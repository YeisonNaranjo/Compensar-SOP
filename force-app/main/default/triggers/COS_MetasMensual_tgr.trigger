/************************************************************************************************
Desarrollado por:  Globant
Autor:             Yeison Naranjo (YSN)
Proyecto:          Compensar
Descripción:       Trigger del objeto Metas Mensuales

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.		Fecha			Autor					Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0		06/09/21		Yeison Naranjo (YSN)	Creación Clase.
************************************************************************************************/

trigger COS_MetasMensual_tgr on COM_MetasMensual__c (before insert, before update) {
    If(Trigger.isBefore){
        If(Trigger.isInsert && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COS_MetasMensual_tgr', 'BeforeInsert' )){
            COS_MetasMensualHandler_cls.updateHeadquarters(trigger.new);
            COM_TriggerExecutionControl_cls.setAlreadyDone( 'COS_MetasMensual_tgr', 'BeforeInsert' );
        }
        
        If(Trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COS_MetasMensual_tgr', 'BeforeUpdate' )){
            COS_MetasMensualHandler_cls.updateHeadquarters(trigger.new);
            COM_TriggerExecutionControl_cls.setAlreadyDone( 'COS_MetasMensual_tgr', 'BeforeUpdate' );
        }
    }
}