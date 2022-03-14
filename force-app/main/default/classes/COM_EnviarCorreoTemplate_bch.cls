/**
* Globant Colombia
* @author           Jordan Parra href=<jordan.parra@globant.com>
* Project:          Compensar
* Description:      Batch para enviar las Encuestas de Casos
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2019-10-10      Jordan Steven Parra  (JP)      	Creación clase.
*************************************************************************************************************/
global class COM_EnviarCorreoTemplate_bch implements Database.Batchable<sObject>{
    
    String query;
    
    global COM_EnviarCorreoTemplate_bch() {
		system.debug('Entra a enviar encuestas');
	}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'SELECT Id, Name, COM_TempCon__c, COM_Correos__c, COM_Plantilla__c, COM_Id_Contacto__c, COM_Cuenta__c FROM AVX_log_encuestas__c';
		system.debug(query);
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, List<AVX_log_encuestas__c> lstEnc) {
        system.debug(lstEnc);
        Set<Id> idsContacto = new Set<Id>();
        List<Contact> delContact = new list<Contact>();
        for (AVX_log_encuestas__c log : lstEnc){
            Set<String> setCorreos = new Set<String>();
            setCorreos.add(log.COM_Correos__c);
            COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, new set<Id>(), log.COM_Plantilla__c, (id)log.COM_Id_Contacto__c, (id)log.COM_Cuenta__c);
            if (log.COM_TempCon__c){
                idsContacto.add(log.COM_Id_Contacto__c);
            }
        }
        if(!idsContacto.isEmpty()){
            delContact = [Select id from Contact where id =: idsContacto];
            for (Contact del : delContact){
                delete del;
            }
        }
        if(!lstEnc.isEmpty()){
            for (AVX_log_encuestas__c log : lstEnc){
                delete log;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        //////
	}
}