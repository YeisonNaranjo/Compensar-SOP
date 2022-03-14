global class RL2_CopiarSetupAuditTrail_sch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
		RL2_CopiarSetupAuditTrail_cls.copiarRegistrosAuditoria();
    }
    
}