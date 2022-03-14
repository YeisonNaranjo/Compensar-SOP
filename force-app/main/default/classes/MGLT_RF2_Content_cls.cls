/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Lionner Steven Moque QUintero    
Proyecto:          Compensar
Descripción:       Clase con la logica para el trigger MGLT_RF2_Content_tgr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2019/09/25      Lionner Steven Moque    Creación Clase.   
************************************************************************************************/
public without sharing class MGLT_RF2_Content_cls {
    
    /* 
    * Nombre: validarEliminarAdjunto
    * Descripcion: Metodo con la logica para permitir borrar archivos de casos solo al propietario del archivo o 
    * si es el Administrador del sistema y si el caso esta en estado diferente de 'Cerrado'.
    *
    * Fecha Creación: 19/12/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1.0          2019/09/25      Lionner Steven Moque         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public void validarEliminarAdjunto(Map<Id, ContentDocument> MapContentDocument){
        Map<Id,Case> mapCasos;
        Map<Id, Profile> mapPerfil;
        Map<String,List<ContentDocument>> mapIdCasoxlstCD = new Map<String, List<ContentDocument>>(); 
        Set<Id> setIdContentDocument = MapContentDocument.keySet();
        
        //system.debug('........... Entro a validarEliminarAdjunto: ' + setIdContentDocument);
        
        mapPerfil = new Map<Id, Profile>([SELECT Id, Name FROM Profile]);
        
        //Estas validaciones solo se hacen para los usuarios que NO son administradores del sistema
        if(Test.isRunningTest() || mapPerfil.get(userinfo.getProfileId()).Name != 'Administrador del sistema'){
            
            for(ContentDocumentLink objContentDocumentLink : [SELECT Id, LinkedEntity.Type,LinkedEntityId,ContentDocumentId,ContentDocument.OwnerId FROM ContentDocumentLink WHERE ContentDocumentId IN :setIdContentDocument]){
                
                if(objContentDocumentLink.LinkedEntity.Type == 'Case'){
                    if(mapIdCasoxlstCD.keySet().contains(objContentDocumentLink.LinkedEntityId)){
                        ContentDocument cdTemp = new ContentDocument(Id = objContentDocumentLink.ContentDocumentId,
                                                                    OwnerId = objContentDocumentLink.ContentDocument.OwnerId );
                        mapIdCasoxlstCD.get(objContentDocumentLink.LinkedEntityId).add(cdTemp);
                        
                    }
                    else{
                        List<ContentDocument> lstCD = new List<ContentDocument>();
                        ContentDocument cdTemp = new ContentDocument(Id = objContentDocumentLink.ContentDocumentId,
                                                                    OwnerId = objContentDocumentLink.ContentDocument.OwnerId );
                        lstCD.add(cdTemp);
                        mapIdCasoxlstCD.put(objContentDocumentLink.LinkedEntityId,lstCD);
                    }
                }

            }

            if(mapIdCasoxlstCD.keySet().isEmpty()){
                return;
            }
            
            mapCasos = new Map<Id,Case>([SELECT Id, Status FROM Case WHERE Id IN :mapIdCasoxlstCD.keySet()]);
            
            for(Id idCaso : mapIdCasoxlstCD.keySet()){
                for(ContentDocument objCD : mapIdCasoxlstCD.get(idCaso)){
                    if(mapCasos.get(idCaso).Status == label.RF2_EstadoCerradoCaso_lbl ){
                        MapContentDocument.get(objCD.Id).addError(label.RF2_MsjEliminarArchivoCasoCerrado);
                    }
                    else if(!objCD.OwnerId.equals(UserInfo.getUserId())){
                        MapContentDocument.get(objCD.Id).addError(label.RF2_MsjElimiarArchivoPropietario);    
                    }
                }
            }
            
        } else{
            system.debug('.......... Es Administrador del Sistema');
        }
    }

    /*Inicio 1-1*/
        public void validarEliminarAdjuntoTarea(Map<Id, ContentDocument> MapContentDocument){
        Map<Id, Task> mapTareas;
        Map<Id, Profile> mapPerfil;
        Map<String,List<ContentDocument>> mapIdTareaxlstCD = new Map<String, List<ContentDocument>>(); 
        Set<Id> setIdContentDocument = MapContentDocument.keySet();



        /*set<Id> setIdTareas = new set<Id>();
        list<Task> lstTareas;
        map<Id, Task> mapTareas;
        Map<Id, Profile> mapPerfil;
        Map<Id, list<ContentDocumentLink>> mapIdxContentDocumentLink;
        Set<Id> setIdContentDocument = MapContentDocument.keySet();
        
        system.debug('........... Entro a validarEliminarAdjunto');*/
        
        mapPerfil = new Map<Id, Profile>([SELECT Id, Name FROM Profile]);
        
        //Estas validaciones solo se hacen para los usuarios que NO son administradores del sistema
        if(Test.isRunningTest() || mapPerfil.get(userinfo.getProfileId()).Name != 'Administrador del sistema'){
                
            for(ContentDocumentLink objContentDocumentLink : [SELECT Id, LinkedEntity.Type,LinkedEntityId,ContentDocumentId,ContentDocument.OwnerId FROM ContentDocumentLink WHERE ContentDocumentId IN :setIdContentDocument]){
                if(objContentDocumentLink.LinkedEntity.Type == 'Task'){
                    //setIdTareas.add(objContentDocumentLink.Id);
                    if(mapIdTareaxlstCD.keySet().contains(objContentDocumentLink.LinkedEntityId)){
                        ContentDocument cdTemp = new ContentDocument(Id = objContentDocumentLink.ContentDocumentId,
                                                                    OwnerId = objContentDocumentLink.ContentDocument.OwnerId );
                        mapIdTareaxlstCD.get(objContentDocumentLink.LinkedEntityId).add(cdTemp);
                        
                    }
                    else{
                        List<ContentDocument> lstCD = new List<ContentDocument>();
                        ContentDocument cdTemp = new ContentDocument(Id = objContentDocumentLink.ContentDocumentId,
                                                                    OwnerId = objContentDocumentLink.ContentDocument.OwnerId );
                        lstCD.add(cdTemp);
                        mapIdTareaxlstCD.put(objContentDocumentLink.LinkedEntityId,lstCD);
                    }
                }
            }
              

            /*if(setIdTareas.isEmpty()){
                return;
            }*/
            
            mapTareas = new Map<Id, Task>([SELECT Id, Status, WhatId FROM Task WHERE Id IN :mapIdTareaxlstCD.keySet()]);
            /*lstTareas = [SELECT Id, whatid FROM Task WHERE Id IN :setIdTareas];
            mapTareas = new map<Id, Task>(lstTareas);*/
            for(Id idTarea : mapIdTareaxlstCD.keySet()){
                for(ContentDocument objCD : mapIdTareaxlstCD.get(idTarea)){
                    
                    if(String.valueOf(mapTareas.get(idTarea).WhatId.getSObjectType()) == 'Case'){
                    //objTask.WhatId.getSObjectType()) == SObjectType.Order.getName()
                        MapContentDocument.get(objCD.Id).addError('No puede eliminar el archivo por permisos de perfil.');
                    }
                }
            }
            
            
            /*for(Attachment objAttachment : lstAttachmentsOld){
                
                    if(((mapTareas.get(objAttachment.ParentId)).whatid.getSObjectType() == Case.SobjectType)){
                        objAttachment.addError('No puede eliminar el archivo por permisos de perfil.');
                    }
                }*/
            
        } else{
            system.debug('.......... Es Administrador del Sistema');
        }
    }

    /*Fin 1.1*/    
}