/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase RL2_AccountHelper_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     18/06/21        Jorge Pozo (JPA)      Creación Clase.
************************************************************************************************/
@isTest
public class RL2_AccountHelper_tst {
    private static String idRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
    
    @isTest
    public static void asignacionMiembroDeEquipo_tst() {
        List<Lead> listLead1 = new List <Lead>();
        Lead objCandidato1                      =   new Lead();
        objCandidato1.FirstName                 =   'Prueba';
        objCandidato1.MiddleName                =   'Test';
        objCandidato1.LastName                  =   'Compensar';
        objCandidato1.CEL1_TipoDocumento__c     =   '1';
        objCandidato1.CEL1_NumeroDocumento__c   =   '18800990077';
        objCandidato1.Email                     =   'prueba@prueba.com';
        objCandidato1.Status					=	'Nuevo';
        objCandidato1.CEL1_TipoAportante__c		= 	'Empresa no afiliada';
		objCandidato1.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead1.add(objCandidato1);
        insert listLead1;
        
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '18800990077';
        
        Test.startTest();
        try {
            insert objCuenta;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CUENTA: ' + e.getMessage());
        }
        Test.stopTest();
        
        Account acc = [SELECT OwnerId FROM Account WHERE Id =: objCuenta.Id];
        System.assertEquals(objCandidato1.OwnerId, objCuenta.OwnerId, 'Diferentes propietarios');
    }

}