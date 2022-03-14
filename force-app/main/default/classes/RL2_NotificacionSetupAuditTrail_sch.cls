global class RL2_NotificacionSetupAuditTrail_sch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
		RL2_CopiarSetupAuditTrail_cls.enviarCorreo();
    }
    
}