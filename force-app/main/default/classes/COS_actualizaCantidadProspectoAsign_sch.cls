global class COS_actualizaCantidadProspectoAsign_sch implements schedulable{
	global void execute(schedulableContext sc){
        COS_actualizaCantidadProspectoAsign_bch b = new COS_actualizaCantidadProspectoAsign_bch();
	    Database.executeBatch (b,100);
    }
}