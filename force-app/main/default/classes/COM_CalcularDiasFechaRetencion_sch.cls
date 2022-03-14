global class COM_CalcularDiasFechaRetencion_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		COM_CalcularDiasFechaRetencion_bch be = new COM_CalcularDiasFechaRetencion_bch();
		database.executeBatch(be);
	}
}