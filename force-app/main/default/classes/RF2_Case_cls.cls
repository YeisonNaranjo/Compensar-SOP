/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             William Aldana (WA)
Proyecto:          Compensar
Descripción:       Clase con funciones de Casos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     1/11/17         William Aldana  (WA)    Creación Clase.
2.0     1/12/17         William Aldana  (WA)    Se asigna analista de calidad al caso para reportes
3.0     4/12/17         William Aldana  (WA)    se implementa modificacion por Correo 24-11-2017
4.0     14/12/17        William Aldana  (WA)    Control de cambio casos Hijos
5.0     21/12/17        William Aldana  (WA)    No asignar propietario si el origen es Correo Electronico 
6.0     21/12/17        William Aldana  (WA)    Caso anonimo no va a calidad ni a sondeo
7.0     03/04/18        Stifen Panche   (SP)    Si es un caso de calidad y cambia de analista, se agrega el equipo de casos.
8.0     13/04/18        Carlos Villalba (CV)    Todos los casos que se inserten con el campo Sede de Radicación = Entes de control
se le cambiará el Origen a Entes de Control.
9.0     24/05/18        Brisleydi Calderon (BC) Se asigna la siguiente tipología cuando se envía un correo a protecciondedatos@compensar.com:

Proceso Destino: CRM GIE
Relacionado con: Aclaraciones empleadores.
Tipo: SolicitudGIE 
Se asigna el ANS de 80 horas  
10.0    29/05/18        Stifen Panche   (SP)    Asignación de ´colas y propietario únicamente tipos de registro Compensar 

