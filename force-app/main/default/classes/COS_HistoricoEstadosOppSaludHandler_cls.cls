public with sharing class COS_HistoricoEstadosOppSaludHandler_cls {
	public static void beforeUpdate(list<Opportunity_stage_history__c> lstNewHistorico, map<Id,Opportunity_stage_history__c> mapOldHistorico){
        System.debug('beforeUpdate ::::: ');
        System.debug('lstNewHistorico ::::: '+lstNewHistorico);
        System.debug('mapOldHistorico ::::: '+mapOldHistorico);
        
        COS_HistoricoEstadosOppSaludHelper_cls.resetNoGestionLead_mtd(lstNewHistorico, mapOldHistorico);
    }
}