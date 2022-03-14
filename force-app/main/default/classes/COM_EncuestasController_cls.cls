/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             William Aldana (WA)
Proyecto:          Compensar
Descripción:       Clase Utilitaria encargada de:
                   * Obtener los datos necesarios para encuestas

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     01/08/17         William Aldana  (WA)   Creación Clase.
    2.0     09/11/19         Paula Bohórquez (PB)   Creación del método validarEncuesta y la clase WrapperResponse para migración a Lightning.
************************************************************************************************/

global class COM_EncuestasController_cls {
    
    public String strNombreEncuesta {get; set;}
    
    public COM_EncuestasController_cls() {
        
    }
    
    public COM_EncuestasController_cls(ApexPages.StandardController controller) {
        AVX_ENC_Encuesta__c objEncuesta = (AVX_ENC_Encuesta__c) controller.getRecord();  
        
        if(objEncuesta != null){
            List<AVX_ENC_Encuesta__c> lstEncuestas = [SELECT Name FROM AVX_ENC_Encuesta__c where Id =: objEncuesta.Id];
            if(!lstEncuestas.isEmpty()){
                strNombreEncuesta = lstEncuestas.get(0).Name;
                system.debug('>>>>>>>>>>>> strNombreEncuesta: ' + strNombreEncuesta);
            } else{
                system.debug('>>>>>>>>>>>> NO ENCOTRO ENCUESTAS');
            }
        } else{
            system.debug('>>>>>>>>>>>> NO LLEGO OBJETO ENCUESTAS AL CONTROLADOR');
        }
        
    }
    
    public void procesarEncuestaPagina(){
        String strEstadoEncuesta;
        String strRespuesta;
        if(!String.isBlank(strNombreEncuesta)){
            strEstadoEncuesta = obtenerEstadoEncuesta(strNombreEncuesta);
            system.debug('>>>>>>>>>>>> strEstadoEncuesta: ' + strEstadoEncuesta);
            if(strEstadoEncuesta.equals('OK')){
                try{
                    strRespuesta = enviarEncuesta(strNombreEncuesta);
                    system.debug('>>>>>>>>>>>> strRespuesta: ' + strRespuesta);
                    if(strRespuesta == 'OK'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Encuesta enviada satisfactoriamente'));
                        return;
                    }
                } catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error enviando la encuesta: ' + e.getMessage()));
                    return;
                }
            } else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Encuesta no disponible para enviar.'));
                return;
            }
        }
    }

    /**
     * [obtenerEstadoEncuesta description]
     * @param  nombreEncuesta [description]
     * @return                [description]
     */
    webService static String obtenerEstadoEncuesta(String nombreEncuesta) {
        // la encuesta solo se puede enviar si está en estado sin contestar
        List<AVX_ENC_Encuesta__c> lstEncuestas = [SELECT RecordType.Name FROM AVX_ENC_Encuesta__c where Name =: nombreEncuesta];
        if(!lstEncuestas.isEmpty()){
            if(lstEncuestas.get(0).RecordType.Name == 'Sin contestar'){
                return 'OK';
            }else{
                    return 'KO';
            }
        }
        return 'KO';
    }
    /**
     * [enviarEncuesta description]
     * @param  nombreEncuesta [description]
     * @return                [description]
     */
    webService static String enviarEncuesta(String nombreEncuesta) {
        List<AVX_ENC_Encuesta__c> lstEncuestas = [SELECT Id, COM_Contacto__c, COM_Contacto__r.Name, COM_Contacto__r.email, COM_Oportunidad__c, COM_Oportunidad__r.Name, Plantilla_encuesta__r.Name FROM AVX_ENC_Encuesta__c where Name =: nombreEncuesta];
        //Inicio NOLA-2087 - Se obtiene la Plantilla de correo de acuerdo al Nombre de Encuesta
        List<EmailTemplate> lstPlantilla = new List<EmailTemplate>();
        if(lstEncuestas[0].Plantilla_encuesta__r.Name == 'Encuesta PAF'){
            lstPlantilla =[select Id, Subject, HtmlValue, Body, DeveloperName from EmailTemplate where DeveloperName = 'Envio_Encuestas_PAF'];
        }else{
            lstPlantilla =[select Id, Subject, HtmlValue, Body, DeveloperName from EmailTemplate where DeveloperName = 'Envio_Encuestas'];
        }
        //Fin NOLA-2087
        if(!lstEncuestas.isEmpty()){
            AVX_ENC_Encuesta__c encuesta = lstEncuestas.get(0);
            EmailTemplate plantilla = lstPlantilla.get(0);
            if(encuesta.COM_Contacto__r.email != null){
                set<String> setCorreos = new set<String>();
                setCorreos.add(encuesta.COM_Contacto__r.email);
                String urlx = URL.getSalesforceBaseUrl().toExternalForm()+'/encuestas/ENC_ResponderEncuesta_pag?id='+encuesta.Id;
                String htmlBody = plantilla.HtmlValue;
                htmlBody = htmlBody.replace('{!Opportunity.Name}', encuesta.COM_Contacto__r.Name);
                htmlBody = htmlBody.replace('{!AVX_ENC_Encuesta__c.Plantilla_encuesta__c}', '<a href="'+urlx+'">Responder Encuenta</a>');
                htmlBody = htmlBody.replace('{!urlEncuesta}', '<a href="'+urlx+'">'+urlx+'</a>');
                //Inicio NOLA-2087 - Se pasa el developer Name de la Plantila de correo de acuerdo al Nombre de Encuesta
                //COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, new set<Id>(), 'Envio_Encuestas', encuesta.COM_Contacto__c, encuesta.Id);
                COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, new set<Id>(), lstPlantilla.get(0).DeveloperName, encuesta.COM_Contacto__c, encuesta.Id);
                //Fin NOLA-2087
                return 'OK';
            } else{
                    throw new applicationException('El contacto '+encuesta.COM_Contacto__r.Name+ ' no tiene un correo asociado');
            }
        }else{
            return 'ERROR';
        }
        // buscar la plantilla de encuesta
        
    }

    public class applicationException extends Exception {}

    /**
    * @method       validarEncuesta
    * @description  Método utilizado en componente lightning MGLT_EnviarEncuesta_lcp, que valida una encuesta y dependiendo de su estado la envía o no
    * @author       Paula Bohórquez - 11-09-2019
    */
    @AuraEnabled
    public static WrapperResponse validarEncuesta(String strNomEncuesta){
        WrapperResponse wrpResponse = new WrapperResponse();
        
        String strEstadoEncuesta = obtenerEstadoEncuesta(strNomEncuesta);
        if(strEstadoEncuesta=='OK'){
            try{
                String strRespuesta = enviarEncuesta(strNomEncuesta);
                if(strRespuesta == 'OK'){
                    wrpResponse.strMensaje = 'Encuesta enviada satisfactoriamente';
                    wrpResponse.strStatus = 'SUCCESS';
                }
                else{
                    wrpResponse.strMensaje = 'Ha ocurrido un error inesperado';
                    wrpResponse.strStatus = 'ERROR';
                }
            } catch(Exception e){
                wrpResponse.strMensaje = 'Error enviando la encuesta: ' + e.getMessage();
                wrpResponse.strStatus = 'ERROR';
                
            }
        }
        else{
            wrpResponse.strMensaje = 'Encuesta no disponible para enviar';
            wrpResponse.strStatus = 'WARNING';
        }

        return wrpResponse;
    }


    public class WrapperResponse {
        @AuraEnabled
        public String strMensaje               {get;set;}
        @AuraEnabled
        public String strStatus                {get;set;}
    }


}