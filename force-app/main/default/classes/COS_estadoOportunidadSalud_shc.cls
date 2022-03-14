global class COS_estadoOportunidadSalud_shc implements schedulable{
	global void execute(schedulableContext sc){
        COS_estadoOportunidadSalud_bch b = new COS_estadoOportunidadSalud_bch();
	    Database.executeBatch (b,80);
    }
}