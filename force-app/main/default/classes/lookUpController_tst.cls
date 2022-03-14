/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       clase de prueba para crear consultas dinamicas para componente de lookup
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     30/10/19         Manuel Mendez  (MM)                    Creación Clase.
*************************************************************************************************/
@istest
public with sharing class lookUpController_tst {
    @istest public static void unit_Test1(){

        Test.startTest();
            lookUpController.obtenerQuery('RF2_Negocio__c',null,'Prueba');
        Test.stopTest();
    }

    @istest 
    public static void unit_Test2(){
        
        RF2_Negocio__c objNegocio = new RF2_Negocio__c();
        objNegocio.Name = 'Prueba Negocio';
        insert objNegocio;

         RF2_Programa__c objPrograma = new RF2_Programa__c();
         objPrograma.Name   =  'Prueba programa';
         objPrograma.RF2_Negocio__c = objNegocio.Id;
         insert objPrograma;

        Test.startTest();
            // RF2_Programa__c objPrograma = [SELECT Id, Name FROM RF2_Programa__c LIMIT 1];
            // System.debug('objPrograma----->>>'+objPrograma);
            String strFiltro = 'RF2_Negocio__c=' + '\'' +String.valueOf(objPrograma.Id) + '\'';
            lookUpController.obtenerQuery('RF2_Programa__c',strFiltro,null);
        Test.stopTest();
    }

    @istest
    public static void unit_Test3(){

        RF2_Negocio__c objNegocio = new RF2_Negocio__c();
        objNegocio.Name = 'Prueba Negocio';
        insert objNegocio;

         RF2_Programa__c objPrograma = new RF2_Programa__c();
         objPrograma.Name   =  'Prueba programa';
         objPrograma.RF2_Negocio__c = objNegocio.Id;
         insert objPrograma;

        Test.startTest();
            // RF2_Programa__c objPrograma = [SELECT Id, Name FROM RF2_Programa__c LIMIT 1];
            // System.debug('objPrograma----->>>'+objPrograma);
            String strFiltro = 'RF2_Negocio__c=' + '\'' +String.valueOf(objPrograma.Id) + '\'';
            lookUpController.obtenerQuery('RF2_Programa__c',strFiltro,'Prueba');
        Test.stopTest();
    }
}