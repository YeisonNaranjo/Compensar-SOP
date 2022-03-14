@isTest
private class COM_ActualizarRelCuentaContactoSch_tst {

	public static AccountContactRelation acr;
	public static Account a;
	public static Contact c;
	public static List<AccountContactRelation> lstAcr;

	public static void crearDatos(){
		a = COM_DataGenerator_cls.crearCuenta(true);
		c = COM_DataGenerator_cls.crearContacto(true, a.Id);
		acr = [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE AccountId =: a.Id AND ContactId =: c.Id];
		lstAcr = new List<AccountContactRelation>();
		lstAcr.add(acr);

	}

	public static testMethod void test_method_one() {
		crearDatos();
		Test.StartTest();
			COM_ActualizarRelCuentaContacto_sch sch = new COM_ActualizarRelCuentaContacto_sch();
			String strSch = '0 0 23 * * ?'; 
			system.schedule('Programar', strSch, sch); 
		Test.stopTest(); 
	}

	public static testMethod void test_method_two(){
		crearDatos();
		Test.startTest();
			COM_ActualizarRelCuentaContacto_bch cdb = new COM_ActualizarRelCuentaContacto_bch();
			cdb.execute(null, lstAcr);
		Test.stopTest();
	}

	public static testMethod void test_method_three(){
		crearDatos();
		Test.startTest();
			COM_ActualizarRelCuentaContacto_bch cdb = new COM_ActualizarRelCuentaContacto_bch();
			cdb.execute(null, lstAcr);
		Test.stopTest();
	}
	
}