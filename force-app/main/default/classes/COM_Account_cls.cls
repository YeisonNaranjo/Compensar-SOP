/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase del Trigger COM_Account_tgr donde se realizan los siguientes operaciones
                    - Generar el digito de verificación en base al Nit ingresado

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/08/17             Cristian David Mejia (CM)             Creación Clase.
    2.0     02/01/18             Helman Reyes         (HR)             Ajuste de excepción para timeout en actualización de dirección
    3.0     19/01/2018           Brisleydi Calderon   (BC)             Creación de método para buscar la dirección en Gestión de cliente y si existe, asignar 1 a un flag creado para actualizar el campo, sino existe se le asignó 0 al flag y se crea la dirección. 
    4.0     12/11/2019           Paula Bohorquez      (PB)             Creación de método que valida duplicados
                                                                        en cuentas que se originen desde Prospectos 
************************************************************************************************/
public with sharing class COM_Account_cls 
{
    
    /**
     * [GenerarDigitoNit description]
     * @param lstOldRecords [description]
     * @param lstNewRecords [description]
     */
    public void GenerarDigitoNit(List<Account> lstOldRecords, List<Account> lstNewRecords)
    {
        for(Integer i = 0; i < lstNewRecords.size(); i++)
        {
            if(String.isNotBlank(lstNewRecords[i].COM_Numero_de_identificacion__c)){
                if(lstNewRecords[i].COM_TipoIdentificacion__c == '2')
                {
                    if(lstOldRecords == null || lstOldRecords[i].COM_Numero_de_identificacion__c != lstNewRecords[i].COM_Numero_de_identificacion__c || lstNewRecords[i].COM_TipoIdentificacion__c != lstOldRecords[i].COM_TipoIdentificacion__c)          //
                    {
                        lstNewRecords[i].COM_Digitoverificacion__c = COM_Account_cls.GenerarDigitoNit(lstNewRecords[i].COM_Numero_de_identificacion__c);             //
                        System.debug(lstNewRecords[i].COM_Digitoverificacion__c);
                    }

                }else if(lstNewRecords[i].COM_TipoIdentificacion__c != '2'){
                     if(lstOldRecords == null || lstOldRecords[i].COM_Numero_de_identificacion__c != lstNewRecords[i].COM_Numero_de_identificacion__c || lstNewRecords[i].COM_TipoIdentificacion__c != lstOldRecords[i].COM_TipoIdentificacion__c)          //
                    {
                        lstNewRecords[i].COM_Digitoverificacion__c = null;
                        System.debug(lstNewRecords[i].COM_Digitoverificacion__c);
                    }

                }
            }
        }
    }

    /**
     * [GenerarDigitoNit description]
     * @param  strNumIdent [description]
     * @return             [description]
     */
    public static Integer GenerarDigitoNit(String strNumIdent)
    {
        String strNit1 = strNumIdent;

        integer x = 0, y = 0, z = strNit1.length(), i, intDv1;
        System.debug('z --> '+z); 

        List<Integer> lstStrVpri = new List<Integer>();
        lstStrVpri.add(0);
        lstStrVpri.add(3);
        lstStrVpri.add(7);
        lstStrVpri.add(13);
        lstStrVpri.add(17);
        lstStrVpri.add(19);
        lstStrVpri.add(23);
        lstStrVpri.add(29);
        lstStrVpri.add(37);
        lstStrVpri.add(41);
        lstStrVpri.add(43);
        lstStrVpri.add(47);
        lstStrVpri.add(53);
        lstStrVpri.add(59);
        lstStrVpri.add(67);
        lstStrVpri.add(71); 
            
        for(i=0 ; i<z ; i++)
        {
            y = Integer.valueOf(strNit1.substring(i, i+1));
            x+=(y*(lstStrVpri.get(z-i)));
        }
        y= math.mod(x, 11);

        if (y > 1)
            intDv1=11-y;
        else
            intDv1=y;

        System.debug('intDv1 --> '+intDv1);
         return intDv1;
    }

    /**
     * [calcularFechaPazYSalvo description]
     * @param lstNewRecords [description]
     */
    public void calcularFechaPazYSalvo(List<Account> lstNewRecords){
        BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
        for(Account cuenta : lstNewRecords){
            if(cuenta.COM_Fecharadicacioncartaretiro__c != null){
                Datetime dtFecha = datetime.newInstanceGmt(cuenta.COM_Fecharadicacioncartaretiro__c.year(), cuenta.COM_Fecharadicacioncartaretiro__c.month(),cuenta.COM_Fecharadicacioncartaretiro__c.day(),0,0,0);
                Datetime fechaLR = COM_Utilidades_cls.calcularFechaDiasHabiles(horarioOficina.Id, dtFecha, 60);
                cuenta.COM_FechaLimiteRetencion__c = fechaLR.dateGMT();
                cuenta.COM_DiasFaltantesRetencion__c = COM_Utilidades_cls.calcularNumeroDiasHabiles(horarioOficina.Id, fechaLR);
            }
        }
    }

    /**
     * [actualizarClientesGC description]
     * @param lstNewRecords [description]
     */
    public void actualizarClientesGC(List<Account> lstOldRecords, List<Account> lstNewRecords){
        Map<Id, Profile> mapPerfil = new Map<Id, Profile>([SELECT Id, Name FROM Profile]);
        if(mapPerfil.get(userinfo.getProfileId()).Name != 'integraciones_WS'){
            system.debug('actualizar a gc');
            Integer direccion = 0;
            for(Integer i = 0; i < lstNewRecords.size(); i++){
                direccion = 0;
                    if(lstNewRecords[i].COM_NAUTCLI__c != null){
                
                        /*if(lstOldRecords[i].COM_Direccion__c== null && lstNewRecords[i].COM_Direccion__c != null){
                            direccion = 0;// creacion
                        } else {
                            direccion = 1;// actualizacion
                        }*/
                        //system.debug(' crear  0 o actu 1 : ' +direccion);
                        enviarActualizacion(String.valueOf(lstNewRecords[i].Id), direccion);
                    }
            }   
        }
    }

    /**
     * [actualizarClientesGC description]
     * @param lstNewRecords [description]
     */
    /*public void validarPermisos(List<Account> lstNewRecords){
        List<PermissionSetAssignment> pst = [SELECT Id FROM PermissionSetAssignment 
            WHERE PermissionSet.Name = 'Actualizacion_GC' AND AssigneeId = :UserInfo.getUserId() LIMIT 1]; 
        List<Profile> pro = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        for(Account acc : lstNewRecords)
            if(acc.COM_NAUTCLI__c != null)
                if(pro[0].Name != 'Administrador del sistema')
                    if(pst.size() == 0)
                        acc.addError('No dispone de permisos para actualizar el registro, consulte al administrador del sistema (Conjunto de permisos GC).');   
    }
    */
   
    /**
     * [enviarActualizacion description]
     * @param idCuenta [description]
     */
     
     // BRIS 12-01-2018
     
    /*@Future(callout=true)
    public static void enviarActualizacion(String idCuenta, Integer direccion){
        list<Account> lstCuenta;
        Account objCuenta;
        boolean blnActualizar;
        
        
        lstCuenta = [SELECT Id, COM_No_procesado_On_Line__c,COM_Direccion__c FROM Account WHERE Id = :idCuenta];
        
        if(lstCuenta.isEmpty()){
            return;
        }
        
        blnActualizar = false;
        objCuenta = lstCuenta.get(0);
        Boolean errorCallOut=false; //HR: creado para corrección timeout
        try{
            
            COM_WrapperCrearClienteGCResponse_cls nautcli = COM_CrearActualizarClienteGC_ws.CrearCliente(idCuenta, true, direccion);
            System.debug('nautcli --- >'+nautcli);
            if(nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente == null){
                System.debug('No se pudo actualizar el cliente');
            } else {
                System.debug('nautcli else --- > '+nautcli);
                String errorContacto = Label.COM_ErrorContacto;
                if(nautcli.CustomerMng_CrearClienteResponse.Header.ResponseDesc.contains(errorContacto)){
                    COM_WrapperCrearClienteGCResponse_cls nautcli2 = COM_CrearActualizarClienteGC_ws.CrearCliente(idCuenta, true, 0);
                    if(nautcli2==null){//HR: se agrega todo el if
                        errorCallOut=true;
                        throw new COM_WebServiceException('Posible timeout esperando respuesta del servicio GC');
                    }
                }

            }     
            
            //Si la transaccion estaba marcada indicando que NO fue procesada Online
            //Se desmarca para indicar que ya se proceso Online
            if(objCuenta.COM_No_procesado_On_Line__c){
                objCuenta.COM_No_procesado_On_Line__c = false;
                blnActualizar = true;
            }                           
        } catch (COM_WSInactivoException e) {
            objCuenta.COM_No_procesado_On_Line__c = true;
            blnActualizar = true;
            system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
        } catch(COM_WebServiceException ee){
            System.debug('Error en el servicio de actualización. Detalle: '+ee.getMessage());
            if(direccion==0 && errorCallOut){ //HR: se agrega todo el if. Cuando falla el servicio de integración (por CalloutException, seguramente timeout) la primera vez que se ingresa una dirección en la cuenta
                objCuenta.COM_Direccion__c=null;
                blnactualizar=true;           
            }           
            
        }catch(Exception eee){
            System.debug('Error en el servicio de actualización. Detalle: '+eee.getMessage());                       
        }
        
        if(blnActualizar){
            try{
                update objCuenta;
            } catch(Exception e){
                system.debug('ERROR ACTUALIZANDO EL CAMPO COM_No_procesado_On_Line__c DE LA CUENTA');
            }
        }
    }*/
    
    // 
    @Future(callout=true)
    public static void enviarActualizacion(String idCuenta, Integer direccion){
        list<Account> lstCuenta;
        Account objCuenta;
        boolean blnActualizar;
        integer existeDireccion = 0; //  existe:1 creacion:0
        
        
        lstCuenta = [SELECT Id, COM_No_procesado_On_Line__c,COM_Direccion__c,COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c FROM Account WHERE Id = :idCuenta];
        
        if(lstCuenta.isEmpty()){
            return;
        }
        
        blnActualizar = false;
        objCuenta = lstCuenta.get(0);
        Boolean errorCallOut=false; //HR: creado para corrección timeout
        try{
            //LLamo al nuevo metodo
            if(objCuenta.COM_Direccion__c!=null){
                existeDireccion = buscarDireccionCuenta(lstCuenta); // este metodo llama al servicio Web y consulta si en GE hay una direccion de cliente, si hay por lo menos una manda a actualizar.
                system.debug(' existeDireccion ?'+existeDireccion);
            }
            
            COM_WrapperCrearClienteGCResponse_cls nautcli = COM_CrearActualizarClienteGC_ws.CrearCliente(idCuenta, true, existeDireccion);
            System.debug('nautcli --- >'+nautcli);
            if(nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente == null){
                System.debug('No se pudo actualizar el cliente');
            } else {
                System.debug('nautcli else --- > '+nautcli);
                String errorContacto = Label.COM_ErrorContacto;
                if(nautcli.CustomerMng_CrearClienteResponse.Header.ResponseDesc.contains(errorContacto)){
                    COM_WrapperCrearClienteGCResponse_cls nautcli2 = COM_CrearActualizarClienteGC_ws.CrearCliente(idCuenta, true, 0);
                    if(nautcli2==null){//HR: se agrega todo el if
                        System.debug('ERROR|'+nautcli2);
                        errorCallOut=true;
                        throw new COM_WebServiceException('Posible timeout esperando respuesta del servicio GC');
                    }
                }

            }     
            
            //Si la transaccion estaba marcada indicando que NO fue procesada Online
            //Se desmarca para indicar que ya se proceso Online
            if(objCuenta.COM_No_procesado_On_Line__c){
                objCuenta.COM_No_procesado_On_Line__c = false;
                blnActualizar = true;
            }                           
        } catch (COM_WSInactivoException e) {
            objCuenta.COM_No_procesado_On_Line__c = true;
            blnActualizar = true;
            system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
        } catch(COM_WebServiceException ee){
            System.debug('Error en el servicio de actualización. Detalle: '+ee.getMessage());
            if(direccion==0 && errorCallOut){ //HR: se agrega todo el if. Cuando falla el servicio de integración (por CalloutException, seguramente timeout) la primera vez que se ingresa una dirección en la cuenta
                objCuenta.COM_Direccion__c=null;
                blnactualizar=true;           
            }           
            
        }catch(Exception eee){
            System.debug('Error en el servicio de actualización. Detalle: '+eee.getMessage());                       
        }
        
        if(blnActualizar){
            try{
                update objCuenta;
            } catch(Exception e){
                system.debug('ERROR ACTUALIZANDO EL CAMPO COM_No_procesado_On_Line__c DE LA CUENTA');
            }
        }
    }
    

    /**
    Método que se encarga de asignar al campo Name de personas naturales la concatenación de todos
    los nombres.  
    @dlopez  Septiembre 25 2017
    */
    public void actualizarName (List<Account> lstNewRecords)
    {
     
    Id idrecordTypeNatural = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.COM_LabelPersonaNatural).getRecordTypeId();
        
        
     for(Integer j = 0; j < lstNewRecords.size(); j++)
     {
          Account objAccount =   lstNewRecords.get(j);
          Id idRecordType = objAccount.recordTypeId;
           
           if(idrecordTypeNatural == idRecordType){
               String nombre1 = objAccount.COM_Primernombre__c;
               String nombre2 =objAccount.COM_Otrosnombres__c;
               String apellido1 = objAccount.COM_Primerapellido__c;
               String apellido2 =objAccount.COM_Segundoapellido__c;
               
               String concatenacion = nombre1;
               
               if(nombre2!= null){
                  concatenacion = concatenacion+' '+nombre2;
               }
               
               concatenacion = concatenacion+' '+apellido1;
               
               if(apellido2!= null){
                  concatenacion = concatenacion+' '+apellido2;
               }
                              
               objAccount.Name = concatenacion;
           }
           
     }

            
    }
   /*BRIS*/
   public static integer  buscarDireccionCuenta(list<account> listcuentaDir){
        
        account cuentaDir = listcuentaDir.get(0);
        integer existeDir = 0;
        //Account responseAccount = [Select COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c from Account where Id =: IdUsuarioCliente];  
        
        COM_WrapperConsultaClienteGCResponse_cls.Body wrpCuenta;
        COM_ConsultarClienteGC_ws clientesGC = new COM_ConsultarClienteGC_ws();
        
        wrpCuenta = clientesGC.Consultar(Integer.valueOf(cuentaDir.COM_TipoIdentificacion__c), Integer.valueOf(cuentaDir.COM_Numero_de_identificacion__c));
        if(wrpCuenta!=null){
            if(wrpCuenta.Cliente!= null && wrpCuenta.Cliente.comunicacionesCliente!=null && wrpCuenta.Cliente.comunicacionesCliente.comunicacionCliente!=null)
            System.debug('wrpCuenta  ----->'+wrpCuenta.Cliente.comunicacionesCliente.comunicacionCliente);
        
            list<COM_WrapperConsultaClienteGCResponse_cls.ComunicacionCliente> c = wrpCuenta.Cliente.comunicacionesCliente.comunicacionCliente;
            list<COM_WrapperConsultaClienteGCResponse_cls.DomicilioComunicacion> domComunicacion = new list<COM_WrapperConsultaClienteGCResponse_cls.DomicilioComunicacion>();
            
            for(COM_WrapperConsultaClienteGCResponse_cls.ComunicacionCliente item :c){
                if(item.domicilios!=null){
                    system.debug('----->'+item.domicilios.domicilioComunicacion);
                    domComunicacion = item.domicilios.domicilioComunicacion;
                }   
            }
            string direccionCuenta = '';
            if(domComunicacion!=null){
                for(COM_WrapperConsultaClienteGCResponse_cls.DomicilioComunicacion item2 :domComunicacion){
                    direccionCuenta = item2.domicilio;
                }
            }   
            if(!string.isblank(direccionCuenta)){
                existeDir = 1;
            }else{
                existeDir = 0;
            }
            system.debug('Existe Direccion:::'+existeDir);
        }
        return existeDir;    
    
    }

    /**
    * @Method:      validarDuplicadosCA
    * @param:       List<Account> lstAccount
    * @Description: Valida que no existan cuentas con el mismo tipo y número de documento antes de insertar
    *               una cuenta procedente de la conversión de un prospecto tipo cuenta acreedora, 
    * @author       Paula Bohórquez Alfonso- 12 de Noviembre 2019 
    */
    public void validarDuplicadosCA(List<Account> lstCuentasNew){
        
        System.debug('*****validarDuplicadosCA : '+lstCuentasNew);
        //Mapa tipo num
        Set<String> setTiposId = new Set<String>();
        Set<String> setNumerosId = new Set<String>();
        Set<String> setLlaves = new Set<String>();
        String strTemp;
        for(Account objAc : lstCuentasNew){
            System.debug('****** objAc'+objAc);
            System.debug('****** objAc'+objAc.CEL1_OrigenEsProspecto__c);
            if(objAc.CEL1_OrigenEsProspecto__c){
                strTemp = objAc.COM_TipoIdentificacion__c + objAc.COM_Numero_de_identificacion__c;
                setTiposId.add(objAc.COM_TipoIdentificacion__c);
                setNumerosId.add(objAc.COM_Numero_de_identificacion__c);
                
            }
        }

        if(!setNumerosId.isEmpty() && !setTiposId.isEmpty()){
            for(Account objCuentaExistente : [SELECT Id, COM_TipoIdentificacion__c,COM_Numero_de_identificacion__c FROM Account WHERE COM_TipoIdentificacion__c IN: setTiposId AND COM_Numero_de_identificacion__c IN: setNumerosId ]){
                strTemp = objCuentaExistente.COM_TipoIdentificacion__c + objCuentaExistente.COM_Numero_de_identificacion__c;
                setLlaves.add(strTemp);
            }
        }     
        if(!setLlaves.isEmpty()){
            for(Account objCuenta : lstCuentasNew){
            strTemp = objCuenta.COM_TipoIdentificacion__c + objCuenta.COM_Numero_de_identificacion__c;
                if(setLlaves.contains(strTemp)){
                    objCuenta.addError(Label.CEL1_CuentaAcDuplicada);
                }
            }
        }        
    }

    /**
    * @Method:      asignarPropietarioCandidatoCA
    * @param:       Map<Id,Account> mapCuentasNew, Map<Id,Account> mapCuentasOld
    * @Description: Cuando un cliente cambie su estado a 'Afiliado' se debe buscar si existían
                    candidatos ya creados que se relacionen a este cliente de acuerdo al tipo y número de 
                    documento. En caso de que exista el candidato cuenta acreedora, su dueño debe cambiarse
                    por el asesor paf del equipo de cuentas del cliente y posteriormente debe convertirse
                    este candidato y asociarlo al cliente mencionado.
    * @author       Paula Bohórquez Alfonso- 12/02/2020 
    */
    public void asignarPropietarioCandidatoCA(Map<Id,Account> mapCuentasNew, Map<Id,Account> mapCuentasOld){
        System.debug('ENTRO A METODO asignarPropietarioCandidatoCA.....');
        System.debug('mapCuentasNew....'+mapCuentasNew);
        System.debug('mapCuentasOld....'+mapCuentasOld);
        Map<String,String> mapTDNDxIdCliente = new Map<String,String>();
        Map<String,String> mapIdClientexIdContacto = new Map<String,String>();
        Set<String> setTiposDocumento = new Set<String>();
        Set<String> setNumerosDocumento = new Set<String>();
        String tempKey = '';
        for(Account objClienteNew : mapCuentasNew.values()){
            if((mapCuentasOld.get(objClienteNew.Id).COM_Estadoafiliacion__c != objClienteNew.COM_Estadoafiliacion__c) && objClienteNew.COM_Estadoafiliacion__c == '0' && String.isNotBlank(String.valueOf(objClienteNew.CEL1_LineaNegocio__c)) && String.valueOf(objClienteNew.CEL1_LineaNegocio__c).contains('Afiliación Corporativa')){
               //setIdsUpdate.add(objClienteNew.Id);
               tempKey = String.valueOf(objClienteNew.COM_TipoIdentificacion__c) + String.valueOf(objClienteNew.COM_Numero_de_identificacion__c);
               System.debug('===>>> asignarPropietarioCandidatoCA : tempKeyACC '+tempKey);
               mapTDNDxIdCliente.put(tempKey,objClienteNew.Id);
               setTiposDocumento.add(objClienteNew.COM_TipoIdentificacion__c);
               setNumerosDocumento.add(objClienteNew.COM_Numero_de_identificacion__c);
            }
        }
        //Buscar si existe contacto relacionado a la cuenta
        for(AccountContactRelation objAcr : [SELECT ContactId,AccountId FROM AccountContactRelation WHERE AccountId IN: mapTDNDxIdCliente.values() AND  Roles INCLUDES ('Representante Legal')]){
            mapIdClientexIdContacto.put(objAcr.AccountId,objAcr.ContactId);
        }

        List<Lead> lstCandidatosUpdate = new List<Lead>();
        Map<String,String> mapIdClientexIdLead = new Map<String,String>();
        Map<String,String> mapIdLeadxIdCliente = new Map<String,String>();
        Map<String,Lead> mapIdLeadxLead = new Map<String,Lead>();
        Map<String,String> mapIdLeadxIdOwnerOld = new Map<String,String>();
        //CEL 1  - PB : Buscar si existen candidatos relacionados a la cuenta (con el mismo tipo y número de documento)
		/* Inicio 5.0 */
        //for(Lead objCandidatoExistente : [SELECT Id, CEL1_NumeroDocumento__c,CEL1_TipoDocumento__c,OwnerId,CEL1_ConvertidoDesdeCliente__c FROM Lead WHERE CEL1_TipoDocumento__c IN: setTiposDocumento AND CEL1_NumeroDocumento__c IN: setNumerosDocumento AND RecordType.DeveloperName IN ('CEL1_ProspectoCuentaAcreedoraPN','CEL1_ProspectosCuentaAcreedoraPJ')]){
        for(Lead objCandidatoExistente : [SELECT Id, CEL1_NumeroDocumento__c,CEL1_TipoDocumento__c,OwnerId,CEL1_ConvertidoDesdeCliente__c FROM Lead WHERE CEL1_TipoDocumento__c IN: setTiposDocumento AND CEL1_NumeroDocumento__c IN: setNumerosDocumento AND RecordType.DeveloperName IN ('CEL1_ProspectoCuentaAcreedoraPN','CEL1_ProspectosCuentaAcreedoraPJ') AND IsConverted = false]){
		/* Fin 5.0 */
            tempKey = String.valueOf(objCandidatoExistente.CEL1_TipoDocumento__c) + String.valueOf(objCandidatoExistente.CEL1_NumeroDocumento__c);
            System.debug('===>>> asignarPropietarioCandidatoCA : tempKeyLEAD '+tempKey);            
            System.debug('===>>> asignarPropietarioCandidatoCA : mapTDNDxIdCliente.get(tempKey) '+mapTDNDxIdCliente.get(tempKey));            
            System.debug('===>>> asignarPropietarioCandidatoCA : objCandidatoExistente '+objCandidatoExistente);            
            mapIdClientexIdLead.put(mapTDNDxIdCliente.get(tempKey),objCandidatoExistente.Id);
            mapIdLeadxIdCliente.put(objCandidatoExistente.Id,mapTDNDxIdCliente.get(tempKey));
            mapIdLeadxLead.put(objCandidatoExistente.Id,objCandidatoExistente);
            mapIdLeadxIdOwnerOld.put(objCandidatoExistente.Id,objCandidatoExistente.OwnerId);
            
            
        }
        if(!mapIdLeadxLead.isEmpty()){
          System.debug('===>>> asignarPropietarioCandidatoCA:SE VA A ENVIAR A ASIGNAR : mapIdClientexIdLead'+mapIdClientexIdLead);
          System.debug('===>>> asignarPropietarioCandidatoCA:SE VA A ENVIAR A ASIGNAR : mapIdLeadxLead'+mapIdLeadxLead);
          Map<Id, Lead> mapCandidatosNew = CEL1_ClienteCuentaAcreedora_cls.asignarPropietarioCandidato(mapIdClientexIdLead, mapIdLeadxLead, true,true);
          System.debug('===>>> asignarPropietarioCandidatoCA:LLEGA DE ASIGNAR : mapCandidatosNew'+mapCandidatosNew);

          if(!mapCandidatosNew.isEmpty()){
              System.debug('******* SE VAN A ACTUALIZAR LOS CANDIDATOS : '+mapCandidatosNew.values());
              update mapCandidatosNew.values();
          }
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            //Se van a convertir los candidatos
            List<Database.LeadConvert> lstCandidatoConvert = new List<Database.LeadConvert>();
            for(Lead objCand : mapCandidatosNew.values()){
                tempKey = String.valueOf(objCand.CEL1_TipoDocumento__c) + String.valueOf(objCand.CEL1_NumeroDocumento__c);
                if(mapTDNDxIdCliente.containsKey(tempKey)){
                    Database.LeadConvert tempLC = new Database.LeadConvert();
                    tempLC.setLeadId(objCand.id);
                    tempLC.setConvertedStatus(convertStatus.MasterLabel);
                    tempLC.setAccountId(mapTDNDxIdCliente.get(tempKey));                        
                    tempLC.setDoNotCreateOpportunity(true);         
                    if(mapIdClientexIdContacto.containsKey(mapTDNDxIdCliente.get(tempKey))){
                        tempLC.setContactId(mapIdClientexIdContacto.get(mapTDNDxIdCliente.get(tempKey)));}
                    lstCandidatoConvert.add(tempLC);
                }
                System.debug('===>>> asignarPropietarioCandidatoCA:SE VA A ENVIAR A ASIGNAR2 : mapIdLeadxLead'+mapIdLeadxLead);
          
            }

            System.debug('===>>> asignarPropietarioCandidatoCA: listCandidatoConvert : '+lstCandidatoConvert);
            List<Task> lstTareas = new List<Task>();
            List<Database.LeadConvertResult> lstRes = Database.convertLead(lstCandidatoConvert);
            for(Database.LeadConvertResult lctemp: lstRes){
                if(lctemp.isSuccess()){
                    System.debug('===>>> asignarPropietarioCandidatoCA: EL CANDIDATO FUE CONVERTIDO ID'+lctemp.getLeadId());
                    System.debug('===>>> asignarPropietarioCandidatoCA: EL CANDIDATO FUE CONVERTIDO ACCID'+lctemp.getAccountId());
                    System.debug('===>>> asignarPropietarioCandidatoCA: OWNERID'+mapIdLeadxIdOwnerOld.get(lctemp.getLeadId()));
                              
                    Task tempTask = new Task(Description = Label.CEL1_CandidatoConvertidoDesc,
                                        Priority = 'Normal',
                                        Subject = Label.CEL1_CandidatoConvertido,
                                        IsReminderSet = true,
                                        WhoId = lctemp.getLeadId(),
                                        //WhatId = mapIdLeadxIdCliente.get(lctemp.getLeadId()),
                                        ReminderDateTime = System.now(),
                                        OwnerId =  mapIdLeadxIdOwnerOld.get(lctemp.getLeadId()));             
                    lstTareas.add(tempTask);
                }
            }
            System.debug('===>>> asignarPropietarioCandidatoCA: lstTareas: '+lstTareas);
                    
            //CEL1 - PB - Se crea la tarea para el asesor
            if(!lstTareas.isEmpty()){
                insert lstTareas;
            }

        }
    }
}