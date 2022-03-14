/**
 * Created by AVX_JSuarez on 10/08/2017.
 */
@isTest
private class COM_CrearActualizarClienteSF_tst {

    public static COM_CrearActualizarClienteSF_ws.WrapperResponseCliente respuesta;
    public static COM_WrapperCrearActualizarClienteSF_cls clienteJ;
    public static COM_WrapperCrearActualizarClienteSF_cls clienteN;
    public static Account accJ, accN;
    public static AccountContactRelation acr;
    private static void crearDatos(){
        COM_Poblacion__c ciudad = new COM_Poblacion__c();
        ciudad.Name = 'nombre';
        ciudad.COM_Codigo__c = '11001';
        ciudad.COM_Departamento__c = '11';
        insert ciudad;

        COM_ActividadEconomicaCIIU__c acteco = new COM_ActividadEconomicaCIIU__c();
        acteco.Name = 'acteco';
        acteco.COM_Codigo__c = '101';
        insert acteco;

        clienteN = new COM_WrapperCrearActualizarClienteSF_cls();
        clienteN.tipoIdentificacion = '1';
        clienteN.numeroIdentificacion = '123';
        clienteN.id = '123';
        COM_WrapperCrearActualizarClienteSF_cls.DatosPersona dp = new COM_WrapperCrearActualizarClienteSF_cls.DatosPersona();
        dp.primerApellido = 'a';
        dp.primerNombre = 'n';
        dp.segundoNombre = 'b';
        dp.segundoApellido = 'b';
        dp.genero = 'M';
        dp.nacimientoFecha = '1990-10-04';
        dp.nacimientoLugar = '11001';
        dp.estadoCivil = 'SO';
        /* Inicio 2.0 */
        dp.orientacionSexual = '1';
        dp.nivelEscolar = '1';
        dp.factorVulnerabilidad = '1';
        dp.pertenenciaEtnica = '1';
        dp.profesion = '5153';        
        /* Fin 2.0 */
        clienteN.datosPersona = dp;

        clienteJ = new COM_WrapperCrearActualizarClienteSF_cls();
        clienteJ.tipoIdentificacion = '2';
        clienteJ.numeroIdentificacion = '123';
        clienteJ.id = '1234';
        
        COM_WrapperCrearActualizarClienteSF_cls.DatosEmpresa de = new COM_WrapperCrearActualizarClienteSF_cls.DatosEmpresa();
        de.razonSocial = 'a';
        de.digitoVerificadorLegal = '2';
        de.constitucionFecha = '2017-10-04';
        de.nombreComercial = 'n';
        clienteJ.datosEmpresa = de; 

        COM_WrapperCrearActualizarClienteSF_cls.Sucursal s = new COM_WrapperCrearActualizarClienteSF_cls.Sucursal();
        s.sucursalID = '0';
        s.centrocostoID = '0';
        clienteJ.sucursal = s;

        COM_WrapperCrearActualizarClienteSF_cls.Requisitos reqs = new COM_WrapperCrearActualizarClienteSF_cls.Requisitos();
        List<COM_WrapperCrearActualizarClienteSF_cls.Requisito> lstReq = new List<COM_WrapperCrearActualizarClienteSF_cls.Requisito>();
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req1 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req1.nemotecnico = 'CLINTE';
        req1.valorString = '5';
        req1.valorNumerico = '0';
        req1.valorBooleano = 'false';
        req1.valorFechaInicio = '0001-01-01T00:00:00';
        req1.valorFechaFin = '2017-10-04T00:00:00';
        lstReq.add(req1);    
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req2 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req2.nemotecnico = 'CORELE';
        req2.valorString = 'correobien@gmail.com';
        req2.valorNumerico = '0';
        req2.valorBooleano = 'true';
        req2.valorFechaInicio = '0001-01-01T00:00:00';
        req2.valorFechaFin = '2017-10-04T00:00:00';
        lstReq.add(req2);    
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req3 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req3.nemotecnico = 'PAGAPO';
        req3.valorString = '0';
        req3.valorNumerico = '0';
        req3.valorBooleano = 'false';
        req3.valorFechaInicio = '0001-01-01T00:00:00';
        req3.valorFechaFin = '2017-10-04T00:00:00';
        lstReq.add(req3);
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req4 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req4.nemotecnico = 'SIGLA';
        req4.valorString = 'sigla';
        req4.valorNumerico = '0';
        req4.valorBooleano = 'false';
        req4.valorFechaInicio = '0001-01-01T00:00:00';
        req4.valorFechaFin = '2017-10-04T00:00:00';
        lstReq.add(req4);
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req5 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req5.nemotecnico = 'ACSENA';
        req5.valorString = '';
        req5.valorNumerico = '100';
        req5.valorBooleano = 'false';
        req5.valorFechaInicio = '0001-01-01T00:00:00';
        req5.valorFechaFin = '2017-10-04T00:00:00';
        lstReq.add(req5);
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req6 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req6.nemotecnico = 'ACTECO';
        req6.valorString = '';
        req6.valorNumerico = '101';
        req6.valorBooleano = 'false';
        req6.valorFechaInicio = '0001-01-01T00:00:00';
        req6.valorFechaFin = '2017-10-04T00:00:00';
        lstReq.add(req6);
        reqs.requisito = lstReq;   
        COM_WrapperCrearActualizarClienteSF_cls.Requisito req7 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req7.nemotecnico = 'ULTSUB';
        req7.valorString = '201710RT522.254';
        req7.valorNumerico = '1';
        req7.valorBooleano = 'false';
        req7.valorFechaInicio = '0001-01-01T00:00:00';
        req7.valorFechaFin = '';
        lstReq.add(req7);
        reqs.requisito = lstReq;   
        
        clienteJ.requisitos = reqs;

    }
    private static void insertarDatos(){

        accN = new Account();
        accN.Name = 'nombre';
        accN.COM_TipoIdentificacion__c = '1';
        accN.COM_Numero_de_identificacion__c = '12345678909';
        accN.COM_NAUTCLI__c = '123';
        accN.COM_Primernombre__c = 'Nombre';
        accN.COM_Otrosnombres__c = 'Nombre';
        accN.COM_Primerapellido__c = 'Apellido';
        accN.COM_Segundoapellido__c = 'Apellido';
        accN.COM_Direccion__c = 'd';
        accN.COM_CorreoElectronico__c = 'abcde@abcde.com';
        accN.COM_Movil__c = '1';
        accN.COM_FechaNacimiento__c = date.newInstance(2000, 1, 1);
        accN.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Natural').getRecordTypeId();
        insert accN;

        accJ = new Account();
        accJ.Name = 'nombre';
        accJ.COM_TipoIdentificacion__c = '2';
        accJ.COM_Numero_de_identificacion__c = '123';
        accJ.COM_NAUTCLI__c = '1234';
        accJ.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
        insert accJ;
        
        Contact objContact = COM_DataGenerator_cls.crearContacto(true, accN.Id);
        

        acr = new AccountContactRelation();
        acr.AccountId = accJ.Id;
        acr.ContactId = objContact.Id;
        acr.Roles = 'Representante Legal';
        acr.IsActive = true;
        insert acr;


    }

