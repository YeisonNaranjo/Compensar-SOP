/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce RF2_BotonCierreCasoGIE_pag
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-29      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  2.0     2018-24-04      Carlos villalba    (CAV)        NOLA-3719
* @version	3.0		2021-09-03		Yeison Naranjo (YSN)			NOLA-00027024
* @version	4.0		2021-10-19		Yeison Naranjo (YSN)			NOLA-00028946
*************************************************************************************************************/

public class RF2_BotonCierreCasoGIE_ctr {
    
    public List<SelectOption> lstValores {get; set;}
    public String valorTipoDoc {get; set;}
    public Boolean blnError {get; set;}
    public String mensajeError {get; set;}  
    public Boolean blnTransaccion {get; set;}
    public String mensajeTransaccion {get; set;}
    public Boolean lightning {get; set;}    
    public Boolean salesforce1 {get; set;}  
    public Case objCaso {get; set;}
    public boolean isPca {get; set;}

    /**
     * Constructor de la clase
     * @param caseToAssing [description]
     */
    public RF2_BotonCierreCasoGIE_ctr(Apexpages.Standardcontroller objStandardController) {
        system.debug('tema - '+UserInfo.getUiTheme());
        if(UserInfo.getUiTheme() == 'Theme4d'){
            lightning = true;
        } else if(UserInfo.getUiTheme() == 'Theme4t'){
            salesforce1 = true;
        }
        String prefijoWeb = Label.RF2_PreNombreArchivoWeb+'%';
        system.debug('prefijoWeb:::'+prefijoWeb);
        String strId = (String) objStandardController.getRecord().Id;

        //List<Case> lstCaso = new List<Case>([SELECT Id, RF2_CorreoElectronicoRespuesta__c, RF2_TipoCierre__c, RF2_ComentarioCierre__c, RF2_EsGIE__c, Status, RF2_Anonimo__c, Contact.Email, Account.COM_CorreoElectronico__c, CaseNumber, RF2_MedioRespuesta__c, ContactId, RF2_CorreoElectronicoHuerfano__c, AccountId, (Select Id, Name from Attachments WHERE NOT Name LIKE :prefijoWeb) FROM Case WHERE Id =:strId]);
        List<Case> lstCaso = new List<Case>([SELECT Id, RF2_CorreoElectronicoRespuesta__c, 
                                                RF2_TipoCierre__c, RF2_ComentarioCierre__c, 
                                                RF2_EsGIE__c, Status, RF2_Anonimo__c, 
                                                Contact.Email, 
                                                Account.COM_CorreoElectronico__c, 
                                                CaseNumber, RF2_MedioRespuesta__c, 
                                                ContactId, RF2_CorreoElectronicoHuerfano__c,
                                                AccountId, RF2_EsPCA__c,RF2_EsPCE__c, RF2_EsPOI__c,RL2_EsPSB__c//,
                                                //(Select Id, Name from Attachments WHERE NOT Name LIKE :prefijoWeb) 
                                            FROM Case WHERE Id =:strId]);
        
        List<ContentDocumentLink> lstCDLink = new List<ContentDocumentLink>();
        Set<Id> resultIds = new Set<Id>();
        for(ContentDocumentLink objCDL : [SELECT Id,ContentDocument.LatestPublishedVersionId 
                                            FROM ContentDocumentLink 
                                           WHERE LinkedEntityId =: lstCaso.get(0).Id 
                                             AND (NOT ContentDocument.Title 
                                            LIKE :prefijoWeb)]){
            resultIds.add(objCDL.ContentDocument.LatestPublishedVersionId);
        }

        if(lstCaso.get(0).RF2_EsGIE__c){
            if(!lstCaso.isEmpty() && lstCaso.get(0).Status == Label.RF2_EstadoCerradoCaso_lbl){
                blnError = true;
                mensajeError = 'No se puede crear el documento. El caso ya se encuentra cerrado.';
            } else {
                if(lstCaso.isEmpty() || lstCaso.get(0).Status != Label.RF2_EstadoPendientePDFGIE_lbl || !lstCaso.get(0).RF2_EsGIE__c || lstCaso.get(0).RF2_ComentarioCierre__c == null || lstCaso.get(0).RF2_MedioRespuesta__c == null || lstCaso.get(0).RF2_TipoCierre__c != Label.RF2_TipoCierreExitosoGIE_lbl){
                    blnError = true;
                    mensajeError = 'No se puede crear el documento. El Caso no es de tipo GIE, o no tiene medio de respuesta o no tiene comentarios o el cierre no es de tipo '+Label.RF2_TipoCierreExitosoGIE_lbl+' o no esta en el estado '+Label.RF2_EstadoPendientePDFGIE_lbl;
                } else {
                    system.debug('Llamando a visualizar GIE');
                    objCaso = lstCaso.get(0);
                }
            }
        lstValores = new List<SelectOption>();
        lstValores.add(new SelectOption(Label.RF2_CartaConFirma,'Carta Con Firma Gestor de GIE'));
        lstValores.add(new SelectOption('SinFirma','Carta Sin Firma'));
        }else{
            lstValores = new List<SelectOption>();
            lstValores.add(new SelectOption('Visualizar carta respuesta','Visualizar carta respuesta'));
            system.debug('Llamando a visualizar PCA');
            objCaso = lstCaso.get(0);
            isPca = true;
        }
    }
    /**
     * [método para crear el pdf de respuesta al caso, adjuntarlo al registro del caso y enviarlo por correo]
     * @param  [description]
     */
    public void enviarPDF(){
        system.debug('------> Entra a enviar enviarPDF');
        blnTransaccion = true;
        //List<Attachment> lstAtt = new List<Attachment>();
        if(objCaso != null){
            String strId = objCaso.Id;
            /*lstAtt = objCaso.Attachments;
            Set<Id> resultIds = new Set<Id>();
            if(lstAtt != null){
                for(Attachment obj : lstAtt){
                    resultIds.add(obj.Id);  
                }
            }*/
            String prefijoWeb                = Label.RF2_PreNombreArchivoWeb+'%';
            List<Contact> lstContactoAnonimo = [  SELECT Id, AccountId 
                                                    FROM Contact 
                                                   WHERE COM_TipoIdentificacion__c      = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl 
                                                     AND COM_Numeroidentificacion__c    = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl 
                                                   LIMIT 1];
            Case objCaso =  [SELECT Id, RF2_EsPCA__c, RF2_EsGIE__c, RF2_EsPCE__c, RL2_EsPSB__c,
                                    RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, 
                                    RF2_CorreoElectronicoRespuesta__c, RF2_EsPOI__c/* Inicio 4.0 */
                             , COM_Encuesta__c, RF2_TipoSolicitud__c, Parentid, Accountid, Contactid, RF2_ServicioGIE__c, COM_Id_Encuesta__c
                             /* Fin 4.0 */
                               FROM Case 
                              WHERE Id =:strId];
            
            /*Inicio 24.0*/ 
            String idEncuesta = '';
            /*Fin 24.0*/
            
            List<ContentDocumentLink> lstCDLink = new List<ContentDocumentLink>();
            Set<Id> resultIds = new Set<Id>();
            for(ContentDocumentLink objCDL : [SELECT Id,ContentDocument.LatestPublishedVersionId 
                                                FROM ContentDocumentLink 
                                               WHERE LinkedEntityId =: objCaso.Id 
                                                 AND (NOT ContentDocument.Title LIKE :prefijoWeb)]){
                resultIds.add(objCDL.ContentDocument.LatestPublishedVersionId);
            }
            try{
                /*Inicio 00264721*/
                PageReference prfPDF;                
                if(objCaso.RF2_EsPOI__c){
                    prfPDF = new PageReference('/apex/RF2_CartaCierreCasoProceso_pag');
                    prfPDF.getParameters().put('idCaso', objCaso.Id);
                }else if(objCaso.RL2_EsPSB__c){
                    prfPDF = new PageReference('/apex/RL2_CartaCIerreCasoPSB_pag');
                }else{
                    prfPDF = new PageReference('/apex/RF2_CartaCierreCasoGIE_pag');
                }
                /*Fin 00264721*/
                prfPDF.getParameters().put('idCaso', objCaso.Id);
                prfPDF.getParameters().put('tipoDoc', valorTipoDoc);
                Blob blbPDF;
                if(Test.isRunningTest()){
                    blbPDF = Blob.valueOf('hola');
                }else{
                    blbPDF = prfPDF.getContent();
                }
                String prefijo = objCaso.RF2_EsPOI__c?'POI':(objCaso.RL2_EsPSB__c?'PSB':'GIE');
                //Adjuntar PDF al registro
                ContentVersion objContentVersion    =   new ContentVersion();
                objContentVersion.VersionData       =   blbPDF;
                objContentVersion.Title             =   prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
                objContentVersion.PathOnClient      =   prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
                insert objContentVersion;

                ContentVersion cv                   =   [SELECT Id,ContentDocumentId 
                                                           FROM ContentVersion 
                                                          WHERE Id =: objContentVersion.Id];
                ContentDocumentLink contentlink     =   new ContentDocumentLink();
                contentlink.LinkedEntityId          =   objCaso.id;
                contentlink.ShareType               =   'V';
                contentlink.ContentDocumentId       =   cv.ContentDocumentId;
                contentlink.Visibility              =   'AllUsers'; 
                insert contentlink;
                resultIds.add(cv.Id);                 
                
                /*Attachment attach = new Attachment();
                attach.Body = blbPDF;
                attach.Name = 'GIE'+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
                attach.IsPrivate = false;
                attach.ParentId = objCaso.Id;
                insert attach;
                resultIds.add(attach.Id);*/

                // verificar que la cuenta no sea anónima
                if(objCaso.RF2_MedioRespuesta__c == Label.RF2_CorreoElectronico_lbl){
                    system.debug('------> Entra a enviar correo');
                    if(objCaso.RF2_Anonimo__c){
                        mensajeTransaccion          = 'Documento generado. Refresque la pantalla del caso para consultar en archivos adjuntos el pdf generado';
                        objCaso.RF2_EnviarOnBase__c = true;
                        objCaso.Status              = Label.RF2_EstadoCerradoCaso_lbl; 
                        update objCaso;
                    } else {
                        if(String.isNotBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                            Contact contactoAnonimo     = [SELECT Id, AccountId 
                                                             FROM Contact 
                                                            WHERE COM_TipoIdentificacion__c     =: Label.RF2_TipoIdentificacionClienteAnonimo_lbl 
                                                              AND COM_Numeroidentificacion__c   =: Label.RF2_NumeroIdentificacionClienteAnonimo_lbl 
                                                            LIMIT 1];
                            /* Inicio 4.0 */
                            idEncuesta = COM_EnviarEncuesta_cls.crearEncuesta(objCaso);
                            System.debug('idEncuesta: ' + idEncuesta);
                            if(idEncuesta != '')
                            {
                                objCaso.COM_Id_Encuesta__c = idEncuesta;
                                update objCaso;
                            } 
                            /*Fin 4.0*/  
                            
                            COM_ConsultarEnvioDocumentos_cls.enviarDocumentos2(Label.RF2_IdProcRespuestaCasos_lbl, new Set<String>{objCaso.RF2_CorreoElectronicoRespuesta__c}, resultIds, 
                            /* Inicio 3.0 */                                                   
                            '', '', 'RF2_Cierrecaso2', contactoAnonimo.Id, objCaso.Id, true, cv.Id);
                            //'', '', 'RF2_Cierrecaso_GIE', contactoAnonimo.Id, objCaso.Id, true, cv.Id);
                            /* Inicio 3.0 */                                                   
                            mensajeTransaccion          = 'Documento generado y enviado al correo '+objCaso.RF2_CorreoElectronicoRespuesta__c+'. Refresque la pantalla del caso para consultar en archivos adjuntos el pdf generado';
                            objCaso.RF2_EnviarOnBase__c = true;
                            objCaso.Status              = Label.RF2_EstadoCerradoCaso_lbl;
                            update objCaso;
                        } else {
                            ContentDocument objContentDocument = new ContentDocument(Id = cv.ContentDocumentId);
                            delete objContentDocument;
                            blnError                = true;
                            mensajeError            = 'No se puede enviar el documento. El caso no tiene un correo asignado.';
                        }
                    }
                } else {
                    objCaso.RF2_EnviarOnBase__c     = true;
                    objCaso.Status                  = Label.RF2_EstadoCerradoCaso_lbl; 
                    update objCaso;
                }
            }catch(Exception e){
                mensajeTransaccion = 'No se pudo procesar el documento. '+e.getMessage();
            }
        } else {
            blnError = true;
            mensajeError = 'No se puede crear el documento. El Caso o no es de tipo GIE, o no tiene comentarios o no esta en el estado '+Label.RF2_EstadoPendientePDFGIE_lbl;
        }    
    }
    /**
     * [método para ver el pdf de respuesta al caso]
     * @param 
     */
     public PageReference verPdf(){
        PageReference prfPDF;
        /*Inicio 00264721*/
        if(objCaso.RF2_EsPOI__c){
            System.debug('Entro 1');
			prfPDF = new PageReference('/apex/RF2_CartaCierreCasoProceso_pag');
            prfPDF.getParameters().put('idCaso', objCaso.Id);
        }else 
        /*Fin 00264721*/
        if(objCaso.RF2_EsGIE__c){
            System.debug('Entro 2');
            prfPDF = new PageReference('/apex/RF2_CartaCierreCasoGIE_pag');
            prfPDF.getParameters().put('idCaso', objCaso.Id);
            prfPDF.getParameters().put('tipoDoc', valorTipoDoc);
        }else if(objCaso.RL2_EsPSB__c){
            System.debug('Entro 3');
            prfPDF = new PageReference('/apex/RL2_CartaCIerreCasoPSB_pag');
            prfPDF.getParameters().put('idCase', objCaso.Id);
        }else{
            System.debug('Entro 4');
            prfPDF = new PageReference('/apex/RF2_CartaCierreCaso_pag');
            prfPDF.getParameters().put('idCase', objCaso.Id);
        }
        prfPDF.setredirect(true);
        return prfPDF;
     }

}