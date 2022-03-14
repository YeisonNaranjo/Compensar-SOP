@isTest
private class COM_ActualizarContadorRepLegalesSch_tst {
	
	public static testMethod void test_method_one() {
		Test.StartTest();
			COM_ActualizarContadorRepLegales_sch sch = new COM_ActualizarContadorRepLegales_sch();
			String strSch = '0 0 23 * * ?'; 
			system.schedule('Programar', strSch, sch); 
		Test.stopTest(); 
	}

	public static testMethod void test_method_two(){
		Test.startTest();
		COM_ActualizarContadorRepLegales_bch cdb = new COM_ActualizarContadorRepLegales_bch();
		List<Account> lstAcc = new List<Account>();
		lstAcc.add(COM_DataGenerator_cls.crearCuenta(true));
		cdb.execute(null, lstAcc);
		Test.stopTest();
	}

		public static testMethod void test_method_three(){
		Test.startTest();
		COM_ActualizarContadorRepLegales_bch cdb = new COM_ActualizarContadorRepLegales_bch();
		List<Account> lstAcc = new List<Account>();
		lstAcc.add(COM_DataGenerator_cls.crearCuenta(false));
		cdb.execute(null, lstAcc);
		Test.stopTest();
	}
	
}