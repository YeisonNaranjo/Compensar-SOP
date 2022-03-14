/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para constuir las transacciones para consultar metadata de documentos en OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_ConsultarMetaDataDocumentoOnBase_ws {
	
	//private COM_ConfiguracionEnvioDocs__c objConfiguracionEnvioDocs;
	
	public static list<MetaDataDocumentoWrapper> consultarMetaDataDocumentoOnBase(Account objCuenta, String strNroCaso, String strRadicadoOnBase, String strDocumentType, String strTipoConsulta){
		COM_WrapperConsMetadataDocResponse_cls objWrapperConsMetadataDocResponse;
		list<MetaDataDocumentoWrapper> lstMetaDataDocumentoWrapper;
		list<COM_WrapperConsMetadataDocResponse_cls.Document_x> lstDocument_x;
		MetaDataDocumentoWrapper objMetaDataDocumentoWrapper;
		String strXMLRequest;
		String strXMLResponse;
		String strCodRespuesta;
		
		if(objCuenta == null){
			//Se retorna error indicando que la cuenta llego nula
		}
		
		lstMetaDataDocumentoWrapper = new list<MetaDataDocumentoWrapper>();
		
		strXMLRequest = construirXMLOnBase(objCuenta, strNroCaso, strRadicadoOnBase, strDocumentType, strTipoConsulta);
		system.debug('strXMLRequest: ' + strXMLRequest);
		system.debug('=====================');
		
		try{
			strXMLResponse = COM_UtilidadWebService_cls.consumirWS(label.COM_WS_ConsultarMetaDataDocumentoOnBase, strXMLRequest, objCuenta.Id);
			system.debug('strXMLResponse: ' + strXMLResponse);
		} catch(Exception e){
			System.Debug('============== EXCEPCION [COM_ConsultarMetaDataDocumentoOnBase_ws] ==============');
			System.debug( e.getMessage() + ' ' + e.getStackTraceString());
			System.Debug('=================================================================================');
			strXMLResponse = null;
			throw new COM_OnBaseException('Ocurrió un error con el servicio de OnBase');
		}
		
		if(strXMLResponse != null){
			Dom.Document domDocument = new Dom.Document();
			domDocument.load(strXMLResponse);
			Map<Object, Object> mapJson = COM_XmlToJson2_cls.parseDocumentToMap(domDocument);
			COM_Utilidades_cls.convertItemToList(mapJson, 'Document');
			COM_Utilidades_cls.convertItemToList(mapJson, 'Document_x');
			String strJSON = JSON.serialize(mapJson);
			system.debug('strJson: ' + strJson);
			objWrapperConsMetadataDocResponse = (COM_WrapperConsMetadataDocResponse_cls)JSON.deserialize(strJSON, COM_WrapperConsMetadataDocResponse_cls.class);
			system.debug('objWrapperConsMetadataDocResponse: ' + objWrapperConsMetadataDocResponse);
			
			if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs != null){
				if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs != null){
					if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse != null){
						if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult != null){
							if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml != null){
								if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response != null){
									if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code != null){
										strCodRespuesta = objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code;
										if(strCodRespuesta.equals('00')){
											system.debug('****** METADATA DOCUMENTO CONSULTADO EN ONBASE ******');
											if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result != null){
												if(objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document != null 
													&& !objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document.isEmpty()){
													for(COM_WrapperConsMetadataDocResponse_cls.Document objDocument : objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document){
														objMetaDataDocumentoWrapper = new MetaDataDocumentoWrapper();
														lstDocument_x = objDocument.Document_x;
														/*objMetaDataDocumentoWrapper.strIdDocumento = objDocument.id;
														objMetaDataDocumentoWrapper.strNombreDocumento = objDocument.name;
														objMetaDataDocumentoWrapper.strDocumentType = objDocument.DocumentType.DocumentType;
														objMetaDataDocumentoWrapper.strDateStored = objDocument.DateStored;*/
														objMetaDataDocumentoWrapper.strIdDocumento = lstDocument_x.get(0).attributtes.id;
														objMetaDataDocumentoWrapper.strNombreDocumento = lstDocument_x.get(0).attributtes.name;
														objMetaDataDocumentoWrapper.strDocumentType = objDocument.DocumentType_x.value;
														objMetaDataDocumentoWrapper.strDateStored = objDocument.DateStored;
														lstMetaDataDocumentoWrapper.add(objMetaDataDocumentoWrapper);
													}
													
													if(!lstMetaDataDocumentoWrapper.isEmpty()){
														return lstMetaDataDocumentoWrapper;
													}
												} else{
													system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document ESTA NULO O VACIO ******');
													return null;
												}
											}
										} else{
											//Error
											system.debug('****** ONBASE DIO RESPUESTA FALLIDA A LA CREACION DEL DOCUMENTO ******');
											return null;
										}
									} else{
										system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code ESTA NULO ******');
										return null;
									}
								} else{
									system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response ESTA NULO ******');
									return null;
								}
							} else{
								system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml ESTA NULO ******');
								return null;
							}
						} else{
							system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult ESTA NULO ******');
							return null;
						}
					} else{
						system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse ESTA NULO ******');
						return null;
					}
				} else{
					system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs ESTA NULO ******');
					return null;
				}
			} else{
				system.debug('****** objWrapperConsMetadataDocResponse.Body.WsDocServ_ExecuteOnBase_Rs ESTA NULO ******');
				return null;
			}
		} else{
			system.debug('****** strXMLResponse ESTA NULO ******');
			return null;
		}
		
		return null;
	}
	
	
	private static String construirXMLOnBase(Account objCuenta, String strNroCaso, String strRadicadoOnBase, String strDocumentType, String strTipoConsulta){
		/* Inicio 2.0 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 2.0 */
        
		return '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.compensar.com/Common/WS/DocumentServices/ExecuteOnBase/IN/v1.0" xmlns:wsr="http://www.compensar.com.co/webservices/commons/WsRequestHeader" xmlns:v11="http://www.compensar.com/OnBaseServices/Execute/Request/v1.0">'
				+ '<soapenv:Header/>'
				+ '<soapenv:Body>'
					+ '<v1:WsDocServ_ExecuteOnBase_Rq>'
            			/* Inicio 2.0 */
						//+ COM_UtilidadWebService_cls.obtenerCabeceraXML(label.COM_Header_ConsultarMetaDataDocumentoOnBase)
						+ COM_UtilidadWebService_cls.obtenerCabeceraXML(label.COM_Header_ConsultarMetaDataDocumentoOnBase, user_Identificacion)
            			/* Fin 2.0 */
						+ '<v11:OnBaseServ_Execute_Rq>'
							+ '<v11:Execute>'
								+ '<v11:xmlCommand><![CDATA[' + construirXML_CDATA(objCuenta, strNroCaso, strRadicadoOnBase, strDocumentType, strTipoConsulta) + ']]></v11:xmlCommand>'
							+ '</v11:Execute>'
						+ '</v11:OnBaseServ_Execute_Rq>'
					+ '</v1:WsDocServ_ExecuteOnBase_Rq>'
				+ '</soapenv:Body>'
			+ '</soapenv:Envelope>';
	}
	
	private static String construirXML_CDATA(Account objCuenta, String strNroCaso, String strRadicadoOnBase, String strDocumentType, String strTipoConsulta){
		list<COM_ConfiguracionOpcionesListas__mdt> lstConfiguracionOpcionesListas;
		String strKeyWords;
		List<String> lstKeyWords = new List<String>();
		String strXML_CDATA;
		
		system.debug('---->>>> strNroCaso: ' + strNroCaso);
		system.debug('---->>>> strRadicadoOnBase: ' + strRadicadoOnBase);
		
		lstConfiguracionOpcionesListas = [SELECT COM_Valor__c, COM_KeyWords__c FROM COM_ConfiguracionOpcionesListas__mdt WHERE COM_Valor__c = :strDocumentType];
		
		if(lstConfiguracionOpcionesListas.isEmpty()){
			throw new COM_OnBaseException('No se encontro la configuración para el documento: ' + strDocumentType);
		} else if(String.isBlank(lstConfiguracionOpcionesListas.get(0).COM_KeyWords__c)){
			throw new COM_OnBaseException('No se han configurado KeyWords para el documento: ' + strDocumentType);
		}
		strKeyWords = '';
		//strKeyWords = lstConfiguracionOpcionesListas.get(0).COM_KeyWords__c;
		//\u003E
		
		lstKeyWords = lstConfiguracionOpcionesListas.get(0).COM_KeyWords__c.split('\\|');
		system.debug('lstKeyWords-------------'+lstKeyWords);
		system.debug('lstConfiguracionOpcionesListas.get(0).COM_KeyWords__c-------------'+lstConfiguracionOpcionesListas.get(0).COM_KeyWords__c);
		for(String str : lstKeyWords){
			if(str.contains('%numeroDocumento%')){
				if(String.isNotBlank(objCuenta.COM_Numero_de_identificacion__c)){
					strKeyWords += str.replace('%numeroDocumento%', objCuenta.COM_Numero_de_identificacion__c);	
				}
			} else if(str.contains('%tipoDocumento%')){
				if(String.isNotBlank(objCuenta.COM_TipoIdentificacion__c)){
					strKeyWords += str.replace('%tipoDocumento%', objCuenta.COM_TipoIdentificacion__c);
				}
			} else if(str.contains('%numeroCaso%')){
				if(String.isNotBlank(strNroCaso)){
					strKeyWords += str.replace('%numeroCaso%', strNroCaso);
				}
			} else if(str.contains('%numeroRadicadoOnBase%')){
				if(String.isNotBlank(strRadicadoOnBase)){
					strKeyWords += str.replace('%numeroRadicadoOnBase%', strRadicadoOnBase);
				}
			}
		}
		/*
		strKeyWords = strKeyWords.replace('%numeroDocumento%', objCuenta.COM_Numero_de_identificacion__c);
		strKeyWords = strKeyWords.replace('%tipoDocumento%', objCuenta.COM_TipoIdentificacion__c);
		strKeyWords = strKeyWords.replace('%numeroCaso%', strNroCaso);
		strKeyWords = strKeyWords.replace('%numeroRadicadoOnBase%', strRadicadoOnBase);
		*/
		system.debug('====>>>>> strTipoConsulta: ' + strTipoConsulta);
		system.debug('====>>>>> strKeyWords: ' + strKeyWords);
		
		if(strTipoConsulta.equals('Document Type Name')){
			strXML_CDATA = '<Request>'
								+ '<Type>DocumentQuery</Type>'
								+ '<Query>'
									+ '<DocumentTypeName>' + strDocumentType + '</DocumentTypeName>'
									+ '<Keywords>'
										+ strKeyWords
									+ '</Keywords>'
									+ '<LoadKeywords>False</LoadKeywords>'
								+ '</Query>'
							+ '</Request>';
		} else if(strTipoConsulta.equals('Agrupacion Familias')){
			strXML_CDATA = '<Request>'
								+ '<Type>DocumentQuery</Type>'
								+ '<Query>'
									+ '<DocumentTypeName/>'
									+ '<customQueryName>' + strDocumentType + '</customQueryName>'
									+ '<Keywords>'
										+ strKeyWords
									+ '</Keywords>'
									+ '<LoadKeywords>False</LoadKeywords>'
								+ '</Query>'
							+ '</Request>';
		}
		 
		return strXML_CDATA;
	}
	
	public class MetaDataDocumentoWrapper{
		public String strIdDocumento {get; set;}
		public String strNombreDocumento {get; set;}
		public String strDocumentType {get; set;}
		public String strDateStored {get; set;}
	}
    
}