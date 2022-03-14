@isTest
public class RF2_Case2_cls_tst {
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
    @isTest static void test_method_5() {
        Test.startTest();
        
        RF2_Case_cls ppp = new RF2_Case_cls();
        ppp.calcularFechaPazYSalvo(null, new List<Case>{new Case(RF2_RelacionadoCon__c = Label.RF2_AsuntoGenerarPazYSalvo_lbl)});
        RF2_Case_cls.stopTrigger();
        RF2_Case_cls.canIRun();
        RF2_Case_cls.startTrigger();
        Test.stopTest();     
    }
    
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
            Department = 'Tecnología',
            Division = 'Tecnología',
            isActive = true);
        system.runAs(new User(Id = UserInfo.getUserId()) ){
            Insert aUser;
        }
        RF2_ConfiguracionAnalistasCalidad__c confAnalistCal = new RF2_ConfiguracionAnalistasCalidad__c();
        confAnalistCal.RF2_FechaAsignacion__c = Datetime.now();
        confAnalistCal.RF2_Usuario__c = aUser.Id;
        confAnalistCal.RF2_Proceso__c = 'GIE';
        Insert confAnalistCal;  
        RF2_Case_cls testedClass = new RF2_Case_cls();
        //Preparación para pruebas - Fin
        
        //SELECT RF2_FechaAsignacion__c, RF2_Usuario__c, RF2_Proceso__c FROM RF2_ConfiguracionAnalistasCalidad__c Where RF2_Usuario__r.IsActive = true order by RF2_FechaAsignacion__c asc];
        testedClass.envioCalidad(aCase);     
    }
    
    //Inicio v1.1
    @isTest(SeeAllData=true)
    public static void test_enviarEncuestas (){
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = 'Encuesta Sondeo GIE2';
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = 'Encuesta Sondeo PCE1';
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account accTest = new Account();
        accTest.Name = 'prueba1';
        accTest.COM_Numero_de_identificacion__c = '001';
        insert accTest;
        
        Contact conTest = new Contact();
        conTest.FirstName = 'prueba';
        conTest.LastName = 'uno';
        conTest.AccountId = accTest.id;
        insert conTest;
        
        Case testCasePCE = new Case();
        testCasePCE.RF2_EsPCE__c = true;
        testCasePCE.RF2_EsGIE__c = false;
        testCasePCE.RF2_MedioRespuesta__c = 'Correspondencia';
        testCasePCE.Origin = 'Asesor';
        testCasePCE.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        testCasePCE.RF2_RelacionadoCon__c = 'Alimentos';
        testCasePCE.RF2_TipoSolicitud__c = 'Solicitud PCE';
        testCasePCE.Description = 'prueba uno';
        testCasePCE.RF2_CorreoElectronicoRespuesta__c = 'jsparra@avanxo.com';
        testCasePCE.AccountId = accTest.id;
        testCasePCE.ContactId = conTest.id;
        testCasePCE.RF2_FechaVencimientoCaso__c = System.Today() + 3;
        testCasePCE.RF2_Colaborador__c = 'Yo ayude a solucionar';
        
        Case testCaseGIE = new Case();
        testCaseGIE.RF2_EsPCE__c = false;
        testCaseGIE.RF2_EsGIE__c = true;
        testCaseGIE.RF2_MedioRespuesta__c = 'Correo Electronico';
        testCaseGIE.Origin = 'Chat';
        testCaseGIE.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';	
        testCaseGIE.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        testCaseGIE.RF2_TipoSolicitud__c = 'Solicitud GIE';
        testCaseGIE.Description = 'prueba dos';
        testCaseGIE.RF2_CorreoElectronicoRespuesta__c = 'jsparra@avanxo.com';
        testCaseGIE.AccountId = accTest.id;
        testCaseGIE.RF2_FechaVencimientoCaso__c = System.Today() + 3;
        testCaseGIE.ContactId = conTest.id;
        testCaseGIE.RF2_Colaborador__c = 'Yo ayude a solucionar';
        
        Case testCasePCE2 = new Case();
        testCasePCE2.RF2_EsPCE__c = true;
        testCasePCE2.RF2_EsGIE__c = false;
        testCasePCE2.RF2_MedioRespuesta__c = 'Correo Electronico';
        testCasePCE2.Origin = 'Asesor';
        testCasePCE2.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        testCasePCE2.RF2_RelacionadoCon__c = 'Alimentos';
        testCasePCE2.RF2_TipoSolicitud__c = 'Solicitud PCE';
        testCasePCE2.Description = 'prueba uno';
        testCasePCE2.RF2_CorreoElectronicoRespuesta__c = 'jsparra@avanxo.com';
        testCasePCE2.AccountId = accTest.id;
        testCasePCE2.ContactId = conTest.id;
        testCasePCE2.RF2_FechaVencimientoCaso__c = System.Today() + 3;
        testCasePCE2.RF2_Colaborador__c = 'Yo ayude a solucionar';
        testCasePCE.RF2_SolucionadoPrimerContacto__c = true;
        
        list<Case> lstCaseTst = new list<Case>();
        lstCaseTst.add(testCasePCE);
        lstCaseTst.add(testCaseGIE);
        lstCaseTst.add(testCasePCE2);
        insert lstCaseTst;
        
        For(Case objCaseTst : lstCaseTst){
            objCaseTst.RF2_Cantidad_de_registros__c = 1;
            objCaseTst.status= 'Solucionado';
        }
        
        System.debug('lstCaseTst.GIE: ' + lstCaseTst[1].RF2_TipoSolicitud__c);
        System.debug('lstCaseTst.GIE: ' + lstCaseTst[1].RF2_ServicioGIE__c);
        Test.startTest();
        RF2_Case_cls.procesarPDF(lstCaseTst[1].Id);
        Test.stopTest();        
        
        update lstCaseTst;
    }
    
    @isTest
    public static void test_enviarEncuestas2 (){
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account accTest = new Account();
        accTest.Name = 'prueba1';
        accTest.COM_Numero_de_identificacion__c = '002';
        insert accTest;
        
        Contact conTest = new Contact();
        conTest.FirstName = 'prueba';
        conTest.LastName = 'uno';
        conTest.COM_TipoIdentificacion__c = Label.RF2_TipoIdentificacionClienteAnonimo_lbl;
        conTest.COM_Numeroidentificacion__c = Label.RF2_NumeroIdentificacionClienteAnonimo_lbl;
        conTest.AccountId = accTest.id;
        insert conTest;
        
        Case testCasePCE2 = new Case();
        testCasePCE2.RF2_EsPCE__c = true;
        testCasePCE2.RF2_EsGIE__c = false;
        testCasePCE2.RF2_MedioRespuesta__c = 'Correo Electronico';
        testCasePCE2.Origin = 'Asesor';
        testCasePCE2.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        testCasePCE2.RF2_RelacionadoCon__c = 'Alimentos';
        testCasePCE2.RF2_TipoSolicitud__c = 'Solicitud PCE';
        testCasePCE2.Description = 'prueba uno';
        testCasePCE2.RF2_CorreoElectronicoRespuesta__c = 'jsparra@avanxo.com';
        testCasePCE2.AccountId = accTest.id;
        testCasePCE2.ContactId = conTest.id;
        testCasePCE2.RF2_GCN__c = 'Otros';
        testCasePCE2.RF2_ExcluidoCalidad__c = true;
        testCasePCE2.RF2_FechaVencimientoCaso__c = System.Today() + 3;
        testCasePCE2.RF2_Colaborador__c = 'Yo ayude a solucionar';
        
        insert testCasePCE2;
        
        testCasePCE2.RF2_Cantidad_de_registros__c = 1;
        testCasePCE2.status= 'Solucionado';testCasePCE2.status= 'Solucionado';
        testCasePCE2.RF2_Anonimo__c = False;
        update testCasePCE2;
        
        Test.startTest();
        RF2_Case_cls.procesarPDF(testCasePCE2.Id);
        Test.stopTest();
    }
    //Final  v1.1 
    
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