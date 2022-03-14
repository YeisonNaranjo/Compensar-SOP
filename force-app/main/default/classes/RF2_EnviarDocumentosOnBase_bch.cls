/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Batch para enviar los documentos a OnBase
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-21      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.1     2018-09-12      Stifen Panche Gutierrez (SPG)   Actualización casos sin adjuntos - Error 201 queries.
* @version  1.2     2019-09-26      Paula Bohórquez (PB)   			Migración Lightning - Se reemplazan Attachments por ContentDocuments
* @version  2.0     2020-12-23		Santiago Contreras (SC) 		Se realiza un Ajuste en el batch y en metodo COM_CrearDocumentoOnBase_ws
* @version  3.0     2021-02-03		Yeison Naranjo (YN) 			Se ajusta la consulta para no incluir documentos ya enviados a OnBase
* @version  3.1     2021-03-03		Yeison Naranjo (YN) 			Se incluye consulta al nivel superior para una unica ejecución.
* @version 	4.0		2021-04-11		Yeison Naranjo (YN)				Se ajusta para no envio de archivos grandes.
**************************************************************************************************************/

global class RF2_EnviarDocumentosOnBase_bch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    String query;
    static Set<Id> setIdsCaso;
        
    
    global RF2_EnviarDocumentosOnBase_bch() {
        system.debug('Entra a enviar Documentos a OnBase ');
        
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        //query = 'SELECT Id, RF2_EsGIE__c, RF2_EsPCA__c, RF2_EsPCE__c, RF2_NumeroRadicadoExterno__c, (Select Id FROM Attachments WHERE Description != \'Enviado a OnBase\'AND BodyLength < 2750000) FROM Case WHERE RF2_EnviarOnBase__c = true';
        
        query = 'SELECT Id, RF2_EsGIE__c, RF2_EsPCA__c, RF2_EsPCE__c, RF2_NumeroRadicadoExterno__c FROM Case WHERE RF2_EnviarOnBase__c = true';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Case> lstCase) {
        Set<Id> setIds = new Set<Id>();
        for(Case objCaso : lstCase){
            setIds.add(objCaso.Id);
        }
        system.debug('los casos ===> '+lstCase.size());
        system.debug('setIds ===> '+setIds);
        
        List<Case> lstCaseUpdate = new List<Case>();
        //List<Attachment> lstAttachmentUpdate = new List<Attachment>();
        //PB AVX 26-09-2019 Migración Lightning 
        List<ContentDocument> lstCDUpdate = new List<ContentDocument>();
        Map<String, List<ContentDocumentLink>> mapIdObjectxlstCDL = new Map<String, List<ContentDocumentLink>>();

        /* Inicio 3.0 */
        //for(ContentDocumentLink cdl : [SELECT ContentDocumentId,ContentDocument.Description,ContentDocument.LatestPublishedVersionId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: setIds]){
        for(ContentDocumentLink cdl : [SELECT ContentDocumentId,ContentDocument.Description,ContentDocument.LatestPublishedVersionId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: setIds And ContentDocument.Description != 'Enviado a OnBase']){
            /* Fin 3.0 */
            system.debug('cdl-->'+cdl);
            if(mapIdObjectxlstCDL.keySet().contains(cdl.LinkedEntityId)){
                mapIdObjectxlstCDL.get(cdl.LinkedEntityId).add(cdl);
            }
            else{
                List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>();
                lstCDL.add(cdl);
                mapIdObjectxlstCDL.put(cdl.LinkedEntityId,lstCDL);
            }                        
        }
		system.debug('mapIdObjectxlstCDL -> '+mapIdObjectxlstCDL);
        Set<String> setTipologias = new Set<String>{Label.RF2_TipoCartaRespuesta, Label.RF2_RespuestaCasos};
        List<COM_ConfiguracionEnvioDocsM__mdt> lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c, developerName  FROM COM_ConfiguracionEnvioDocsM__mdt WHERE COM_DocumentTypeName__c IN :setTipologias];
        system.debug('lstConfig -> '+lstConfig);
        /* Inicio 3.1 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 3.1 */
        Map<String, COM_ConfiguracionEnvioDocsM__mdt> mapConfig = new Map<String, COM_ConfiguracionEnvioDocsM__mdt>();
        for(COM_ConfiguracionEnvioDocsM__mdt config : lstConfig){
            mapConfig.put(config.COM_DocumentTypeName__c, config); //2.0 Antes se pasaba el Id de config para que se hiciera la consulta, ahora se pasa el objeto para evitar las consultas ciclicas
        }
        List<COM_LogTransacciones__c> lstTransacciones = new List<COM_LogTransacciones__c>();
        if(!lstConfig.isEmpty()){
            // 2.0 Start, Agregamos los Ids de las posibles consultas, y se realizan antes de los ciclos for, se reduce la cantidad de consultas.
            List<String> cdlIDs = new List<String>();
            list<ContentVersion> lstContentVersion;
            /* Inicio 4.0 */
            list<ContentVersion> lstContentVersionBig;
            Map<Id, String> mapDocxCaso = New Map<Id, String>();
            Map<String, Integer> mapCasoCountDoc = New Map<String, Integer>();
            Map<String, Integer> mapCasoSizeDoc = New Map<String, Integer>();
            /* Fin 4.0 */
            
            Map<String, ContentVersion> lstContentVersionMap = new Map<String, ContentVersion>();
            for(Case caso : lstCase){
                if(mapIdObjectxlstCDL.keySet().contains(caso.Id)&&!mapIdObjectxlstCDL.get(caso.Id).isEmpty()){
                    for(ContentDocumentLink cdl : mapIdObjectxlstCDL.get(caso.Id)) {
                        cdlIds.add(cdl.ContentDocument.LatestPublishedVersionId);
                        /* Inicio 4.0 */
                        mapDocxCaso.put(cdl.ContentDocument.LatestPublishedVersionId, caso.Id);
                        /* Fin 4.0 */
                    }
                }
            }
            /* Inicio 4.0 */
            Integer intMaxHeadSize = Limits.getLimitHeapSize() - Integer.valueOf(Label.RF2_Dsicount_ApexHeadSizeLimit);
            System.debug('intMaxHeadSize: ' + intMaxHeadSize);
            //lstContentVersion = [SELECT Id, FileType,Title,VersionData,ContentDocumentId FROM ContentVersion WHERE Id IN :cdlIds];
            //lstContentVersion = [SELECT Id, FileType,Title, VersionData, ContentDocumentId, ContentSize FROM ContentVersion WHERE Id IN :cdlIds and ContentSize <: intMaxHeadSize order by CreatedDate ASC];
            //if(!lstContentVersion.isEmpty()){
            /* Fin 4.0 */
            Integer intCountSize = 0;
            for(ContentVersion cv : [SELECT Id, FileType,Title, VersionData, ContentDocumentId, ContentSize FROM ContentVersion WHERE Id IN :cdlIds and ContentSize <: intMaxHeadSize order by CreatedDate ASC]){
                /* Inicio 4.0 */
                If(!mapCasoSizeDoc.containsKey(mapDocxCaso.get(cv.Id))){
                    mapCasoSizeDoc.put(mapDocxCaso.get(cv.Id),cv.ContentSize);
                    /* Fin 4.0 */
                    lstContentVersionMap.put(cv.id, cv);
                    /* Inicio 4.0 */
                } else{
                    Integer currentIntSize = mapCasoSizeDoc.get(mapDocxCaso.get(cv.Id)) + cv.ContentSize;
                    If(currentIntSize >= intMaxHeadSize){
                        mapCasoSizeDoc.put(mapDocxCaso.get(cv.Id),currentIntSize);
                        
                        If(!mapCasoCountDoc.containsKey(mapDocxCaso.get(cv.Id))){
                            mapCasoCountDoc.put(mapDocxCaso.get(cv.Id),1);
                        } else{
                            Integer currentIntNoDoc = mapCasoCountDoc.get(mapDocxCaso.get(cv.Id)) + 1;
                            mapCasoCountDoc.put(mapDocxCaso.get(cv.Id),currentIntNoDoc);
                        } 
                    } else {
                        mapCasoSizeDoc.put(mapDocxCaso.get(cv.Id),currentIntSize);
                        lstContentVersionMap.put(cv.id, cv);
                    }
                }   
                /* Fin 4.0 */
            }
            //} 4.0
            
            /* Inicio 4.0*/
            //lstContentVersionBig = [SELECT Id FROM ContentVersion WHERE Id IN :cdlIds and ContentSize >=: intMaxHeadSize order by CreatedDate ASC];
            //if(!lstContentVersionBig.isEmpty()){
                for(ContentVersion cv : [SELECT Id FROM ContentVersion WHERE Id IN :cdlIds and ContentSize >=: intMaxHeadSize order by CreatedDate ASC]){
                    If(!mapCasoCountDoc.containsKey(mapDocxCaso.get(cv.Id))){
                        mapCasoCountDoc.put(mapDocxCaso.get(cv.Id),1);
                    } else{
                        Integer currentInt = mapCasoCountDoc.get(mapDocxCaso.get(cv.Id)) + 1;
                        mapCasoCountDoc.put(mapDocxCaso.get(cv.Id),currentInt);
                    }
                    System.debug('mapCasoCountDoc: ' + mapCasoCountDoc);
                }
            //}
            /* Fin 4.0 */
            System.debug('getHeapSize(): ' + Limits.getHeapSize());
            //ContentDocumentLink objContentDocumentLink = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId  =: objContentVersion.ContentDocumentId LIMIT 1];
            // 2.0 End
            for(Case caso : lstCase){
                system.debug('caso -> '+caso);
                COM_CrearDocumentoOnBase_ws.DTORespuesta transaccion = new COM_CrearDocumentoOnBase_ws.DTORespuesta();
                if(mapIdObjectxlstCDL.keySet().contains(caso.Id)&&!mapIdObjectxlstCDL.get(caso.Id).isEmpty()){
                    for(ContentDocumentLink cdl : mapIdObjectxlstCDL.get(caso.Id)) {
                        system.debug('el adjunto ===> ' + cdl.LinkedEntityId.getSObjectType());
                        try{
                            /* Inicio 4.0 */
                            if(lstContentVersionMap.get(cdl.ContentDocument.LatestPublishedVersionId) != Null){
                            /* Fin 4.0 */
                                if(String.isNotBlank(caso.RF2_NumeroRadicadoExterno__c)){//si viene de correspondencia todo se envía a WFO
                                    /* Inicio 3.1 */
                                    //transaccion = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(lstContentVersionMap.get(cdl.ContentDocument.LatestPublishedVersionId), mapConfig.get(Label.RF2_TipoCartaRespuesta), caso.Id);//WFO //2.0 Se pasan los valores completos para reducir consultas SOQL
                                    transaccion = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(lstContentVersionMap.get(cdl.ContentDocument.LatestPublishedVersionId), mapConfig.get(Label.RF2_TipoCartaRespuesta), caso.Id, user_Identificacion);//WFO //2.0 Se pasan los valores completos para reducir consultas SOQL
                                    /* Fin 3.1 */
                                } else {//todo lo demás va para oys
                                    /* Inicio 3.1 */
                                    //transaccion = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(lstContentVersionMap.get(cdl.ContentDocument.LatestPublishedVersionId), mapConfig.get(Label.RF2_RespuestaCasos), caso.Id);//OYS //2.0 Se pasan los valores completos para reducir consultas SOQL
                                    transaccion = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(lstContentVersionMap.get(cdl.ContentDocument.LatestPublishedVersionId), mapConfig.get(Label.RF2_RespuestaCasos), caso.Id, user_Identificacion);//WFO //2.0 Se pasan los valores completos para reducir consultas SOQL
                                    /* Fin 3.1 */                                    
                                }   
                                system.debug('----> Se pudo enviar el documento. ');
                            /* Inicio 4.0 */
                            } else{
                                transaccion.resultado = true;
                                system.debug('----> No se pudo enviar el documento: Documento inexistente o de un tamaño superior al limite.');
                            }                           
                            /* Fin 4.0 */
                        } catch(Exception e){
                            transaccion.resultado = false;
                            system.debug('----> No se pudo enviar el documento. '+e.getMessage());
                        }
                        if(transaccion.transaccion != null){
                            lstTransacciones.add(transaccion.transaccion);
                            String strDesc;
                            if(transaccion.resultado){
                                lstCDUpdate.add(new ContentDocument(Id = cdl.ContentDocumentId,
                                                             Description = 'Enviado a OnBase'));
                                //att.Description = 'Enviado a OnBase';
                            } else {
                                
                                strDesc = transaccion.transaccion.COM_Response__c!=null?transaccion.transaccion.COM_Response__c.left(500):'';
                            	lstCDUpdate.add(new ContentDocument(Id = cdl.ContentDocumentId,
                                                             Description = strDesc));
                            
                            }
                            //lstAttachmentUpdate.add(att);
                        }
                        
                    } 
                    if(transaccion.resultado){
                        caso.RF2_EnviarOnBase__c = false;
                        If(mapCasoCountDoc.containsKey(caso.Id)){
                            caso.COM_Documentos_no_enviados__c = mapCasoCountDoc.get(caso.Id);
                        }
                        lstCaseUpdate.add(caso);
                    }
                } else {
                    caso.RF2_EnviarOnBase__c = false;
                    /*Inicio 1.1*/
                   
                    lstCaseUpdate.add(caso);
                    /*Fin 1.1*/
                }
                
            }
            try {
                RF2_Case_cls.stopTrigger();
                    //update lstCase;
                    /*Inicio 1.1*/
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterInsert');
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeUpdate');
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeInsert');
                    /*Fin 1.1*/
                   update lstCaseUpdate;
                RF2_Case_cls.startTrigger();
            } catch(Exception e) {
                System.debug('Error actualizando los registros. '+e.getMessage());
            }
            try {
                insert lstTransacciones;
            } catch(Exception e) {
                System.debug('Error insertando los logs de transacción. '+e.getMessage());
            }
             try {
                update lstCDUpdate;
            } catch(Exception e) {
                System.debug('Error actualizando los archivos. '+e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

}