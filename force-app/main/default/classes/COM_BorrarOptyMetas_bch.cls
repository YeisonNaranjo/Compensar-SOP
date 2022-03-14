/**
* Avanxo Colombia
* @author 			Stifen Panche Gutierrez (SP)
* Project:			Compensar
* Description:		Clase encargada de ejecutar  un batch para actualizar la asociación de oportunidades con su respectiva meta.
*                  COM_SumarMetas_bch
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		14/04/2018		Stifen Panche (SP)		Implementacion inicial de la clase.
**/

global class COM_BorrarOptyMetas_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global COM_BorrarOptyMetas_bch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		COM_Fecha_Metas_bch__c cs = COM_Fecha_Metas_bch__c.getInstance();
		Integer anio = Integer.valueOf(cs.Anio__c);
		query = 'Select Id from Opportunity where (StageName = \'Facturada\' OR StageName = \'DESEMBOLSADO\') and CALENDAR_YEAR(COM_FechaFacturacion__c) = :anio';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		List<Opportunity> lstOpty = new List<Opportunity>();
   		lstOpty = (List<Opportunity>)scope;

   		for(Opportunity opty : lstOpty )
   		{
   			opty.COM_MetaIndividual__c = null;

   		}

   		update lstopty;
	
	}
	
	global void finish(Database.BatchableContext BC) {

//Al finalizar la asociación de cuentas, realiza sumatoria del importe de oportunidades para casa meta.
		 COM_SumarMetas_bch b = new COM_SumarMetas_bch();
         database.executebatch(b);
		
	}
	
}