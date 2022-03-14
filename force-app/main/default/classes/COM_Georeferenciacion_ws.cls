/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para constuir las transacciones para consumir los WS de Georeferenciacion
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_Georeferenciacion_ws {
	
	/* 
	* Nombre: consultarGeoreferenciacion
    * Descripcion: Metodo encargado de construir la transaccion e invocar el metodo para enviarla a Georeferenciacion
    * Fecha Creación: 28/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            28-Jul-2017     Juan David Uribe Ruiz       Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public GeoreferenciacionWrapper consultarGeoreferenciacion(Account objCuenta, Integer intMunicipio){
		COM_WrapperGeoreferenciaRequest_cls objWrapperGeoreferenciaRequest;
		COM_WrapperGeoreferenciaRequest_cls.Georeferencia_Request objRequest;
		COM_WrapperGeoreferenciaRequest_cls.Body objBody;
		COM_WrapperGeoreferenciaResponse_cls objWrapperGeoreferenciaResponse;
		GeoreferenciacionWrapper objGeoreferenciacionWrapper;
		
		objRequest = new COM_WrapperGeoreferenciaRequest_cls.Georeferencia_Request();
		
		objRequest.Header = COM_UtilidadWebService_cls.obtenerCabecera(label.COM_Header_Georeferenciacion);
		
		objWrapperGeoreferenciaRequest = new COM_WrapperGeoreferenciaRequest_cls();
		objBody = new COM_WrapperGeoreferenciaRequest_cls.Body();
		objBody.Direccion = objCuenta.COM_Direccion__c;
		objBody.Municipio = intMunicipio;
		objRequest.Body = objBody;
		objWrapperGeoreferenciaRequest.Georeferencia_Request = objRequest;
		
		try{ 
			objWrapperGeoreferenciaResponse = (COM_WrapperGeoreferenciaResponse_cls)COM_UtilidadWebService_cls.consumirWS(objWrapperGeoreferenciaRequest, label.COM_WS_Georeferenciacion, COM_WrapperGeoreferenciaResponse_cls.class, objCuenta.Id);
			system.debug('-------------> ' + objWrapperGeoreferenciaResponse);
		} catch(COM_WebServiceException e){
			throw new COM_GeoreferenciacionException(e.getMessage());
		} catch(Exception e){
			throw new COM_GeoreferenciacionException(e.getMessage());
		}
		
		if(objWrapperGeoreferenciaResponse != null){
			objGeoreferenciacionWrapper = new GeoreferenciacionWrapper();
			objGeoreferenciacionWrapper.strDireccionEstandarizada = objWrapperGeoreferenciaResponse.Georeferencia_Response.Body.DireccionEstandarizada;
			objGeoreferenciacionWrapper.strBarrio = objWrapperGeoreferenciaResponse.Georeferencia_Response.Body.Barrio;
			objGeoreferenciacionWrapper.strLocalidad = objWrapperGeoreferenciaResponse.Georeferencia_Response.Body.Localidad;
		}
		
		return objGeoreferenciacionWrapper;
	}
	
	public class GeoreferenciacionWrapper{
		public String strDireccionEstandarizada {get; set;}
		public String strBarrio {get; set;}
		public String strLocalidad {get; set;}
	}
    
}