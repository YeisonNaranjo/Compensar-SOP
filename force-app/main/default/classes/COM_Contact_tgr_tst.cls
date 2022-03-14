@isTest
private class COM_Contact_tgr_tst {
	
	@isTest static void test_method_one() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		COM_DataGenerator_cls.crearContacto(true, ac.Id);
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}