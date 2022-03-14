/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase que contiene la logica para el trigger de LiveChatTranscript

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                            Descripción
----------  ----------   ----------------------------  ------------------------------------------
    1.0     17/11/2017   Juan David Uribe Ruiz (JDUR)  Creación Clase.
************************************************************************************************/ 
public without sharing class RF2_LiveChatTranscript_cls {
    
    public void procesarTranscripcionAfterInsert(list<LiveChatTranscript> lstNew){
        set<String> setChatKey;
        list<RF2_EncuestasCasos__c> lstEncuestas;
        list<RF2_EncuestasCasos__c> lstEncuestasActualizar;
        map<String, RF2_EncuestasCasos__c> mapEncuestasCasos;
        RF2_EncuestasCasos__c objEncuestasCasosAux;
        
        system.debug('=====>>>> Entro a RF2_LiveChatTranscript_cls');
        
        setChatKey = new set<String>();
        //Se obtienen todos los ChatKey de las transcripciones
        for(LiveChatTranscript objLiveChatTranscript : lstNew){
            setChatKey.add(objLiveChatTranscript.ChatKey);
        }
        
        //Se consultan las encuestas que esten asociadas con los ChatKey que estan en el trigger
        lstEncuestas = [SELECT Id, RF2_Caso__c, RF2_ChatKey__c, RF2_TranscripcionLiveChat__c FROM RF2_EncuestasCasos__c WHERE RF2_ChatKey__c IN :setChatKey];
        system.debug('=====>>>> lstEncuestas: ' + lstEncuestas);
        
        //Separamos las encuentas en un map para accederlos mas facil
        mapEncuestasCasos = new map<String, RF2_EncuestasCasos__c>();
        for(RF2_EncuestasCasos__c objEncuestasCasos : lstEncuestas){
            mapEncuestasCasos.put(objEncuestasCasos.RF2_ChatKey__c, objEncuestasCasos);
        }
        
        //Recorremos el listado de transcripciones para validar si alguna encuesta asociada al map no 
        //tiene asociado un caso y de este modo asociar el caso de la transcripcion a la encuesta
        lstEncuestasActualizar = new list<RF2_EncuestasCasos__c>();
        for(LiveChatTranscript objLiveChatTranscript : lstNew){
            if(mapEncuestasCasos.containsKey(objLiveChatTranscript.ChatKey)){
                objEncuestasCasosAux = mapEncuestasCasos.get(objLiveChatTranscript.ChatKey);
                if(objEncuestasCasosAux.RF2_Caso__c == null || objEncuestasCasosAux.RF2_TranscripcionLiveChat__c == null){
                    system.debug('=====>>>> Va a asignar caso de la Transcripcion');
                    objEncuestasCasosAux.RF2_Caso__c = objLiveChatTranscript.CaseId;
                    objEncuestasCasosAux.RF2_TranscripcionLiveChat__c = objLiveChatTranscript.Id;
                    lstEncuestasActualizar.add(objEncuestasCasosAux);
                } else{
                    system.debug('=====>>>> La encuesta ya tiene asignado un caso o una transcripcion');
                }
            }
        }
        
        //Se actualizan las Encuestas
        if(!lstEncuestasActualizar.isEmpty()){
            update lstEncuestasActualizar;
        }
    }
    
}