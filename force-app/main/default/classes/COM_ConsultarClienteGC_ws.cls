/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para consultar clientes en GC 
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     28/07/2017      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public class COM_ConsultarClienteGC_ws {

    public WrapperClienteResponse wprCliente {get;set;}

    public COM_ConsultarClienteGC_ws() {
        wprCliente = new WrapperClienteResponse();
    }

    public COM_WrapperConsultaClienteGCResponse_cls.Body Consultar(Integer tipoIdentificacion, Long numeroIdentificacion){
        COM_WrapperConsultaClienteGCRequest_cls wrpRequest          = new COM_WrapperConsultaClienteGCRequest_cls();
        COM_WrapperConsultaClienteGCResponse_cls wrpResponse;
        COM_WrapperConsultaClienteGCRequest_cls.customerMng_ConsultaCliente_Request reqContenido = new COM_WrapperConsultaClienteGCRequest_cls.customerMng_ConsultaCliente_Request();
        reqContenido.Header                                         = COM_UtilidadWebService_cls.obtenerCabecera(Label.COM_WS_ConsultarClienteGC);
        COM_WrapperConsultaClienteGCRequest_cls.Body reqBody        = new COM_WrapperConsultaClienteGCRequest_cls.Body();
        COM_WrapperConsultaClienteGCRequest_cls.cliente reqCliente  = new COM_WrapperConsultaClienteGCRequest_cls.Cliente();
        reqCliente.tipoIdentificacion                               = tipoIdentificacion;
        reqCliente.numeroIdentificacion                             = numeroIdentificacion;
        reqCliente.id                                               = 0;
        reqCliente.opcionConsulta                                   = 3;
        reqBody.cliente                                             = reqCliente;
        reqContenido.Body                                           = reqBody;
        wrpRequest.customerMng_ConsultaCliente_Request              = reqContenido;
        try{ 
            wrpResponse = (COM_WrapperConsultaClienteGCResponse_cls)COM_UtilidadWebService_cls.consumirWS(wrpRequest, Label.COM_WS_ConsultarClienteGC, COM_WrapperConsultaClienteGCResponse_cls.class, null);
            system.debug('>>>>'+wrpresponse);
        } catch(Exception e){
            System.debug('Error consultado los datos ->' + e.getMessage());
        }
        if(wrpResponse != null){
            return wrpResponse.CustomerMng_ConsultaCliente_Response.Body;
        } else {
            return null;
        }
    }

    public WrapperClienteResponse mapCamposCuenta(COM_WrapperConsultaClienteGCResponse_cls.Body wrpCuenta){
        if(wrpCuenta.cliente.tipoIdentificacion != '-1' && wrpCuenta.cliente.numeroIdentificacion != '-1') {
            Account accCliente                                          = new Account();
            Account accRepresentanteLegal                               = new Account();
            List<Account> lstSucursales                                 = new List<Account>();
            string foneticoID;
            accCliente.COM_TipoIdentificacion__c                        = wrpCuenta.cliente.tipoIdentificacion;
            accCliente.COM_Numero_de_identificacion__c                  = wrpCuenta.cliente.numeroIdentificacion;
            accCliente.COM_NAUTCLI__c                                   = wrpCuenta.cliente.id;
            try{
                if(wrpCuenta.cliente.Afiliacion.afiliacion.size() > 0){
                    Integer estAfiliado = 0;
                    for(COM_WrapperConsultaClienteGCResponse_cls.afiliacion4 afi : wrpCuenta.cliente.Afiliacion.afiliacion){
                        if(afi.estadoAfiliacion == '0')
                            estAfiliado += 1;
                        system.debug('estado de afilicación - '+estAfiliado+' - '+afi.estadoAfiliacion);
                    }
                    system.debug('estado de afilicación - '+estAfiliado);
                    accCliente.COM_Estadoafiliacion__c = estAfiliado>0?'0':'1';
                }
                accCliente.COM_Estadoafiliacion__c                  = wrpCuenta.cliente.Afiliacion.afiliacion[wrpCuenta.cliente.Afiliacion.afiliacion.size()-1].estadoAfiliacion;
            } catch(Exception e){
                //accCliente.COM_Estadoafiliacion__c                  = '1';
                System.debug('Estado de afiliación inválido. '+e.getMessage());
            }
             try{
                accCliente.COM_Categoria__c                         = wrpCuenta.cliente.Afiliacion.afiliacion[wrpCuenta.cliente.Afiliacion.afiliacion.size()-1].categoriaAfiliacion;

            } catch(Exception e){
                //accCliente.COM_Estadoafiliacion__c                  = '1';
                System.debug('Estado de afiliación inválido. '+e.getMessage());
            }
            try{
                accCliente.COM_CausalRetiro__c  = wrpCuenta.cliente.Afiliacion.afiliacion[wrpCuenta.cliente.Afiliacion.afiliacion.size()-1].Programa.Programa[0].motivoRetiroOpcional.nombre;
                accCliente.COM_FechaRetiro__c         = Date.valueOf(wrpCuenta.cliente.Afiliacion.afiliacion[wrpCuenta.cliente.Afiliacion.afiliacion.size()-1].retiroFecha);
                
            } catch(Exception e){
                System.debug('Datos de retiro inválidos. '+e.getMessage());
            }
            Map<String,RecordType> tiposRegistro = new Map<String,RecordType>();
            List<RecordType> lstTR = [SELECT Id, DeveloperName From RecordType WHERE SobjectType = 'Account'];
            for(RecordType tr : lstTR){
                tiposRegistro.put(tr.DeveloperName, tr);
            }
            if (wrpCuenta.cliente.tipoIdentificacion == '2') {
                //DATOS EMPRESA
                accCliente.RecordTypeId                                 = tiposRegistro.get('COM_Juridico').Id;
                accCliente.COM_Digitoverificacion__c                    = Decimal.valueOf(wrpCuenta.cliente.DatosEmpresa.digitoVerificadorLegal);
                accCliente.Name                                         = wrpCuenta.cliente.DatosEmpresa.razonSocial;
                accCliente.COM_NombreComercial__c                       = wrpCuenta.cliente.DatosEmpresa.nombreComercial;
                accCliente.COM_Sucursal__c = 0;
                accCliente.COM_CentroCosto__c = 0;
                //DATOS REPRESENTANTE LEGAL
                if (wrpCuenta.cliente.DatosRepresentanteLegal.numeroIdentificacion != '-1') {
                    accRepresentanteLegal.RecordTypeId                  = tiposRegistro.get('COM_Natural').Id;
                    accRepresentanteLegal.COM_TipoIdentificacion__c     = wrpCuenta.cliente.DatosRepresentanteLegal.tipoIdentificacion;
                    accRepresentanteLegal.COM_Numero_de_identificacion__c = wrpCuenta.cliente.DatosRepresentanteLegal.numeroIdentificacion;
                    accRepresentanteLegal.COM_NAUTCLI__c                = wrpCuenta.cliente.DatosRepresentanteLegal.id;
                    accRepresentanteLegal.Name                          = wrpCuenta.cliente.DatosRepresentanteLegal.nombrePrimero;
                    accRepresentanteLegal.Name                          += wrpCuenta.cliente.DatosRepresentanteLegal.nombreSegundo!=null?' '+wrpCuenta.cliente.DatosRepresentanteLegal.nombreSegundo:'';
                    accRepresentanteLegal.Name                          += ' '+wrpCuenta.cliente.DatosRepresentanteLegal.apellidoPrimero;
                    accRepresentanteLegal.Name                          += wrpCuenta.cliente.DatosRepresentanteLegal.apellidoSegundo!=null?' '+wrpCuenta.cliente.DatosRepresentanteLegal.apellidoSegundo:'';
                    accRepresentanteLegal.COM_Primernombre__c           = wrpCuenta.cliente.DatosRepresentanteLegal.nombrePrimero;
                    accRepresentanteLegal.COM_Otrosnombres__c           = wrpCuenta.cliente.DatosRepresentanteLegal.nombreSegundo;
                    accRepresentanteLegal.COM_Primerapellido__c         = wrpCuenta.cliente.DatosRepresentanteLegal.apellidoPrimero;
                    accRepresentanteLegal.COM_Segundoapellido__c        = wrpCuenta.cliente.DatosRepresentanteLegal.apellidoSegundo;
                    if (wrpCuenta.cliente.DatosRepresentanteLegal.demografia.nacimientoFecha != null)
                        accRepresentanteLegal.COM_FechaNacimiento__c    = Date.valueof(wrpCuenta.cliente.DatosRepresentanteLegal.demografia.nacimientoFecha);
                    accRepresentanteLegal.COM_Genero__c                 = wrpCuenta.cliente.DatosRepresentanteLegal.demografia.genero;
                    accRepresentanteLegal.COM_Estado_civil__c           = wrpCuenta.cliente.DatosRepresentanteLegal.demografia.estadoCivil;
                    accRepresentanteLegal.COM_Profesion__c              = wrpCuenta.cliente.DatosRepresentanteLegal.demografia.OficiosProfesiones;
                }
                
                if(wrpCuenta.cliente.Sucursal != null){
                    if(wrpCuenta.cliente.Sucursal.sucursal != null && wrpCuenta.cliente.Sucursal.sucursal.size() > 0){
                        for(COM_WrapperConsultaClienteGCResponse_cls.Sucursal2 suc : wrpCuenta.cliente.Sucursal.sucursal){
                            if(suc.sucursalID != '0'){
                                Account accSucursal = new Account();
                                accSucursal.COM_TipoIdentificacion__c = wrpCuenta.cliente.tipoIdentificacion;
                                accSucursal.COM_Numero_de_identificacion__c = wrpCuenta.cliente.numeroIdentificacion;
                                accSucursal.COM_NAUTCLI__c = suc.id;
                                accSucursal.COM_Sucursal__c = Integer.valueOf(suc.sucursalID);
                                accSucursal.COM_CentroCosto__c = Integer.valueOf(suc.centroCostosID);
                                accSucursal.Name = suc.razonSocial;
                                if(suc.centroCostosID == '0'){
                                    accSucursal.RecordTypeId = tiposRegistro.get('COM_Sucursal').Id; 
                                } else {
                                    accSucursal.RecordTypeId = tiposRegistro.get('COM_CentroCosto').Id; 
                                }
                                lstSucursales.add(accSucursal);
                            }
                        }
                    }
                }
            } else {
                //DATOS PERSONA
                accCliente.RecordTypeId                                 = tiposRegistro.get('COM_Natural').Id;
                accCliente.Name                                         = wrpCuenta.cliente.DatosPersona.nombrePrimero;
                accCliente.Name                                         += wrpCuenta.cliente.DatosPersona.nombreSegundo!=null?' '+wrpCuenta.cliente.DatosPersona.nombreSegundo:'';
                accCliente.Name                                         += ' '+wrpCuenta.cliente.DatosPersona.apellidoPrimero;
                accCliente.Name                                         += wrpCuenta.cliente.DatosPersona.apellidoSegundo!=null?' '+wrpCuenta.cliente.DatosPersona.apellidoSegundo:'';
                accCliente.COM_Primernombre__c                          = wrpCuenta.cliente.DatosPersona.nombrePrimero;
                accCliente.COM_Otrosnombres__c                          = wrpCuenta.cliente.DatosPersona.nombreSegundo;
                accCliente.COM_Primerapellido__c                        = wrpCuenta.cliente.DatosPersona.apellidoPrimero;
                accCliente.COM_Segundoapellido__c                       = wrpCuenta.cliente.DatosPersona.apellidoSegundo;
                if (wrpCuenta.cliente.DatosPersona.demografia.nacimientoFecha != null)
                    accCliente.COM_FechaNacimiento__c                   = Date.valueof(wrpCuenta.cliente.DatosPersona.demografia.nacimientoFecha);
                accCliente.COM_Genero__c                                = wrpCuenta.cliente.DatosPersona.demografia.genero;
                accCliente.COM_Estado_civil__c                          = wrpCuenta.cliente.DatosPersona.demografia.estadoCivil;
                accCliente.COM_Profesion__c                             = wrpCuenta.cliente.DatosPersona.demografia.oficiosProfesiones;
            }
            if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios != null) {
                accCliente.COM_Barrio__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios.domicilioComunicacion[0].barrio;
                accCliente.COM_Direccion__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios.domicilioComunicacion[0].domicilio;
                if(wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios.domicilioComunicacion[0].localidad.id != null){
                    if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios.domicilioComunicacion[0].localidad.id != '-1' ) {
                        try {
                            COM_Poblacion__c pobCiudad = new COM_Poblacion__c(COM_Codigo__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios.domicilioComunicacion[0].localidad.id);
                            accCliente.COM_Ciudad__r = pobCiudad;
                            system.debug('ciudad>>' + pobciudad + '>>>>' + accCliente.COM_Ciudad__c);
                        } catch (exception e) {
                            System.debug('Ciudad no válida - ' + e.getMessage());
                        }
                    }
                }
                accCliente.COM_Tipodireccion__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].domicilios.domicilioComunicacion[0].tipoAreaGeografica;
                if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].correosElectronicos != null)
                    accCliente.COM_CorreoElectronico__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].correosElectronicos.correoElectronico[0];
                if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].opTinEmail != null)
                    accCliente.COM_Aceptaenviocorreoelectronico__c = Boolean.valueOf(wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].opTinEmail);
                if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].Celulares != null)
                    accCliente.COM_Movil__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].Celulares.celular[0];
                if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].opTinSMS != null)
                    accCliente.COM_AceptaenvioSMS__c = Boolean.valueOf(wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].opTinSMS);
                if (wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].telefonos != null) {
                    accCliente.Phone = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].telefonos.telefonoComunicacion[0].telefono;
                    accCliente.COM_Extension__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].telefonos.telefonoComunicacion[0].extensionTelefono;
                }
                accCliente.COM_UsuarioFacebook__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].redesSociales;
                accCliente.COM_UsuarioTwitter__c = wrpCuenta.cliente.comunicacionesCliente.comunicacionCliente[0].redesSociales;
            }
            WrapperClienteResponse Respuesta                    = new WrapperClienteResponse();
            if(wrpCuenta.cliente.id != '0'){
                try{
                    envioClientesGC(accCliente, accRepresentanteLegal);
                } catch(Exception e){
                    System.debug('Error consultando requisitos. '+e.getMessage());
                }
            }
            Respuesta.cuenta                                    = accCliente;
            Respuesta.cuentaRL                                  = accRepresentanteLegal;
            Respuesta.sucursales                                = lstSucursales;
            return Respuesta;
        }
        System.debug('El cliente no existe en GC');
        return null;
    }

    public void envioClientesGC(Account accCliente, Account accRepresentanteLegal){
        system.debug('entra envio clientes');
        if(Test.isRunningTest()){
            String response = '{"ConsultaRequisitos_Response" : {"Header" : {"System" : {"RequestDate" : "2017-10-25T10:04:59.876-05:00","ResponseDate" : "2017-10-25T10:05:00.082-05:00","ResponseCode" : "0","ResponseDesc" : "OK","TransactionID" : "12620170918162528248"}},"Body" : {"Requisitos" : { "Requisito" :[{"Tipo" : "TELCEL","FechaInicio" : "20171011","FechaFin" : "20171011","ValorAlfanumerico" : "","ValorNumerico" : "7002635691","ValorBooleano" : "true"},{"Tipo" : "TELCEL","FechaInicio" : "0","FechaFin" : "0","ValorAlfanumerico" : "","ValorNumerico" : "7002635691","ValorBooleano" : "true"}] }}}}';
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(response, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
        }
        Map<String, List<COM_ConfiguracionRequisitosM__mdt>> mapReqPrograma = new Map<String, List<COM_ConfiguracionRequisitosM__mdt>>();
        for(COM_ConfiguracionRequisitosM__mdt requisitoObj : [SELECT COM_Label__c, COM_Nemotecnico__c, COM_NombreApi__c, COM_Objeto__c, 
                                                                COM_IdRequisitoc__c, COM_NombreApiCuenta__c
                                                            FROM COM_ConfiguracionRequisitosM__mdt 
                                                            WHERE COM_CampoCliente__c = true]) {
            if(!mapReqPrograma.containsKey(requisitoObj.COM_Nemotecnico__c)){
                mapReqPrograma.put(requisitoObj.COM_Nemotecnico__c, new List<COM_ConfiguracionRequisitosM__mdt>{requisitoObj});
            } else {
                mapReqPrograma.get(requisitoObj.COM_Nemotecnico__c).add(requisitoObj);
            }
        }
        List<String> lstRequisitos = new List<String>();
        for(String nemotecnico : mapReqPrograma.keySet()){
            lstRequisitos.add(nemotecnico);
        }
        
        if(Test.isRunningTest()){
            for(COM_ConfiguracionRequisitosM__mdt requisitoObj : [SELECT COM_Label__c, COM_Nemotecnico__c, COM_NombreApi__c, COM_Objeto__c, 
                                                                COM_IdRequisitoc__c, COM_NombreApiCuenta__c
                                                            FROM COM_ConfiguracionRequisitosM__mdt 
                                                            WHERE COM_CampoCliente__c = false]) {
                if(!mapReqPrograma.containsKey(requisitoObj.COM_Nemotecnico__c)){
                    mapReqPrograma.put(requisitoObj.COM_Nemotecnico__c, new List<COM_ConfiguracionRequisitosM__mdt>{requisitoObj});
                } else {
                    mapReqPrograma.get(requisitoObj.COM_Nemotecnico__c).add(requisitoObj);
                }
            }
            for(String nemotecnico : mapReqPrograma.keySet()){
                lstRequisitos.add(nemotecnico);
            }
        }

        COM_WrapperConsultaRequisitoResponse_cls reqResponse = COM_ConsultarRequisitosAldea_ws.consultarRequisitos(accCliente, lstRequisitos); 
        if(reqResponse.ConsultaRequisitos_Response.Body.Requisitos != null){
            List<COM_WrapperConsultaRequisitoResponse_cls.Requisito> lstRequisito = reqResponse.ConsultaRequisitos_Response.Body.Requisitos.Requisito;
            if(lstRequisito.size() > 0){
                Map<String, sObject> mapObjetos = new Map<String, sObject>();
                if(accCliente.COM_TipoIdentificacion__c == '2'){
                    try{
                        mapObjetos.put('Contact', accRepresentanteLegal);  
                    } catch(Exception e){
                        System.debug('Error consutando el representante legal '+e.getMessage());
                    }                
                }
                mapObjetos.put('Account', accCliente);
                system.debug('mapObjetos - > '+mapObjetos);      
                for(COM_WrapperConsultaRequisitoResponse_cls.Requisito requisito : lstRequisito){
                    List<COM_ConfiguracionRequisitosM__mdt> lstDetalleRequisito = mapReqPrograma.get(requisito.Tipo);
                    system.debug('requisito  '+requisito);
                    for(COM_ConfiguracionRequisitosM__mdt detalle : lstDetalleRequisito){
                        system.debug('detalle  '+detalle);
                        String[] lstNombreApi = detalle.COM_NombreApiCuenta__c.split('\\.');
                        List<sObject> obj;
                        if(detalle.COM_Label__c == 'ValorAlfanumerico'){
                            if(lstNombreApi.size() == 1){
                                mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, requisito.ValorAlfanumerico));
                            } else if(lstNombreApi.size() == 2){ 
                                mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], requisito.ValorAlfanumerico));                                
                            } else if(lstNombreApi.size() > 3){ 
                                String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+requisito.ValorAlfanumerico+com+' LIMIT 1';
                                obj = database.query(strQuery);
                                if(obj != null && obj.size()==1)
                                    mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                            }
                        }
                        else if(detalle.COM_Label__c == 'ValorBooleano'){
                            if(lstNombreApi.size() == 1){
                                mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, requisito.ValorBooleano));
                            } else if(lstNombreApi.size() == 2){ 
                                mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], requisito.ValorBooleano));                                
                            } else if(lstNombreApi.size() > 3){                                
                                String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+requisito.ValorBooleano+com+' LIMIT 1';
                                obj = database.query(strQuery);
                                if(obj != null && obj.size()==1)
                                    mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                            }
                        }
                        else if(detalle.COM_Label__c == 'ValorNumerico'){
                            if(lstNombreApi.size() == 1){
                                mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, requisito.ValorNumerico));
                            } else if(lstNombreApi.size() == 2){ 
                                mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], requisito.ValorNumerico));                                
                            } else if(lstNombreApi.size() > 3){                                
                                String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+requisito.ValorNumerico+com+' LIMIT 1';
                                obj = database.query(strQuery);
                                if(obj != null && obj.size()==1)
                                    mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                            }
                        }
                        else if(detalle.COM_Label__c == 'FechaInicio'){
                            if(lstNombreApi.size() == 1){
                                mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, requisito.FechaInicio));
                            } else if(lstNombreApi.size() == 2){ 
                                mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], requisito.FechaInicio));                                
                            } else if(lstNombreApi.size() > 3){                                
                                String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+requisito.FechaInicio+com+' LIMIT 1';
                                obj = database.query(strQuery);
                                if(obj != null && obj.size()==1)
                                    mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                            }
                        }
                        else if(detalle.COM_Label__c == 'FechaFin'){
                            if(lstNombreApi.size() == 1){
                                mapObjetos.get(detalle.COM_Objeto__c).put(detalle.COM_NombreApiCuenta__c, castDato(detalle.COM_Objeto__c, detalle.COM_NombreApiCuenta__c, requisito.FechaFin));
                            } else if(lstNombreApi.size() == 2){ 
                                mapObjetos.get(detalle.COM_Objeto__c=='Opportunity'?'Account':detalle.COM_Objeto__c).put(lstNombreApi[1], castDato(lstNombreApi[0], lstNombreApi[1], requisito.FechaFin));                                
                            } else if(lstNombreApi.size() > 3){                                
                                String com = String.valueOf(Schema.getGlobalDescribe().get(lstNombreApi[lstNombreApi.size()==4?1:1]).getDescribe().fields.getMap().get(lstNombreApi[lstNombreApi.size()==4?3:4]).getDescribe().getSoapType())=='STRING'?'\'':'';                               
                                String strQuery = 'SELECT '+lstNombreApi[lstNombreApi.size()==4?2:3]+' FROM '+lstNombreApi[lstNombreApi.size()==4?1:1]+' WHERE '+lstNombreApi[lstNombreApi.size()==4?3:4]+' = '+com+requisito.FechaFin+com+' LIMIT 1';
                                obj = database.query(strQuery);
                                if(obj != null && obj.size()==1)
                                    mapObjetos.get(lstNombreApi[0]).put(lstNombreApi[lstNombreApi.size()==4?1:2], obj[0].get(lstNombreApi[lstNombreApi.size()==4?2:3]));
                            }    
                        }
                    }                
                    system.debug('mapa objetos req -> '+mapObjetos);
                }
                system.debug('mapa objetos -> '+mapObjetos);
            }
        }
    }

    public static Object castDato(String objeto, String campo, String valor){
        String tipoDato = String.valueOf(Schema.getGlobalDescribe().get(objeto).getDescribe().fields.getMap().get(campo).getDescribe().getSoapType());
        system.debug('tipoDato  '+tipoDato);
        try{
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
        } catch(Exception e){
            system.debug('Error mapeando requisito. '+e.getMessage());
        }
        return null;
    }

    public String CrearCliente(WrapperClienteResponse cliente){
        if(cliente.cuenta.COM_Numero_de_identificacion__c != null && cliente.cuenta.name != null ) {
            try {
                system.debug(cliente);
                insert cliente.cuenta;
                if (cliente.cuenta.COM_TipoIdentificacion__c == '2') {
                    if(cliente.cuentaRL.COM_TipoIdentificacion__c != null) {
                        List<Account> lstAccRL = [SELECT Id FROM Account WHERE COM_NAUTCLI__c =:cliente.cuentaRL.COM_NAUTCLI__c];
                        if(lstAccRL.size() > 0)
                            cliente.cuentaRL.Id = lstAccRL.get(0).Id;
                        COM_AccountContactRelation_cls.startTrigger2();
                        //COM_NormalizarDireccion_cls.startTrigger();
                        upsert cliente.CuentaRL;
                        //cliente.contacto.AccountId              = cliente.cuentaRL.Id;
                        List<Contact> lstCon = [SELECT Id FROM Contact WHERE AccountId =:cliente.cuentaRL.Id AND
                            COM_TipoIdentificacion__c =:cliente.cuentaRL.COM_TipoIdentificacion__c AND 
                            COM_Numeroidentificacion__c =:cliente.cuentaRL.COM_Numero_de_identificacion__c
                        ];
                        if(lstCon.size() > 0){
                            AccountContactRelation acr = new AccountContactRelation();
                            acr.AccountId = cliente.cuenta.Id;
                            acr.ContactId = lstCon.get(0).Id;
                            acr.Roles = 'Representante Legal';
                            insert acr;
                        } else {
                            System.debug('No hay contacto, no se puede crear la relación de Representante Legal');
                        }
                    }
                }
                if(cliente.sucursales != null && cliente.sucursales.size() > 0){
                    Map<Decimal,Account> mapSuc = new Map<Decimal,Account>();
                    for(Account sucursal : cliente.sucursales){
                        if(sucursal.COM_CentroCosto__c == 0){
                            sucursal.ParentId = cliente.cuenta.Id;
                            mapSuc.put(sucursal.COM_Sucursal__c, sucursal);
                        }
                    }
                    insert mapSuc.values();
                    Map<Decimal,Account> mapCC = new Map<Decimal,Account>();
                    for(Account centroCosto : cliente.sucursales){
                        if(centroCosto.COM_CentroCosto__c != 0){
                            centroCosto.ParentId = mapSuc.get(centroCosto.COM_Sucursal__c).Id;
                            mapCC.put(centroCosto.COM_Sucursal__c, centroCosto);
                        }
                    }
                    insert mapCC.values();
                }
                return cliente.cuenta.Id;
            } catch (exception e) {   
                System.debug('Error creando los datos -> ' + e.getMessage());
                return null;
            }
        }
        return null;
    }

    public class WrapperClienteResponse{
        public Account cuenta                                       { get; set; }
        public Account cuentaRL                                     { get; set; }
        public Contact contacto                                     { get; set; }
        public AccountContactRelation relacion                      { get; set; }
        public List<Account> sucursales                             { get; set; }
    }

}