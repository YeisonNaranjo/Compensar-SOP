@isTest
private class COM_UtilidadesMigracion_cls_tst {
    
    @isTest static void test_method_1() {
        COM_UtilidadesMigracion_cls.stopTrigger();
        COM_UtilidadesMigracion_cls.canIRun();
        COM_UtilidadesMigracion_cls.startTrigger();
    }
    
    @isTest static void test_method_2() {
        List<Account> acclst = new List<Account>();
        /*Account acc1 = COM_DataGenerator_cls.crearCuenta(false);
        acc1.Name ='Cliente 145235';
        acc1.COM_TipoIdentificacion__c = '1';
        acc1.COM_Numero_de_identificacion__c = '11435243523';
        //insert acc1;
        //acclst.add(acc1);
        Account acc2 = COM_DataGenerator_cls.crearCuenta(false);
        acc1.Name ='Cliente 2 eee';
        acc2.COM_TipoIdentificacion__c = '2';
        acc2.COM_Numero_de_identificacion__c = '1224376';
        //insert acc2;
        //acclst.add(acc2);
        Account acc3 = COM_DataGenerator_cls.crearCuenta(false);
        acc1.Name ='Cliente 3 asasasa';
        acc3.COM_TipoIdentificacion__c = '1';
        acc3.COM_Numero_de_identificacion__c = '1365476';
        //insert acc3;
        //acclst.add(acc3);
        
        COM_AccountContactRelation_cls.stopTrigger();
        insert acc1;
        insert acc2;
        insert acc3;
        COM_AccountContactRelation_cls.startTrigger();
        
        acclst.add(acc1);
        acclst.add(acc2);
        acclst.add(acc3);*/
        
        for(Integer i=0 ;i <3;i++)
        {
            Account acc = new Account();
            acc.Name ='Cliente '+i;
            acc.COM_TipoIdentificacion__c = '1';
            acc.COM_Numero_de_identificacion__c = '1'+i;
            acc.RecordTypeId = '0126A0000005VbpQAE';
            insert acc;
            acclst.add(acc);
            
        }

        COM_UtilidadesMigracion_cls ppp = new COM_UtilidadesMigracion_cls();
        ppp.crearContactoCuentaNatural(acclst);
    }

        @isTest static void test_method_3() {
        List<Account> acclst = new List<Account>();
        Account acc1 = COM_DataGenerator_cls.crearCuenta(true);
        acc1.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.COM_LabelPersonaNatural).getRecordTypeId();
        update acc1;
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, acc1.Id);
        //Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, acc1.Id);
        //AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, acc1.Id, cont.Id);

        acclst.add(acc1);
        /*Account acc2 = COM_DataGenerator_cls.crearCuenta(true);
            Contact cont2 =  COM_DataGenerator_cls.crearContacto(true, acc2.Id);
        Opportunity opp2 = COM_DataGenerator_cls.crearOportunidad(true, acc2.Id);
        AccountContactRelation rel2 = COM_DataGenerator_cls.crearContRelation(true, acc2.Id, cont2.Id);
        acclst.add(acc2);*/

    

        COM_UtilidadesMigracion_cls ppp = new COM_UtilidadesMigracion_cls();
        ppp.asociarRepresentanteLegal(acclst);
        ppp.crearContactoCuentaNatural(acclst);
        ppp.contadorRepLegalesBatch(acclst);
    }  
}