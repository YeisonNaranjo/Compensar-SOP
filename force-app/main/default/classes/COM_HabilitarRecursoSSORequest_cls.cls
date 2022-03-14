/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase donde se crea el Request de web service SSO

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
public with sharing class COM_HabilitarRecursoSSORequest_cls 
{
	/**
	 * @version 1.0
	 * @description Se crea el request del servicio
	 * @param String strIdUsuario => Id del SSO del usuario
	 * @return HttpRequest => Request armado
	 **/	
	public HttpRequest crearRequest(String strIdUsuario)
	{
		COM_ConfiguracionSSOM__mdt objSettingService = [SELECT COM_AplicacionClienteSSO__c,COM_AplicacionDestinoSSO__c,COM_DelegadoDepSSO__c,COM_EndPointSSO__c,
															COM_idAplicacionSSO__c,COM_NormalizarSSO__c,COM_OrgSSO__c,COM_PasswordSSO__c,
															COM_strTidUsuarioSSO__c,COM_UserNameSSO__c,COM_ActionSSO__c
													FROM COM_ConfiguracionSSOM__mdt Limit 1];

		HttpRequest objHttpRequest  =   new HttpRequest();
        objHttpRequest.setEndpoint(objSettingService.COM_EndPointSSO__c);
        objHttpRequest.setMethod('POST');
        objHttpRequest.setHeader('Content-Type', 'text/xml;charset=utf-8'); 
        objHttpRequest.setHeader('SOAPAction', objSettingService.COM_ActionSSO__c);
        //objHttpRequest.setHeader('Authorization', objSettingServices.strBasicAuthentication);                
        system.debug('objRequest: ' + objHttpRequest);

		String strXML =	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://www.tibco.com/schemas/CompensarLEH/Resources/EIM/Common/ServiceCommon.xsd" xmlns:wseg="http://WSeguridad/">';
			strXML+= '<soapenv:Header>';
				strXML+= '<ser:headerMessage>';
					strXML+= '<ser:userName>'+objSettingService.COM_UserNameSSO__c+'</ser:userName>';
					strXML+= '<ser:password>'+objSettingService.COM_PasswordSSO__c+'</ser:password>';
					strXML+= '<ser:idAplicacion>'+objSettingService.COM_idAplicacionSSO__c+'</ser:idAplicacion>';
					strXML+= '<ser:transactionID/>';
				strXML+= '</ser:headerMessage>';
			strXML+= '</soapenv:Header>';
			strXML+='<soapenv:Body>';
				strXML+='<wseg:HabilitarRecurso>';
					strXML+='<wseg:RecursoAutilizar/>';
					strXML+='<wseg:strTidUsuario>'+objSettingService.COM_strTidUsuarioSSO__c+'</wseg:strTidUsuario>';
					strXML+='<wseg:strIdUsuario>'+strIdUsuario+'</wseg:strIdUsuario>';
					strXML+='<wseg:Delegado_Dep>'+objSettingService.COM_DelegadoDepSSO__c+'</wseg:Delegado_Dep>';
					strXML+='<wseg:org>'+objSettingService.COM_OrgSSO__c+'</wseg:org>';
					strXML+='<wseg:strTicket/>';
					strXML+='<wseg:aplicacionCliente>'+objSettingService.COM_AplicacionClienteSSO__c+'</wseg:aplicacionCliente>';
					strXML+='<wseg:aplicacionDestino>'+objSettingService.COM_AplicacionDestinoSSO__c+'</wseg:aplicacionDestino>';
					strXML+='<wseg:normalizar>'+objSettingService.COM_NormalizarSSO__c+'</wseg:normalizar>';
					strXML+='<wseg:strError/>';
				strXML+='</wseg:HabilitarRecurso>';
			strXML+='</soapenv:Body>';
		strXML+='</soapenv:Envelope>';

        system.debug('strXML: ' + strXML);
        system.debug('objRequest DESPUES: ' + objHttpRequest);
			
		objHttpRequest.setbody(strXML);
		return objHttpRequest;
	}
}