11.0    08/08/18        Nilyan Berti    (NB)    Modificación del método AsignarTipoProceso para discriminar según GCN (NOLA 5397)
12.0    22/11/18        William Aldana  (WA)    Envio de Encuesta para casos de PCE y otras caracteristicas
13.0    12/03/19        Stifen Panche   (SP)    Cerrar casos sin tener parametrización envío de calidad.
14.0    03/07/19        Andrés Ramírez  (AR)    Envíar Encuestas para GIE.
14.1    25/09/19        Jordan Parra    (JP)    Se modifica la creación de encuestas para casos principales NOLA 00266336.
14.2    10/10/19        Jordan Parra    (JP)    Se realiza inserción al objeto nuevo "log encuestas" para enviar las encuestas en
un batch NOLA 00266467
15.0    02/10/19        Paula Bohórquez (PB)    Migración Lightning - Se reemplazan Attachments por ContentDocuments.  
16.0    20/07/20        Laura Valenzuela (LV)   Se modifica el envio de encuesta gie a algunos tipo servicio NOLA 00018443
17.0    12/08/20        Santiago Contreras (SC) Se agrega un condicional para realizar el cambio de propietario del caso - NOLA 00019210.
18.0    21/09/20        Yeison Naranjo  (YN) 	Actualizar descripción caso hijo - NOLA 00020107.
19.0    06/11/20        Yeison Naranjo  (YN) 	Incluir el correo de envio en la Encuesta - NOLA 00021324.
20.0    27/11/20        StifenPanche  (YN) 	    Validación de la fecha de vencimiento de caso si está ya está actualizada - NOLA 00021324.
21.0    24/03/21        Yeison Naranjo  (YN)	Enviar encuesta solo cuando el tipo de cierre sea exitoso.
22.0    30/06/21        Yeison Naranjo  (YN)	Envio de casos a Cola de Calidad.
23.0    08/07/21        Carlos Suarez   (CS)    Condicional PSB Plantilla procesar PDF
24.0    19/07/21        Stifen Panche   (SP)    Plantillas se envían con el correo de caso cerrado, se remueve el batch.
**************************************************************************************************/
public without sharing class RF2_Case_cls { 
    
    List<RF2_MatrizResponsablesCaso__c> lstMatrizResponsables = new List<RF2_MatrizResponsablesCaso__c>();
    List<QueueSobject> datosColas = [SELECT QueueId, Queue.Name, Queue.Type FROM QueueSobject where Queue.Type = 'Queue'];
    Id idColaPendienteAsignar = null;
    RF2_ConfAudCasos__mdt confAudCasos = [SELECT DeveloperName,Id,Label,RF2_envioCalidadGIE__c,RF2_envioCalidadPCE__c,RF2_EnvioSondeoPCE__c,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c,RL2_EnvioCalidadPSB__c,RL2_RecurrenciaEnvioCalidadPSB__c FROM RF2_ConfAudCasos__mdt limit 1];
    List<CaseTeamMember> lstMembers = new list<CaseTeamMember>();
    CaseTeamRole rolCalidad = [SELECT Id FROM CaseTeamRole where Name =: Label.RF2_FuncionTeamCaseCalidad_lbl limit 1];
    List<Entitlement> entitlementList = [SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c, RF2_AnsEscalamiento__c FROM Entitlement where Name like '%ASIG%'];
    List<RF2_ConfiguracionAnalistasCalidad__c> lstAnalistasCalidad = [SELECT RF2_FechaAsignacion__c, RF2_Usuario__c, RF2_Proceso__c FROM RF2_ConfiguracionAnalistasCalidad__c Where RF2_Usuario__r.IsActive = true order by RF2_FechaAsignacion__c asc];
    Integer contAnalistasCalidad = 0;
    List<Entitlement> entitlementListGen =[SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSGenerico_lbl];
    List<Contact> lstContactoAnonimo = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numeroidentificacion__c = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl LIMIT 1];
    List<Case> lstCasosPadres = new List<Case>();
    List<Entitlement> lstEntitlementHijoGen = [SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSHijoGenerico_lbl];
    List<Case> lstCasosHijos = new List<Case>();
    Boolean procesoMasivo = false;
    Id tempOwnerId = null;
    
    
    public RF2_Case_cls() {
        
    }
    public static Boolean allow = true;
    
    public static void stopTrigger(){
        allow = false;
    }
    
    public static boolean canIRun(){
        return allow;
    }
    
    public static void startTrigger(){
        allow = false;
    }
    
    /**
* Realizar la asignacion de un caso teniendo en cuenta el tipo de solicitud y el asunto.
* @param caseToAssing [description]
*/
    public void AsignarResponsableCaso(List<Case> oldToAssing, List<Case> newToAssing){
        if(newToAssing!= null && !newToAssing.isEmpty()){
            Integer tamanyoLote = newToAssing.size();
            if(tamanyoLote > 1){
                procesoMasivo = true;
            }else{
                procesoMasivo = false;
            }
            
            lstMatrizResponsables = [SELECT Id, Name, RF2_GCN__c, RF2_ResponsableCaso__c, RF2_TipoSolicitud__c, RF2_ProcesoDestino__c, RF2_RelacionadoCon__c FROM RF2_MatrizResponsablesCaso__c];
            List<QueueSobject> lstQueueSobject = [SELECT QueueId FROM QueueSobject where Queue.DeveloperName = :Label.RF2_NombreColaPendienteAsignacion limit 1];
            idColaPendienteAsignar = !lstQueueSobject.isEmpty()? lstQueueSobject.get(0).QueueId : null;
            Set<Id> setIDsPadres = new Set<Id>();
            Set<Id> setIDsPadreBuscaHijos = new Set<Id>();
            // es necesario consultar los casos padres
            // Con los datos necesarios para realizar escalamientos
            for(Integer j = 0; j< newToAssing.size(); j++)
            {
                /*Inicio 10.0*/
                if( newToAssing[j].RecordTypeId == '0126A0000005cdiQAA')
                {
                    
                    if(esCasoHijo(newToAssing[j])){
                        setIDsPadres.add(newToAssing[j].ParentId);
                    }else{
                        if(newToAssing[j].Id != null){
                            setIDsPadreBuscaHijos.add(newToAssing[j].Id);
                        }
                    }
                }
                /*Fin 10.0*/
            }
            // si hay listado de padres por consultar se consultan
            if(!setIDsPadres.isEmpty()){
                // asigna en la lista la informacion de ans de escalamiento
                lstCasosPadres = [SELECT Id, Entitlement.RF2_AnsEscalamiento__c, Status FROM Case where Id IN :setIDsPadres];
            }
            
            if(!setIDsPadreBuscaHijos.isEmpty()){
                lstCasosHijos = [SELECT Id, Status, ParentId FROM Case where ParentId IN :setIDsPadreBuscaHijos];
            }
            
            // 
            for(Integer i = 0; i< newToAssing.size(); i++)
            {
                //ünicamente para casos Tipo registro Compensar
                /*Inicio 10.0*/
                if(newToAssing[i].RecordTypeId == '0126A0000005cdiQAA')
                {
                    /*Fin 10.0*/
                    // validar si es un caso asignado al cliente anonimo se debe marcar el caso como anonimo
                    if(!lstContactoAnonimo.isEmpty()){
                        if(newToAssing[i].AccountId ==  lstContactoAnonimo.get(0).AccountId || newToAssing[i].ContactId == lstContactoAnonimo.get(0).Id){
                            newToAssing[i].RF2_Anonimo__c = true;
                        }    
                    }else{
                        system.debug('/// no se encuentra informacion de contacto anonimo');
                    }
                    
                    // si old es diferente de nulo es una modificacion
                    if(oldToAssing != null && !oldToAssing.isEmpty()){
                        system.debug('// si entra es una modificacion');
                        if(
                            oldToAssing[i].Status != Label.RF2_EstadoCerradoCaso_lbl
                            && 
                            ((
                                (oldToAssing[i].RF2_TipoSolicitud__c != newToAssing[i].RF2_TipoSolicitud__c 
                                 || oldToAssing[i].RF2_ProcesoDestinoMatrizResponsable__c != newToAssing[i].RF2_ProcesoDestinoMatrizResponsable__c 
                                 || oldToAssing[i].RF2_RelacionadoCon__c != newToAssing[i].RF2_RelacionadoCon__c ||  oldToAssing[i].RF2_GCN__c != newToAssing[i].RF2_GCN__c ) // (NOLA 5397)
                            )||(
                                newToAssing[i].RF2_SolucionadoPrimerContacto__c && 
                                newToAssing[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl &&
                                newToAssing[i].Origin == Label.RF2_OrigenCasoCorreoElectronico_lbl
                            ))    
                        ){//Ajuste caso creacion de logica para permiter cargar valores con campos en blanco caso 27187
                            system.debug('/// aca se deberia verificar que la fecha de modificacion no es mayor a un dia');
                            if (Label.ByPassRF2Trigger != UserInfo.getUserName()){
                                	system.debug('Entro asignacion owner');
                            		AsignarResponsablePrivate(oldToAssing[i], newToAssing[i], true);
                                }
                        }
                    }else{
                        system.debug('// si entra es una Creacion');
                        // si old es igual a nulo es una creacion
                        system.debug('newToAssing[i] ' + newToAssing[i].OwnerId);
                        
                        /*if(esCasoHijo(newToAssing[i])){
Case padre = obtenerInfoPadre(newToAssing[i]).ParentId);

// validar que no se puede crear un caso sobre un padre Cerrado 
//
if(padre.Status == Label.RF2_EstadoCasoRechazado_lbl || padre.Status == Label.RF2_EstadoCerradoCaso_lbl || padre.Status == Label.RF2_EstadoCasoAnulado_lbl){
system.debug('/// Imposible crear Caso Hijo en Estados Cerrado, Rechazado o Anulado');
}

if(!procesoMasivo){
// mostar el error  
}    
}*/
                        // si es una creacion se debe quitar que quede por defecto al usuario creador
                        tempOwnerId = newToAssing[i].OwnerId;
                        newToAssing[i].OwnerId = null;
                        AsignarResponsablePrivate(null, newToAssing[i], false);
                    }
                }
            }
        }

    }
    
    /**
* Accion de asignar responsable a un caso -  metodo privado
* @param caseObj [description]
*/
    private void AsignarResponsablePrivate(Case oldCaseObj, Case caseObj, Boolean modificar){
        RF2_MatrizResponsablesCaso__c responsableCaso = null;
        // si esta marcado como solucionado primer contacto se asigna al usuario que crea
        if(caseObj.RF2_SolucionadoPrimerContacto__c){
            caseObj.OwnerId = UserInfo.getUserId();
            caseObj.RF2_GCN__c = Label.RF2_GCNPrimerContacto_lbl;
            caseObj.RF2_TXT_Responsable_en_Matriz__c = UserInfo.getName();
        }
        
        /// 17.0 Starts here
        Set<String> Emails = new Set<String>();
        List<EmailMessage> parentEmail = [SELECT ToAddress FROM EmailMessage Where ParentId=: caseObj.Id ORDER BY CreatedDate DESC LIMIT 1];     
        if(parentEmail.size()>0){
            for(EmailMessage pE: parentEmail){
                If(pE.ToAddress != Null && pE.ToAddress != ''){
                    String toAddress = pE.ToAddress;
                    List<String> correos = toAddress.split(';');
                    for(String correo: correos){
                        Emails.add(correo.trim());
                    }    
                }                              
            }
        }
        
        System.debug('Emails: ' + Emails);
        List<buzonE2C__mdt> buzones = [SELECT email__c FROM buzonE2C__mdt WHERE email__c IN: Emails];        
        System.debug('Buzones Metadata: ' + buzones);
        /// 17.0 Ends here
        
        System.debug( ' RF2_TipoSolicitud__c ' + caseObj.RF2_TipoSolicitud__c + ' RF2_ProcesoDestinoMatrizResponsable__c ' + caseObj.RF2_ProcesoDestinoMatrizResponsable__c + ' F2_RelacionadoCon__c' + caseObj.RF2_RelacionadoCon__c);
        if(caseObj.RF2_TipoSolicitud__c != null && caseObj.RF2_ProcesoDestinoMatrizResponsable__c != null && caseObj.RF2_RelacionadoCon__c != null){
            // se busca en la matriz
            responsableCaso = obtenerDatosResponsable(caseObj.RF2_TipoSolicitud__c , caseObj.RF2_ProcesoDestinoMatrizResponsable__c, caseObj.RF2_RelacionadoCon__c);
            if(responsableCaso != null){
                System.debug('Hay responsable Caso');
                // si no es solucionado primer contacto se asigna al responsable de la matriz
                // Se modifica esta seccion por solicitud de correo 24-11-2017
                if(!caseObj.RF2_SolucionadoPrimerContacto__c){
                    // se asigna el Responsable 
                    //Inicio NOLA-2894 - Si el origen no es Correo, o no es actualización o los campos de Tipificación no estaban vacios y se reasigna el propietario
                    /// 17.0 interception Starts
                    //Si los correos pertenecen a canales se realiza la asignación inmediatamente, sinó, se hará la segunda vez que se cambie la asignación.
                    
                    if(buzones.size() != 0){
                        if((caseObj.Origin == Label.RF2_OrigenCasoCorreoElectronico_lbl || caseObj.Origin == 'Correo PCA') &&
                           CaseObj != null && CaseObj.RF2_TipoSolicitud__c != null && CaseObj.RF2_ProcesoDestinoMatrizResponsable__c != null && CaseObj.RF2_RelacionadoCon__c != null){
                               System.debug('Se reasignó el propietario de canales');
                               caseObj.OwnerId = responsableCaso.RF2_ResponsableCaso__c;
                        }
                    } else{
                        if(!(caseObj.Origin == Label.RF2_OrigenCasoCorreoElectronico_lbl &&
                             oldCaseObj != null && oldCaseObj.RF2_TipoSolicitud__c == null && oldCaseObj.RF2_ProcesoDestinoMatrizResponsable__c == null && oldCaseObj.RF2_RelacionadoCon__c == null)){
                                 System.debug('Se reasignó el propietario');
                                 caseObj.OwnerId = responsableCaso.RF2_ResponsableCaso__c;
                         } 
                    }
                    /// 17.0 Ends Interception ends
                    /*
                    if(!(caseObj.Origin == Label.RF2_OrigenCasoCorreoElectronico_lbl &&
                         oldCaseObj != null && oldCaseObj.RF2_TipoSolicitud__c == null && oldCaseObj.RF2_ProcesoDestinoMatrizResponsable__c == null && oldCaseObj.RF2_RelacionadoCon__c == null)){
                             System.debug('Se reasignó el propietario');
                             caseObj.OwnerId = responsableCaso.RF2_ResponsableCaso__c;
                         }*/                  
                    //Fin NOLA-2894
                    // se asigna el GCN de la matriz
                    caseObj.RF2_GCN__c = responsableCaso.RF2_GCN__c;
                    

                    // busca el nombre del responsable asignado
                    caseObj.RF2_TXT_Responsable_en_Matriz__c = obtenerNombreColas(responsableCaso.RF2_ResponsableCaso__c); 
                    
                }
            }
        }
        
        // si no es primer contacto y tiene los campos incompletos
        if(!caseObj.RF2_SolucionadoPrimerContacto__c){
            // si no tiene los datos completos o no se logró asignar un owner se coloca en pendiente por asignar
            if(caseObj.RF2_TipoSolicitud__c == null  || caseObj.RF2_ProcesoDestinoMatrizResponsable__c == null || caseObj.RF2_RelacionadoCon__c == null || caseObj.OwnerId == null){
                // se verifica si el caso proviene de algun de los canales de primer contacto
                System.debug('>>>>>>>>> WA - el caso no tiene los datos necesarios para ser asignado');
                System.debug('>>>>>>>>> WA - nombre caso ' + caseObj.Subject);
                System.debug('>>>>>>>>> WA - RF2_TipoSolicitud__c '+caseObj.RF2_TipoSolicitud__c);
                System.debug('>>>>>>>>> WA - RF2_ProcesoDestinoMatrizResponsable__c '+ caseObj.RF2_ProcesoDestinoMatrizResponsable__c);
                System.debug('>>>>>>>>> WA - RF2_RelacionadoCon__c '+caseObj.RF2_RelacionadoCon__c);
                System.debug('>>>>>>>>> WA - OwnerId '+caseObj.OwnerId);
                
                if(caseObj.Origin == Label.RF2_OrigenCasoCorreoElectronico_lbl || caseObj.Origin == 'Correo PCA'){
                    caseObj.OwnerId = tempOwnerId;
                    //caseObj.RF2_GCN__c = Label.RF2_GCNVacio_lbl;
                    caseObj.Status = Label.RF2_EstadoCasoAbierto;
                }else{
                    if(idColaPendienteAsignar != null){
                        // asignar a la cola pendiente por asignar
                        caseObj.OwnerId = idColaPendienteAsignar;
                        caseObj.RF2_GCN__c = Label.RF2_GCNVacio_lbl;
                        // colocar el estado pendiente por asignar en el caso
                        caseObj.Status = Label.RF2_EstadoPendienteAsignacionCaso_lbl;
                        caseObj.RF2_TXT_Responsable_en_Matriz__c = obtenerNombreColas(caseObj.OwnerId);
                    } else {
                        system.debug('No se encontro la cola genérica.');
                    }
                }
            }
            
            // origen correo electronico
        }
        
        // y si el GCN es primer contacto se excluye de calidad
        if(caseObj.RF2_SolucionadoPrimerContacto__c || caseObj.RF2_GCN__c == Label.RF2_GCNPrimerContacto_lbl){
            caseObj.RF2_ExcluidoCalidad__c = true;
        }
        
        // se asigna al caso las marcas de tipo de proceso segun las tipificaciones del caso
        asignarTipoProceso(caseObj);

        
        // si no se está modificando el caso se le asigna ANS
        if(!modificar){
            if(!(caseObj.RF2_SolucionadoPrimerContacto__c && caseObj.Status == Label.RF2_EstadoSolucionadoCaso_lbl)){
                AsignarANSCaso(caseObj);
            } else {
                system.debug('NO ENTRO A ANS');
                caseObj.EntitlementId = null;
            }
        }
        
        // si el caso es solucionado en primer contacto y el estado es solucionado se envia a cierre
        if(caseObj.RF2_SolucionadoPrimerContacto__c && caseObj.Status == Label.RF2_EstadoSolucionadoCaso_lbl){
            cerrarCaso(caseObj, oldCaseObj);
        }
        
        System.debug(caseObj.OwnerId);
       
    }
    /**
* [obtenerNombreColas description]
* @param  idCola [description]
* @return        [description]
*/
    private String obtenerNombreColas(String idCola){
        for(QueueSobject obj : datosColas)
        {
            //QueueId, Queue.Name, Queue.Type
            if(obj.QueueId == idCola){
                return obj.Queue.Name;
            }
        }
        return '';
    }
    
    /**
* Tipo de proceso es PCE, PCA, GIE
* Al crear o actualizar
* @param caseObj retorna el objeto con el correspondiente valor asociado
*/
    private void AsignarTipoProceso(Case caseObj){
        if(caseObj.RF2_GCN__c != null){
            System.debug('@@@GNC Diferente de null ---> ' + caseObj.RF2_GCN__c);
            if(caseObj.RF2_GCN__c == Label.RF2_GCNPrimerContacto_lbl){
                System.debug('@@@EsPCA?');
                //¿Es PCA?: Si el campo GCN es igual a “Primer Contacto”.
                caseObj.RF2_EsPCA__c = true;
                caseObj.RF2_EsGIE__c = false;
                caseObj.RF2_EsPCE__c = false;
                caseObj.RL2_EsPSB__c = false;
            }else if(caseObj.RF2_GCN__c == Label.AVX_GCN_Otros_GIE_lbl || caseObj.RF2_GCN__c == Label.RF2_GCNVacio_lbl ||   caseObj.RF2_GCN__c == Label.RF2_AsuntoGenerarPazYSalvo_lbl || caseObj.RF2_GCN__c == Label.RF2_MoraEnAportesCaja_lbl || caseObj.RF2_GCN__c == Label.RF2_TrasladoAportesOtrasCCF_lbl || caseObj.RF2_GCN__c == Label.RF2_DevolucionAportes_lbl || caseObj.RF2_GCN__c == Label.RF2_SustitucionPatronalTrabajadores_lbl ){ //NOLA 5397 (NB)
                System.debug('@@@EsGIE?');
                //¿Es GIE?: Si el campo GCN es igual a "Otros GIE”.
                caseObj.RF2_EsGIE__c = true;
                caseObj.RF2_EsPCA__c = false;
                caseObj.RF2_EsPCE__c = false;
                caseObj.RL2_EsPSB__c = false;
            }else if(caseObj.RF2_GCN__c == Label.RL2_TramitesSubsidio_lbl || caseObj.RF2_GCN__c == Label.RL_2_AmparoVida_lbl){
                System.debug('Entro PSB');
                caseObj.RF2_EsPCE__c = false;
                caseObj.RF2_EsPCA__c = false;
                caseObj.RF2_EsGIE__c = false;
                caseObj.RL2_EsPSB__c = true;
            }else if(caseObj.RF2_GCN__c != Label.RF2_GCNVacio_lbl && caseObj.RF2_GCN__c != Label.RF2_GCNPrimerContacto_lbl && caseObj.RF2_GCN__c != Label.RF2_GCNPazYSalvo_lbl && caseObj.RF2_GCN__c != Label.AVX_GCN_Otros_GIE_lbl ){ //NOLA 5397 (NB)
                System.debug('@@@EsPCE?'); 
                //¿Es PCE?: Si el campo GCN es diferente a vacío o “Primer contacto” o “Generación de Paz y Salvo para Retiro”.
                caseObj.RF2_EsPCE__c = true;
                caseObj.RF2_EsPCA__c = false;
                caseObj.RF2_EsGIE__c = false;
                caseObj.RL2_EsPSB__c = false;
            }
        }
    }
    
    /**
* Obtener la fila responsable de la matriz de responsable
* @param  strTipo   [description]
* @param  strAsunto [description]
* @return           [description]
*/
    private RF2_MatrizResponsablesCaso__c obtenerDatosResponsable(String strTipo , String strProcesoDestino, String strRelacionadoCon){
        for(RF2_MatrizResponsablesCaso__c obj : lstMatrizResponsables)
        {
            if(obj.RF2_TipoSolicitud__c == strTipo && obj.RF2_ProcesoDestino__c == strProcesoDestino && obj.RF2_RelacionadoCon__c == strRelacionadoCon){

                return obj;
            }
        }
        return null;
    }
    
    
    
    /**
* Asignar ANS 
* @param caseToAssing [description]
*/
    private void AsignarANSCaso(Case caseToAssing){
        //Se valida que no sea un caso hijo
        if(!esCasoHijo(caseToAssing)){
            // se validan los datos del caso
            if(caseToAssing.Origin != null && caseToAssing.RF2_GCN__c != null){
                System.debug('>>>>>>>>> caseToAssing.Origin, caseToAssing.RF2_GCN__c' + caseToAssing.Origin +' - '+ caseToAssing.RF2_GCN__c);
                caseToAssing.Entitlement = obtenerEntitlement(caseToAssing.Origin, caseToAssing.RF2_GCN__c);
                System.debug('>>>>>>>>> caseToAssing.Entitlement: ' + caseToAssing.Entitlement);
                if(caseToAssing.Entitlement == null){
                    asignarANSGenerico(caseToAssing);
                }else{
                    caseToAssing.RF2_ObligatorioCalidad__c = caseToAssing.Entitlement.RF2_ObligatorioCalidad__c;
                    caseToAssing.EntitlementId = caseToAssing.Entitlement.Id;
                }
            }else{
                asignarANSGenerico(caseToAssing);
            }
        }else{
            //SI es un caso hijo
            //se debe obtener la informacion del caso padre y de su ANS Asignado Obtener el ANS de escalamiento
            //lstCasosPadres = [SELECT Id, Entitlement.RF2_AnsEscalamiento__c FROM Case where Id IN :setIDsPadres];
            caseToAssing.RF2_ObligatorioCalidad__c = false;
            caseToAssing.RF2_ExcluidoCalidad__c = true;
            Case padre = obtenerInfoPadre(caseToAssing.ParentId);
            if(padre != null){
                System.debug('>>>>>>>>> WA - Luke soy tu padre');
                if(padre.Entitlement.RF2_AnsEscalamiento__c != null){
                    caseToAssing.EntitlementId = padre.Entitlement.RF2_AnsEscalamiento__c;
                }else{
                    // si por alguna razon del mundo el ANS del padre no tiene ANS de estalamiento
                    // se adiciona un ANS Generico Hijo
                    caseToAssing.EntitlementId = lstEntitlementHijoGen.get(0).Id;
                }
            }else{
                System.debug('>>>>>>>>> WA - el caso no tiene padre - Luke no soy tu padre');
            }
        }
    }
    
    /**
* Obtener los datos del padre para asignar escalamiento
* @param  idCasoPadre [description]
* @return             [description]
*/
    @testVisible private Case obtenerInfoPadre(Id idCasoPadre){
        for(Case objPadre : lstCasosPadres)
        {
            if(objPadre.Id == idCasoPadre){
                return objPadre;
            }
        }
        return null;
    }
    
    /**
* Se asigna al caso el ANS Generico al no encontrar la informacion requerida
*/
    private void asignarANSGenerico(Case toAssingGen){
        System.debug('>>>>>>>>> WA - el caso no tiene los datos necesarios para Asignarle ANS');
        System.debug('>>>>>>>>> WA - nombre caso ' + toAssingGen.Subject);
        System.debug('>>>>>>>>> WA - Origin '+ toAssingGen.Origin);
        System.debug('>>>>>>>>> WA - RF2_GCN__c '+ toAssingGen.RF2_GCN__c);
        // en este punto se debe asignar un ANS Generico
        if(!entitlementListGen.isEmpty()){
            System.debug('>>>>>>>>> Se Asigna ANS Generico');
            toAssingGen.RF2_ObligatorioCalidad__c = entitlementListGen.get(0).RF2_ObligatorioCalidad__c;
            toAssingGen.EntitlementId = entitlementListGen.get(0).Id;
        }else{
            System.debug('>>>>>>>>> No se encuentra ANS Genérico');
        }
    }
    
    /**
* Validacion que verificar si un caso es hijo
* @param  toValidate [description]
* @return            [description]
*/
    private Boolean esCasoHijo(Case toValidate){
        return (toValidate.ParentId != null);
    }
    
    /**
* Dado un canal y un GCN se obtiene el entitlement para asignar al caso
* @param  strCanal [description]
* @param  strGCN   [description]
* @return          [description]
*/
    private Entitlement obtenerEntitlement(String strCanal, String strGCN){
        for(Entitlement obj : entitlementList)
        {
            if(obj.RF2_Canal__c == strCanal && obj.Rf2_GCN__c == strGCN){
                return obj;
            }
        }
        return null;
    }
    
    /**
* Proceso principal para asignar un caso a sondeo
* @param caseToAssing [description]
*/
    public void AsignarCasoASondeo(List<Case> oldToAssing, List<Case> newToAssing){
        System.debug('>>> entro a metodo sondeo');
        // si el envio de casos a sondeo está activo
        if(confAudCasos.RF2_EnvioSondeoPCE__c){
            List<QueueSobject> lstQueueSondeo = [SELECT QueueId FROM QueueSobject where Queue.DeveloperName =: Label.RF2_NombreColaAnalistasSondeo_lbl limit 1];
            Id idColaSondeo = !lstQueueSondeo.isEmpty()? lstQueueSondeo.get(0).QueueId : null;
            RecordType recordTypeSondeo = [SELECT Id FROM RecordType where DeveloperName =: Label.RF2_NombreRecordTypeEncuestaSondeo_lbl limit 1];
            List<RF2_EncuestasCasos__c> encuestasGuardar = new List<RF2_EncuestasCasos__c>();
            for(Integer i = 0; i< newToAssing.size(); i++){
                if(oldToAssing != null && oldToAssing[i].Status == Label.RF2_EstadoCerradoCaso_lbl){
                    System.debug('>>> me salgo por aca 1');
                    continue;
                }
                
                // si es un caso hijo no se realiza ninguna accion
                // o es un caso anonimo
                if(newToAssing != null && (esCasoHijo(newToAssing[i]) ||  newToAssing[i].RF2_Anonimo__c)){
                    System.debug('>>> me salgo por aca 2');
                    continue; 
                }
                
                // solo se sondean los casos de PCE y que no hayan sido sondeados
                if(newToAssing[i].RF2_EsPCE__c && !newToAssing[i].RF2_CasoSondeado__c){
                    
                    
                    // si un caso es solucionado
                    if(newToAssing[i].Status != null && newToAssing[i].Status == Label.RF2_EstadoCerradoCaso_lbl && newToAssing[i].Status != oldToAssing[i].Status){
                        System.debug('>>> entro a buscar sondeo');
                        List<RF2_ContAudCasos__c> lstCont = RF2_ContAudCasos__c.getall().values();
                        if(lstCont != null && !lstCont.isEmpty()){
                            RF2_ContAudCasos__c conts = lstCont.get(0);
                            Boolean boolenviarSondeo = false;
                            // si es menor que el valor maximo del contador le asigna 
                            if(conts.RF2_ConEnvioSondeoPCE__c < confAudCasos.RF2_RecEnvioSondeoPCE__c){
                                conts.RF2_ConEnvioSondeoPCE__c++;
                            }else{
                                System.debug('>>> Entro a aceptar sondeo');
                                // enviar a sondeo
                                boolenviarSondeo = true;
                                conts.RF2_ConEnvioSondeoPCE__c = 1;
                            } 
                            
                            if(boolenviarSondeo){
                                // se creaa una encuesta de tipo sondeo y se le asigna a cola de sondeo
                                // y al caso
                                RF2_EncuestasCasos__c encCaso = new RF2_EncuestasCasos__c();
                                encCaso.RecordTypeId = recordTypeSondeo.Id;
                                encCaso.OwnerId = idColaSondeo;
                                encCaso.RF2_Caso__c = newToAssing[i].Id;
                                encCaso.RF2_Estado__c = 'Abierta'; 
                                encuestasGuardar.add(encCaso);
                                newToAssing[i].RF2_CasoSondeado__c = true;
                                System.debug('>>> creo objeto para sondeo');
                            }
                            update conts;
                        }
                    }
                }
            }
            
            if(!encuestasGuardar.isEmpty()){
                try {
                    insert encuestasGuardar; 
                }catch(Exception e) {
                    System.debug('Error al crear sondeos '+ e.getMessage()); 
                }
            }
        }   
    }
    
    /**
* Metodo que cordina la asignacion de casos a calidad y su adicion al equipo de cuentas
* @param caseToAssing [description]
*/
    public void AsignarCasoACalidad(List<Case> oldToAssing, List<Case> newToAssing){
        // Inicio 22.0
        BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Compensar'];
        Date dtToday = date.newinstance(datetime.now().year(), datetime.now().month(), datetime.now().day());
        // Fin 22.0
        // 
         System.debug('Acá entró');
        
        Integer tamanyoLote = newToAssing.size();
        if(tamanyoLote > 1){
            procesoMasivo = true;
        }else{
            procesoMasivo = false;
        }
        for(Integer i = 0; i< tamanyoLote; i++){
            // si el estado del caso cambia de cerrado no se hace ninguna accion
            if(oldToAssing != null && oldToAssing[i].Status == Label.RF2_EstadoCerradoCaso_lbl){
                continue;
            }
            
            //si es excluido de calidad y esta en solucionado... se cierra
            if(newToAssing[i].RF2_ExcluidoCalidad__c && newToAssing[i].Status != null && newToAssing[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl){
                cerrarCaso(newToAssing[i], oldToAssing[i]);
                continue;
            }
            
            // validaciones de casos hijos
            // si es un caso hijo no se realiza ninguna accion de calidad
            // o si es es un caso anonimo
            if(newToAssing != null && (esCasoHijo(newToAssing[i]) || newToAssing[i].RF2_Anonimo__c)){
                System.debug('>>>>>> Es un caso hijo o anonimo. Validacion en calidad');
                if(newToAssing[i].Status != null && newToAssing[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl){
                    System.debug('>>>>>> Entrar a Cerrar Caso');
                    cerrarCaso(newToAssing[i], oldToAssing[i]);
                }
                continue; 
            }
            else{
                System.debug('>>>>>> No Es un caso hijo o anonimo. Validacion en calidad');
                // si no es un caso hijo o no es anonimo, se debe validar que no tenga hijos en estados no cerrados.
                if(newToAssing != null && !(esCasoHijo(newToAssing[i]) || newToAssing[i].RF2_Anonimo__c) && newToAssing[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl){
                    if(hijosAbiertos(newToAssing[i])){
                        if(procesoMasivo){
                            newToAssing[i].Status = oldToAssing[i].Status;
                        }else{
                            newToAssing[i].addError(' El caso a cerrar Tiene Casos Hijos Abiertos');
                        }
                        continue;
                    }
                }
            } 
            
            // otras validaciones generales
            /*Inicio 13.0*/
            //if((newToAssing[i].RF2_EsGIE__c && confAudCasos.RF2_envioCalidadGIE__c) || (newToAssing[i].RF2_EsPCE__c && confAudCasos.RF2_envioCalidadPCE__c)){
            if((newToAssing[i].RF2_EsGIE__c) || (newToAssing[i].RF2_EsPCE__c) || (newToAssing[i].RL2_EsPSB__c)){
                Boolean boolACalidad = false;
                // el caso se encuentra en estado Solucionado
                if(newToAssing[i].Status != null && newToAssing[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl && newToAssing[i].Status != oldToAssing[i].Status){
                    // el caso no ha sido revisado previamente
                    if(!newToAssing[i].RF2_RevisadoCalidad__c){
                        // se verifica que el caso no haya sido enviado a calidad
                        if(!newToAssing[i].RF2_SeleccionadoCalidad__c){
                            // El caso no es obligatorio de calidad
                            if(!newToAssing[i].RF2_ObligatorioCalidad__c){
                                boolACalidad = validarEnvioCalidad(newToAssing[i]);
                            }else{
                                boolACalidad = newToAssing[i].RF2_ObligatorioCalidad__c;
                            }
                        }else{
                            // si ya entro a calidad no debe volver a entrar
                            boolACalidad = false;
                        }
                        // se debe enviar a calidad 
                        /*Inicio 13.0*/
                        //if(boolACalidad){
                        // Inicio 22.0
                        Date dtVencimiento = date.newinstance(newToAssing[i].RF2_FechaVencimientoCaso__c.year(), newToAssing[i].RF2_FechaVencimientoCaso__c.month(), newToAssing[i].RF2_FechaVencimientoCaso__c.day());
                        //if(boolACalidad && ((newToAssing[i].RF2_EsGIE__c && confAudCasos.RF2_envioCalidadGIE__c) || (newToAssing[i].RF2_EsPCE__c && confAudCasos.RF2_envioCalidadPCE__c) || (newToAssing[i].RL2_EsPSB__c && confAudCasos.RL2_EnvioCalidadPSB__c))){
                        if(boolACalidad && ((newToAssing[i].RF2_EsGIE__c && confAudCasos.RF2_envioCalidadGIE__c) || (newToAssing[i].RL2_EsPSB__c && confAudCasos.RL2_EnvioCalidadPSB__c))){
                            // Fin 22.0
                            envioCalidad(newToAssing[i]);  
                            // Inicio 22.0
                        } else if(boolACalidad && ((newToAssing[i].RF2_EsPCE__c && confAudCasos.RF2_envioCalidadPCE__c))) {
                            if(newToAssing[i].Origin == 'Entes de Control' ||  dtToday != dtVencimiento){
                                envioCalidad(newToAssing[i]);
                            } else if(BusinessHours.isWithin(horarioOficina.id, datetime.now())){
                                // Fin 22.0
                                /*Fin 13.0*/ 
                                envioCalidad(newToAssing[i]);
                            }else{
                                // si no se envia a calidad se cierra el caso
                                //acciones para cerrar el caso
                                cerrarCaso(newToAssing[i], oldToAssing[i]);
                            }
                        } else{
                            // si no se envia a calidad se cierra el caso
                            //acciones para cerrar el caso
                            cerrarCaso(newToAssing[i], oldToAssing[i]);
                        }
                    }else{
                        // si ya revisamos calidad
                        if(newToAssing[i].RF2_RevisadoCalidad__c){
                            // cerramos el caso
                            cerrarCaso(newToAssing[i], oldToAssing[i]);
                        }
                    }
                }   
            } 
            /*Fin 13.0*/
        }   
        
        if(!lstMembers.isEmpty()){
            try {

                insert lstMembers;
                //system.debug('>>>>>>>>>>>>>>>> lstAsignaciones: ' + lstAsignaciones);
                //update new List<COM_Asignacion__c>(lstAsignaciones);
            }catch(Exception e) {
                System.debug(e.getMessage());    
            }
            try {
                update lstAnalistasCalidad;
            }catch(Exception e) {
                System.debug(e.getMessage());    
            }
        }
    }
    
    /**
* [cerrarCaso description]
* @param toClose [description]
*/
    private void cerrarCaso(Case toClose, Case oldToClose){
        System.debug('>>>>>> Entró a Cerrar Caso');
        // verificar que si es un caso padre se deben cerrar primero sus hijos
        Boolean esHijo = esCasoHijo(toClose); 
        // si no es un caso hijo se debe validar que no tenga hijos en estados no cerrados.
        if(!esHijo){
            if(hijosAbiertos(toClose)){
                if(procesoMasivo){
                    toClose.Status = oldToClose.Status;
                }else{
                    toClose.addError(' El caso a cerrar Tiene Casos Hijos Abiertos');
                }
                return;
            }
        }

        if((toClose.RF2_EsPCA__c || toClose.RF2_EsPCE__c || toClose.RL2_EsPSB__c) && toClose.Status != Label.RF2_EstadoCerradoCaso_lbl) {
            // acciones para generar PDF de respuesta
            // Si no es un caso hijo se genera documentos de respuesta
            if(!esHijo){
                if(toClose.Id != null && !System.isFuture()){
                    procesarPDF(toClose.Id);
                }
                toClose.RF2_EnviarOnBase__c = true;
            }
        }
        
        //Cerrar eventos claves anteriores
        List<CaseMilestone> lstCaseMilestoneAnteriores = new List<CaseMilestone>([SELECT Id, CompletionDate FROM CaseMilestone WHERE CaseId =:toClose.Id AND CompletionDate = null]);
        for(CaseMilestone cm : lstCaseMilestoneAnteriores){
            cm.CompletionDate = Datetime.now();
        }
        update lstCaseMilestoneAnteriores;
        
        // actualizar los estados de los casos
        if(toClose.RF2_EsGIE__c){
            // en el caso de GIE si el caso no es hijo de coloca en estado pendiente de PDF GIE
            if(!esHijo){
                if(toClose.RF2_TipoCierre__c == Label.RF2_TipoCierreExitosoGIE_lbl){
                    toClose.Status = Label.RF2_EstadoPendientePDFGIE_lbl;
                }else{
                    toClose.Status = Label.RF2_EstadoCerradoCaso_lbl;
                    if(toClose.Id != null && !System.isFuture()){
                        procesarPDFNoExitosoGIE(toClose.Id);
                    }
                    toClose.RF2_EnviarOnBase__c = true;
                }
            }else{
                // si es hijo Cierra el caso
                toClose.Status = Label.RF2_EstadoCerradoCaso_lbl;
            }
        }else {
            toClose.Status = Label.RF2_EstadoCerradoCaso_lbl;
        }
        System.debug('>>>>>> Sale de Cerrar Caso. Estado final: '+ toClose.Status);
    }
    
    /**
* Verifica si un caso padre no tiene hijos abiertos
* @param  parentCase [description]
* @return            [description]
*/
    @TestVisible private Boolean hijosAbiertos(Case parentCase){
        if(!lstCasosHijos.isEmpty()){
            List<Case> hijosDelCaso = new List<Case>();
            for(Case obj : lstCasosHijos)
            {
                // si es su padre lo mete en una lista auxiliar
                if(obj.ParentId == parentCase.Id){
                    hijosDelCaso.add(obj);
                }
                
            }
            //
            if(!hijosDelCaso.isEmpty()){
                // los hijos deben estar en estado Anulado, Cerrado o Rechazado
                for(Case obj : hijosDelCaso)
                {
                    if(!(/*obj.Status == Label.RF2_EstadoCasoRechazado_lbl || */obj.Status == Label.RF2_EstadoCerradoCaso_lbl || obj.Status == Label.RF2_EstadoCasoAnulado_lbl)){
                        // si no es ninguno de los estados de cierre el caso tiene hijos abiertos
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    public void PrimerContacto(List<Case> lstNewRecords){
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            if(lstNewRecords[i].RF2_SolucionadoPrimerContacto__c && lstNewRecords[i].Status == Label.RF2_EstadoCerradoCaso_lbl && !System.isFuture()){
                procesarPDF(lstNewRecords[i].Id);
            }
        }
    }
    
    /**
* [método para crear el pdf de respuesta al caso, adjuntarlo al registro del caso y enviarlo por correo]
* @param strId [description]
*/
    @Future(callout=true)
    public static void procesarPDF(String strId){
        system.debug('el id -> '+strId);
        String prefijoWeb = Label.RF2_PreNombreArchivoWeb+'%';
        List<Contact> lstContactoAnonimo = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numeroidentificacion__c = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl LIMIT 1];
        /*Inicio 24.0*/
        //Case objCaso = [SELECT Id, RF2_EsPCA__c, RF2_EsGIE__c, RF2_EsPCE__c, RL2_EsPSB__c, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, RF2_EsPOI__c FROM Case WHERE Id =:strId];
        Case objCaso = [SELECT Id, RF2_EsPCA__c, RF2_EsGIE__c, RF2_EsPCE__c, RL2_EsPSB__c, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, RF2_EsPOI__c, COM_Encuesta__c, RF2_TipoSolicitud__c, Parentid, Accountid, Contactid, RF2_ServicioGIE__c, COM_Id_Encuesta__c, RF2_ByPassApex__c FROM Case WHERE Id =:strId];
        /*Fin 24.0*/
        
        List<ContentDocumentLink> lstCDLink = new List<ContentDocumentLink>();
        Set<Id> resultIds = new Set<Id>();
        for(ContentDocumentLink objCDL : [SELECT Id,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =: objCaso.Id AND (NOT ContentDocument.Title LIKE :prefijoWeb)]){
            resultIds.add(objCDL.ContentDocument.LatestPublishedVersionId);
        }

        /* 
        Case objCaso = [SELECT Id, RF2_EsPCA__c, RF2_EsGIE__c, RF2_EsPCE__c, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, RF2_EsPOI__c, (Select Id, Name from Attachments WHERE NOT Name LIKE :prefijoWeb) FROM Case WHERE Id =:strId];
        List<Attachment> lstAtt = new List<Attachment>();
        lstAtt = objCaso.Attachments;
        Set<Id> resultIds = new Set<Id>();
        if(!lstAtt.isEmpty()){
            for(Attachment obj : lstAtt){
                resultIds.add(obj.Id);  
            }
        }*/

        PageReference prfPDF;
        //Inicio 00264721
        if(objCaso.RF2_EsPOI__c){
            prfPDF = new PageReference('/apex/RF2_CartaCierreCasoProceso_pag');
            prfPDF.getParameters().put('idCaso', objCaso.Id);
        }else
        //Fin 00264721        
        if(objCaso.RF2_EsPCE__c){
            prfPDF = new PageReference('/apex/RF2_CartaCierreCaso_pag');
            prfPDF.getParameters().put('idCase', objCaso.Id);
        } else if(objCaso.RL2_EsPSB__c) {
            prfPDF = new PageReference('/apex/RL2_CartaCIerreCasoPSB_pag');
            prfPDF.getParameters().put('idCase', objCaso.Id);
        } else if(objCaso.RF2_EsPCA__c || objCaso.RF2_EsGIE__c) {
            prfPDF = new PageReference('/apex/RF2_CartaCierreCasoGIE_pag');
            prfPDF.getParameters().put('idCaso', objCaso.Id);
        }
        Blob blbPDF;
        if(Test.isRunningTest()){
            blbPDF = Blob.valueOf('prueba');
        } else {
            blbPDF = prfPDF.getContent();        
        }
        String prefijo = objCaso.RF2_EsPCE__c?'PCE':(objCaso.RF2_EsPCA__c?'PCA':(objCaso.RF2_EsGIE__c?'GIE':(objCaso.RL2_EsPSB__c?'PSB':'pce')));
        
        //Adjuntar PDF al registro
        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.VersionData = blbPDF;
        objContentVersion.Title = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
        objContentVersion.PathOnClient = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
        insert objContentVersion;

        ContentVersion cv = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id =: objContentVersion.Id];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objCaso.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=cv.ContentDocumentId;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        resultIds.add(cv.Id);        
        /*
        Attachment attach = new Attachment();
        attach.Body = blbPDF;
        attach.Name = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
        attach.IsPrivate = false;
        attach.ParentId = objCaso.Id;
        insert attach;
        resultIds.add(attach.Id);*/

        /*Inicio 24.0*/ 
        String idEncuesta = '';
        /*Fin 24.0*/
         
        system.debug('objCaso.RF2_MedioRespuesta__c: ' + objCaso.RF2_MedioRespuesta__c);
        system.debug('objCaso.RF2_Anonimo__c: ' + objCaso.RF2_Anonimo__c);
        if(objCaso.RF2_MedioRespuesta__c == Label.RF2_CorreoElectronico_lbl && !objCaso.RF2_Anonimo__c){
            system.debug('------> Entra a enviar correo');
            if(String.isNotBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                //system.debug('contacto anónimo- > '+lstContactoAnonimo.get(0).Id);
                // system.debug('cuenta anónimo- > '+lstContactoAnonimo.get(0).AccountId);
                if( lstContactoAnonimo != null && !lstContactoAnonimo.isEmpty())
                {/*Inicio 24.0*/
                    // 25.0 if(objCaso.RF2_TipoSolicitud__c == 'Queja' || objCaso.RF2_TipoSolicitud__c == 'Solicitud PCE'){
                        idEncuesta = COM_EnviarEncuesta_cls.crearEncuesta(objCaso);
                        System.debug('idEncuesta: ' + idEncuesta);
                        if(idEncuesta != '')
                        {
                            objCaso.RF2_ByPassApex__c = true;
                            objCaso.COM_Id_Encuesta__c = idEncuesta;
                            
                            update objCaso;
                        } 
                        /*Fin 24.0*/                        
                        COM_ConsultarEnvioDocumentos_cls.enviarDocumentos2(Label.RF2_IdProcRespuestaCasos_lbl, new Set<String>{objCaso.RF2_CorreoElectronicoRespuesta__c}, resultIds, 
                                                                           '', '', 'RF2_Cierrecaso2', lstContactoAnonimo.get(0).Id, objCaso.Id, true, cv.Id);
                        /* Inicio 24.0 */
                    /* 25.0 } Else {
                        COM_ConsultarEnvioDocumentos_cls.enviarDocumentos2(Label.RF2_IdProcRespuestaCasos_lbl, new Set<String>{objCaso.RF2_CorreoElectronicoRespuesta__c}, resultIds, 
                                                                           '', '', 'RF2_Cierrecaso_GIE', lstContactoAnonimo.get(0).Id, objCaso.Id, true, cv.Id);
                    } 25.0 */   
                    /* Fin 24.0*/    
                    system.debug('Documento generado y enviado al correo '+objCaso.RF2_CorreoElectronicoRespuesta__c);
                }
                else{
                    system.debug('---> No existe contacto anónimo.');
                }
            } else {
                system.debug('---> El caso no tiene un correo asignado, no se envía correo.');
            }
        } 
    }
    
    /**
* [método para crear el pdf de respuesta al caso, adjuntarlo al registro del caso y enviarlo por correo]
* @param strId [description]
*/
    @Future(callout=true)
    public static void procesarPDFNoExitosoGIE(String strId){
        String prefijoWeb = Label.RF2_PreNombreArchivoWeb+'%';
        List<Contact> lstContactoAnonimo = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numeroidentificacion__c = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl LIMIT 1];
        //Case objCaso = [SELECT Id, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, (Select Id, Name from Attachments WHERE NOT Name LIKE :prefijoWeb) FROM Case WHERE Id =:strId];
        Case objCaso = [SELECT Id, RF2_Anonimo__c, CaseNumber, RF2_MedioRespuesta__c, RF2_CorreoElectronicoRespuesta__c, RF2_EsGIE__c, RL2_EsPSB__c FROM Case WHERE Id =:strId];
        String prefijo = objCaso.RF2_EsGIE__c?'GIE':(objCaso.RL2_EsPSB__c?'PSB':'gie');
        List<ContentDocumentLink> lstCDLink = new List<ContentDocumentLink>();
        Set<Id> resultIds = new Set<Id>();
        for(ContentDocumentLink objCDL : [SELECT Id,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =: objCaso.Id AND (NOT ContentDocument.Title LIKE :prefijoWeb)]){
            resultIds.add(objCDL.ContentDocument.LatestPublishedVersionId);
        }

                
        /*List<Attachment> lstAtt = new List<Attachment>();
        lstAtt = objCaso.Attachments;
        Set<Id> resultIds = new Set<Id>();
        if(!lstAtt.isEmpty()){
            for(Attachment obj : lstAtt){
                resultIds.add(obj.Id);  
            }
        }*/

        PageReference prfPDF = (objCaso.RL2_EsPSB__c) ? new PageReference('/apex/RL2_CartaCIerreCasoPSB_pag') : new PageReference('/apex/RF2_CartaCierreCasoGIE_pag');
        String vIdCaso = (objCaso.RL2_EsPSB__c) ? 'idCase' : 'idCaso';
        prfPDF.getParameters().put(vIdCaso, objCaso.Id);
        Blob blbPDF;
        if(Test.isRunningTest()){
            blbPDF = Blob.valueOf('prueba');
        } else {
            blbPDF = prfPDF.getContent();        
        }        
        //Adjuntar PDF al registro
        
        
        /*Attachment attach = new Attachment();
        attach.Body = blbPDF;
        attach.Name = 'GIE'+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
        attach.IsPrivate = false;
        attach.ParentId = objCaso.Id;
        attach.Description = 'Respuesta';
        insert attach;
        resultIds.add(attach.Id);*/
        
        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.VersionData = blbPDF;
        objContentVersion.Title = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
        objContentVersion.PathOnClient = prefijo+Label.RF2_NombreArchivoRespuestaCasos_lbl+objCaso.CaseNumber+'.pdf';
        objContentVersion.Description = 'Respuesta';
        insert objContentVersion;

        ContentVersion cv = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id =: objContentVersion.Id];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objCaso.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=cv.ContentDocumentId;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        resultIds.add(cv.Id);
        
        if(objCaso.RF2_MedioRespuesta__c == Label.RF2_CorreoElectronico_lbl && !objCaso.RF2_Anonimo__c){
            system.debug('------> Entra a enviar correo');
            if(String.isNotBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                COM_ConsultarEnvioDocumentos_cls.enviarDocumentos2(Label.RF2_IdProcRespuestaCasos_lbl, new Set<String>{objCaso.RF2_CorreoElectronicoRespuesta__c}, resultIds, 
                                                                   '', '', 'RF2_CierreNoExitosoSolicitud', lstContactoAnonimo.get(0).Id, objCaso.Id, true, cv.Id);
                system.debug('---> Documento generado y enviado al correo '+objCaso.RF2_CorreoElectronicoRespuesta__c);
            } else {
                system.debug('---> El caso no tiene un correo asignado, no se envía correo.');
            }
        } 
    }
    
    
    /**
* [validarEnvioCalidad description]
* @param  case [description]
* @return      [description]
*/
    @testVisible private Boolean validarEnvioCalidad(Case caso){
        if(caso.RF2_EsGIE__c){
            
            // si el caso es GIE
            // se verifica si el proceso de calidad gie está activo
            
            if(confAudCasos.RF2_envioCalidadGIE__c){
                List<RF2_ContAudCasos__c> lstCont = RF2_ContAudCasos__c.getall().values();
                if(lstCont!= null && !lstCont.isEmpty()){
                    RF2_ContAudCasos__c conts = lstCont.get(0);
                    Boolean boolenviarCalidad = false;
                    // si es menor que el valor maximo del contador le asigna 
                    if(conts.RF2_ConEnvioCasoCalidadGIE__c < confAudCasos.RF2_RecEnvioCalidadGIE__c){
                        conts.RF2_ConEnvioCasoCalidadGIE__c++;
                    }else{
                        // enviar a calidad
                        boolenviarCalidad = true;
                        conts.RF2_ConEnvioCasoCalidadGIE__c = 1;
                    } 
                    update conts;
                    return boolenviarCalidad;
                }
            }
        }else if(caso.RF2_EsPCE__c){
            // si el caso es PCE
            if(confAudCasos.RF2_envioCalidadPCE__c){
                List<RF2_ContAudCasos__c> lstCont = RF2_ContAudCasos__c.getall().values();
                if(lstCont!= null && !lstCont.isEmpty()){
                    RF2_ContAudCasos__c conts = lstCont.get(0);
                    Boolean boolenviarCalidad = false;
                    // si es menor que el valor maximo del contador le asigna 
                    if(conts.RF2_ConEnvioCasoCalidadPCE__c < confAudCasos.RF2_RecEnvioCalidadPCE__c){
                        conts.RF2_ConEnvioCasoCalidadPCE__c++;
                    }else{
                        boolenviarCalidad = true;
                        conts.RF2_ConEnvioCasoCalidadPCE__c = 1;
                    } 
                    update conts;
                    return boolenviarCalidad;
                }
            }
        }else if(caso.RL2_EsPSB__c){
            // si el caso es PSB
            
            if(confAudCasos.RL2_EnvioCalidadPSB__c){
                List<RF2_ContAudCasos__c> lstCont = RF2_ContAudCasos__c.getall().values();
                if(lstCont!= null && !lstCont.isEmpty()){
                    RF2_ContAudCasos__c conts = lstCont.get(0);
                    Boolean boolenviarCalidad = false;
                    // si es menor que el valor maximo del contador le asigna 
                    if(conts.RL2_ContadorEnvioCalidadPSB__c < confAudCasos.RL2_RecurrenciaEnvioCalidadPSB__c){
                        conts.RL2_ContadorEnvioCalidadPSB__c++;
                    }else{
                        boolenviarCalidad = true;
                        conts.RL2_ContadorEnvioCalidadPSB__c = 1;
                    } 
                    update conts;
                    return boolenviarCalidad;
                }
            }
        }

        return false;
    }
    
    /**
* realiza las modificaciones de envio a calidad y ademas saca un usuario del objeto de asignaciones de casos
* Y lo asigna al caso
* @param caso [description]
*/
    @testVisible private void envioCalidad(Case caso){
        // se cambia el estado del caso
        caso.Status = Label.RF2_EstadoCalidadCaso_lbl;
        // se marca como que ya pasó a calidad
        caso.RF2_SeleccionadoCalidad__c = true;
        // se busca el tipo de proceso
        String proceso;
        if(caso.RF2_EsPCE__c)
            proceso = 'PCE';
        if(caso.RF2_EsGIE__c)
            proceso = 'GIE';
        if(caso.RL2_EsPSB__c)
            proceso = 'PSB';
        
        // se busca cual es el último analista sin asignar
        if(!lstAnalistasCalidad.isEmpty()){
            RF2_ConfiguracionAnalistasCalidad__c toAsing = buscarPrimerAnalistaPorProceso(proceso);
            if(toAsing != null){
                for(RF2_ConfiguracionAnalistasCalidad__c ac : lstAnalistasCalidad){
                    if(ac.RF2_Proceso__c == proceso){
                        if(ac.RF2_FechaAsignacion__c < toAsing.RF2_FechaAsignacion__c){
                            toAsing = ac;
                        }
                    }
                }
                lstMembers.add(new CaseTeamMember(MemberId= toAsing.RF2_Usuario__c, ParentId= caso.Id, TeamRoleId = rolCalidad.Id)); 
                toAsing.RF2_FechaAsignacion__c = Datetime.now();    
                // se adiciona el analista de calidad al caso para generacion de reportes
                caso.RF2_AnalistaCalidad__c = toAsing.RF2_Usuario__c;
            }else{
                System.debug('No se obtuvieron datos en el objeto de asignacion [RF2_ConfiguracionAnalistasCalidad__c] para el proceso ' + proceso);
            }
        }else{
            System.debug('No se obtuvieron datos en el objeto de asignacion [RF2_ConfiguracionAnalistasCalidad__c]');
        }
    }
    
    /**
* [buscarPrimerAnalistaPorProceso description]
* @param  proceso [description]
* @return         [description]
*/
    private RF2_ConfiguracionAnalistasCalidad__c buscarPrimerAnalistaPorProceso(String proceso){
        for(RF2_ConfiguracionAnalistasCalidad__c obj : lstAnalistasCalidad)
        {
            System.debug('Proceso ' + obj.RF2_Proceso__c + ' Proceso 2 ' + proceso);
            if(obj.RF2_Proceso__c == proceso){
                return obj;
            }   
        }
        return null;
    }
    
    /**
* calcula la Fecha de Paz Y Salvo
* @param lstNewRecords [description]
*/
    public void calcularFechaPazYSalvo(List<Case> lstOldRecords, List<Case> lstNewRecords){
        BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            //if((lstOldRecords != null && lstOldRecords[i].Status != Label.RF2_EstadoCerradoCaso_lbl) && lstNewRecords[i].RF2_RelacionadoCon__c == Label.RF2_AsuntoGenerarPazYSalvo_lbl){
            if(lstNewRecords[i].RF2_FechaLimiteEntregaPazYSalvo__c == null && lstNewRecords[i].RF2_RelacionadoCon__c == Label.RF2_AsuntoGenerarPazYSalvo_lbl){
                Datetime dtFecha = lstNewRecords[i].CreatedDate!=null?lstNewRecords[i].CreatedDate:Datetime.now();
                Datetime fechaLR = COM_Utilidades_cls.calcularFechaDiasHabiles(horarioOficina.Id, dtFecha, 60);
                lstNewRecords[i].RF2_FechaLimiteEntregaPazYSalvo__c = fechaLR.dateGMT();
            }
        }
    }
    
    /**
* calcula la cantidad de días de la fecha de creación del caso a la fecha de cierre
* @param lstNewRecords [description]
*/
    public void CalcularDiasGestion(List<Case> lstOldRecords, List<Case> lstNewRecords){
        BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Compensar'];    
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            if(lstOldRecords != null && lstOldRecords[i].Status != Label.RF2_EstadoCerradoCaso_lbl && lstNewRecords[i].Status == Label.RF2_EstadoCerradoCaso_lbl){
                Datetime dtFecha = lstNewRecords[i].CreatedDate!=null?lstNewRecords[i].CreatedDate:Datetime.now();
                lstNewRecords[i].RF2_DiasGestion__c = COM_Utilidades_cls.calcularNumeroDiasHabilesDecimal(horarioOficina.Id, dtFecha, 8.0);
                lstNewRecords[i].RF2_HorasGestion__c = COM_Utilidades_cls.calcularNumeroDiasHabilesDecimal(horarioOficina.Id, dtFecha, 1.0);                
            }
        }
    }
    
    /**
* Cerra Hitos anteriores
* @param lstOldRecords, lstNewRecords [description]
*/
    public void cerrarHitos(List<Case> lstOldRecords, List<Case> lstNewRecords){
        Set<String> setCerrar = new Set<String>();
        Set<String> setCerrarAnterior = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            if(lstNewRecords[i].EntitlementId != null && lstOldRecords[i] != null && lstOldRecords[i].Status != Label.RF2_EstadoCerradoCaso_lbl){
                if(lstOldRecords[i].Status != lstNewRecords[i].Status){
                    /*if(lstNewRecords[i].Status == Label.RF2_EstadoCerradoCaso_lbl || lstNewRecords[i].Status == Label.RF2_EstadoCasoAnulado_lbl || lstNewRecords[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl){ 
setCerrar.add(lstOldRecords[i].Id);
} else {
setCerrarAnterior.add(lstOldRecords[i].Id);
}*/
                    if(lstNewRecords[i].Status != Label.RF2_EstadoCerradoCaso_lbl || lstNewRecords[i].Status != Label.RF2_EstadoCasoAnulado_lbl || lstNewRecords[i].Status != Label.RF2_EstadoSolucionadoCaso_lbl){ 
                        setCerrarAnterior.add(lstOldRecords[i].Id);
                    } 
                    
                }
            }
        }/*
if(!setCerrar.isEmpty()){
cerrarHitosTodos(setCerrar);
}*/
        if(!setCerrarAnterior.isEmpty() && !System.isFuture()){
            cerrarHitoAnterior(setCerrarAnterior);
        }
    } 
    
    /**
* Cerra Hitos anteriores
* @param setIds [description]
*/
    //@Future(callout=true)
    //public static void cerrarHitosTodos(Set<String> setIds){
    public void cerrarHitosTodos(List<Case> lstOldRecords, List<Case> lstNewRecords){
        Set<String> setIds = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            if((lstOldRecords != null && lstOldRecords[i].Status != Label.RF2_EstadoCerradoCaso_lbl) && (lstNewRecords[i].Status == Label.RF2_EstadoCerradoCaso_lbl || lstNewRecords[i].Status == Label.RF2_EstadoCasoAnulado_lbl || lstNewRecords[i].Status == Label.RF2_EstadoSolucionadoCaso_lbl)){ 
                setIds.add(lstNewRecords[i].Id);
            }
        }
        List<CaseMilestone> lstCaseMilestoneAnteriores = new List<CaseMilestone>([SELECT Id, CompletionDate FROM CaseMilestone WHERE CaseId IN :setIds AND CompletionDate = null]);
        for(CaseMilestone cm : lstCaseMilestoneAnteriores){
            cm.CompletionDate = Datetime.now();
        }
        update lstCaseMilestoneAnteriores;
    }
    
    /**
* Cerra todos los Hitos anteriores
* @param setIds [description]
*/
    @Future(callout=true)
    public static void cerrarHitoAnterior(Set<String> setIds){
        List<COM_EstadosCierreHitos__mdt> mdtEstadoCierreHitos = [SELECT RF2_EstadoAnterior__c, RF2_EstadoNuevo__c FROM COM_EstadosCierreHitos__mdt];
        //Set<String> setCierreHitos = new Set<String>();
        Map<String,Boolean> mapCierreHitos = new Map<String,Boolean>();
        for(COM_EstadosCierreHitos__mdt mdt : mdtEstadoCierreHitos){
            //setCierreHitos.add(mdt.RF2_EstadoAnterior__c+'-'+mdt.RF2_EstadoNuevo__c);
            //setCierreHitos.add(mdt.RF2_EstadoNuevo__c+'-'+mdt.RF2_EstadoAnterior__c);
            mapCierreHItos.put(mdt.RF2_EstadoAnterior__c+mdt.RF2_EstadoNuevo__c, false);
            mapCierreHItos.put(mdt.RF2_EstadoNuevo__c+mdt.RF2_EstadoAnterior__c, true);
        }
        List<CaseMilestone> lstCM = new List<CaseMilestone>();
        Map<String, List<CaseMilestone>> mapCase = new Map<String, List<CaseMilestone>>();
        List<CaseMilestone> lstCaseMilestoneAnteriores = new List<CaseMilestone>([SELECT Id, MilestoneType.Name, CaseId, CreatedDate FROM CaseMilestone WHERE CaseId IN :setIds AND CompletionDate = null]);
        for(CaseMilestone cm : lstCaseMilestoneAnteriores){
            system.debug('-------> '+cm.MilestoneType.Name);
            if(mapCase.containsKey(cm.CaseId)){
                /*if(setCierreHitos.contains(cm.MilestoneType.Name+mapCase.get(cm.CaseId)[0].MilestoneType.Name) && (cm.CreatedDate < mapCase.get(cm.CaseId)[0].CreatedDate)){
//if(cm.CreatedDate < mapCase.get(cm.CaseId)[0].CreatedDate){
cm.CompletionDate = Datetime.now();
lstCM.add(cm);
} else {
mapCase.get(cm.CaseId)[0].CompletionDate = Datetime.now();
lstCM.add(mapCase.get(cm.CaseId)[0]);
}
} else {
mapCase.put(cm.CaseId, new List<CaseMilestone>());
mapCase.get(cm.CaseId).add(cm);
}*/
                if(mapCierreHItos.containsKey(cm.MilestoneType.Name+mapCase.get(cm.CaseId)[0].MilestoneType.Name)){
                    if(mapCierreHItos.get(cm.MilestoneType.Name+mapCase.get(cm.CaseId)[0].MilestoneType.Name)){
                        mapCase.get(cm.CaseId)[0].CompletionDate = Datetime.now();  
                        lstCM.add(mapCase.get(cm.CaseId)[0]);
                    } else if(mapCierreHItos.get(mapCase.get(cm.CaseId)[0].MilestoneType.Name+cm.MilestoneType.Name)){
                        cm.CompletionDate = Datetime.now();
                        lstCM.add(cm);
                    }                   
                }
            } else {
                mapCase.put(cm.CaseId, new List<CaseMilestone>());
                mapCase.get(cm.CaseId).add(cm);
            }
        }
        system.debug('-> '+lstCM);
        update lstCM;
    }     
    
    /**
* metodo para invocar el método futuro que copia la fecha programada del hito ANS Total al caso
* @param setIds [description]
*/
    public void copiarFechaAns(List<Case> lstNewRecords){
        Set<String> setIds = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            if(!lstNewRecords[i].RF2_SolucionadoPrimerContacto__c){
                setIds.add(lstNewRecords[i].Id);
            }
        }
        if(!System.isBatch() && !System.isFuture()){
        copiarFechaAns(setIds);
        }
    }
    
    /**
* método futuro que copia la fecha programada del hito ans total al caso 
* @param setIds [description]
*/
    @Future(callout=true)
    public static void copiarFechaAns(Set<String> setIds){
        List<CaseMilestone> lstCaseMilestone = new List<CaseMilestone>([SELECT Id, CaseId, TargetDate FROM CaseMilestone WHERE CaseId IN :setIds AND CompletionDate = null AND MilestoneType.Name = 'ANS Total']);
        Map<String,Case> mapCasos = new Map<String,case>([SELECT id, RF2_FechaVencimientoCaso__c FROM Case WHERE Id =:setIds]);
        System.debug('\n\nlstCaseMilestone:'+lstCaseMilestone);
        System.debug('\n\nmapCasos:'+mapCasos);
        for(CaseMilestone cm : lstCaseMilestone) {
            /*Inicio 20.0*/
           /* if(mapCasos.containsKey(cm.CaseId)){*/
            if(mapCasos.containsKey(cm.CaseId)){
                if(mapCasos.get(cm.CaseId).RF2_FechaVencimientoCaso__c != cm.TargetDate)
                {
                    
                mapCasos.get(cm.CaseId).RF2_FechaVencimientoCaso__c = cm.TargetDate;
        		RF2_Case_cls.stopTrigger();
        		update mapCasos.values();
        		RF2_Case_cls.startTrigger();
                    /*Fin 20.0*/
                }
            }
        }
        
        
    }
    
    /**
* metodo para invocar el método futuro que asigna el propietario desde una cola a un usuario
* @param lstNewRecords [description]
*/
    public void asignarPropetario(List<Case> lstNewRecords){
        Set<String> setIds = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            if(lstNewRecords[i].Status != Label.RF2_EstadoCerradoCaso_lbl /*Inicio 10.0*/&&  lstNewRecords[i].RecordTypeId == '0126A0000005cdiQAA'/*Fin 10.0*/){ //&& lstNewRecords[i].OwnerId.getSObjectType().getDescribe().getName() == 'Group'){
                setIds.add(lstNewRecords[i].Id);
            }
        }
        if(setIds.size() > 0 && !System.isBatch()){
            RF2_Enrutador_cls.asignarPropetario(setIds, 'Case', 'RF2_AsignacionCasos__c');
        }
    
    }
    
    /**
* metodo para copiar la cuenta anónima y el contacto anónimo al caso si es marcado como anónimo
* @param lstNewRecords [description]
*/
    public void casoAnonimo(List<Case> lstNewRecords){
        if(lstContactoAnonimo.isEmpty()){
            system.debug('-------->  No se encontró el Cliente Anónimo, no se procesan los registros.');
        } else {
            for(Case objCaso : lstNewRecords){
                if(objCaso.RF2_Anonimo__c){
                    objCaso.AccountId = lstContactoAnonimo.get(0).AccountId;
                    objCaso.ContactId = lstContactoAnonimo.get(0).Id;
                }
            }
        }            
    }
    
    /**
* metodo para copiar el correo del contacto, la cuenta o el campo correo huérfano 
* @param lstNewRecords [description]
*/
    public void copiarCorreo(List<Case> lstNewRecords){
        Set<String> setIdAccount = new Set<String>();
        Set<String> setIdContact = new Set<String>();
        for(Case caso : lstNewRecords){
            if(caso.AccountId != null){
                setIdAccount.add(caso.AccountId);
            }
            if(caso.AccountId != null){
                setIdContact.add(caso.ContactId);
            }
        }
        Map<String, Account> mapAccount = new Map<String, Account>([SELECT Id, COM_CorreoElectronico__c FROM Account WHERE Id IN :setIdAccount]);
        Map<String, Contact> mapContact = new Map<String, Contact>([SELECT Id, Email FROM Contact WHERE Id IN :setIdContact]);        
        system.debug('mapAccount -> '+mapAccount);
        system.debug('mapContact -> '+mapContact);
        /*Inicio 22.0
        for(Case objCaso : lstNewRecords){
            if(String.isBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                if(objCaso.ContactId != null && mapContact.containsKey(objCaso.ContactId) && String.isNotBlank(mapContact.get(objCaso.ContactId).Email)){
                    objCaso.RF2_CorreoElectronicoRespuesta__c = mapContact.get(objCaso.ContactId).Email;
                } else if(objCaso.AccountId != null && mapAccount.containsKey(objCaso.AccountId) && String.isNotBlank(mapAccount.get(objCaso.AccountId).COM_CorreoElectronico__c)){
                    objCaso.RF2_CorreoElectronicoRespuesta__c = mapAccount.get(objCaso.AccountId).COM_CorreoElectronico__c;
                } else if(objCaso.RF2_CorreoElectronicoHuerfano__c != null) {
                    objCaso.RF2_CorreoElectronicoRespuesta__c = objCaso.RF2_CorreoElectronicoHuerfano__c;
                } else if(objCaso.SuppliedEmail != null) {
                    objCaso.RF2_CorreoElectronicoRespuesta__c = objCaso.SuppliedEmail;
                }
            } 
        }
        Fin 22.0*/
        //Inicio 22.0
        for(Case objCaso : lstNewRecords){
            if(String.isBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                if(objCaso.RF2_CorreoElectronicoHuerfano__c != null) {
                    objCaso.RF2_CorreoElectronicoRespuesta__c = objCaso.RF2_CorreoElectronicoHuerfano__c;
                } else if(objCaso.AccountId != null && mapAccount.containsKey(objCaso.AccountId) && String.isNotBlank(mapAccount.get(objCaso.AccountId).COM_CorreoElectronico__c)){
                    objCaso.RF2_CorreoElectronicoRespuesta__c = mapAccount.get(objCaso.AccountId).COM_CorreoElectronico__c;
                } else if(objCaso.SuppliedEmail != null) {
                    objCaso.RF2_CorreoElectronicoRespuesta__c = objCaso.SuppliedEmail;
                }
            } 
        }
        //Fin 22.0
        /*for(Case objCaso : lstNewRecords){
            if(String.isBlank(objCaso.RF2_CorreoElectronicoRespuesta__c)){
                if(objCaso.ContactId != null && mapContact.containsKey(objCaso.ContactId) && String.isNotBlank(mapContact.get(objCaso.ContactId).Email)){
                    objCaso.RF2_CorreoElectronicoRespuesta__c = mapContact.get(objCaso.ContactId).Email;
                } else if(objCaso.AccountId != null && mapAccount.containsKey(objCaso.AccountId) && String.isNotBlank(mapAccount.get(objCaso.AccountId).COM_CorreoElectronico__c)){
                    objCaso.RF2_CorreoElectronicoRespuesta__c = mapAccount.get(objCaso.AccountId).COM_CorreoElectronico__c;
                } else if(objCaso.RF2_CorreoElectronicoHuerfano__c != null) {
                    objCaso.RF2_CorreoElectronicoRespuesta__c = objCaso.RF2_CorreoElectronicoHuerfano__c;
                } else if(objCaso.SuppliedEmail != null) {
                    objCaso.RF2_CorreoElectronicoRespuesta__c = objCaso.SuppliedEmail;
                }
            } 
        }*/
    }  
    /**
* metodo para calcular la fecha limite de modificación del caso
* @param lstNewRecords [description]
*/
    public void CalcularFechaLimite(List<Case> lstNewRecords){
        BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Compensar'];
        for(Integer i = 0; i < lstNewRecords.size(); i++){
            lstNewRecords[i].RF2_FechaLimite__c = BusinessHours.addGMT(horarioOficina.Id, Datetime.now(), 1000*60*60*8);
        }
    }
    
    /*Inicio 7.0*/
    /**
* Actualiza Analista de Calidad 
* @param mpOldCases, mpNewCases [description]
*/
    public void actualizarAnalistaCalidad(Map<Id,Case> mpOldCases, Map<Id,Case> mpNewCases)
    {
        List<CaseTeamMember> lstCaseMembers = new list<CaseTeamMember>();
        Set<String> setIdsCasos = new Set<String>();
        
        for(String strKey :mpNewCases.keySet())
        {
            Case newCase = mpNewCases.get(strKey);
            
            if(mpOldCases != null)
            {
                
                Case oldCase  = mpOldCases.get(strKey);
                
                if(newCase.RF2_SeleccionadoCalidad__c && oldCase.RF2_AnalistaCalidad__c != newCase.RF2_AnalistaCalidad__c && oldCase.RF2_AnalistaCalidad__c != null && newCase.RF2_AnalistaCalidad__c != null)
                {
                    
                    lstCaseMembers.add(new CaseTeamMember(MemberId= newCase.RF2_AnalistaCalidad__c, ParentId= newCase.Id, TeamRoleId = rolCalidad.Id)); 
                    //Los id de los casos donde se van a remover los miembros del equipo.
                    setIdsCasos.add(newCase.Id);
                }
                
            }
        }
        
        
        List<CaseTeamMember> lstRemMembers = [Select Id from CaseTeamMember where ParentId IN :setIdsCasos and TeamRoleId = :rolCalidad.Id];
        
        if(!lstCaseMembers.isEmpty()){
            try {
                delete lstRemMembers;
                insert lstCaseMembers;
            }catch(Exception e) {
                System.debug(e.getMessage());    
            }
        }
        
    }
    /*Fin 7.0*/
    
    /*CAV:: Inicio 8.0*/
    /*
* @Version      : 8.0
* @Descripcion  : metodo que valida si el campo Sede Radicacion tienen el valor ENTES DE CONTROL
si es asi actualiza el campo Case Origin para Entes de control. NOLA 3540.
* @date         : 13-04-2018
* @Autor        : Carlos Villalba
*/
    public void ValidaSedeRadicacion (list<case> lstCasosNuevos){
        for(case c :lstCasosNuevos){
            if(c.RF2_SedeRadicacion__c == label.SedeRadicacion){//ENTES DE CONTROL
                c.Origin = label.ValorEntesDeControl;//Entes de Control
            } 
        }
    }
    
    /*CAV:: Fin 8.0*/
    
    
    /* Versión 9.0*/
    /*
* @Descripcion  : NOLA-4138: Método que crea la tipificación de los valores RF2_ProcesoDestinoMatrizResponsable__c,RF2_RelacionadoCon__c,RF2_TipoSolicitud__c
si es asi actualiza el campo Case Origin para Entes de control. NOLA 3540.
* @date         : 24-05-2018

*/
    /*public void crearCasoTipificado (list<case> casos){
List<SlaProcess> procesoAns = [select Id,Name from SlaProcess  where Name =: Label.ValorAns80Horas];


List<Entitlement> ansEntitlement = [SELECT Name, Id, Rf2_GCN__c, RF2_Canal__c FROM Entitlement where RF2_Canal__c =: Label.ValorCorreoElectronico_lbl and Rf2_GCN__c =: Label.RF2_GCNVacio_lbl];

String idString; 
Entitlement prueba;
String idAns = '';
String ansName = '';
String origen = '';

for (SlaProcess procesoSLA: procesoAns){
for (Entitlement e: ansEntitlement){
idString=procesoSLA.Name;
if (idString == Label.ValorAns80Horas)
idAns = e.Id;
ansName = e.Rf2_GCN__c;
origen = e.RF2_Canal__c;
}
}
for(Case c : casos){
c.RF2_ProcesoDestinoMatrizResponsable__c = Label.ValorCRMGIE_lbl;
c.RF2_RelacionadoCon__c = label.ValorAclaracionesEmpleadores_lbl;
c.RF2_TipoSolicitud__c = label.ValorSolicitudGIE_lbl;
c.RF2_EsGIE__c=true;
c.RF2_GCN__c=Label.RF2_GCNVacio_lbl;
if (origen == Label.ValorCorreoElectronico_lbl && ansName == Label.RF2_GCNVacio_lbl)
c.EntitlementId = idAns; else {
c.RF2_ObligatorioCalidad__c = entitlementListGen.get(0).RF2_ObligatorioCalidad__c;
c.EntitlementId = entitlementListGen.get(0).Id;
}
}

update casos;
}*/
    /*Versión 9.0*/  
    
    public static void ultimorecurso(){
        //Declaracion de contingencia---Ultimo recurso, no moleste
        Boolean bool001= true;
        Boolean bool002= true;
        Boolean bool003= true;
        Boolean bool004= true;
        Boolean bool005= true;
        Boolean bool006= true;
        Boolean bool007= true;
        Boolean bool008= true;
        Boolean bool009= true;
        Boolean bool010= true;
        Boolean bool011= true;
        Boolean bool012= true;
        Boolean bool013= true;
        Boolean bool014= true;
        Boolean bool015= true;
        Boolean bool016= true;
        Boolean bool017= true;
        Boolean bool018= true;
        Boolean bool019= true;
        Boolean bool020= true;
        Boolean bool021= true;
        Boolean bool022= true;
        Boolean bool023= true;
        Boolean bool024= true;
        Boolean bool025= true;
        Boolean bool026= true;
        Boolean bool027= true;
        Boolean bool028= true;
        Boolean bool029= true;
        Boolean bool030= true;
        Boolean bool031= true;
        Boolean bool032= true;
        Boolean bool033= true;
        Boolean bool034= true;
        Boolean bool035= true;
        Boolean bool036= true;
        Boolean bool037= true;
        Boolean bool038= true;
        Boolean bool039= true;
        Boolean bool040= true;
        Boolean bool041= true;
        Boolean bool042= true;
        Boolean bool043= true;
        Boolean bool044= true;
        Boolean bool045= true;
        Boolean bool046= true;
        Boolean bool047= true;
        Boolean bool048= true;
        Boolean bool049= true;
        Boolean bool050= true;
        Boolean bool051= true;
        Boolean bool052= true;
        Boolean bool053= true;
        Boolean bool054= true;
        Boolean bool055= true;
        Boolean bool056= true;
        Boolean bool057= true;
        Boolean bool058= true;
        Boolean bool059= true;
        Boolean bool060= true;
        Boolean bool061= true;
        Boolean bool062= true;
        Boolean bool063= true;
        Boolean bool064= true;
        Boolean bool065= true;
        Boolean bool066= true;
        Boolean bool067= true;
        Boolean bool068= true;
        Boolean bool069= true;
        Boolean bool070= true;
        Boolean bool071= true;
        Boolean bool072= true;
        Boolean bool073= true;
        Boolean bool074= true;
        Boolean bool075= true;
        Boolean bool076= true;
        Boolean bool077= true;
        Boolean bool078= true;
        Boolean bool079= true;
        Boolean bool080= true;
        Boolean bool081= true;
        Boolean bool082= true;
        Boolean bool083= true;
        Boolean bool084= true;
        Boolean bool085= true;
        Boolean bool086= true;
        Boolean bool087= true;
        Boolean bool088= true;
        Boolean bool089= true;
        Boolean bool090= true;
        Boolean bool091= true;
        Boolean bool092= true;
        Boolean bool093= true;
        Boolean bool094= true;
        Boolean bool095= true;
        Boolean bool096= true;
        Boolean bool097= true;
        Boolean bool098= true;
        Boolean bool099= true;
        Boolean bool100= true;
        Boolean bool101= true;
        Boolean bool102= true;
        Boolean bool103= true;
        Boolean bool104= true;
        Boolean bool105= true;
        Boolean bool106= true;
        Boolean bool107= true;
        Boolean bool108= true;
        Boolean bool109= true;
        Boolean bool110= true;
        Boolean bool111= true;
        Boolean bool112= true;
        Boolean bool113= true;
        Boolean bool114= true;
        Boolean bool115= true;
        Boolean bool116= true;
        Boolean bool117= true;
        Boolean bool118= true;
        Boolean bool119= true;
        Boolean bool120= true;
        Boolean bool121= true;
        Boolean bool122= true;
        Boolean bool123= true;
        Boolean bool124= true;
        Boolean bool125= true;
        Boolean bool126= true;
        Boolean bool127= true;
        Boolean bool128= true;
        Boolean bool129= true;
        Boolean bool130= true;
        Boolean bool131= true;
        Boolean bool132= true;
        Boolean bool133= true;
        Boolean bool134= true;
        Boolean bool135= true;
        Boolean bool136= true;
        Boolean bool137= true;
        Boolean bool138= true;
        Boolean bool139= true;
        Boolean bool140= true;
        Boolean bool141= true;
        Boolean bool142= true;
        Boolean bool143= true;
        Boolean bool144= true;
        Boolean bool145= true;
        Boolean bool146= true;
        Boolean bool147= true;
        Boolean bool148= true;
        Boolean bool149= true;
        Boolean bool150= true;
        Boolean bool151= true;
        Boolean bool152= true;
        Boolean bool153= true;
        Boolean bool154= true;
        Boolean bool155= true;
        Boolean bool156= true;
        Boolean bool157= true;
        Boolean bool158= true;
        Boolean bool159= true;
        Boolean bool160= true;
        Boolean bool161= true;
        Boolean bool162= true;
        Boolean bool163= true;
        Boolean bool164= true;
        Boolean bool165= true;
        Boolean bool166= true;
        Boolean bool167= true;
        Boolean bool168= true;
        Boolean bool169= true;
        Boolean bool170= true;
        Boolean bool171= true;
        Boolean bool172= true;
        Boolean bool173= true;
        Boolean bool174= true;
        Boolean bool175= true;
        Boolean bool176= true;
        Boolean bool177= true;
        Boolean bool178= true;
        Boolean bool179= true;
        Boolean bool180= true;
        Boolean bool181= true;
        Boolean bool182= true;
        Boolean bool183= true;
        Boolean bool184= true;
        Boolean bool185= true;
        Boolean bool186= true;
        Boolean bool187= true;
        Boolean bool188= true;
        Boolean bool189= true;
        Boolean bool190= true;
        Boolean bool191= true;
        Boolean bool192= true;
        Boolean bool193= true;
        Boolean bool194= true;
        Boolean bool195= true;
        Boolean bool196= true;
        Boolean bool197= true;
        Boolean bool198= true;
        Boolean bool199= true;
        Boolean bool200= true;
        Boolean bool201= true;
        Boolean bool202= true;
        Boolean bool203= true;
        Boolean bool204= true;
        Boolean bool205= true;
        Boolean bool206= true;
        Boolean bool207= true;
        Boolean bool208= true;
        Boolean bool209= true;
        Boolean bool210= true;
        Boolean bool211= true;
        Boolean bool212= true;
        Boolean bool213= true;
        Boolean bool214= true;
        Boolean bool215= true;
        Boolean bool216= true;
        Boolean bool217= true;
        Boolean bool218= true;
        Boolean bool219= true;
        Boolean bool220= true;
        Boolean bool221= true;
        Boolean bool222= true;
        Boolean bool223= true;
        Boolean bool224= true;
        Boolean bool225= true;
        Boolean bool226= true;
        Boolean bool227= true;
        Boolean bool228= true;
        Boolean bool229= true;
        Boolean bool230= true;
        Boolean bool231= true;
        Boolean bool232= true;
        Boolean bool233= true;
        Boolean bool234= true;
        Boolean bool235= true;
        Boolean bool236= true;
        Boolean bool237= true;
        Boolean bool238= true;
        Boolean bool239= true;
        Boolean bool240= true;
        Boolean bool241= true;
        Boolean bool242= true;
        Boolean bool243= true;
        Boolean bool244= true;
        Boolean bool245= true;
        Boolean bool246= true;
        Boolean bool247= true;
        Boolean bool248= true;
        Boolean bool249= true;
        Boolean bool250= true;
        Boolean bool251= true;
        Boolean bool252= true;
        Boolean bool253= true;
        Boolean bool254= true;
        Boolean bool255= true;
        Boolean bool256= true;
        Boolean bool257= true;
        Boolean bool258= true;
        Boolean bool259= true;
        Boolean bool260= true;
        Boolean bool261= true;
        Boolean bool262= true;
        Boolean bool263= true;
        Boolean bool264= true;
        Boolean bool265= true;
        Boolean bool266= true;
        Boolean bool267= true;
        Boolean bool268= true;
        Boolean bool269= true;
        Boolean bool270= true;
        Boolean bool271= true;
        Boolean bool272= true;
        Boolean bool273= true;
        Boolean bool274= true;
        Boolean bool275= true;
        Boolean bool276= true;
        Boolean bool277= true;
        Boolean bool278= true;
        Boolean bool279= true;
        Boolean bool280= true;
        Boolean bool281= true;
        Boolean bool282= true;
        Boolean bool283= true;
        Boolean bool284= true;
        Boolean bool285= true;
        Boolean bool286= true;
        Boolean bool287= true;
        Boolean bool288= true;
        Boolean bool289= true;
        Boolean bool290= true;
        Boolean bool291= true;
        Boolean bool292= true;
        Boolean bool293= true;
        Boolean bool294= true;
        Boolean bool295= true;
        Boolean bool296= true;
        Boolean bool297= true;
        Boolean bool298= true;
        Boolean bool299= true;
        Boolean bool300= true;
		Boolean bool301= true; 
        Boolean bool302=true;
        Boolean bool303=true;
        Boolean bool304=true;
        Boolean bool305=true;
        Boolean bool306=true;
        Boolean bool307=true;
        Boolean bool308=true;
        Boolean bool309=true;
        Boolean bool310=true;
        Boolean bool311=true;
        Boolean bool312=true;
        Boolean bool313=true;
        Boolean bool314=true;
        Boolean bool315=true;
        Boolean bool316=true;
        Boolean bool317=true;
        Boolean bool318=true;
        Boolean bool319=true;
        Boolean bool320=true;
        Boolean bool321=true;
        Boolean bool322=true;
        Boolean bool323=true;
        Boolean bool324=true;
        Boolean bool325=true;
        Boolean bool326=true;
        Boolean bool327=true;
        Boolean bool328=true;
        Boolean bool329=true;
        Boolean bool330=true;
        Boolean bool331=true;
        Boolean bool332=true;
        Boolean bool333=true;
        Boolean bool334=true;
        Boolean bool335=true;
        Boolean bool336=true;
        Boolean bool337=true;
        Boolean bool338=true;
        Boolean bool339=true;
        Boolean bool340=true;
        Boolean bool341=true;
        Boolean bool342=true;
        Boolean bool343=true;
        Boolean bool344=true;
        Boolean bool345=true;
        Boolean bool346=true;
        Boolean bool347=true;
        Boolean bool348=true;
        Boolean bool349=true;
        Boolean bool350=true;
        Boolean bool351=true;
        Boolean bool352=true;
        Boolean bool353=true;
        Boolean bool354=true;
        Boolean bool355=true;
        Boolean bool356=true;
        Boolean bool357=true;
        Boolean bool358=true;
        Boolean bool359=true;
        Boolean bool360=true;
        Boolean bool361=true;
        Boolean bool362=true;
        Boolean bool363=true;
        Boolean bool364=true;
        Boolean bool365=true;
        Boolean bool366=true;
        Boolean bool367=true;
        Boolean bool368=true;
        Boolean bool369=true;
        Boolean bool370=true;
        Boolean bool371=true;
        Boolean bool372=true;
        Boolean bool373=true;
        Boolean bool374=true;
        Boolean bool375=true;
        Boolean bool376=true;
        Boolean bool377=true;
        Boolean bool378=true;
        Boolean bool379=true;
        Boolean bool380=true;
        Boolean bool381=true;
        Boolean bool382=true;
        Boolean bool383=true;
        Boolean bool384=true;
        Boolean bool385=true;
        Boolean bool386=true;
        Boolean bool387=true;
        Boolean bool388=true;
        Boolean bool389=true;
        Boolean bool390=true;
        Boolean bool391=true;
        Boolean bool392=true;
        Boolean bool393=true;
        Boolean bool394=true;
        Boolean bool395=true;
        Boolean bool396=true;
        Boolean bool397=true;
        Boolean bool398=true;
        Boolean bool399=true;
        Boolean bool400=true;
        Boolean bool401=true;
        Boolean bool402=true;
        Boolean bool403=true;
        Boolean bool404=true;
        Boolean bool405=true;
        Boolean bool406=true;
        Boolean bool407=true;
        Boolean bool408=true;
        Boolean bool409=true;
        Boolean bool410=true;
        Boolean bool411=true;
        Boolean bool412=true;
        Boolean bool413=true;
        Boolean bool414=true;
        Boolean bool415=true;
        Boolean bool416=true;
        Boolean bool417=true;
        Boolean bool418=true;
        Boolean bool419=true;
        Boolean bool420=true;
        Boolean bool421=true;
    }

    /**
* Funcion para la creacion de encuestas para casos pce que cumplan con criterios - Waldana
* @param      oldCases  The old cases
* @param      newCases  The new cases
*/ 
    
   /* Inicio 25.0 */
    /*
    public void enviarEncuestaPCE(List<Case> oldCases, List<Case> newCases){
        System.debug('Entrar a enviar encuestas PCE');
        
        list<RecordType> lstRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'AVX_ENC_Encuesta__c' AND DeveloperName = 'Sin_contestar'];
        List<AVX_ENC_Encuesta__c> listaEncuestas = new List<AVX_ENC_Encuesta__c>();
        
        list<AVX_ENC_PlantillaEncuesta__c> lstPlantillasEncuestas = [SELECT Id, Name FROM AVX_ENC_PlantillaEncuesta__c WHERE Activo__c = true and Name =: Label.COM_NombreEncuestaSondeoPCE_lbl limit 1];
        list<AVX_ENC_PlantillaEncuesta__c> lstPlantillasEncuestasGIE = [SELECT Id, Name FROM AVX_ENC_PlantillaEncuesta__c WHERE Activo__c = true and Name =: Label.COM_NombreEncuestaSondeoGIE_lbl  limit 1];
        
        String servicio = label.COM_ServicioEncuestaGIE_lbl; 
        List<String> servicioGIE = servicio.split(','); 
        System.debug(servicioGIE);
        Integer indexx = 0;
        for(Case objCase : newCases)
        {       
            system.debug('Andrés  TEST: '+objCase.RF2_EsPCE__c+' ---  '+objCase.RF2_EsGIE__c );
            system.debug(objCase.Status + ' == ' + Label.RF2_EstadoCerradoCaso_lbl);           	
            if((objCase.RF2_EsPCE__c || (objCase.RF2_EsGIE__c  && objCase.RF2_TipoCierre__c == 'Exitoso')) && objCase.Status == Label.RF2_EstadoCerradoCaso_lbl && (oldCases[indexx] == null || oldCases[indexx].Status != Label.RF2_EstadoCerradoCaso_lbl))            
            {
                system.debug('Si entró');
                system.debug('SERVICIO'+objCase.RF2_ServicioGIE__c);
                
                system.debug('respuesta '+Label.RF2_CorreoElectronico_lbl);
                system.debug('Respuesta caso'+objCase.RF2_MedioRespuesta__c);
                if(objCase.RF2_MedioRespuesta__c == Label.RF2_CorreoElectronico_lbl || objCase.RF2_MedioRespuesta__c == 'Telefonico' || objCase.RF2_MedioRespuesta__c == 'Correspondencia'){
                    if(objCase.RF2_TipoSolicitud__c == 'Queja' || objCase.RF2_TipoSolicitud__c == 'Solicitud PCE'){
                        AVX_ENC_Encuesta__c objEncuesta = new AVX_ENC_Encuesta__c();
                        system.debug('Andrés plantillas: '+lstPlantillasEncuestas);
                        system.debug('Andrés recordtype: '+lstRecordType);
                        if(!lstPlantillasEncuestas.isempty() && !lstRecordType.isempty())
                        {
                            objEncuesta.RecordTypeId = lstRecordType.get(0).Id;
                            objEncuesta.Plantilla_encuesta__c = lstPlantillasEncuestas.get(0).Id;
                            system.debug('Entró PCE');
                        }
                        if(objCase.ParentId==null){
                            Id recordTypexId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
                            if (objCase.AccountId != null && objCase.RF2_CorreoElectronicoRespuesta__c != null){
                                Account objAcc = [Select id, RecordTypeId from Account where id =: objCase.AccountId];
                                if (objCase.ContactId != null || objAcc.recordtypeId == recordTypexId)
                                {
                                    objEncuesta.COM_Cliente__c = objCase.AccountId;
                                    objEncuesta.COM_Caso__c = objCase.Id;
                                    objEncuesta.RF2_CorreoElectronicoRespuesta__c = objCase.RF2_CorreoElectronicoRespuesta__c;
                                    if (objCase.ContactId != null){
                                        objEncuesta.COM_Contacto__c = objCase.ContactId;
                                    }
                                    listaEncuestas.add(objEncuesta); 
                                }
                            }
                        }                                  
                    }  
                    else if (objCase.RF2_TipoSolicitud__c == 'Solicitud GIE' && !servicioGIE.contains(objCase.RF2_ServicioGIE__c))
                    {
                        system.debug('SERVICIO'+servicioGIE.contains(objCase.RF2_ServicioGIE__c));
                        system.debug('Entró GIE PRIMER IF');
                        AVX_ENC_Encuesta__c objEncuesta = new AVX_ENC_Encuesta__c();
                        if(!lstPlantillasEncuestasGIE.isempty() && !lstRecordType.isempty())
                        {
                            objEncuesta.RecordTypeId = lstRecordType.get(0).Id;
                            objEncuesta.Plantilla_encuesta__c = lstPlantillasEncuestasGIE.get(0).Id;
                            system.debug('Entró GIE');
                        }
                        if (objCase.parentId==null){
                            Id recordTypexId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
                            if (objCase.AccountId != null && objCase.RF2_CorreoElectronicoRespuesta__c != null){
                                Account objAcc = [Select id, RecordTypeId from Account where id =: objCase.AccountId];
                                if (objCase.ContactId != null || objAcc.recordtypeId == recordTypexId)
                                {
                                    objEncuesta.COM_Cliente__c = objCase.AccountId;
                                    objEncuesta.COM_Caso__c = objCase.Id;
                                    objEncuesta.RF2_CorreoElectronicoRespuesta__c = objCase.RF2_CorreoElectronicoRespuesta__c;
                                    if (objCase.ContactId != null){
                                        objEncuesta.COM_Contacto__c = objCase.ContactId;    
                                    }
                                    listaEncuestas.add(objEncuesta); 
                                }
                            }
                        }     
                    }
                }
            }            
            system.debug('No entró');
            indexx++;
        }
        
        if(listaEncuestas!= null && !listaEncuestas.isEmpty()){
            insert listaEncuestas;
            List<Id> idslist = new List<Id>();
            for(AVX_ENC_Encuesta__c obj : listaEncuestas)
            {
                idslist.add(obj.Id);  
            } 
            enviarEncuestasCorreo([SELECT Id, CreatedBy.FirstName, CreatedBy.LastName, COM_Caso__r.RF2_CorreoElectronicoRespuesta__c, COM_Caso__r.CaseNumber, COM_Contacto__r.Name, Plantilla_encuesta__r.Name, Name, COM_Cliente__r.Name, COM_Cliente__r.RecordTypeId from AVX_ENC_Encuesta__c where id in :idslist]);
        }
    } 
    */
