global class COS_consolidaMetaSaludDiario_shc implements schedulable{
	global void execute(schedulableContext sc){
        COS_consolidaMetaSaludDiario_bch b = new COS_consolidaMetaSaludDiario_bch();
	    Database.executeBatch (b,20);
    }
}