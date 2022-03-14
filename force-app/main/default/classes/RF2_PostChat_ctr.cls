/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Controlador para la pagina RF2_PostChat_pag

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0      10/11/2017     Juan David Uribe Ruiz   Creación Clase.
	2.0      07/10/2019     Paula Bohórquez Alfonso Los métodos se ponen globales para integración con SnapIn.
************************************************************************************************/
global without sharing class RF2_PostChat_ctr {
    
    public String strCaseId {get;set;}
    public String strChatKey {get;set;}
    public String attachedRecords {get;set;}
    
    global RF2_PostChat_ctr(){
        String caseId = null;
        attachedRecords = ApexPages.currentPage().getParameters().get('attachedRecords');
        strChatKey = ApexPages.currentPage().getParameters().get('chatKey');
        system.debug('=======>>>>> attachedRecords: ' + attachedRecords);
        try{
            caseId = RF2_JSON2Apex_cls.parse(attachedRecords).Case_Z;
        } catch(Exception e){
            system.debug('=======>>>>> error: ' + e.getMessage());
            caseId = null;
        }
        strCaseId = caseId;
        system.debug('=======>>>>> caseId: ' + caseId);
    }
    
    @RemoteAction
    global static void finalizar(String strPreguntaExperiencia, String strResolvimosInquietudes, String strRecomendaria, 
                                 String strRazonCalificacion, String strIdCaso, String strChatKey) {
        RF2_EncuestasCasos__c objEncuestasCasos;
        boolean blnResolvimosInquietudes;
        list<RecordType> lstRecordType;
        list<LiveChatTranscript> lstLCT;
        system.debug('=======>>>>> strPreguntaExperiencia: ' + strPreguntaExperiencia);
        system.debug('=======>>>>> strResolvimosInquietudes: ' + strResolvimosInquietudes);
        system.debug('=======>>>>> strRecomendaria: ' + strRecomendaria);
        system.debug('=======>>>>> strRazonCalificacion: ' + strRazonCalificacion);
        system.debug('=======>>>>> strIdCaso: ' + strIdCaso);
        system.debug('=======>>>>> strChatKey: ' + strChatKey);
        
        blnResolvimosInquietudes = false;
        
        lstRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'RF2_EncuestaChat' AND SObjectType = 'RF2_EncuestasCasos__c'];
        
        if('Si'.equals(strResolvimosInquietudes)){
            blnResolvimosInquietudes = true;
        } else{
            blnResolvimosInquietudes = false;
        }
        
        lstLCT = [SELECT Id, ChatKey, CaseId FROM LiveChatTranscript WHERE ChatKey = :strChatKey];
        system.debug('=======>>>>> lstLCT: ' + lstLCT);
        
        objEncuestasCasos = new RF2_EncuestasCasos__c();
        objEncuestasCasos.RecordTypeId = lstRecordType.get(0).Id;
        
        if(!lstLCT.isEmpty()){
            objEncuestasCasos.RF2_TranscripcionLiveChat__c = lstLCT.get(0).Id;
        }
        
        if(!String.isblank(strIdCaso)){
            system.debug('=======>>>>> Se va a asignar el caso que llego al post-chat');
            objEncuestasCasos.RF2_Caso__c = strIdCaso;
        } else{
            if(!lstLCT.isEmpty()){
                objEncuestasCasos.RF2_Caso__c = lstLCT.get(0).CaseId;
            }
        }
        objEncuestasCasos.RF2_ChatKey__c = strChatKey;
        objEncuestasCasos.RF2_CalificacionSoporteChat__c = strPreguntaExperiencia;
        objEncuestasCasos.RF2_ResolucionInquietudes__c = blnResolvimosInquietudes;
        objEncuestasCasos.RF2_CalificacionRecomendacionChat__c = strRecomendaria;
        objEncuestasCasos.RF2_RazonCalificacion__c = strRazonCalificacion;
        objEncuestasCasos.RF2_Estado__c = 'Cerrada';
        
        insert objEncuestasCasos;
        system.debug('=======>>>>> SE INSERTO LA ENCUESTA: ' + objEncuestasCasos.Id);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Gracias por sus respuestas'));
    }
    
}