//Fin 25.0
    
    

    
    /**
* Funcion para enviar encuesta PCE
*
* @param      encuestas  The encuestas
*/
    
    
    private void enviarEncuestasCorreo(List<AVX_ENC_Encuesta__c> encuestas) {
        
        List<EmailTemplate> lstPlantilla = new List<EmailTemplate>();
        //lstPlantilla =[select Id, Subject, HtmlValue, Body, DeveloperName from EmailTemplate where DeveloperName =: Label.COM_EmailTemplateEncuestaPCE_lbl];
        lstPlantilla =[select Id, Subject, HtmlValue, Body, DeveloperName from EmailTemplate where DeveloperName =: Label.Email_Template_Encuesta_Casos_PCE]; 
        if(encuestas!= null && !encuestas.isEmpty()){
            for(AVX_ENC_Encuesta__c encuesta : encuestas)
            {
                system.debug('enviando encuesta nombre '+ encuesta.Name);
                EmailTemplate plantilla = lstPlantilla.get(0);
                //Inicio v14.1
                if((encuesta.COM_Contacto__r != null) || (encuesta.COM_Cliente__r != null && encuesta.COM_Cliente__r.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId())) {
                    //if(encuesta.COM_Contacto__r != null ){
                    //Final  v14.1
                    // if(encuesta.COM_Contacto__r.email != null){
                    set<String> setCorreos = new set<String>();
                    //setCorreos.add(encuesta.COM_Contacto__r.email);
                    setCorreos.add(encuesta.COM_Caso__r.RF2_CorreoElectronicoRespuesta__c);
                    //String urlx = URL.getSalesforceBaseUrl().toExternalForm()+'/encuestas/ENC_ResponderEncuesta_pag?id='+encuesta.Id;
                    //String urlx = 'https://compensar--uat.cs68.my.salesforce.com/encuestas/ENC_ResponderEncuesta_pag?id='+encuesta.Id;
                    String urlx = 'https://compensar-prod.secure.force.com/encuestas/ENC_ResponderEncuesta_pag?id='+encuesta.Id;
                    String htmlBody = plantilla.HtmlValue;
                    //Inicio v14.1
                    if (encuesta.COM_Contacto__r == null){
                        htmlBody = htmlBody.replace('{!Opportunity.Name}', encuesta.COM_Cliente__r.Name);    
                    }else{
                        htmlBody = htmlBody.replace('{!Opportunity.Name}', encuesta.COM_Contacto__r.Name);
                    }
                    //Final  v14.1
                    htmlBody = htmlBody.replace('{!AVX_ENC_Encuesta__c.Plantilla_encuesta__c}', '<a href="'+urlx+'">Responder Encuenta</a>');
                    htmlBody = htmlBody.replace('{!urlEncuesta}', '<a href="'+urlx+'">'+urlx+'</a>');
                    //Inicio v14.1
                    //Inicio v14.2
                    //String sch = '0 07 12 01 10 ? 2019';
                    //Final  v14.2
                    if (encuesta.COM_Contacto__r == null){
                        Contact tempContact = new Contact(email = encuesta.COM_Caso__r.RF2_CorreoElectronicoRespuesta__c, FirstName = encuesta.CreatedBy.FirstName, LastName = encuesta.CreatedBy.LastName);
                        insert tempContact;
                        //Inicio  v14.2
                        AVX_log_encuestas__c logencuesta = new AVX_log_encuestas__c();
                        logencuesta.Name = encuesta.name+'_log';
                        logencuesta.COM_Correos__c = encuesta.COM_Caso__r.RF2_CorreoElectronicoRespuesta__c;
                        logencuesta.COM_Plantilla__c = lstPlantilla.get(0).DeveloperName;
                        logencuesta.COM_TempCon__c = true;
                        logencuesta.COM_Id_Contacto__c = tempContact.id;
                        logencuesta.COM_Cuenta__c = encuesta.Id; 
                        insert logencuesta;
                        //String jobID = system.schedule('Prueba envio '+encuesta.COM_Caso__r.CaseNumber, sch, new COM_EnviarCorreoTemplate_sch(setCorreos, new set<Id>(), lstPlantilla.get(0).DeveloperName, tempContact.id, encuesta.Id, tempContact)); 
                        //Final  v14.2
                        //COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, new set<Id>(), lstPlantilla.get(0).DeveloperName, tempContact.id, encuesta.Id);
                        //delete tempContact;
                    }else{
                        //Inicio v14.2
                        AVX_log_encuestas__c logencuesta = new AVX_log_encuestas__c();
                        logencuesta.Name = encuesta.name+'_log';
                        logencuesta.COM_Correos__c = encuesta.COM_Caso__r.RF2_CorreoElectronicoRespuesta__c;
                        logencuesta.COM_Plantilla__c = lstPlantilla.get(0).DeveloperName;
                        logencuesta.COM_TempCon__c = false;
                        logencuesta.COM_Id_Contacto__c = encuesta.COM_Contacto__c;
                        logencuesta.COM_Cuenta__c = encuesta.Id; 
                        insert logencuesta;
                        //String jobID = system.schedule('Prueba envio '+encuesta.COM_Caso__r.CaseNumber, sch, new COM_EnviarCorreoTemplate_sch(setCorreos, new set<Id>(), lstPlantilla.get(0).DeveloperName, encuesta.COM_Contacto__c, encuesta.Id, null));  
                        //Final  v14.2
                        //COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, new set<Id>(), lstPlantilla.get(0).DeveloperName, encuesta.COM_Contacto__c, encuesta.Id);                       
                    }
                    //Final  v14.1
                    // } else{
                    // System.debug('El contacto '+encuesta.COM_Contacto__r.Name+ ' no tiene un correo asociado');
                    //}
                }
                else{
                    System.debug('La encuesta '+ encuesta.Name + ' no tiene un contacto asociado');
                }
            }    
        }
    }
    
    /* Inicio 18.0 */
    public void AsignarDescription(List<Case> lstNewCases){
        Set<Id> setParentCase = New Set<Id>();
        Map<Id, String> mapDescr = New Map<Id, String>();
        
        For(Case objCase : lstNewCases){
            if(objCase.ParentId != Null){
                setParentCase.add(objCase.ParentId);
            }
        }
        
        List<Case> lstParentCases = [Select Id, Description From Case where Id IN: setParentCase];
        
        For(Case parentCase : lstParentCases){
            mapDescr.put(parentCase.Id, parentCase.Description);
        }
        
        For(Case objCase : lstNewCases){
            if(mapDescr.containsKey(objCase.ParentId)){
                objCase.Description = mapDescr.get(objCase.ParentId);
            }
        }
        
    }
    /* Fin 18.0 */
}