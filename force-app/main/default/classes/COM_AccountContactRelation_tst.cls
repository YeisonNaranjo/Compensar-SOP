/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_AccountContactRelation_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     28/07/17             Cristian David Mejia (CM)             Creación Clase.
	1.1     07/05/19 			 Jordan Steven Parra  (JP) 			   Aumento de cobertura
************************************************************************************************/
@isTest
private class COM_AccountContactRelation_tst
{
    public static Account objAcc;
    public static Contact objCon;

    public static void createData()
    {
        objCon = new Contact();
        objAcc = new Account();

        objAcc.Name = 'Nombre';
        objAcc.COM_TipoIdentificacion__c = '1';
        objAcc.COM_Numero_de_identificacion__c = '98765432';
        objAcc.COM_Primernombre__c = 'Nombre';
        objAcc.COM_Otrosnombres__c = 'Nombre';
        objAcc.COM_Primerapellido__c = 'Apellido';
        objAcc.COM_Segundoapellido__c = 'Apellido';

        objCon = new Contact();
        objCon.FirstName = 'Test';
        objCon.LastName = 'Test';
/*        objCont.AccountId = objAcc.Id;
        lstContact.add(objCont);

        objCont = new Contact();
        objCont.FirstName = 'Test2';
        objCont.LastName = 'Test2';
        objCont.AccountId = objAcc.Id;
        lstContact.add(objCont);

        objCont = new Contact();
        objCont.FirstName = 'Test3';
        objCont.LastName = 'Test3';
        objCont.AccountId = objAcc.Id;
        lstContact.add(objCont);

        objCont = new Contact();
        objCont.FirstName = 'Test4';
        objCont.LastName = 'Test4';
        objCont.AccountId = objAcc.Id;
        lstContact.add(objCont);

        insert lstContact;*/
    }

