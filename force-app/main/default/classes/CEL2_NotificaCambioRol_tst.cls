/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase de prueba para clase CEL5_AsignacionAccountTM_cls
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     19/02/20         Manuel Mendez  (MM)                    Creación Clase.
**************************************************************************************************/ 
@istest
public with sharing class CEL2_NotificaCambioRol_tst {
    @istest
    public static void unit_Test1() {
        Account objAccount = COM_DataGenerator_cls.crearCuenta(true);
        Contact objContact = COM_DataGenerator_cls.crearContacto(true,objAccount.Id);
        AccountContactRelation objACR = COM_DataGenerator_cls.crearContRelation(true,objAccount.Id,objContact.Id);
        System.debug('objACR.....'+objACR);
        Test.startTest();
            objACR.Roles = 'Mercadeo';
            update objACR;
        Test.stopTest();
    }

    @istest
    public static void unit_Test2() {
        Account objAccount = COM_DataGenerator_cls.crearCuenta(true);
        Contact objContact = COM_DataGenerator_cls.crearContacto(true,objAccount.Id);
        AccountTeamMember objACT = COM_DataGenerator_cls.crearAccountTeamMember(false,objAccount.Id);
        objACT.TeamMemberRole   =   'Especialista mercadeo';
        insert objACT;
        AccountContactRelation objACR = COM_DataGenerator_cls.crearContRelation(true,objAccount.Id,objContact.Id);
        System.debug('objACR.....'+objACR);
        Test.startTest();
            objACR.Roles = 'Mercadeo';
            update objACR;
        Test.stopTest();
    }

    @istest
    public static void unit_Test3() {
        Account account = COM_DataGenerator_cls.crearCuenta4(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert account;
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        Account objAc = COM_DataGenerator_cls.crearCuenta3(true);
        Contact objContact;
        objContact = new Contact();
        objContact.FirstName = 'Raul';
        objContact.LastName = 'Jimenez';
        objContact.AccountId = objAc.Id;
        objContact.Email = 'raul@micorreo.com';
        objContact.COM_TipoIdentificacion__c = '1';
        objContact.COM_Numeroidentificacion__c = '8800990077';
        insert objContact;
        System.debug('objContact.....'+objContact);
        AccountContactRelation objACC = [SELECT Id, Roles FROM AccountContactRelation WHERE AccountId =:account.Id];
        
        AccountContactRelation objACR = COM_DataGenerator_cls.crearContRelation(true,account.Id,objContact.Id);
        
        System.debug('objACR.....'+objACR);
        System.debug('objACC.....'+objACC);
        // System.debug('cont2.....'+cont2);
        System.debug('cont.....'+cont);
        System.debug('account.....'+account);
        
        Test.startTest();
            delete objACR;
        Test.stopTest();
    }

    @istest
    public static void unit_Test4() {
        Account account = COM_DataGenerator_cls.crearCuenta4(false);
        account.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert account;
        AccountTeamMember objACT = COM_DataGenerator_cls.crearAccountTeamMember(false,account.Id);
        objACT.TeamMemberRole   =   'Especialista mercadeo';
        insert objACT;
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        Account objAc = COM_DataGenerator_cls.crearCuenta3(true);
        Contact objContact;
        objContact = new Contact();
        objContact.FirstName = 'Raul';
        objContact.LastName = 'Jimenez';
        objContact.AccountId = objAc.Id;
        objContact.Email = 'raul@micorreo.com';
        objContact.COM_TipoIdentificacion__c = '1';
        objContact.COM_Numeroidentificacion__c = '8800990077';
        insert objContact;
        System.debug('objContact.....'+objContact);
        AccountContactRelation objACC = [SELECT Id, Roles FROM AccountContactRelation WHERE AccountId =:account.Id];
        
        AccountContactRelation objACR = COM_DataGenerator_cls.crearContRelation(true,account.Id,objContact.Id);
        
        System.debug('objACR.....'+objACR);
        System.debug('objACC.....'+objACC);
        // System.debug('cont2.....'+cont2);
        System.debug('cont.....'+cont);
        System.debug('account.....'+account);
        
        Test.startTest();
            delete objACR;
        Test.stopTest();
    }
}