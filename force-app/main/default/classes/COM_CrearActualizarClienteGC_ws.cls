/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para los procesos de creacion y actualizacion de clientes en GC
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-28      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  2.0    	06/01/2022      Yeison Naranjo		            Inclusión nuevo campo NOLA 00030781
*************************************************************************************************************/

public class COM_CrearActualizarClienteGC_ws {

    public COM_CrearActualizarClienteGC_ws() {

    }
    public static COM_WrapperCrearClienteGCResponse_cls CrearCliente(String idCliente, Boolean actualizar, Integer direccion) {
    //public static Decimal CrearCliente(String idCliente, Boolean actualizar) {
        
        Map<String, sObject> mapObjetos = new Map<String, sObject>();
        Account accCliente = [SELECT COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, Id, COM_Genero__c, RecordType.DeveloperName, COM_Digitoverificacion__c,
                Name, Type, COM_NombreComercial__c, COM_Fechaconstitucion__c, COM_ActividadEconomicaCIIU__c, COM_SectorEconomico__c, ParentId, COM_Estadoafiliacion__c,
                Phone, COM_Extension__c, COM_Barrio__c, COM_Direccion__c, COM_Localidad__c, COM_Ciudad__r.COM_Codigo__c, COM_Tipodireccion__c, COM_CorreoElectronico__c,
                COM_Aceptaenviocorreoelectronico__c, COM_Movil__c, COM_AceptaenvioSMS__c, COM_UsuarioFacebook__c, COM_UsuarioTwitter__c,
                COM_FechaNacimiento__c, COM_Otrosnombres__c, COM_Primerapellido__c, COM_Segundoapellido__c, COM_Estado_civil__c, COM_Valorultimoaporte__c,
                COM_Tamanoempresa__c, COM_Bloque__c, COM_Caja_anterior__c, COM_Tratamientoprotecciondatos__c, COM_ModalidadentregatarjetaCompensar__c, Website, COM_TotalbeneficiarioscategoriaA__c,
                COM_TotalbeneficiarioscategoriaB__c, COM_TotaltrabajadorescategoriaC__c, COM_Total_beneficiarios__c, COM_BeneficiariosDerechoSubsidio__c,
                COM_TotaltrabajadorescategoriaA__c, COM_TotaltrabajadorescategoriaB__c, COM_Total_trabajadores__c, COM_ActividadeconomicaSENA__c,
                COM_Trabajadoresderechosubsidio__c, COM_Valorultimosubsidio__c, COM_Segmento__c, COM_Primernombre__c, COM_ActividadEconomicaCIIU__r.COM_Codigo__c,
                COM_ARL1__r.COM_CodigoARL__c
                /* Inicio 2.0 */, COM_ResponsabilidadesFiscales__c /* Fin 2.0 */
                FROM Account WHERE Id = :idCliente];
        string strDN;

        strDN = accCliente.COM_TipoIdentificacion__c == '2'?'COM_Juridico':'COM_Natural';
        String strTipoRegistro = [SELECT Id FROM RecordType WHERE DeveloperName = :strDN AND SobjectType = 'Account'].Id;
        COM_WrapperCrearClienteGCRequest_cls wrpRequest = new COM_WrapperCrearClienteGCRequest_cls();
        COM_WrapperCrearClienteGCResponse_cls wrpResponse;
        COM_WrapperCrearClienteGCRequest_cls.CustomerMng_CrearCliente_Request reqContenido = new COM_WrapperCrearClienteGCRequest_cls.CustomerMng_CrearCliente_Request();
        COM_WrapperCrearClienteGCRequest_cls.Body reqBody = new COM_WrapperCrearClienteGCRequest_cls.Body();
        COM_WrapperCrearClienteGCRequest_cls.cliente reqCliente = new COM_WrapperCrearClienteGCRequest_cls.Cliente();
        reqCliente.tipoIdentificacion = accCliente.COM_TipoIdentificacion__c;
        //reqCliente.numeroIdentificacion = accCliente.COM_Numeroidentificacion__c;
        reqCliente.numeroIdentificacion = accCliente.COM_Numero_de_identificacion__c;
        COM_WrapperCrearClienteGCRequest_cls.Variables reqVariables = new COM_WrapperCrearClienteGCRequest_cls.Variables();
        reqVariables.CreacionPrimerNombre = '1';
        reqVariables.CreacionSegundoNombre = '1';
        reqVariables.CreacionPrimerApellido = '1';
        reqVariables.CreacionSegundoApellido = '1';
        COM_WrapperCrearClienteGCRequest_cls.demografia reqDemografia = new COM_WrapperCrearClienteGCRequest_cls.demografia();
        if(accCliente.RecordType.DeveloperName == 'COM_Natural') {
            //DATOS PERSONA
            COM_WrapperCrearClienteGCRequest_cls.datosPersona reqDatosPersona = new COM_WrapperCrearClienteGCRequest_cls.datosPersona();
            reqDatosPersona.nombrePrimero = accCliente.COM_Primernombre__c;
            reqDatosPersona.nombreSegundo = accCliente.COM_Otrosnombres__c;
            reqDatosPersona.apellidoPrimero = accCliente.COM_Primerapellido__c;
            reqDatosPersona.apellidoSegundo = accCliente.COM_Segundoapellido__c;
            reqDatosPersona.demografia = reqDemografia;
            reqDatosPersona.Variables = reqVariables;
            reqCliente.datosPersona = reqDatosPersona;
            if(accCliente.COM_FechaNacimiento__c != null)
                reqDemografia.nacimientoFecha = String.valueOf(accCliente.COM_FechaNacimiento__c)+'T00:00:00';
            reqDemografia.genero = accCliente.COM_Genero__c;
            reqDemografia.estadoCivil = accCliente.COM_Estado_civil__c;
        } else if (accCliente.RecordType.DeveloperName == 'COM_Juridico') {
            //DATOS EMPRESA
            Contact conRepresentanteLegal = new Contact();
            Contact[] lstRepresentanteLegal = [SELECT AccountId FROM Contact
                    WHERE Id IN (SELECT ContactId FROM AccountContactRelation WHERE Roles INCLUDES ('Representante Legal') AND IsActive = true AND AccountId = :AccCliente.Id ) LIMIT 1];
            if(lstRepresentanteLegal.size() > 0)
                conRepresentanteLegal = lstRepresentanteLegal[0];          
                
            Account accRepresentanteLegal = new Account();
            Account[] lstAccRepresentanteLegal = [SELECT COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, COM_Genero__c, COM_FechaNacimiento__c,
                            Name, COM_Otrosnombres__c, COM_Primerapellido__c, COM_Segundoapellido__c, COM_Estado_civil__c, COM_Localidad__c, COM_Primernombre__c
                    FROM Account WHERE Id = :conRepresentanteLegal.AccountId LIMIT 1];
            if(lstAccRepresentanteLegal.size() > 0)
                accRepresentanteLegal = lstAccRepresentanteLegal[0];          
            
            mapObjetos.put('Contact', accRepresentanteLegal);
            COM_WrapperCrearClienteGCRequest_cls.datosEmpresa reqDatosEmpresa = new COM_WrapperCrearClienteGCRequest_cls.datosEmpresa();
            reqDatosEmpresa.digitoVerificadorLegal = String.valueOf(accCliente.COM_Digitoverificacion__c);
            /* Inicio 2.0 */
            reqDatosEmpresa.Responsabilidades_Fiscales = Integer.valueOf(accCliente.COM_ResponsabilidadesFiscales__c);
            /* Fin 2.0 */
            reqDatosEmpresa.razonSocial = accCliente.Name;
            reqDatosEmpresa.tipoEmpresa = accCliente.Type;
            reqDatosEmpresa.nombreComercial = accCliente.COM_NombreComercial__c;
            try{
                reqDatosEmpresa.constitucionFecha = String.valueOf(accCliente.COM_Fechaconstitucion__c);
            } catch(Exception e){
                System.debug('fecha de constitución inválida========>'+e.getMessage());
            }
            if(accCliente.COM_ActividadEconomicaCIIU__c != null){
                try {
                    COM_ActividadEconomicaCIIU__c actActividadEconomica = [SELECT COM_Codigo__c FROM COM_ActividadEconomicaCIIU__c WHERE Id = :accCliente.COM_ActividadEconomicaCIIU__c];
                    reqDatosEmpresa.tipoActividadEconomica = actActividadEconomica.COM_Codigo__c;
                } catch(Exception e){
                    System.debug('Actividad Económica inválida========>'+e.getMessage());
                }
            }
            reqDatosEmpresa.sectorEconomico = accCliente.COM_SectorEconomico__c;
            reqDatosEmpresa.grupoEmpresarial = accCliente.ParentId;
            reqDatosEmpresa.estadoAfiliacion = accCliente.COM_Estadoafiliacion__c!=null?accCliente.COM_Estadoafiliacion__c:'A';
            if(accCliente.COM_FechaNacimiento__c != null)
                reqDemografia.nacimientoFecha = String.valueOf(accRepresentanteLegal.COM_FechaNacimiento__c)+'T00:00:00';
            reqDemografia.genero = accRepresentanteLegal.COM_Genero__c;
            reqDemografia.estadoCivil = accRepresentanteLegal.COM_Estado_civil__c;
            reqCliente.datosEmpresa = reqDatosEmpresa;
            COM_WrapperCrearClienteGCRequest_cls.datosRepresentanteLegal reqDatosRepresentanteLegal = new COM_WrapperCrearClienteGCRequest_cls.datosRepresentanteLegal();
            reqDatosRepresentanteLegal.TipoIdentificacion = accRepresentanteLegal.COM_TipoIdentificacion__c;
            //reqDatosRepresentanteLegal.NumeroIdentificacion = accRepresentanteLegal.COM_Numeroidentificacion__c;
            reqDatosRepresentanteLegal.NumeroIdentificacion = accRepresentanteLegal.COM_Numero_de_identificacion__c;
            reqDatosRepresentanteLegal.nombrePrimero = accRepresentanteLegal.COM_Primernombre__c;
            reqDatosRepresentanteLegal.nombreSegundo = accRepresentanteLegal.COM_Otrosnombres__c;
            reqDatosRepresentanteLegal.apellidoSegundo = accRepresentanteLegal.COM_Primerapellido__c;
            reqDatosRepresentanteLegal.apellidoPrimero = accRepresentanteLegal.COM_Segundoapellido__c;
            reqDatosRepresentanteLegal.demografia = reqDemografia;
            /*Inicio Stifen*/
            if(!actualizar)
            reqCliente.datosRepresentanteLegal = reqDatosRepresentanteLegal;
            /*Fin Stifen*/
        }
        COM_WrapperCrearClienteGCRequest_cls.comunicacionesCliente reqComunicacionesCliente = new COM_WrapperCrearClienteGCRequest_cls.comunicacionesCliente();
        List<COM_WrapperCrearClienteGCRequest_cls.comunicacionCliente> reqLstComunicacionCliente = new List<COM_WrapperCrearClienteGCRequest_cls.comunicacionCliente>();
        COM_WrapperCrearClienteGCRequest_cls.comunicacionCliente reqComunicacionCliente = new COM_WrapperCrearClienteGCRequest_cls.comunicacionCliente();
        COM_WrapperCrearClienteGCRequest_cls.telefonos reqTelefonos = new COM_WrapperCrearClienteGCRequest_cls.telefonos();
        List<COM_WrapperCrearClienteGCRequest_cls.telefonoComunicacion> reqLstTelefonoComunicacion = new List<COM_WrapperCrearClienteGCRequest_cls.telefonoComunicacion>();
        COM_WrapperCrearClienteGCRequest_cls.telefonoComunicacion reqTelefonoComunicacion = new COM_WrapperCrearClienteGCRequest_cls.telefonoComunicacion();
        reqTelefonoComunicacion.tipoTelefono = '1';
        reqTelefonoComunicacion.telefono = accCliente.Phone != null?accCliente.Phone:'0';
        reqTelefonoComunicacion.extensionTelefono = accCliente.COM_Extension__c != null?accCliente.COM_Extension__c:'0';        
        reqLstTelefonoComunicacion.add(reqTelefonoComunicacion);
        reqTelefonos.telefonoComunicacion = reqLstTelefonoComunicacion;
        reqComunicacionCliente.telefonos = reqTelefonos;
        COM_WrapperCrearClienteGCRequest_cls.domicilios reqDomicilios = new COM_WrapperCrearClienteGCRequest_cls.domicilios();
        List<COM_WrapperCrearClienteGCRequest_cls.domicilioComunicacion> reqLstDomicilioComunicacion = new List<COM_WrapperCrearClienteGCRequest_cls.domicilioComunicacion>();
        COM_WrapperCrearClienteGCRequest_cls.domicilioComunicacion reqDomicilioComunicacion = new COM_WrapperCrearClienteGCRequest_cls.domicilioComunicacion();
        reqDomicilioComunicacion.barrio = accCliente.COM_Barrio__c;
        reqDomicilioComunicacion.tipoDomicilio = reqDomicilioComunicacion.domicilio!=null?'1':null;
        reqDomicilioComunicacion.domicilio = accCliente.COM_Direccion__c;
        COM_WrapperCrearClienteGCRequest_cls.localidad reqLocalidad = new COM_WrapperCrearClienteGCRequest_cls.localidad();
        //reqLocalidad.id = accCliente.COM_Localidad__c;
        COM_WrapperCrearClienteGCRequest_cls.municipio reqMunicipio = new COM_WrapperCrearClienteGCRequest_cls.municipio();
        COM_WrapperCrearClienteGCRequest_cls.departamento reqDepartamento = new COM_WrapperCrearClienteGCRequest_cls.departamento();
        if(accCliente.COM_Ciudad__c != null){
            try {
                COM_Poblacion__c pobCiudad = [SELECT Name, COM_Codigo__c, COM_Departamento__c FROM COM_Poblacion__c WHERE Id = :accCliente.COM_Ciudad__c];
                reqMunicipio.id = String.valueOf(pobCiudad.COM_Codigo__c).substring(2);
                reqMunicipio.nombre = pobCiudad.Name;
                reqDepartamento.id = String.valueOf(pobCiudad.COM_Codigo__c).substring(0,2);
                reqDepartamento.nombre = pobCiudad.COM_Departamento__c.substring(0,2);
                reqLocalidad.id = String.valueOf(pobCiudad.COM_Codigo__c);
            } catch(Exception e){
                System.debug('Ciudad inválida========>'+e.getMessage());
            }
        }
        reqMunicipio.departamento = reqDepartamento;
        //reqLocalidad.nombre = String.valueOf(accCliente.get('lblLocalidad'));
        reqLocalidad.municipio = reqMunicipio;
        reqDomicilioComunicacion.localidad = reqLocalidad;
        reqDomicilioComunicacion.tipoAreaGeografica = accCliente.COM_Tipodireccion__c;
        if(reqDomicilioComunicacion.domicilio != null && reqDomicilioComunicacion.localidad.id  != null && reqDomicilioComunicacion.tipoAreaGeografica != null)
            reqLstDomicilioComunicacion.add(reqDomicilioComunicacion);
        reqDomicilios.domicilioComunicacion = reqLstDomicilioComunicacion;
        reqComunicacionCliente.domicilios = reqDomicilios;
        COM_WrapperCrearClienteGCRequest_cls.correosElectronicos reqCorreosElectronicos = new COM_WrapperCrearClienteGCRequest_cls.correosElectronicos();
        if(!String.isBlank(accCliente.COM_CorreoElectronico__c)) {
            reqCorreosElectronicos.correoElectronico = new List<String>();
            reqCorreosElectronicos.correoElectronico.add(accCliente.COM_CorreoElectronico__c);
            reqComunicacionCliente.correosElectronicos = reqCorreosElectronicos;
        }
        reqComunicacionCliente.opTinEmail = String.valueOf(accCliente.COM_Aceptaenviocorreoelectronico__c);
        if(!String.isBlank(accCliente.COM_Movil__c)) {
            COM_WrapperCrearClienteGCRequest_cls.celulares reqCelulares = new COM_WrapperCrearClienteGCRequest_cls.celulares();
            reqCelulares.Celular = new List<String>();
            reqCelulares.Celular.add(accCliente.COM_Movil__c);
            reqComunicacionCliente.celulares = reqCelulares;
        }
        reqComunicacionCliente.opTinSMS = String.valueOf(accCliente.COM_AceptaenvioSMS__c);
        COM_WrapperCrearClienteGCRequest_cls.redesSociales reqRedesSociales = new COM_WrapperCrearClienteGCRequest_cls.redesSociales();
        if(!String.isBlank(accCliente.COM_UsuarioFacebook__c) && !String.isBlank(accCliente.COM_UsuarioTwitter__c)) {
            reqRedesSociales.redesSociales = new List<String>();
            if(!String.isBlank(accCliente.COM_UsuarioFacebook__c))
                reqRedesSociales.redesSociales.add(accCliente.COM_UsuarioFacebook__c);
            if(!String.isBlank(accCliente.COM_UsuarioTwitter__c))
                reqRedesSociales.redesSociales.add(accCliente.COM_UsuarioTwitter__c);
            if(!reqRedesSociales.redesSociales.isEmpty())
                reqComunicacionCliente.redesSociales = reqRedesSociales;
        }

        COM_WrapperCrearClienteGCRequest_cls.adicionalesContacto reqAdicionalesContacto = new COM_WrapperCrearClienteGCRequest_cls.adicionalesContacto();
        //reqAdicionalesContacto.orden = actualizar?'1':'0';
        reqAdicionalesContacto.orden = String.valueOf(direccion);
        //reqAdicionalesContacto.orden = '0';
        reqAdicionalesContacto.borradoEstado = 'A';
        String strFecha = String.valueOf(system.now().year())+'-';
        strFecha += String.valueOf(system.now().month()).length()==1?'0'+String.valueOf(system.now().month()):String.valueOf(system.now().month());
        strFecha += '-'+(system.now().day()<10?('0'+String.valueOf(system.now().day())):(String.valueOf(system.now().day())))+'T00:00:00-05:00';
        reqAdicionalesContacto.creacionFecha = strFecha;
        reqAdicionalesContacto.ultimaNovedadFecha = strFecha;
        reqAdicionalesContacto.identificador = accCliente.COM_Numero_de_identificacion__c;
        reqAdicionalesContacto.zonaBogota = accCliente.COM_Localidad__c;
        reqComunicacionCliente.adicionalesContacto = reqAdicionalesContacto;

        reqLstComunicacionCliente.add(reqComunicacionCliente);
        reqComunicacionesCliente.comunicacionCliente = reqLstComunicacionCliente;
        reqCliente.comunicacionesCliente = reqComunicacionesCliente;
        reqBody.cliente = reqCliente;
        COM_WrapperCrearClienteGCRequest_cls.AtributosComunes reqAtributosComunes = new COM_WrapperCrearClienteGCRequest_cls.AtributosComunes();
        reqAtributosComunes.consultaCliente = actualizar?'1':'0';
        reqAtributosComunes.fechaModificacion = strFecha;
        reqBody.cliente.atributosComunes = reqAtributosComunes;

//if (accCliente.RecordType.DeveloperName == 'COM_Juridico'){
        COM_WrapperCrearClienteGCRequest_cls.Requisitos objRequisitos;
        List<COM_WrapperCrearClienteGCRequest_cls.Requisito> lstRequisito;


//RUBEN - AÑADIR REQUISITOS INI
//
        objRequisitos = new COM_WrapperCrearClienteGCRequest_cls.Requisitos();
        lstRequisito = new List<COM_WrapperCrearClienteGCRequest_cls.Requisito>();
        
        mapObjetos.put('Account', accCliente);
        //mapObjetos.put('Opportunity', oppOportunidad);

        Map<String, List<COM_ConfiguracionRequisitosM__mdt>> mapReqPrograma = new Map<String, List<COM_ConfiguracionRequisitosM__mdt>>();
        for(COM_ConfiguracionRequisitosM__mdt requisitoObj : [SELECT COM_Label__c, COM_Nemotecnico__c, COM_NombreApi__c, COM_Objeto__c, COM_IdRequisitoc__c,
                                                            COM_NombreApiCuenta__c
                                                            FROM COM_ConfiguracionRequisitosM__mdt 
                                                            WHERE COM_CampoCliente__c = true]) {
            if(!mapReqPrograma.containsKey(requisitoObj.COM_Nemotecnico__c)){
                mapReqPrograma.put(requisitoObj.COM_Nemotecnico__c, new List<COM_ConfiguracionRequisitosM__mdt>{requisitoObj});
            } else {
                mapReqPrograma.get(requisitoObj.COM_Nemotecnico__c).add(requisitoObj);
            }
        }
        system.debug('ruben - '+mapObjetos);
        for(String strRequisito :mapReqPrograma.keySet()) {
            COM_WrapperCrearClienteGCRequest_cls.Requisito objWprRequisito;
            objWprRequisito = new COM_WrapperCrearClienteGCRequest_cls.Requisito();            
            objWprRequisito.sigla = strRequisito;
            List<COM_ConfiguracionRequisitosM__mdt> lstObjRequisito = mapReqPrograma.get(strRequisito);
            for(COM_ConfiguracionRequisitosM__mdt requisito : lstObjRequisito) {
                system.debug('====='+requisito);
                objWprRequisito.idRequisito = Integer.valueOf(requisito.COM_IdRequisitoc__c);
                String[] lstNombreApi = requisito.COM_NombreApi__c.split('\\.');
                if(strRequisito == 'ULTSUB')
                    continue;
                try{
                    if(requisito.COM_Label__c == 'ValorAlfanumerico'){
                        if(lstNombreApi.size() == 1){
                            objWprRequisito.campoAlfa = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                        } else if(lstNombreApi.size() > 1){
                            if(requisito.COM_Objeto__c=='Opportunity') 
                                objWprRequisito.campoAlfa = String.valueOf(mapObjetos.get('Account').getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                            else if(requisito.COM_Objeto__c=='Contact')
                                objWprRequisito.campoAlfa = String.valueOf(mapObjetos.get('Contact').get(lstNombreApi[1]));
                            else
                                objWprRequisito.campoAlfa = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                        }
                    } else if(requisito.COM_Label__c == 'ValorBooleano'){
                        if(lstNombreApi.size() == 1){
                            objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                        } else if(lstNombreApi.size() > 1){ 
                            //objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c=='Opportunity'?'Account':requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                            if(requisito.COM_Objeto__c=='Opportunity') 
                                objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get('Account').getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                            else if(requisito.COM_Objeto__c=='Contact')
                                objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get('Contact').get(lstNombreApi[1]));
                            else
                                objWprRequisito.campoBooleano = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                        }
                    } else if(requisito.COM_Label__c == 'ValorNumerico'){
                        if(lstNombreApi.size() == 1){
                            if(strRequisito == 'FCONST'){
                                String aux = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                                objWprRequisito.campoNumerico = aux.replace('-','').replace(' 00:00:00','');
                            } else{
                                objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).get(requisito.COM_NombreApi__c));
                            }
                        } else if(lstNombreApi.size() > 1){ 
                            //objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c=='Opportunity'?'Account':requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                            if(requisito.COM_Objeto__c=='Opportunity') 
                                objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get('Account').getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                            else if(requisito.COM_Objeto__c=='Contact')
                                objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get('Contact').get(lstNombreApi[1]));
                            else
                                objWprRequisito.campoNumerico = String.valueOf(mapObjetos.get(requisito.COM_Objeto__c).getSobject(lstNombreApi[0]).get(lstNombreApi[1]));
                        }   
                    } 
                } catch(Exception e){
                    System.debug('Error consultando el valor del requisito -> '+e.getMessage());
                }
            }
            
            if(objWprRequisito.campoAlfa != null || objWprRequisito.campoBooleano != null || objWprRequisito.campoNumerico != null){
                if(objWprRequisito.campoAlfa == null)
                    objWprRequisito.campoAlfa = '';
                if(objWprRequisito.campoBooleano == null)
                    objWprRequisito.campoBooleano = 'false';
                if(objWprRequisito.campoNumerico == null)
                    objWprRequisito.campoNumerico = '0';
                objWprRequisito.campoFecha1 = '0001-01-01T00:00:00';
                objWprRequisito.campoFecha2 = '0001-01-01T00:00:00';
                String decCampoFecha = String.valueOf(system.now().year())+(system.now().month()<10?('0'+String.valueOf(system.now().month())):(String.valueOf(system.now().month())))+(system.now().day()<10?('0'+String.valueOf(system.now().day())):(String.valueOf(system.now().day())));
                objWprRequisito.decCampoFecha1 = decCampoFecha;
                objWprRequisito.decCampoFecha2 = decCampoFecha;
                objWprRequisito.estadoDato = 4; //4 porque es creación
                objWprRequisito.grupoDato = 0;
                objWprRequisito.guardarTramite = false;
                objWprRequisito.idCampoNumerico = 0;
                objWprRequisito.numeroRadicado = 0;
                objWprRequisito.subGrupoDato = 0;
                if((strRequisito == 'CORELE' &&  objWprRequisito.campoAlfa == '') || (strRequisito == 'TELCEL' && objWprRequisito.campoNumerico == '0'))
                    objWprRequisito.tipoAccion = 2; //CORELE Y TELCEL SE PUEDEN ENVIAR CON UN DATOS DISTINTO PARA QUE DEJE VINCULAR
                else
                    objWprRequisito.tipoAccion = 1;
                lstRequisito.add(objWprRequisito);
            }
        }
        
        objRequisitos.requisito = lstRequisito;     
        reqBody.cliente.Requisitos = objRequisitos;
