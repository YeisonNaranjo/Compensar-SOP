@isTest
private class COM_Opportunity_trg_tst {
	
	@isTest static void test_method_one() {
		// Implement test code

         Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test';
          objCuenta.AccountNumber = '654321';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
          objCuenta.COM_Numero_de_identificacion__c = '12345678909';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
          insert objCuenta;


		 Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objCuenta.id;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Cotizado';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_Fecharadicacioncartaretiro__c = System.today();
        //objOpportunity
        //COM_Alojamiento
        COM_TriggerExecutionControl_cls.ExecutedTriggers_set.clear();
        insert objOpportunity;
	}
	
}