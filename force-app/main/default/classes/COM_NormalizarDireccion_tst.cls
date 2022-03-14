@isTest
private class COM_NormalizarDireccion_tst {
	
	@isTest static void test_method_one() {
		COM_NormalizarDireccion_cls.stopTrigger();
		COM_NormalizarDireccion_cls.canIRun();
		COM_NormalizarDireccion_cls.startTrigger();
		COM_NormalizarDireccion_cls.getPoblacionesList();
	}
	
	@isTest static void test_method_two() {
		COM_NormalizarDireccion_cls ppp = new COM_NormalizarDireccion_cls();
		ppp.normalizarDireccion(new List<Account>(), new List<Account>());
		Account cuenta = COM_DataGenerator_cls.crearCuenta(false);
		cuenta.COM_Ciudad__c = COM_DataGenerator_cls.crearPoblacion(true).id;
		cuenta.COM_Direccion__c = 'carrera 69 # 96 -21';
		insert cuenta;

	}

	@isTest static void test_method_three() {
		COM_NormalizarDireccion_cls ppp = new COM_NormalizarDireccion_cls();
		ppp.normalizarDireccion(new List<Account>(), new List<Account>());
		Account cuenta = COM_DataGenerator_cls.crearCuenta(false);
		cuenta.COM_Ciudad__c = COM_DataGenerator_cls.crearPoblacion(true).id;
		cuenta.COM_Direccion__c = 'carrera 69 # 96 -22';
		insert cuenta;

		cuenta.COM_Direccion__c = 'carrera 69 # 96 -22';
		update cuenta;

	}

	@isTest static void test_method_four() {
		COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);

		Account cuenta1 = COM_DataGenerator_cls.crearCuenta(true);
		cuenta1.COM_Ciudad__c = pob.id;
		cuenta1.COM_Direccion__c = 'carrera 69 # 96 -21';
		List<Account> lstAccountOld = new List<Account>();
		lstAccountOld.add(cuenta1);

		Account cuenta2 = COM_DataGenerator_cls.crearCuenta(false);
		cuenta2.COM_Ciudad__c = pob.id;
		cuenta2.COM_Direccion__c = 'carrera 69 # 96 -22';
		cuenta2.Id = cuenta1.Id;
		List<Account> lstAccountNew = new List<Account>();
		lstAccountNew.add(cuenta2);

		COM_NormalizarDireccion_cls ppp = new COM_NormalizarDireccion_cls();
		ppp.normalizarDireccion(lstAccountOld, lstAccountNew);

	}


	@isTest static void test_method_five() {
		COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);

		Account cuenta1 = COM_DataGenerator_cls.crearCuenta(true);
		cuenta1.COM_Ciudad__c = pob.id;
		cuenta1.COM_Direccion__c = 'carrera 69 # 96 -21';
		List<Account> lstAccountOld = new List<Account>();
		lstAccountOld.add(cuenta1);

		Account cuenta2 = COM_DataGenerator_cls.crearCuenta(false);
		cuenta2.COM_Ciudad__c = pob.id;
		cuenta2.COM_Direccion__c = 'carrera 69 # 96 -22';
		cuenta2.Id = cuenta1.Id;
		List<Account> lstAccountNew = new List<Account>();
		lstAccountNew.add(cuenta2);
		List<User> objUser = [Select COM_PermisosEscrituraGC__c from User where COM_PermisosEscrituraGC__c = true and isActive = true];
		if(!objUser.isEmpty()){
			System.runAs(objUser.get(0))
	        {
				COM_NormalizarDireccion_cls ppp = new COM_NormalizarDireccion_cls();
				ppp.normalizarDireccion(lstAccountOld, lstAccountNew);
			}
		}
	}



	
}