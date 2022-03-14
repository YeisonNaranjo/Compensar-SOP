/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Web service para la creación de casos en SF desde OnBase
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-07      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.1     2021-07-01      Stifen Panche Gutierrez (SPG)   Log servicio web.
*************************************************************************************************************/

@RestResource(urlMapping='/Caso/*')
global class RF2_CrearCasosSF_ws {
    /**
     * @description Metodo encargado de procesar las peticiones invocadas al servicio de creación de casos en SF desde onBase
     * @param wrapper con la información para la creación del caso.
     * @return wrapper con la información de la transacción.
     */
    @HttpPost
    global static RF2_WrapperCrearCasosSFResponse_cls crearCaso(RF2_WrapperCrearCasosSFRequest_cls DatosCaso){
        system.debug('Caso - '+DatosCaso);
        RF2_WrapperCrearCasosSFResponse_cls objResponse = new RF2_WrapperCrearCasosSFResponse_cls();
        objResponse.fechaTransaccion = System.Now();
        Case caso = new Case();
        try{
            String idCaso = procesarCaso(DatosCaso);            
            caso = [SELECT CaseNumber FROM Case WHERE Id =:idCaso];
            if(caso != null && caso.CaseNumber != null){
                objResponse.NumeroConsecutivoCRM = caso.CaseNumber; 
                objResponse.codigoRespuesta = 200;
                objResponse.mensajeRespuesta = Label.RF2_WSTransaccionExitosa_lbl;   
            } else {
                objResponse.NumeroConsecutivoCRM = '';
                objResponse.codigoRespuesta = 400;
                objResponse.mensajeRespuesta =  Label.RF2_WSTransaccionError_lbl+' No se genero número de caso.';
            }
        }catch(Exception e){
            objResponse.NumeroConsecutivoCRM = '';
            objResponse.codigoRespuesta = 400;
            objResponse.mensajeRespuesta =  Label.RF2_WSTransaccionError_lbl+e.getMessage();
        }
        
        /*Creación Log*/
        /*Inicio 1.1*/
          try{
            COM_LogTransacciones__c objLog = new COM_LogTransacciones__c();
        
            //objLog.COM_AttachmentId__c = objContentVersion.Id;
            //objLog.COM_AttachmentId__c = objAttachment.Id;
            //objLog.COM_AttachmContentVersion = oContentVersion//ment.Id;
            objLog.COM_FechaTransaccion__c = Datetime.now();
            objLog.COM_Request__c =  String.valueOf(DatosCaso).length()>131000?String.valueOf(DatosCaso).substring(0, 131000):String.valueOf(DatosCaso);
            objLog.COM_Response__c = String.valueOf(objResponse).length()>131000?String.valueOf(objResponse).substring(0, 131000):String.valueOf(objResponse);
            objLog.COM_TipoTransaccion__c = label.COM_WS_CrearCaso;
            objLog.COM_Descripcion__c = objResponse.mensajeRespuesta;
            if(objResponse.codigoRespuesta == 200)
            {
                objLog.RF2_CasoId__c = caso.id; 
            }
            insert objLog;
        } catch(Exception e){
            system.debug('..... NO SE PUDO CREAR EL REGISTRO DE LOG PARA ' + label.COM_WS_CrearCaso + ': ' + e.getMessage());
        }
        /*Fin 1.1*/
       
        
        system.debug('Respuesta - >'+objResponse);
        return objResponse;
    }

    /**
     * @description Metodo encargado de crear el caso
     * @param wrapper con la información para la creación del caso.
     * @return Id del caso creado
     */
    public static String procesarCaso(RF2_WrapperCrearCasosSFRequest_cls objRequest){
        RF2_WrapperCrearCasosSFRequest_cls dc = objRequest;
        //Si el caso no es anónimo  y no tiene numero ni tipo de documento no procesar
        if(dc.noID != Label.RF2_NoIDCasoOnBase_lbl && (String.isBlank(dc.tipoDocumento) ||  String.isBlank(dc.numeroDocumento))){
            throw new RF2_CrearCasosException('Faltan datos para crear el caso.');
        }
        Case caso = new Case();
        caso.Status = Label.RF2_EstadoCasoAbierto;
        caso.Origin = Label.RF2_OrigenCasoOnBase_lbl;
        caso.RF2_NumeroRadicadoExterno__c = dc.idCaso;
        caso.RF2_DocumentaHandlerID__c = dc.documentHandler;
        caso.RF2_Anonimo__c = dc.noID=='1'?true:false;
        caso.RF2_FechaRecepcion__c = Date.valueOf(dc.fechaRecepcion);
        caso.RF2_SedeRadicacion__c = dc.sede;
        caso.Description = dc.observacion;
        caso.RF2_ProcesoDestinoMatrizResponsable__c  = dc.procesoDestino; 
        caso.RF2_TipoSolicitud__c = dc.tipo;
        caso.RF2_RelacionadoCon__c = dc.asunto;  
        caso.Subject = dc.asunto;
        caso.RF2_TieneArchivosOnBase__c = String.isNotBlank(dc.documentHandler)?true:false;   

        caso.RF2_CorreoElectronicoHuerfano__c = dc.correoElectronico;
        caso.RF2_TelefonoHuerfano__c = dc.telefono;  
        List<COM_Poblacion__c> lstciudad = new List<COM_Poblacion__c>([SELECT Id FROM COM_Poblacion__c WHERE COM_Codigo__c =:dc.ciudad]);
        if(!lstCiudad.isEmpty()){
            caso.RF2_CiudadHuerfano__c = lstciudad[0].Id;
        } else {
            system.debug('No se encontró la Ciudad.');
            //throw new RF2_CrearCasosException('No se encontró la Ciudad, consulte el administrador CRM.');
        }       
        caso.RF2_DireccionHuerfano__c = dc.direccion;

        List<Account> lstClientes = new List<Account>();
        List<Contact> lstContactos = new List<Contact>();
        List<AccountContactRelation> lstRelacion = new List<AccountContactRelation>();
        //los casos con noID igual a 1 o con numero de documento igual a 9999 son anónimos y se asignan a la cuenta creada como anónima
        if(dc.noID == '1' || dc.numeroDocumento == Label.RF2_NumeroIdentificacionClienteAnonimo_lbl){
            lstContactos = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numeroidentificacion__c = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl LIMIT 1];
            if(lstContactos.size() == 0){
                throw new RF2_CrearCasosException('No se encontró el Cliente Anónimo, consulte el administrador CRM.');
            }
            caso.AccountId = lstContactos.get(0).AccountId;
            caso.ContactId = lstContactos.get(0).Id;
        } else {
            //Si el caso no es anónimo se busca en SF
            lstClientes = [SELECT Id, Name FROM Account WHERE COM_TipoIdentificacion__c =: dc.tipoDocumento AND COM_Numero_de_identificacion__c =: dc.numeroDocumento LIMIT 1];
            if(lstClientes.size() > 0){
                caso.AccountId = lstClientes.get(0).Id;
                if(dc.tipoDocumento=='2'){
                    lstRelacion = [SELECT ContactId FROM AccountContactRelation WHERE AccountId = :lstClientes.get(0).Id LIMIT 1];
                    if(lstRelacion.size() > 0){
                        caso.ContactId = lstRelacion.get(0).ContactId;                        
                    } else {
                        caso.RF2_CompanyaHuerfano__c = dc.razonSocial;
                        //throw new RF2_CrearCasosException('El cliente no tiene un contacto asociado.');
                    }
                } else {
                   lstContactos = [SELECT Id FROM Contact WHERE COM_TipoIdentificacion__c =: dc.tipoDocumento AND COM_Numeroidentificacion__c = :dc.numeroDocumento AND AccountId =: lstClientes.get(0).Id LIMIT 1]; 
                    if(lstContactos.size() > 0){
                        caso.ContactId = lstContactos.get(0).Id;
                    } else {
                        caso.RF2_NombreContactoHuerfano__c = dc.primerNombre;
                        caso.RF2_NombreContactoHuerfano__c += !String.isBlank(dc.segundoNombre)?' '+dc.segundoNombre:'';
                        caso.RF2_NombreContactoHuerfano__c += ' '+dc.primerApellido;
                        caso.RF2_NombreContactoHuerfano__c += !String.isBlank(dc.segundoApellido)?' '+dc.segundoApellido:'';
                        //throw new RF2_CrearCasosException('El cliente no tiene un contacto asociado.');
                    }
                }
            } else {
                caso.RF2_TipoIdentificacionHuerfano__c = dc.tipoDocumento;
                caso.RF2_NumeroIdentificacionHuerfano__c = dc.numeroDocumento;
                caso.RF2_NombreContactoHuerfano__c = dc.primerNombre;
                caso.RF2_NombreContactoHuerfano__c += !String.isBlank(dc.segundoNombre)?' '+dc.segundoNombre:'';
                caso.RF2_NombreContactoHuerfano__c += ' '+dc.primerApellido;
                caso.RF2_NombreContactoHuerfano__c += !String.isBlank(dc.segundoApellido)?' '+dc.segundoApellido:'';
                caso.RF2_CompanyaHuerfano__c = dc.razonSocial;
                
            }
        }
        try{
            insert caso;
        } catch(Exception e) {
            throw new RF2_CrearCasosException(e.getMessage()); 
        }        
        system.debug('el caso- >'+caso);
        return caso.Id;
    }

}