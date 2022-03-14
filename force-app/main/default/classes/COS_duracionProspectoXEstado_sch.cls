global class COS_duracionProspectoXEstado_sch implements schedulable{
    global void execute(schedulableContext sc){
        COS_duracionProspectoXEstado_bch b = new COS_duracionProspectoXEstado_bch();
	    Database.executeBatch (b,200);
    }
}