@isTest
private class COM_BotonGenerarPdfAlojamiento_ctr_tst {
	
	@isTest static void test_method_1() {
		 Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfAlojamiento_ctr app = new COM_BotonGenerarPdfAlojamiento_ctr(controller);
				app.redireccionar();
				app.lstOppLineItem = new List<OpportunityLineItem>();
		 Test.stopTest();
	}
	
	@isTest static void test_method_2() {
		 Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 oppp.COM_Fechahorainicio__c = null;
		 oppp.COM_Fechahorafinalizacion__c = null;
		 oppp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Alojamiento').getRecordTypeId();
		 
		 update oppp;
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfAlojamiento_ctr app = new COM_BotonGenerarPdfAlojamiento_ctr(controller);
				app.redireccionar();
				app.lstOppLineItem = new List<OpportunityLineItem>();
		 Test.stopTest();
	}
	
	@isTest static void test_method_3() {
		 Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 oppp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Alojamiento').getRecordTypeId();
		 
		 update oppp;
		 Product2 p2 =  COM_DataGenerator_cls.crearProductoAlojamiento(true);
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfAlojamiento_ctr app = new COM_BotonGenerarPdfAlojamiento_ctr(controller);
				app.redireccionar();
				app.lstOppLineItem = new List<OpportunityLineItem>();
		 Test.stopTest();
	}

		@isTest static void test_method_4() {
		 Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Contact cont =  COM_DataGenerator_cls.crearContacto(true, acc.Id);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 oppp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Alojamiento').getRecordTypeId();
		 oppp.Contacto__c = cont.Id;
		 update oppp;
		 Product2 p2 =  COM_DataGenerator_cls.crearProductoAlojamiento(true);
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfAlojamiento_ctr app = new COM_BotonGenerarPdfAlojamiento_ctr(controller);
				app.redireccionar();
				app.lstOppLineItem = new List<OpportunityLineItem>();
		 Test.stopTest();
	}

		@isTest static void test_method_5() {
		 Account acc = COM_DataGenerator_cls.crearCuenta(true);
		 Opportunity oppp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		 Quote cuote =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 Quote cuote2 =  COM_DataGenerator_cls.crearQuote(true, oppp.Id);
		 cuote.Id = cuote2.Id;
		 delete cuote2;
		 Test.startTest();
				ApexPages.StandardController controller = new ApexPages.StandardController(cuote);
				COM_BotonGenerarPdfAlojamiento_ctr app = new COM_BotonGenerarPdfAlojamiento_ctr(controller);
				app.redireccionar();
				app.lstOppLineItem = new List<OpportunityLineItem>();
		 Test.stopTest();
	}
}