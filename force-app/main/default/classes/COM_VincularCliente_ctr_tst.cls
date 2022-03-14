@isTest
private class COM_VincularCliente_ctr_tst {
	
	@isTest static void test_method_one() {
		Account account = COM_DataGenerator_cls.crearCuenta(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        account.COM_Primernombre__c = 'Cosme';
        account.COM_Primerapellido__c = 'Fulanito';
        account.COM_Estado_civil__c = 'CA';
        insert account;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
		//AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
		ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);

	}
	
	@isTest static void test_method_two() {
		Account account = COM_DataGenerator_cls.crearCuenta(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert account;
		ApexPages.StandardController controller = new ApexPages.StandardController(new Opportunity());
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	}
    @isTest static void test_method_three() {
		Account account = COM_DataGenerator_cls.crearCuenta4(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert account;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
       	ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	 	ppp.vincularCliente();
	}

    @isTest static void test_method_four() {
		Account account = COM_DataGenerator_cls.crearCuenta4(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert account;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true,account.Id);
      //  Opportunity opp2 = new Opportunity();
		ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	 //	ppp.vincularCliente();
	}
        @isTest static void test_method_five() {
		Account account = COM_DataGenerator_cls.crearCuenta5(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert account;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true,account.Id);
      //  Opportunity opp2 = new Opportunity();
		ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	 //	ppp.vincularCliente();
	}
    
    @isTest static void test_method_six() {
		List<Account> lstAc = new List<Account>();
        Account account = COM_DataGenerator_cls.crearCuenta5(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        account.COM_EsAFP__c    =   true;
        lstAc.add(account);
        Account objCuentaJur = COM_DataGenerator_cls.crearCuenta4(false);
        objCuentaJur.COM_Numero_de_identificacion__c = '1918298823';
        objCuentaJur.Name = 'Empresa';
        account.COM_EsAFP__c    =   true;
        lstAc.add(objCuentaJur);
        
        insert lstAc;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, lstAc[0].Id);
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(false,lstAc[0].Id);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_Vinculacion_Pensionado').getRecordTypeId();
		opp.COM_EntidadPensionadora1__c = lstAc[1].Id;
        insert opp;
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	}
    
    @isTest static void test_method_seven() {
		List<Account> lstAc = new List<Account>();
        Account account = COM_DataGenerator_cls.crearCuenta5(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        lstAc.add(account);
        Account objCuentaJur = COM_DataGenerator_cls.crearCuenta4(false);
        objCuentaJur.COM_Numero_de_identificacion__c = '1918298823';
        objCuentaJur.Name = 'Empresa';
        lstAc.add(objCuentaJur);
        
        insert lstAc;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, lstAc[0].Id);
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(false,lstAc[0].Id);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_Vinculacion_Contratista').getRecordTypeId();
		opp.COM_EntidadContratista__c = lstAc[1].Id;
        insert opp;
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	 //	ppp.vincularCliente();
	}
    @isTest static void test_method_eight() {
        Account account = COM_DataGenerator_cls.crearCuenta5(true);
        
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(false,account.Id);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_Vinculacion_Contratista').getRecordTypeId();
		opp.COM_EntidadContratista__c = account.Id;
        insert opp;
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_VincularCliente_ctr ppp = new COM_VincularCliente_ctr(controller);
	 
	}
    


}