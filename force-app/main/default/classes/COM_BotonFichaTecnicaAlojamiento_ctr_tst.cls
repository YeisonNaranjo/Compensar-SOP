@isTest
private class COM_BotonFichaTecnicaAlojamiento_ctr_tst {
	
	@isTest static void test_method_one() {
		Account acc=  COM_DataGenerator_cls.crearCuenta(true);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		Test.startTest();
		ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        COM_BotonFichaTecnicaAlojamiento_ctr app = new COM_BotonFichaTecnicaAlojamiento_ctr(controller);
        app.redireccionar();
		Test.stopTest();		
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}