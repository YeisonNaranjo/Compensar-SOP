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
public with sharing class CEL5_AsignacionAccountTM_tst {
    @istest
    public static void unit_Test1(){
        Account objAcc = COM_DataGenerator_cls.crearCuenta(true);
        User objUser = [SELECT Id,ProfileId FROM User WHERE IsActive = true AND Profile.Name = 'Asesor - PAF' LIMIT 1];
        AccountTeamMember objAccTM = new AccountTeamMember();
        objAccTM.AccountId = objAcc.Id;
        objAccTM.AccountAccessLevel         =   'Edit';
        objAccTM.CaseAccessLevel            =   'Edit';
        objAccTM.OpportunityAccessLevel     =   'Edit';
        objAccTM.TeamMemberRole             =   'COM_AuxiliarAdministrativoPAF';
        objAccTM.UserId                     =   objUser.Id;
        insert objAccTM;

        User objUser2 = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'Asesor - PAF' ORDER BY CreatedDate ASC NULLS FIRST limit 1];
        AccountTeamMember objAccTM2 = new AccountTeamMember();
        objAccTM2.AccountId = objAcc.Id;
        objAccTM2.AccountAccessLevel         =   'Edit';
        objAccTM2.CaseAccessLevel            =   'Edit';
        objAccTM2.OpportunityAccessLevel     =   'Edit';
        objAccTM2.TeamMemberRole             =   'COM_AuxiliarAdministrativoPAF';
        objAccTM2.UserId                     =   objUser2.Id;

        Test.startTest();
        try {
            insert objAccTM2;
        } catch (Exception e) {
            System.assert(e.getMessage().contains(label.CEL5_ErrorAccountTM));      
        }
        Test.stopTest();
    }
}