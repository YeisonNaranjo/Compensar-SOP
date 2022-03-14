/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_PAF_CartaBienvenida_ctr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     08/08/17             Cristian David Mejia (CM)             Creación Clase.
    ************************************************************************************************/

    @isTest
    private class COM_PAF_CartaBienvenida_tst 
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
            //Inicio Modificación V2.0
            COM_AccountContactRelation_cls.stopTrigger();
            update lstAccContRel;
            COM_AccountContactRelation_cls.startTrigger();
            //Fin Modificación V2.0

            PageReference pageRef = Page.COM_PAF_CartaBienvenida_pag;
            Test.setCurrentPage(pageRef);
            System.debug([Select id,DeveloperName FROM EmailTemplate]);
            ApexPages.currentPage().getParameters().put('accountID', objAcc.Id);
            ApexPages.currentPage().getParameters().put('idProc', 'TST');

            Test.startTest();
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr();
            controller.getBody();
            Test.stopTest();
        }

        public static testMethod void test_method_sucess2() 
        {
            createData();
            objAcc.COM_Genero__c                = 'F';
            insert objAcc;
            PageReference pageRef = Page.COM_PAF_CartaBienvenida_pag;
            Test.setCurrentPage(pageRef);
            System.debug([Select id,DeveloperName FROM EmailTemplate]);
            ApexPages.currentPage().getParameters().put('accountID', objAcc.Id);

            Test.startTest();
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr();
            controller.getBody();
            Test.stopTest();
        }


        public static testMethod void test_method_sucess3(){
            Test.startTest();
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr();
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
            //Inicio Modificación V2.0
            COM_AccountContactRelation_cls.stopTrigger();
            //Fin Modificación V2.0
            update acr;
            COM_TriggerExecutionControl_cls.setAlreadyDone('COM_Opportunity_tgr','AfterInsert');
            Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
            ApexPages.StandardController apexController = new ApexPages.StandardController(opp);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaA_A1');
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess5(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            COM_TriggerExecutionControl_cls.setAlreadyDone('COM_Opportunity_tgr','AfterInsert');
            Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;
            ApexPages.StandardController apexController = new ApexPages.StandardController(opp);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaA_A1');
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess6(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            COM_TriggerExecutionControl_cls.setAlreadyDone('COM_Opportunity_tgr','AfterInsert');
            Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;

            ApexPages.StandardController apexController = new ApexPages.StandardController(opp);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaB_C_D');
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess7(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            COM_TriggerExecutionControl_cls.setAlreadyDone('COM_Opportunity_tgr','AfterInsert');
            Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto(true, account.Id);
            AccountContactRelation acr = [SELECT Id FROM AccountContactRelation WHERE AccountId = :account.Id AND ContactId = :con.Id];
            acr.Roles = 'Representante Legal';
            acr.COM_CargoEmpresa__c= 'ese';
            update acr;

            ApexPages.StandardController apexController = new ApexPages.StandardController(opp);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaPensionados');
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }


        public static testMethod void test_method_sucess8(){
            Test.startTest();
            createData();
            Account account = COM_DataGenerator_cls.crearCuenta2(true);
            COM_TriggerExecutionControl_cls.setAlreadyDone('COM_Opportunity_tgr','AfterInsert');
            Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
            Contact con = COM_DataGenerator_cls.crearContacto(true, account.Id);
            AccountContactRelation acr = COM_DataGenerator_cls.crearContRelation(true, account.Id, con.Id);
            ApexPages.StandardController apexController = new ApexPages.StandardController(opp);
            ApexPages.currentPage().getParameters().put('tipoDoc','BienvenidaPrimerEmpleo');
            COM_PAF_CartaBienvenida_ctr controller = new COM_PAF_CartaBienvenida_ctr(apexController);
            controller.getBody();
            Test.stopTest();

        }             
    }