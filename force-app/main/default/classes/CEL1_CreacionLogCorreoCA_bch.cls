/**
* Avanxo Colombia
* @author           Paula Bohórquez href=<pbohorquez@avanxo.com>
* Project:          Compensar
* Description:      Batch para crear los de correo electrónico para todos 
*                   los EmailMessage relacionados a Cuenta Acreedora
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2019-12-16      Paula Bohórquez (PB)            Creación de la clase
*************************************************************************************************************/
global class CEL1_CreacionLogCorreoCA_bch implements Database.Batchable<sObject>, Database.Stateful{

    global List<Log_Correo_Electronico__c> lstLogs; 
    global Map<String,String> mapIdTaskxIdCandidato;
    

    global Database.QueryLocator start(Database.BatchableContext BC) {

        DateTime dtaFecha = System.now();
        //DateTime dtaFechaBuscar = dtaFecha.addHours(-1);
        DateTime dtaFechaBuscar = dtaFecha.addDays(-10);
        String strLead = 'Lead';
        String query = 'SELECT Id, WhoId FROM Task WHERE Who.Type = \''+strLead+ '\' AND CreatedDate > '+dtaFechaBuscar.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        System.debug(' CEL1_CreacionLogCorreoCA_bch :: query :: '+query);
        mapIdTaskxIdCandidato = new Map<String,String>();
        lstLogs = new List<Log_Correo_Electronico__c>();
        return Database.getQueryLocator(query);
            
              
    }
    
    global void execute(Database.BatchableContext BC, List<Task> lstTask) {
        
        System.debug('lstTask....'+lstTask);
        Map<String, String> mapIdTaskxIdLead = new Map<String, String>();
        List<Lead> lstLeadUpd = new List<Lead>();
        for(Task tsk : lstTask){
            mapIdTaskxIdCandidato.put(tsk.Id,tsk.WhoId);
        }        

        if(!mapIdTaskxIdCandidato.isEmpty()){
            String stTemp;
            List<Log_Correo_Electronico__c> lstLogsCorreo = new List<Log_Correo_Electronico__c>();
            Set<Id> setIdCandidatosExcluir = new Set<Id>();
            
            for(Log_Correo_Electronico__c objLog : [SELECT CEL1_Candidato__c FROM Log_Correo_Electronico__c WHERE CEL1_Candidato__c != '']){
                setIdCandidatosExcluir.add(objLog.CEL1_Candidato__c);
            }

            for(EmailMessage em : [SELECT Id,IsOpened,FirstOpenedDate,LastOpenedDate, Subject, ActivityId,MessageDate, Status FROM EmailMessage WHERE ActivityId IN: mapIdTaskxIdCandidato.keySet()]){
                if(!setIdCandidatosExcluir.contains(mapIdTaskxIdCandidato.get(em.ActivityId))){
                    stTemp = em.Status == '3'?'Enviado':'';
                    lstLogs.add(new Log_Correo_Electronico__c(
                        Asunto_Correo__c = em.Subject,
                        CEL1_Candidato__c = mapIdTaskxIdCandidato.get(em.ActivityId),
                        Estado__c = stTemp,
                        Fecha_Envio__c = em.MessageDate,
                        CEL1_FechaAbierto__c = em.FirstOpenedDate
                    ));  
                }                              
            }            
        } 
        Set<Id> setIdLogsOK = new Set<Id>();
        if(!lstLogs.isEmpty()){
            Database.SaveResult[] srList = Database.insert(lstLogs, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('**** crearLogCorreo : se insertaron los correos:  ');
                    setIdLogsOK.add(sr.getId());
                    System.debug('setIdLogsOK.for...'+setIdLogsOK);
                    
                }
                else {                   
                    for(Database.Error err : sr.getErrors()) { 
                        System.debug('**** crearLogCorreo : error al insertar los correos: ');            
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }

            System.debug('setIdLogsOK....'+setIdLogsOK);

            for(Log_Correo_Electronico__c objLog : [SELECT CEL1_Candidato__c FROM Log_Correo_Electronico__c WHERE Id IN: setIdLogsOK]){
                lstLeadUpd.add(new Lead(Id = objLog.CEL1_Candidato__c,
                    CEL1_EmailFueEnviado__c = true));
            }
            System.debug('lstLeadUpd...'+lstLeadUpd);
            if(!lstLeadUpd.isEmpty()){
                //Se marcan los leads como enviados
                try {
                    update lstLeadUpd;    
                } catch (DmlException  e) {
                    for (Integer i= 0; i < e.getNumDml(); i++) {
                        System.debug('mensaje de error for...'+e.getDmlMessage(i));
                        
                    }
                }
                
            }
        }       
    }   
    
    global void finish(Database.BatchableContext BC) {      


    }
}