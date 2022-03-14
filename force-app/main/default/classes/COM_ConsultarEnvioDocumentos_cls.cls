/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase donde se realizan los siguientes procesos:
                    - Consultar si el documento debe ser enviado por Email y/o OnBase

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/07/17             Cristian David Mejia (CM)             Creación Clase.
    1.2     24/08/17             Juan David Uribe Ruiz (JDUR)          Se agrega envio a OnBase.
    1.3     09/11/17             Rubén Suárez Forero (RUSF)            Se agrega método para solo enviar correo.
************************************************************************************************/
public with sharing class COM_ConsultarEnvioDocumentos_cls 
{
    
    private static List<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
    /**
     * @description Metedo encargado de devolver la configuracion de envio del documento solicitadp
     * @String idProceso => Identificador con el cual fue configurado el proceso o documento
     * @return TipoEnviosDocuemnto => Configuración del documento solicitado
     **/    
    public static TipoEnviosDocuemnto consultarEnvioDocumentos(String idProceso)
    {

        //Se Valida que se reciba un valor de entrada
        if(String.isBlank(idProceso))
            return new TipoEnviosDocuemnto(false, false, Label.COM_SinIdentificadorProceso);

        lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c FROM COM_ConfiguracionEnvioDocsM__mdt WHERE COM_IdentificadorProceso__c =: idProceso];
        
        //Se valida que se halla encontrado una configuración con el identificador ingresado
        if(lstConfig.isEmpty())
            return new TipoEnviosDocuemnto(false, false, Label.COM_NoEncontroConfiguracion);

        return new TipoEnviosDocuemnto(lstConfig[0].COM_EnvioEmail__c, lstConfig[0].COM_EnvioOnBase__c, null);
    }

    public static void enviarDocumentos(String idProceso,set<String> setCorreos, set<Id> setIdAdjuntos, String strAsunto, String strCuerpoCorreo, String strTemplate, Id strTargetObjId, Id strWhatId)
    {
        TipoEnviosDocuemnto objTipoEnvios = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos(idProceso);
        System.debug('***CM*** =====>>> objTipoEnvios \n'+objTipoEnvios);
        if(String.isBlank(objTipoEnvios.strError))
        {
            system.debug('entro a enviar');
            system.debug('setCorreos  '+setCorreos);
            if(objTipoEnvios.blnEmail && setCorreos != null && !setCorreos.isEmpty())
            {
                system.debug('sigueee  entro a enviar');
                try 
                {
                    if(strTemplate == '')
                        COM_UtilidadCorreo_cls.enviarCorreoSimple(setCorreos, setIdAdjuntos, strAsunto, strCuerpoCorreo);
                    else
                        COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, setIdAdjuntos, strTemplate, strTargetObjId, strWhatId);
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
            
            //Inicio modificación JDUR
            if(objTipoEnvios.blnOnBase && !setIdAdjuntos.isEmpty()){ 
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase((new list<Id>(setIdAdjuntos)).get(0), lstConfig[0].Id);
            }
            //Fin modificación JDUR
        }

    }

    //RUSF 1.3
    //Método para solo enviar documentos por correo
    public static void enviarDocumentos2(String idProceso,set<String> setCorreos, set<Id> setIdAdjuntos, String strAsunto, String strCuerpoCorreo, String strTemplate, Id strTargetObjId, Id strWhatId, Boolean enviarCorreo, Id IdAdjuntos)
    {
        TipoEnviosDocuemnto objTipoEnvios = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos(idProceso);
        System.debug('***CM*** =====>>> objTipoEnvios \n'+objTipoEnvios);
        if(String.isBlank(objTipoEnvios.strError))
        {
            system.debug('entro a enviar');
            system.debug('setCorreos  '+setCorreos);
            if(enviarCorreo && objTipoEnvios.blnEmail && setCorreos != null && !setCorreos.isEmpty())
            {
                system.debug('sigueee  entro a enviar');
                try 
                {
                    if(strTemplate == '')
                        COM_UtilidadCorreo_cls.enviarCorreoSimple(setCorreos, setIdAdjuntos, strAsunto, strCuerpoCorreo);
                    else
                        COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, setIdAdjuntos, strTemplate, strTargetObjId, strWhatId);
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
            
            //Inicio modificación JDUR
            //if(objTipoEnvios.blnOnBase && IdAdjuntos != null){ 
            //  COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(IdAdjuntos, lstConfig[0].Id);
            //}
            //Fin modificación JDUR
        }

    }
    
    //RUSF 1.4
    //Método para solo enviar documentos a OnBase
    public static void enviarDocumentoOnBase(String idProceso, set<Id> setIdAdjuntos){
        TipoEnviosDocuemnto objTipoEnvios = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos(idProceso);
        if(String.isBlank(objTipoEnvios.strError)){
            system.debug('entro a enviarDocumentoOnBase');
            if(objTipoEnvios.blnOnBase && !setIdAdjuntos.isEmpty()){ 
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase((new list<Id>(setIdAdjuntos)).get(0), lstConfig[0].Id);
            }
        }
    }

    public class TipoEnviosDocuemnto
    {
        public boolean blnEmail;
        public boolean blnOnBase;
        public String strError;
        public TipoEnviosDocuemnto(boolean blnEmail, boolean blnOnBase, String strError)
        {
            this.blnEmail = blnEmail;
            this.blnOnBase = blnOnBase;
            this.strError = strError;
        }
    }
}