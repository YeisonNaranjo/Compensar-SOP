/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para constuir las transacciones para enviar documentos a OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    22/08/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   1.1    24/09/2019      Paula Bohórquez                     Migración Lightning - Se cambian Attachments por Content Documents
* @version   1.2    07/01/2021      Stifen Panche                       Se revisa que el linkedentityid a asociar a la trasnsacción sea de un Caso.
* @version   2.0	28/12/2020		Santiago Contreras (SC)				Se modifica la clase CrearDocumentoOnBase2 para que no realice consultas SOQL
* @version   3.0	03/03/2021		Yeison Stic Naranjo					Ajuste 201 queries
* @version   3.1    29/11/2021      Alvaro Gomez 						creacion Metodo Envio Documentos por soporte 
****************************************************************************************************************/
public with sharing class COM_CrearDocumentoOnBase_ws {
    
    private static COM_ConfiguracionEnvioDocsM__mdt objConfiguracionEnvioDocs;
    
    @Future(callout=true)
    public static void crearDocumentoOnBase(Id idAttachment, Id idConfiguracionEnvioDocs){
   
        list<ContentVersion> lstContentVersion;
        ContentVersion objContentVersion;
        
        
        //list<Attachment> lstAttachment;
        //Attachment objAttachment;
        ////Attachme//nt objAttachment;
        //lstContentVersion lstContentVersion;
        List<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        COM_WrapperCrearDocumentoGCResponse_cls objWrapperCrearDocumentoGCResponse;
        String strXMLRequest;
        String strXMLResponse;
        String strCodRespuesta;
        String strDescripcionLog;
        
        lstConfig = [SELECT COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c, developerName 
                     FROM COM_ConfiguracionEnvioDocsM__mdt 
                     WHERE Id =: idConfiguracionEnvioDocs];
        
        /* Inicio 3.0 */
        String strUuserIdentificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 3.0 */
        
        if(lstConfig.isEmpty()){
            //Error indicando que no llego la configuracion para el envio del archivo
            system.debug('****** NO SE ENCONTRO LA COM_ConfiguracionEnvioDocs__c POR LO TANTO NO SE PUEDE ENVIAR EL DOCUMENTO A ONBASE ******');
            return;
        }
        
        objConfiguracionEnvioDocs = lstConfig.get(0);
        System.debug('--->>> PBAVX ID ATTACHMENT : '+idAttachment);
        //lstAttachment = [SELECT Id, ContentType, Name, Body, ParentId, Parent.Type FROM Attachment WHERE Id = :idAttachment];
        lstContentVersion = [SELECT Id, FileType,Title,VersionData,ContentDocumentId FROM ContentVersion WHERE Id = :idAttachment];
       
        if(lstContentVersion.isEmpty()){
        //if(lstAttachment.isEmpty()){
            //Error indicando que no se encontro el archivo adjunto 
            system.debug('****** NO SE ENCONTRO LA EL ARCHIVO ADJUNTO [Attachment] POR LO TANTO NO SE PUEDE ENVIAR EL DOCUMENTO A ONBASE ******');
            return;
        }
        
        //objAttachment = lstAttachment.get(0);
        //obContentVersion//meContentVersion = lstAttachment.get(0);
        objContentVersion = lstContentVersion.get(0);
        
        try{
            /* Inicio 3.0 */
            //strXMLRequest = construirXMLOnBase(lstContentVersion.get(0));
            strXMLRequest = construirXMLOnBase(lstContentVersion.get(0), strUuserIdentificacion);
            /* Fin 3.0 */
        } catch(Exception e){
            system.debug('****** ERROR AL CREAR EL XML DE REQUEST PARA ENVIAR EL DOCUMENTO A ONBASE ******');
            return;
        }
        system.debug(strXMLRequest);
        system.debug('=====================');
        try{
            //strXMLResponse = COM_UtilidadWebService_cls.consumirWS(label.COM_WS_CrearDocumentoOnBase, strXMLRequest, objAttachment.Id);
            //strXMLResponse = ContentVersion.conContentVersion(label.COM_WS_CrearDocumentoOnBase, strXMLRequest, objAttach//ment.Id);
            strXMLResponse = COM_UtilidadWebService_cls.consumirWS(label.COM_WS_CrearDocumentoOnBase, strXMLRequest, objContentVersion.Id);
            system.debug('strXMLResponse: ' + strXMLResponse);
        } catch(Exception e){
            System.Debug('============== EXCEPCION [COM_CrearDocumentoOnBase_ws] ==============');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=====================================================================');
            strXMLResponse = null;
            strDescripcionLog = e.getMessage() + ' ' + e.getStackTraceString();
        }
        
        try{
            COM_LogTransacciones__c objLog = new COM_LogTransacciones__c();
        
            objLog.COM_AttachmentId__c = objContentVersion.Id;
            //objLog.COM_AttachmentId__c = objAttachment.Id;
            //objLog.COM_AttachmContentVersion = oContentVersion//ment.Id;
            objLog.COM_FechaTransaccion__c = Datetime.now();
            objLog.COM_Request__c = strXMLRequest.abbreviate(131000);
            objLog.COM_Response__c = strXMLResponse.abbreviate(131000);
            objLog.COM_TipoTransaccion__c = label.COM_WS_CrearDocumentoOnBase;
            objLog.COM_Descripcion__c = strDescripcionLog;
            insert objLog;
        } catch(Exception e){
            system.debug('..... NO SE PUDO CREAR EL REGISTRO DE LOG PARA ' + label.COM_WS_CrearDocumentoOnBase + ': ' + e.getMessage());
        }
        
        if(strXMLResponse != null){
            objWrapperCrearDocumentoGCResponse = (COM_WrapperCrearDocumentoGCResponse_cls)COM_XmlToJson_cls.parseDocumentToObject(strXMLResponse, COM_WrapperCrearDocumentoGCResponse_cls.class);
            system.debug('El Objeto: ' + objWrapperCrearDocumentoGCResponse);
            if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs != null){
                if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs != null){
                    if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse != null){
                        if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult != null){
                            if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml != null){
                                if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response != null){
                                    if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code != null){
                                        strCodRespuesta = objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code;
                                        if(strCodRespuesta.equals('00')){
                                            system.debug('****** DOCUMENTO CREADO EN ONBASE ******');
                                        } else{
                                            //Error
                                            system.debug('****** ONBASE DIO RESPUESTA FALLIDA A LA CREACION DEL DOCUMENTO ******');
                                        }
                                    } else{
                                        system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code ESTA NULO ******');
                                    }
                                } else{
                                    system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response ESTA NULO ******');
                                }
                            } else{
                                system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml ESTA NULO ******');
                            }
                        } else{
                            system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult ESTA NULO ******');
                        }
                    } else{
                        system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse ESTA NULO ******');
                    }
                } else{
                    system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs ESTA NULO ******');
                }
            } else{
                system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs ESTA NULO ******');
            }
        } else{
            system.debug('****** strXMLResponse ESTA NULO ******');
        }
        
    }
    
    /** metodo de envio por soporte - cartas de afiliacion*/
    //3.1 
    @Future(callout=true)
    public static void crearDocumentoOnBaseSupport(Id idAttachment, Id idConfiguracionEnvioDocs, String idUsuario ){
   
        list<ContentVersion> lstContentVersion;
        ContentVersion objContentVersion;
        
        
        //list<Attachment> lstAttachment;
        //Attachment objAttachment;
        ////Attachme//nt objAttachment;
        //lstContentVersion lstContentVersion;
        List<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        COM_WrapperCrearDocumentoGCResponse_cls objWrapperCrearDocumentoGCResponse;
        String strXMLRequest;
        String strXMLResponse;
        String strCodRespuesta;
        String strDescripcionLog;
        
        lstConfig = [SELECT COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c, developerName 
                     FROM COM_ConfiguracionEnvioDocsM__mdt 
                     WHERE Id =: idConfiguracionEnvioDocs];
        
        
        String strUuserIdentificacion = idUsuario ;
                
        if(lstConfig.isEmpty()){
            //Error indicando que no llego la configuracion para el envio del archivo
            system.debug('****** NO SE ENCONTRO LA COM_ConfiguracionEnvioDocs__c POR LO TANTO NO SE PUEDE ENVIAR EL DOCUMENTO A ONBASE ******');
            return;
        }
        
        objConfiguracionEnvioDocs = lstConfig.get(0);
        System.debug('--->>> PBAVX ID ATTACHMENT : '+idAttachment);
        lstContentVersion = [SELECT Id, FileType,Title,VersionData,ContentDocumentId FROM ContentVersion WHERE Id = :idAttachment];
       
        if(lstContentVersion.isEmpty()){
        //if(lstAttachment.isEmpty()){
            //Error indicando que no se encontro el archivo adjunto 
            system.debug('****** NO SE ENCONTRO LA EL ARCHIVO ADJUNTO [Attachment] POR LO TANTO NO SE PUEDE ENVIAR EL DOCUMENTO A ONBASE ******');
            return;
        }
        
        //objAttachment = lstAttachment.get(0);
        //obContentVersion//meContentVersion = lstAttachment.get(0);
        objContentVersion = lstContentVersion.get(0);
        
        try{
            /* Inicio 3.0 */
            //strXMLRequest = construirXMLOnBase(lstContentVersion.get(0));
            strXMLRequest = construirXMLOnBase(lstContentVersion.get(0), strUuserIdentificacion);
            /* Fin 3.0 */
        } catch(Exception e){
            system.debug('****** ERROR AL CREAR EL XML DE REQUEST PARA ENVIAR EL DOCUMENTO A ONBASE ******');
            return;
        }
        system.debug('strXMLRequest');
        system.debug(strXMLRequest);
        system.debug('=====================');
        try{
            strXMLResponse = COM_UtilidadWebService_cls.consumirWSSupport(label.COM_WS_CrearDocumentoOnBase, strXMLRequest, objContentVersion.Id);
            system.debug('strXMLResponse: ' + strXMLResponse);
        } catch(Exception e){
            System.Debug('============== EXCEPCION [COM_CrearDocumentoOnBase_ws] ==============');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=====================================================================');
            strXMLResponse = null;
            strDescripcionLog = e.getMessage() + ' ' + e.getStackTraceString();
        }

        
        if(strXMLResponse != null){
            objWrapperCrearDocumentoGCResponse = (COM_WrapperCrearDocumentoGCResponse_cls)COM_XmlToJson_cls.parseDocumentToObject(strXMLResponse, COM_WrapperCrearDocumentoGCResponse_cls.class);
            system.debug('El Objeto: ' + objWrapperCrearDocumentoGCResponse);
            if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs != null){
                if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs != null){
                    if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse != null){
                        if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult != null){
                            if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml != null){
                                if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response != null){
                                    if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code != null){
                                        strCodRespuesta = objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code;
                                        if(strCodRespuesta.equals('00')){
                                            system.debug('****** DOCUMENTO CREADO EN ONBASE ******');
                                        } else{
                                            //Error
                                            system.debug('****** ONBASE DIO RESPUESTA FALLIDA A LA CREACION DEL DOCUMENTO ******');
                                        }
                                    } else{
                                        system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code ESTA NULO ******');
                                    }
                                } else{
                                    system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response ESTA NULO ******');
                                }
                            } else{
                                system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml ESTA NULO ******');
                            }
                        } else{
                            system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult ESTA NULO ******');
                        }
                    } else{
                        system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse ESTA NULO ******');
                    }
                } else{
                    system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs ESTA NULO ******');
                }
            } else{
                system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs ESTA NULO ******');
            }
        } else{
            system.debug('****** strXMLResponse ESTA NULO ******');
        }
        
    }

