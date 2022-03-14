trigger COS_HistoricoEstadosProspectoSalud_tgr on COS_HistoricoEstadosProspectoSalud__c (before insert,before update,after insert,after update) {
	 if(Trigger.isBefore){
        if (Trigger.isUpdate){
            COS_HistoricoEstadosLeadSaludHandler_cls.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}