@isTest
private class COM_CrearActualizarClienteGC_tst {

    private static COM_CrearActualizarClienteGC_ws clsCrear = new COM_CrearActualizarClienteGC_ws();
    private static String responseOK = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "1234"},"atributosComunes": ""}}}';
    private static String responseError = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "0"},"atributosComunes": ""}}}';
    private static String responseNull;
    private static Account accJ;
    private static Account accN;
    private static Contact objContact;
    private static AccountContactRelation acr;

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

        Account arl = new Account();
        arl.Name = 'arl';
        arl.COM_TipoIdentificacion__c = '2';
        arl.COM_Numero_de_identificacion__c = '123456';
        arl.COM_CodigoARL__c = '22';
        arl.COM_EsARL__c = true;
        arl.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'COM_Juridico'].Id;
        insert arl;

        accJ = new Account();
        accJ.Name = 'nombre';
        accJ.COM_TipoIdentificacion__c = '2';
        accJ.COM_Numero_de_identificacion__c = '123456789';
        accJ.COM_Digitoverificacion__c = 1;
        accJ.COM_ResponsabilidadesFiscales__c = '1';
		accJ.COM_ActividadEconomicaCIIU__c = aec.id;
        accJ.RecordTypeId = arl.RecordTypeId;
        insert accJ;
        
        objContact = COM_DataGenerator_cls.crearContacto(true, accN.Id);


List<AccountContactRelation> laLista = [SELECT AccountId, ContactId FROM AccountContactRelation];
system.debug('laLista-'+laLista);

        acr = new AccountContactRelation();
        acr.AccountId = accJ.Id;
        //acr.ContactId = [SELECT ContactId FROM AccountContactRelation WHERE AccountId =:accN.Id AND Roles INCLUDES ('Representante Legal') LIMIT 1].ContactId;
        acr.ContactId = objContact.Id;
        acr.Roles = 'Representante Legal';
        acr.IsActive = true;
        insert acr;

        system.debug(ciudad);
        system.debug(aec);
        system.debug(arl);
        system.debug(accJ);
        system.debug(accN);
        system.debug(acr);
    }
    
    @isTest static void test_method_one() {
        crearDatos();
        COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperCrearClienteGCResponse_cls responseJOK = COM_CrearActualizarClienteGC_ws.CrearCliente( (String)accJ.id, false, 1);
        system.debug(accJ);
        system.debug(accN);
        system.debug(acr);
    }

    @isTest static void test_method_two() {
        crearDatos();
        COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);   
        COM_WrapperCrearClienteGCResponse_cls responseNOK = COM_CrearActualizarClienteGC_ws.CrearCliente( (String)accN.id, false, 1);
    }

    @isTest static void test_method_three() {
        crearDatos();   
        COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseError, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperCrearClienteGCResponse_cls responseJError = COM_CrearActualizarClienteGC_ws.CrearCliente( (String)accJ.id, false, 1);
    }

    @isTest static void test_method_four() {
        crearDatos();
        COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseError, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);   
        COM_WrapperCrearClienteGCResponse_cls responseNError = COM_CrearActualizarClienteGC_ws.CrearCliente( (String)accN.id, false, 1);
    }

    @isTest static void test_method_five() {
        crearDatos();   
        COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseNull, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperCrearClienteGCResponse_cls responseJNull = COM_CrearActualizarClienteGC_ws.CrearCliente( (String)accJ.id, false, 1);
    }

    @isTest static void test_method_six() {
        crearDatos();
        COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseNull, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);       
        COM_WrapperCrearClienteGCResponse_cls responseNNull = COM_CrearActualizarClienteGC_ws.CrearCliente( (String)accN.id, false, 1);
    }
    
}