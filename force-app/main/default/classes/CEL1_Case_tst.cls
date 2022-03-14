/************************************************************************************************
Desarrollado por:  Globant
Autor:             Andrea Contreras(AC)
Proyecto:          Compensar
Descripción:       Test Class of CEL1_Case_cls 

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/12/19         Andrea Contreras  (AC)    Creación Clase.   
**************************************************************************************************/
@isTest
public class CEL1_Case_tst {
  private static void createData(Id idCuenta){
        List<RF2_ConfAudCasos__mdt> ojbLst = [SELECT DeveloperName,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c FROM RF2_ConfAudCasos__mdt];
        
        RF2_ContAudCasos__c conf = new RF2_ContAudCasos__c();
        conf.Name = '1';
        conf.RF2_ConEnvioCasoCalidadGIE__c = ojbLst.get(0).RF2_RecEnvioCalidadGIE__c;
        conf.RF2_ConEnvioCasoCalidadPCE__c = ojbLst.get(0).RF2_RecEnvioCalidadPCE__c;
        conf.RF2_ConEnvioSondeoPCE__c = ojbLst.get(0).RF2_RecEnvioSondeoPCE__c;
        insert conf;
        
        //Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
        
        Entitlement ent = new Entitlement();
        ent.AccountId = idCuenta;
        ent.Name = Label.RF2_NombreANSGenerico_lbl;
        ent.RF2_Canal__c = 'Call Center';
        ent.Rf2_GCN__c = 'Otros';
        ent.RF2_ObligatorioCalidad__c = false;
        insert ent;
                
        // crear mas entittlements para completar
        
        /*List<Entitlement> entitlementListGen = [SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSGenerico_lbl];
        if(entitlementListGen.isEmpty())
        system.debug('no hay nada niño!! ');*/
        
    }
    @isTest static void test_method_1(){
        Test.startTest();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Queja', 'URL PCE', 'Alimentos', 'Aportes', 'Pagina Web', false);
        caso.Status='Abierto';
        caso.Origin ='Chat';
        caso.RF2_GCN__c='Vacios';
        update caso;
        Test.stopTest();
    }
}