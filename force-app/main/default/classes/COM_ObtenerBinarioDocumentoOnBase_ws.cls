/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para constuir las transacciones para consultar el binario de documentos en OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    30/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_ObtenerBinarioDocumentoOnBase_ws {
	
	public static BinarioDocumentoWrapper obtenerBinarioDocumentoOnBase(String strIdDocumento){
		COM_WrapperConsBinarioDocResponse_cls objWrapperConsBinarioDocResponse;
		BinarioDocumentoWrapper objBinarioDocumentoWrapper;
		String strXMLRequest;
		String strXMLResponse;
		String strCodRespuesta;
		
		strXMLRequest = construirXMLOnBase(strIdDocumento);
		system.debug('strXMLRequest: ' + strXMLRequest);
		system.debug('=====================');
		
		try{
			strXMLResponse = COM_UtilidadWebService_cls.consumirWS(label.COM_WS_ConsultarBiarioDocumentoOnBase, strXMLRequest, null);
			system.debug('strXMLResponse: ' + strXMLResponse);
		} catch(Exception e){
			System.Debug('============== EXCEPCION [COM_ObtenerBinarioDocumentoOnBase_ws] ==============');
			System.debug( e.getMessage() + ' ' + e.getStackTraceString());
			System.Debug('=================================================================================');
			strXMLResponse = null;
		}
		
		if(strXMLResponse != null){
			objWrapperConsBinarioDocResponse = (COM_WrapperConsBinarioDocResponse_cls)COM_XmlToJson_cls.parseDocumentToObject(strXMLResponse, COM_WrapperConsBinarioDocResponse_cls.class);
			system.debug('objWrapperConsBinarioDocResponse: ' + objWrapperConsBinarioDocResponse);
			
			if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs != null){
				if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs != null){
					if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse != null){
						if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult != null){
							if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml != null){
								if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response != null){
									if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code != null){
										strCodRespuesta = objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code;
										if(strCodRespuesta.equals('00')){
											objBinarioDocumentoWrapper = new BinarioDocumentoWrapper();
											if(objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document.Pages != null){
												objBinarioDocumentoWrapper.strBinario = objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document.Pages.Page_x.Page_x;
												objBinarioDocumentoWrapper.strExtension = objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document.Pages.Page_x.extension;
												objBinarioDocumentoWrapper.strNombre = objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document.name.replace(':', '');
												return objBinarioDocumentoWrapper;
											} else{
												system.debug('****** ONBASE DIO RESPUESTA EXITOSA 00  PERO CON MENSAJE DE ERROR '+ objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Result.Document.QueryError +' ******');
												return null;
											}
										} else{
											//Error
											system.debug('****** ONBASE DIO RESPUESTA FALLIDA A LA CONSULTA DEL BINARIO DEL DOCUMENTO ******');
											return null;
										}
									} else{
										system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response.Code ESTA NULO ******');
										return null;
									}
								} else{
									system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml.Response ESTA NULO ******');
									return null;
								}
							} else{
								system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult.xml ESTA NULO ******');
								return null;
							}
						} else{
							system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse.ExecuteResult ESTA NULO ******');
							return null;
						}
					} else{
						system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs.ExecuteResponse ESTA NULO ******');
						return null;
					}
				} else{
					system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs.OnBaseServ_Execute_Rs ESTA NULO ******');
					return null;
				}
			} else{
				system.debug('****** objWrapperConsBinarioDocResponse.Body.WsDocServ_ExecuteOnBase_Rs ESTA NULO ******');
				return null;
			}
		} else{
			system.debug('****** strXMLResponse ESTA NULO ******');
			return null;
		}
		
		return null;
	}
	
	private static String construirXMLOnBase(String strDocumentHandle){
		/* Inicio 2.0 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 2.0 */
        
		return '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.compensar.com/Common/WS/DocumentServices/ExecuteOnBase/IN/v1.0" xmlns:wsr="http://www.compensar.com.co/webservices/commons/WsRequestHeader" xmlns:v11="http://www.compensar.com/OnBaseServices/Execute/Request/v1.0">'
				+ '<soapenv:Header/>'
				+ '<soapenv:Body>'
					+ '<v1:WsDocServ_ExecuteOnBase_Rq>'
						+ COM_UtilidadWebService_cls.obtenerCabeceraXML(label.COM_Header_ConsultarBiarioDocumentoOnBase, user_Identificacion)
						+ '<v11:OnBaseServ_Execute_Rq>'
							+ '<v11:Execute>'
								+ '<v11:xmlCommand><![CDATA[' + construirXML_CDATA(strDocumentHandle) + ']]></v11:xmlCommand>'
							+ '</v11:Execute>'
						+ '</v11:OnBaseServ_Execute_Rq>'
					+ '</v1:WsDocServ_ExecuteOnBase_Rq>'
				+ '</soapenv:Body>'
			+ '</soapenv:Envelope>';
	}
	
	private static String construirXML_CDATA(String strDocumentHandle){
		
		return '<Request>'
					+ '<Type>DocumentData</Type>'
					+ '<Query>'
						+ '<DocumentHandle>' + strDocumentHandle + '</DocumentHandle>'
						+ '<LoadKeywords>False</LoadKeywords>'
					+ '</Query>'
				+ '</Request>';
	}
	
	public class BinarioDocumentoWrapper{
		public String strBinario {get; set;}
		public String strExtension {get; set;}
		public String strNombre {get; set;}
	}
    
}