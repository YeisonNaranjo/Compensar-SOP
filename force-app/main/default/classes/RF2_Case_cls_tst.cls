@isTest
private class RF2_Case_cls_tst {
    
    private static void createData(Id idCuenta){
        List<RF2_ConfAudCasos__mdt> ojbLst = [SELECT DeveloperName,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c FROM RF2_ConfAudCasos__mdt];
        
        RF2_ContAudCasos__c conf = new RF2_ContAudCasos__c();
        conf.Name = '1';
        conf.RF2_ConEnvioCasoCalidadGIE__c = ojbLst.get(0).RF2_RecEnvioCalidadGIE__c;
        conf.RF2_ConEnvioCasoCalidadPCE__c = ojbLst.get(0).RF2_RecEnvioCalidadPCE__c;
        conf.RF2_ConEnvioSondeoPCE__c = ojbLst.get(0).RF2_RecEnvioSondeoPCE__c;
        insert conf;
        
        //Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
        
        Entitlement ent = new Entitlement();
        ent.AccountId = idCuenta;
        ent.Name = Label.RF2_NombreANSGenerico_lbl;
        ent.RF2_Canal__c = 'Call Center';
        ent.Rf2_GCN__c = 'Otros';
        ent.RF2_ObligatorioCalidad__c = false;
        insert ent;
        
        
        // crear mas entittlements para completar
        
        /*List<Entitlement> entitlementListGen = [SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSGenerico_lbl];
if(entitlementListGen.isEmpty())
system.debug('no hay nada niño!! ');*/
        
        
    }



    
    @isTest static void test_method_1() {

        Account acc = COM_DataGenerator_cls.crearCuenta(true);        
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        Test.startTest();
        DescribeFieldResult describe = Case.RF2_ProcesoDestinoMatrizResponsable__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();        
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        createData(acc.Id);        
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);
        Test.stopTest();
    }
    
    @isTest static void test_method_2() {
        Test.startTest();
        //createData();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Queja', 'URL PCE', 'Alimentos', 'Aportes', 'Pagina Web', false);
        Test.stopTest();
    }
    
    @isTest static void test_method_3() {
        Test.startTest();
        //createData();
        RF2_Case_cls ppp = new RF2_Case_cls();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Empresarial', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', false);
        Test.stopTest();
    }
    
    @isTest static void test_method_4() {
        Test.startTest();
        //createData();
        RF2_Case_cls ppp = new RF2_Case_cls();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cona = new Contact();
        cona.FirstName = 'Pepe';
        cona.LastName = 'Perez';
        cona.AccountId = acc.Id;
        cona.Email = 'pruebas@micorreo.com';
        cona.COM_TipoIdentificacion__c = '1';
        cona.COM_Numeroidentificacion__c = '12345678909';
        insert cona;
        //Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cona.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', true);
        caso.Status ='Gestión';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
        caso.RF2_Negocio__c =  'Gestion de Informacion Empresarial';
        caso.RF2_Programa__c = 'Empresarial';       
        caso.RF2_Servicio__c =  'Aclaraciones';
        caso.RF2_AsuntoCOM__c =  'Análisis datos de vinculación y aportes';
        
        update caso;
        caso.RF2_Negocio__c =  'Gestion de Informacion Empresarial';
        caso.RF2_Programa__c = 'Empresarial';      
        caso.RF2_Servicio__c =  'Aclaraciones';
        caso.RF2_AsuntoCOM__c =  'Análisis datos de vinculación y aportes';
        caso.RF2_Responsable_de_la_Omision__c = 'Error del cliente';
        caso.Status ='Solucionado';
        update caso;
        Test.stopTest();
    }
    
    @isTest static void test_method_5() {
        Test.startTest();
        
        RF2_Case_cls ppp = new RF2_Case_cls();
        ppp.calcularFechaPazYSalvo(null, new List<Case>{new Case(RF2_RelacionadoCon__c = Label.RF2_AsuntoGenerarPazYSalvo_lbl)});
        RF2_Case_cls.stopTrigger();
        RF2_Case_cls.canIRun();
        RF2_Case_cls.startTrigger();
        Test.stopTest();     
    }
    
    @isTest static void test_method_6() {
        
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        
        createData(acc.Id);
        
        //Crear Analistas de Calidad
        User objUser;
        objUser = [Select Id, UserRole.Name FROM User WHERE  IsActive = true and UserRole.Name ='Analista PCA' Limit 1];
        RF2_ConfiguracionAnalistasCalidad__c AnalistaCalidad = new RF2_ConfiguracionAnalistasCalidad__c();
        AnalistaCalidad.RF2_FechaAsignacion__c = DateTime.newInstance(2018, 3, 16, 12, 6, 13);
        AnalistaCalidad.RF2_Usuario__c = objUser.Id;
        AnalistaCalidad.RF2_Proceso__c = 'GIE';
        Insert AnalistaCalidad;
        
        Case casoPadre =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Empresarial', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', false);
        Case casoHijo = new Case();
        casoHijo.ContactId = cont.Id;
        casoHijo.AccountId = acc.Id;
        casoHijo.Origin = 'Correo Electronico';
        casoHijo.Status = 'Abierto';
        casoHijo.RF2_GrupoCicloNegocio__c = 'Aportes';
        casoHijo.RF2_TipoSolicitud__c = 'Solicitud GIE';
        casoHijo.RF2_ProcesoDestinoMatrizResponsable__c = 'Empresarial';
        casoHijo.RF2_RelacionadoCon__c = 'Traslado de Aportes';
        casoHijo.RF2_SolucionadoPrimerContacto__c = true;
        casoHijo.ParentId = casopadre.Id;
        casoPadre.Status = 'Gestión';
        casoPadre.RF2_TipoCierre__c = 'Exitoso';
        update casoPadre;
        casoPadre.RF2_MedioRespuesta__c = 'Correo Electronico';
        casoPadre.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
        casoPadre.RF2_TipoCierre__c = 'Exitoso';
        casoPadre.RF2_Negocio__c =  'Gestion de Informacion Empresarial';
        casoPadre.RF2_Programa__c = 'Empresarial';      
        casoPadre.RF2_Servicio__c =  'Aclaraciones';
        casoPadre.RF2_AsuntoCOM__c =  'Análisis datos de vinculación y aportes';
        casoPadre.RF2_Responsable_de_la_Omision__c = 'Error del cliente';
        casoPadre.Status = 'Solucionado';
		casoPadre.RF2_Cantidad_de_registros__c  = 1;
        Test.startTest();
        update casoPadre;
        Test.stopTest();    
    }
    
    /* @isTest static void test_method_7() {
Test.startTest();

Case casoHijo = new Case();
casoHijo.Origin = 'Pagina Web';
casoHijo.Status = 'Abierto';
casoHijo.Subject = 'el subject';
casoHijo.RF2_CorreoElectronicoHuerfano__c = 'name@avanxo.com';
casoHijo.RF2_NombreContactoHuerfano__c = 'name';
casoHijo.RF2_GrupoCicloNegocio__c = 'Aportes';
casoHijo.RF2_TipoSolicitud__c = 'Solicitud GIE';
casoHijo.RF2_ProcesoDestinoMatrizResponsable__c = 'Empresarial';
casoHijo.RF2_RelacionadoCon__c = 'Traslado de Aportes';
casoHijo.RF2_SolucionadoPrimerContacto__c = true;
insert casoHijo;
casoHijo.Status = 'Gestión';
update casoHijo;
casoHijo.RF2_MedioRespuesta__c = 'Correo Electronico';
casoHijo.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
casoHijo.RF2_TipoCierre__c = 'Exitoso';
casoHijo.RF2_Negocio__c =  'Alimentos';
casoHijo.RF2_Programa__c = 'Restaurante';       
casoHijo.RF2_Servicio__c =  'Preguntas generales';
casoHijo.RF2_AsuntoCOM__c =  'Horarios';
casoHijo.RF2_Responsable_de_la_Omision__c = 'Error Interno';
casoHijo.Status = 'Solucionado';
update casoHijo;
Test.stopTest();
}*/
    @isTest static void test_method_8() {
        Test.startTest();
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Case casoHijo2 = new Case();
        casoHijo2.AccountId = acc.Id;
        casoHijo2.Origin = 'Pagina Web';
        casoHijo2.Status = 'Abierto';
        casoHijo2.Subject = 'el subject';
        casoHijo2.RF2_GrupoCicloNegocio__c = 'Aportes';
        casoHijo2.RF2_TipoSolicitud__c = 'Solicitud GIE';
        casoHijo2.RF2_ProcesoDestinoMatrizResponsable__c = 'Empresarial';
        casoHijo2.RF2_RelacionadoCon__c = 'Traslado de aportes a otras CCF';
        casoHijo2.RF2_SolucionadoPrimerContacto__c = true;
        insert casoHijo2;
        casoHijo2.Status = 'Gestión';
        update casoHijo2;
        casoHijo2.RF2_MedioRespuesta__c = 'Correo Electronico';
        casoHijo2.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
        casoHijo2.RF2_TipoCierre__c = 'Exitoso';
        casoHijo2.RF2_Negocio__c =  'Gestion de Informacion Empresarial';
        casoHijo2.RF2_Programa__c = 'Empresarial';      
        casoHijo2.RF2_Servicio__c =  'Aclaraciones';
        casoHijo2.RF2_AsuntoCOM__c =  'Análisis datos de vinculación y aportes';
        casoHijo2.RF2_Responsable_de_la_Omision__c = 'Error del cliente';
        casoHijo2.Status = 'Solucionado';
        update casoHijo2;
        Test.stopTest();
    }
    
    /* @isTest static void test_method_9() {
Test.startTest();
Account anon = COM_DataGenerator_cls.insertarAccAnonima(true);
Contact con = COM_DataGenerator_cls.crearContacto(false, anon.Id);
con.COM_TipoIdentificacion__c = '1';
con.COM_Numeroidentificacion__c = '9999'; 
insert con;
Case casoHijo3 = new Case();
casoHijo3.RF2_CorreoElectronicoHuerfano__c = 'asd@avanxo.com';
casoHijo3.RF2_NombreContactoHuerfano__c = 'el name';
casoHijo3.Origin = 'Pagina Web';
casoHijo3.Subject = 'el subject';
casoHijo3.Status = 'Abierto';
casoHijo3.RF2_GrupoCicloNegocio__c = 'Aportes';
casoHijo3.RF2_TipoSolicitud__c = 'Solicitud GIE';
casoHijo3.RF2_ProcesoDestinoMatrizResponsable__c = 'Empresarial';
casoHijo3.RF2_RelacionadoCon__c = 'Traslado de Aportes';
casoHijo3.RF2_Anonimo__c = true;
insert casoHijo3;
casoHijo3.Status = 'Gestión';
update casoHijo3;
casoHijo3.RF2_MedioRespuesta__c = 'Correo Electronico';
casoHijo3.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
casoHijo3.RF2_TipoCierre__c = 'Exitoso';
casoHijo3.RF2_Negocio__c =  'Alimentos';
casoHijo3.RF2_Programa__c = 'Restaurante';      
casoHijo3.RF2_Servicio__c =  'Preguntas generales';
casoHijo3.RF2_AsuntoCOM__c =  'Horarios';
casoHijo3.Status = 'Solucionado';
//update casoHijo3;
Test.stopTest();
}*/
    
    @isTest static void test_method_10() {
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Queja', 'URL PCE', 'Alimentos', 'Aportes', 'Pagina Web', false);
        Set<String> s = new Set<String>();
        List<Case> lc = new List<Case>();
        s.add(caso.Id);
        lc.add(caso);
        
        Test.startTest();
        RF2_Case_cls.procesarPDF(caso.Id);
        RF2_Case_cls.procesarPDFNoExitosoGIE(caso.Id);        
        RF2_Case_cls.cerrarHitoAnterior(s);
        RF2_Case_cls.copiarFechaAns(s);
        Test.stopTest();
    }
    
    /* @isTest static void test_method_11() {

COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
Account acc = COM_DataGenerator_cls.crearCuenta(true);
Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
createData(acc.Id);
Case casoPadre =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, '', '', '', 'Aportes', 'Correo Electrónico', false);
//Case casoPadre =  COM_DataGenerator_cls.crearCaso(false, acc.Id, cont.Id);
//casoPadre.Origin = 'Correo Electrónico';
casoPadre.Status = Label.RF2_EstadoCerradoCaso_lbl;
casoPadre.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
insert casoPadre;
//casoPadre.RF2_ExcluidoCalidad__c = true;
//
Test.startTest(); 

update casoPadre;
Test.stopTest();
/List<Case> lc = new List<Case>();
lc.add(casoPadre);
RF2_Case_cls c = new RF2_Case_cls();
Test.startTest(); 
c.AsignarResponsableCaso(lc, lc);
Test.stopTest();   
}*/
    
    
    @isTest static void test_method_12() {
        
        Account anon = COM_DataGenerator_cls.insertarAccAnonima(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, anon.Id);
        con.COM_TipoIdentificacion__c = '1';
        con.COM_Numeroidentificacion__c = '9999'; 
        insert con;

        //Case casoAnonimo = COM_DataGenerator_cls.crearCasoAnonimo(true, anon.Id);
        Case casoAnonimo = new Case();
        casoAnonimo = new Case();
        //caso.ContactId = idContacto;
        casoAnonimo.AccountId = anon.Id;
        casoAnonimo.Origin = 'Call Center';
        casoAnonimo.Status = 'Abierto';
        casoAnonimo.RF2_GrupoCicloNegocio__c = 'Aportes';
        casoAnonimo.RF2_TipoSolicitud__c = 'Queja';
        casoAnonimo.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        casoAnonimo.RF2_RelacionadoCon__c = 'Agencia de empleo';
        casoAnonimo.RF2_Anonimo__c = true;
        casoAnonimo.RF2_SolucionadoPrimerContacto__c = true;
		insert casoAnonimo;
        casoAnonimo.RF2_SolucionadoPrimerContacto__c = true;
        update casoAnonimo;
        //Crear Analistas de Calidad
        User objUser;
        objUser = [Select Id, UserRole.Name FROM User WHERE  IsActive = true and UserRole.Name ='Analista PCA' Limit 1];
        System.debug('Stif ' + objUser);
        RF2_ConfiguracionAnalistasCalidad__c AnalistaCalidad = new RF2_ConfiguracionAnalistasCalidad__c();
        AnalistaCalidad.RF2_FechaAsignacion__c = DateTime.newInstance(2018, 3, 16, 12, 6, 13);
        AnalistaCalidad.RF2_Usuario__c = objUser.Id;
        AnalistaCalidad.RF2_Proceso__c = 'PCE';
        Insert AnalistaCalidad;
        Test.startTest();



        casoAnonimo.RF2_MedioRespuesta__c = 'Correo Electronico';
        casoAnonimo.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
        casoAnonimo.RF2_TipoCierre__c = 'Exitoso';
        //casoAnonimo.RF2_Negocio__c =  'Alimentos';
        //casoAnonimo.RF2_Programa__c = 'Restaurante';      
       // casoAnonimo.RF2_Servicio__c =  'Preguntas generales';
       // casoAnonimo.RF2_AsuntoCOM__c =  'Horarios';
        CasoAnonimo.RF2_EsGIE__c = true;
        CasoAnonimo.RF2_CorreoElectronicoRespuesta__c = 'pruebas@hotmail.com';
        casoAnonimo.RF2_Cantidad_de_registros__c = 50;
        casoAnonimo.Status = 'Solucionado';
        update casoAnonimo;

        Test.stopTest();
    }

    
    
    
    @isTest static void test_method_13() {
        
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        
        createData(acc.Id);
        
        //Crear Analistas de Calidad
        User objUser;
        objUser = [Select Id, UserRole.Name FROM User WHERE  IsActive = true and UserRole.Name ='Analista PCA' Limit 1];
        RF2_ConfiguracionAnalistasCalidad__c AnalistaCalidad = new RF2_ConfiguracionAnalistasCalidad__c();
        AnalistaCalidad.RF2_FechaAsignacion__c = DateTime.newInstance(2018, 3, 16, 12, 6, 13);
        AnalistaCalidad.RF2_Usuario__c = objUser.Id;
        AnalistaCalidad.RF2_Proceso__c = 'PCE';
        Insert AnalistaCalidad;
		
		/*::CV INICIO*/
		RF2_SubdireccionSalidaOyS__c Ss= new RF2_SubdireccionSalidaOyS__c();
		Ss.name='Bienestar';
		Ss.RF2_Codigo__c = 'SUBDIR_0001';
		Ss.RF2_Busqueda__c= 'Todos';
		insert Ss;
		
		RF2_ProcesoSalidaOyS__c Ps = new RF2_ProcesoSalidaOyS__c();
		Ps.Name = 'Recreación, Educación y Deportes';
		Ps.RF2_Codigo__c='PROC_0007';
		Ps.RF2_Busqueda__c='Todos';
        Ps.RF2_SubdireccionSalidaOyS__c =Ss.id;
		insert Ps;
		
		RF2_SubprocesoLinea__c  Sbp = new  RF2_SubprocesoLinea__c();
		Sbp.Name='Deportes';
		Sbp.RF2_Codigo__c='SUBPROC_0038';
		Sbp.RF2_ProcesoSalidaOyS__c = Ps.id;
		Sbp.RF2_Busqueda__c= 'Todos';
		insert Sbp;
		
		RF2_ProgramaAreaSalidaOyS__c PrAr = new RF2_ProgramaAreaSalidaOyS__c();
		PrAr.Name = 'Aco';
		PrAr.RF2_Codigo__c = 'PROG_0096';
		PrAr.RF2_SubprocesoLinea__c = Sbp.id;
		PrAr.RF2_Busqueda__c='Todos';
		insert PrAr;
		
		RF2_CausalSalida__c CauSal = new  RF2_CausalSalida__c();
		CauSal.Name ='acd';
		CauSal.RF2_Codigo__c='Causal9898';
		CauSal.RF2_ProcesoSalidaOyS__c=Ps.id;
		CauSal.RF2_Busqueda__c='Todos';
		insert CauSal;
		
		RF2_ComplejidadSalidaOyS__c Compl = new RF2_ComplejidadSalidaOyS__c();
		Compl.Name ='sdsd';
		Compl.RF2_Codigo__c='dfdfddfs';
		Compl.RF2_CausalSalida__c=CauSal.id;
		Compl.RF2_Busqueda__c='Todos';
		insert Compl;
		
		RF2_FasesClienteSalidaOyS__c fasCli = new RF2_FasesClienteSalidaOyS__c();
		fasCli.name ='Carlosv';
		fasCli.RF2_Codigo__c ='sdsd87';
		fasCli.RF2_CausalSalida__c = CauSal.id;
		insert fasCli;
		
		RF2_EjeSalidaOyS__c ejeSal = new RF2_EjeSalidaOyS__c();
		ejeSal.name='sdsds';
		ejeSal.RF2_Codigo__c ='EJE_0470';
		ejeSal.RF2_Busqueda__c ='Tros';
        ejeSal.RF2_CausalSalida__c =CauSal.id;
		insert ejeSal;
		
		RF2_ServiciosREDSalidaOyS__c ser = new RF2_ServiciosREDSalidaOyS__c();
		ser.name='gim';
		ser.RF2_Codigo__c = 'Cod';
		ser.RF2_Busqueda__c ='Todos';
		insert ser;
		
		/*::CV INICIO*/
        
        Case casoPadre =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Empresarial', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', false);
        Case casoHijo = new Case();
        casoHijo.ContactId = cont.Id;
        casoHijo.AccountId = acc.Id;
        casoHijo.Origin = 'Correo Electronico';
        casoHijo.Status = 'Abierto';
        casoHijo.RF2_GrupoCicloNegocio__c = 'Aportes';
        casoHijo.RF2_TipoSolicitud__c = 'Solicitud GIE';
        casoHijo.RF2_ProcesoDestinoMatrizResponsable__c = 'Empresarial';
        casoHijo.RF2_RelacionadoCon__c = 'Traslado de Aportes';
        casoHijo.RF2_SolucionadoPrimerContacto__c = false;
        casoHijo.ParentId = casopadre.Id;
        casoHijo.RF2_EsPCE__c = true;
        casoHijo.RF2_EsGIE__c = false;
        casoHijo.RF2_Subdireccion__c = 'Bienestar';
        casoPadre.Status = 'Gestión';
        casoPadre.RF2_TipoCierre__c = 'Exitoso';
        casoPadre.RF2_EsPCE__c = true;
        casoPadre.RF2_EsGIE__c = false;
        update casoPadre;
        casoPadre.RF2_MedioRespuesta__c = 'Correo Electronico';
        casoPadre.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
        casoPadre.RF2_TipoCierre__c = 'Exitoso';
        casoPadre.RF2_Negocio__c =  'Alimentos';
        casoPadre.RF2_Programa__c = 'Restaurante';      
        casoPadre.RF2_Servicio__c =  'Aportes';
        casoPadre.RF2_AsuntoCOM__c =  'Devolución de Aportes';
        casoPadre.RF2_Responsable_de_la_Omision__c = 'Error Interno';
        casoPadre.RF2_SubdireccionL__c = Ss.id;
		casoPadre.RF2_ProcesoL__c = PS.id;
		casoPadre.RF2_SubprocesoLineaL__c = Sbp.id;
		casoPadre.RF2_Ciclos__c= 'Subsidio';
		casoPadre.RF2_ProgramaAreaL__c= PrAr.id;
		casoPadre.RF2_CausalSalidaL__c=CauSal.id;
		casoPadre.RF2_ComplejidadL__c=Compl.id;
		casoPadre.RF2_FaseClienteL__c=fasCli.id;
		casoPadre.RF2_EjesL__c= ejeSal.id;
		casoPadre.RF2_ServicioRED__c=ser.id;
		casoPadre.RF2_ConceptosOrganizaciones__c='Financiero';
		casoPadre.RF2_ImpactoOrganizacional__c='Servicio';
		casoPadre.RF2_ImpactoCliente__c='Esfuerzo Emocional';
		casoPadre.RF2_AfectacionEconomica__c='Si';
		casoPadre.RF2_Procedencia__c='Si';
		casoPadre.RF2_Procedencia2__c='Si';		
        casoPadre.Status = 'Solucionado';
        Test.startTest();
        try{update casoPadre;}catch(Exception e){}
        RF2_Case_cls claseCase = new RF2_Case_cls();
        claseCase.hijosAbiertos(casoPadre);
        claseCase.obtenerInfoPadre(casoPadre.id);
        Test.stopTest();    
    }

        @isTest static void test_method_14() {

            //-----------------------------------------------------------------------------------------------------------------------------------------
        
        Account anon = COM_DataGenerator_cls.insertarAccAnonima(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, anon.Id);
        con.COM_TipoIdentificacion__c = '1';
        con.COM_Numeroidentificacion__c = '9999'; 
        insert con;

        //Case casoAnonimo = COM_DataGenerator_cls.crearCasoAnonimo(true, anon.Id);
        Case casoAnonimo = new Case();
        casoAnonimo = new Case();
        //caso.ContactId = idContacto;
        casoAnonimo.AccountId = anon.Id;
        casoAnonimo.Origin = 'Call Center';
        casoAnonimo.Status = 'Cerrado';
        casoAnonimo.RF2_GrupoCicloNegocio__c = 'Aportes';
        casoAnonimo.RF2_TipoSolicitud__c = 'Solicitud GIE';
        casoAnonimo.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        casoAnonimo.RF2_RelacionadoCon__c = 'Aclaracion aportes empleadores, independientes y pensionados';
        CasoAnonimo.RF2_EsGIE__c = true;
        CasoAnonimo.RF2_EsPCE__c = true;
        casoAnonimo.RF2_Anonimo__c = true;
        casoAnonimo.RF2_SolucionadoPrimerContacto__c = true;
        casoAnonimo.RF2_MedioRespuesta__c = 'Correo Electronico';
        casoAnonimo.RF2_Cantidad_de_registros__c = 50;
        insert casoAnonimo;
        casoAnonimo.RF2_SolucionadoPrimerContacto__c = true;
        casoAnonimo.Status = 'Pendiente PDF Respuesta Cierre';
        CasoAnonimo.RF2_EsGIE__c = true;
        CasoAnonimo.RF2_EsPCE__c = true;
        update casoAnonimo;
        //Crear Analistas de Calidad
        User objUser;
        objUser = [Select Id, UserRole.Name FROM User WHERE  IsActive = true and UserRole.Name ='Analista GIE' Limit 1];
        System.debug('Andrés ==== '  +  CasoAnonimo.RF2_EsGIE__c);
        RF2_ConfiguracionAnalistasCalidad__c AnalistaCalidad = new RF2_ConfiguracionAnalistasCalidad__c();
        AnalistaCalidad.RF2_FechaAsignacion__c = DateTime.newInstance(2018, 3, 16, 12, 6, 13);
        AnalistaCalidad.RF2_Usuario__c = objUser.Id;
        AnalistaCalidad.RF2_Proceso__c = 'GIE';
        Insert AnalistaCalidad;
        Test.startTest();
System.debug('2. Andrés ==== '  +  CasoAnonimo.RF2_EsGIE__c);
        casoAnonimo.RF2_MedioRespuesta__c = 'Correo Electronico';
        casoAnonimo.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
        casoAnonimo.RF2_TipoCierre__c = 'Exitoso';
        //casoAnonimo.RF2_Negocio__c =  'Alimentos';
        //casoAnonimo.RF2_Programa__c = 'Restaurante';      
       // casoAnonimo.RF2_Servicio__c =  'Preguntas generales';
       // casoAnonimo.RF2_AsuntoCOM__c =  'Horarios';
        CasoAnonimo.RF2_EsGIE__c = true;
        CasoAnonimo.RF2_CorreoElectronicoRespuesta__c = 'pruebas@hotmail.com';
        casoAnonimo.RF2_Cantidad_de_registros__c = 50;
        casoAnonimo.Status = 'Cerrado';
		casoAnonimo.RF2_Colaborador__c = 'Colaborador';
        update casoAnonimo;

        Test.stopTest();
    }
    
   /* @isTest
    public static void  test_AsignarCasoACalidad(){
        
        RF2_Case_cls testedClass = new RF2_Case_cls();
        
        // Preparación para realiza pruebas - Inicio
        List<Case> lCaseParent = new List<Case>();
        	Case aParentCase = new Case();
        	aParentCase.RecordTypeId = '0126A0000005cdiQAA';
        	aParentCase.Status = 'Solucionado';
        	aParentCase.RF2_Anonimo__c = false;
        	aParentCase.RF2_EsGIE__c = true;
            aParentCase.origin = 'Asesor';
            aParentCase.Description = 'Descripcion';
            System.debug('Avx'+aParentCase);
        	Insert aParentCase;
        lCaseParent.add(aParentCase);
        List<Case> multipleCaseParent = new List<Case>();	
        multipleCaseParent.add(aParentCase);
        	aParentCase.Status = 'No Solucionado';
        multipleCaseParent.add(aParentCase);
        
        Account anAccount = new Account();
        	anAccount.name = 'Test Account';
        Insert anAccount;
        
        Entitlement aEntitlement = new Entitlement();
            aEntitlement.Name = 'ANS Hijo 16 horas - ASIG45';
            aEntitlement.RF2_ObligatorioCalidad__c = false;
        	aEntitlement.AccountId = anAccount.Id;
        Insert aEntitlement;
        
        List<Case> lCaseChildren = new List<Case>();
        	Case aChildCase = new Case();
        	aChildCase.ParentId = aParentCase.Id;
        	aChildCase.Status = 'Solucionado';
        	Insert aChildCase;
        lCaseChildren.add(aChildCase);
               
        testedClass.AsignarResponsableCaso(null, lCaseParent);
        List<Case> caseError = lCaseParent;
        //Preparación para realiza pruebas - Fin
        
        Test.startTest();
        
            //Prueba con un caso
            testedClass.AsignarCasoACalidad(null, lCaseParent);
        	testedClass.AsignarCasoACalidad(lCaseChildren, lCaseChildren);
        
        	//Multiples casos
            testedClass.AsignarCasoACalidad(null, multipleCaseParent);
            
            //Prueba con un caso y casos abiertos
            caseError.get(0).Status = 'Solucionado';
            testedClass.AsignarCasoACalidad(null, caseError);
            
            //Multiples Casos con casos abiertos
            caseError.add(aParentCase);
            testedClass.AsignarCasoACalidad(lCaseParent, caseError);
        
           	//Prueba caso anónimo
           	caseError.get(0).RF2_Anonimo__c = true;
            testedClass.AsignarCasoACalidad(lCaseParent, caseError);
        
        Test.stopTest();
    }*/
    
    @isTest
    public static void test_validarEnvioCalidad(){
        
        //Preparación para pruebas - Inicio
        RF2_Case_cls testedClass = new RF2_Case_cls();
        
        Case aCase = new Case();
        aCase.RF2_EsGIE__c = true;
        
        Case otherCase = new Case();
        otherCase.RF2_EsGIE__c = false;
        otherCase.RF2_EsPCE__c = true;
        
        Case aCase2 = new Case();
        aCase2.RF2_EsGIE__c = false;
        aCase2.RF2_EsPCE__c = false;
        
        RF2_ContAudCasos__c  contAudCasos = new RF2_ContAudCasos__c();
        	contAudCasos.Name = 'Conjunto1';
        	contAudCasos.RF2_ConEnvioCasoCalidadGIE__c = 0;
        	contAudCasos.RF2_ConEnvioCasoCalidadPCE__c = 0; 
        	contAudCasos.RF2_ConEnvioSondeoPCE__c = 0;
        Insert contAudCasos;
        //Preparación para pruebas - Fin
    
        testedClass.validarEnvioCalidad(aCase);
        testedClass.validarEnvioCalidad(otherCase);
        testedClass.validarEnvioCalidad(aCase2);
        	
        	contAudCasos.RF2_ConEnvioCasoCalidadGIE__c = 11;
        	contAudCasos.RF2_ConEnvioCasoCalidadPCE__c = 11;
        Update contAudCasos;
        testedClass.validarEnvioCalidad(aCase);
        testedClass.validarEnvioCalidad(otherCase);
    }
    
    @isTest
    public static void test_envioCalidad(){
        //Preparación para pruebas - Inicio       
        
        Case aCase = new Case();
            aCase.RF2_EsPCE__c = true;
            aCase.RF2_EsGIE__c = true;
        
        User aUser = new User(
        	Username = 'test@test.com'+ System.currentTimeMillis(),
            LastName = 'LastName', 
            Email = 'test@test.com', 
            Alias = 'test', 
            CommunityNickname = 'test', 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = [SELECT Id FROM Profile Limit 1].Id, 
            LanguageLocaleKey = 'en_US',
			Division = 'Tecnología',
			 Department =  'Tecnología',
        	isActive = true);
        Insert aUser;
        
        RF2_ConfiguracionAnalistasCalidad__c confAnalistCal = new RF2_ConfiguracionAnalistasCalidad__c();
            confAnalistCal.RF2_FechaAsignacion__c = Datetime.now();
            confAnalistCal.RF2_Usuario__c = aUser.Id;
            confAnalistCal.RF2_Proceso__c = 'GIE';
        System.runAs([select Id from User where Id = :UserInfo.getUserId() ][0]) {
        	insert confAnalistCal;
        }
        
        RF2_Case_cls testedClass = new RF2_Case_cls();
        //Preparación para pruebas - Fin
        
        //SELECT RF2_FechaAsignacion__c, RF2_Usuario__c, RF2_Proceso__c FROM RF2_ConfiguracionAnalistasCalidad__c Where RF2_Usuario__r.IsActive = true order by RF2_FechaAsignacion__c asc];
		testedClass.envioCalidad(aCase);
        
    }
    
    @isTest
    public static void ultimorecurso (){
        RF2_Case_cls.ultimorecurso();
    }

    @isTest
    public static void  test_AsignarCasoACalidad(){
        
        RF2_Case_cls testedClass = new RF2_Case_cls();
        
        // Preparación para realiza pruebas - Inicio
        List<Case> lCaseParent = new List<Case>();
            Case aParentCase = new Case();
            aParentCase.RecordTypeId = '0126A0000005cdiQAA';
            aParentCase.Status = 'Solucionado';
            aParentCase.RF2_Anonimo__c = false;
            aParentCase.RF2_EsGIE__c = true;
            Insert aParentCase;
        lCaseParent.add(aParentCase);
        List<Case> multipleCaseParent = new List<Case>();   
        multipleCaseParent.add(aParentCase);
            aParentCase.Status = 'No Solucionado';
        multipleCaseParent.add(aParentCase);
        
        Account anAccount = new Account();
            anAccount.name = 'Test Account';
        Insert anAccount;
        
        Entitlement aEntitlement = new Entitlement();
            aEntitlement.Name = 'ANS Hijo 16 horas - ASIG45';
            aEntitlement.RF2_ObligatorioCalidad__c = false;
            aEntitlement.AccountId = anAccount.Id;
        Insert aEntitlement;
        
        List<Case> lCaseChildren = new List<Case>();
            Case aChildCase = new Case();
            aChildCase.ParentId = aParentCase.Id;
        	aChildCase.RF2_MedioRespuesta__c = 'Correo Electronico';
        	aChildCase.RF2_ComentarioCierre__c = 'Solucionado';
            aChildCase.RF2_SolucionadoPrimerContacto__c = true;
        	aChildCase.Status = 'Solucionado';
            Insert aChildCase;
        lCaseChildren.add(aChildCase);
               
        testedClass.AsignarResponsableCaso(null, lCaseParent);
        List<Case> caseError = lCaseParent;
        //Preparación para realiza pruebas - Fin
        
        Test.startTest();
        
            //Prueba con un caso
            testedClass.AsignarCasoACalidad(null, lCaseParent);
            testedClass.AsignarCasoACalidad(lCaseChildren, lCaseChildren);
        
            //Multiples casos
            testedClass.AsignarCasoACalidad(null, multipleCaseParent);
            
            //Prueba con un caso y casos abiertos
            caseError.get(0).Status = 'Solucionado';
            testedClass.AsignarCasoACalidad(lCaseParent, caseError);
            
            //Multiples Casos con casos abiertos
            caseError.add(aParentCase);
            testedClass.AsignarCasoACalidad(lCaseParent, caseError);
        
            //Prueba caso anónimo
            caseError.get(0).RF2_Anonimo__c = true;
            testedClass.AsignarCasoACalidad(lCaseParent, caseError);
        
        Test.stopTest();
    }
    
}