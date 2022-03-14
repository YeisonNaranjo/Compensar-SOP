/****************************************************************************************************
Información general
-------------------
author: Elkin Córdoba
email: ecordoba@avanxo.com
company: Avanxo Colombia
Description: Clase de prueba de la clase COM_ActualizarCasosColas_queue

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       30-Jul-2018     Elkin Córdoba       Creación de la Clase
****************************************************************************************************/
@isTest
class COM_ActualizarCasosColas_queue_tst {     

    /*private static void createData(Id idCuenta){
        List<RF2_ConfAudCasos__mdt> ojbLst = [SELECT DeveloperName,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c FROM RF2_ConfAudCasos__mdt];
        
        RF2_ContAudCasos__c conf = new RF2_ContAudCasos__c();
        conf.Name = '1';
        conf.RF2_ConEnvioCasoCalidadGIE__c = ojbLst.get(0).RF2_RecEnvioCalidadGIE__c;
        conf.RF2_ConEnvioCasoCalidadPCE__c = ojbLst.get(0).RF2_RecEnvioCalidadPCE__c;
        conf.RF2_ConEnvioSondeoPCE__c = ojbLst.get(0).RF2_RecEnvioSondeoPCE__c;
        insert conf;
        Entitlement ent = new Entitlement();
        ent.AccountId = idCuenta;
        ent.Name = Label.RF2_NombreANSGenerico_lbl;
        ent.RF2_Canal__c = 'Call Center';
        ent.Rf2_GCN__c = 'Otros';
        ent.RF2_ObligatorioCalidad__c = false;
        insert ent;
    }
    
    @testSetup static void createDataTest(){
        
        DescribeFieldResult describe = Case.RF2_ProcesoDestinoMatrizResponsable__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);       
    }*/
           
    static testmethod void enqueuJobTest() {
        Test.startTest();        
        System.enqueueJob(new COM_ActualizarCasosColas_queue());
        Test.stopTest();
    }
}