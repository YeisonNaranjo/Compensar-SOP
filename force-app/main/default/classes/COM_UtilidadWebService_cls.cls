/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase de utilidades para el consumo de WebServices y lo relacionado
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    26/07/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   2.0    03/03/2021      Yeison Stic Naranjo              	Ajuste 201 queries
* @version   3.1    29/11/2021      Alvaro Gomez 						creacion Metodo consumo Servicio por soporte 
****************************************************************************************************************/
public with sharing class COM_UtilidadWebService_cls {
    
    /* 
    * Nombre: obtenerCabecera
    * Descripcion: Metodo encargado de construir la cabecera (Header) que se debe enviar en 
    *              todas las peticiones de consumo de WebServices
    * Fecha Creación: 26/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            26-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public static COM_BaseWrapper_cls.Header obtenerCabecera(String strNameHeader){
        COM_BaseWrapper_cls.Header objHeader;
        COM_BaseWrapper_cls.SecurityHeader objSecurityHeader;
        COM_BaseWrapper_cls.System_x objSystem_x;
        COM_ConfiguracionHeaderWSM__mdt objConfiguracionHeaderWS;
        
        objHeader = new COM_BaseWrapper_cls.Header();
        objSecurityHeader = new COM_BaseWrapper_cls.SecurityHeader();
        objSystem_x = new COM_BaseWrapper_cls.System_x();
        
        //objConfiguracionHeaderWS = COM_ConfiguracionHeaderWSM__mdt.getInstance(strNameHeader);
        objConfiguracionHeaderWS = [Select COM_Usuario__c, COM_Password__c, COM_InputSystem__c, COM_ApplicationId__c, COM_DireccionIp__c, COM_PrefijoTransaccionId__c From COM_ConfiguracionHeaderWSM__mdt where Label =:strNameHeader limit 1];
        
        objSecurityHeader.User =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        objSecurityHeader.Password = objConfiguracionHeaderWS.COM_Password__c;
        
        objSystem_x.InputSystem = objConfiguracionHeaderWS.COM_InputSystem__c;
        objSystem_x.ApplicationID = objConfiguracionHeaderWS.COM_ApplicationId__c;
        objSystem_x.TransactionID = obtenerTransactionId(objConfiguracionHeaderWS.COM_PrefijoTransaccionId__c);
        objSystem_x.IPAddress = objConfiguracionHeaderWS.COM_DireccionIp__c;
        
        objHeader.SecurityHeader = objSecurityHeader;
        objHeader.System_x = objSystem_x;
        
        return objHeader;
    }
    
    /* 
    * Nombre: obtenerCabeceraXML
    * Descripcion: Metodo encargado de construir la cabecera (Header) en XML que se debe enviar en 
    *              todas las peticiones de consumo de WebServices via SOAP
    * Fecha Creación: 22/08/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            22-Ago-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    /* Inicio 2.0 */
    //public static String obtenerCabeceraXML(String strNameHeader){
    public static String obtenerCabeceraXML(String strNameHeader, String user_Identificacion){        
    /* Fin 2.0 */
        COM_ConfiguracionHeaderWSM__mdt objConfiguracionHeaderWS;
        String strCabecera;
        //objConfiguracionHeaderWS = COM_ConfiguracionHeaderWSM__mdt.getInstance(strNameHeader);
        objConfiguracionHeaderWS = [Select COM_Usuario__c, COM_Password__c, COM_InputSystem__c, COM_ApplicationId__c, COM_DireccionIp__c, COM_PrefijoTransaccionId__c From COM_ConfiguracionHeaderWSM__mdt where Label =:strNameHeader limit 1];
        /* Inicio 2.0 */
        //String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 2.0 */
        strCabecera = '<wsr:Header>'
                + '<wsr:SecurityHeader>'
                   + '<wsr:User>' + user_Identificacion + '</wsr:User>'
                   + '<wsr:Password>' + objConfiguracionHeaderWS.COM_Password__c + '</wsr:Password>'
                + '</wsr:SecurityHeader>'
                + '<wsr:System>'
                   + '<wsr:InputSystem>' + objConfiguracionHeaderWS.COM_InputSystem__c + '</wsr:InputSystem>'
                   + '<wsr:ApplicationID>' + objConfiguracionHeaderWS.COM_ApplicationId__c + '</wsr:ApplicationID>'
                   + '<wsr:TransactionID>' + obtenerTransactionId(objConfiguracionHeaderWS.COM_PrefijoTransaccionId__c) + '</wsr:TransactionID>'
                   + '<wsr:IPAddress>' + objConfiguracionHeaderWS.COM_DireccionIp__c + '</wsr:IPAddress>'
                + '</wsr:System>'
             + '</wsr:Header>';

        return strCabecera;
    }
    
    /* 
    * Nombre: consumirWS
    * Descripcion: Metodo encargado de consumir un Web Service REST
    * Fecha Creación: 26/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            26-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public static Object consumirWS(Object objTransaccion, String strNombreServicio, System.Type apexType, Id IdObjeto){
        Object objRta;
        COM_ConfiguracionWebServiceM__mdt objConfiguracionWebService;
        HttpRequest objRequest;
        HttpResponse objResponse;
        Http objHttp;
        list<COM_LogTransacciones__c> lstLogs;
        COM_LogTransacciones__c objLog;
        String strEndPoint;
        String strJSON;
        String strJSONOriginal;
        String strResponseOriginal;
        String strBodyResponse;
        
        //Se consultan datos del servicios con strNombreServicio
        //objConfiguracionWebService = COM_ConfiguracionWebService__c.getInstance(strNombreServicio);
        objConfiguracionWebService = [Select COM_Protocolo__c, COM_DireccionIp__c, COM_Puerto__c, COM_Recurso__c, COM_Metodo__c, COM_Activo__c, COM_TimeOut__c From COM_ConfiguracionWebServiceM__mdt where Label =: strNombreServicio limit 1];
        if(objConfiguracionWebService == null){
            //Error indicando que no se encontro la configuracion para consumir el Web Service
            throw new COM_WebServiceException('No se encontró la configuración para el servicio ' + strNombreServicio);
        }
        
        if(!objConfiguracionWebService.COM_Activo__c){
            system.debug('El Web Service ' + strNombreServicio + ' se encuentra desactivado.');
            throw new COM_WSInactivoException('El Web Service ' + strNombreServicio + ' se encuentra desactivado.');
        }
        
        system.debug('========>>>> apexType: ' + apexType);
        
        //Se serializa el objTransaccion a un JSON, el segundo parametro se envia true para que omita los valores nulos (null)
        strJSON = system.JSON.serialize(objTransaccion, true);
        strJSONOriginal = strJSON;
        
        //Se hace el .replaceAll del atributo System_x
        strJSON = strJSON.replace('"System_x"', '"System"');
        
        //Se construye el HttpRequest
        objRequest = new HttpRequest();
        strEndPoint = construirEndPoint(objConfiguracionWebService);
        system.debug('========>>>> EndPoint: ' + strEndPoint);
        
        if(objConfiguracionWebService.COM_Metodo__c.equals('GET')){
            strEndPoint += '?' + EncodingUtil.urlEncode(strJSON, 'UTF-8');
        } else{
            objRequest.setBody(strJSON);
            objRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            system.debug('========>>>> Request Header: ' + objRequest.getHeader('Content-Type'));
            system.debug('========>>>> Request Header: ' + objRequest.getHeader('Accept-Charset'));
            system.debug('========>>>> Request Body: ' + objRequest.getBody());
        }
        objRequest.setEndpoint(strEndPoint);
        objRequest.setMethod(objConfiguracionWebService.COM_Metodo__c);
        objRequest.setTimeout(objConfiguracionWebService.COM_TimeOut__c.intValue());

        //Se crea la cache para los logs
        if (!Cache.Org.contains('local.partition1.logs')) {
            lstLogs = new list<COM_LogTransacciones__c>();
            Cache.Org.put('local.partition1.logs', lstLogs);
        } else{
            lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
        }
        
        system.debug('========>>>> strJSON: ' + strJSON);
        system.debug('========>>>> Request: ' + objRequest);
        
        //Se envia la transaccion
        objHttp = new http();
        try {
            objResponse = objHttp.send(objRequest);
        } catch(system.CalloutException e) {
            system.debug('=====> Callout error: ' + e);
            objLog = generarLog(IdObjeto, null, strJSONOriginal, null, strNombreServicio, e.getMessage());
            lstLogs.add(objLog);
            Cache.Org.put('local.partition1.logs', lstLogs);
            throw new COM_WebServiceException(e.getMessage());
        }
        
        if (objResponse.getStatusCode() != 200 ) {
            system.debug('=====> objResponse: ' + objResponse);
            objLog = generarLog(IdObjeto, objResponse.getStatusCode()+'', strJSONOriginal, objResponse.getStatus(), strNombreServicio, null);
            lstLogs.add(objLog);
            Cache.Org.put('local.partition1.logs', lstLogs);
            throw new COM_WebServiceException(objResponse.getStatus());     
        } 
        
        strResponseOriginal = objResponse.getBody();
        
        objLog = generarLog(IdObjeto, objResponse.getStatusCode()+'', strJSONOriginal, strResponseOriginal, strNombreServicio, null);
        lstLogs.add(objLog);
        Cache.Org.put('local.partition1.logs', lstLogs);
        
        strBodyResponse = objResponse.getBody().replace('"System"', '"System_x"').replace('""', 'null').replace('\n\r', ' ').replace('\n', ' ').replace('\r', ' ');
        
        //Se deserializa el JSON de respuesta usando el apexType
        //system.debug('========>>>> ResponseBody: ' + objResponse.getBody());
        
        system.debug('========>>>> strBodyResponse: ' + strBodyResponse);
        try{
            objRta = system.JSON.deserialize(strBodyResponse, apexType);
        } catch(Exception e){
            system.debug('=====>>>> Error JSON.deserialize: ' + e);
            return null;
        }
        
        //Se retorna el objeto de respuesta
        return objRta;
    }
    
    public static String consumirWS(String strNombreServicio, String strXML, Id IdObjeto){
        HttpRequest objRequest;
        HttpResponse objResponse;
        Http objHttp;
        COM_ConfiguracionWebServiceM__mdt objConfiguracionWebService;
        COM_LogTransacciones__c objLog;
        list<COM_LogTransacciones__c> lstLogs;
        String strEndPoint;
        String strJSON;
        String strBodyResponse;
        
        //Se consultan datos del servicios con strNombreServicio
        //objConfiguracionWebService = COM_ConfiguracionWebServiceM__mdt.getInstance(strNombreServicio);
        objConfiguracionWebService = [Select COM_Protocolo__c, COM_DireccionIp__c, COM_Puerto__c, COM_Recurso__c, COM_Metodo__c, COM_SOAPAction__c, COM_TimeOut__c From COM_ConfiguracionWebServiceM__mdt where Label =: strNombreServicio limit 1];
        if(objConfiguracionWebService == null){
            //Error indicando que no se encontro la configuracion para consumir el Web Service
            throw new COM_WebServiceException('No se encontró la configuración para el servicio ' + strNombreServicio);
        }
        
        //Se crea la cache para los logs
        if (!Cache.Org.contains('local.partition1.logs')) {
            lstLogs = new list<COM_LogTransacciones__c>();
            Cache.Org.put('local.partition1.logs', lstLogs);
        } else{
            lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
        }
        
        //Se construye el HttpRequest
        objRequest = new HttpRequest();
        strEndPoint = construirEndPoint(objConfiguracionWebService);
        
        objRequest.setbody(strXML);
        objRequest.setEndpoint(strEndPoint);
        objRequest.setMethod(objConfiguracionWebService.COM_Metodo__c);
        objRequest.setHeader('Content-Type', 'application/xml;charset=utf-8'); 
        objRequest.setHeader('SOAPAction', objConfiguracionWebService.COM_SOAPAction__c);
        objRequest.setTimeout(objConfiguracionWebService.COM_TimeOut__c.intValue());
        
        system.debug('=========================');
        system.debug(objRequest);
        system.debug('=========================');
        //Se envia la transaccion
        objHttp = new http();
        try {
            objResponse = objHttp.send(objRequest);
        } catch(system.CalloutException e) {
            system.debug('=====> Callout error: ' + e);
            objLog = generarLog(IdObjeto, null, strXML, null, strNombreServicio, e.getMessage());
            lstLogs.add(objLog);
            Cache.Org.put('local.partition1.logs', lstLogs);
            throw new COM_WebServiceException(e.getMessage());
        }
        
        strBodyResponse = objResponse.getBody();
        objLog = generarLog(IdObjeto, null, strXML, strBodyResponse, strNombreServicio, null);
        lstLogs.add(objLog);
        list<COM_LogTransacciones__c> lstLogsSize = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
        System.debug('lstLogsSize ' + lstLogsSize.size());
        String strLogsSize = lstLogsSize.toString();
        System.debug('strLogsSize ' + strLogsSize.length());
        
        Cache.Org.put('local.partition1.logs', lstLogs);
        
        if(strBodyResponse != null){
            strBodyResponse = strBodyResponse.replace('\n\r', ' ').replace('\n', ' ').replace('\r', ' ');
            strBodyResponse = strBodyResponse.replace('&lt;', '<');
            strBodyResponse = strBodyResponse.replace('&gt;', '>');
            strBodyResponse = strBodyResponse.replace('&quot;', '"');
            strBodyResponse = strBodyResponse.replace('&amp;', '&');
            strBodyResponse = strBodyResponse.replace('<ns1:System>', '<ns1:System_x>');
            strBodyResponse = strBodyResponse.replace('</ns1:System>', '</ns1:System_x>');
            strBodyResponse = strBodyResponse.replace('<Page extension', '<Page_x extension');
            strBodyResponse = strBodyResponse.replace('</Page>', '</Page_x>');
        }
        
        return strBodyResponse;
        
    }
    //3.1
    /*Version para envio de documentos por soporte*/
      public static String consumirWSSupport(String strNombreServicio, String strXML, Id IdObjeto){
        HttpRequest objRequest;
        HttpResponse objResponse;
        Http objHttp;
        COM_ConfiguracionWebServiceM__mdt objConfiguracionWebService;
        String strEndPoint;
        String strJSON;
        String strBodyResponse;
        
        //Se consultan datos del servicios con strNombreServicio
        //objConfiguracionWebService = COM_ConfiguracionWebServiceM__mdt.getInstance(strNombreServicio);
        objConfiguracionWebService = [Select COM_Protocolo__c, COM_DireccionIp__c, COM_Puerto__c, COM_Recurso__c, COM_Metodo__c, COM_SOAPAction__c, COM_TimeOut__c From COM_ConfiguracionWebServiceM__mdt where Label =: strNombreServicio limit 1];
        if(objConfiguracionWebService == null){
            //Error indicando que no se encontro la configuracion para consumir el Web Service
            throw new COM_WebServiceException('No se encontró la configuración para el servicio ' + strNombreServicio);
        }
        
              
        //Se construye el HttpRequest
        objRequest = new HttpRequest();
        strEndPoint = construirEndPoint(objConfiguracionWebService);
        
        objRequest.setbody(strXML);
        objRequest.setEndpoint(strEndPoint);
        objRequest.setMethod(objConfiguracionWebService.COM_Metodo__c);
        objRequest.setHeader('Content-Type', 'application/xml;charset=utf-8'); 
        objRequest.setHeader('SOAPAction', objConfiguracionWebService.COM_SOAPAction__c);
        objRequest.setTimeout(objConfiguracionWebService.COM_TimeOut__c.intValue());
        
        system.debug('=========================');
        system.debug(objRequest);
        system.debug('=========================');
        //Se envia la transaccion
        objHttp = new http();
        try {
            objResponse = objHttp.send(objRequest);
        } catch(system.CalloutException e) {
            system.debug('=====> Callout error: ' + e);
            throw new COM_WebServiceException(e.getMessage());
        }
        
        strBodyResponse = objResponse.getBody();
               
        if(strBodyResponse != null){
            strBodyResponse = strBodyResponse.replace('\n\r', ' ').replace('\n', ' ').replace('\r', ' ');
            strBodyResponse = strBodyResponse.replace('&lt;', '<');
            strBodyResponse = strBodyResponse.replace('&gt;', '>');
            strBodyResponse = strBodyResponse.replace('&quot;', '"');
            strBodyResponse = strBodyResponse.replace('&amp;', '&');
            strBodyResponse = strBodyResponse.replace('<ns1:System>', '<ns1:System_x>');
            strBodyResponse = strBodyResponse.replace('</ns1:System>', '</ns1:System_x>');
            strBodyResponse = strBodyResponse.replace('<Page extension', '<Page_x extension');
            strBodyResponse = strBodyResponse.replace('</Page>', '</Page_x>');
        }
        
        return strBodyResponse;
        
    }
    
    private static COM_LogTransacciones__c generarLog(Id IdObjeto, String StrCodigoRespuesta, String strRequest, 
                                String strResponse, String strTipoTransaccion, String strDescripcion){
                                    
        return COM_Utilidades_cls.generarLog(IdObjeto, StrCodigoRespuesta, strRequest, strResponse, strTipoTransaccion, strDescripcion);
        
        /*if(!system.isFuture()){
            system.debug('********* Va a almacentar Log para TipoTransaccion: ' + strTipoTransaccion + ', IdObjeto: ' + IdObjeto);
            //COM_Utilidades_cls.generarLog(IdObjeto, StrCodigoRespuesta, strRequest, strResponse, strTipoTransaccion, strDescripcion);
        } else{
            system.debug('No va almacenar LOG porque ya fue invocado un metodo futuro');
        }*/
    }
    
    /* 
    * Nombre: obtenerTransactionId
    * Descripcion: Metodo encargado de generar un TransactionId para ser enviado en el consumo de WebServices
    * Fecha Creación: 26/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            26-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    private static String obtenerTransactionId(String strCodApp){
        return strCodApp + COM_Utilidades_cls.obtenerFechaActualFormateadaStr(COM_UtilidadConstantes_cls.FORMATO_FECHA_TRANSACTION_ID);
    }
    
    /* 
    * Nombre: construirEndPoint
    * Descripcion: Metodo encargado construir el EndPoint a partir de la configuracion personalizada COM_ConfiguracionWebServiceM__mdt
    * Fecha Creación: 26/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            26-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    private static String construirEndPoint(COM_ConfiguracionWebServiceM__mdt objConfiguracionWebService){
        String strEndPoint;
        if(objConfiguracionWebService == null){
            return null;
        }
        
        strEndPoint = '';
        strEndPoint += objConfiguracionWebService.COM_Protocolo__c + '://' + objConfiguracionWebService.COM_DireccionIp__c;
        if(objConfiguracionWebService.COM_Puerto__c != null){
            strEndPoint += ':' + Integer.Valueof(objConfiguracionWebService.COM_Puerto__c);
        }
        strEndPoint += '/' + objConfiguracionWebService.COM_Recurso__c.removeStart('/').removeEnd('/');
        
        return strEndPoint;
    }
    
}