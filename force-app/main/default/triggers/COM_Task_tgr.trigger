/****************************************************************************************************
    -------------------
    Developer:        Avanxo Colombia
    Autor:            Jordan Steven Parra Torres
    Project:          Compensar
    Description:      
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     2018-06-12  Jordan Steven Parra Torres  Trigger creado para la ejecución de la clase COM_TaskTriggerHandler_cls.
    ------  ----------  --------------------------  -----------
    2.0     2020-08-21  Yeison Stic Naranjo Rendón  Actualización campo tipo de actividad.
 ****************************************************************************************************/

// Inicio 2.0 trigger COM_Task_tgr on Task (before delete) {
trigger COM_Task_tgr on Task (before delete, after insert, after update) {
/* Fin 2.0 */
	if(trigger.isBefore && trigger.isDelete){
		COM_TaskTriggerHandler_cls.CheckTask(trigger.old);
	}
/* Inicio 2.0 */
    if(trigger.isAfter && trigger.isInsert){
        COM_TaskTriggerHandler_cls.UpdateActivityType(trigger.new);
    }
    /* Fin 2.0 */
}