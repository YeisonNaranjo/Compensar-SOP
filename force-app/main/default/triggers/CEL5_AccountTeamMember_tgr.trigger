/************************************************************************************************
Desarrollado por:  Globant
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Trigger del objeto AccountTeamMember

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/02/20         Manuel Mendez  (MM)                    Creación Clase.
**************************************************************************************************/
trigger CEL5_AccountTeamMember_tgr on AccountTeamMember (before insert,before update, after insert, after update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert) {
            CEL5_AccountTeamMemberHandler_cls.beforeInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {
            CEL5_AccountTeamMemberHandler_cls.beforeUpdate(Trigger.new, Trigger.old);
        }
    }
    if (Trigger.isAfter) {
       if (Trigger.isInsert) {
            CEL5_AccountTeamMemberHandler_cls.afterInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {
            CEL5_AccountTeamMemberHandler_cls.afterUpdate(Trigger.new,Trigger.old);
        }
    }
}