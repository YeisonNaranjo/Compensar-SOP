/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Mock que simula la respuesta exitosa de la integración del SSO

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/

@isTest
global class COM_HabilitarRecursoSSOMock_tst implements HttpCalloutMock 
{
    public String strToken = 'SwyYYUUh%2bj%2bt8KcraFwnwyDf6CmQasVkA3qilbDyHmSAujtgJ4N0OkYuj2wranaW-03';

    public HTTPResponse respond(HTTPRequest req) 
    {	
    	String strResponse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">';
    		strResponse+= '<SOAP-ENV:Header/>';
    		strResponse+= '<SOAP-ENV:Body>';
    			strResponse+= '<HabilitarRecursoResponse xmlns="http://WSeguridad/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
    				strResponse+= '<HabilitarRecursoResult>true</HabilitarRecursoResult>';
    				strResponse+= '<strTicket>'+strToken+'</strTicket>';
    				strResponse+= '<strError/>';
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