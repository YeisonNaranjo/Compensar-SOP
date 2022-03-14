@isTest
private class COM_GenerarPazYSalvo_tst {
	@isTest static void test_method_1() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		ApexPages.StandardController controller = new ApexPages.StandardController(acc);
		COM_GenerarPazYSalvo_ctr appx = new COM_GenerarPazYSalvo_ctr(controller);
		appx.mensajeTransaccion = '';
    	appx.blnTransaccion = true;
    	appx.valorTipoDoc = '';
	    appx.lightning = true;
	    appx.salesforce1 = true;
		appx.redireccionar();
		//Id ids = appx.getContactosCuenta(acc.Id);
	}


	@isTest static void test_method_2() {
		Account acc = COM_DataGenerator_cls.crearCuenta(false);
		acc.COM_FechaAportePazSalvo__c = null;
		acc.COM_FechaAfiliacion__c = null;
		acc.COM_FechaRetiro__c = null;
		acc.COM_CorreoElectronico__c = null;
		insert acc;
		ApexPages.StandardController controller = new ApexPages.StandardController(acc);
		COM_GenerarPazYSalvo_ctr appx = new COM_GenerarPazYSalvo_ctr(controller);
		appx.mensajeTransaccion = '';
    	appx.blnTransaccion = true;
    	appx.valorTipoDoc = '';
	    appx.lightning = true;
	    appx.salesforce1 = true;
		appx.redireccionar();
		//Id ids = appx.getContactosCuenta(acc.Id);
	}

}