trigger COS_HistoricoEstadosOportunidadSalud on Opportunity_stage_history__c (before insert,before update,after insert,after update) {
	if(Trigger.isBefore){
        if (Trigger.isUpdate){
            COS_HistoricoEstadosOppSaludHandler_cls.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}