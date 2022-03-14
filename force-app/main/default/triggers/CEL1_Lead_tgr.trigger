/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Trigger del objeto Lead

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     30/10/19         Manuel Mendez  (MM)                    Creación Clase.
**************************************************************************************************/
trigger CEL1_Lead_tgr on Lead (before insert,before update,after insert,after update) {
    
    if(!COM_TriggerExecutionControl_cls.hasAlreadyDone('CEL1_Lead_tgr','BEFORE')) 
    {	
        if(Trigger.isBefore){
            if (Trigger.isInsert) {
                CEL1_LeadHandler_cls.beforeInsert(Trigger.new);
            }
            
            if (Trigger.isUpdate) {
                CEL1_LeadHandler_cls.beforeUpdate(Trigger.new, Trigger.old);
            }
        }}
    if(!COM_TriggerExecutionControl_cls.hasAlreadyDone('CEL1_Lead_tgr','AFTER')) 
    {	
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                CEL1_LeadHandler_cls.afterInsert(Trigger.newMap);
            }
            
            if (Trigger.isUpdate) {
                CEL1_LeadHandler_cls.afterUpdate(Trigger.new,Trigger.oldMap);
            }
        }
    }
}