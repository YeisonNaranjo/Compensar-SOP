@isTest
private class COM_ConsultarCliente_tst {

	private static String responseNull = '{"Error":"Error"}';
	private static String responseOK = '{"CustomerMng_ConsultaCliente_Response":{"Header":{"RequestDate":"2017-08-31T16:14:37.564-05:00","ResponseDate":"2017-08-31T16:14:37.9-05:00","ResponseCode":"0","ResponseDesc":"OK","TransactionID":"99999912345"},"Body":{"Vinculacion":{"AfiliadoCaja":"false","AfiliacionConResponsable":"false","AfiliadoSalud":"false","AfiliadoPLC":"false"},"Cliente":{"TipoIdentificacion":"1","NumeroIdentificacion":"1","Id":"9999803423702961","datosPersona":{"nombrePrimero":"JESUS","nombreSegundo":"","apellidoPrimero":"OVIEDO","apellidoSegundo":"","nombre":"JESUSOVIEDO","foneticoID":"19480615OVIEDOJESUS","nuip":"","Familia":"","demografia":{"nacimientoFecha":"1948-06-15T00:00:00","nacimientoLugar":"","genero":"M","estadoCivil":"SO","gradoEscolaridad":"","TitulosObtenidos":"","OficiosProfesiones":"","OtrosEstudios":""},"categoriaAfiliacion":"","estadoAfiliacion":"D","motivoInactivacion":{"id":"21"}},"Sucursal":{"sucursal":[{"id":"","sucursalID":"0","nivelAdicional":"D","razonSocial":"","mantenimiento":""}]},"comunicacionesCliente":{"comunicacionCliente":[{"telefonos":{"telefonoComunicacion":[{"tipoTelefono":"1","telefono":"3560170","extensionTelefono":"0"}]},"domicilios":{"domicilioComunicacion":[{"barrio":".","tipoDomicilio":"","domicilio":"CALLE34#7ESTE99BL20CS14","codigoPostal":"-","localidad":{},"tipoAreaGeografica":"U"}]},"correosElectronicos":{"correoElectronico":["NACESARITO3X@XYAHOO1.COM"]},"celulares":{"celular":["7104836645"]},"redesSociales":"","opTinEmail":"true","opTinSMS":"true","adicionalesContacto":{"borradoEstado":"A","identificador":"1006010","orden":"1","zonaBogota":"0"}}]},"Contacto":"","Afiliacion":{"afiliacion":[{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803431968415","nombre":"MARIADEJESUSRAMOSALDANA","legalID":"39714350","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2000-11-30T00:00:00","ingresoEmpresaFecha":"1998-10-16T00:00:00","inicioFecha":"1998-10-16T00:00:00","retiroFecha":"2000-11-30T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811432","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""},{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803465819992","nombre":"BLANCALEONORZAMUDIO","legalID":"41543226","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2001-05-01T00:00:00","ingresoEmpresaFecha":"2000-05-10T00:00:00","inicioFecha":"2000-05-10T00:00:00","retiroFecha":"2001-05-01T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811494","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""}]},"Radicacion":""},"atributosComunes":{"beneficiarioEstado":"false","empresaEstado":"false","saltarFoneticoEstado":"false","indice":"0","edadMayor":"false"}}}}';
	private static String responseError = '{"CustomerMng_ConsultaCliente_Response":{"Body":{"Cliente":{"TipoIdentificacion":"1","NumeroIdentificacion":"1","Id":"0"}}}}';
	private static String responseError2 = '{"CustomerMng_ConsultaCliente_Response":{"Header":{"RequestDate":"2017-08-31T16:14:37.564-05:00","ResponseDate":"2017-08-31T16:14:37.9-05:00","ResponseCode":"0","ResponseDesc":"OK","TransactionID":"99999912345"},"Body":{"Vinculacion":{"AfiliadoCaja":"false","AfiliacionConResponsable":"false","AfiliadoSalud":"false","AfiliadoPLC":"false"},"Cliente":{"TipoIdentificacion":"1","NumeroIdentificacion":"1","Id":"9999803423702961","datosPersona":{"foneticoID":"19480615OVIEDOJESUS","nuip":"","Familia":"","demografia":{"nacimientoFecha":"1948-06-","nacimientoLugar":"","genero":"M","estadoCivil":"ys","gradoEscolaridad":"","TitulosObtenidos":"","OficiosProfesiones":"","OtrosEstudios":""},"categoriaAfiliacion":"","estadoAfiliacion":"D","motivoInactivacion":{"id":"21"}},"Sucursal":{"sucursal":[{"id":"","sucursalID":"0","nivelAdicional":"EE","razonSocial":"","mantenimiento":""}]},"comunicacionesCliente":{"comunicacionCliente":[{"telefonos":{"telefonoComunicacion":[{"tipoTelefono":"1","telefono":"3560170","extensionTelefono":"0"}]},"domicilios":{"domicilioComunicacion":[{"barrio":".","tipoDomicilio":"","domicilio":"CALLE34#7ESTE99BL20CS14","codigoPostal":"-","localidad":{"id":"5898","municipio":{"id":"-1","nombre":"","departamento":{"id":"-"}},"nombre":"BOGOTAD.C."},"tipoAreaGeografica":"U"}]},"correosElectronicos":{"correoElectronico":["NACESARITO3X@XYAHOO1.COM"]},"celulares":{"celular":["7104836645"]},"redesSociales":"","opTinEmail":"true","opTinSMS":"true","adicionalesContacto":{"borradoEstado":"A","identificador":"1006010","orden":"1","zonaBogota":"0"}}]},"Contacto":"","Afiliacion":{"afiliacion":[{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803431968415","nombre":"MARIADEJESUSRAMOSALDANA","legalID":"39714350","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2000-11-30T00:00:00","ingresoEmpresaFecha":"1998-10-16T00:00:00","inicioFecha":"1998-10-16T00:00:00","retiroFecha":"2000-11-30T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811432","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""},{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803465819992","nombre":"BLANCALEONORZAMUDIO","legalID":"41543226","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2001-05-01T00:00:00","ingresoEmpresaFecha":"2000-05-10T00:00:00","inicioFecha":"2000-05-10T00:00:00","retiroFecha":"2001-05-01T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811494","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""}]},"Radicacion":""},"atributosComunes":{"beneficiarioEstado":"false","empresaEstado":"false","saltarFoneticoEstado":"false","indice":"0","edadMayor":"false"}}}}';
	public static void createData(){
		Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
		Account acc = new Account();
		acc.Name = 'Nombre';	
		acc.COM_TipoIdentificacion__c = '2';	
		acc.COM_Numero_de_identificacion__c = '12345';	
		acc.COM_Direccion__c = 'dir';
		acc.Phone = '1';
		acc.COM_Estadoafiliacion__c = '0';
		acc.COM_CausalRetiro__c = 'causal';
		acc.COM_FechaRetiro__c = date.newInstance(2017, 9, 27);
		acc.RecordTypeId = rt;
		insert acc;
	}

