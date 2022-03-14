/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             William Aldana (WA)
Proyecto:          Compensar
Descripción:       Trigger del objeto Case

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     1/11/17         William Aldana  (WA)    Creación Clase.
2.0     3/04/18         Stifen Panche   (SP)    Actualiza Equipo de casos de caso Calidad.
3.0     13/04/18        Carlos Villalba (CAV)   Agregado el metodo ValidaSedeRadicacion.
4.0     11/12/19        Andrea Contreras(AC)    Agregar logica para cambiar ANS cuando el caso se actualiza
5.0     21/09/20        Yeison Naranjo  (YN)    Actualizar descripción caso hijo NOLA 00020107.
6.0     26/04/21        Yeison Naranjo  (YN)    Ajuste error batch envio encuesta NOLA 00025030.
7.0     19/07/21        Stifen Panche   (SP)    Se cambia el envío de encuestas sobre la plantilla de cierre de caso NOLA 00025030.
8.0		22/10/2021		Yeison Naranjo	(YN)	No generar encuesta para envio en batch.
**************************************************************************************************/
trigger RF2_Case_tgr on Case (
    before insert, 
    before update,
    after insert,
    after update) {
        
        if(RF2_Case_cls.canIRun()){
            if (Trigger.isBefore) {            
                if(Trigger.isInsert && !COM_TriggerExecutionControl_cls.hasAlreadyDone('RF2_Case_tgr', 'beforeInsert')){
                    RF2_Case_cls caseprocess = new RF2_Case_cls();
                    caseprocess.CasoAnonimo(Trigger.new);
                    caseprocess.CopiarCorreo(Trigger.new);
                    caseprocess.CalcularFechaLimite(Trigger.new);
                    /* CAV:: V8.0*/
                    caseprocess.ValidaSedeRadicacion(Trigger.new);
                    /* CAV:: v8.0*/
                    caseprocess.AsignarResponsableCaso(Trigger.old, Trigger.new);
                    //caseprocess.CalcularFechaPazYSalvo(Trigger.old, Trigger.new);
                    
                    //Asignacion de Casos SALUD ----
                    COS_AsignacionCasosSalud_cls.asignacionCasos(Trigger.new);
                    
                    /* Inicio 5.0 */
                    System.debug('getProfileId: ' + Userinfo.getProfileId() + ' COM_System_Administrator_ID: ' + Label.COM_System_Administrator_ID);
                    if(Userinfo.getProfileId() != Label.COM_System_Administrator_ID){
                        caseprocess.AsignarDescription(Trigger.new);                    
                    }  
                    /* Fin 5.0 */
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeInsert');
                }else if(Trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone('RF2_Case_tgr', 'beforeUpdate')){
                    /*for(Case obj : Trigger.old){                    
Trigger.new.get(0).addError('No se puede modificar un caso en estado Cerrado');
}*/                        
                    System.debug('AsignarResponsableCaso');
                    RF2_Case_cls caseprocess = new RF2_Case_cls();
                    caseprocess.CasoAnonimo(Trigger.new);
                    caseprocess.AsignarResponsableCaso(Trigger.old, Trigger.new);
                    caseprocess.AsignarCasoACalidad(Trigger.old, Trigger.new);
                    caseprocess.AsignarCasoASondeo(Trigger.old, Trigger.new);
                    caseprocess.CalcularFechaPazYSalvo(Trigger.old, Trigger.new);
                    caseprocess.CerrarHitosTodos(Trigger.old, Trigger.new);
                    caseprocess.CalcularDiasGestion(Trigger.old, Trigger.new); 
                    /* Inicio 5.0 */
                    System.debug('getProfileId: ' + Userinfo.getProfileId() + ' COM_System_Administrator_ID: ' + Label.COM_System_Administrator_ID);
                    if(Userinfo.getProfileId() != Label.COM_System_Administrator_ID){
                        caseprocess.AsignarDescription(Trigger.new);                    
                    }                
                    /* Fin 5.0 */
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeUpdate');
                    
                    /* Inicio 6.0 */
                    System.debug('Entro Trigger de CASO :: ');
                    CEL1_Case_cls caseClass = new CEL1_Case_cls();
                    caseClass.buscarANSCaso(Trigger.old, Trigger.new);
                    /* Fin 6.0*/
                }
                /* Inicio 6.0 if(Trigger.isUpdate){
System.debug('Entro Trigger de CASO :: ');
CEL1_Case_cls caseClass = new CEL1_Case_cls();
caseClass.buscarANSCaso(Trigger.old, Trigger.new);
} Fin 6.0*/
            } 
            if (Trigger.isAfter) {
                if(Trigger.isInsert && !COM_TriggerExecutionControl_cls.hasAlreadyDone('RF2_Case_tgr', 'afterInsert')){
                    RF2_Case_cls caseprocess = new RF2_Case_cls();
                    caseprocess.CopiarFechaAns(Trigger.new);
                    caseprocess.AsignarPropetario(Trigger.new);
                    caseprocess.PrimerContacto(Trigger.new);
                    // 8.0 caseprocess.enviarEncuestaPCE(Trigger.old, Trigger.new);
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterInsert');
                    
                }
                if(Trigger.isUpdate && !COM_TriggerExecutionControl_cls.hasAlreadyDone('RF2_Case_tgr', 'afterUpdate')){
                    RF2_Case_cls caseprocess = new RF2_Case_cls();
                    caseprocess.CerrarHitos(Trigger.old, Trigger.new);
                    caseprocess.AsignarPropetario(Trigger.new);
                    // 8.0 caseprocess.enviarEncuestaPCE(Trigger.old, Trigger.new);
                    if(!System.IsBatch() && !System.isFuture()){ 
                    caseprocess.CopiarFechaAns(Trigger.new);
                    }
                    /*Inicio 2.0*/
                    // caseprocess.actualizarAnalistaCalidad(Trigger.oldMap, Trigger.newMap);
                    /*Fin 2.0*/
                    COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
                }
            }
        }
    }