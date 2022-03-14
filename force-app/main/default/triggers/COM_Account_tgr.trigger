/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Trigger del objeto Account

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     10/08/17             Cristian David Mejia (CM)             Creación Clase.
2.0     15/08/17             Daniel Alejandro López Monsalve (DL)  Incluye método crear contacto en PersNat
3.0     20/08/17             Daniel Alejandro López Monsalve (DL)  Incluye método crear contacto en PersNat
4.0     22/11/17             Nicolas Laverde Pinzón (NLP)          Incluyo método actualizaContactoCuentasNatural
4.1     27/07/18             Stifen Panche Gutierrez (SPG)         Controles de Ejecución
4.2     05/07/19             Jordan Parra (JP)                     Se realiza un ajuste en el control de ejecución
5.0		23/01/20			 Yeison Naranjo (YN)				   Ajuste no llenar ARL cuando no esta activo el flag ARL.
para permitir la inserción de dos cuentas en 1
transacción a partir de la integración caso
NOLA 00262442
6.0     12/02/20             Paula Bohórquez Alfonso(PBA)           CEL1 - Se incluye método para asignación de propietario a 
                                                                    candidatos asociados a cuenta acreedora para clientes 
                                                                    que se crean desde portal web.
7.0		18/06/21			Jorge Pozo (JPA)						After Insert - Se agregó el método RL2_AccountHelper_cls.asignacionMiembroDeEquipo()
7.0		18/06/21			Jorge Pozo (JPA)						Before Insert - Se agregó el método RL2_AccountHelper_cls.actualizarTipoRegistro()
************************************************************************************************/
trigger COM_Account_tgr on Account
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
    /*Inicio  v4.2 */
    public static Integer contador;
    if(contador == null){
        contador = 0;
    }else{
        contador++;
    }
    system.debug('Contador::: '+contador);
    /*Final   v4.2*/
    
    //if(COM_AccountContactRelation_cls.canIRun()){
    system.debug('::::::::::::::::::::: Account Trigger');
    COM_AccountContactRelation_cls  clsRelAccount = new COM_AccountContactRelation_cls ();
    COM_Account_cls clsAccount = new COM_Account_cls();


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
            //CEL1 - PB
            if(Trigger.isUpdate){
                
                System.debug('===>> AFTERUPDMIGRACION: va a entrar asignarPropietarioCandidatoCA');
                clsAccount.asignarPropietarioCandidatoCA(Trigger.newMap,Trigger.oldMap);
            }
            //CEL1 - PB FIN
        }
        if(Trigger.IsBefore && Trigger.isInsert)
            {
                 clsAccount.validarDuplicadosCA(Trigger.new);

        }
        if(Trigger.IsBefore && Trigger.isUpdate)
        {   
            clsRelAccount.actualizaContactoCuentasNatural(trigger.new);
        }
    }
    //Caso en el que la fase del proyecto es producción.
    else if (faseProyecto == 'PRODUCCION'){
        clsAccount = new COM_Account_cls();
        COM_AsignacionCuenta_cls asignaCuenta = new COM_AsignacionCuenta_cls();
        COM_NormalizarDireccion_cls clsNormalizaDireccion = new COM_NormalizarDireccion_cls();
        
        if (Trigger.isBefore)
        {
            /*Inicio 4.1*/
            //if(Trigger.isInsert)
            if(Trigger.isInsert  && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Account_tgr', 'BeforeInsert' ))
            {
                /*Fin 4.1*/
                system.debug('::::::::::::::::::::: Account Before Insert');
                RL2_AccountHelper_cls.actualizarTipoRegistro(Trigger.new);
                clsAccount.validarDuplicadosCA(Trigger.new);
                clsAccount.GenerarDigitoNit(null,trigger.new);
                asignaCuenta.asignarAdminitrador(trigger.new);
                clsAccount.actualizarName(trigger.new);
                /* Inicio 5.0 */
                asignaCuenta.validarEsARL(trigger.new);
                /* Fin 5.0 */
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'BeforeInsert' );
            }
            /*Inicio 4.1*/
            //else if (Trigger.isUpdate)
            else if (Trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Account_tgr', 'BeforeUpdate' ))
            {
                /*Fin 4.1*/
                system.debug('::::::::::::::::::::: Account Before Update');
                clsAccount.GenerarDigitoNit(trigger.old,trigger.new);
                clsAccount.CalcularFechaPazYSalvo(trigger.new);
                clsAccount.actualizarName(trigger.new);
                /* Inicio 5.0 */
                asignaCuenta.validarEsARL(trigger.new);
                /* Fin 5.0 */
                clsRelAccount.actualizaContactoCuentasNatural(trigger.new);
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'BeforeUpdate' );
                
            }
            
        } else if (Trigger.isAfter)
        {
            /*Inicio 4.1*/
            //if(trigger.isInsert)
            /*Incio v4.2*/
            //if(trigger.isInsert && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Account_tgr', 'AfterInsert' )) //Se comenta esta líena de código (JP) v4.2
            //{Se comenta esta línea de código (JP) v4.2
            /*Fin 4.1*/
            if (Trigger.isInsert){
                //if (!COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Account_tgr', 'AfterInsert')){
                /*Final v4.2*/
                system.debug('::::::::::::::::::::: Account After Insert');
                //Actualizaciones para personas naturales.
                clsRelAccount.crearContactoCuentaNatural(trigger.new);
                clsRelAccount.asociarRepresentanteLegal(trigger.new);
                clsNormalizaDireccion.normalizarDireccion(null, trigger.new);
                asignaCuenta.asignarCuenta(trigger.New);
                RL2_AccountHelper_cls.asignacionMiembroDeEquipo(trigger.New);
                /*Inicio v4.2*/           
                //COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'AfterInsert' );
            }
            //}
            // }Se comenta esta línea de código (JP) v4.2
            /*Final  v4.2*/
            /*Inicio 4.1*/
            //else if (Trigger.isUpdate)
            else if (Trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone( 'COM_Account_tgr', 'AfterUpdate' ))
                /*Fin 4.1*/
            {
                
                /*Inicio 4.1*/
                Cuentas_Usuarios_Cargue__c CS = Cuentas_Usuarios_Cargue__c.getInstance();
                /*Fin 4.1*/

                //CEL1 - PB
                if(Trigger.isUpdate){
                    System.debug('===>> AFTERUPDPRODUCCION: va a entrar asignarPropietarioCandidatoCA');
                    clsAccount.asignarPropietarioCandidatoCA(Trigger.newMap,Trigger.oldMap);
                }
                //CEL1 - PB FIN
                
                
                system.debug('::::::::::::::::::::: Account After Update');
                if(!(system.isBatch() || system.isFuture())){
                    
                    /*Inicio 4.1*/
                    
                    if(CS.blnTieneAcceso__c)
                    {
                        /*Fin 4.1*/
                        system.debug('>>>>>>>>>>>>>>> actualizarClientesGC');
                        clsAccount.actualizarClientesGC(trigger.old, trigger.new);
                    }
                    clsNormalizaDireccion.normalizarDireccion(trigger.old, trigger.new);
                }
                COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'AfterUpdate' );
                
            }
        }
    }
    //}
    
}