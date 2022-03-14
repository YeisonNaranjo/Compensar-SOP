@isTest
private class COM_BorrarOtyMetas_tst {
    
	@isTest static void test_Borrar_Opty_Metas() {

		// Implement test code

		Test.StartTest();
		insert new COM_Fecha_Metas_bch__c(Anio__c = '2018');
			COM_BorrarOptyMetas_sch sch = new COM_BorrarOptyMetas_sch();
			String strSch = '0 0 23 * * ?'; 
			system.schedule('ProgramarBorrar', strSch, sch); 
		Test.stopTest(); 
	}
}