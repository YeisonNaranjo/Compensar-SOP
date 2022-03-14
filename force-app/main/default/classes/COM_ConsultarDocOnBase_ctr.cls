/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Controlador de la visualforce COM_ConsultarDocOnBase_pag

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
global with sharing class COM_ConsultarDocOnBase_ctr 
{
    public List<Documento> lstDocs {get; set;}
    public Account objAcc {get; set;}
    public String strTipoDoc {get; set;}
    public String strNumDoc {get; set;}
    public String strDocBase64 {get; set;}
    public list<SelectOption> lstDocumentTypeName {get; set;}
    public list<SelectOption> lstCustomQueryName {get; set;}
    public String strOptDocumentTypeName {get; set;}
    public String strOptCustomQueryName {get; set;}
    public String strItem {get; set;}
    
    public String filename {get; set;}
    public transient String getData {get; set;} 
    public String Id {get; set;}
    public String CompId {get; set;}
    public boolean blnMensaje {get; set;}
    public boolean blnError {get; set;}
   
    public String strOptRadioButton {get; set;}
    public list<SelectOption> lstOptTadioButton {get; set;}
    
    private list<COM_LogTransacciones__c> lstLogs;
    
    public String strNroCaso {get; set;}
    public String strRadicadoOnBase {get; set;}

    /**
     * @description Constructor
     * @param ApexPages.Standardcontroller controller
     * @version 1.0
     **/    
    public COM_ConsultarDocOnBase_ctr(ApexPages.Standardcontroller controller) 
    {
        list<COM_ConfiguracionOpcionesListas__mdt> lstConfiguracionOpcionesListas;
        objAcc = (Account) controller.getRecord();
        lstDocs = new List<Documento>();
        
        if(objAcc.Id != null){
            objAcc = [SELECT Id, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c FROM Account WHERE Id = :objAcc.Id].get(0);
            
            strTipoDoc = objAcc.COM_TipoIdentificacion__c;
            //strNumDoc = objAcc.COM_Numeroidentificacion__c;
            strNumDoc = objAcc.COM_Numero_de_identificacion__c;
        }
        
        lstDocumentTypeName = new List<SelectOption>();
        lstCustomQueryName = new List<SelectOption>();
        lstOptTadioButton = new List<SelectOption>();
        
        blnMensaje = false;
        blnError = false;
        
        lstConfiguracionOpcionesListas = [SELECT COM_Etiqueta__c, COM_Valor__c, COM_AgrupadorLista__c, COM_SeleccionadoDefecto__c FROM COM_ConfiguracionOpcionesListas__mdt];
        
        for(COM_ConfiguracionOpcionesListas__mdt objConfiguracionOpcionesListas : lstConfiguracionOpcionesListas){
            if(objConfiguracionOpcionesListas.COM_AgrupadorLista__c.equals('ConsultarDocOnBase_DocumentTypeName')){
                lstDocumentTypeName.add(new SelectOption(objConfiguracionOpcionesListas.COM_Valor__c, objConfiguracionOpcionesListas.COM_Etiqueta__c));
                if(objConfiguracionOpcionesListas.COM_SeleccionadoDefecto__c){
                    strOptDocumentTypeName = objConfiguracionOpcionesListas.COM_Valor__c;
                }
            }
            
            if(objConfiguracionOpcionesListas.COM_AgrupadorLista__c.equals('ConsultarDocOnBase_CustomQueryName')){
                lstCustomQueryName.add(new SelectOption(objConfiguracionOpcionesListas.COM_Valor__c, objConfiguracionOpcionesListas.COM_Etiqueta__c));
                if(objConfiguracionOpcionesListas.COM_SeleccionadoDefecto__c){
                    strOptCustomQueryName = objConfiguracionOpcionesListas.COM_Valor__c;
                }
            }
        }
        
        lstOptTadioButton.add(new SelectOption('Document Type Name','Document Type Name')); 
        lstOptTadioButton.add(new SelectOption('Agrupacion Familias','Agrupacion Familias')); 
        strOptRadioButton = 'Document Type Name';
        //strOptRadioButton = 'Agrupacion Familias';
    }

    /**
     * @description Metodo encargado de hacer el llamado al servicio Web que trae los documentos de la cuenta y almacenarlos en la lista
     * @param ApexPages.Standardcontroller controller
     * @version 1.0
     **/
    public void getDocumentos()
    {
        system.debug(':::::::::: ACA SE CONSULTAN LOS DOCUMENTOS ');
        system.debug(':::::::::: strTipoDoc: ' + objAcc.COM_TipoIdentificacion__c);
        system.debug(':::::::::: strNumDoc: ' + objAcc.COM_Numero_de_identificacion__c);
        system.debug(':::::::::: strOptRadioButton: ' + strOptRadioButton);
        system.debug(':::::::::: strOptDocumentTypeName: ' + strOptDocumentTypeName);
        system.debug(':::::::::: strOptCustomQueryName: ' + strOptCustomQueryName);
        system.debug(':::::::::: strNroCaso: ' + strNroCaso);
        system.debug(':::::::::: strRadicadoOnBase: ' + strRadicadoOnBase);
        Documento objDocumento;
        lstDocs = new List<Documento>();
        list<COM_ConsultarMetaDataDocumentoOnBase_ws.MetaDataDocumentoWrapper> lstMetaDataDocumentoWrapper;
        blnMensaje = false;
        String strTipoDocumento;
        
        if(strOptRadioButton == 'Document Type Name'){
            strTipoDocumento = strOptDocumentTypeName;
        } else{
            strTipoDocumento = strOptCustomQueryName;
        }
        
        /*if(String.isBlank(objAcc.COM_Numero_de_identificacion__c)){
            blnMensaje = true;
            system.debug(':::::::::: Por favor digite en Número de Identificación.');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Por favor digite en Número de Identificación.'));
            return;
        }*/
        
        //COM_LogTransacciones__c objLog;
        //String strRequestAux;
        try{
            //strRequestAux = objAcc + ' <<<<>>>> strOptDocumentTypeName: ' + strOptDocumentTypeName + ' <<<<>>>> strOptRadioButton: ' + strOptRadioButton;
            lstMetaDataDocumentoWrapper = COM_ConsultarMetaDataDocumentoOnBase_ws.consultarMetaDataDocumentoOnBase(objAcc, strNroCaso, strRadicadoOnBase, strTipoDocumento, strOptRadioButton);
            //objLog = COM_Utilidades_cls.generarLog(objAcc.Id, strRequestAux, lstMetaDataDocumentoWrapper, Label.COM_WS_ConsultarMetaDataDocumentoOnBase, null);
            try{
                lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
                if(lstLogs != null && !lstLogs.isEmpty()){
                    insert lstLogs;
                    Cache.Org.remove('local.partition1.logs');
                }
            } catch(Exception e){
                system.debug('NO SE PUDO GUARDAR EL LOG.');
                System.Debug('====================== EXCEPCION [log getDocumentos] ======================');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                System.Debug('========================================================================================');
            }
        } catch(Exception e){
            try{
                lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
                if(lstLogs != null && !lstLogs.isEmpty()){
                    insert lstLogs;
                    Cache.Org.remove('local.partition1.logs');
                }
            } catch(Exception ex){
                system.debug('NO SE PUDO GUARDAR EL LOG.');
                System.Debug('====================== EXCEPCION [log Exception] ======================');
                System.debug( ex.getMessage() + ' ' + ex.getStackTraceString());
                System.Debug('========================================================================================');
            }
            blnMensaje = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return;
        }
        system.debug('>>>>>>>>>> lstMetaDataDocumentoWrapper: ' + lstMetaDataDocumentoWrapper);
        if(lstMetaDataDocumentoWrapper != null && !lstMetaDataDocumentoWrapper.isEmpty()){
            for(COM_ConsultarMetaDataDocumentoOnBase_ws.MetaDataDocumentoWrapper objMetaDataDocumentoWrapper : lstMetaDataDocumentoWrapper){
                
                //lstDocs.add(new Documento(objMetaDataDocumentoWrapper.strNombreDocumento,objMetaDataDocumentoWrapper.strDocumentType,objMetaDataDocumentoWrapper.strNombreDocumento,'pdf') );
                objDocumento = new Documento();
                objDocumento.strNomDoc      = objMetaDataDocumentoWrapper.strNombreDocumento;
                objDocumento.strTipoDoc     = objMetaDataDocumentoWrapper.strDocumentType;
                objDocumento.strNombreArch  = objMetaDataDocumentoWrapper.strNombreDocumento+'.pdf';
                objDocumento.strDocumentoId = objMetaDataDocumentoWrapper.strIdDocumento;
                system.debug(':::::::::: objDocumento: ' + objDocumento);
                lstDocs.add(objDocumento);
                //lstDocs.add(new Documento(objMetaDataDocumentoWrapper.strNombreDocumento,objMetaDataDocumentoWrapper.strDocumentType,objMetaDataDocumentoWrapper.strNombreDocumento,'pdf', objMetaDataDocumentoWrapper.strIdDocumento) );
            }
        } else{
            blnMensaje = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No se encontraron documentos'));
            return;
        }
        system.debug(':::::::::: lstDocs: ' + lstDocs);
    }
    
    public void descargar(){
        COM_ObtenerBinarioDocumentoOnBase_ws.BinarioDocumentoWrapper objBinarioDocumentoWrapper;
        blnError = false;
        blnMensaje = false;
        objBinarioDocumentoWrapper = null;
        filename = null;
        getData = null;
        system.debug(':::::::::: CompId: ' + CompId);
        system.debug(':::::::::: Id: ' + Id);
        
        objBinarioDocumentoWrapper = COM_ObtenerBinarioDocumentoOnBase_ws.obtenerBinarioDocumentoOnBase(Id);
        system.debug(':::::::::: objBinarioDocumentoWrapper: ' + objBinarioDocumentoWrapper);
        
        try{
            lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
            if(lstLogs != null && !lstLogs.isEmpty()){
                insert lstLogs;
                Cache.Org.remove('local.partition1.logs');
            }
        } catch(Exception ex){
            system.debug('NO SE PUDO GUARDAR EL LOG.');
            System.Debug('====================== EXCEPCION [log descargar] ======================');
            System.debug( ex.getMessage() + ' ' + ex.getStackTraceString());
            System.Debug('========================================================================================');
        }
        
        if(objBinarioDocumentoWrapper == null){
            system.debug(':::::::::: OBJETO BinarioDocumentoWrapper esta nulo');
            blnMensaje = true;
            blnError = true;
            system.debug(':::::::::: blnMensaje: ' + blnMensaje);
            system.debug(':::::::::: blnError: ' + blnError);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'No se pudo descargar el documento.'));
            return;
        }
        
        filename = objBinarioDocumentoWrapper.strNombre + '.' + objBinarioDocumentoWrapper.strExtension;
        getData = objBinarioDocumentoWrapper.strBinario;
    }



    /**
     * @description Wrapper encargado de almacenar los datos de cada documento
     * @version 1.0
     **/
    public class Documento
    {
        public String strNomDoc{get;set;}
        public String strTipoDoc{get;set;}
        public String strNombreArch{get;set;}
        public String strDocumentoId{get;set;}
        
        public Documento(){
            
        }

        public Documento(String strNombre, String strTipo,String strNameFile, String strFileExtension)
        {
            strNomDoc     = strNombre;
            strTipoDoc    = strTipo;
            strNombreArch = strNameFile+'.'+strFileExtension;
        }
        
        public Documento(String strNombre, String strTipo, String strNameFile, String strFileExtension, String strDocumentoId)
        {
            strNomDoc     = strNombre;
            strTipoDoc    = strTipo;
            strNombreArch = strNameFile+'.'+strFileExtension;
            strDocumentoId=strDocumentoId;
        }
    }
}