    @isTest static void test_method_one(){
        Test.startTest();
            COM_CrearActualizarClienteSF_ws clase = new COM_CrearActualizarClienteSF_ws();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(null);
          //  System.AssertEquals(400, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_two() {
        crearDatos();
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteN);
           System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_three() {
        crearDatos();
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_four() {
        crearDatos();
        COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal drl = new COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal();
        drl.numeroIdentificacion = '1234';
        drl.id = '12345';
        drl.tipoIdentificacion = '1';
        drl.nombrePrimero = 'a';
        drl.nombreSegundo = 'a';
        drl.apellidoPrimero = 'b';
        drl.apellidoSegundo = 'c';
        drl.estadoCivil = 'SO';
        drl.nacimientoFecha = '1990-11-01';
        drl.nacimientoLugar = '11001';
        drl.genero = 'M';
        clienteJ.datosRepresentanteLegal = drl; 
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_five() {
        crearDatos();
        clienteJ.sucursal = null;
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_six() {
        crearDatos();
        clienteJ.sucursal.sucursalID = '1';
        clienteJ.sucursal.centrocostoID = '0';
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_seven() {
        crearDatos();
        clienteJ.sucursal.sucursalID = '1';
        clienteJ.sucursal.centrocostoID = '1';
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_nine() {
        crearDatos();
        insertarDatos();
        COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal drl = new COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal();
        drl.numeroIdentificacion = '1234';
        drl.id = '12345';
        drl.tipoIdentificacion = '1';
        drl.nombrePrimero = 'a';
        drl.nombreSegundo = 'a';
        drl.apellidoPrimero = 'b';
        drl.apellidoSegundo = 'c';
        drl.estadoCivil = 'SO';
        drl.nacimientoFecha = '1990-11-01';
        drl.nacimientoLugar = '11001';
        drl.genero = 'M';
        clienteJ.datosRepresentanteLegal = drl; 

        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_ten() {
        crearDatos();
        insertarDatos();
        COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal drl = new COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal();
        drl.numeroIdentificacion = '123';
        drl.id = '123';
        drl.tipoIdentificacion = '1';
        drl.nombrePrimero = 'a';
        drl.nombreSegundo = 'a';
        drl.apellidoPrimero = 'b';
        drl.apellidoSegundo = 'c';
        drl.estadoCivil = 'SO';
        drl.nacimientoFecha = '1990-11-01';
        drl.nacimientoLugar = '11001';
        drl.genero = 'M';
        clienteJ.datosRepresentanteLegal = drl; 

        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            //System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }
    @isTest static void test_method_eleven() {
        crearDatos();
        insertarDatos();
        COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal drl = new COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal();
        drl.numeroIdentificacion = '123';
        drl.id = '123';
        drl.tipoIdentificacion = '1';
        drl.nombrePrimero = 'a';
        drl.nombreSegundo = 'a';
        drl.apellidoPrimero = 'b';
        drl.apellidoSegundo = 'c';
        drl.estadoCivil = 'SO';
        drl.nacimientoFecha = '1990-11-01';
        drl.nacimientoLugar = '11001';
        drl.genero = 'M';
        clienteJ.datosRepresentanteLegal = drl; 

        COM_WrapperCrearActualizarClienteSF_cls.Requisito req0 = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
        req0.nemotecnico = 'CORELE';
        req0.valorString = 'elcorreoestamal';
        req0.valorNumerico = '0';
        req0.valorBooleano = 'true';
        req0.valorFechaInicio = '0001-01-01T00:00:00';
        req0.valorFechaFin = '2017-10-04T00:00:00';
        clienteJ.requisitos.requisito.add(req0);
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            //System.AssertEquals(400, respuesta.codigoRespuesta);
        Test.stopTest();
    }
/*
    @isTest static void test_method_twelve() {
        crearDatos();
        insertarDatos();
        Contact c = new Contact();
        c.COM_TipoIdentificacion__c = '1';
        c.COM_Numeroidentificacion__c = '999';
        c.FirstName = 'f';
        c.LastName = 'l';
        c.AccountId = accN.Id;
        insert c;
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteN);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }*/

    @isTest static void test_method_thirteen() {
        crearDatos();
        insertarDatos();
        List<AccountContactRelation> acr4 = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId =:accN.Id];
        for(AccountContactRelation a : acr4){
            a.Roles = 'Otros';
            a.IsActive = false;
        }
        update acr4;
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteN);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

    @isTest static void test_method_fourteen() {
        crearDatos();
        clienteN.datosPersona.nacimientoFecha = 'fechamal';
        clienteJ.sucursal = null;
        clienteJ.datosEmpresa.digitoVerificadorLegal = 'a';
        clienteJ.datosEmpresa.constitucionFecha = 'fechamal';
        COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal drl = new COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal();
        drl.numeroIdentificacion = '1234';
        drl.id = '12345';
        drl.tipoIdentificacion = '1';
        drl.nombrePrimero = 'a';
        drl.nombreSegundo = 'a';
        drl.apellidoPrimero = 'b';
        drl.apellidoSegundo = 'c';
        drl.estadoCivil = 'SO';
        drl.nacimientoFecha = 'otrafechamal';
        drl.nacimientoLugar = 'unaciudad mal';
        drl.genero = 'M';
        clienteJ.datosRepresentanteLegal = drl;        
        COM_WrapperCrearActualizarClienteSF_cls.domicilio d = new COM_WrapperCrearActualizarClienteSF_cls.domicilio();
        d.codigoMunicipio = '11001'; 
        List<COM_WrapperCrearActualizarClienteSF_cls.domicilio> lstd = new List<COM_WrapperCrearActualizarClienteSF_cls.domicilio>();
        lstd.add(d);
        COM_WrapperCrearActualizarClienteSF_cls.domicilios ds = new COM_WrapperCrearActualizarClienteSF_cls.domicilios();
        ds.domicilio = lstd;
        COM_WrapperCrearActualizarClienteSF_cls.comunicacion c = new COM_WrapperCrearActualizarClienteSF_cls.comunicacion();
        c.domicilios = ds; 
        List<COM_WrapperCrearActualizarClienteSF_cls.comunicacion> lstc = new List<COM_WrapperCrearActualizarClienteSF_cls.comunicacion>();
        lstc.add(c);
        COM_WrapperCrearActualizarClienteSF_cls.comunicaciones cs = new COM_WrapperCrearActualizarClienteSF_cls.comunicaciones();
        cs.comunicacion = lstc;
        clienteN.comunicaciones = cs;
        Test.startTest();
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteN);
            System.AssertEquals(200, respuesta.codigoRespuesta);
            respuesta = COM_CrearActualizarClienteSF_ws.crearCliente(clienteJ);
            System.AssertEquals(200, respuesta.codigoRespuesta);
        Test.stopTest();
    }

}