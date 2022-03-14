/**
* Avanxo Colombia
* @author 			Gonzalo Rivas Valenzuela (GR)
* Project:			Compensar
* Description:		Clase que contiene la definición y la lógica un batch para desasociar casos a contactos temporales
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		13/01/2021		Gonzalo Rivas (GR)		Implementacion inicial de la clase.
* @version  2.0     09/02/2021      Gonzalo Rivas (GR)      Se modifica el tamaño del batch
**/
global class COM_EliminarCasePorContact_bch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query ='SELECT Id, Name, COM_Id_Contacto__c FROM AVX_log_encuestas__c WHERE COM_TempCon__c = true';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<AVX_log_encuestas__c> scope){
        
        set<Id> contId = new set<Id>();
        if(scope.size()>0){
            for(AVX_log_encuestas__c encuestas : scope){
                contId.add(encuestas.COM_Id_Contacto__c);
            }
            
            List<Case> cases = [SELECT Id, ContactId FROM Case WHERE ContactId =: contId];
            for(Case cs : cases){
                cs.ContactId = null;
                //cases.add(cs);
            }
            COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeUpdate');
            COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
            update cases;
        }
        
    }
    global void finish(Database.BatchableContext bc){
        COM_EnviarCorreoTemplate_bch b = new COM_EnviarCorreoTemplate_bch();
        database.executeBatch(b, 10);
    }
}