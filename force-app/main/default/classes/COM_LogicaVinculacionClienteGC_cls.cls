/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para el procesamiento de las solicitudes de Vinculación de Clientes en GC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    14/08/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   1.1    21/11/2017      Rubén Suárez Forero (RUSF)          Modificación Vinculación
****************************************************************************************************************/
public with sharing class COM_LogicaVinculacionClienteGC_cls {
    
    /* 
    * Nombre: procesarVinculacion
    * Descripcion: Metodo encargado iniciar el proceso de vinculacion y validar si el cliente o 
    *              el representante legal ya tienen NAUCLI, sino lo obtiene de GC
    * Fecha Creación: 26/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            14-Ago-2017     Juan David Uribe Ruiz         Creacion del metodo.
    *   1.2          16-Ago-2018     Stifen Panche Gutierrez       Se consulta el ClosedDate para enviar fecha de ingreso.
    *   2.0          06-Ene-2022     Yeison Naranjo			       Incluir cambio vinculación GC NOLA 00030781.
    * --------------------------------------------------------------------------------------------------------------
    */
    public String procesarVinculacion(Id idOportunidad){
        COM_ConsultarClienteGC_ws clientesGC;
        list<Opportunity> lstOportunidad;
        list<Account> lstCuenta;
        list<Contact> lstRepresentanteLegal;
        list<COM_LogTransacciones__c> lstLogs;
        COM_LogTransacciones__c objLog;
        Opportunity objOportunidad;
        Account objCuenta;
        Account objCuentaRL;
        Contact objRepresentanteLegal;
        Decimal decResponse;
        COM_WrapperConsultaClienteGCResponse_cls.Body wrpCuenta;
        boolean blnActualizarCuenta;
        boolean blnActualizarRepresentante;
        boolean blnActualizarOportunidad;
        boolean blnError;
        boolean blnTest1;
        boolean blnTest2;
        boolean blnTest3;
        boolean blnTest4;
		boolean blnTest5;
        String strRequestAux;
        COM_ConfiguracionWebServiceM__mdt objConfiguracionWebService;
        
        blnActualizarCuenta = false;
        blnActualizarRepresentante = false;
        blnActualizarOportunidad = false;
        blnError = false;
        lstLogs = new list<COM_LogTransacciones__c>();
        strRequestAux = '';
        
        lstOportunidad = [SELECT Id, AccountId, COM_FechaIngresoEmpresa__c, LastModifiedDate, CreatedDate, 
                         COM_TotalHijosDerechoSubsidio__c, COM_Opcionvinculacion__c, COM_ProgramaVinculacion1__c, 
                         COM_ProgramaVinculacion1__r.COM_Codigo__c, COM_ProgramaVinculacion1__r.COM_ProgramaPadre__c, COM_No_procesado_On_Line__c, 
                         COM_ProgramaVinculacion1__r.Name, COM_SalarioBase__c, COM_ValorPension__c, RecordTypeId, RecordType.DeveloperName,
                         COM_BaseAporteContratista__c, COM_ActividadeconomicaSENA__c, COM_ActividadEconomicaCIIU__r.COM_Codigo__c, COM_SectorEconomico__c,
                         
                         COM_EntidadPensionadora1__c, COM_EntidadPensionadora1__r.Name, COM_EntidadPensionadora1__r.COM_NAUTCLI__c,
                         COM_EntidadPensionadora1__r.COM_Numero_de_identificacion__c, COM_EntidadPensionadora1__r.COM_TipoIdentificacion__c,

                         COM_EntidadContratista__c, COM_EntidadContratista__r.Name, COM_EntidadContratista__r.COM_NAUTCLI__c,
                         COM_EntidadContratista__r.COM_Numero_de_identificacion__c, COM_EntidadContratista__r.COM_TipoIdentificacion__c,
                         
                         COM_CentrodeCostoEntidadqueContrata__c, COM_CentrodeCostoEntidadqueContrata__r.Name, COM_CentrodeCostoEntidadqueContrata__r.COM_NAUTCLI__c,
                         COM_CentrodeCostoEntidadqueContrata__r.COM_Numero_de_identificacion__c, COM_CentrodeCostoEntidadqueContrata__r.COM_TipoIdentificacion__c,
                         
                         COM_CentroDeCostoPension__c, COM_CentroDeCostoPension__r.Name, COM_CentroDeCostoPension__r.COM_NAUTCLI__c,
                         COM_CentroDeCostoPension__r.COM_Numero_de_identificacion__c, COM_CentroDeCostoPension__r.COM_TipoIdentificacion__c,
                         
                         COM_SucursalPension__c, COM_SucursalPension__r.Name, COM_SucursalPension__r.COM_NAUTCLI__c,
                         COM_SucursalPension__r.COM_Numero_de_identificacion__c, COM_SucursalPension__r.COM_TipoIdentificacion__c,
                         
                         COM_SucursalContratista__c, COM_SucursalContratista__r.Name, COM_SucursalContratista__r.COM_NAUTCLI__c,
                         COM_SucursalContratista__r.COM_Numero_de_identificacion__c, COM_SucursalContratista__r.COM_TipoIdentificacion__c,
                         COM_Vinculadodesde__c,COM_FechaRegistrado__c, COM_ARL1__r.COM_CodigoARL__c, COM_TipoEmpresa__c,
                         COM_Comite__r.Name,/*Inicio 1.2*/CloseDate/*Fin 1.2*/
                        FROM Opportunity 
                        WHERE Id = :idOportunidad];
        objOportunidad = lstOportunidad.get(0);
        
        lstCuenta = [SELECT Id, Name, COM_Otrosnombres__c, COM_Primerapellido__c, COM_Segundoapellido__c, COM_Nombre_completo_del_cliente__c, 
                            COM_FechaNacimiento__c, COM_Genero__c, COM_Estado_civil__c, COM_Profesion__c, COM_Categoria__c, COM_Estadoafiliacion__c, 
                            COM_Digitoverificacion__c, Type, COM_NombreComercial__c, COM_Fechaconstitucion__c, COM_ActividadEconomicaCIIU__r.COM_Codigo__c, 
                            COM_SectorEconomico__c, Parent.Name, COM_Sucursal__c, COM_CentroCosto__c, COM_Negociacionadicional__c, Phone, COM_Extension__c, 
                            COM_Barrio__c, COM_Aceptaenviocorreoelectronico__c, COM_Tipodireccion__c, COM_Direccion__c, COM_Localidad__c, 
                            COM_Ciudad__r.COM_Codigo__c, COM_Ciudad__r.Name, COM_Ciudad__r.COM_Departamento__c, COM_CorreoElectronico__c, 
                            COM_UsuarioFacebook__c, COM_UsuarioTwitter__c, RecordTypeId, RecordType.DeveloperName, COM_TipoIdentificacion__c, 
                            COM_Numero_de_identificacion__c, COM_NAUTCLI__c, COM_TipoCliente__c, COM_ActividadeconomicaSENA__c,
                            COM_ModalidadentregatarjetaCompensar__c, COM_Valorultimoaporte__c, COM_AceptaenvioSMS__c, COM_Movil__c,
                            Website, COM_BeneficiariosDerechoSubsidio__c, COM_Segmento__c,
                            COM_Caja_anterior__c, COM_Tratamientoprotecciondatos__c,
                            COM_Trabajadoresderechosubsidio__c,  COM_No_procesado_On_Line__c, 
                            COM_Valorultimosubsidio__c, COM_TotaltrabajadorescategoriaC__c, COM_Total_trabajadores__c, COM_Primernombre__c
                     /* Inicio 2.0 */, COM_ResponsabilidadesFiscales__c /* Fin 2.0 */
                    FROM Account 
                    WHERE Id = :objOportunidad.AccountId];
        
        /*List<COM_ProgramaSinVinculacionGC__mdt> lstProgramasNoEnviar = new List<COM_ProgramaSinVinculacionGC__mdt>([SELECT COM_IdPrograma__c 
            FROM COM_ProgramaSinVinculacionGC__mdt 
            WHERE COM_IdPrograma__c =: lstOportunidad.get(0).COM_ProgramaVinculacion1__r.COM_Codigo__c]);
        */
        Boolean blnNoEnviar = false;
        /*if(!lstProgramasNoEnviar.isEmpty() && lstOportunidad.get(0).COM_ProgramaVinculacion1__r.COM_Codigo__c == lstProgramasNoEnviar.get(0).COM_IdPrograma__c){
            blnNoEnviar = true;
        }*/
        
        if(!lstCuenta.isEmpty()){
            objCuenta = lstCuenta.get(0);
        } else{
            //Error indicando que la oportnidad no tiene un cliente para vincular
            return 'La oportunidad no tiene una cuenta asociada';
        }
        if(!blnNoEnviar){
            objConfiguracionWebService = [Select COM_Activo__c From COM_ConfiguracionWebServiceM__mdt where Label = :label.COM_WS_VincularClienteGC limit 1];
            if(objConfiguracionWebService == null){
                //Error indicando que no se encontro la configuracion para consumir el Web Service
                throw new COM_WebServiceException('No se encontró la configuración para el servicio ' + label.COM_WS_VincularClienteGC);
            }
            
            if(!objConfiguracionWebService.COM_Activo__c){
                system.debug('El Web Service ' + label.COM_WS_VincularClienteGC + ' se encuentra desactivado.');
                try{
                    objOportunidad.COM_No_procesado_On_Line__c = true;
                    update objOportunidad;
                } catch(Exception e){
                    system.debug('NO SE MARCAR LA OPORTUNIDAD COMO NO PROCESADA ONLINE');
                }
                throw new COM_WSInactivoException('El Web Service ' + label.COM_WS_VincularClienteGC + ' se encuentra desactivado.');
            }
        }
        
        lstRepresentanteLegal = [SELECT Account.Name, COM_TipoIdentificacion__c, COM_Numeroidentificacion__c, COM_FechaNacimiento__c, COM_EstadoCivil__c, 
                    FirstName,MiddleName, LastName, Account.COM_NAUTCLI__c, Account.COM_Nombre_completo_del_cliente__c, 
                    AccountId, Account.Id, Account.COM_Numero_de_identificacion__c, Account.COM_TipoIdentificacion__c
            FROM Contact 
            WHERE Id IN (SELECT ContactId FROM AccountContactRelation WHERE Roles INCLUDES ('Representante Legal') 
                AND IsActive = true AND AccountId = :objCuenta.Id)];

        try{
            if(objCuenta.RecordType.DeveloperName.equals('COM_Juridico')){
                if(lstRepresentanteLegal.isEmpty() && objCuenta.RecordType.DeveloperName.equals('COM_Juridico')){
                    //Se debe levantar un error debido a que para realizar la vinculacion la cuenta debe tener 1 Representante Legal
                    throw new COM_VinculacionClienteException('La cuenta que se esta tratando de vincular es Juridica y no tiene un Representante Legal asociado.');
                } 
                
                objRepresentanteLegal = lstRepresentanteLegal.get(0);
                if(objRepresentanteLegal.Account.COM_NAUTCLI__c == null){
                    //Se debe consultar si el cliente esta registrado en GC y si no mandarlo a crear
                    blnActualizarRepresentante = true;
                    if(clientesGC == null){
                        clientesGC = new COM_ConsultarClienteGC_ws();
                    }
                    
                    objCuentaRL = [SELECT Id, COM_NAUTCLI__c, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, COM_No_procesado_On_Line__c FROM Account WHERE Id = :objRepresentanteLegal.AccountId];
                    try {
                        strRequestAux = 'COM_TipoIdentificacion__c: ' + objRepresentanteLegal.COM_TipoIdentificacion__c;
                        strRequestAux += '; COM_Numeroidentificacion__c: ' + objRepresentanteLegal.COM_Numeroidentificacion__c;
                        
                        //wrpCuenta = clientesGC.Consultar(Integer.valueOf(objRepresentanteLegal.COM_TipoIdentificacion__c), Integer.valueOf(objRepresentanteLegal.COM_Numeroidentificacion__c));
                        wrpCuenta = clientesGC.Consultar(Integer.valueOf(objCuentaRL.COM_TipoIdentificacion__c), Integer.valueOf(objCuentaRL.COM_Numero_de_identificacion__c));
                        
                        /*objLog = COM_Utilidades_cls.generarLog(objRepresentanteLegal.AccountId, strRequestAux, wrpCuenta, Label.COM_WS_ConsultarClienteGC, null);
                        lstLogs.add(objLog);*/
                        system.debug('\n >> CAV 1 :'+wrpCuenta);
                        system.debug('\n >> CAV 2 :'+wrpCuenta.cliente.tipoIdentificacion);

                        if(wrpCuenta != null && wrpCuenta.cliente.tipoIdentificacion != '-1' && wrpCuenta.cliente.numeroIdentificacion != '-1'){
                            system.debug('.................. va a poner NAUCLI a Representante Legal');
                            objCuentaRL.COM_NAUTCLI__c = wrpCuenta.cliente.id;
                            objRepresentanteLegal.Account.COM_NAUTCLI__c = objCuentaRL.COM_NAUTCLI__c;
                        } else{
                            //decResponse = COM_CrearActualizarClienteGC_ws.CrearCliente(objCuentaRL.Id, false);
                            //objCuentaRL.COM_NAUTCLI__c = decResponse;
                            //objRepresentanteLegal.Account.COM_NAUTCLI__c = objCuentaRL.COM_NAUTCLI__c;
    
                            COM_WrapperCrearClienteGCResponse_cls nautcli;
                            try{
                                nautcli = COM_CrearActualizarClienteGC_ws.CrearCliente(objCuentaRL.Id, true,0);
                            } catch (COM_WSInactivoException e) {
                                objCuentaRL.COM_No_procesado_On_Line__c = true;
                                system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
                                throw e;
                            }
                            
                            //Si la transaccion estaba marcada indicando que NO fue procesada Online
                            //Se desmarca para indicar que ya se proceso Online
                            if(objCuentaRL.COM_No_procesado_On_Line__c){
                                objCuentaRL.COM_No_procesado_On_Line__c = false;
                            }
                            
                            if(nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente != null){
                                objCuentaRL.COM_NAUTCLI__c = nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente;                      
                                objRepresentanteLegal.Account.COM_NAUTCLI__c = objCuentaRL.COM_NAUTCLI__c;
                            } else {
                                System.debug('Error obteniendo el NAUTCLI');    
                            }
                            
                            
                        }
                    } catch(Exception e){
                        blnActualizarRepresentante = false;
                        /*objLog = COM_Utilidades_cls.generarLog(objRepresentanteLegal.AccountId, strRequestAux, null, Label.COM_WS_CrearActualizarClienteGC,  e.getMessage() + ' ' + e.getStackTraceString());
                        lstLogs.add(objLog);*/
                        System.Debug('====================== EXCEPCION [NAUCLI del Representante Legal] ======================');
                        System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                        System.Debug('========================================================================================');
                        throw new COM_VinculacionClienteException('Error obteniendo NAUCLI del Representante Legal');
                    }
                }
            } else {
                if(lstRepresentanteLegal.isEmpty() && objCuenta.RecordType.DeveloperName.equals('COM_Natural')){
                    //Se debe levantar un error debido a que para realizar la vinculacion la cuenta debe tener 1 Representante Legal
                    throw new COM_VinculacionClienteException('La cuenta no tiene representante legal asociado');
                } 
                objRepresentanteLegal = lstRepresentanteLegal.get(0);
            }
            
            if(objCuenta.COM_NAUTCLI__c == null){
                //Se debe enviar el cliente para que sea creado en GC
                blnActualizarCuenta = true;
                system.debug('........... El Cliente no tiene NAUTCLI va a iniciar el proceso de obtenerlo');
                clientesGC = new COM_ConsultarClienteGC_ws();
                try {
                    strRequestAux = '';
                    strRequestAux = 'COM_TipoIdentificacion__c: ' + objCuenta.COM_TipoIdentificacion__c;
                    strRequestAux += '; COM_Numero_de_identificacion__c: ' + objCuenta.COM_Numero_de_identificacion__c;
                    system.debug('........... Va a consultar cliente en GC');
                    wrpCuenta = clientesGC.Consultar(Integer.valueOf(objCuenta.COM_TipoIdentificacion__c), Integer.valueOf(objCuenta.COM_Numero_de_identificacion__c));
                    system.debug('@@@  ----> wrpCuenta '+wrpCuenta);
                    /*objLog = COM_Utilidades_cls.generarLog(objCuenta.Id, strRequestAux, wrpCuenta, Label.COM_WS_ConsultarClienteGC, null);
                    lstLogs.add(objLog);*/
                    
                    if(wrpCuenta != null && wrpCuenta.cliente.tipoIdentificacion != '-1' && wrpCuenta.cliente.numeroIdentificacion != '-1'
                        /*&& wrpCuenta.cliente.datosRepresentanteLegal.tipoIdentificacion != '-1' 
                        && wrpCuenta.cliente.datosRepresentanteLegal.numeroIdentificacion != '-1' */){
                        system.debug('........... SI se consulto el cliente y se encontro en GC');
                        objCuenta.COM_NAUTCLI__c = wrpCuenta.cliente.id;
                    } else{
                        system.debug('........... NO se encontro el cliente y se va crear en GC');
                        //decResponse = COM_CrearActualizarClienteGC_ws.CrearCliente(objCuenta.Id, false);
                        //objCuenta.COM_NAUTCLI__c = decResponse;
                        COM_WrapperCrearClienteGCResponse_cls nautcli2;
                        
                        try{
                            nautcli2 = COM_CrearActualizarClienteGC_ws.CrearCliente(objCuenta.Id, true,0);
                        } catch (COM_WSInactivoException e) {
                            objCuenta.COM_No_procesado_On_Line__c = true;
                            system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
                            throw e;
                        }
                        
                        //Si la transaccion estaba marcada indicando que NO fue procesada Online
                        //Se desmarca para indicar que ya se proceso Online
                        if(objCuenta.COM_No_procesado_On_Line__c){
                            objCuenta.COM_No_procesado_On_Line__c = false;
                        }
                        
                        if(nautcli2.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente != null){
                            objCuenta.COM_NAUTCLI__c = nautcli2.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente;                       
                        } else {
                            System.debug('Error obteniendo el NAUTCLI');    
                        }                   
                    }
                    
                    system.debug('........... NAUTCLI: ' + objCuenta.COM_NAUTCLI__c);
                } catch(Exception e){
                    /*objLog = COM_Utilidades_cls.generarLog(objCuenta.Id, strRequestAux, null, Label.COM_WS_CrearActualizarClienteGC, e.getMessage() + ' ' + e.getStackTraceString());
                    lstLogs.add(objLog);*/
                    
                    blnActualizarCuenta = false;
                    System.Debug('====================== EXCEPCION [NAUCLI del Cliente] ======================');
                    System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                    System.Debug('============================================================================');
                    throw new COM_VinculacionClienteException('Error obteniendo NAUCLI del Cliente');
                }
            }
        } catch(COM_VinculacionClienteException e){
            blnActualizarRepresentante = false;
            blnActualizarCuenta = false;
            lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
        
            if(lstLogs != null && !lstLogs.isEmpty()){
                system.debug('::::::::::::::::::::: SI VA A INSERTAR LOGS: ' + lstLogs.size());
                try{
                    insert lstLogs;
                    lstLogs = new list<COM_LogTransacciones__c>();
                    Cache.Org.put('local.partition1.logs', lstLogs);
                }catch(Exception ex){
                    system.debug('NO SE PUDO GUARDAR EL LOG.');
                    System.Debug('====================== EXCEPCION [log Vincular] ======================');
                    System.debug( ex.getMessage() + ' ' + ex.getStackTraceString());
                    System.Debug('======================================================================');
                }
            }
            throw new COM_VinculacionClienteException(e.getMessage());
        }
        
        //COM_WrapperVinculacionClienteRespons_cls wprResponse = new COM_WrapperVinculacionClienteRespons_cls();
        COM_WrapperVinculacionClienteRespons_cls.Body wprResponse = new COM_WrapperVinculacionClienteRespons_cls.Body();
        COM_VinculacionClienteGC_ws objVinculacionClienteGC = new COM_VinculacionClienteGC_ws();
        //COM_WrapperCrearClienteGCResponse_cls nautcli3 = new COM_WrapperCrearClienteGCResponse_cls();
        try{

            objLog = new COM_LogTransacciones__c();
            strRequestAux = '';
            strRequestAux += objOportunidad + ' <<<<>>>> ' + objCuenta + ' <<<<>>>> ' + objRepresentanteLegal;
            /* INICIO MODIFICACIÓN RUSF 1.1 PARTE 1
            if(!blnNoEnviar){
                //Enviar a vincular el cliente
                wprResponse = objVinculacionClienteGC.vincularCliente(objOportunidad, objCuenta, objRepresentanteLegal);
            } else {
                //Actualizar el cliente
                nautcli3 = COM_CrearActualizarClienteGC_ws.CrearCliente(objCuenta.Id, true,1);
            }
            */
            wprResponse = objVinculacionClienteGC.vincularCliente(objOportunidad, objCuenta, objRepresentanteLegal, blnNoEnviar);
            /* FIN MODIFICACIÓN RUSF 1.1 PARTE 1*/
            //Si la transaccion estaba marcada indicando que NO fue procesada Online
            //Se desmarca para indicar que ya se proceso Online
            if(objOportunidad.COM_No_procesado_On_Line__c){
                objOportunidad.COM_No_procesado_On_Line__c = false;
                blnActualizarOportunidad = true;
            } 
            
            /*objLog = COM_Utilidades_cls.generarLog(objOportunidad.Id, strRequestAux, wprResponse, Label.COM_WS_VincularClienteGC, null);
            lstLogs.add(objLog);*/
        } catch(COM_WSInactivoException wsie){
            objOportunidad.COM_No_procesado_On_Line__c = true;
            update objOportunidad;
            system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
            throw new COM_VinculacionClienteException(wsie.getMessage());
        } catch(COM_VinculacionClienteException vce){
            /*objLog = COM_Utilidades_cls.generarLog(objOportunidad.Id, strRequestAux, null, Label.COM_WS_VincularClienteGC,  vce.getMessage() + ' ' + vce.getStackTraceString());
            lstLogs.add(objLog);*/
            lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
        
            if(!lstLogs.isEmpty()){
                system.debug('::::::::::::::::::::: SI VA A INSERTAR LOGS: ' + lstLogs.size());
                try{
                    insert lstLogs;
                    lstLogs = new list<COM_LogTransacciones__c>();
                    Cache.Org.put('local.partition1.logs', lstLogs);
                }catch(Exception ex){
                    system.debug('NO SE PUDO GUARDAR EL LOG.');
                    System.Debug('====================== EXCEPCION [log Vincular] ======================');
                    System.debug( ex.getMessage() + ' ' + ex.getStackTraceString());
                    System.Debug('======================================================================');
                }
            }
            throw new COM_VinculacionClienteException(vce.getMessage());
        }
        
        if(blnActualizarOportunidad){
            update objOportunidad;
        }
        
        if(blnActualizarCuenta){
            update objCuenta;
        }
        
        if(blnActualizarRepresentante){
            system.debug('................. Va a actualizar representante');
            update objCuentaRL;
        }
        
        lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
        
        if(!lstLogs.isEmpty()){
            system.debug('::::::::::::::::::::: SI VA A INSERTAR LOGS: ' + lstLogs.size());
            try{
                insert lstLogs;
                lstLogs = new list<COM_LogTransacciones__c>();
                Cache.Org.put('local.partition1.logs', lstLogs);
            }catch(Exception ex){
                system.debug('NO SE PUDO GUARDAR EL LOG.');
                System.Debug('====================== EXCEPCION [log Vincular] ======================');
                System.debug( ex.getMessage() + ' ' + ex.getStackTraceString());
                System.Debug('======================================================================');
            }
        } else{
            system.debug('::::::::::::::::::::: LISTA LOGS VACIA');
        }
        /* INICIO MODIFICACIÓN RUSF 1.1 PARTE 2
        if(!blnNoEnviar){
            if(wprResponse != null){
                if(wprResponse.ProcesarVinculacionResponse.resultadoOperacion == 'true'){
                    Account acc = new Account();
                    acc.Id = objCuenta.Id;
                    acc.COM_Estadoafiliacion__c = '0';
                    try{
                        update acc;
                    }catch(Exception e){
                        system.debug('NO SE PUDO ACTUALIZAR EL CLIENTE');
                        System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                    }
                }
                return wprResponse.ProcesarVinculacionResponse.resultadoMensaje;
            }else{
                return null;
            }
        } else {
            if(nautcli3 != null && nautcli3.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente != null){
                Opportunity opp = new Opportunity();
                opp.Id = objOportunidad.Id;
                opp.COM_PendienteVinculacionGC__c = true;
                try{
                    update opp;
                }catch(Exception e){
                    system.debug('NO SE PUDO ACTUALIZAR LA OPORTUNIDAD');
                    System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                }
                return Label.COM_ProgramasNoVinculadosGC;
            }else{
                return null;
            }
        }
        */
        if(wprResponse != null){
            if(wprResponse.ProcesarVinculacionResponse.resultadoOperacion == 'true'){
                Account acc = new Account();
                acc.Id = objCuenta.Id;
                acc.COM_Estadoafiliacion__c = '0';
                acc.RF2_ComiteOpp__c = objOportunidad.COM_Comite__r.Name;
                try{
                    update acc;
                }catch(Exception e){
                    system.debug('NO SE PUDO ACTUALIZAR EL CLIENTE');
                    System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                }
            }
            return wprResponse.ProcesarVinculacionResponse.resultadoMensaje;
        } else {
            Opportunity opp = new Opportunity();
            opp.Id = objOportunidad.Id;
            opp.COM_PendienteVinculacionGC__c = true;
            try{
                update opp;
            }catch(Exception e){
                system.debug('NO SE PUDO ACTUALIZAR LA OPORTUNIDAD');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            }
            return null;
        }
       /* FIN MODIFICACIÓN RUSF 1.1 PARTE 1*/
       

    }

    
}