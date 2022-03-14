global class COM_AsignarPropietarioColas_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global COM_AsignarPropietarioColas_bch() {
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		query = 'Select Id From Case Where Owner.name like \'Cola%\'';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Case> scope) {

   		Set<String> setCaseIds = new Set<String>();

   		System.debug('setCaseIds  ' + setCaseIds);

   		for(Case c : scope)
   		{
   			setCaseIds.add(c.Id);
   		}

   		COM_Encolable_cls.asignarPropetarioColas(setCaseIds, 'Case', 'RF2_AsignacionCasos__c');
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}