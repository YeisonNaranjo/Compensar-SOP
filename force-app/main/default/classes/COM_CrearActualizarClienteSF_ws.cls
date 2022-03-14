/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para los procesos de creacion y actualizacion de clientes en SFDC
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     28/07/2017      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.0     21/02/2018      Andrés Nicolás Ballesteros      NOLA-2938: No se están creando las relaciones entre cuentas y contactos de tipo representante legal
* @version  2.0     21/11/2019      Paula Bohórquez Alfonso         Se hace el ajuste para que los upsert de los clientes jurídico y natural se
hagan con base en la llave NAUTCLI.
* @version  3.0     06/07/2020      Yeison Naranjo				    NOLA-00018299: Ajuste de reconocimiento cuando existe relación previa como otros
* @version  4.0     13/08/2020      Yeison Naranjo				    NOLA-00019237: Ajuste nuevos campos.
*************************************************************************************************************/

@RestResource(urlMapping='/Cliente/*')
global class COM_CrearActualizarClienteSF_ws {
    
    public COM_CrearActualizarClienteSF_ws() {
        
    }
    
    @HttpPut
    global static WrapperResponseCliente crearCliente(COM_WrapperCrearActualizarClienteSF_cls cliente){
        WrapperResponseCliente respuesta = new WrapperResponseCliente();
        System.debug(cliente);
        if(cliente != null){
            //PB AVX 21-11 Se realiza la validación porque los upsert de cliente van a ser con base en el NAUTCLI
            if(String.isNotBlank(cliente.tipoIdentificacion) && String.isNotBlank(cliente.numeroIdentificacion) && 
               String.isNotBlank(cliente.id)&&cliente.id != '0'){
                   //FIN PB AVX 21-11
                   if(cliente.tipoIdentificacion == '2'){
                       if(cliente.DatosEmpresa != null && String.isNotBlank(cliente.DatosEmpresa.razonSocial)){
                           respuesta = ProcesarRequest(cliente);
                       }
                   } else {
                       if(cliente.DatosPersona != null && String.isNotBlank(cliente.DatosPersona.primerApellido) && 
                          String.isNotBlank(cliente.DatosPersona.primerNombre)){
                              respuesta = ProcesarRequest(cliente);
                          }
                   }
               }
            //PB AVX 21-11 Se realiza la validación porque los upsert de cliente van a ser con base en el NAUTCLI
            else if(String.isBlank(cliente.id) || cliente.id == '0'){
                respuesta.codigoRespuesta = 400;
                respuesta.mensajeRespuesta = 'Error: Por favor verifique que el Id del cliente esté lleno y sea diferente de 0';
                respuesta.fechaRespuesta = System.Now();
                return respuesta;
            }
            //FIN PB AVX 21-11
        }
        if(respuesta == null){
            respuesta = new WrapperResponseCliente();
            respuesta.codigoRespuesta = 400;
            respuesta.fechaRespuesta = System.Now();
            respuesta.mensajeRespuesta = 'Faltan datos obligatorios - Consulte con el administrador de SF';
        }
        return respuesta;
    }
    
    public static WrapperResponseCliente ProcesarRequest(COM_WrapperCrearActualizarClienteSF_cls cliente){
        System.debug('cliente==' + cliente);
        List<Account> lstConsulta = new List<Account>();
        if(cliente.tipoIdentificacion == '2'){
            lstConsulta = [SELECT Id, COM_NAUTCLI__c FROM Account WHERE COM_NAUTCLI__c =:cliente.Id AND COM_TipoIdentificacion__c=:cliente.tipoIdentificacion AND COM_Numero_de_identificacion__c =:cliente.numeroIdentificacion];
        }else{ 
            lstConsulta = [SELECT Id, COM_NAUTCLI__c FROM Account WHERE COM_TipoIdentificacion__c=:cliente.tipoIdentificacion AND COM_Numero_de_identificacion__c =:cliente.numeroIdentificacion];
        }
        System.debug('lstConsulta===' + lstConsulta); 
        Account accCliente = lstConsulta.size() > 0?lstConsulta.get(0): new Account();
        System.debug('accCliente=='+ accCliente);
        Account accRepresentanteLegal;
        Contact conRepresentanteLegal;
        AccountContactRelation acrRelacion;
        AccountContactRelation acrOldRelacion;
        Map<String,RecordType> tiposRegistro = new Map<String,RecordType>();
        List<RecordType> lstTR = [SELECT Id, DeveloperName From RecordType WHERE SobjectType = 'Account'];
        for(RecordType tr : lstTR){
            tiposRegistro.put(tr.DeveloperName, tr);
        }
        if(accCliente != null) {
            List<Contact> lstConRepresentanteLegal;
            List<Contact> lstConRepresentanteLegalOLD;
            List<AccountContactRelation> lstRelacion;
            if(cliente.tipoIdentificacion == '2') {
                if(cliente.DatosRepresentanteLegal != null){
                    lstConRepresentanteLegalOLD = [SELECT Id FROM Contact WHERE COM_TipoIdentificacion__c =: cliente.DatosRepresentanteLegal.tipoIdentificacion AND
                                                   COM_Numeroidentificacion__c =: cliente.DatosRepresentanteLegal.numeroIdentificacion];
                    List<Account> lstAccRepresentanteLegal = [SELECT Id FROM Account WHERE COM_NAUTCLI__c =:cliente.DatosRepresentanteLegal.Id 
                                                              AND COM_TipoIdentificacion__c = :cliente.DatosRepresentanteLegal.tipoIdentificacion 
                                                              AND COM_Numero_de_identificacion__c = :cliente.DatosRepresentanteLegal.numeroIdentificacion];
                    accRepresentanteLegal = lstAccRepresentanteLegal.size() > 0 ? lstAccRepresentanteLegal.get(0) : new Account();
                    /* Inicio 3.0 */
                    /*lstRelacion = [SELECT Id, AccountId, ContactId, Contact.COM_TipoIdentificacion__c, Contact.COM_Numeroidentificacion__c FROM AccountContactRelation 
                                   WHERE AccountId =:accCliente.Id AND IsActive = true AND Roles INCLUDES ('Representante Legal')];*/
                    lstRelacion = [SELECT Id, AccountId, ContactId, Contact.COM_TipoIdentificacion__c, Contact.COM_Numeroidentificacion__c FROM AccountContactRelation 
                                   WHERE AccountId =:accCliente.Id AND IsActive = true AND (Roles INCLUDES ('Representante Legal') OR (Contact.COM_TipoIdentificacion__c =: cliente.DatosRepresentanteLegal.tipoIdentificacion AND Contact.COM_Numeroidentificacion__c =: cliente.DatosRepresentanteLegal.numeroIdentificacion))];
                    /* Fin 3.0 */
                    
                    if(lstRelacion.size() > 0){
                        if(lstRelacion.get(0).Contact.COM_TipoIdentificacion__c == cliente.DatosRepresentanteLegal.tipoIdentificacion &&
                           lstRelacion.get(0).Contact.COM_Numeroidentificacion__c == cliente.DatosRepresentanteLegal.numeroIdentificacion){
                               acrRelacion = lstRelacion.get(0); 
                               acrRelacion.Roles = 'Representante Legal';
                               lstConRepresentanteLegal = [SELECT Id FROM Contact WHERE Id =:lstRelacion.get(0).Contact.Id];  
                           } else {
                               acrRelacion = new AccountContactRelation();
                               acrOldRelacion = lstRelacion.get(0);
                           }
                    } else {
                        acrRelacion = new AccountContactRelation();
                        
                    }   
                } else {
                    accRepresentanteLegal = new Account();
                    acrRelacion = new AccountContactRelation();
                }
            } else {
                lstConRepresentanteLegalOLD = [SELECT Id FROM Contact WHERE COM_TipoIdentificacion__c =: cliente.tipoIdentificacion AND
                                               COM_Numeroidentificacion__c =: cliente.numeroIdentificacion];
                lstRelacion = [SELECT Id, ContactId, Contact.COM_TipoIdentificacion__c, Contact.COM_Numeroidentificacion__c FROM AccountContactRelation 
                               WHERE AccountId =:accCliente.Id AND IsActive = true AND Roles INCLUDES ('Representante Legal')];
                if(lstRelacion.size() > 0){
                    if(lstRelacion.get(0).Contact.COM_TipoIdentificacion__c == cliente.tipoIdentificacion &&
                       lstRelacion.get(0).Contact.COM_Numeroidentificacion__c == cliente.numeroIdentificacion){
                           acrRelacion = lstRelacion.get(0);  
                           lstConRepresentanteLegal = [SELECT Id FROM Contact WHERE Id =:lstRelacion.get(0).Contact.Id];  
                       } else {
                           acrRelacion = new AccountContactRelation();
                           acrOldRelacion = lstRelacion.get(0);
                       }
                } else {
                    acrRelacion = new AccountContactRelation();
                }
            }
            if(lstConRepresentanteLegalOLD != null && lstConRepresentanteLegalOLD.size()>0){
                conRepresentanteLegal = lstConRepresentanteLegalOLD.get(0);
            } else {
                if(lstConRepresentanteLegal != null && lstConRepresentanteLegal.size()>0){
                    conRepresentanteLegal = lstConRepresentanteLegal.get(0);
                } else {
                    conRepresentanteLegal = new Contact();
                }
            }
        }
        accCliente.COM_TipoIdentificacion__c = cliente.tipoIdentificacion;
        accCliente.COM_Numero_de_identificacion__c = cliente.numeroIdentificacion;
        accCliente.COM_NAUTCLI__c = cliente.id;
        //accCliente.COM_Estadoafiliacion__c = cliente.estadoAfiliacion;
        if (cliente.tipoIdentificacion == '2') {
            //DATOS EMPRESA
            if(cliente.Sucursal != null){
                if(cliente.Sucursal.sucursalID != null && cliente.Sucursal.centrocostoID != null){
                    if(cliente.Sucursal.sucursalID == '0' && cliente.Sucursal.centrocostoID == '0'){
                        accCliente.RecordTypeId = tiposRegistro.get('COM_Juridico').Id;
                    } else if(cliente.Sucursal.sucursalID != '0' && cliente.Sucursal.centrocostoID == '0'){
                        accCliente.RecordTypeId = tiposRegistro.get('COM_Sucursal').Id;
                    } else if(cliente.Sucursal.sucursalID != '0' && cliente.Sucursal.centrocostoID != '0'){
                        accCliente.RecordTypeId = tiposRegistro.get('COM_CentroCosto').Id;
                    }
                } else {
                    accCliente.RecordTypeId = tiposRegistro.get('COM_Juridico').Id;
                }
            } else {
                accCliente.RecordTypeId = tiposRegistro.get('COM_Juridico').Id;
            }
            try {
                if(cliente.DatosEmpresa.digitoVerificadorLegal != null)
                    accCliente.COM_Digitoverificacion__c    = Integer.valueOf(cliente.DatosEmpresa.digitoVerificadorLegal);
            } catch (exception e) {
                System.debug('digito de verificación no válido - ' + e.getMessage());
            }
            accCliente.Name = cliente.DatosEmpresa.razonSocial;
            if(cliente.Sucursal != null){
                accCliente.COM_Sucursal__c = Integer.valueOf(cliente.Sucursal.sucursalID);
                accCliente.COM_CentroCosto__c = Integer.valueOf(cliente.Sucursal.centrocostoID);
            }
            if(cliente.DatosEmpresa.nombreComercial != null)
                accCliente.COM_NombreComercial__c = cliente.DatosEmpresa.nombreComercial;
            try {
                if(cliente.DatosEmpresa.constitucionFecha != null)
                    accCliente.COM_Fechaconstitucion__c = date.valueOf(cliente.DatosEmpresa.constitucionFecha);
            } catch (exception e) {
                System.debug('fecha de nacimiento no válida - ' + e.getMessage());
            }
            //DATOS REPRESENTANTE LEGAL
            if (cliente.DatosRepresentanteLegal != null) {
                if(cliente.DatosRepresentanteLegal.tipoIdentificacion != null && cliente.DatosRepresentanteLegal.numeroIdentificacion != null &&
                   cliente.DatosRepresentanteLegal.id != null && cliente.DatosRepresentanteLegal.nombrePrimero != null &&
                   cliente.DatosRepresentanteLegal.apellidoPrimero != null){
                       accRepresentanteLegal.RecordTypeId = tiposRegistro.get('COM_Natural').Id;
                       accRepresentanteLegal.COM_TipoIdentificacion__c = cliente.DatosRepresentanteLegal.tipoIdentificacion;
                       conRepresentanteLegal.COM_TipoIdentificacion__c = cliente.DatosRepresentanteLegal.tipoIdentificacion;
                       System.debug('-------->Primer Tipo Identificacion: '+accRepresentanteLegal.COM_TipoIdentificacion__c);
                       accRepresentanteLegal.COM_Numero_de_identificacion__c = cliente.DatosRepresentanteLegal.numeroIdentificacion;
                       conRepresentanteLegal.COM_Numeroidentificacion__c = cliente.DatosRepresentanteLegal.numeroIdentificacion;
                       accRepresentanteLegal.COM_NAUTCLI__c = cliente.DatosRepresentanteLegal.id;
                       accRepresentanteLegal.Name = cliente.DatosRepresentanteLegal.nombrePrimero;
                       accRepresentanteLegal.Name += cliente.DatosRepresentanteLegal.nombreSegundo!=null?(' '+cliente.DatosRepresentanteLegal.nombreSegundo):'';
                       accRepresentanteLegal.Name += ' '+cliente.DatosRepresentanteLegal.apellidoPrimero;
                       accRepresentanteLegal.Name += cliente.DatosRepresentanteLegal.apellidoSegundo!=null?(' '+cliente.DatosRepresentanteLegal.apellidoSegundo):'';            
                       accRepresentanteLegal.COM_Primernombre__c = cliente.DatosRepresentanteLegal.nombrePrimero;
                       conRepresentanteLegal.FirstName = cliente.DatosRepresentanteLegal.nombrePrimero;
                       if(cliente.DatosRepresentanteLegal.nombreSegundo != null){
                           accRepresentanteLegal.COM_Otrosnombres__c = cliente.DatosRepresentanteLegal.nombreSegundo;
                           conRepresentanteLegal.MiddleName = cliente.DatosRepresentanteLegal.nombreSegundo;
                       }
                       accRepresentanteLegal.COM_Primerapellido__c = cliente.DatosRepresentanteLegal.apellidoPrimero;
                       conRepresentanteLegal.LastName = cliente.DatosRepresentanteLegal.apellidoPrimero;
                       if(cliente.DatosRepresentanteLegal.apellidoSegundo != null){
                           accRepresentanteLegal.COM_Segundoapellido__c = cliente.DatosRepresentanteLegal.apellidoSegundo;
                           conRepresentanteLegal.LastName += cliente.DatosRepresentanteLegal.apellidoSegundo;
                       }
                       if(cliente.DatosRepresentanteLegal.genero != null){
                           accRepresentanteLegal.COM_Genero__c = cliente.DatosRepresentanteLegal.genero;
                       }
                       if(cliente.DatosRepresentanteLegal.estadoCivil != null){
                           accRepresentanteLegal.COM_Estado_civil__c = cliente.DatosRepresentanteLegal.estadoCivil;
                           conRepresentanteLegal.COM_EstadoCivil__c = cliente.DatosRepresentanteLegal.estadoCivil;
                       }
                       if(cliente.DatosRepresentanteLegal.nacimientoFecha != null){
                           try {
                               accRepresentanteLegal.COM_FechaNacimiento__c = Date.valueof(cliente.DatosRepresentanteLegal.nacimientoFecha);
                               conRepresentanteLegal.COM_Fechanacimiento__c = Date.valueof(cliente.DatosRepresentanteLegal.nacimientoFecha);
                           } catch (exception e) {
                               System.debug('fecha de nacimiento no válida - ' + e.getMessage());
                           }
                       }   
                   }
            }
        } else {
            //DATOS PERSONA
            accCliente.RecordTypeId = tiposRegistro.get('COM_Natural').Id;
            accCliente.Name = cliente.DatosPersona.primerNombre;
            accCliente.Name += cliente.DatosPersona.segundoNombre!=null?' '+cliente.DatosPersona.segundoNombre:'';
            accCliente.Name += ' '+cliente.DatosPersona.primerApellido;
            accCliente.Name += cliente.DatosPersona.segundoApellido!=null?' '+cliente.DatosPersona.segundoApellido:'';
            accCliente.COM_Primernombre__c = cliente.DatosPersona.primerNombre;
            conRepresentanteLegal.FirstName = cliente.DatosPersona.primerNombre;
            if(cliente.DatosPersona.segundoNombre != null){
                accCliente.COM_Otrosnombres__c = cliente.DatosPersona.segundoNombre;
                conRepresentanteLegal.MiddleName = cliente.DatosPersona.segundoNombre;
            }
            accCliente.COM_Primerapellido__c = cliente.DatosPersona.primerApellido;
            conRepresentanteLegal.LastName   = cliente.DatosPersona.primerApellido;
            if(cliente.DatosPersona.segundoApellido != null){
                accCliente.COM_Segundoapellido__c = cliente.DatosPersona.segundoApellido;
                conRepresentanteLegal.LastName += cliente.DatosPersona.segundoApellido;
            }
            if(cliente.DatosPersona.genero != null){
                accCliente.COM_Genero__c = cliente.DatosPersona.genero;
            }
            if(cliente.DatosPersona.estadoCivil != null){
                accCliente.COM_Estado_civil__c = cliente.DatosPersona.estadoCivil;
                conRepresentanteLegal.COM_EstadoCivil__c = cliente.DatosPersona.estadoCivil;
            }
            if(cliente.DatosPersona.nacimientoFecha != null){
                try {
                    accCliente.COM_FechaNacimiento__c = Date.valueof(cliente.DatosPersona.nacimientoFecha);
                    conRepresentanteLegal.COM_Fechanacimiento__c = Date.valueof(cliente.DatosPersona.nacimientoFecha);
                } catch (exception e) {
                    System.debug('fecha de nacimiento no válida - ' + e.getMessage());
                }
            }
            
            /* Inicio 4.0 */
            if(cliente.DatosPersona.orientacionSexual != null){
                accCliente.COM_OrientacionSexual__c = cliente.DatosPersona.orientacionSexual;
            }
            
            if(cliente.DatosPersona.nivelEscolar != null){
                accCliente.COM_NivelEscolaridad__c = cliente.DatosPersona.nivelEscolar;
            }
            
            if(cliente.DatosPersona.factorVulnerabilidad != null){
                accCliente.COM_FactorVunerabilidad__c = cliente.DatosPersona.factorVulnerabilidad;
            }
            
            if(cliente.DatosPersona.pertenenciaEtnica != null){
                accCliente.COM_PertenenciaEtnica__c = cliente.DatosPersona.pertenenciaEtnica;
            }
            
            if(cliente.DatosPersona.profesion != null){
                accCliente.COM_Profesion__c = cliente.DatosPersona.profesion;
            }
            /* Fin 4.0 */
            
            conRepresentanteLegal.COM_TipoIdentificacion__c         = cliente.tipoIdentificacion;
            conRepresentanteLegal.COM_Numeroidentificacion__c       = cliente.numeroIdentificacion;
        }
        //DATOS COMUNES CLIENTE
        try{
            accCliente.Phone = cliente.Comunicaciones.Comunicacion[0].telefonos.telefono[0].telefono;
        } catch (exception e) {
            System.debug('teléfono no válido - ' + e.getMessage());
        }
        try {
            accCliente.COM_Extension__c = cliente.Comunicaciones.Comunicacion[0].telefonos.telefono[0].extensionTelefono;
        } catch (exception e) {
            System.debug('extensión no válida - ' + e.getMessage());
        }
        try{
            accCliente.COM_Tipodireccion__c = cliente.Comunicaciones.Comunicacion[0].domicilios.domicilio[0].tipoAreaGeografica;
        }catch (exception e) {
            System.debug('COM_Tipodireccion__c no válido - ' + e.getMessage());
        }
        try{
            accCliente.COM_Direccion__c = cliente.Comunicaciones.Comunicacion[0].domicilios.domicilio[0].domicilio;
        }catch (exception e) {
            System.debug('COM_Direccion__c no válido - ' + e.getMessage());
        }
        try{
            accCliente.COM_Barrio__c = cliente.Comunicaciones.Comunicacion[0].domicilios.domicilio[0].barrio;
        }catch (exception e) {
            System.debug('COM_Barrio__c no válido - ' + e.getMessage());
        }
        try {
            COM_Poblacion__c pobCiudad = new COM_Poblacion__c(COM_Codigo__c = cliente.Comunicaciones.Comunicacion[0].domicilios.domicilio[0].codigoMunicipio);
            accCliente.COM_Ciudad__r = pobCiudad;
            system.debug('ciudad>>'+pobciudad+'>>>>'+accCliente.COM_Ciudad__c);
        } catch (exception e) {
            System.debug('Ciudad no válida - ' + e.getMessage());
        }
        try {
            accCliente.COM_CorreoElectronico__c = cliente.Comunicaciones.Comunicacion[0].correosElectronicos.correoElectronico[0].correoElectronico;
        } catch (exception e) {
            System.debug('Correo no válido - ' + e.getMessage());
        }
        try {
            accCliente.COM_Aceptaenviocorreoelectronico__c = Boolean.valueOf(cliente.Comunicaciones.Comunicacion[0].correosElectronicos.correoElectronico[0].opTinEmail);
        } catch (exception e) {
            System.debug('Opción de correo no válida - ' + e.getMessage());
        }
        try {
            accCliente.COM_Movil__c = cliente.Comunicaciones.Comunicacion[0].Celulares.celular[0].celular;
        } catch (exception e) {
            System.debug('Celular no válido - ' + e.getMessage());
        }
        try {
            accCliente.COM_AceptaenvioSMS__c = Boolean.valueOf(cliente.Comunicaciones.Comunicacion[0].Celulares.celular[0].opTinSMS);
        } catch (exception e) {
            System.debug('Opción de celular no válida - ' + e.getMessage());
        }
        //REQUISITOS
        System.debug('accRepresentanteLegal YSN1: ' + accRepresentanteLegal);
        if(cliente.requisitos != null && cliente.requisitos.requisito != null && cliente.requisitos.requisito.size() > 0){
            Map<String, sObject> mapObjetos = new Map<String, sObject>();
            if(accCliente.COM_TipoIdentificacion__c == '2'){
                try{
                    mapObjetos.put('Contact', accRepresentanteLegal);  
                } catch(Exception e){
                    System.debug('Error en el representante legal '+e.getMessage());
                }                
            }
	        System.debug('accRepresentanteLegal YSN2: ' + accRepresentanteLegal);
            mapObjetos.put('Account', accCliente);
            Map<String, List<COM_ConfiguracionRequisitos_ClienteSF__mdt>> mapReqPrograma = new Map<String, List<COM_ConfiguracionRequisitos_ClienteSF__mdt>>();
            /*Inicio 00265100*/
            List<COM_ConfiguracionRequisitos_ClienteSF__mdt> lstCOM_ConfigRequisitosM = new List<COM_ConfiguracionRequisitos_ClienteSF__mdt>();
            if(cliente.tipoIdentificacion == '2'){//Requisitos para persona Juridica con contacto Representante Legal
                lstCOM_ConfigRequisitosM = [SELECT COM_Label__c, COM_Nemotecnico__c, COM_NombreApi__c, COM_Objeto__c, 
                                            COM_IdRequisitoc__c, COM_NombreApiCuenta__c FROM COM_ConfiguracionRequisitos_ClienteSF__mdt];
            }else{//Requisitos para persona Natural sin Contacto 
                lstCOM_ConfigRequisitosM = [SELECT COM_Label__c, COM_Nemotecnico__c, COM_NombreApi__c, COM_Objeto__c, 
                                            COM_IdRequisitoc__c, COM_NombreApiCuenta__c FROM COM_ConfiguracionRequisitos_ClienteSF__mdt Where COM_Objeto__c != 'Contact'];
            }
            for(COM_ConfiguracionRequisitos_ClienteSF__mdt requisitoObj : lstCOM_ConfigRequisitosM) {
                /*Fin 00265100*/
                if(!mapReqPrograma.containsKey(requisitoObj.COM_Nemotecnico__c)){
                    mapReqPrograma.put(requisitoObj.COM_Nemotecnico__c, new List<COM_ConfiguracionRequisitos_ClienteSF__mdt>{requisitoObj});
                } else {
                    mapReqPrograma.get(requisitoObj.COM_Nemotecnico__c).add(requisitoObj);
                }
            }
            List<String> lstRequisitos = new List<String>();
            for(String nemotecnico : mapReqPrograma.keySet()){
                lstRequisitos.add(nemotecnico);
            }            
	        System.debug('accRepresentanteLegal YSN3: ' + accRepresentanteLegal);
            for(COM_WrapperCrearActualizarClienteSF_cls.Requisito req : cliente.requisitos.requisito){
                system.debug('requisito - >  '+req+'\n'+req.nemotecnico);
                system.debug('requisito num - >  '+ req.ValorNumerico);
                List<COM_ConfiguracionRequisitos_ClienteSF__mdt> lstDetalleRequisito = mapReqPrograma.get(req.nemotecnico);
                if(lstDetalleRequisito != null){
                    for(COM_ConfiguracionRequisitos_ClienteSF__mdt detalle : lstDetalleRequisito){
                        system.debug('detalle  '+detalle);
                        String[] lstNombreApi = detalle.COM_NombreApiCuenta__c.split('\\.');
                        List<sObject> obj;
        System.debug('accRepresentanteLegal YSN4: ' + accRepresentanteLegal);
                        if(detalle.COM_Nemotecnico__c == 'ULTSUB'){
                            try{
                                String[] lstUltSub = req.valorString.split('RT');
                                mapObjetos.get(detalle.COM_Objeto__c).put('COM_Periodoultimosubsidio__c', Date.newInstance(Integer.valueOf(lstUltSub[0].left(4)), Integer.valueOf(lstUltSub[0].substring(4,6)), 1));
                                mapObjetos.get(detalle.COM_Objeto__c).put('COM_Valorultimosubsidio__c',Double.valueOf(lstUltSub[1].replace('.','')));
                            } catch(Exception e){
                                system.debug('Error en el subsidio -> '+e.getMessage());
                            }
                        } else {
                            if(detalle.COM_Label__c == 'ValorAlfanumerico'){
                                if(lstNombreApi.size() == 1){
                                    mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, req.valorString));
                                } else if(lstNombreApi.size() == 2){ 
                                    mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], req.valorString));                                
                                } else if(lstNombreApi.size() > 3){ 
                                    String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                    String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+req.valorString+com+' LIMIT 1';
                                    obj = database.query(strQuery);
                                    if(obj != null && obj.size()==1)
                                        mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                                }
                            }
                            else if(detalle.COM_Label__c == 'ValorBooleano'){
                                if(lstNombreApi.size() == 1){
                                    mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, req.ValorBooleano));
                                } else if(lstNombreApi.size() == 2){ 
                                    mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], req.ValorBooleano));                                
                                } else if(lstNombreApi.size() > 3){                                
                                    String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                    String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+req.ValorBooleano+com+' LIMIT 1';
                                    obj = database.query(strQuery);
                                    if(obj != null && obj.size()==1)
                                        mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                                }
                            }
                            else if(detalle.COM_Label__c == 'ValorNumerico'){
					        System.debug('accRepresentanteLegal YSN5: ' + accRepresentanteLegal + ' : ' + lstNombreApi.size());
                                if(lstNombreApi.size() == 1){
                                    mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, req.ValorNumerico));
                                } else if(lstNombreApi.size() == 2){ 
                                    mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], req.ValorNumerico));                                
                                } else if(lstNombreApi.size() > 3){                                
                                    String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                    String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+req.ValorNumerico+com+' LIMIT 1';
                                    obj = database.query(strQuery);
                                    if(obj != null && obj.size()==1)
                                        mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                                }
                            }
                            else if(detalle.COM_Label__c == 'FechaInicio'){
                                if(lstNombreApi.size() == 1){
                                    mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, req.valorFechaInicio));
                                } else if(lstNombreApi.size() == 2){ 
                                    mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], req.valorFechaInicio));                                
                                } else if(lstNombreApi.size() > 3){                                
                                    String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                    String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+req.valorFechaInicio+com+' LIMIT 1';
                                    obj = database.query(strQuery);
                                    if(obj != null && obj.size()==1)
                                        mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                                }
                            }
                            else if(detalle.COM_Label__c == 'FechaFin'){
        System.debug('accRepresentanteLegal YSN6: ' + accRepresentanteLegal);
                                if(lstNombreApi.size() == 1){
                                    mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, req.valorFechaFin));
                                } else if(lstNombreApi.size() == 2){ 
                                    mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], req.valorFechaFin));                                
                                } else if(lstNombreApi.size() > 3){                                
                                    String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                    String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+req.valorFechaFin+com+' LIMIT 1';
                                    obj = database.query(strQuery);
                                    if(obj != null && obj.size()==1)
                                        mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                                }    
                            }
                        }
                    }
                }
            }
            system.debug('mapobjetos-----> '+mapObjetos);
        }
        
        WrapperResponseCliente wprResponse = new WrapperResponseCliente();
        wprResponse.fechaRespuesta = System.now();
        try {
            
            System.debug('--------->Fecha Nacimiento Contacto'+conRepresentanteLegal.COM_Fechanacimiento__c);
            //System.debug('--------->Segundo Tipo de Identificacion: '+accRepresentanteLegal.COM_TipoIdentificacion__c);
            //NOLA-2938
            //upsert accCliente;
            System.debug('accCliente==' + accCliente); 
            //AVX PB 11-21-19 : Se agrega a la lógica el Nautcli para que siempre el upsert se haga con base en ese valor
            Database.UpsertResult ur_accCliente = Database.upsert (accCliente,Account.COM_NAUTCLI__c,false);
            system.debug(':::: ID accCliente: ' + ur_accCliente.getId());
            //END
            if (accCliente.COM_TipoIdentificacion__c == '2') {
                if(accRepresentanteLegal.Name != null){
                    //NOLA-2938
                    System.debug('accRepresentanteLegal YSN7: ' + accRepresentanteLegal);
                    upsert accRepresentanteLegal COM_NAUTCLI__c;
                    conRepresentanteLegal.AccountId = accRepresentanteLegal.Id;
                    /*Database.UpsertResult ur_accRepresentanteLegal = Database.upsert (accRepresentanteLegal,false);
conRepresentanteLegal.AccountId = ur_accRepresentanteLegal.getId();*/
                    //END
                }
            } else {
                //NOLA-2938
                conRepresentanteLegal.AccountId = accCliente.Id;
                
                // conRepresentanteLegal.AccountId = ur_accCliente.getID();
                //END
            }
            //NOLA-2938
            //if(conRepresentanteLegal.Id != null){
            if(conRepresentanteLegal.AccountId != null){
                //END
                //upsert conRepresentanteLegal COM_ExternalId__c; /// mientras prueba CARLOS VILLALBA
            }
            
            if(acrOldRelacion != null){
                acrOldRelacion.Roles = 'Otros';
                System.debug('acrOldRelacion==' +acrOldRelacion);
                upsert acrOldRelacion;
            }
            
            /*/Inicio V2 

if(acrOldRelacion != null && acrRelacion != null){
acrOldRelacion.Roles = 'Otros';
upsert acrOldRelacion;  
}
//Fin v2 */
            if(acrRelacion != null) {
                if (accCliente.COM_TipoIdentificacion__c == '2') {
                    if(accRepresentanteLegal.Name != null){   
                        List<Contact> lstCon = [SELECT Id FROM Contact WHERE AccountId =:accRepresentanteLegal.Id AND
                                                COM_TipoIdentificacion__c =:accRepresentanteLegal.COM_TipoIdentificacion__c AND 
                                                COM_Numeroidentificacion__c =:accRepresentanteLegal.COM_Numero_de_identificacion__c
                                               ];  
                        if(lstCon.size() > 0){
                            if(acrRelacion != null && acrRelacion.Id == null){
                                //NOLA-2939
                                //acrRelacion.AccountId = accCliente.Id;
                                System.debug('ur_accCliente.getId(): ' + ur_accCliente.getId());
                                acrRelacion.AccountId = ur_accCliente.getId();
                                //END
                                acrRelacion.ContactId = lstCon.get(0).Id;
                                acrRelacion.Roles = 'Representante Legal';
                                upsert acrRelacion;
                            } Else If(acrRelacion != null && acrRelacion.Id != null){
                                acrRelacion.Roles = 'Representante Legal';
                                upsert acrRelacion;
                            }
                            
                        }
                    }
                }             
            }
            
            wprResponse.codigoRespuesta = 200;
            wprResponse.mensajeRespuesta = 'Transacción Exitosa';
            wprResponse.fechaRespuesta = System.Now();
            wprResponse.idcliente = accCliente.Id;
            return wprResponse;
        } catch (exception e) {
            wprResponse.codigoRespuesta = 400;
            wprResponse.mensajeRespuesta = 'Error creando los datos -> ' + e;
            wprResponse.fechaRespuesta = System.Now();
            return wprResponse;
        }
        return null;
    }
    
    public static Object castDato(String objeto, String campo, String valor){
        String tipoDato = String.valueOf(Schema.getGlobalDescribe().get(objeto).getDescribe().fields.getMap().get(campo).getDescribe().getSoapType());
        system.debug(objeto+'-'+campo+'-'+valor+'-'+tipoDato);
        if(tipoDato  == 'ID' || tipoDato  == 'String')
            return String.valueOf(valor);
        else if (tipoDato  == 'DateTime'){
            if (valor.length() == 8){
                return Datetime.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), Integer.valueOf(valor.substring(6,8)));
            }
            else if(valor.length() == 6){
                return Datetime.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), 1);
            }
            else if(valor.length() == 15){
                return Datetime.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), 1);   
            }
            else{
                if(Integer.valueOf(valor.left(4)) <= 1 )
                    return null;
                else
                    return Datetime.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(5,7)), Integer.valueOf(valor.substring(8,10)));
            }
        }       
        else if (tipoDato  == 'Date'){
            system.debug('fechaa '+valor.length());
            if (valor.length() == 8){
                system.debug(Integer.valueOf(valor.left(4))+'-'+Integer.valueOf(valor.substring(4,6))+'-'+Integer.valueOf(valor.substring(6,8)));
                return Date.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), Integer.valueOf(valor.substring(6,8)));
            }
            else if(valor.length() == 6){
                return Date.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), 1);
            }
            else if(valor.length() == 15){
                return Date.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), 1);   
            }
            else{
                if(Integer.valueOf(valor.left(4)) <= 1 )
                    return null;
                else
                    return Date.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(5,7)), Integer.valueOf(valor.substring(8,10)));
            }
        }
        else if (tipoDato  == 'Time'){
            return Time.newInstance(Integer.valueOf(valor.left(2)), Integer.valueOf(valor.substring(3,5)), Integer.valueOf(valor.substring(6,8)), 0);
        }
        else if (tipoDato  == 'Boolean'){
            return Boolean.valueOf(valor);
        }
        else if (tipoDato  == 'Double'){
            return Double.valueOf(valor);
        }
        else if (tipoDato  == 'Integer'){
            return Integer.valueOf(valor);
        }
        else{
            
            return valor;
        }
        
        return null;
    }
    
    //WRAPPER RESPONSE
    global class WrapperResponseCliente{
        public  Integer                             codigoRespuesta                 {get; set;}
        public  String                              mensajeRespuesta                {get; set;}
        public  Datetime                            fechaRespuesta                  {get; set;}
        public  String                              idcliente                       {get; set;}
    }
}