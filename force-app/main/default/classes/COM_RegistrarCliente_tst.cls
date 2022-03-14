@isTest
private class COM_RegistrarCliente_tst {
	
	private static String responseOK = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "1234"},"atributosComunes": ""}}}';
	private static Account accN;

	private static void crearDatos(){
		COM_Poblacion__c ciudad = new COM_Poblacion__c();
		ciudad.Name = 'nombre';
		ciudad.COM_Codigo__c = '11001';
		ciudad.COM_Departamento__c = '11';
		insert ciudad;

		COM_ActividadEconomicaCIIU__c aec = new COM_ActividadEconomicaCIIU__c();
		aec.Name = 'nombre';
		aec.COM_Codigo__c = '1';
		insert aec;
		
		accN = new Account();
		accN.Name = 'nombre';
		accN.COM_TipoIdentificacion__c = '1';
		accN.COM_Numero_de_identificacion__c = '123456789';
        accN.COM_Primernombre__c = 'Nombre';
        accN.COM_Otrosnombres__c = 'Nombre';
        accN.COM_Primerapellido__c = 'Apellido';
        accN.COM_Segundoapellido__c = 'Apellido';
        accN.COM_FechaNacimiento__c = date.newInstance(2000, 1, 1);
        accN.COM_Ciudad__c = ciudad.Id;
        accN.COM_Direccion__c = 'd';
        accN.COM_CorreoElectronico__c = 'abcde@abcde.com';
        accN.COM_Tipodireccion__c = 'U';
        accN.COM_Movil__c = '1';
        accN.COM_UsuarioFacebook__c = 'f';
        accN.COM_UsuarioTwitter__c = 't';
        accN.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'COM_Natural'].Id;
		insert accN;
	}

	@isTest static void test_method_1() {
		Test.startTest();
			ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
			COM_RegistrarCliente_ctr controlador = new COM_RegistrarCliente_ctr(sc);
	        PageReference pageRef = Page.COM_RegistrarCliente_pag;
	        Test.setCurrentPage(pageRef);
		Test.stopTest();
	}

	@isTest static void test_method_2() {
		crearDatos();
		Test.startTest();
			ApexPages.StandardController sc = new ApexPages.StandardController(accN);
			COM_RegistrarCliente_ctr controlador = new COM_RegistrarCliente_ctr(sc);
			PageReference pageRef = Page.COM_RegistrarCliente_pag;
		    Test.setCurrentPage(pageRef);
		    controlador.procesarRegistro();
		Test.stopTest();
	}

	@isTest static void test_method_3() {
		crearDatos();
		Test.startTest();
			ApexPages.StandardController sc = new ApexPages.StandardController(accN);
			COM_RegistrarCliente_ctr controlador = new COM_RegistrarCliente_ctr(sc);
			PageReference pageRef = Page.COM_RegistrarCliente_pag;
		    Test.setCurrentPage(pageRef);
		    COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
	    	Test.setMock(HttpCalloutMock.class, tstMock);		
		    controlador.procesarRegistro();
		Test.stopTest();
	}
	
}