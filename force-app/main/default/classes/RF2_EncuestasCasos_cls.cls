public without sharing class RF2_EncuestasCasos_cls { 
    
    public static Boolean allow = true;
    public static void stopTrigger(){
        allow = false;
    }
    public static boolean canIRun(){
        return allow;
    }
    public static void startTrigger(){
        allow = false;
    }
    public void asignarPropetario(List<RF2_EncuestasCasos__c> lstNewRecords){
        Set<String> setIds = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++){          
            setIds.add(lstNewRecords[i].Id);
        }
        if(setIds.size() > 0){
            RF2_Enrutador_cls.asignarPropetario(setIds, 'RF2_EncuestasCasos__c', 'RF2_AsignacionEncuestas__c');
        }
    }
}