global class COS_duracionOportunidadXEstado_sch implements schedulable{
	global void execute(schedulableContext sc){
        COS_duracionOportunidadXEstado_bch b = new COS_duracionOportunidadXEstado_bch();
	    Database.executeBatch (b,200);
    }
}