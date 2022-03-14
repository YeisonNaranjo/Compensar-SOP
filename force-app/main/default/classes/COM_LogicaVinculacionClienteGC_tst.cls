@isTest
private class COM_LogicaVinculacionClienteGC_tst {
    
    private static String responseOK = '{"CustomerAdmin_ProcesarVinculacion_Response" : {"Header" : {"RequestDate" : "2017-10-11T16:57:55.919-05:00","ResponseDate" : "2017-10-11T16:57:56.418-05:00","ResponseCode" : "0","ResponseDesc" : "OK","TransactionID" : "12620171011165755816"},"Body" : {"ProcesarVinculacionResponse" : {"resultadoOperacion" : "true","resultadoMensaje" : "Vinculación existente. El cambio no puede ser realizado."}}}, "CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "1234"},"atributosComunes": ""}}}';
    private static String responseError = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "0"},"atributosComunes": ""}}}';
    private static String responseConsultaOk = '{"CustomerMng_ConsultaCliente_Response":{"Header":{"RequestDate":"2017-08-31T16:14:37.564-05:00","ResponseDate":"2017-08-31T16:14:37.9-05:00","ResponseCode":"0","ResponseDesc":"OK","TransactionID":"99999912345"},"Body":{"Vinculacion":{"AfiliadoCaja":"false","AfiliacionConResponsable":"false","AfiliadoSalud":"false","AfiliadoPLC":"false"},"Cliente":{"TipoIdentificacion":"1","NumeroIdentificacion":"1","Id":"9999803423702961","datosPersona":{"nombrePrimero":"JESUS","nombreSegundo":"","apellidoPrimero":"OVIEDO","apellidoSegundo":"","nombre":"JESUSOVIEDO","foneticoID":"19480615OVIEDOJESUS","nuip":"","Familia":"","demografia":{"nacimientoFecha":"1948-06-15T00:00:00","nacimientoLugar":"","genero":"M","estadoCivil":"SO","gradoEscolaridad":"","TitulosObtenidos":"","OficiosProfesiones":"","OtrosEstudios":""},"categoriaAfiliacion":"","estadoAfiliacion":"D","motivoInactivacion":{"id":"21"}},"Sucursal":{"sucursal":[{"id":"","sucursalID":"0","nivelAdicional":"D","razonSocial":"","mantenimiento":""}]},"comunicacionesCliente":{"comunicacionCliente":[{"telefonos":{"telefonoComunicacion":[{"tipoTelefono":"1","telefono":"3560170","extensionTelefono":"0"}]},"domicilios":{"domicilioComunicacion":[{"barrio":".","tipoDomicilio":"","domicilio":"CALLE34#7ESTE99BL20CS14","codigoPostal":"-","localidad":{},"tipoAreaGeografica":"U"}]},"correosElectronicos":{"correoElectronico":["NACESARITO3X@XYAHOO1.COM"]},"celulares":{"celular":["7104836645"]},"redesSociales":"","opTinEmail":"true","opTinSMS":"true","adicionalesContacto":{"borradoEstado":"A","identificador":"1006010","orden":"1","zonaBogota":"0"}}]},"Contacto":"","Afiliacion":{"afiliacion":[{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803431968415","nombre":"MARIADEJESUSRAMOSALDANA","legalID":"39714350","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2000-11-30T00:00:00","ingresoEmpresaFecha":"1998-10-16T00:00:00","inicioFecha":"1998-10-16T00:00:00","retiroFecha":"2000-11-30T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811432","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""},{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803465819992","nombre":"BLANCALEONORZAMUDIO","legalID":"41543226","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2001-05-01T00:00:00","ingresoEmpresaFecha":"2000-05-10T00:00:00","inicioFecha":"2000-05-10T00:00:00","retiroFecha":"2001-05-01T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811494","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""}]},"Radicacion":""},"atributosComunes":{"beneficiarioEstado":"false","empresaEstado":"false","saltarFoneticoEstado":"false","indice":"0","edadMayor":"false"}}}}';
    private static String responseConsultaOk2 = '{"CustomerMng_ConsultaCliente_Response":{"Header":{"RequestDate":"2017-08-31T16:14:37.564-05:00","ResponseDate":"2017-08-31T16:14:37.9-05:00","ResponseCode":"0","ResponseDesc":"OK","TransactionID":"99999912345"},"Body":{"Vinculacion":{"AfiliadoCaja":"false","AfiliacionConResponsable":"false","AfiliadoSalud":"false","AfiliadoPLC":"false"},"Cliente":{"TipoIdentificacion":"-1","NumeroIdentificacion":"-1","Id":"9999803423702961","datosPersona":{"nombrePrimero":"JESUS","nombreSegundo":"","apellidoPrimero":"OVIEDO","apellidoSegundo":"","nombre":"JESUSOVIEDO","foneticoID":"19480615OVIEDOJESUS","nuip":"","Familia":"","demografia":{"nacimientoFecha":"1948-06-15T00:00:00","nacimientoLugar":"","genero":"M","estadoCivil":"SO","gradoEscolaridad":"","TitulosObtenidos":"","OficiosProfesiones":"","OtrosEstudios":""},"categoriaAfiliacion":"","estadoAfiliacion":"D","motivoInactivacion":{"id":"21"}},"Sucursal":{"sucursal":[{"id":"","sucursalID":"0","nivelAdicional":"D","razonSocial":"","mantenimiento":""}]},"comunicacionesCliente":{"comunicacionCliente":[{"telefonos":{"telefonoComunicacion":[{"tipoTelefono":"1","telefono":"3560170","extensionTelefono":"0"}]},"domicilios":{"domicilioComunicacion":[{"barrio":".","tipoDomicilio":"","domicilio":"CALLE34#7ESTE99BL20CS14","codigoPostal":"-","localidad":{},"tipoAreaGeografica":"U"}]},"correosElectronicos":{"correoElectronico":["NACESARITO3X@XYAHOO1.COM"]},"celulares":{"celular":["7104836645"]},"redesSociales":"","opTinEmail":"true","opTinSMS":"true","adicionalesContacto":{"borradoEstado":"A","identificador":"1006010","orden":"1","zonaBogota":"0"}}]},"Contacto":"","Afiliacion":{"afiliacion":[{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803431968415","nombre":"MARIADEJESUSRAMOSALDANA","legalID":"39714350","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2000-11-30T00:00:00","ingresoEmpresaFecha":"1998-10-16T00:00:00","inicioFecha":"1998-10-16T00:00:00","retiroFecha":"2000-11-30T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811432","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""},{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803465819992","nombre":"BLANCALEONORZAMUDIO","legalID":"41543226","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2001-05-01T00:00:00","ingresoEmpresaFecha":"2000-05-10T00:00:00","inicioFecha":"2000-05-10T00:00:00","retiroFecha":"2001-05-01T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811494","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""}]},"Radicacion":""},"atributosComunes":{"beneficiarioEstado":"false","empresaEstado":"false","saltarFoneticoEstado":"false","indice":"0","edadMayor":"false"}}}}';
    private static String responseOK2 = '{"CustomerAdmin_ProcesarVinculacion_Response" : {"Header" : {"RequestDate" : "2017-10-11T16:57:55.919-05:00","ResponseDate" : "2017-10-11T16:57:56.418-05:00","ResponseCode" : "0","ResponseDesc" : "OK","TransactionID" : "12620171011165755816"},"Body" : {"ProcesarVinculacionResponse" : {"resultadoOperacion" : "true","resultadoMensaje" : "Vinculación existente. El cambio no puede ser realizado."}}}, "CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": null},"atributosComunes": ""}}}';
    private static String responseNull;
    private static Account accJ;
    private static Account accN;
    private static Contact objContact;
    private static AccountContactRelation acr;
    private static Opportunity o;
    private static COM_ProgramaVinculacion__c p;
    
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
        accJ.COM_EsAFP__c = True;
        accJ.RecordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName = 'COM_Juridico'].Id;
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
        
        p = new COM_ProgramaVinculacion__c();
        p.Name = 'programa';
        p.COM_Codigo__c = '10251';
        insert p;

        o = new Opportunity();
        o.Name = 'o';
        o.StageName = 'En revisión';
        o.CloseDate = Date.newInstance(2017, 10, 1);
        o.COM_ProgramaVinculacion1__c = p.Id;
        o.COM_EntidadPensionadora1__c = accJ.Id;
        o.COM_ValorPension__c = 100;
        COM_OpportunityLineItem_cls.stopTrigger();
        insert o;

    }

    @isTest static void test_method_one() {
        crearDatos();
        Test.startTest();
        COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
        clsA.procesarVinculacion(o.Id);
        Test.stopTest();
    }

    @isTest static void test_method_two() {
        crearDatos();
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            accN.COM_NAUTCLI__c = '1';
            update accN;
            clsA.procesarVinculacion(o.Id);
        Test.stopTest();
    }

    @isTest static void test_method_three() {
        crearDatos();
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            accN.COM_NAUTCLI__c = '1';
            update accN;
            p.COM_Programa_Activo__c = true;
            update p;
            clsA.procesarVinculacion(o.Id);
        Test.stopTest();
    }

   /* @isTest static void test_method_four() {
        crearDatos();
         Test.startTest();
        accN.COM_NAUTCLI__c = '1';
        update accN;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accN.Id;
        update o;
        
        if(label.COM_FaseProyecto == 'MIGRACION'){
            List<AccountContactRelation> lstRelation = [SELECT ContactId FROM AccountContactRelation WHERE AccountId =:accN.Id LIMIT 1];
            system.debug(lstRelation);
            AccountContactRelation ojbAccountContactRelation = lstRelation.get(0);
            ojbAccountContactRelation.Roles = 'Representante Legal';
            update ojbAccountContactRelation;
        }

            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            clsA.procesarVinculacion(o.Id);
        Test.stopTest();
    }*/

    @isTest static void test_method_five() {
        crearDatos();
        accN.COM_NAUTCLI__c = '1';
        update accN;
        accJ.COM_NAUTCLI__c = '1';
        update accJ;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accJ.Id;
        update o;
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            clsA.procesarVinculacion(o.Id);
        Test.stopTest();
    }

    @isTest static void test_method_six() {
        crearDatos();
        accN.COM_NAUTCLI__c = null;
        update accN;
        accJ.COM_NAUTCLI__c = '1';
        update accJ;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accJ.Id;
        update o;
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseConsultaOk, 200, 'OK');
	        
            Test.setMock(HttpCalloutMock.class, tstMock);
            Test.setMock(HttpCalloutMock.class, tstMockOK);
            try{clsA.procesarVinculacion(o.Id);}
            catch(Exception e){

            }
        Test.stopTest();
    }

    @isTest static void test_method_seven() {
        crearDatos();
        accN.COM_NAUTCLI__c = '1';
        update accN;
        accJ.COM_NAUTCLI__c = null;
        update accJ;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accJ.Id;
        update o;
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            try{clsA.procesarVinculacion(o.Id);}
            catch(Exception e){
                
            }
        Test.stopTest();
    }

    @isTest static void test_method_eight() {
         crearDatos();
        accN.COM_NAUTCLI__c = '1';
        update accN;
        accJ.COM_NAUTCLI__c = '1';
        update accJ;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accJ.Id;
        update o;
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseError, 500, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            try{clsA.procesarVinculacion(o.Id);}
            catch(Exception e){
                
            }
        Test.stopTest();
    }
    @isTest static void test_method_nine() {
        crearDatos();
        accN.COM_NAUTCLI__c = null;
        update accN;
        accJ.COM_NAUTCLI__c = '1';
        update accJ;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accJ.Id;
        update o;
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseConsultaOk2, 200, 'OK');
	        
            Test.setMock(HttpCalloutMock.class, tstMock);
            Test.setMock(HttpCalloutMock.class, tstMockOK);
            try{clsA.procesarVinculacion(o.Id);}
            catch(Exception e){

            }
        Test.stopTest();
    }

    @isTest static void test_method_ten() {
        crearDatos();
        accN.COM_NAUTCLI__c = '1';
        accN.COM_No_procesado_On_Line__c = true;
        update accN;
        p.COM_Programa_Activo__c = true;
        update p;
        o.AccountId = accN.Id;
        o.COM_No_procesado_On_Line__c = true;
        update o;
        
        if(label.COM_FaseProyecto == 'MIGRACION'){
            List<AccountContactRelation> lstRelation = [SELECT ContactId FROM AccountContactRelation WHERE AccountId =:accN.Id LIMIT 1];
            system.debug(lstRelation);
            AccountContactRelation ojbAccountContactRelation = lstRelation.get(0);
            ojbAccountContactRelation.Roles = 'Representante Legal';
            update ojbAccountContactRelation;
        }

        
        Test.startTest();
            COM_LogicaVinculacionClienteGC_cls clsA = new COM_LogicaVinculacionClienteGC_cls();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK2, 200, 'OK');
            //COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseError, 500, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            try{clsA.procesarVinculacion(o.Id);}
            catch(Exception e){}
        Test.stopTest();
    }
}