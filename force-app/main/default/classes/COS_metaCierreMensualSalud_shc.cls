global class COS_metaCierreMensualSalud_shc implements schedulable{
	global void execute(schedulableContext sc){
        COS_metaCierreMensualSalud_bch b = new COS_metaCierreMensualSalud_bch();
	    Database.executeBatch (b,20);
    }
}