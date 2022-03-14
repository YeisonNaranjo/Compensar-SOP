trigger COM_Contact_tgr on Contact (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {
    
    
        String faseProyecto = System.Label.COM_FaseProyecto;
        
        if (faseProyecto == 'MIGRACION'){
    
        }
        
        else if (faseProyecto == 'PRODUCCION'){
        
            COM_AccountContactRelation_cls clsAccContact = new COM_AccountContactRelation_cls();
    
            if (Trigger.isBefore) {
                //call your handler.before method
            
            } else if (Trigger.isAfter && Trigger.isDelete) {
            //call handler.after method
            //System.debug('WA va a actualizar despues de delete COM_Contact_tgr');
            clsAccContact.contadorRepLegales(trigger.old);  
            }
        }
}