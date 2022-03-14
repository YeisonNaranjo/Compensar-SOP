/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_Account_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/08/17             Cristian David Mejia (CM)             Creación Clase.
    2.0     19/01/18             Brisleydi Calderon (BC)               Se agregó método test_method_tree para requerimiento NOLA - 2220
************************************************************************************************/
@isTest
private class COM_Account_tst
{
    private static Account objAcc, objAcc2, objAcc3;
    private static User objUser;
    private static String responseOK;
    private static String responseError;

    public static void createData(){
        List<Contact> lstContact = new List<Contact>();
        objUser = [Select Id FROM User WHERE  NOT UserRole.Name like '%PAF%' Limit 1];
        objAcc = COM_DataGenerator_cls.crearCuenta(false);
        objAcc2 = COM_DataGenerator_cls.crearCuenta2(false);
        String faseProyecto = System.Label.COM_FaseProyecto;
        responseOK = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "2017-09-27T15:21:19.837-05:00","ResponseDate": "2017-09-27T15:21:20.508-05:00","ResponseCode": "1","ResponseDesc": "OK","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "98765432","IdCliente": "12345679012345"},"atributosComunes": ""}}}';
        responseError = '{"Error":"Error"}';
    }

    public static testMethod void test_method_one(){
        createData();
        Test.startTest();

            objAcc3 = COM_DataGenerator_cls.insertarAccAnonima(true);

            objAcc.COM_TipoIdentificacion__c    = '2';
            objAcc.COM_Numero_de_identificacion__c = '123456789';
            objAcc.Name = 'Empresa';
            objAcc.COM_Digitoverificacion__c = COM_Account_cls.GenerarDigitoNit(objAcc.COM_Numero_de_identificacion__c);

            COM_AccountContactRelation_cls.stopTrigger();
            insert objAcc;
            COM_AccountContactRelation_cls.startTrigger();

            objAcc = [SELECT COM_Digitoverificacion__c FROM Account WHERE Id =: objAcc.Id];
            System.assertEquals(objAcc.COM_Digitoverificacion__c, 6);
           
            objAcc.COM_Numero_de_identificacion__c = '0';
            objAcc.COM_Digitoverificacion__c = COM_Account_cls.GenerarDigitoNit(objAcc.COM_Numero_de_identificacion__c);
            
            COM_AccountContactRelation_cls.stopTrigger();
            update objAcc;
            COM_AccountContactRelation_cls.startTrigger();
            
            objAcc = [SELECT COM_Digitoverificacion__c FROM Account WHERE Id =: objAcc.Id];
            System.assertEquals(objAcc.COM_Digitoverificacion__c, 0);
            
            objAcc.COM_TipoIdentificacion__c    = '1';
            objAcc.COM_Numero_de_identificacion__c  = '98765432';
            objAcc.COM_Primernombre__c = 'Nombre';
            objAcc.COM_Otrosnombres__c = 'Nombre';
            objAcc.COM_Primerapellido__c = 'Apellido';
            objAcc.COM_Segundoapellido__c = 'Apellido';
            objAcc.COM_Digitoverificacion__c = COM_Account_cls.GenerarDigitoNit(objAcc.COM_Numero_de_identificacion__c);

            COM_AccountContactRelation_cls.stopTrigger();
            update objAcc;
            COM_AccountContactRelation_cls.startTrigger();

            objAcc = [SELECT COM_Digitoverificacion__c FROM Account WHERE Id =: objAcc.Id];
            System.assertEquals(objAcc.COM_Digitoverificacion__c, 8);

            objAcc.COM_Fecharadicacioncartaretiro__c = date.newInstance(2017, 9, 27);
            List<Account> lstNewRecords = new List<Account>();
            lstNewRecords.add(objAcc);
            new COM_Account_cls().calcularFechaPazYSalvo(lstNewRecords);

            COM_AccountContactRelation_cls.stopTrigger();
            update objAcc;
            COM_AccountContactRelation_cls.startTrigger();

            objAcc = [SELECT COM_DiasFaltantesRetencion__c, COM_FechaLimiteRetencion__c FROM Account WHERE Id =: objAcc.Id];
            Integer dias = COM_Utilidades_cls.calculateDaysBetweenFechas(objAcc.COM_FechaLimiteRetencion__c, System.today());
            //System.assertEquals(objAcc.COM_DiasFaltantesRetencion__c, dias);
            //System.assertEquals(objAcc.COM_FechaLimiteRetencion__c, date.newInstance(2017, 12, 26));

            COM_CalloutGenericRestMock_tst tstMockError = new COM_CalloutGenericRestMock_tst(responseError, 400, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMockError);
            objAcc.COM_NAUTCLI__c = '12345679012345';

            COM_AccountContactRelation_cls.stopTrigger();
            update objAcc;
            COM_AccountContactRelation_cls.startTrigger();

            COM_CalloutGenericRestMock_tst tstMockOK = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMockOK);
            COM_AccountContactRelation_cls.stopTrigger();
            update objAcc;
            COM_AccountContactRelation_cls.startTrigger();

