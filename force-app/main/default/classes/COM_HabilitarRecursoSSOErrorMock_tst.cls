/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Mock que simula la respuesta con algun error de la integración SSO

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/

@isTest
global class COM_HabilitarRecursoSSOErrorMock_tst implements HttpCalloutMock 
{
	public String strError = 'Usuario no encontrado';

    public HTTPResponse respond(HTTPRequest req) 
    {

    	String strResponse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">';
    		strResponse+= '<SOAP-ENV:Header/>';
    		strResponse+= '<SOAP-ENV:Body>';
    			strResponse+= '<HabilitarRecursoResponse xmlns="http://WSeguridad/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
    				strResponse+= '<HabilitarRecursoResult>false</HabilitarRecursoResult>';
    				strResponse+= '<strTicket/>';
    				strResponse+= '<strError>'+strError+'</strError>';
    			strResponse+= '</HabilitarRecursoResponse>';
    		strResponse+= '</SOAP-ENV:Body>';
    	strResponse+= '</SOAP-ENV:Envelope>';
    	
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml;charset=utf-8');
        res.setBody(strResponse);
        res.setStatusCode(200);
        return res;
    }

}