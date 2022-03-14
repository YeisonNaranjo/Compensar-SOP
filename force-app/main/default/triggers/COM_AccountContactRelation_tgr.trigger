/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Trigger del objeto AccountContactRelation

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/07/17             Cristian David Mejia (CM)             Creación Clase.
    ************************************************************************************************/
    trigger COM_AccountContactRelation_tgr on AccountContactRelation (
        before insert, 
        before update, 
        before delete, 
        after insert, 
        after update, 
        after delete) 
    {

       String faseProyecto = System.Label.COM_FaseProyecto;

       if (faseProyecto == 'MIGRACION'){




       }
       else if (faseProyecto == 'PRODUCCION'){
         COM_AccountContactRelation_cls clsAccContact = new COM_AccountContactRelation_cls();
                /*if (Trigger.isBefore) 
                {
                    //call your handler.before metho
                    System.debug('WA estoy entrando antes');
                } 
                else */ 
                if (Trigger.isAfter) 
                {
                    if(trigger.isInsert)
                    {
                        System.debug('WA va a actualizar despues de insert o update COM_AccountContactRelation_tgr');
                        clsAccContact.contadorRepLegales(trigger.new);
                        
                    }
                    
                    else if (trigger.isUpdate) {
                        System.debug('WA va a actualizar despues de update COM_AccountContactRelation_tgr');
                        clsAccContact.contadorRepLegales(trigger.new);
                        System.debug('ENTRO A NOTIFICARCAMBIO....');
                        CEL2_NotificaCambioRol_cls.notificarCambio(trigger.new,trigger.old);
                    }
                    else if(trigger.isDelete)
                    {
                        //System.debug('WA va a actualizar despues de delete COM_AccountContactRelation_tgr');
                        clsAccContact.contadorRepLegales(trigger.old);
                        CEL2_NotificaCambioRol_cls.notificarCambioDelete(trigger.old);
                    }
                }
                
                
            }
        }