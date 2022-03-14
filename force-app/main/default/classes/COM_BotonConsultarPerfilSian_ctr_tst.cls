@isTest
private class COM_BotonConsultarPerfilSian_ctr_tst {

	private static Account crearCuenta(){
		COM_AccountContactRelation_cls.stopTrigger();
		Account arl = new Account();
		arl.Name ='Prueba';
		arl.COM_TipoIdentificacion__c = '2';
		arl.COM_Numero_de_identificacion__c = '123456789';
		insert arl;
		COM_AccountContactRelation_cls.startTrigger();
		return arl;
	}
	
	@isTest static void test_method_one() {
		Account account = crearCuenta();
		Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(account);
		COM_BotonConsultarPerfilSian_ctr app = new COM_BotonConsultarPerfilSian_ctr(controller);
		app.redireccionar();
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Account account = crearCuenta();
		Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(account);
		COM_BotonConsultarPerfilSian_ctr app = new COM_BotonConsultarPerfilSian_ctr(controller);
		app.ieValue = 'true';
		app.redireccionar();
		Test.stopTest();
	}
	
}