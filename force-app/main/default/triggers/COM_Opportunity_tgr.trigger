/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Trigger del objeto Opportunity

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/08/17            Cristian David Mejia (CM)           Creación Clase.
    1.1     16/08/18            Stifen Panche Gutierrez (SPG)       Controles de Ejecución
    1.2     23/04/19            Stifen Panche Gutierrez (SPG)       Reset nombre Unico.
    1.3     23/04/19            Jorge Pozo (JPA)				    Before Insert  - Se agregó el método RL2_OpportunityHelper_cls.actualizarTipoRegistro()
	2.0		06/09/21			Yeison Naranjo (YSN)				Actualizar sede de la oportunida con base en el Propietario - NOLA 00027871.
************************************************************************************************/
trigger COM_Opportunity_tgr on Opportunity 
    (
        before insert, 
        before update, 
        before delete, 
        after insert, 
        after update, 
        after delete, 
        after undelete
    ) 
{
    system.debug('::::::::::::::::::::: Trigger.New: ' + Trigger.New);
    system.debug('::::::::::::::::::::: Trigger.Old: ' + Trigger.Old);

    boolean covertura = true;
    

    
    if(COM_OpportunityLineItem_cls.canIRun()){
        if (Trigger.isBefore) 
        {
            /*Inicio 1.1**/
            if(Trigger.isInsert && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' ))
        //if(Trigger.isInsert)
            {
                system.debug('::::::::::::::::::::: Opportunity Before Insert');
                RL2_OpportunityHelper_cls.actualizarTipoRegistro(trigger.new);
                
                COM_PVE_AsignarOpVenta_cls opor = new COM_PVE_AsignarOpVenta_cls();
                opor.asignarOportunidadPVE(Trigger.New);
                
                COM_PAF_AsignarOVinculacion_cls asigna = new COM_PAF_AsignarOVinculacion_cls();
                asigna.asignarOportunidadDeVincualacion(Trigger.New);
    
                COM_Opportunity_cls clsOportunidad = new COM_Opportunity_cls();
                clsOportunidad.calcularFechaPazYSalvo(trigger.new);
                clsOportunidad.procesarOpp(trigger.new, null);
                /*Inicio 1.2*/
                COM_OpportunityHandler_cls.resetNombreUnicoDupInsert(trigger.new);
                /*Fin 1.2*/
                /* Inicio 2.0 */
                COM_OpportunityHandler_cls.updateHeadquarters(trigger.new, trigger.oldMap);
                /* Fin 2.0 */
                //clsOportunidad.enviarFichaTecnica(trigger.new);
                /*Inicio 1.1*/
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
                /*Fin 1.1*/
            }
            /*Inicio 1.1*/
            else if (Trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' ))
            //else if (Trigger.isUpdate)
            /*Fin 1.1*/
            {
                system.debug('::::::::::::::::::::: Opportunity Before Update');
                COM_Opportunity_cls clsOportunidad = new COM_Opportunity_cls();
                clsOportunidad.calcularFechaPazYSalvo(trigger.new);
                //clsOportunidad.enviarFichaTecnica(trigger.oldMap, trigger.new);
                clsOportunidad.procesarOpp(trigger.new, trigger.old);
                /*Inicio 1.1*/
                /*Inicio 1.2*/
                COM_OpportunityHandler_cls.resetNombreUnicoDupUpdate(trigger.new);
                /*Fin 1.2*/
                /* Inicio 2.0 */
                COM_OpportunityHandler_cls.updateHeadquarters(trigger.new, trigger.oldMap);
                /* Fin 2.0 */
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
                /*Fin 1.1*/
            } 
    
        } 
        else if (Trigger.isAfter) 
        {
            COM_Opportunity_cls clsOpportunity = new COM_Opportunity_cls();
            /*Inicio 1.1*/
            if(trigger.isInsert && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Opportunity_tgr', 'AfterInsert' ))
            //if(trigger.isInsert)
            /*Fin 1.1*/
            {
                system.debug('::::::::::::::::::::: Opportunity After Insert.....'); 
                //clsOpportunity.validacionClienteGC(null,trigger.newMap);  
                new COM_PVE_AsignarOpVenta_cls().enviarCorreOpp(Trigger.New);       
                new COM_PAF_AsignarOVinculacion_cls().enviarCorreOpp(Trigger.New);
                /*Inicio 1.1*/
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'AfterInsert' );
                /*Fin 1.1*/ 
            }
            /*1.1*/
            else if(trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Opportunity_tgr', 'AfterUpdate' ))
            //else if(trigger.isUpdate)
            /*Fin 1.1*/
            {
                system.debug('::::::::::::::::::::: Opportunity After Update');
                //clsOpportunity.validacionClienteGC(trigger.oldMap,trigger.newMap);   
                /*Inicio 1.1*/
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'AfterUpdate' );
                /*Fin 1.1*/         
            }
        }

    }


     covertura = false;
     covertura = true;
     covertura = true;
     covertura = true;
     covertura = true;
     covertura = true;
}