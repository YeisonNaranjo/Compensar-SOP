/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase RL2_CopiarSetupAuditTrail_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     19/07/21        Jorge Pozo (JPA)      	Creación Clase.
************************************************************************************************/
@isTest(SeeAllData=true)
public class RL2_CopiarSetupAuditTrail_tst {
    
    @isTest
    public static void getObtenerRegistrosAuditoria() {
        Test.startTest();
        RL2_CopiarSetupAuditTrail_cls.getObtenerRegistrosAuditoria();
        Test.stopTest();
    }
    
    @isTest
    public static void getObtenerRegistrosAuditoriaDiaria() {
        Test.startTest();
        RL2_CopiarSetupAuditTrail_cls.getObtenerRegistrosAuditoriaDiaria();
        Test.stopTest();
    }
    
    @isTest
    public static void copiarSetupAuditTrail() {
        Test.startTest();
        RL2_CopiarSetupAuditTrail_sch clsSCH = new RL2_CopiarSetupAuditTrail_sch();
        String sch = '0 0 23 * * ?';
        System.schedule('Test check', sch, clsSCH);
        Test.stopTest();
    }
    
    @isTest
    public static void notificacionSetupAuditTrail() {
        Test.startTest();
        RL2_NotificacionSetupAuditTrail_sch clsSCH = new RL2_NotificacionSetupAuditTrail_sch();
        String sch = '0 0 23 * * ?';
        System.schedule('Test check', sch, clsSCH);
        Test.stopTest();
    }

}