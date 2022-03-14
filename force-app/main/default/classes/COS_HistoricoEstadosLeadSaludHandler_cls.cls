public with sharing class COS_HistoricoEstadosLeadSaludHandler_cls {
	public static void beforeUpdate(list<COS_HistoricoEstadosProspectoSalud__c> lstNewHistorico, map<Id,COS_HistoricoEstadosProspectoSalud__c> mapOldHistorico){
        System.debug('beforeUpdate ::::: ');
        System.debug('lstNewHistorico ::::: '+lstNewHistorico);
        System.debug('mapOldHistorico ::::: '+mapOldHistorico);
        
        COS_HistoricoEstadosLeadSaludHelper_cls.resetNoGestionLead_mtd(lstNewHistorico, mapOldHistorico);
    }
}