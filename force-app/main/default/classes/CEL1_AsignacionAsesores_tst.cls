/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase de prueba para clase CEL1_AsignacionAsesores_cls
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     06/11/19         Manuel Mendez  (MM)                    Creación Clase.
**************************************************************************************************/ 
@istest
public with sharing class CEL1_AsignacionAsesores_tst {
    @istest
    public static void unit_Test1(){

        User objUser = [SELECT Id FROM User LIMIT 1];

        COM_Asignacion__c objAsignacion         =   new COM_Asignacion__c();
        objAsignacion.COM_FechaAsignacion__c    =   System.now();
        objAsignacion.COM_perfil__c             =   'Asesor - PAF';
        objAsignacion.COM_Usuario__c            =   objUser.Id;
        objAsignacion.CEL1_Asignado__c          =   false;
        insert objAsignacion;

        COM_Asignacion__c objAsignacion2         =   new COM_Asignacion__c();
        objAsignacion2.COM_FechaAsignacion__c    =   System.now();
        objAsignacion2.COM_perfil__c             =   'Asesor - PAF';
        objAsignacion2.COM_Usuario__c            =   objUser.Id;
        objAsignacion2.CEL1_Asignado__c          =   true;
        insert objAsignacion2;

        List<Lead> lstInsert = new  List<Lead>();

        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '983483748374';
        objCandidato.Email                      =   'prueba@prueba.com';
        lstInsert.add(objCandidato);

        Lead objCandidato2                       =   new Lead();
        objCandidato2.FirstName                  =   'Prueba';
        objCandidato2.MiddleName                 =   'Test';
        objCandidato2.LastName                   =   'Compensar';
        objCandidato2.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato2.CEL1_TipoDocumento__c      =   '1';
        objCandidato2.CEL1_NumeroDocumento__c    =   '9834837';
        objCandidato2.Email                      =   'prueba@prueba.com';
        lstInsert.add(objCandidato2);

        Lead objCandidato3                       =   new Lead();
        objCandidato3.FirstName                  =   'Prueba';
        objCandidato3.MiddleName                 =   'Test';
        objCandidato3.LastName                   =   'Compensar';
        objCandidato3.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato3.CEL1_TipoDocumento__c      =   '1';
        objCandidato3.CEL1_NumeroDocumento__c    =   '98348375435';
        objCandidato3.Email                      =   'prueba@prueba.com';
        lstInsert.add(objCandidato3);
        
        Test.startTest();
            insert lstInsert;
        Test.stopTest();
    }
}