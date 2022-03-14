@isTest
private class COM_Account_Execution_tst
{
	@isTest
	  public static void test_method_one(){

	  
	  	 

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


          COM_AccountContactRelation_cls.startTrigger2();
          Insert objCuenta;
       
    }
}