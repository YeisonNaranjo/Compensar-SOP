global class COM_CalcularDiasFechaRetencion_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global COM_CalcularDiasFechaRetencion_bch() {
		system.debug('Entra a calcular dias fecha de retención');
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT COM_DiasFaltantesRetencion__c, COM_FechaLimiteRetencion__c FROM '+
				'Account WHERE COM_FechaLimiteRetencion__c != NULL AND COM_FechaLimiteRetencion__c >= '+
				String.valueOf(System.TODAY()).left(10);
				system.debug(query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> lstAcc) {
   		system.debug(lstAcc);
   		BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
		for (Account acc : lstAcc) {
            Datetime dtFechaLR = datetime.newInstanceGmt(acc.COM_FechaLimiteRetencion__c.year(), acc.COM_FechaLimiteRetencion__c.month(), acc.COM_FechaLimiteRetencion__c.day(),24,0,0);
            acc.COM_DiasFaltantesRetencion__c = COM_Utilidades_cls.calcularNumeroDiasHabiles(horarioOficina.Id, dtFechaLR)*-1;          
        }
        try {
			COM_AccountContactRelation_cls.stopTrigger();
            update lstAcc;
            COM_AccountContactRelation_cls.startTrigger(); 
        } catch(Exception e) {
            System.debug('Error actualizando los registros. '+e.getMessage());
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}