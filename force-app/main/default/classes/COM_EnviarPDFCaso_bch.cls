/** Globant Colombia
* 	@author 			Yeison Naranjo (YN)
* 	Project:			Compensar
* 	Description:		Clase batch para enviar PDF no generados
*					
* 	Changes (Version)
* 	-------------------------------------
*	No.		Date			Author					Description
*	-----	----------		--------------------	---------------
* 	1.0		03/11/2021		Yeison Naranjo (YN)		Clase para enviar PDFs no generados **/

global class COM_EnviarPDFCaso_bch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query ='SELECT Id, RF2_EsPCA__c, RF2_EsGIE__c, RF2_EsPCE__c, RL2_EsPSB__c, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, RF2_EsPOI__c, COM_Encuesta__c, RF2_TipoSolicitud__c, Parentid, Accountid, Contactid, RF2_ServicioGIE__c, COM_Id_Encuesta__c FROM Case WHERE Crear_PDF__c = true limit 10';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope){
        Set<Id> resultIds = new Set<Id>();
        List<Contact> lstContactoAnonimo = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numeroidentificacion__c = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl LIMIT 1];
        
        For(Case objCaso : scope){
            PageReference prfPDF;
            resultIds.Clear();
            if(objCaso.RF2_EsPOI__c){
                prfPDF = new PageReference('/apex/RF2_CartaCierreCasoProceso_pag');
                prfPDF.getParameters().put('idCaso', objCaso.Id);
            }else{
                if(objCaso.RF2_EsPCE__c){
                    prfPDF = new PageReference('/apex/RF2_CartaCierreCaso_pag');
                    prfPDF.getParameters().put('idCase', objCaso.Id);
                } else if(objCaso.RL2_EsPSB__c) {
                    prfPDF = new PageReference('/apex/RL2_CartaCIerreCasoPSB_pag');
                    prfPDF.getParameters().put('idCase', objCaso.Id);
                } else if(objCaso.RF2_EsPCA__c || objCaso.RF2_EsGIE__c) {
                    prfPDF = new PageReference('/apex/RF2_CartaCierreCasoGIE_pag');
                    prfPDF.getParameters().put('idCaso', objCaso.Id);
                }
            }  
            
            Blob blbPDF;
            if(Test.isRunningTest()) {
                blbPDF = blob.valueOf('Unit.Test');
            } else {
                blbPDF = prfPDF.getContent();   
            }
            
            String prefijo = objCaso.RF2_EsPCE__c?'PCE':(objCaso.RF2_EsPCA__c?'PCA':(objCaso.RF2_EsGIE__c?'GIE':(objCaso.RL2_EsPSB__c?'PSB':'pce')));
                
            ContentVersion objContentVersion = new ContentVersion();
            objContentVersion.VersionData = blbPDF;
            objContentVersion.Title = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
            objContentVersion.PathOnClient = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
            insert objContentVersion;
            
            ContentVersion cv = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id =: objContentVersion.Id];
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=objCaso.id;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=cv.ContentDocumentId;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;
            
            resultIds.add(cv.Id); 
            
            String idEncuesta = '';
            
            system.debug('objCaso.RF2_MedioRespuesta__c: ' + objCaso.RF2_MedioRespuesta__c);
            system.debug('objCaso.RF2_Anonimo__c: ' + objCaso.RF2_Anonimo__c);
            if(objCaso.RF2_MedioRespuesta__c == Label.RF2_CorreoElectronico_lbl && !objCaso.RF2_Anonimo__c){
                system.debug('------> Entra a enviar correo');
                if(String.isNotBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                    if( lstContactoAnonimo != null && !lstContactoAnonimo.isEmpty())
                    {
                        if(objCaso.RF2_TipoSolicitud__c == 'Queja' || objCaso.RF2_TipoSolicitud__c == 'Solicitud PCE'){
                            idEncuesta = COM_EnviarEncuesta_cls.crearEncuesta(objCaso);
                            System.debug('idEncuesta: ' + idEncuesta);
                            if(idEncuesta != '')
                            {
                                COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeUpdate');
                                COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
                                objCaso.Crear_PDF__c = false;
                                objCaso.COM_Id_Encuesta__c = idEncuesta;
                                update objCaso;
                            } 
                            COM_ConsultarEnvioDocumentos_cls.enviarDocumentos2(Label.RF2_IdProcRespuestaCasos_lbl, new Set<String>{objCaso.RF2_CorreoElectronicoRespuesta__c}, resultIds, 
                                                                               '', '', 'RF2_Cierrecaso2', lstContactoAnonimo.get(0).Id, objCaso.Id, true, cv.Id);
                            
                        } Else {
                            COM_ConsultarEnvioDocumentos_cls.enviarDocumentos2(Label.RF2_IdProcRespuestaCasos_lbl, new Set<String>{objCaso.RF2_CorreoElectronicoRespuesta__c}, resultIds, 
                                                                               '', '', 'RF2_Cierrecaso_GIE', lstContactoAnonimo.get(0).Id, objCaso.Id, true, cv.Id);
                        }            
                        system.debug('Documento generado y enviado al correo '+objCaso.RF2_CorreoElectronicoRespuesta__c);
                    }
                    else{
                        system.debug('---> No existe contacto anónimo.');
                    }
                } else {
                    system.debug('---> El caso no tiene un correo asignado, no se envía correo.');
                }
            } 
        }
    }   
    
    global void finish(Database.BatchableContext bc){
        List<Case> lstCasetoProcess = [SELECT Id, RF2_EsPCA__c, RF2_EsGIE__c, RF2_EsPCE__c, RL2_EsPSB__c, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, RF2_EsPOI__c, COM_Encuesta__c, RF2_TipoSolicitud__c, Parentid, Accountid, Contactid, RF2_ServicioGIE__c, COM_Id_Encuesta__c FROM Case WHERE Crear_PDF__c = true limit 1];
        
        If(!lstCasetoProcess.isEmpty()){
            COM_EnviarPDFCaso_bch b = new COM_EnviarPDFCaso_bch();
            database.executeBatch(b, 10);  
        }        
    }
}