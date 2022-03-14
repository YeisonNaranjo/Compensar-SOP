@isTest
private class COM_CalcularDiasFechaRetencionSch_tst {
	
	public static testMethod void test_method_one() {
		Test.StartTest();
			COM_CalcularDiasFechaRetencion_sch sch = new COM_CalcularDiasFechaRetencion_sch();
			String strSch = '0 0 23 * * ?'; 
			system.schedule('Programar', strSch, sch); 
		Test.stopTest(); 
	}

	public static testMethod void test_method_two(){
		Test.startTest();
		COM_CalcularDiasFechaRetencion_bch cdb = new COM_CalcularDiasFechaRetencion_bch();
		List<Account> lstAcc = new List<Account>();
		lstAcc.add(COM_DataGenerator_cls.crearCuenta(true));
		cdb.execute(null, lstAcc);
		Test.stopTest();
	}

		public static testMethod void test_method_three(){
		Test.startTest();
		COM_CalcularDiasFechaRetencion_bch cdb = new COM_CalcularDiasFechaRetencion_bch();
		List<Account> lstAcc = new List<Account>();
		lstAcc.add(COM_DataGenerator_cls.crearCuenta(false));
		cdb.execute(null, lstAcc);
		Test.stopTest();
	}
	
}