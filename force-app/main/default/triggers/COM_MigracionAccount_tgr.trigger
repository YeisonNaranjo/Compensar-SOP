/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Daniel Alejandro López Monsalve (DL)
Proyecto:          Compensar
Descripción:       Trigger del objeto Account para el proceso de migración
                   Se debe deshabilitar después de la migración. 

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     02/10/17             Daniel Alejandro López Monsalve (DL)     Creación Clase.
************************************************************************************************/
trigger COM_MigracionAccount_tgr on Account 
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
   
    if(COM_UtilidadesMigracion_cls.canIRun()){
        system.debug('::::::::::::::::::::: Account Trigger Migración');
        COM_UtilidadesMigracion_cls  clsRelAccount = new COM_UtilidadesMigracion_cls ();
        String faseProyecto = System.Label.COM_FaseProyecto;
        if (faseProyecto == 'MIGRACION'){
             system.debug('::::::::::::::::::::: Account Trigger Fase Migracion');
             //Método que crea un contacto asociado a la cuenta para persona natural
             // @dlopez Septiembre 17 2017
             if (Trigger.isAfter) 
                {
                    if(trigger.isInsert)
                    {
                        
                        clsRelAccount.crearContactoCuentaNatural(trigger.new);
                    }
                 }
        }
        
        
        //Caso en el que la fase del proyecto es producción.
        else if (faseProyecto == 'PRODUCCION'){
                
               
                            
        }
      }
}