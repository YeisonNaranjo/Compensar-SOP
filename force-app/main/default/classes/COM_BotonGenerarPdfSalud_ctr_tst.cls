@isTest
private class COM_BotonGenerarPdfSalud_ctr_tst {
	
	@isTest static void test_method_1() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfSalud_ctr app = new COM_BotonGenerarPdfSalud_ctr(controller);
				app.redireccionar();
		 Test.stopTest();
	}
	
	@isTest static void test_method_2() {
		 Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Quote cuote2 =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 cuote.Id = cuote2.Id;
		 delete cuote2;
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfSalud_ctr app = new COM_BotonGenerarPdfSalud_ctr(controller);
				app.redireccionar();
		 Test.stopTest();
	}
	
}