///Fin ajuste por funcion envio documentos por soporte
//
//
    /* Inicio 3.0 */
    //private static String construirXMLOnBase(ContentVersion objContentVersion){
    private static String construirXMLOnBase(ContentVersion objContentVersion, String user_Identificacion){
    /* Inicio 3.0 */
    //private static String construirXMLOnBase(Attachment objAttachment){
        
        return '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.compensar.com/Common/WS/DocumentServices/ExecuteOnBase/IN/v1.0" xmlns:wsr="http://www.compensar.com.co/webservices/commons/WsRequestHeader" xmlns:v11="http://www.compensar.com/OnBaseServices/Execute/Request/v1.0">'
                       + '<soapenv:Header/>'
                       + '<soapenv:Body>'
                          + '<v1:WsDocServ_ExecuteOnBase_Rq>'
            /* Inicio 3.0 */
                            // + COM_UtilidadWebService_cls.obtenerCabeceraXML(label.COM_Header_CrearDocumentoOnBase)
                             + COM_UtilidadWebService_cls.obtenerCabeceraXML(label.COM_Header_CrearDocumentoOnBase, user_Identificacion)
             /* Fin 3.0 */
                             + '<v11:OnBaseServ_Execute_Rq>'
                                + '<v11:Execute>'
                                   + '<v11:xmlCommand><![CDATA['+construirXML_CDATA(objContentVersion)+']]></v11:xmlCommand>'
                                   //+ '<v11:xmlCommand><![CDATA['+construirXML_CDATA(objAttachment)+']]></v11:xmlCommand>'
                                + '</v11:Execute>'
                             + '</v11:OnBaseServ_Execute_Rq>'
                          + '</v1:WsDocServ_ExecuteOnBase_Rq>'
                       + '</soapenv:Body>'
                    + '</soapenv:Envelope>';
        
    }
    
    private static String construirXML_CDATA(ContentVersion objContentVersion){
   // private static String construirXML_CDATA(Attachment objAttachment){
        list<Account> lstCuentas;
        list<Opportunity> lstOpportunity;
        list<Quote> lstQuote;
        list<COM_Actas__c> lstActas;
        list<Case> lstCasos;
        Account objCuenta;
        SObject objData;
        String strNumeroDocumento;
        String strTipoDocumento;
        String strExtension;
        
        strNumeroDocumento = '';
        strTipoDocumento = '';
        strExtension = '';
        
        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
        for(ContentDocumentLink objCDL : [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId =: objContentVersion.ContentDocumentId]){
            if(objCDL.LinkedEntityId.getSObjectType() != User.getSObjectType()){
                objContentDocumentLink = objCDL;
                break;
            }
        }
        //if(objAttachment.ParentId.getSObjectType() == Account.SobjectType){
        System.debug('--->>CDLINK OBJECTTYPE : '+objContentDocumentLink.LinkedEntityId.getSObjectType());
        //System.debug('casos: ' + lstCasos.size());
        if(objContentDocumentLink.LinkedEntityId.getSObjectType() == Account.SobjectType){
            
            lstCuentas = [SELECT COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, Name 
                          FROM Account 
                          WHERE Id = :objContentDocumentLink.LinkedEntityId];
            if(lstCuentas.isEmpty()){
                //Error indicando que la cuenta no existe
            }
            
            objCuenta = lstCuentas.get(0);
            objData = lstCuentas.get(0);
            strNumeroDocumento = objCuenta.COM_Numero_de_identificacion__c;
            strTipoDocumento = objCuenta.COM_TipoIdentificacion__c + '';
            
        } else if(objContentDocumentLink.LinkedEntityId.getSObjectType() == Opportunity.SobjectType){
            
            lstOpportunity = [SELECT Id, AccountId, Account.Name, Account.COM_TipoIdentificacion__c, Account.COM_Numero_de_identificacion__c 
                              FROM Opportunity 
                              WHERE Id = :objContentDocumentLink.LinkedEntityId];
            
            if(lstOpportunity.isEmpty()){
                //Error indicando que la cuenta no existe
            }
            
            objData = lstOpportunity.get(0);
            strNumeroDocumento = lstOpportunity.get(0).Account.COM_Numero_de_identificacion__c;
            strTipoDocumento = lstOpportunity.get(0).Account.COM_TipoIdentificacion__c + '';
            
        } else if(objContentDocumentLink.LinkedEntityId.getSObjectType() == Case.SobjectType){
            
            lstCasos = [SELECT Id, AccountId, Account.Name, Account.COM_TipoIdentificacion__c, Account.COM_Numero_de_identificacion__c, RF2_NumeroIdentificacionHuerfano__c,
                            RF2_Anonimo__c, ContactId, Contact.COM_TipoIdentificacion__c, CaseNumber, RF2_NumeroRadicadoExterno__c, Contact.COM_Numeroidentificacion__c
                              FROM Case 
                              WHERE Id = :objContentDocumentLink.LinkedEntityId];
            
            if(lstCasos.isEmpty()){
                //Error indicando que la cuenta no existe
            }
            
            objData = lstCasos.get(0);
            strNumeroDocumento = lstCasos.get(0).Account.COM_Numero_de_identificacion__c;
            strTipoDocumento = lstCasos.get(0).Account.COM_TipoIdentificacion__c + '';
            
        } else if(objContentDocumentLink.LinkedEntityId.getSObjectType() == Quote.SobjectType){
            
            lstQuote = [SELECT Id, AccountId, Account.Name, Account.COM_TipoIdentificacion__c, Account.COM_Numero_de_identificacion__c 
                        FROM Quote 
                        WHERE Id = :objContentDocumentLink.LinkedEntityId];
            
            if(lstQuote.isEmpty()){
                //Error indicando que la cuenta no existe
            }
            
            objData = lstQuote.get(0);
            strNumeroDocumento = lstQuote.get(0).Account.COM_Numero_de_identificacion__c;
            strTipoDocumento = lstQuote.get(0).Account.COM_TipoIdentificacion__c + '';
            
        } else if(objContentDocumentLink.LinkedEntityId.getSObjectType() == COM_Actas__c.SobjectType){
            
            lstActas = [SELECT Id, COM_Cuenta__c, COM_Cuenta__r.Name, COM_Cuenta__r.COM_TipoIdentificacion__c, COM_Cuenta__r.COM_Numero_de_identificacion__c 
                        FROM COM_Actas__c 
                        WHERE Id = :objContentDocumentLink.LinkedEntityId];
            
            if(lstActas.isEmpty()){
                //Error indicando que la cuenta no existe
            }
            
            objData = lstActas.get(0);
            strNumeroDocumento = lstActas.get(0).COM_Cuenta__r.COM_Numero_de_identificacion__c;
            strTipoDocumento = lstActas.get(0).COM_Cuenta__r.COM_TipoIdentificacion__c + '';
            
        }
        String[] strNombreArchivo;
        /*String[] strNombreArchivo = objAttachment.Name.split('\\.');
        
        if(strNombreArchivo.size() < 1){
            //Archivo sin extension
            strExtension = '';
        } else{
            strExtension = strNombreArchivo[(strNombreArchivo.size()-1)];
        }*/

       // strExtension = objContentVersion.FileType;
        strExtension = getFileExtension(objContentVersion.FileType);
        
        list<COM_ConfiguracionKeyWordsOnBaseM__mdt> lstConfiguracionKeyWordsOnBase;
        
        system.debug('=========>>>>>>> objConfiguracionEnvioDocs.Name: ' + objConfiguracionEnvioDocs.developerName);
        lstConfiguracionKeyWordsOnBase = [SELECT COM_NombreApiCampo__c, COM_NombreDocumento__c, COM_NombreKeyWord__c 
                                          FROM COM_ConfiguracionKeyWordsOnBaseM__mdt 
                                          WHERE COM_NombreDocumento__c = :objConfiguracionEnvioDocs.developerName];
        system.debug('=========>>>>>>> lstConfiguracionKeyWordsOnBase: ' + lstConfiguracionKeyWordsOnBase);
        
        String strKeyWords;
        String strValorCampo;
        String[] strNombreApiCampo;
        
        strKeyWords = '';
        strValorCampo = '';
        for(COM_ConfiguracionKeyWordsOnBaseM__mdt objConfiguracionKeyWordsOnBase : lstConfiguracionKeyWordsOnBase){
            if(String.isBlank(objConfiguracionKeyWordsOnBase.COM_NombreApiCampo__c)){
                system.debug('********* NO SE VA A PROCESAR ESTE KEYWORD PORQUE NO TIENE COM_NombreApiCampo__c *********');
                continue;
            }
            system.debug('=========>>>>>>> objConfiguracionKeyWordsOnBase.COM_NombreApiCampo__c: ' + objConfiguracionKeyWordsOnBase.COM_NombreApiCampo__c);
            strNombreArchivo = objConfiguracionKeyWordsOnBase.COM_NombreApiCampo__c.split('\\.');
            system.debug('=========>>>>>>> strNombreApiCampo: ' + strNombreArchivo);
            if(objContentDocumentLink.LinkedEntityId.getSObjectType() == Case.SobjectType && 
                (objConfiguracionKeyWordsOnBase.COM_NombreKeyWord__c == Label.RF2_KeyWordCasoOnBase || objConfiguracionKeyWordsOnBase.COM_NombreKeyWord__c == Label.RF2_KeyWordCasoID)){            
                if(objData.get('RF2_Anonimo__c') == true){
                    system.debug('====== caso anónimo');
                    strValorCampo = Label.RF2_NumeroIdentificacionClienteAnonimo_lbl;
                } else if(objData.get('AccountId') == null && objData.get('ContactId') == null){
                    system.debug('====== caso huerfano');
                    if(objData.get('RF2_NumeroIdentificacionHuerfano__c') == null){
                        continue;
                    } else {
                        strValorCampo = (String)objData.get('RF2_NumeroIdentificacionHuerfano__c');     
                    }                    
                } else if(objData.get('ContactId') != null){
                    system.debug('====== caso contacto');
                    if(objData.getSobject('Contact').get('COM_Numeroidentificacion__c') == null){
                        continue;
                    } else {
                        strValorCampo = (String)objData.getSobject('Contact').get('COM_Numeroidentificacion__c');
                    }  
                } else if(objData.get('AccountId') != null){
                    system.debug('====== caso cuenta');
                    if(objData.getSobject('Account').get('COM_Numero_de_identificacion__c') == null){
                        continue;
                    } else {
                        strValorCampo = (String)objData.getSobject('Account').get('COM_Numero_de_identificacion__c');
                    } 
                }                                
            } else if(objContentDocumentLink.LinkedEntityId.getSObjectType() == Case.SobjectType && objConfiguracionKeyWordsOnBase.COM_NombreKeyWord__c == Label.RF2_KeyWordCasoDescripcion){
                if(objContentVersion.Title.left(3) == Label.RF2_PreNombreArchivoWeb) {
                    strValorCampo = Label.RF2_KeyWordCasoSoporte;
                } else {
                    strValorCampo = Label.RF2_KeyWordCasoRespuesta;        
                }
            }/* else if(objAttachment.ParentId.getSObjectType() == Case.SobjectType && 
                (objConfiguracionKeyWordsOnBase.COM_NombreKeyWord__c == 'Asesor' || objConfiguracionKeyWordsOnBase.COM_NombreKeyWord__c == 'Nombre lote')){
                strValorCampo = objAttachment.Name.left(3)+'---'+Datetime.now();
            }*/ else {
                if(strNombreArchivo.size() == 1){
                    strValorCampo = (String)objData.get(objConfiguracionKeyWordsOnBase.COM_NombreApiCampo__c);
                } else if(strNombreArchivo.size() > 1){
                    strValorCampo = (String)objData.getSobject(strNombreArchivo[0]).get(strNombreArchivo[1]);
                } else{
                    system.debug('********* NO SE VA A PROCESAR ESTE KEYWORD PORQUE COM_NombreApiCampo__c ESTA RARO *********');
                    continue;
                }
            }
            
            strKeyWords += '<Keyword name="'+objConfiguracionKeyWordsOnBase.COM_NombreKeyWord__c+'">'+strValorCampo+'</Keyword> ';
        }
        
        system.debug('=========>>>>>>> strKeyWords: ' + strKeyWords);
         System.debug('limits: ' + Limits.getHeapSize());
      /*  List<String> tipoArchivo = objAttachment.Name.split('.');
        system.debug('=========>>>>>>> tipoArchivo: ' + tipoArchivo);
        system.debug('=========>>>>>>> strExtension: ' + strExtension);
        system.debug('=========>>>>>>> tipoArchivo.size(): ' + tipoArchivo.size());
*/
        return '<Request>'
                    + '<Type>SaveDocument</Type>'
                    + '<Document>'
                        + '<DiskGroupName>' + objConfiguracionEnvioDocs.COM_DiskGroupName__c + '</DiskGroupName>'
                        + '<DocumentTypeName>' + objConfiguracionEnvioDocs.COM_DocumentTypeName__c + '</DocumentTypeName>'
                        + '<FileFormat>' + objConfiguracionEnvioDocs.COM_FileFormat__c + '</FileFormat>'
                        + '<FileExtension>'+strExtension+'</FileExtension>'
                        //+ '<FileFormat>' + strExtension!=''?strNombreArchivo[0]:'PDF' + '</FileFormat>'
                        //+ '<FileExtension>'+strExtension+'</FileExtension>'
                        + '<Keywords>'
                            + strKeyWords
                        + '</Keywords>'
                        + '<Pages>'
                            + '<Page>'+EncodingUtil.base64Encode(objContentVersion.VersionData)+'</Page>'
                        + '</Pages>'
                    + '</Document>'
                + '</Request>';
    }

    public static String  getFileExtension(String strFileType){
        System.debug('strFileType-->'+strFileType);
         if(strFileType.toLowerCase()=='pdf'){
             return 'pdf';
         }else if(strFileType.toLowerCase()=='msexcel' || strFileType.toLowerCase()=='EXCEL_X' ||strFileType.toLowerCase()=='EXCEL'){
            return 'xlsx'; 
         }else if(strFileType.toLowerCase()=='msword' ||strFileType.toLowerCase()=='WORD_X' || strFileType.toLowerCase()=='WORD'){
           return 'docx';  
         }else{
            return strFileType; 
         }
     }

	/* Inicio 3.0 */    
    //public static DTORespuesta crearDocumentoOnBase2(ContentVersion attachmentCV, COM_ConfiguracionEnvioDocsM__mdt ConfiguracionEnvioDocs, Id IdCasoDoc){
    public static DTORespuesta crearDocumentoOnBase2(ContentVersion attachmentCV, COM_ConfiguracionEnvioDocsM__mdt ConfiguracionEnvioDocs, Id IdCasoDoc, String user_Identificacion){
    /* Fin 3.0 */
        // list<Attachment> lstAttachment;
        // Attachment objAttachment;
        list<ContentVersion> lstContentVersion = new list<ContentVersion>();
        ContentVersion objContentVersion;
        List<COM_ConfiguracionEnvioDocsM__mdt> lstConfig= new List<COM_ConfiguracionEnvioDocsM__mdt>();
        COM_WrapperCrearDocumentoGCResponse_cls objWrapperCrearDocumentoGCResponse;
        String strXMLRequest;
        String strXMLResponse;
        String strCodRespuesta;
        String strDescripcionLog;
        DTORespuesta respuesta = new DTORespuesta();
        /*lstConfig = [SELECT COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c, developerName 
                     FROM COM_ConfiguracionEnvioDocsM__mdt 
                     WHERE Id =: idConfiguracionEnvioDocs];*///2.0 change
        if(ConfiguracionEnvioDocs != null){
        	lstConfig.add(ConfiguracionEnvioDocs);//2.0 se mantiene de esta forma para respetar el flujo de la clase.
        }
        if(lstConfig.isEmpty()){
            //Error indicando que no llego la configuracion para el envio del archivo
            system.debug('****** NO SE ENCONTRO LA COM_ConfiguracionEnvioDocs__c POR LO TANTO NO SE PUEDE ENVIAR EL DOCUMENTO A ONBASE ******');
            respuesta.resultado = false;
            return respuesta;
        }
        
        //objConfiguracionEnvioDocs = lstConfig.get(0); //ya no se tiene la consulta, se pasa el dato directamente.
        objConfiguracionEnvioDocs = ConfiguracionEnvioDocs;
        
        //lstAttachment = [SELECT Id, ContentType, Name, Body, ParentId, Parent.Type FROM Attachment WHERE Id = :idAttachment];
        //lstContentVersion = [SELECT Id, FileType,Title,VersionData,ContentDocumentId FROM ContentVersion WHERE Id = :idAttachment];
        //2.0 ya no se consulta en la clase, se pasa el valor directamente para evitar consultas repetitivas.
        lstContentVersion.add(attachmentCV);
        
       // if(lstAttachment.isEmpty()){
        if(lstContentVersion.isEmpty()){
            //Error indicando que no se encontro el archivo adjunto 
            system.debug('****** NO SE ENCONTRO LA EL ARCHIVO ADJUNTO [Attachment] POR LO TANTO NO SE PUEDE ENVIAR EL DOCUMENTO A ONBASE ******');
            respuesta.resultado = false;
            return respuesta;
        }
        
        //objAttachment = lstAttachment.get(0);
        objContentVersion = lstContentVersion.get(0);
        
        try{
            //strXMLRequest = construirXMLOnBase(lstAttachment.get(0));
            /* Inicio 3.0 */
            //strXMLRequest = construirXMLOnBase(lstContentVersion.get(0));
            System.debug('user_Identificacion: '+user_Identificacion);
            strXMLRequest = construirXMLOnBase(lstContentVersion.get(0), user_Identificacion);
            /* Fin 3.0 */ 
            System.debug('****** Se creó el XML para On Base');
        } catch(Exception e){
            system.debug('****** ERROR AL CREAR EL XML DE REQUEST PARA ENVIAR EL DOCUMENTO A ONBASE ****** '+ e.getMessage());
            respuesta.resultado = false;
            return respuesta;
        }
        system.debug(strXMLRequest);
        system.debug('=====================');
        //try{
            strXMLResponse = COM_UtilidadWebService_cls.consumirWS(label.COM_WS_CrearDocumentoOnBase, strXMLRequest, objContentVersion.Id);
            Cache.Org.remove('local.partition1.logs');
            system.debug('strXMLResponse: ' + strXMLResponse);
        /*} catch(Exception e){
            System.Debug('============== EXCEPCION [COM_CrearDocumentoOnBase_ws] ==============');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=====================================================================');
            strXMLResponse = null;
            strDescripcionLog = e.getMessage() + ' ' + e.getStackTraceString();
            Cache.Org.remove('local.partition1.logs');
        }*/
             
        /*Inicio 1.2*/
            //ContentDocumentLink objContentDocumentLink = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId  =: objContentVersion.ContentDocumentId LIMIT 1];
        /*    List<ContentDocumentLink> lstContentDocumentLink = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId  =: objContentVersion.ContentDocumentId];
         Id idCaso = null;
       
        for(ContentDocumentLink content : lstContentDocumentLink)
        {
            if(content.LinkedEntityId.getSobjectType() == Schema.Case.getSObjectType())
            {   idCaso = content.LinkedEntityId;
                break;
            }
        }*/
      
        /*Fin 1.2*/
        
        	COM_LogTransacciones__c objLog = new COM_LogTransacciones__c();
            objLog.COM_AttachmentId__c = objContentVersion.Id;
            objLog.COM_FechaTransaccion__c = Datetime.now();
            //objLog.COM_Request__c = strXMLRequest;
            objLog.COM_Request__c = strXMLRequest.left(2000);
            objLog.COM_Response__c = strXMLResponse;
            objLog.COM_TipoTransaccion__c = label.COM_WS_CrearDocumentoOnBase;
            objLog.COM_Descripcion__c = strDescripcionLog;
        	objLog.RF2_CasoId__c = IdCasoDoc;
           /*Inicio 1.2*/
            //objLog.RF2_CasoId__c = objContentDocumentLink.LinkedEntityId;
           /* if(idCaso != null)
            {
             objLog.RF2_CasoId__c = idCaso;
            }*/
            /*Fin 1.2*/


        if(strXMLResponse != null){
            objWrapperCrearDocumentoGCResponse = (COM_WrapperCrearDocumentoGCResponse_cls)COM_XmlToJson_cls.parseDocumentToObject(strXMLResponse, COM_WrapperCrearDocumentoGCResponse_cls.class);
            system.debug('El Objeto: ' + objWrapperCrearDocumentoGCResponse);
            if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs != null){
                if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs != null){
                    if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse != null){
                        if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult != null){
                            if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml != null){
                                if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response != null){
                                    if(objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code != null){
                                        strCodRespuesta = objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code;
                                        if(strCodRespuesta.equals('00')){
                                            system.debug('****** DOCUMENTO CREADO EN ONBASE ******');
                                            respuesta.resultado = true;
                                            respuesta.transaccion = objLog;
                                            return respuesta;
                                        } else{
                                            //Error
                                            system.debug('****** ONBASE DIO RESPUESTA FALLIDA A LA CREACION DEL DOCUMENTO ******');
                                        }
                                    } else{
                                        system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code ESTA NULO ******');
                                    }
                                } else{
                                    system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response ESTA NULO ******');
                                }
                            } else{
                                system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml ESTA NULO ******');
                            }
                        } else{
                            system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult ESTA NULO ******');
                        }
                    } else{
                        system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse ESTA NULO ******');
                    }
                } else{
                    system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs ESTA NULO ******');
                }
            } else{
                system.debug('****** objWrapperCrearDocumentoGCResponse.Body.WsDocServ_ExecuteOnBase_Rs ESTA NULO ******');
            }
        } else{
            system.debug('****** strXMLResponse ESTA NULO ******');
        }
        respuesta.resultado = false;
        respuesta.transaccion = objLog;
        return respuesta;
        
    }

    public class DTORespuesta{
        public Boolean resultado;
        public COM_LogTransacciones__c transaccion;
    }
}