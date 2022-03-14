/**
* Avanxo Colombia
* @author           Paula Bohórquez href=<paula.bohorquez@globant.com>
* Project:          Compensar
* Description:      Batch que cierra las tareas creadas para notificar a los asesores PAF cuando un candidato
*					fue convertido automáticamente desde una cuenta que tengan una antiguedad mayor a 7 días.
*
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2020-02-18      Paula Bohórquez (PB)            Creación de la clase
*************************************************************************************************************/
global class CEL1_CerrarTareasPAF_bch implements Database.Batchable<sObject>{

    
    global Database.QueryLocator start(Database.BatchableContext BC) {
		DateTime dtaFecha = System.now();
        Integer intDias=Integer.valueOf(Label.CEL1_DiasBorradoTareas);
        DateTime dtaFechaBuscar = dtaFecha.addDays(intDias);
        String query = 'SELECT Id,Status, WhoId FROM Task WHERE (Subject = \'' +Label.CEL1_CandidatoConvertido+'\' OR Subject =\'' +Label.CEL2_CambioRol + '\') AND Status != \'Completed\' AND CreatedDate < '+dtaFechaBuscar.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        //String query = 'SELECT Id,Status, WhoId FROM Task WHERE Subject = \'' +Label.CEL1_CandidatoConvertido+'\' AND Status != \'Completed\'';
        System.debug(' CEL1_CreacionLogCorreoCA_bch :: query :: '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Task> lstTask) {
        
        for(Task objTsk : lstTask){
            objTsk.Status = 'Completed';
        } 
        
        Database.SaveResult [] updateResult = Database.update(lstTask, false);
        for (Database.SaveResult r : updateResult)
        {
            if (!r.isSuccess()){
                for (Database.Error e : r.getErrors()){System.debug('===>>> CEL1_CerrarTareasPAF_bch : Ocurrió el siguiente error : '+r.getId()+e);}     
            }  
            else{
                System.debug('===>>> CEL1_CerrarTareasPAF_bch : Se actualizó la siguiente tarea : '+r.getId());
            }          
    	}
    }
    
    global void finish(Database.BatchableContext BC) {    	


    }
}