/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Elkin Cordoba (EC)
Proyecto:          Compensar
Descripción:       NOLA-3987 
                   Clase de prueba de la clase COM_PAF_CartaReafiliacion_ctr 
                   Se imita la funcionalidad del controlador COM_PAF_CartaBienvenida_ctr 
                   encargado de:                    
                      * Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/05/18             Elkin Cordoba (EC)             Creacion  de la Clase.
----------  -------------   ----------------------  ---------------------------------------------
    2.0     24/09/20             Yeison Naranjo (YN)             Aumento cobertura NOLA 00020102.
************************************************************************************************/

    @isTest
    private class COM_PAF_CartaReafiliacion_tst 
    {
        public static EmailTemplate objEmailT;
        public static Account objAcc;

        public static void createData()
        {
            COM_ConfiguracionConsecutivos__c objConf    = new COM_ConfiguracionConsecutivos__c();
            objConf.Name                                = 'Test';
            objConf.COM_Formato__c                      = 'TST-####-ddmmAAAA';
            objConf.COM_IdentificadorProceso__c         = 'TST';
            insert objConf;

            objAcc                              = COM_DataGenerator_cls.crearCuenta(false);
            objAcc.COM_TipoIdentificacion__c    = '3';
            objAcc.COM_Numero_de_identificacion__c  = '123456789';
            objAcc.COM_Genero__c                = 'M';
            objAcc.COM_FechaAfiliacion__c       = System.today();
            objAcc.COM_FechaRetiro__c           =  System.today();
            objAcc.COM_Periodoultimoaporte__c   = System.today();
            /* Inicio 2.0 */
            objAcc.COM_Direccion__c   = 'KR 30 # 50';
            objAcc.COM_CorreoElectronico__c   = 'pruebas@globant.com';
            objAcc.Phone = '2780675';
            /* Fin 2.0 */

            objEmailT = [Select id,DeveloperName FROM EmailTemplate][0];
        }

        public static testMethod void test_method_sucess() 
        {
            createData();
            COM_AccountContactRelation_cls.stopTrigger();
            insert objAcc;
            COM_AccountContactRelation_cls.startTrigger();

            Contact objCont = new Contact();
            objCont.FirstName = 'Test';
            objCont.LastName = 'Test';
            objCont.COM_TipoIdentificacion__c    = '3';
            objCont.COM_Numeroidentificacion__c  = '123456789';
			objCont.AccountId = objAcc.Id;
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCont;
            COM_AccountContactRelation_cls.startTrigger();

            List<AccountContactRelation> lstAccContRel = [Select Id,AccountId,ContactId FROM AccountContactRelation];
            for(AccountContactRelation objAccContRel : lstAccContRel)
            {
                objAccContRel.IsActive = true;
                objAccContRel.Roles = 'Representante Legal';
            }
            update lstAccContRel;

            PageReference pageRef = Page.COM_PAF_CartaReafiliacion_pag;
            Test.setCurrentPage(pageRef);
            System.debug([Select id,DeveloperName FROM EmailTemplate]);
            ApexPages.currentPage().getParameters().put('accountID', objAcc.Id);
            ApexPages.currentPage().getParameters().put('idProc', 'TST');

            Test.startTest();
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr();
            controller.getBody();
            Test.stopTest();
        }

        public static testMethod void test_method_sucess2() 
        {
            createData();
            objAcc.COM_Genero__c                = 'F';
            insert objAcc;
            PageReference pageRef = Page.COM_PAF_CartaReafiliacion_pag;
            Test.setCurrentPage(pageRef);
            System.debug([Select id,DeveloperName FROM EmailTemplate]);
            ApexPages.currentPage().getParameters().put('accountID', objAcc.Id);

            Test.startTest();
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr();
            controller.getBody();
            Test.stopTest();
        }


        public static testMethod void test_method_sucess3(){
            Test.startTest();
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr();
            system.debug(controller.strElaboradoPor);
            system.debug(controller.strCodigoDoc);
            system.debug(controller.strBody);
            Test.stopTest();

        }

        public static testMethod void test_method_sucess4(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta(true);
            Contact con = COM_DataGenerator_cls.crearContacto(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;
            Case c = COM_DataGenerator_cls.crearCasoAnonimo(true, account.Id);
            ApexPages.StandardController apexController = new ApexPages.StandardController(c);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaA_A1');
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess5(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            Case c = COM_DataGenerator_cls.crearCasoAnonimo(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto2(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;
            ApexPages.StandardController apexController = new ApexPages.StandardController(c);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaA_A1');
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess6(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            Case c = COM_DataGenerator_cls.crearCasoAnonimo(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto2(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;

            ApexPages.StandardController apexController = new ApexPages.StandardController(c);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaB_C_D');
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess7(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            Case c = COM_DataGenerator_cls.crearCasoAnonimo(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto2(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;

            ApexPages.StandardController apexController = new ApexPages.StandardController(c);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaPensionados');
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess8(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            Case c = COM_DataGenerator_cls.crearCasoAnonimo(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto2(true, account.Id);
            AccountContactRelation acr = COM_DataGenerator_cls.crearContRelation(true, account.Id, con.Id);
            ApexPages.StandardController apexController = new ApexPages.StandardController(c);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaPrimerEmpleo');
            COM_PAF_CartaReafiliacion_ctr controller = new COM_PAF_CartaReafiliacion_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }             
    }