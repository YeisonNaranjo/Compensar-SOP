@isTest
private class COM_OpportunityLineItem_tst {
	
	@isTest static void test_method_one() {
		Test.startTest();
		COM_OpportunityLineItem_cls.stopTrigger();
		COM_OpportunityLineItem_cls.canIRun();
		COM_OpportunityLineItem_cls.startTrigger();
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Test.startTest();
		COM_OpportunityLineItem_cls pp = new COM_OpportunityLineItem_cls();
		pp.procesarOpportunityLineItem(new list<OpportunityLineItem>(),new list<OpportunityLineItem>());
		Test.stopTest();
	}




	@isTest static void test_method_three() {
		Test.startTest();

		Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
		Opportunity oportunidad = COM_DataGenerator_cls.crearOportunidad(true, cuenta.Id);
		Pricebook2 pb = COM_DataGenerator_cls.createPriceBook(true);

		COM_OpportunityLineItem_cls pp = new COM_OpportunityLineItem_cls();
		list<OpportunityLineItem> listOpli  = new list<OpportunityLineItem>();
		list<OpportunityLineItem> listOpliNew  = new list<OpportunityLineItem>();
		OpportunityLineItem opli = new OpportunityLineItem();
		opli.OpportunityId = oportunidad.Id;
		opli.PricebookEntryId = pb.Id;
		opli.Quantity = 2;
		opli.COM_NumeroNoches__c = 3;
		
		listOpli.add(opli);
		listOpliNew.add(opli);
		pp.procesarOpportunityLineItem(listOpli,new list<OpportunityLineItem>());

		Test.stopTest();
	}

	@isTest static void test_method_four() {
		Test.startTest();

		Account cuenta = COM_DataGenerator_cls.crearCuenta(true);


		Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = cuenta.Id;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Cotizado';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Alojamiento'];
        objOpportunity.RecordTypeId = lstRecordTypeQuote.get(0).Id;
        //objOpportunity
        //COM_Alojamiento
        
        insert objOpportunity;

		
		//Opportunity oportunidad = COM_DataGenerator_cls.crearOportunidad(true, cuenta.Id);
		Pricebook2 pb = COM_DataGenerator_cls.createPriceBook(true);

		COM_OpportunityLineItem_cls pp = new COM_OpportunityLineItem_cls();
		list<OpportunityLineItem> listOpli  = new list<OpportunityLineItem>();
		list<OpportunityLineItem> listOpliNew  = new list<OpportunityLineItem>();
		OpportunityLineItem opli = new OpportunityLineItem();
		opli.OpportunityId = objOpportunity.Id;
		opli.PricebookEntryId = pb.Id;
		opli.Quantity = 2;
		opli.COM_NumeroNoches__c = 3;
		
		listOpli.add(opli);
		listOpliNew.add(opli);
		pp.procesarOpportunityLineItem(listOpli,new list<OpportunityLineItem>());

		Test.stopTest();
	}
	
}