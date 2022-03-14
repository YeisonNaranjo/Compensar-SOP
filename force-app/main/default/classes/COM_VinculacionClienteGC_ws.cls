/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para constuir las transacciones para consumir los WS de Vinculación de Clientes en GC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    03/08/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   1.1    21/11/2017      Rubén Suárez Forero (RUSF)          Modificación Vinculación
* @version   1.2    16/08/2018      Stifen Panche Gutierrez (SPG)       Cambio fecha de ingreso con la fecha de cierre
* @version   2.0    06/01/2022      Yeison Naranjo (YSN)       			Inclusión nuevo campo GC NOLA 00030781
****************************************************************************************************************/
public class COM_VinculacionClienteGC_ws {
    
    
    public COM_VinculacionClienteGC_ws() {
    }
    
    public COM_WrapperVinculacionClienteRespons_cls.Body vincularCliente(Opportunity ObjOportunidad, Account objCuenta, Contact objRepresentanteLegal, Boolean blnVincular){
        COM_WrapperVinculacionClienteRequest_cls objWrapperVinculacionClienteRequest;
        COM_WrapperVinculacionClienteRespons_cls objWrapperVinculacionClienteResponse;
        
        objWrapperVinculacionClienteRequest = new COM_WrapperVinculacionClienteRequest_cls();
        objWrapperVinculacionClienteRequest.CustomerAdmin_ProcesarVinculacion_Request.Header = COM_UtilidadWebService_cls.obtenerCabecera(label.COM_Header_VincularClienteGC);
        system.debug(objWrapperVinculacionClienteRequest);
        mapearCamposVinculacion(objWrapperVinculacionClienteRequest, objCuenta, ObjOportunidad, objRepresentanteLegal, blnVincular);
        system.debug(objWrapperVinculacionClienteRequest);
        String strJSON = system.JSON.serializePretty(objWrapperVinculacionClienteRequest, true);
        
        system.debug('\n\n'+strJSON+'\n\n');
        
        try{ 
            objWrapperVinculacionClienteResponse = (COM_WrapperVinculacionClienteRespons_cls)COM_UtilidadWebService_cls.consumirWS(objWrapperVinculacionClienteRequest, label.COM_WS_VincularClienteGC, COM_WrapperVinculacionClienteRespons_cls.class, ObjOportunidad.Id);
            system.debug('-------------> ' + objWrapperVinculacionClienteResponse);
        } catch(COM_WebServiceException e){
            System.Debug('====================== COM_WebServiceException [VinculacionClienteGC] ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('============================================================================================');
            throw new COM_VinculacionClienteException(e.getMessage());
        } catch(Exception e){
            System.Debug('====================== Exception [VinculacionClienteGC] ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('==============================================================================');
            throw new COM_VinculacionClienteException(e.getMessage());
        }
        
        if(objWrapperVinculacionClienteResponse != null)
            return objWrapperVinculacionClienteResponse.CustomerAdmin_ProcesarVinculacion_Response.Body;
        else
            return null;
    }
    
    private void mapearCamposVinculacion(COM_WrapperVinculacionClienteRequest_cls objWrapperVinculacionClienteRequest, Account objCuenta, Opportunity ObjOportunidad, Contact objRepresentanteLegal, Boolean blnVincular){
        //COM_WrapperVinculacionClienteRequest_cls.CustomerAdminProcesarVinculacionRequest objProcesarVinculacionRequest;
        COM_WrapperVinculacionClienteRequest_cls.Body objBody;
        COM_WrapperVinculacionClienteRequest_cls.AtributosComunes objAtributosComunes;
        COM_WrapperVinculacionClienteRequest_cls.Cliente objCliente;
        COM_WrapperVinculacionClienteRequest_cls.DatosPersona objDatosPersona;
        COM_WrapperVinculacionClienteRequest_cls.DatosEmpresa objDatosEmpresa;
        COM_WrapperVinculacionClienteRequest_cls.Sucursales objSucursales; 
        list<COM_WrapperVinculacionClienteRequest_cls.Sucursal> lstSucursal; 
        COM_WrapperVinculacionClienteRequest_cls.Sucursal objSucursal; 
        COM_WrapperVinculacionClienteRequest_cls.ComunicacionesCliente objComunicacionesCliente;
        list<COM_WrapperVinculacionClienteRequest_cls.ComunicacionCliente> lstComunicacionCliente;
        COM_WrapperVinculacionClienteRequest_cls.ComunicacionCliente objComunicacionCliente;
        //COM_WrapperVinculacionClienteRequest_cls.Comunicacion objComunicacion;
        COM_WrapperVinculacionClienteRequest_cls.Contacto objContacto;
        COM_WrapperVinculacionClienteRequest_cls.Afiliaciones objAfiliaciones;
        list<COM_WrapperVinculacionClienteRequest_cls.Afiliacion> lstAfiliacion;
        COM_WrapperVinculacionClienteRequest_cls.Afiliacion objAfiliacion;
        COM_WrapperVinculacionClienteRequest_cls.Radicacion objRadicacion;
        COM_WrapperVinculacionClienteRequest_cls.Requisitos objRequisitos;
        list<COM_WrapperVinculacionClienteRequest_cls.Requisito> lstRequisito;
        COM_WrapperVinculacionClienteRequest_cls.Requisito objRequisito;
        COM_WrapperVinculacionClienteRequest_cls.Programas objProgramas;
        list<COM_WrapperVinculacionClienteRequest_cls.Programa> lstPrograma;
        COM_WrapperVinculacionClienteRequest_cls.Programa objPrograma;
        COM_WrapperVinculacionClienteRequest_cls.ClientesResponsables objClientesResponsables;
        list<COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable> lstClienteResponsable;
        COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable objClienteResponsable1;
        COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable objClienteResponsable2;
        COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable objClienteResponsable3;
        COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable objClienteResponsable4;
        COM_WrapperVinculacionClienteRequest_cls.MotivoRetiro objMotivoRetiro;
        COM_WrapperVinculacionClienteRequest_cls.MotivoInactivacion objMotivoInactivacion;
        COM_WrapperVinculacionClienteRequest_cls.MotivoRetiroOpcional objMotivoRetiroOpcional;
        COM_WrapperVinculacionClienteRequest_cls.AdicionalesContacto objAdicionalesContacto;
        COM_WrapperVinculacionClienteRequest_cls.Domicilios objDomicilios;
        list<COM_WrapperVinculacionClienteRequest_cls.DomicilioComunicacion> lstDomicilioComunicacion;
        COM_WrapperVinculacionClienteRequest_cls.DomicilioComunicacion objDomicilioComunicacion;
        COM_WrapperVinculacionClienteRequest_cls.Telefonos objTelefonos;
        list<COM_WrapperVinculacionClienteRequest_cls.TelefonoComunicacion> lstTelefonoComunicacion;
        COM_WrapperVinculacionClienteRequest_cls.TelefonoComunicacion objTelefonoComunicacion;
        COM_WrapperVinculacionClienteRequest_cls.Localidad objLocalidad;
        COM_WrapperVinculacionClienteRequest_cls.Municipio objMunicipio;
        COM_WrapperVinculacionClienteRequest_cls.Departamento objDepartamento;
        COM_WrapperVinculacionClienteRequest_cls.Familia objFamilia;
        COM_WrapperVinculacionClienteRequest_cls.Demografia objDemografia;
        
        objCliente = new COM_WrapperVinculacionClienteRequest_cls.Cliente();
        objCliente.TipoIdentificacion = Integer.valueOf(objCuenta.COM_TipoIdentificacion__c);
        objCliente.NumeroIdentificacion = objCuenta.COM_Numero_de_identificacion__c;
        // NO VA? objCliente.legalID = Integer.valueOf(objCuenta.COM_Numero_de_identificacion__c);
        objCliente.id = Decimal.valueOf(objCuenta.COM_NAUTCLI__c);
    
        //LA SUCURSAL HAY QUE REVISARLA
        /*
        if(objCuenta.RecordType.DeveloperName.equals('COM_Juridico')) {
            objSucursales = new COM_WrapperVinculacionClienteRequest_cls.Sucursales();
            lstSucursal = new list<COM_WrapperVinculacionClienteRequest_cls.Sucursal>();
            objSucursal = new COM_WrapperVinculacionClienteRequest_cls.Sucursal();
            objSucursal.id = objCuenta.COM_Sucursal__c.longValue();
            objSucursal.sucursalID = objCuenta.COM_Sucursal__c.longValue();
            objSucursal.centroCostosID = objCuenta.COM_CentroCosto__c.longValue();
            objSucursal.nivelAdicional = objCuenta.COM_Negociacionadicional__c;
            objSucursal.razonSocial = objCuenta.Name;
            objSucursal.mantenimiento = '';
            lstSucursal.add(objSucursal);
            System.debug('==='+objSucursal);
            System.debug('==='+lstSucursal);
            objSucursales.sucursal = lstSucursal;
            System.debug('==='+objSucursales.sucursal);
            objCliente.sucursales = objSucursales;
        }
        */
    
        objSucursales = new COM_WrapperVinculacionClienteRequest_cls.Sucursales();
        lstSucursal = new list<COM_WrapperVinculacionClienteRequest_cls.Sucursal>();
        objSucursal = new COM_WrapperVinculacionClienteRequest_cls.Sucursal();
        objSucursal.id = 0;
        objSucursal.sucursalID = 0;
        objSucursal.centroCostosID = 0;
        objSucursal.mantenimiento = '';
        if(lstSucursal.size() > 0)
            objCliente.sucursales = objSucursales;

        objTelefonos = new COM_WrapperVinculacionClienteRequest_cls.Telefonos();
        lstTelefonoComunicacion = new list<COM_WrapperVinculacionClienteRequest_cls.TelefonoComunicacion>();
        objTelefonoComunicacion = new COM_WrapperVinculacionClienteRequest_cls.TelefonoComunicacion();
        objTelefonoComunicacion.tipoTelefono = '1';
        try{
            objTelefonoComunicacion.telefono = long.valueOf(objCuenta.Phone);
        } catch (Exception e){
            system.debug('telefono '+e.getMessage());
        }
        try{
            objTelefonoComunicacion.extensionTelefono = long.valueOf(objCuenta.COM_Extension__c);
        } catch (Exception e){
            system.debug('extensionTelefono '+e.getMessage());
        }   
        lstTelefonoComunicacion.add(objTelefonoComunicacion);
        objTelefonos.telefonoComunicacion = lstTelefonoComunicacion;
        
        objDepartamento = new COM_WrapperVinculacionClienteRequest_cls.Departamento();

        try{
            objDepartamento.id = String.valueOf(objCuenta.COM_Ciudad__r.COM_Codigo__c).substring(0,2);
        } catch (Exception e){
            system.debug('departamento '+e.getMessage());
        }
    
        //objDepartamento.nombre = objCuenta.COM_Ciudad__r.COM_Departamento__c;
        objMunicipio = new COM_WrapperVinculacionClienteRequest_cls.Municipio();
        try{
            objMunicipio.id = Integer.valueOf(objCuenta.COM_Ciudad__r.COM_Codigo__c);
        } catch (Exception e){
            system.debug('departamento '+e.getMessage());
        }
        objMunicipio.nombre = objCuenta.COM_Ciudad__r.Name;
        objMunicipio.departamento = objDepartamento;
        
        objLocalidad = new COM_WrapperVinculacionClienteRequest_cls.Localidad();
        try{
            objLocalidad.id = Integer.valueOf(objCuenta.COM_Ciudad__r.COM_Codigo__c);
        } catch (Exception e){
            system.debug('departamento '+e.getMessage());
        }
        objLocalidad.municipio = objMunicipio;
        //objLocalidad.nombre = objCuenta.COM_Localidad__c;
        
        objDomicilios = new COM_WrapperVinculacionClienteRequest_cls.Domicilios();
        lstDomicilioComunicacion = new list<COM_WrapperVinculacionClienteRequest_cls.DomicilioComunicacion>();
        objDomicilioComunicacion = new COM_WrapperVinculacionClienteRequest_cls.DomicilioComunicacion();
        objDomicilioComunicacion.barrio = objCuenta.COM_Barrio__c;
        objDomicilioComunicacion.casillaCorreo = '';
        //objDomicilioComunicacion.tipoDomicilio = objCuenta.COM_Tipodireccion__c;
        objDomicilioComunicacion.domicilio = objCuenta.COM_Direccion__c;
        objDomicilioComunicacion.codigoPostal = '';
        objDomicilioComunicacion.localidad = objLocalidad;
        objDomicilioComunicacion.tipoAreaGeografica = objCuenta.COM_Tipodireccion__c;
        if(objDomicilioComunicacion.domicilio != null && objDomicilioComunicacion.localidad.id  != null && objDomicilioComunicacion.tipoAreaGeografica != null)
        lstDomicilioComunicacion.add(objDomicilioComunicacion);
        objDomicilios.domicilioComunicacion = lstDomicilioComunicacion;
        
        objAdicionalesContacto = new COM_WrapperVinculacionClienteRequest_cls.AdicionalesContacto();
        objAdicionalesContacto.borradoEstado = 'A';
        String strFecha = String.valueOf(system.now().year())+'-';
        strFecha += String.valueOf(system.now().month()).length()==1?'0'+String.valueOf(system.now().month()):String.valueOf(system.now().month());
        strFecha += '-'+(system.now().day()<10?('0'+String.valueOf(system.now().day())):(String.valueOf(system.now().day())))+'T00:00:00-05:00';
        objAdicionalesContacto.creacionFecha = strFecha;
        objAdicionalesContacto.ultimaNovedadFecha = strFecha;
        objAdicionalesContacto.identificador = objCuenta.COM_Numero_de_identificacion__c;
        objAdicionalesContacto.orden = 1;
        try{
            objAdicionalesContacto.zonaBogota = Integer.valueOf(objCuenta.COM_Localidad__c)==null?0:Integer.valueOf(objCuenta.COM_Localidad__c);
        } catch (exception e){
            system.debug(e.getMessage());
            objAdicionalesContacto.zonaBogota = 0;
        }    
        objComunicacionesCliente = new COM_WrapperVinculacionClienteRequest_cls.ComunicacionesCliente();
        lstComunicacionCliente = new list<COM_WrapperVinculacionClienteRequest_cls.ComunicacionCliente>();
        objComunicacionCliente = new COM_WrapperVinculacionClienteRequest_cls.ComunicacionCliente();
        objComunicacionCliente.telefonos = objTelefonos;
        objComunicacionCliente.domicilios = objDomicilios;
        objComunicacionCliente.adicionalesContacto = objAdicionalesContacto;

        COM_WrapperVinculacionClienteRequest_cls.correosElectronicos objCorreosElectronicos = new COM_WrapperVinculacionClienteRequest_cls.correosElectronicos();
        objCorreosElectronicos.correoElectronico = new List<String>();
        objCorreosElectronicos.correoElectronico.add(objCuenta.COM_CorreoElectronico__c);
        objComunicacionCliente.correosElectronicos = objCorreosElectronicos;

        
        COM_WrapperVinculacionClienteRequest_cls.redesSociales objRedesSociales = new COM_WrapperVinculacionClienteRequest_cls.redesSociales();
        objRedesSociales.redesSociales = new List<String>();
        if(objCuenta.COM_UsuarioFacebook__c != null){
            objRedesSociales.redesSociales.add(objCuenta.COM_UsuarioFacebook__c);
        } else if(objCuenta.COM_UsuarioTwitter__c != null){
            objRedesSociales.redesSociales.add(objCuenta.COM_UsuarioTwitter__c);
        }
        objComunicacionCliente.redesSociales = objRedesSociales;
        lstComunicacionCliente.add(objComunicacionCliente);
        objComunicacionesCliente.comunicacionCliente = lstComunicacionCliente;
        
        objCliente.comunicacionesCliente = objComunicacionesCliente;
        
        /*
        objContacto = new COM_WrapperVinculacionClienteRequest_cls.Contacto();
        objContacto.tipoContacto = '';
        objContacto.orden = 0;
        objCliente.Contacto = objContacto;
        */
        
        /*
        objMotivoRetiro = new COM_WrapperVinculacionClienteRequest_cls.MotivoRetiro();
        objMotivoRetiro.id = 0;
        objMotivoRetiro.nombre = '';
        */
        
        objClientesResponsables = new COM_WrapperVinculacionClienteRequest_cls.ClientesResponsables();
        lstClienteResponsable = new list<COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable>();
        
        objClienteResponsable1 = new COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable();
        objClienteResponsable1.tipoResponsable = '1';

        if(objCuenta.RecordType.DeveloperName.equals('COM_Juridico')) {
            objClienteResponsable1.id = '0';
            objClienteResponsable1.nombre = '';
            objClienteResponsable1.legalID = '0';
            objClienteResponsable1.tipoIdentificacion = '0';
        } else {
            objClienteResponsable1.id = objCuenta.COM_NAUTCLI__c;
            objClienteResponsable1.nombre = objCuenta.COM_Nombre_completo_del_cliente__c;
            objClienteResponsable1.legalID = objCuenta.COM_Numero_de_identificacion__c;
            objClienteResponsable1.tipoIdentificacion = objCuenta.COM_TipoIdentificacion__c;
        }   
        lstClienteResponsable.add(objClienteResponsable1);
        
        objClienteResponsable2 = new COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable();
        objClienteResponsable2.tipoResponsable = '2';
        try{
            if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Contratista')){
                objClienteResponsable2.legalID = ObjOportunidad.COM_EntidadContratista__r.COM_Numero_de_identificacion__c;
                objClienteResponsable2.tipoIdentificacion = ObjOportunidad.COM_EntidadContratista__r.COM_TipoIdentificacion__c;
                objClienteResponsable2.id = ObjOportunidad.COM_EntidadContratista__r.COM_NAUTCLI__c;
                objClienteResponsable2.nombre = ObjOportunidad.COM_EntidadContratista__r.Name;
            }else if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')){
                objClienteResponsable2.legalID = ObjOportunidad.COM_EntidadPensionadora1__r.COM_Numero_de_identificacion__c;
                objClienteResponsable2.tipoIdentificacion = ObjOportunidad.COM_EntidadPensionadora1__r.COM_TipoIdentificacion__c;
                objClienteResponsable2.id = ObjOportunidad.COM_EntidadPensionadora1__r.COM_NAUTCLI__c;
                objClienteResponsable2.nombre = ObjOportunidad.COM_EntidadPensionadora1__r.Name;
            }
        } catch(Exception e){
            system.debug('cliente responsable 2. '+e.getMessage());
            objClienteResponsable2.legalID = '0';
            objClienteResponsable2.tipoIdentificacion = '';
            objClienteResponsable2.id = '0';
            objClienteResponsable2.nombre = '0';
        }       
        lstClienteResponsable.add(objClienteResponsable2);

        objClienteResponsable3 = new COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable();
        objClienteResponsable3.tipoResponsable = '3';
        try{
            if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Contratista') && ObjOportunidad.COM_SucursalContratista__c != null){
                objClienteResponsable3.legalID = ObjOportunidad.COM_SucursalContratista__r.COM_Numero_de_identificacion__c;
                objClienteResponsable3.tipoIdentificacion = ObjOportunidad.COM_SucursalContratista__r.COM_TipoIdentificacion__c;
                objClienteResponsable3.id = ObjOportunidad.COM_SucursalContratista__r.COM_NAUTCLI__c;
                objClienteResponsable3.nombre = ObjOportunidad.COM_SucursalContratista__r.Name;
            }else if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Pensionado') && ObjOportunidad.COM_SucursalPension__c != null){
                objClienteResponsable3.legalID = ObjOportunidad.COM_SucursalPension__r.COM_Numero_de_identificacion__c;
                objClienteResponsable3.tipoIdentificacion = ObjOportunidad.COM_SucursalPension__r.COM_TipoIdentificacion__c;
                objClienteResponsable3.id = ObjOportunidad.COM_SucursalPension__r.COM_NAUTCLI__c;
                objClienteResponsable3.nombre = ObjOportunidad.COM_SucursalPension__r.Name;
            }
        } catch(Exception e){
            system.debug('cliente responsable 3. '+e.getMessage());
            objClienteResponsable3.legalID = '0';
            objClienteResponsable3.tipoIdentificacion = '';
            objClienteResponsable3.id = '0';
            objClienteResponsable3.nombre = '0';         
        }
        lstClienteResponsable.add(objClienteResponsable3);

        objClienteResponsable4 = new COM_WrapperVinculacionClienteRequest_cls.ClienteResponsable();
        objClienteResponsable4.tipoResponsable = '4';
        try{
            if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Contratista') && ObjOportunidad.COM_CentrodeCostoEntidadqueContrata__c != null){
                objClienteResponsable4.legalID = ObjOportunidad.COM_CentrodeCostoEntidadqueContrata__r.COM_Numero_de_identificacion__c;
                objClienteResponsable4.tipoIdentificacion = ObjOportunidad.COM_CentrodeCostoEntidadqueContrata__r.COM_TipoIdentificacion__c;
                objClienteResponsable4.id = ObjOportunidad.COM_CentrodeCostoEntidadqueContrata__r.COM_NAUTCLI__c;
                objClienteResponsable4.nombre = ObjOportunidad.COM_CentrodeCostoEntidadqueContrata__r.Name;
            }else if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Pensionado') && ObjOportunidad.COM_CentroDeCostoPension__c != null){
                objClienteResponsable4.legalID = ObjOportunidad.COM_CentroDeCostoPension__r.COM_Numero_de_identificacion__c;
                objClienteResponsable4.tipoIdentificacion = ObjOportunidad.COM_CentroDeCostoPension__r.COM_TipoIdentificacion__c;
                objClienteResponsable4.id = ObjOportunidad.COM_CentroDeCostoPension__r.COM_NAUTCLI__c;
                objClienteResponsable4.nombre = ObjOportunidad.COM_CentroDeCostoPension__r.Name;
            }
        } catch(Exception e){
            system.debug('cliente responsable 4. '+e.getMessage());
            objClienteResponsable4.legalID = '0';
            objClienteResponsable4.tipoIdentificacion = '';
            objClienteResponsable4.id = '0';
            objClienteResponsable4.nombre = '0';         
        }
        lstClienteResponsable.add(objClienteResponsable4);

        objClientesResponsables.clienteResponsable = lstClienteResponsable;
        
        /*objMotivoRetiroOpcional = new COM_WrapperVinculacionClienteRequest_cls.MotivoRetiroOpcional();
        objMotivoRetiroOpcional.id = 0;
        objMotivoRetiroOpcional.nombre = '';*/
        
        /*objMotivoInactivacion = new COM_WrapperVinculacionClienteRequest_cls.MotivoInactivacion();
        objMotivoInactivacion.id = 0;*/


        //RUBEN - AÑADIR REQUISITOS INI
        objRequisitos = new COM_WrapperVinculacionClienteRequest_cls.Requisitos();
        lstRequisito = new List<COM_WrapperVinculacionClienteRequest_cls.Requisito>();
        Map<String, sObject> mapObjetos = new Map<String, sObject>();
        mapObjetos.put('Account', objCuenta);
        mapObjetos.put('Opportunity', ObjOportunidad);
        mapObjetos.put('Contact', objRepresentanteLegal);
        system.debug('mapa de objetos \n'+mapObjetos);
        Map<String, COM_ConfiguracionProgramaReqM__mdt> lstReqPrograma = new Map<String, COM_ConfiguracionProgramaReqM__mdt>();
        list<COM_ConfiguracionProgramaReqM__mdt> lstConfiguracionPrograma = [SELECT COM_IdRequisito__c, COM_Nemotecnico_del__c 
                                                        FROM COM_ConfiguracionProgramaReqM__mdt 
                                                        WHERE COM_IdPrograma__c = :ObjOportunidad.COM_ProgramaVinculacion1__r.COM_Codigo__c ];
        system.debug('--->>> lstConfiguracionPrograma: ' + lstConfiguracionPrograma);
        
        for(COM_ConfiguracionProgramaReqM__mdt programaObj : lstConfiguracionPrograma){
            lstReqPrograma.put(programaObj.COM_Nemotecnico_del__c, programaObj);
        }

        Map<String, List<COM_ConfiguracionRequisitosM__mdt>> mapReqPrograma = new Map<String, List<COM_ConfiguracionRequisitosM__mdt>>();
        for(COM_ConfiguracionRequisitosM__mdt requisitoObj : [SELECT COM_Label__c, COM_Nemotecnico__c, COM_NombreApi__c, COM_Objeto__c 
                                                            FROM COM_ConfiguracionRequisitosM__mdt 
                                                            WHERE COM_Nemotecnico__c IN :lstReqPrograma.keySet()]) {
            if(!mapReqPrograma.containsKey(requisitoObj.COM_Nemotecnico__c)){
                mapReqPrograma.put(requisitoObj.COM_Nemotecnico__c, new List<COM_ConfiguracionRequisitosM__mdt>{requisitoObj});
            } else {
                mapReqPrograma.get(requisitoObj.COM_Nemotecnico__c).add(requisitoObj);
            }
        }
        
        system.debug('--->>> mapReqPrograma: ' + mapReqPrograma);

        for(String strRequisito :mapReqPrograma.keySet()) {
            COM_WrapperVinculacionClienteRequest_cls.Requisito objWprRequisito;
            objWprRequisito = new COM_WrapperVinculacionClienteRequest_cls.Requisito();
            objWprRequisito.idRequisito = Integer.valueOf(lstReqPrograma.get(strRequisito).COM_IdRequisito__c);
            objWprRequisito.sigla = strRequisito;
            List<COM_ConfiguracionRequisitosM__mdt> lstObjRequisito = mapReqPrograma.get(strRequisito);
            system.debug('====='+lstObjRequisito);
            for(COM_ConfiguracionRequisitosM__mdt requisito : lstObjRequisito) {
                if(strRequisito == 'ULTSUB'){
                    continue;
                }
                String[] lstNombreApi = requisito.COM_NombreApi__c.split('\\.');
                sObject  obj;
                try{
                    if(requisito.COM_Label__c == 'ValorAlfanumerico'){
                        if(lstNombreApi.size() == 1){
                            objWprRequisito.campoAlfa = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                        } else if(lstNombreApi.size() > 1){ 
                            objWprRequisito.campoAlfa = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1])); 
                        }
                    } else if(requisito.COM_Label__c == 'ValorBooleano'){
                        if(lstNombreApi.size() == 1){
                            objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                        } else if(lstNombreApi.size() > 1){ 
                            objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                            
                        }
                    } else if(requisito.COM_Label__c == 'ValorNumerico'){
                        if(strRequisito == 'REPLEG'){
                            objWprRequisito.campoNumerico = '5'; //5 es el código de representante legal
                        }else if(lstNombreApi.size() == 1){
                            objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                        } else if(lstNombreApi.size() > 1){ 
                                objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));   
                        }
                    }
                }catch(exception e){
                    system.debug('error mapeando requisito. '+e.getmessage());
                } 
            }
            if(!(objWprRequisito.campoAlfa == null && objWprRequisito.campoBooleano == null && objWprRequisito.campoNumerico == null)){
                if(objWprRequisito.campoAlfa == null)
                    objWprRequisito.campoAlfa = '';
                if(objWprRequisito.campoBooleano == null)
                    objWprRequisito.campoBooleano = 'false';
                if(objWprRequisito.campoNumerico == null)
                    objWprRequisito.campoNumerico = '0';
                System.debug('campos requisito '+objWprRequisito.campoAlfa+'---'+objWprRequisito.campoBooleano+'---'+objWprRequisito.campoNumerico);
                objWprRequisito.campoFecha1 = '0001-01-01T00:00:00';
                objWprRequisito.campoFecha2 = '0001-01-01T00:00:00';
                String decCampoFecha = String.valueOf(system.now().year());
                decCampoFecha += String.valueOf(system.now().month()).length()==1?'0'+String.valueOf(system.now().month()):String.valueOf(system.now().month());
                decCampoFecha += (system.now().day()<10?('0'+String.valueOf(system.now().day())):(String.valueOf(system.now().day())));
                objWprRequisito.decCampoFecha1 = decCampoFecha;
                objWprRequisito.decCampoFecha2 = decCampoFecha;
                objWprRequisito.estadoDato = 4; //4 porque es creación
                objWprRequisito.grupoDato = 0;
                objWprRequisito.guardarTramite = false;
                objWprRequisito.idCampoNumerico = 0;
                objWprRequisito.numeroRadicado = 0;
                objWprRequisito.subGrupoDato = 0;
                if(strRequisito == 'CORELE' &&  objWprRequisito.campoAlfa == ''){
                    continue; //no se envía corele si está vacío
                } else if (strRequisito == 'TELCEL' && objWprRequisito.campoNumerico == '0'){
                    objWprRequisito.tipoAccion = 2; //TELCEL SE PUEDEN ENVIAR CON UN DATOS DISTINTO PARA QUE DEJE VINCULAR
                } else{
                    objWprRequisito.tipoAccion = 1;
                }
                lstRequisito.add(objWprRequisito);
            }

        }
        
        objRequisitos.requisito = lstRequisito;     
        //RUBEN - AÑADIR REQUISITOS FIN
        
        objProgramas = new COM_WrapperVinculacionClienteRequest_cls.Programas();
        lstPrograma = new list<COM_WrapperVinculacionClienteRequest_cls.Programa>();
        objPrograma = new COM_WrapperVinculacionClienteRequest_cls.Programa();
        objPrograma.id = long.valueOf(ObjOportunidad.COM_ProgramaVinculacion1__r.COM_Codigo__c);
        try{
            objPrograma.programaPadre = long.valueOf(ObjOportunidad.COM_ProgramaVinculacion1__r.COM_ProgramaPadre__c);
        } catch(exception e){
            System.debug('Error en el programa padre '+e.getMessage());
            objPrograma.programaPadre = 0;
        }
        objPrograma.creacionFecha = Date.newinstance(ObjOportunidad.CreatedDate.year(), ObjOportunidad.CreatedDate.month(), ObjOportunidad.CreatedDate.day());
        //objPrograma.nombrePrograma = ObjOportunidad.COM_ProgramaVinculacion1__r.Name;
        list<COM_ConfiguracionProgramasM__mdt> lstConfPrograma = [SELECT Condicion__c FROM COM_ConfiguracionProgramasM__mdt 
            WHERE COM_IdPrograma__c = :ObjOportunidad.COM_ProgramaVinculacion1__r.COM_Codigo__c ];
        if(lstConfPrograma.size() == 1)
            objPrograma.condicion = Integer.valueOf(lstConfPrograma.get(0).Condicion__c);
            
        if(objCuenta.RecordType.DeveloperName.equals('COM_Juridico') || ObjOportunidad.COM_ProgramaVinculacion1__r.COM_Codigo__c == '1011') {
            objPrograma.diasPaHisto = 0;
            //objPrograma.diasPaReAuto = 0;
            objPrograma.tipoRadicacion = 0;
            objPrograma.edadReAuto = 0;
            objPrograma.genNuevoRadicadoEstado = false;
            objPrograma.grupo = 0;
            objPrograma.indicadorProgramaEstado = 0;
            objPrograma.indicadorVinculacionEstado = 0;
            objPrograma.manejaResponsable1PersonaEstado = false;
            objPrograma.manejaResponsable2EmpresaEstado = false;
            //objPrograma.motivoRetiroOpcional = objMotivoRetiroOpcional;
            //objPrograma.nivelAnterior = 0;
            objPrograma.clientePropietarioID = 0;
            objPrograma.tipoParentesco = '';
            objPrograma.tipoIdClientePropietario = '0';
            objPrograma.sigla = 'CJ';
            
            //objPrograma.nombreProgramaPadre = '';
            objPrograma.diasParaReactivacion = 0;
            if(objCuenta.RecordType.DeveloperName.equals('COM_Natural'))
                objPrograma.esPersona = true;
        }
        objPrograma.requisitos = objRequisitos;
        /*objPrograma.motivoInactivacion = objMotivoInactivacion;
        objPrograma.estadoAfiliacion = '';
        objPrograma.clienteID = 0;*/
        lstPrograma.add(objPrograma);
        objProgramas.programa = lstPrograma;
        
        objAfiliaciones = new COM_WrapperVinculacionClienteRequest_cls.Afiliaciones();
        lstAfiliacion = new list<COM_WrapperVinculacionClienteRequest_cls.Afiliacion>();
        objAfiliacion = new COM_WrapperVinculacionClienteRequest_cls.Afiliacion();
        
        objAfiliacion.nuevoEstado = true;
        objAfiliacion.cmnt = 'A';
        objAfiliacion.modificacionFecha = ObjOportunidad.LastModifiedDate;
        objAfiliacion.categoriaAfiliacion = 'K';
        objAfiliacion.cantidadVinculacion = 1;
        objAfiliacion.actualizadoEstado = false;
        //objAfiliacion.inicioFecha = ObjOportunidad.COM_Vinculadodesde__c;
        //objAfiliacion.registroFecha = ObjOportunidad.COM_FechaRegistrado__c;
       // objAfiliacion.inicioFecha = Date.newinstance(ObjOportunidad.CreatedDate.year(), ObjOportunidad.CreatedDate.month(), ObjOportunidad.CreatedDate.day());
        objAfiliacion.inicioFecha = Date.newinstance(ObjOportunidad.CloseDate.year(), ObjOportunidad.CloseDate.month(), ObjOportunidad.CloseDate.day());
        objAfiliacion.registroFecha = Date.newinstance(ObjOportunidad.CreatedDate.year(), ObjOportunidad.CreatedDate.month(), ObjOportunidad.CreatedDate.day());
        /*Inicio 1.2*/
        //objAfiliacion.ingresoEmpresaFecha = Date.newinstance(ObjOportunidad.CreatedDate.year(), ObjOportunidad.CreatedDate.month(), ObjOportunidad.CreatedDate.day());
        objAfiliacion.ingresoEmpresaFecha = Date.newinstance(ObjOportunidad.CloseDate.year(), ObjOportunidad.CloseDate.month(), ObjOportunidad.CloseDate.day());
        /*Fin 1.2*/
        if(objCuenta.RecordType.DeveloperName.equals('COM_Juridico') || ObjOportunidad.COM_ProgramaVinculacion1__r.COM_Codigo__c == '1011') {
            /*objAfiliacion.beneficiarios = '';*/   
            //objAfiliacion.finFecha = system.now();
            //objAfiliacion.ingresoEmpresaFecha = ObjOportunidad.COM_FechaIngresoEmpresa__c;
            /*Inicio 1.2*/
            //objAfiliacion.ingresoEmpresaFecha = Date.newinstance(ObjOportunidad.CreatedDate.year(), ObjOportunidad.CreatedDate.month(), ObjOportunidad.CreatedDate.day());
            objAfiliacion.ingresoEmpresaFecha = Date.newinstance(ObjOportunidad.CloseDate.year(), ObjOportunidad.CloseDate.month(), ObjOportunidad.CloseDate.day());
            /*Fin 1.1*/
            objAfiliacion.clienteID = String.valueOf(objCuenta.COM_NAUTCLI__c);
            /*objAfiliacion.retiroFecha = system.now();
            objAfiliacion.soloServicio = 0;
            objAfiliacion.textoVinculacion = '';
            objAfiliacion.variableRetiro = '';*/
        } else {            
            objAfiliacion.estado = 0;
        }
        if(ObjOportunidad.RecordType.DeveloperName.equals('COM_VEmpresas')) {
            objAfiliacion.valorVinculacion = 0;
        } else if(ObjOportunidad.RecordType.DeveloperName.equals('COM_VIndependientes')){
            objAfiliacion.valorVinculacion = Integer.valueOf(ObjOportunidad.COM_SalarioBase__c);
        }else if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Contratista')){
            objAfiliacion.valorVinculacion = Integer.valueOf(ObjOportunidad.COM_BaseAporteContratista__c);
        }else if(ObjOportunidad.RecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')){
            objAfiliacion.valorVinculacion = Integer.valueOf(ObjOportunidad.COM_ValorPension__c);
        }else {
            objAfiliacion.valorVinculacion = 0; 
        }
        
        objAfiliacion.motivoRetiro = objMotivoRetiro;
        objAfiliacion.clientesResponsables = objClientesResponsables;
            
        objAfiliacion.programas = objProgramas;
        
        lstAfiliacion.add(objAfiliacion);
        objAfiliaciones.afiliacion = lstAfiliacion;
        
        objCliente.Afiliaciones = objAfiliaciones;
        
        objCliente.Programa = objPrograma;
        
        /*
        objMotivoInactivacion = new COM_WrapperVinculacionClienteRequest_cls.MotivoInactivacion();
        objMotivoInactivacion.id = 0;
        */
    
        if(objCuenta.RecordType.DeveloperName.equals('COM_Natural')) { 
            /*objFamilia = new COM_WrapperVinculacionClienteRequest_cls.Familia();
            objFamilia.tipoParentesco = '';
            objFamilia.familiar = '';*/
            
            objDemografia = new COM_WrapperVinculacionClienteRequest_cls.Demografia();
            try{
                objDemografia.nacimientoFecha = String.valueOf(objCuenta.COM_FechaNacimiento__c)+'T00:00:00';
            } catch (exception e) {
                System.debug(e.getMessage());
            }
            /*objDemografia.nacimientoLugar = '';*/
            objDemografia.genero = objCuenta.COM_Genero__c;
            objDemografia.estadoCivil = objCuenta.COM_Estado_civil__c;
            /*objDemografia.cabezaFamiliaEstado = false;
            objDemografia.gradoEscolaridad = '';
            objDemografia.titulosObtenidos = '';*/
            //objDemografia.oficiosProfesiones = objCuenta.COM_Profesion__c;
            /*objDemografia.otrosEstudios = '';
            objDemografia.hijosEstado = false;*/
            objDemografia.hijosCantidad = Integer.ValueOf(ObjOportunidad.COM_TotalHijosDerechoSubsidio__c);
            /*objDemografia.personasACargoCantidad = 0;
            objDemografia.discapacidadEstado = false;*/
            
            objDatosPersona = new COM_WrapperVinculacionClienteRequest_cls.DatosPersona();
            objDatosPersona.nombrePrimero = objCuenta.COM_Primernombre__c;
            objDatosPersona.nombreSegundo = objCuenta.COM_Otrosnombres__c;
            objDatosPersona.apellidoPrimero = objCuenta.COM_Primerapellido__c;
            objDatosPersona.apellidoSegundo = objCuenta.COM_Segundoapellido__c;
            objDatosPersona.nombre = objCuenta.COM_Nombre_completo_del_cliente__c;
            /*objDatosPersona.foneticoID = '';
            objDatosPersona.nuip = '';
            objDatosPersona.familia = objFamilia;*/
            objDatosPersona.demografia = objDemografia;
            try{
                objDatosPersona.tipoVinculacion = long.valueOf(ObjOportunidad.COM_Opcionvinculacion__c);
            } catch (exception e) {
                System.debug(e.getMessage());
            }
            objDatosPersona.categoriaAfiliacion = objCuenta.COM_Categoria__c;
            //objDatosPersona.estadoAfiliacion = objCuenta.COM_Estadoafiliacion__c;
            /*objDatosPersona.motivoInactivacion = objMotivoInactivacion;*/
            
            if(objCuenta.RecordType.DeveloperName.equals('COM_Natural') && ObjOportunidad.COM_ProgramaVinculacion1__r.COM_Codigo__c != '1011') {
                objCliente.datosPersona = objDatosPersona;
            }
            
        } else if(objCuenta.RecordType.DeveloperName.equals('COM_Juridico')) {
            objDatosEmpresa = new COM_WrapperVinculacionClienteRequest_cls.DatosEmpresa();
            objDatosEmpresa.digitoVerificadorLegal = Integer.valueOf(objCuenta.COM_Digitoverificacion__c);
            objDatosEmpresa.razonSocial = objCuenta.Name;
            try{
                objDatosEmpresa.tipoEmpresa = Integer.valueOf(objCuenta.Type);
            } catch(Exception e){
                System.debug('Error en el tipo de empresa. '+e.getMessage());
            }
            objDatosEmpresa.nombreComercial = objCuenta.COM_NombreComercial__c;
            objDatosEmpresa.constitucionFecha = objCuenta.COM_Fechaconstitucion__c;
            objDatosEmpresa.tipoActividadEconomica = objCuenta.COM_ActividadEconomicaCIIU__r.COM_Codigo__c;
            //objDatosEmpresa.sectorEconomico = Integer.valueOf(objCuenta.COM_SectorEconomico__c);
            if(objCuenta.Parent != null){
                objDatosEmpresa.grupoEmpresarial = objCuenta.Parent.Name;
            }
            /*objDatosEmpresa.agremiacion = ''; 
            objDatosEmpresa.estadoAfiliacion = objCuenta.COM_Estadoafiliacion__c; 
            objDatosEmpresa.motivoInactivacion = objMotivoInactivacion; */
            
            /* Inicio 2.0 */
            If(objCuenta.COM_ResponsabilidadesFiscales__c != Null){
                objDatosEmpresa.Responsabilidades_Fiscales = Integer.valueOf(objCuenta.COM_ResponsabilidadesFiscales__c);
            }
            /* Fin 2.0 */
            
            objCliente.datosEmpresa = objDatosEmpresa;
        }
        
        objAtributosComunes = new COM_WrapperVinculacionClienteRequest_cls.AtributosComunes();
        objAtributosComunes.comunEntrePE = '';
        objAtributosComunes.fidelizacionFecha = system.now();
        objAtributosComunes.ubicaciones = '';
        objAtributosComunes.beneficiarioEstado = false;
        objAtributosComunes.empresaEstado = false;
        objAtributosComunes.saltarFoneticoEstado = false;
        objAtributosComunes.indice = 0;

        
        
        objBody = new COM_WrapperVinculacionClienteRequest_cls.Body();
        objBody.Cliente = objCliente;
        objBody.atributosComunes = objAtributosComunes;
        /* INICIO MODIFICACIÓN RUSF 1.1 */
        objBody.flagVinculacion = blnVincular?1:0;
        /* FIN MODIFICACIÓN RUSF 1.1 */
        
        /*objProcesarVinculacionRequest = new COM_WrapperVinculacionClienteRequest_cls.CustomerAdminProcesarVinculacionRequest();
        objProcesarVinculacionRequest.Body = objBody;
        objWrapperVinculacionClienteRequest.CustomerAdmin_ProcesarVinculacion_Request = objProcesarVinculacionRequest;*/

        objWrapperVinculacionClienteRequest.CustomerAdmin_ProcesarVinculacion_Request.Body = objBody;
    }
    
    public static Object castDato(String objeto, String campo, String valor){
        String tipoDato = String.valueOf(Schema.getGlobalDescribe().get(objeto).getDescribe().fields.getMap().get(campo).getDescribe().getSoapType());
        system.debug('tipoDato  '+tipoDato);
        if(tipoDato  == 'ID' || tipoDato  == 'String')
            return String.valueOf(valor);
        else if (tipoDato  == 'DateTime')
            return Datetime.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), Integer.valueOf(valor.substring(6,8)));
        else if (tipoDato  == 'Date')
            return Date.newInstance(Integer.valueOf(valor.left(4)), Integer.valueOf(valor.substring(4,6)), Integer.valueOf(valor.substring(6,8)));
        else if (tipoDato  == 'Time')
            return Time.newInstance(Integer.valueOf(valor.left(2)), Integer.valueOf(valor.substring(3,5)), Integer.valueOf(valor.substring(6,8)), 0);
        else if (tipoDato  == 'Boolean')
            return Boolean.valueOf(valor);
        else if (tipoDato  == 'Double')
            return Double.valueOf(valor);
        else if (tipoDato  == 'Integer')
            return Integer.valueOf(valor);
        else
            return valor;
        return null;
    }


}