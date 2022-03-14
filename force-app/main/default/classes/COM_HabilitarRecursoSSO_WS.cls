/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Web Service encargado del Single SignOn

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
public with sharing class COM_HabilitarRecursoSSO_WS 
{

    /**
     * @version 1.0
     * @description Metodo encargado de hacer la integracion del SSO, y retornar el token
     * @return String Token de sesion activa
     **/    
    public String getTokenSSO()
    {
        COM_HabilitarRecursoSSORequest_cls clsRequest = new COM_HabilitarRecursoSSORequest_cls();
        User objUser = [Select COM_IdUsuarioSSO__c FROM User WHERE Id =: UserInfo.getUserId()];

        if(objUser.COM_IdUsuarioSSO__c == null)
        {
            return Label.COM_UsuarioSinIdSSO;
        }

        String strToken = '';
        Boolean blnError = false;
        try
        {
            Http http = new Http ();
            HttpRequest objHttpRequest = clsRequest.crearRequest(objUser.COM_IdUsuarioSSO__c);
            HttpResponse res = http.send(objHttpRequest);
            System.debug('\n---res--->'+res);
            System.debug('\n---res.getBody()--->'+res.getBody());

            if(res.getStatusCode() != 200)
            {
                return Label.COM_ErrorWS_SSO;
            }

            Dom.Document documento = new Dom.Document();
            documento.load(res.getBody());
            
            //Capturar el nodo raiz
            Dom.XMLNode raiz = documento.getRootElement();
            
            Dom.XMLNode body=null;
            //Recorrer cada nodo desde el nodo raiz hasta encontrar el nodo Body
            for(Dom.XMLNode child : raiz.getChildElements()) {
                
                if(child.getName()=='Body')
                    body=child;
            }

            for(Dom.XMLNode infoR :body.getChildren()[0].getChildren())
            {
                system.debug('\n---infoR.getName()--->'+infoR.getName());
                
                if(infoR.getName() == 'HabilitarRecursoResult')
                {
                    if(!Boolean.valueOf(infoR.getText()))
                    {
                        blnError = true;
                    }
                }
                else if(infoR.getName() == 'strTicket')
                {
                    strToken = infoR.getText();
                }
                else if (infoR.getName() == 'strError' && !String.isBlank(infoR.getText())) 
                {
                    strToken = infoR.getText();
                }
                    
            }

            System.debug('Token ===>> '+strToken);
            if(strToken == ''){
                System.debug('\n Se recibió un token vacio');
            }
        } 
        catch(Exception e)
        {
            System.debug(e.getMessage());
            return e.getMessage();
        }
        return strToken;
    }
}