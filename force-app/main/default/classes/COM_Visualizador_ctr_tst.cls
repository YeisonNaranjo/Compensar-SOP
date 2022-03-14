@isTest
private class COM_Visualizador_ctr_tst {
    
    @isTest static void test_method_one() {
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        //Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'AfterInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        //AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        ApexPages.currentPage().getParameters().put('customObjectId', account.Id); 
        ApexPages.currentPage().getParameters().put('tipo', 'EncuentroDirectivos'); 
        ApexPages.currentPage().getParameters().put('tipoDoc', 'value'); 
        ApexPages.currentPage().getParameters().put('idCotizacion', 'value'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = System.Label.DocumentoBienvenidaCat,
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion_1;
        
        Test.startTest();
        COM_Visualizador_ctr ppp = new COM_Visualizador_ctr();
        System.debug(ppp.lstCorreo);
        ppp.getEmailsRepLegales(account.Id);
        ppp.getEmailsCuenta(account.Id);
        ppp.strTipoDoc = 'BienvenidaA_A1';
        //COM_DataGenerator_cls.crearOperador(true);
        COM_Operador__c op = COM_DataGenerator_cls.crearOperador(true);
        opp.COM_Operador__c = op.Id;
        opp.COM_Fechahorainicio__c = System.today()+2;
        update opp;
        
        ppp.getEmailsOperador(opp.Id);
        ppp.getContactosCuenta(account.Id);
        ppp.fnGuardarEnviar();
        Test.stopTest();
        
    }
    
    @isTest static void test_method_two() {
        ApexPages.currentPage().getParameters().put('customObjectId', 'value'); 
        ApexPages.currentPage().getParameters().put('tipo', 'valuex'); 
        ApexPages.currentPage().getParameters().put('tipoDoc', 'value'); 
        ApexPages.currentPage().getParameters().put('idCotizacion', 'value'); 
        
        COM_Visualizador_ctr ppp = new COM_Visualizador_ctr();
        System.debug(ppp.lstCorreo);
    }    
    
    @isTest static void test_method_three() {
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'AfterInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        ApexPages.currentPage().getParameters().put('customObjectId', 'value'); 
        ApexPages.currentPage().getParameters().put('tipo', 'EncuentroDirectivos'); 
        ApexPages.currentPage().getParameters().put('tipoDoc', 'value'); 
        ApexPages.currentPage().getParameters().put('idCotizacion', 'value');
        COM_Visualizador_ctr ppp = new COM_Visualizador_ctr(); 
        ppp.getContactosCuenta(account.Id);
    } 
    
    @isTest static void test_method_four() {
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'AfterInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        ApexPages.currentPage().getParameters().put('customObjectId', account.Id); 
        ApexPages.currentPage().getParameters().put('tipo', 'EncuentroDirectivos'); 
        ApexPages.currentPage().getParameters().put('tipoDoc', 'value'); 
        ApexPages.currentPage().getParameters().put('idCotizacion', 'value'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = System.Label.DocumentoBienvenidaCat,
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion_1;
        
        Test.startTest();
        COM_Visualizador_ctr ppp = new COM_Visualizador_ctr();
        System.debug(ppp.lstCorreo);
        ppp.getEmailsRepLegales(account.Id);
        ppp.getEmailsCuenta(account.Id);
        ppp.strTipoDoc = 'FichaTecnica';
        //COM_DataGenerator_cls.crearOperador(true);
        COM_Operador__c op = COM_DataGenerator_cls.crearOperador(true);
        opp.COM_Operador__c = op.Id;
        opp.COM_Fechahorainicio__c = System.today()+2;
        update opp;
        
        ppp.getEmailsOperador(opp.Id);
        ppp.getContactosCuenta(account.Id);
        ppp.fnGuardarEnviar();
        Test.stopTest();
        
    }
}