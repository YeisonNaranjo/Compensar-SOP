@isTest
private class RF2_CrearCasosSF_tst {
	
	public static RF2_WrapperCrearCasosSFResponse_cls respuesta;
    public static RF2_WrapperCrearCasosSFRequest_cls request;
    
    private static void crearDatos(){
    	request = new RF2_WrapperCrearCasosSFRequest_cls();
    	
		request.documentHandler = '';
		request.noID = '';
		request.fechaTransaccion = '';
		request.fechaRecepcion = '2017-01-01';
		request.tipoDocumento = '';
		request.numeroDocumento = '';
		request.sede = '';
		request.primerNombre = '';
		request.segundoNombre = '';
		request.primerApellido = '';
		request.segundoApellido = '';
		request.razonSocial = '';
		request.direccion = '';
		request.ciudad = '1';
		request.correoElectronico = '';
		request.telefono = '';
		request.observacion = '';
		request.procesoDestino = 'CRM PCE';
		request.tipo = 'Queja';
		request.asunto = 'Agencia de empleo';
		request.genero = '';
		request.estadoCivil = '';

		COM_Poblacion__c pob = new COM_Poblacion__c();
    	pob.COM_Codigo__c = '1';
    	pob.Name = 'n';
    	insert pob;
    }

    private static void insertarAccAnonima(){
    	Account acc = new Account();
    	acc.Name = 'a1';
    	acc.COM_TipoIdentificacion__c = '1';
    	acc.COM_Numero_de_identificacion__c = '9999';
    	insert acc;
    	
    	Contact con = COM_DataGenerator_cls.crearContacto(false, acc.Id);
		con.COM_TipoIdentificacion__c = '1';
		con.COM_Numeroidentificacion__c = '9999'; 
		insert con;
	}

	private static void insertarAcc(){
    	Account acc2 = new Account();
    	acc2.Name = 'a2';
    	acc2.COM_TipoIdentificacion__c = '1';
    	acc2.COM_Numero_de_identificacion__c = '12345';
    	insert acc2;
                    
    }

    private static void insertarAcc2(){
    	Account acc2 = new Account();
    	acc2.Name = 'a3';
    	acc2.COM_TipoIdentificacion__c = '2';
    	acc2.COM_Numero_de_identificacion__c = '12345';
    	insert acc2;
                    
    }

	@isTest static void test_method_1() {
		Test.startTest();
			RF2_CrearCasosSF_ws servicio = new RF2_CrearCasosSF_ws();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(null);
            System.AssertEquals(400, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_2() {
		crearDatos();
		request.noID = '0';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
            System.AssertEquals(400, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_3() {
		crearDatos();
		request.noID = '1';
		request.tipoDocumento = '1';
		request.numeroDocumento = '12345';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
            System.AssertEquals(400, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_4() {
		crearDatos();
		insertarAccAnonima();
		request.noID = '1';
		request.tipoDocumento = '1';
		request.numeroDocumento = '12345';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
			system.debug('------->>>> ' + respuesta);
            //System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_5() {
		crearDatos();
		insertarAcc();
		insertarAccAnonima();
		request.noID = '0';
		request.tipoDocumento = '1';
		request.numeroDocumento = '12345';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
			system.debug('------->>>> ' + respuesta);
            //System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_6() {
		crearDatos();
		insertarAcc();
		request.noID = '0';
		request.tipoDocumento = '1';
		request.numeroDocumento = '12345';
		request.asunto = 'mallll';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
            System.AssertEquals(400, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_7() {
		crearDatos();
		insertarAcc();
		request.noID = '0';
		request.tipoDocumento = '2';
		request.numeroDocumento = '12345';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
	}

	@isTest static void test_method_8() {
		crearDatos();
		insertarAcc();
		request.noID = '0';
		request.tipoDocumento = '2';
		request.numeroDocumento = '123456';
		Test.startTest();
			respuesta = RF2_CrearCasosSF_ws.crearCaso(request);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
	}

}