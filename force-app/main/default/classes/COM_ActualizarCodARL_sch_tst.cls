/****************************************************************************************************
Información general
-------------------
author: Yeison Naranjo
email: yeison.naranjo@globant.com
company: Globant Colombia
Description: Clase COM_ActualizarCodARL_sch_tst clase de pruebas de COM_ActualizarCodARL_sch

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       05-Febrero-2020 Yeison Naranjo               Creación de la Clase
****************************************************************************************************/
@istest
public class COM_ActualizarCodARL_sch_tst {
    static testmethod void testbatch() { 
         
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'BeforeInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'BeforeUpdate' );
        
        Account accTest = new Account();
        accTest.Name = 'prueba1';
        accTest.COM_EsARL__c = False;
        accTest.COM_CodigoARL__c = '22';
        accTest.COM_Movil__c = '3258978569';
        insert accTest;
        
        Test.startTest();
        COM_ActualizarCodARL_bch prueba_batch = new COM_ActualizarCodARL_bch();
        Database.executeBatch(prueba_batch);
        Test.stopTest();
        
        accTest.COM_EsARL__c = False;
        accTest.COM_CodigoARL__c = '22';
        update accTest;
    }
    
    static testmethod void testscheduler() {
        Test.startTest();
        COM_ActualizarCodARL_sch sh1 = new COM_ActualizarCodARL_sch();
        String sch = '0 0 2 * * ?';
        system.schedule('Test schedule', sch, sh1);
        Test.stopTest();
    }
}