    public static testMethod void test_method_1() 
    {
        createData();
        //String strAccountId;
        //List<AccountContactRelation> lstAccContRel = [Select Id,AccountId,ContactId FROM AccountContactRelation WHERE AccountId=:objAcc.Id];

        Test.startTest();
            insert objAcc;
            List<AccountContactRelation> lstAccContRel = [SELECT Id,AccountId, ContactId FROM AccountContactRelation WHERE AccountId=:objAcc.Id];
            List<String> lstStr = new List<String>();
            for(AccountContactRelation acr :lstAccContRel)
                lstStr.add(acr.ContactId);
            List<Contact> lstCon = [SELECT Id, AccountId FROM Contact WHERE Id IN :lstStr];

            COM_AccountContactRelation_cls clsAcr = new COM_AccountContactRelation_cls ();
            clsAcr.contadorRepLegales(lstCon);
            clsAcr.contadorRepLegales(lstAccContRel);

            //objAcc = [SELECT Id,COM_CantidadLegales__c FROM Account WHERE Id =:objAcc.Id];
            //System.assertEquals(objAcc.COM_CantidadLegales__c,1);
                            
        Test.stopTest();
        /*
        COM_AccountContactRelation_cls clsAcr = new COM_AccountContactRelation_cls ();
        clsAcr.contadorRepLegales(lstContact);

        for(AccountContactRelation objAccContRel : lstAccContRel)
        {
            objAccContRel.IsActive = true;
            objAccContRel.Roles = 'Representante Legal';
            strAccountId = objAccContRel.AccountId;
        }
        update lstAccContRel;

        Account objAcc = new Account();
        objAcc.Name = 'Test2';
        insert objAcc;

        Contact objCont = new Contact();
        objCont.FirstName = 'Test5';
        objCont.LastName = 'Test5';
        objCont.AccountId = objAcc.Id;
        insert objCont;

        Test.startTest();

            AccountContactRelation objAccContRel = new AccountContactRelation();
            objAccContRel.IsActive = true;
            objAccContRel.Roles = 'Representante Legal';
            objAccContRel.AccountId = strAccountId;
            objAccContRel.ContactId = objCont.Id;
            insert objAccContRel;
            
            objAcc = [SELECT Id,COM_CantidadLegales__c FROM Account WHERE Id =: strAccountId];
            System.assertEquals(objAcc.COM_CantidadLegales__c,5);

            objAccContRel.Roles = 'Otro';
            update objAccContRel;

            objAcc = [SELECT Id,COM_CantidadLegales__c FROM Account WHERE Id =: strAccountId];
            System.assertEquals(objAcc.COM_CantidadLegales__c,4);

            objAccContRel.Roles = 'Representante Legal';
            update objAccContRel;

            objAcc = [SELECT Id,COM_CantidadLegales__c FROM Account WHERE Id =: strAccountId];
            System.assertEquals(objAcc.COM_CantidadLegales__c,5);

            delete objAccContRel;

            objAcc = [SELECT Id,COM_CantidadLegales__c FROM Account WHERE Id =: strAccountId];
            System.assertEquals(objAcc.COM_CantidadLegales__c,4);

        Test.stopTest();
        */
    }
    /*
    public static testMethod void test_method_2(){
        createData();
        Test.startTest();
            insert objAcc;
            List<AccountContactRelation> lstAccContRel = [SELECT Id,AccountId, ContactId FROM AccountContactRelation WHERE AccountId=:objAcc.Id];
            List<String> lstStr = new List<String>();
            for(AccountContactRelation acr :lstAccContRel)
                lstStr.add(acr.ContactId);
            List<Contact> lstCon = [SELECT Id, AccountId FROM Contact WHERE Id IN :lstStr];

            COM_AccountContactRelation_cls clsAcr = new COM_AccountContactRelation_cls ();
            User u = [SELECT Id, COM_PermisosEscrituraGC__c FROM User WHERE COM_PermisosEscrituraGC__c = false AND IsActive = true LIMIT 1];
            AccountTeamMember newAccountTeamMember = new AccountTeamMember();
            newAccountTeamMember.AccountId = objAcc.Id;
            newAccountTeamMember.TeamMemberRole = Label.COM_PAF_TypeTeamAsesor;
            newAccountTeamMember.UserId = u.Id;
            insert newAccountTeamMember;
            AccountShare acctShare = new AccountShare();
            acctShare.AccountId = objAcc.Id;
            acctShare.UserOrGroupId = u.Id;
            acctShare.AccountAccessLevel = 'Edit';
            acctShare.CaseAccessLevel = 'Edit';
            acctShare.OpportunityAccessLevel = 'Edit';
            upsert acctShare;
            System.runAs(u){
                clsAcr.contadorRepLegales(lstCon);
                clsAcr.contadorRepLegales(lstAccContRel);
            }                            
        Test.stopTest();
    }
*/
    public static testMethod void test_method_3(){
        createData();
        Test.startTest();
            objAcc.RecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType ='Account' AND DeveloperName = 'COM_Natural'].get(0).Id;
            insert objAcc;
            List<Account> lstAcc = new List<Account>();
            lstAcc.add(objAcc);
            COM_AccountContactRelation_cls clsAcr = new COM_AccountContactRelation_cls ();
            clsAcr.actualizaContactoCuentasNatural(lstAcc);
            clsAcr.contadorRepLegalesBatch(lstAcc);
        Test.stopTest();
    }
    
//Inicio v1.1
    public static testMethod void test_method_4() 
    {
        objAcc = new Account();
        objAcc.Name = 'nombre';
        objAcc.COM_TipoIdentificacion__c = '1';
        objAcc.COM_Numero_de_identificacion__c = '98765432';
        objAcc.COM_Primernombre__c = 'Nombre';
        objAcc.COM_Otrosnombres__c = 'Nombre';
        objAcc.COM_Primerapellido__c = 'ApellidossApellidossApellidossApellidossApellidossApellidossApellidossApellidossApellidoss';
        Test.startTest();
            insert objAcc;
            List<AccountContactRelation> lstAccContRel = [SELECT Id,AccountId, ContactId FROM AccountContactRelation WHERE AccountId=:objAcc.Id];
            List<String> lstStr = new List<String>();
            for(AccountContactRelation acr :lstAccContRel)
                lstStr.add(acr.ContactId);
            List<Contact> lstCon = [SELECT Id, AccountId FROM Contact WHERE Id IN :lstStr];

            COM_AccountContactRelation_cls clsAcr = new COM_AccountContactRelation_cls ();
            clsAcr.contadorRepLegales(lstCon);
            clsAcr.contadorRepLegales(lstAccContRel);
        Test.stopTest();
    }    
//Final v1.1
    
}