            objAcc.COM_No_procesado_On_Line__c = true;
            COM_AccountContactRelation_cls.stopTrigger();
            update objAcc;
            COM_AccountContactRelation_cls.startTrigger();

        Test.stopTest();
    }
    public static testMethod void test_method_two(){
        createData();
        String responseOK = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "1234"},"atributosComunes": ""}}}';
        String responseError = '';
    
        Test.startTest();
            COM_Account_cls clsA = new COM_Account_cls();
            List<Account> lstNewRecords = new List<Account>();
            List<Account> lstOldRecords = new List<Account>();
            lstNewRecords.add(objAcc);
            lstOldRecords.add(objAcc);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.COM_LabelPersonaNatural).getRecordTypeId();
            objAcc.COM_Primernombre__c = 'n1';
            objAcc2.COM_Primernombre__c = 'n2';
            objAcc.COM_Primerapellido__c = 'p1';
            objAcc2.COM_Primerapellido__c = 'p2';
            objAcc.COM_TipoIdentificacion__c = '1';
            objAcc.COM_Numero_de_identificacion__c = '11';
            objAcc2.COM_TipoIdentificacion__c = '1';
            objAcc2.COM_Numero_de_identificacion__c = '11';
            objAcc.Name = 'n1';
            objAcc2.Name = 'n2';
            objAcc.COM_Otrosnombres__c = 'o';
            objAcc.COM_Segundoapellido__c = 's';
            objAcc.COM_NAUTCLI__c = '';

            lstNewRecords.add(objAcc2);
            lstOldRecords.add(objAcc2);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            insert objAcc;
            //insert objAcc2;
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            lstNewRecords.add(objAcc);        
            lstOldRecords.add(objAcc);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            objAcc2.COM_Direccion__c = null;
            lstOldRecords.add(objAcc2);
            objAcc.COM_Direccion__c = '';
            lstNewRecords.add(objAcc);  
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            update objAcc;
            //update objAcc2;
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            objAcc.COM_No_procesado_On_Line__c = true;
            update objAcc;
            clsA.GenerarDigitoNit(null, lstNewRecords);
            clsA.actualizarName(lstNewRecords);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            objAcc.COM_No_procesado_On_Line__c = true;
            update objAcc;
            lstNewRecords.add(objAcc);        
            lstOldRecords.add(objAcc);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
            COM_CalloutGenericRestMock_tst tstMock2 = new COM_CalloutGenericRestMock_tst(responseError, 400, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock2);
            clsA.actualizarClientesGC(lstOldRecords, lstNewRecords);
        Test.stopTest();
    }


    public static testMethod void test_method_tree(){
        createData();
        //String responseOK = '{"CustomerMng_CrearClienteResponse": {"Header": {"RequestDate": "1","ResponseDate": "1","ResponseCode": "1","ResponseDesc": "1","TransactionID": ""},"Body": {"Cliente": {"TipoIdentificacion": "1","NumeroIdentificacion": "14243965","IdCliente": "1234"},"atributosComunes": ""}}}';
        String responseOK2 = '{"CustomerMng_ConsultaCliente_Response":{"Header":{"RequestDate":"2017-08-31T16:14:37.564-05:00","ResponseDate":"2017-08-31T16:14:37.9-05:00","ResponseCode":"0","ResponseDesc":"OK","TransactionID":"99999912345"},"Body":{"Vinculacion":{"AfiliadoCaja":"false","AfiliacionConResponsable":"false","AfiliadoSalud":"false","AfiliadoPLC":"false"},"Cliente":{"TipoIdentificacion":"1","NumeroIdentificacion":"1","Id":"9999803423702961","datosPersona":{"nombrePrimero":"JESUS","nombreSegundo":"","apellidoPrimero":"OVIEDO","apellidoSegundo":"","nombre":"JESUSOVIEDO","foneticoID":"19480615OVIEDOJESUS","nuip":"","Familia":"","demografia":{"nacimientoFecha":"1948-06-15T00:00:00","nacimientoLugar":"","genero":"M","estadoCivil":"SO","gradoEscolaridad":"","TitulosObtenidos":"","OficiosProfesiones":"","OtrosEstudios":""},"categoriaAfiliacion":"","estadoAfiliacion":"D","motivoInactivacion":{"id":"21"}},"Sucursal":{"sucursal":[{"id":"","sucursalID":"0","nivelAdicional":"D","razonSocial":"","mantenimiento":""}]},"comunicacionesCliente":{"comunicacionCliente":[{"telefonos":{"telefonoComunicacion":[{"tipoTelefono":"1","telefono":"3560170","extensionTelefono":"0"}]},"domicilios":{"domicilioComunicacion":[{"barrio":".","tipoDomicilio":"","domicilio":"CALLE34#7ESTE99BL20CS14","codigoPostal":"-","localidad":{},"tipoAreaGeografica":"U"}]},"correosElectronicos":{"correoElectronico":["NACESARITO3X@XYAHOO1.COM"]},"celulares":{"celular":["7104836645"]},"redesSociales":"","opTinEmail":"true","opTinSMS":"true","adicionalesContacto":{"borradoEstado":"A","identificador":"1006010","orden":"1","zonaBogota":"0"}}]},"Contacto":"","Afiliacion":{"afiliacion":[{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803431968415","nombre":"MARIADEJESUSRAMOSALDANA","legalID":"39714350","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2000-11-30T00:00:00","ingresoEmpresaFecha":"1998-10-16T00:00:00","inicioFecha":"1998-10-16T00:00:00","retiroFecha":"2000-11-30T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811432","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""},{"beneficiarios":"","cantidadVinculacion":"0","categoriaAfiliacion":"","motivoRetiro":{"id":"1","nombre":"-"},"ClienteResponsable":{"clienteResponsable":[{"tipoResponsable":"1","id":"9999803465819992","nombre":"BLANCALEONORZAMUDIO","legalID":"41543226","tipoIdentificacion":"1"},{"tipoResponsable":"2","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"3","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"},{"tipoResponsable":"4","id":"0","nombre":"","legalID":"0","tipoIdentificacion":"0"}]},"cmnt":"H","actualizadoEstado":"false","nuevoEstado":"false","estado":"1","finFecha":"2001-05-01T00:00:00","ingresoEmpresaFecha":"2000-05-10T00:00:00","inicioFecha":"2000-05-10T00:00:00","retiroFecha":"2001-05-01T00:00:00","soloServicio":"0","textoVinculacion":"","valorVinculacion":"0","variableRetiro":"CRETHIJ","Programa":{"programa":[{"condicion":"3","diasPaHisto":"0","tipoRadicacion":"0","edadReAuto":"0","genNuevoRadicadoEstado":"false","grupo":"0","id":"10321","programaPadre":"1021","indicadorProgramaEstado":"0","indicadorVinculacionEstado":"0","manejaResponsable1PersonaEstado":"false","manejaResponsable2EmpresaEstado":"false","motivoRetiroOpcional":{"id":"1","nombre":"VoluntarioportrasladodeCaja"},"clientePropietarioID":"0","tipoParentesco":"HI","sigla":"CJ","tipoIdClientePropietario":"0","nombrePrograma":"HijosdeTrabajadorDependiente","nombreProgramaPadre":"","diasParaReactivacion":"0"}]},"id":"2811494","motivoInactivacion":{"id":"21"},"estadoAfiliacion":"1","clienteID":""}]},"Radicacion":""},"atributosComunes":{"beneficiarioEstado":"false","empresaEstado":"false","saltarFoneticoEstado":"false","indice":"0","edadMayor":"false"}}}}';
        String responseError = '';
    
        Test.startTest();
            List<Account> lstNewRecords = new List<Account>();

            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK2, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.COM_LabelPersonaNatural).getRecordTypeId();
            objAcc.COM_Primernombre__c = 'n1';
            objAcc.COM_Primerapellido__c = 'p1';
            objAcc.COM_TipoIdentificacion__c = '1';
            objAcc.COM_Numero_de_identificacion__c = '900781662';
            objAcc.Name = 'n1';
            objAcc.COM_Otrosnombres__c = 'o';
            objAcc.COM_Segundoapellido__c = 's';
            objAcc.COM_NAUTCLI__c = '';
            objAcc.COM_Direccion__c = 'Prueba de dirección88'; 
            
            lstNewRecords.add(objAcc);

            COM_Account_cls.buscarDireccionCuenta(lstNewRecords);

           
            //COM_CalloutGenericRestMock_tst tstMock2 = new COM_CalloutGenericRestMock_tst(responseError, 400, 'OK');
            //Test.setMock(HttpCalloutMock.class, tstMock2);
            
        Test.stopTest();
    }

     @istest
    public static void validarDuplicadosCA_tst(){
        
		Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '12345678909';
        objCuenta.COM_Estadoafiliacion__c = '1';
        insert objCuenta;
        
        
        //COM_TriggerExecutionControl_cls.ExecutedTriggers_set.remove( 'COM_Account_tgr' + 'Before' );
        COM_TriggerExecutionControl_cls.ExecutedTriggers_set.remove( 'COM_Account_tgr' + 'BeforeInsert' );
        
        COM_TriggerExecutionControl_cls.ExecutedTriggers_set.remove( 'COM_Account_tgr' + 'AfterInsert' );
        	
        
        
         Account objCuenta2 = new Account();
          objCuenta2.Name = 'PruebaFinal';
          objCuenta2.AccountNumber = '654331';
          objCuenta2.BillingStreet = 'Calle 1a38';
          objCuenta2.CEL1_OrigenEsProspecto__c = true;
          objCuenta2.BillingCountry = 'Colombia';
          objCuenta2.BillingState = 'Cundinamarca';
          objCuenta2.COM_CorreoElectronico__c = 'testtt@hotmail.com';
          objCuenta2.COM_TipoIdentificacion__c = '1';
          objCuenta2.COM_Numero_de_identificacion__c = '12345678909';
          objCuenta2.COM_FechaLimiteRetencion__c = System.today();
       

        Test.startTest();
        List<Account> lstCuentasNew = new List<Account>();
		lstCuentasNew.add(objCuenta2);
        COM_Account_cls cls = new COM_Account_cls();
        cls.validarDuplicadosCA(lstCuentasNew);
        
        Test.stopTest();
        

    }
    
    @istest
    public static void asignarPropietarioCandidatoCA_tst(){
        
		User objUser = [SELECT Id,ProfileId FROM User WHERE IsActive = true AND Profile.Name = 'Administrador del sistema' LIMIT 1];
        
        COM_Asignacion__c objAsignacion         =   new COM_Asignacion__c();
        objAsignacion.COM_FechaAsignacion__c    =   System.now();
        objAsignacion.COM_perfil__c             =   'Asesor - PAF';
        objAsignacion.COM_Usuario__c            =   objUser.Id;
        objAsignacion.CEL1_Asignado__c          =   false;
        insert objAsignacion;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Paula';
        objCandidato.MiddleName                 =   'Bohorquez';
        objCandidato.LastName                   =   'Alfonso';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '12345678909';
        objCandidato.CEL1_OrigenEsProspecto__c    =   true;
        objCandidato.Email                      =   'prueba@pruebap.com';
        insert objCandidato;
		
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_Primernombre__c = 'Pepe';
        objCuenta.COM_Primerapellido__c = 'Perez';
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '12345678909';
        objCuenta.COM_Estadoafiliacion__c = '1';
        objCuenta.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        objCuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('COM_Natural').getRecordTypeId();
		
        insert objCuenta;
        
		COM_DataGenerator_cls.crearContacto(true, objCuenta.Id);
        
       // COM_TriggerExecutionControl_cls.ExecutedTriggers_set.remove( 'COM_Account_tgr' + 'BeforeInsert' );
       
        User objUser2 = [SELECT Id,ProfileId FROM User WHERE IsActive = true AND Profile.Name = 'Asesor - PAF' LIMIT 1];
        AccountTeamMember objAccTM = new AccountTeamMember();
        objAccTM.AccountId = objCuenta.Id;
        objAccTM.AccountAccessLevel         =   'Edit';
        objAccTM.CaseAccessLevel            =   'Edit';
        objAccTM.OpportunityAccessLevel     =   'Edit';
        objAccTM.TeamMemberRole             =   'COM_AuxiliarAdministrativoPAF';
        objAccTM.UserId                     =   objUser2.Id;
        insert objAccTM;

        Test.startTest();
        COM_TriggerExecutionControl_cls.ExecutedTriggers_set.remove( 'COM_Account_tgr' + 'BeforeUpdate' );
        COM_TriggerExecutionControl_cls.ExecutedTriggers_set.remove( 'COM_Account_tgr' + 'AfterUpdate' );
        
        System.runAs(objUser){
			objCuenta.COM_Estadoafiliacion__c = '0';
        	update objCuenta;
        }
        Test.stopTest();        

    }

}