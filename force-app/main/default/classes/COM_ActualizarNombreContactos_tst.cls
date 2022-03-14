@isTest
private class COM_ActualizarNombreContactos_tst {

    static testMethod void test_method_one()
        
    {
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <20;i++)
        {
            Account acc = new Account();
            acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Natural').getRecordTypeId();
            acc.Name ='Cliente '+i;
            acc.COM_TipoIdentificacion__c = '1';
            acc.COM_Numero_de_identificacion__c = '1'+i;
            acc.COM_Primernombre__c = 'uno'+i;
            acc.COM_Otrosnombres__c = 'uno'+i;
            acc.COM_Primerapellido__c = 'uno'+i;
            acc.COM_Segundoapellido__c = 'uno'+i;
            acc.Phone = '123456789';
            acc.COM_Movil__c = '';
            acc.COM_CorreoElectronico__c='prueba@prueba.com';
            acc.COM_Tratamientoprotecciondatos__c = true;
            acc.COM_Aceptaenviocorreoelectronico__c = true; 
            acc.COM_AceptaenvioSMS__c = true; 
            acc.COM_Estado_civil__c = '';
            lstAccount.add(acc);
        }
        COM_AccountContactRelation_cls.stopTrigger();
        insert lstAccount;


        List<Contact> lstContact = new List<Contact>();
        for(Account a : lstAccount){
            Contact con = new Contact();
            con.FirstName = a.COM_Primernombre__c;
            con.LastName = a.COM_Primerapellido__c;
            con.AccountId = a.Id;
            lstContact.add(con);
        }
        insert lstContact;

        Test.startTest();

            COM_ActualizarNombreContactos_bch obj = new COM_ActualizarNombreContactos_bch();
            DataBase.executeBatch(obj);

        Test.stopTest();
    }

}