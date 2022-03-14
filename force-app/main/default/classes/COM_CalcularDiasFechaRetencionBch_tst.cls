@isTest 
private class COM_CalcularDiasFechaRetencionBch_tst 
{
    static testMethod void test_method_one() 
    {
        List<Account> lstAccount= new List<Account>();
        
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Cliente '+i;
            acc.COM_FechaLimiteRetencion__c = Date.newInstance(2017, 9, 27);
            acc.COM_DiasFaltantesRetencion__c = 15;
            acc.COM_TipoIdentificacion__c = '1';
            acc.COM_Numero_de_identificacion__c = '1'+i;
            lstAccount.add(acc);
        }
        COM_AccountContactRelation_cls.stopTrigger();
        insert lstAccount;
        COM_AccountContactRelation_cls.startTrigger(); 

        Test.startTest();

            COM_CalcularDiasFechaRetencion_bch obj = new COM_CalcularDiasFechaRetencion_bch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }

    


}