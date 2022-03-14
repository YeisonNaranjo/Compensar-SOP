/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Luis Rafael Peñaranda (LP)
Proyecto:          Compensar
Descripción:       Clase de preubas para Controlador de la pde compoenntes de botones migrados de JS encargado de:
                    * Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     01/09/19             Luis Peñaranda (LP)             		Creación Clase.
************************************************************************************************/
@isTest
public class MGLT_GenerarPDF_tst {
     
    @isTest(SeeAllData=true)
    static void GenerarPDF1() {
        Account objAcc = [Select Id from Account where COM_Numero_de_identificacion__c = '9999'];
        Contact objContact = [Select Id from Contact where AccountId =: objAcc.Id];
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Quote objQuote;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        //objAcc = COM_DataGenerator_cls.crearCuenta(true);
        //objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
        OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();

		
        Pricebook2 pb = COM_DataGenerator_cls.createPriceBook(true);
		OpportunityLineItem opli = new OpportunityLineItem();
		opli.OpportunityId = objOpp.Id;
		opli.PricebookEntryId = pb.Id;
		opli.Quantity = 2;
		opli.COM_NumeroNoches__c = 3;
        
            
        objQuote = COM_DataGenerator_cls.crearQuote(false, objOpp.Id);
        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
        objQuote.Status = 'Aprobada';
        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
        insert objQuote;
  

        Contact con = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        

        
        Test.startTest();          
        MGLT_GenerarPDF_ctr.obtainStage(objOpp.id);
        MGLT_GenerarPDF_ctr.getQuote(objQuote.Id);
        MGLT_GenerarPDF_ctr.getClientePazySalvo(objAcc.id);
         Test.stopTest();
        //System.assertEquals('Normal', pri);
    }
 
    @isTest(SeeAllData=true)
    static void GenerarPDF2() {
        Account objAcc = [Select Id from Account where COM_Numero_de_identificacion__c = '9999'];
        Contact objContact = [Select Id from Contact where AccountId =: objAcc.Id];
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Quote objQuote;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        //objAcc = COM_DataGenerator_cls.crearCuenta(true);
        //objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
        OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();

		
        Pricebook2 pb = COM_DataGenerator_cls.createPriceBook(true);
		OpportunityLineItem opli = new OpportunityLineItem();
		opli.OpportunityId = objOpp.Id;
		opli.PricebookEntryId = pb.Id;
		opli.Quantity = 2;
		opli.COM_NumeroNoches__c = 3;
        
            
        objQuote = COM_DataGenerator_cls.crearQuote(false, objOpp.Id);
        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
        objQuote.Status = 'Aprobada';
        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
        insert objQuote;
  

        Contact con = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        

        //Case caso =  COM_DataGenerator_cls.crearCasox(true, objAcc.Id, con.Id, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);
        
        Test.startTest();          
        MGLT_GenerarPDF_ctr.getQuoteOppLagos(objQuote.Id);
        MGLT_GenerarPDF_ctr.getCartaBienvenida(objOpp.Id);
         Test.stopTest();
        //System.assertEquals('Normal', pri);
    }
 	@isTest(SeeAllData=true)
    static void GenerarPDF3() {
        Account objAcc = [Select Id from Account where COM_Numero_de_identificacion__c = '9999'];
        Contact objContact = [Select Id from Contact where AccountId =: objAcc.Id];
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Quote objQuote;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        //objAcc = COM_DataGenerator_cls.crearCuenta(true);
        //objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
        OpportunityLineItem objOpportunityLineItem = new OpportunityLineItem();

		
        Pricebook2 pb = COM_DataGenerator_cls.createPriceBook(true);
		OpportunityLineItem opli = new OpportunityLineItem();
		opli.OpportunityId = objOpp.Id;
		opli.PricebookEntryId = pb.Id;
		opli.Quantity = 2;
		opli.COM_NumeroNoches__c = 3;
        
            
        objQuote = COM_DataGenerator_cls.crearQuote(false, objOpp.Id);
        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
        objQuote.Status = 'Aprobada';
        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
        insert objQuote;
  

        Contact con = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        
        //Case caso =  COM_DataGenerator_cls.crearCaso(true, objAcc.Id, con.Id);
        Case caso = new Case();
        caso = new Case();
        caso.ContactId = con.Id;
        caso.AccountId = objAcc.Id;
        caso.Origin = 'Call Center';
        caso.Status = 'Abierto';
        caso.RF2_GrupoCicloNegocio__c = 'Aportes';
        caso.RF2_TipoSolicitud__c = 'Queja';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
        caso.Subject = 'subject';
        //insert caso;
        
        Test.startTest();  
		MGLT_GenerarPDF_ctr.fetchRecordTypeValues();  
        MGLT_GenerarPDF_ctr.getRecTypeId('Sin contestar');
        MGLT_GenerarPDF_ctr.getCartaReafiliacion(caso.Id);
         Test.stopTest();
        //System.assertEquals('Normal', pri);
    }   
}