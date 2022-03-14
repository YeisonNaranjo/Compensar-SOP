/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz
Proyecto:          Compensar
Descripción:       trigger de OpportunityLineItem

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     05/10/2017      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
trigger COM_OpportunityLineItem_tgr on OpportunityLineItem (after insert, after update, before insert, before update) {
	
	
	if (Trigger.isBefore){
		COM_OpportunityLineItem_cls objOpportunityLineItem = new COM_OpportunityLineItem_cls();
		if(Trigger.isInsert){
			system.debug('................ Trigger Before Insert');
			objOpportunityLineItem.procesarOpportunityLineItem(trigger.new, null);
		}
		
		if(Trigger.isUpdate){
			system.debug('................ Trigger Before Update');
			objOpportunityLineItem.procesarOpportunityLineItem(trigger.new, trigger.old);
		}
		
	}
    
}