	public static testMethod void test_method_1() {
	    Test.startTest();
			COM_ConsultarCliente_ctr controlador1 = new COM_ConsultarCliente_ctr();
			controlador1.fnConsultar();
		Test.stopTest(); 
	}

	public static testMethod void test_method_2() {
	    Test.startTest();
			COM_ConsultarCliente_ctr controlador2 = new COM_ConsultarCliente_ctr();
			controlador2.objAcc.COM_TipoIdentificacion__c = '2';
			controlador2.strTipoSeleccionado = '12345';
			//controlador2.objAcc.COM_Numero_de_identificacion__c = '12345';
			COM_CalloutGenericRestMock_tst tstMockNull = new COM_CalloutGenericRestMock_tst(responseNull, 200, 'OK');
	        Test.setMock(HttpCalloutMock.class, tstMockNull);
	        controlador2.fnConsultar();	
		Test.stopTest(); 
	}

	public static testMethod void test_method_3() {
	    Test.startTest();
			COM_ConsultarCliente_ctr controlador3 = new COM_ConsultarCliente_ctr();
	        COM_CalloutGenericRestMock_tst tstMockError = new COM_CalloutGenericRestMock_tst(responseError, 200, 'OK');
	        Test.setMock(HttpCalloutMock.class, tstMockError);
	        controlador3.fnConsultar();	
		Test.stopTest(); 
	}

	public static testMethod void test_method_4() {
	    Test.startTest();
	        COM_ConsultarCliente_ctr controlador4 = new COM_ConsultarCliente_ctr();
			COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
	        Test.setMock(HttpCalloutMock.class, tstMockOK);
	        controlador4.objAcc.COM_Numero_de_identificacion__c = '2';
			controlador4.strTipoSeleccionado = '12345';
	        controlador4.fnConsultar();	
	        controlador4.fnTraerDeGC();
		Test.stopTest(); 
	}

	public static testMethod void test_method_5() {
	    Test.startTest();
	        COM_ConsultarCliente_ctr controlador5 = new COM_ConsultarCliente_ctr();
			createData();
			COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
	        Test.setMock(HttpCalloutMock.class, tstMockOK);
			controlador5.objAcc.COM_Numero_de_identificacion__c = '1';
			controlador5.strTipoSeleccionado = '12345';
			controlador5.fnConsultar();
			controlador5.fnCrearCliente();
			controlador5.fnAbrir();
		Test.stopTest(); 
	}

	public static testMethod void test_method_6() {
	    Test.startTest();
	        COM_ConsultarCliente_ctr controlador5 = new COM_ConsultarCliente_ctr();
			createData();
			COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseError2, 200, 'OK');
	        Test.setMock(HttpCalloutMock.class, tstMockOK);
			controlador5.objAcc.COM_Numero_de_identificacion__c = 'abc';
			controlador5.strTipoSeleccionado = '1';
			controlador5.fnConsultar();
		Test.stopTest(); 
	}
	public static testMethod void test_method_7() {
	    Test.startTest();
	    	COM_ConsultarCliente_ctr.AccounGCWrapper wpr = new COM_ConsultarCliente_ctr.AccounGCWrapper();
	    	wpr.objCuenta = new Account();
	    	wpr.strTipoDocumento = '';
	    	wpr.strEstadoAfiliacion  = '';
	}
	public static testMethod void test_method_8() {
	    Test.startTest();
	        COM_ConsultarCliente_ctr controlador4 = new COM_ConsultarCliente_ctr();
			COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseError2, 200, 'OK');
	        Test.setMock(HttpCalloutMock.class, tstMockOK);
	        controlador4.objAcc.COM_Numero_de_identificacion__c = '2';
			controlador4.strTipoSeleccionado = '12345';
	        controlador4.fnConsultar();	
	        controlador4.fnTraerDeGC();
		Test.stopTest(); 
	}
}