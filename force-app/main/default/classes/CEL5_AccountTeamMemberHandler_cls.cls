/************************************************************************************************
Desarrollado por:  Globant
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase Handler para Trigger CEL5_AccountTeamMember_tgr
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/02/20         Manuel Mendez  (MM)                    Creación Clase.
**************************************************************************************************/
public with sharing class CEL5_AccountTeamMemberHandler_cls {
    public static void beforeInsert(List<AccountTeamMember> lstNewAccountTeamMember)
    {
        CEL5_AsignacionAccountTM_cls.validaAsesor(lstNewAccountTeamMember);
    }

    public static void beforeUpdate(List<AccountTeamMember> lstNewAccountTeamMember,List<AccountTeamMember> lstOldAccountTeamMember)
    {
        // CEL5_AsignacionAccountTM_cls.validaAsesor(lstNewAccountTeamMember);
    }

    public static void afterInsert(List<AccountTeamMember> lstNewAccountTeamMember)
    {
        // CEL5_AsignacionAccountTM_cls.validaAsesor(lstNewAccountTeamMember);
    }

    public static void afterUpdate(List<AccountTeamMember> lstNewAccountTeamMember,List<AccountTeamMember> lstOldAccountTeamMember)
    {
        
    }
}