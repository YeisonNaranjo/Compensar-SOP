/**
* Avanxo Colombia
* @author 			Stifen Panche Gutierrez (SP)
* Project:			Compensar
* Description:		Clase encargada de ejecutar  un batch para sumar metas individuales, debería enviarse todas las noches.
*                  COM_SumarMetas_bch
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		14/04/2018		Stifen Panche (SP)		Implementacion inicial de la clase.
**/

global class COM_SumarMetas_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global COM_SumarMetas_bch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {


		COM_Fecha_Metas_bch__c cs = COM_Fecha_Metas_bch__c.getInstance();
		String anio = cs.Anio__c;
			query = 'Select Id, COM_Anio__c, COM_Mes__c, COM_Linea__c, COM_Asesor__c, COM_Canal__c, COM_Ciclo__c from COM_MetasIndividuales__c where COM_Anio__c = :anio and RF2_Fecha_actualizacion_RISK__c = null';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<COM_MetasIndividuales__c> scope) {


       Map<Id, COM_MetasIndividuales__c> scopeMap = new Map<Id, COM_MetasIndividuales__c>(scope);
   		 List<COM_MetasIndividuales__c> metas = new List<COM_MetasIndividuales__c>();  
         metas = (List<COM_MetasIndividuales__c>)scope;

         Map<Id,Decimal> mapMetasSuma = new Map<Id,Decimal>();


         /*Suma las metas de acuerdo a las oportunidades asociadas*/


         for (AggregateResult ar : [select COM_MetaIndividual__c,recordtype.DeveloperName,sum(Amount) valor, sum (COM_Valor_antes_impuesto__c) valorAlojamiento from Opportunity where COM_MetaIndividual__c in :scopeMap.keySet() group by COM_MetaIndividual__c,recordtype.DeveloperName ])
         {
			 	if(!ar.get('DeveloperName').equals('COM_Alojamiento')){
					 mapMetasSuma.put((Id) ar.get('COM_MetaIndividual__c'), (Decimal)ar.get('valor'));
				 }else{
					 // si es Alojamiento
					 mapMetasSuma.put((Id) ar.get('COM_MetaIndividual__c'), (Decimal)ar.get('valorAlojamiento'));
				 }
                
         }

         for(COM_MetasIndividuales__c meta : metas)
         {
         	meta.COM_ValorEjecutado__c =+ mapMetasSuma.get(meta.Id);
			system.debug('meta.COM_ValorEjecutado__---------->'+meta.COM_ValorEjecutado__c);
         }

         update metas;
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}