//RUBEN - AÑADIR REQUISITOS FIN
//}


System.debug(' reqBody Stif ' + reqBody);
        reqContenido.Body = reqBody;


        reqContenido.Header = COM_UtilidadWebService_cls.obtenerCabecera(Label.COM_WS_CrearActualizarClienteGC);
        wrpRequest.CustomerMng_CrearCliente_Request = reqContenido;
        System.debug(system.json.serialize(wrpRequest));
        try {
            system.debug('----> Consumir Servicio wrpRequest '+wrpRequest);
            system.debug('----> Consumir Servicio COM_WS_CrearActualizarClienteGC '+Label.COM_WS_CrearActualizarClienteGC);
            system.debug('----> Consumir Servicio COM_WrapperCrearClienteGCResponse_cls '+COM_WrapperCrearClienteGCResponse_cls.class);
            system.debug('----> Consumir Servicio accCliente.Id '+accCliente.Id);
            
            wrpResponse = (COM_WrapperCrearClienteGCResponse_cls) COM_UtilidadWebService_cls.consumirWS(wrpRequest, Label.COM_WS_CrearActualizarClienteGC, COM_WrapperCrearClienteGCResponse_cls.class, accCliente.Id);
            accCliente.COM_NAUTCLI__c = wrpResponse.CustomerMng_CrearClienteResponse.Body.cliente.IdCliente;
            //return accCliente.COM_NAUTCLI__c;
            return wrpResponse;
        } catch (COM_WSInactivoException e) {
            System.debug('Error ========>'+e.getMessage());
            throw e;
        } catch (Exception e) {
            System.debug('Error ========>'+e.getMessage());
            return null;
        }
    }

}