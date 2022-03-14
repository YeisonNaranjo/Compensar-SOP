@isTest
private class COM_BotonEncuentroConDirectivos_ctr_tst {
	
	@isTest static void test_method_one() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		COM_Actas__c acta = COM_DataGenerator_cls.crearActa(true, acc.Id);
		Test.startTest();
		ApexPages.StandardController controller = new ApexPages.StandardController(acta);
		COM_BotonEncuentroConDirectivos_ctr app = new COM_BotonEncuentroConDirectivos_ctr(controller);
		app.redireccionar();
		app.strTipoDoc = 'aa';
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		COM_Actas__c acta = COM_DataGenerator_cls.crearActa(true, acc.Id);
		acta.RecordTypeId = Schema.SObjectType.COM_Actas__c.getRecordTypeInfosByName().get('Mejora continua').getRecordTypeId();
		update acta;
		Test.startTest();
		ApexPages.StandardController controller = new ApexPages.StandardController(acta);
			COM_BotonEncuentroConDirectivos_ctr app = new COM_BotonEncuentroConDirectivos_ctr(controller);
			app.redireccionar();
		Test.stopTest();
	}

	@isTest static void test_method_three() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		COM_Actas__c acta = COM_DataGenerator_cls.crearActa(true, acc.Id);
		COM_Actas__c acta2 = COM_DataGenerator_cls.crearActa2(true, acc.Id);
		acta.Id = acta2.Id;
		delete acta2;
		Test.startTest();
		ApexPages.StandardController controller = new ApexPages.StandardController(acta);
			COM_BotonEncuentroConDirectivos_ctr app = new COM_BotonEncuentroConDirectivos_ctr(controller);
			app.redireccionar();
		Test.stopTest();
	}
	
}