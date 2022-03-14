@isTest
private class COM_ActualizarRelCuentaContactoBch_tst {
	
	@isTest static void test_method_one() {
		List<Account> lstAccount= new List<Account>();
        
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Cliente '+i;
            acc.COM_TipoIdentificacion__c = '1';
            acc.COM_Numero_de_identificacion__c = '1'+i;
            lstAccount.add(acc);
        }
        COM_AccountContactRelation_cls.stopTrigger();
        insert lstAccount;
        COM_AccountContactRelation_cls.startTrigger(); 

        Test.startTest();

            COM_ActualizarRelCuentaContacto_bch obj = new COM_ActualizarRelCuentaContacto_bch();
            obj.query = '';
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
	}
	
}