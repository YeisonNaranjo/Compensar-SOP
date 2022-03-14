/***********************************************************************************************
Desarrollado por:   Globant Colombia
Autor:              Carlos Suarez (CS)
Proyecto:           Compensar Release Q2 (RL2)
Descripción:        Clase Subsidio
Cambios (Versiones)
-----------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    -----------------------------------------------------
1.0     2021-06-15      Carlos Suarez           Creación de la clase
*************************************************************************************************/
public without sharing class RL2_Subsidio_ctr {


    /**
     * Get Tipo Documentos
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getTipoDocumentos() {
        try {

            List<RL2_TipoDocumentoCaso__mdt> lstTipoDocumentos = [SELECT RL2_DocumentoId__c, RL2_TipoDocumento__c FROM RL2_TipoDocumentoCaso__mdt WHERE RL2_PSB__c = true ORDER BY RL2_TipoDocumento__c  ASC];
        
            List<ResultWrapper> lstDocumentos = new List<ResultWrapper>();
            ResultWrapper vWrapObj;
            for(RL2_TipoDocumentoCaso__mdt mdtTipoDocumento : lstTipoDocumentos)
            {   
                vWrapObj = new ResultWrapper();
                vWrapObj.name = 'RL2_TipoDocumentoCaso__mdt';
                vWrapObj.text = mdtTipoDocumento.RL2_TipoDocumento__c;
                vWrapObj.val = mdtTipoDocumento.RL2_DocumentoId__c;
                lstDocumentos.add(vWrapObj);
            }

            return lstDocumentos;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    /**
     * Get Medios Respuesta
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getMediosRespuesta() {
        try {

            List<medioRespuesta__mdt> lstMRespuesta = [SELECT Id, MasterLabel, CE2_APIListaValor__c FROM medioRespuesta__mdt];
            List<ResultWrapper> lstMedios = new List<ResultWrapper>();
            ResultWrapper vWrapObj;
            for(medioRespuesta__mdt mdtMedio : lstMRespuesta)
            {
                if(mdtMedio.CE2_APIListaValor__c != 'Correspondencia'){
                    vWrapObj = new ResultWrapper();
                    vWrapObj.name = 'medioRespuesta__mdt';
                    vWrapObj.text = mdtMedio.MasterLabel;
                    vWrapObj.val = mdtMedio.CE2_APIListaValor__c;
                    lstMedios.add(vWrapObj);
                }
            }
            return lstMedios;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get PickList Info
     * @param String vObject
     * @param String vField
     * @param String vExclude
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getPickListInfo(String vObject, String vField, String vExclude){
        
        List<ResultWrapper> lstValues = new List<ResultWrapper>();
        List<Schema.PicklistEntry> values = RL2_Utilities.findPicklistOptions(vObject, vField, vExclude);
        ResultWrapper pl;
        if(!values.isEmpty()){
            for (Schema.PicklistEntry p: values) {
                if(!vExclude.contains(String.valueOf(p.getLabel()))) {
                    pl = new ResultWrapper();
                    pl.name = vObject;
                    pl.text = p.getLabel();
                    pl.val = p.getValue();
                    lstValues.add(pl);
                }
            }
        }
        return lstValues;
    }

    /**
     * Get Subsidios
     * @param String vObj
     * @param String vField
     * @param String vExclude
     * @return ReturnWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ReturnWrapper getSubsidios(String vObj, String vField, String vExclude){
        try{
            ReturnWrapper vReturn = new ReturnWrapper();
            List<Schema.PicklistEntry> lstOptions = RL2_Utilities.findPicklistOptions(vObj, vField, vExclude);
            List<String> lstSubs = new List<String>();
            for( Schema.PicklistEntry vSub : lstOptions){
                lstSubs.add(vSub.getValue());
            }
            vReturn.isResult = true;
            vReturn.message = 'success';
            vReturn.lstSubsidios = lstSubs;

            return vReturn;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get Servicios y Relacionados
     * @param String vSubsidio
     * @return ReturnWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ReturnWrapper getServicioRelacionado(String vSubsidio){
        ReturnWrapper vReturn = new ReturnWrapper();
        List<RL2_MatrizParametrizacionSubsidio__c> lstServicios = new List<RL2_MatrizParametrizacionSubsidio__c>();
        Set<Id> lstRelacionadoConId = new Set<Id>();

        RelacionadoConWrapper vRelacionConWrapper;
        List<RelacionadoConWrapper> lstRelacionConWrapper = new List<RelacionadoConWrapper>();

        try{
            List<ServicioRelacionadoWrapper> lstServicioRelacionadoW = new List<ServicioRelacionadoWrapper>();
            ServicioRelacionadoWrapper vServicioRelacionadoW;

            for(RL2_MatrizParametrizacionSubsidio__c vServ : [SELECT Id, Name, RL2_Activo__c,RL2_MediosAtencion__c,RL2_Subsidios__c,RL2_ApiName__c,RL2_Tooltip__c,
                                                                    RL2_Texto__c, (SELECT Id,Name, RL2_ApiName__c,RL2_NivelSuperior__c,RL2_Texto__c,RL2_MediosAtencion__c,RL2_NoDocumentos__c
                                                                    FROM Nivel_Superior_Matriz_Subsidios__r 
                                                                    WHERE RL2_Activo__c = true AND RecordType.DeveloperName =: System.Label.RL2_RelacionadoCon
                                                                    AND RL2_Subsidios__c includes(:vSubsidio)
                                                                    ORDER BY RL2_Order__c ASC NULLS LAST) 
                                                                    FROM RL2_MatrizParametrizacionSubsidio__c
                                                                    WHERE RecordType.DeveloperName =: System.Label.RL2_Servicio AND RL2_Activo__c = true 
                                                                    AND RL2_Subsidios__c includes(:vSubsidio)
                                                                    ORDER BY RL2_Order__c ASC NULLS LAST]){
                vServicioRelacionadoW = new ServicioRelacionadoWrapper();
                vServicioRelacionadoW.vServicio = vServ;
                
                for(RL2_MatrizParametrizacionSubsidio__c vRelacionado : vServ.Nivel_Superior_Matriz_Subsidios__r){
                    vRelacionConWrapper = new RelacionadoConWrapper(); 
                    vRelacionConWrapper.vRelacionadoCon = vRelacionado;
                    lstRelacionConWrapper.add(vRelacionConWrapper);
                    lstRelacionadoConId.add(vRelacionado.Id);
                    vServicioRelacionadoW.lstRelacionadoConWrapper.add(vRelacionConWrapper);
                }
                lstServicioRelacionadoW.add(vServicioRelacionadoW);
            }

            List<String> lstMediosAtencion = new List<String>();
            for(RL2_MatrizParametrizacionSubsidio__c vRequisitoMedio : [SELECT Id, Name, RL2_ApiName__c, 
                                                                    RL2_NivelSuperior__c,RL2_Texto__c,RL2_Icono__c,RL2_EtiquetaDescarga__c,        
                                                                    RL2_MediosAtencion__c,RL2_NombreRequisito__c,RecordType.DeveloperName 
                                                                    FROM RL2_MatrizParametrizacionSubsidio__c
                                                                    WHERE (RecordType.DeveloperName =: System.Label.RL2_Requisito AND RL2_Subsidios__c includes(:vSubsidio) 
                                                                    AND RL2_NivelSuperior__c IN:lstRelacionadoConId  AND RL2_Activo__c = true) 
                                                                    OR (RecordType.DeveloperName =: System.Label.RL2_MedioAtencion AND RL2_Activo__c = true)]){
                for( RelacionadoConWrapper  vRelacionadoW: lstRelacionConWrapper){
                    if(vRequisitoMedio.RecordType.DeveloperName == System.Label.RL2_Requisito){
                        if(vRelacionadoW.vRelacionadoCon.Id == vRequisitoMedio.RL2_NivelSuperior__c){ vRelacionadoW.lstRequisitos.add(vRequisitoMedio); }
                    }else if(vRequisitoMedio.RecordType.DeveloperName == System.Label.RL2_MedioAtencion){
                        if(vRelacionadoW.vRelacionadoCon.RL2_MediosAtencion__c != null){
                            if(vRelacionadoW.vRelacionadoCon.RL2_MediosAtencion__c.contains(vRequisitoMedio.RL2_ApiName__c)){
                                vRelacionadoW.lstMedioAtencion.add(vRequisitoMedio);
                            }
                        }
                    }
                }
            }
            
            vReturn.lstServicioRelacionadoWrapper = lstServicioRelacionadoW;
            vReturn.isResult = true;
            vReturn.message = 'success';

            return vReturn;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get Requisitos
     * @param String vSubsidio
     * @param String vRelacionado
     * @return List<RL2_MatrizParametrizacionSubsidio__c>
     */
    @AuraEnabled(cacheable=true)
    public static List<RL2_MatrizParametrizacionSubsidio__c> getRequisitos(String vSubsidio, String vRelacionado) {
        String vApiRelacionado = getApiRelacionado(vRelacionado);
        List<RL2_MatrizParametrizacionSubsidio__c> lstRequisitos = [SELECT Id, Name,RL2_Activo__c, RL2_NombreRequisito__c, RL2_ApiName__c, 
                                                                    RL2_NivelSuperior__r.Name,RL2_NivelSuperior__r.RL2_NivelSuperior__r.Name, 
                                                                    RL2_NivelSuperior__r.RL2_NivelSuperior__r.RL2_Subsidios__c, RL2_Texto__c
                                                                    FROM RL2_MatrizParametrizacionSubsidio__c 
                                                                    WHERE RecordType.DeveloperName =: System.Label.RL2_Requisito 
                                                                    AND RL2_NivelSuperior__r.RL2_ApiName__c = :vApiRelacionado
                                                                    AND RL2_Subsidios__c includes (:vSubsidio)
                                                                    AND RL2_Activo__c = true WITH SECURITY_ENFORCED];
        if(!lstRequisitos.isEmpty()){return lstRequisitos;}
        else{ return null; }
    }

    /**
     * Get Related Api
     * @param String vRelacionado
     * @return String
     */
    public static String getApiRelacionado (String vRelacionadoId)
    {
        String vApiRelacionado;
        RL2_MatrizParametrizacionSubsidio__c vRelacionado = [SELECT Id, Name, RL2_ApiName__c 
                                                                    FROM RL2_MatrizParametrizacionSubsidio__c 
                                                                    WHERE Id = :vRelacionadoId WITH SECURITY_ENFORCED];
        vApiRelacionado = vRelacionado.RL2_ApiName__c;
        return vApiRelacionado;
    }

    /**
     * Get Checkbox Info
     * @param String vRelacionado
     * @return String
     */
    @AuraEnabled(cacheable=true)
    public static RL2_MatrizParametrizacionSubsidio__c getCheckBoxInfo (String vRelacionadoId)
    {
        RL2_MatrizParametrizacionSubsidio__c vRelacionado;
        try{
            vRelacionado = [SELECT Id, Name, RL2_NoDocumentos__c, RL2_FechaIngreso__c,RL2_Normatividad__c,RL2_DocumentoObligatorio__c,RL2_TieneImposibilidad__c
                                                                    FROM RL2_MatrizParametrizacionSubsidio__c 
                                                                    WHERE Id = :vRelacionadoId WITH SECURITY_ENFORCED];
            return vRelacionado;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Create Case 
     * @param Case vCaso
     * @return Caso
     */
    public static Case createSubsidioCase( Case vCaso ){
        Case tmpCaso = vCaso;
        String nitId = System.Label.RL2_ClienteJuridico;
        
        //Contact
        String tipoIdContacto = '';
        String numeroIdContacto = '';

        //Account
        String tipoId = tmpCaso.RF2_TipoIdentificacionHuerfano__c;
        String numId = tmpCaso.RF2_NumeroIdentificacionHuerfano__c;

        
        tmpCaso.Status = System.Label.RF2_EstadoCasoAbierto;
        tmpCaso.Origin = System.Label.RF2_OrigenCasoPaginaWeb_lbl;
        tmpCaso.RF2_FechaRecepcion__c = System.Date.today();
        Id tipoRegistro = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get( 'RF2_Compensar' ).getRecordTypeId();
        tmpCaso.RecordTypeId = tipoRegistro;

        List<AccountContactRelation> lstRelacion = new List<AccountContactRelation>();
        List<Contact> lstContact = new List<Contact>();
        List<Account> lstClientes = new List<Account>();

        if(nitId.equals(tmpCaso.RF2_TipoIdentificacionHuerfano__c)){
            tipoIdContacto = tmpCaso.RF2_TipoIdentificacionHuerfano__c;
            numeroIdContacto = tmpCaso.RF2_NumeroIdentificacionHuerfano__c;
        }

        lstClientes = RL2_Utilities.getClienteByIdTypeNum(tipoId, numId);
        if(!lstClientes.isEmpty()) {
            tmpCaso.AccountId = lstClientes.get(0).Id;
            if(nitId == tmpCaso.RF2_TipoIdentificacionHuerfano__c) {
                lstRelacion = RL2_Utilities.getAccountRelationByAccountId(lstClientes.get(0).Id, tipoIdContacto, numeroIdContacto);
                if(!lstRelacion.isEmpty()) { tmpCaso.ContactId = lstRelacion.get(0).ContactId; }
            } else {
                lstContact = [SELECT Id FROM Contact
                                WHERE COM_TipoIdentificacion__c = :tipoId
                                AND COM_Numeroidentificacion__c = :numId
                                AND AccountId =: lstClientes.get(0).Id WITH SECURITY_ENFORCED LIMIT 1];
                if(!lstContact.isEmpty()) { tmpCaso.ContactId = lstContact.get(0).Id; }
            }
        }else {
            System.debug('No se ha encontrado informacion del cliente TipoID: ' + tipoId + ', numID: ' +numId);
        }

        try{
            insert tmpCaso;
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        tmpCaso = RL2_Utilities.getCaseById(tmpCaso.Id);
        return tmpCaso;
    }

    /**
     * Save Subsidio Files
     * @param Case vCaso
     * @param List<Object> filesToInsert
     * @return Case
     */
    @AuraEnabled
    public static Case saveSubsidioFiles(Case vCaso, List<Object> filesToInsert){
        try {
            
            String vTempRelacionado = '';
            String vTempTipoServicio = '';
            vTempRelacionado = vCaso.RF2_RelacionadoCon__c;
            vCaso.RF2_RelacionadoCon__c = getApiRelacionado(vTempRelacionado);
            vTempTipoServicio = vCaso.RL2_TipoServicio__c;
            vCaso.RL2_TipoServicio__c = getApiRelacionado(vTempTipoServicio);
            Case nCaso = createSubsidioCase(vCaso);
            
            List<Id> lstContentVersionIds = new list<Id>();
            List<ContentVersion> lstContentVersion = new List<ContentVersion>();
            ContentVersion vContentVersion;
            for (Object file : filesToInsert) {
                FileInfo fileData = (FileInfo) System.JSON.deserialize(System.JSON.serialize(file), FileInfo.class);
                vContentVersion = new ContentVersion();
                vContentVersion.PathOnClient = '/' + fileData.title;
                vContentVersion.FirstPublishLocationId = nCaso.Id;
                vContentVersion.Title = fileData.title;
                vContentVersion.VersionData = fileData.versionData;
                lstContentVersion.add(vContentVersion);
            }
            
            if(!lstContentVersion.isEmpty()){ insert lstContentVersion; }
            

            return nCaso;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get City By Name
     * @param String vCity
     * @return ResultWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getCityByName(String vCity){
        try{
            ResultWrapper lstWrapObj = new ResultWrapper();
                    
            List<RL2_Poblacion__c> lstPoblacion = new List<RL2_Poblacion__c>();
            lstPoblacion  = [SELECT Id, Name FROM RL2_Poblacion__c WHERE RL2_EsMunicipio__c  = true AND Name =:vCity WITH SECURITY_ENFORCED LIMIT 1];        
            if(!lstPoblacion.isEmpty()){
                lstWrapObj.name = 'RL2_Poblacion__c';
                lstWrapObj.text = lstPoblacion[0].Name;
                lstWrapObj.val = lstPoblacion[0].Id;
            }
            
            return lstWrapObj;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get Documentos Subsidio Arriendo
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getArriendoDocumentos(){

        Map<String, RL2_DocumentoSubsidioArriendo__mdt> mapDocumentos = RL2_DocumentoSubsidioArriendo__mdt.getAll();
        List<ResultWrapper> lstDocumentos = new List<ResultWrapper>();
        ResultWrapper vWrapObj;
        for(String strDoc : mapDocumentos.keySet()){
            vWrapObj = new ResultWrapper();
            vWrapObj.name = (mapDocumentos.get(strDoc).RL2_Viabilidad__c) ? 'viabilidad' : 'radicacion';
            vWrapObj.text = mapDocumentos.get(strDoc).RL2_NombreDocumento__c;
            vWrapObj.val = ( mapDocumentos.get(strDoc).RL2_Requerido__c ) ? 'required' : '';
            lstDocumentos.add(vWrapObj);
            
        }
        return lstDocumentos;
    }

    /**
     * Get Dependency Fields
     * @param SObject obj
     * @param String ctrl
     * @return List<RL2_Utilities.DependencyResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static RL2_Utilities.DependencyResultWrapper getDependentFields(SObject obj, String vField){
        try {
            String vDependent = vField.toLowerCase();
            Schema.sObjectType objType = obj.getSObjectType();

            Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
            Schema.SObjectField vDeptField = objFieldMap.get(vDependent);
            Map<String,List<Map<String,String>>> vMap = RL2_Utilities.getDependentPicklistValues(vDeptField);
            RL2_Utilities.DependencyResultWrapper dependencies = new RL2_Utilities.DependencyResultWrapper();
            dependencies.mapVal = vMap;
            
            return dependencies;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    /**
     * Get Tipo Documentos Subsidio Arriendo
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getTipoDocumentosArriendo() {
        try {

            List<RL2_TipoDocumentoCaso__mdt> lstTipoDocumentos = [SELECT RL2_DocumentoId__c, RL2_TipoDocumento__c FROM RL2_TipoDocumentoCaso__mdt WHERE RL2_PSB__c = true AND RL2_EsArriendo__c = true ORDER BY RL2_TipoDocumento__c  ASC];
        
            List<ResultWrapper> lstDocumentos = new List<ResultWrapper>();
            ResultWrapper vWrapObj;
            for(RL2_TipoDocumentoCaso__mdt mdtTipoDocumento : lstTipoDocumentos)
            {   
                vWrapObj = new ResultWrapper();
                vWrapObj.name = 'RL2_TipoDocumentoCaso__mdt';
                vWrapObj.text = mdtTipoDocumento.RL2_TipoDocumento__c;
                vWrapObj.val = mdtTipoDocumento.RL2_DocumentoId__c;
                lstDocumentos.add(vWrapObj);
            }

            return lstDocumentos;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    public class ReturnWrapper {
        @AuraEnabled 
		public Boolean isResult;
        @AuraEnabled 
        public String message;
        @AuraEnabled
        public List<ServicioRelacionadoWrapper> lstServicioRelacionadoWrapper;
        @AuraEnabled 
        public List<String> lstSubsidios;
    }

    public class ServicioRelacionadoWrapper
    {
        @AuraEnabled
        public RL2_MatrizParametrizacionSubsidio__c vServicio;
        @AuraEnabled
        public List<RelacionadoConWrapper> lstRelacionadoConWrapper = new List<RelacionadoConWrapper>();
    }

    public class RelacionadoConWrapper
    {
        @AuraEnabled
        public RL2_MatrizParametrizacionSubsidio__c vRelacionadoCon;
        @AuraEnabled
        public List<RL2_MatrizParametrizacionSubsidio__c> lstRequisitos = new List<RL2_MatrizParametrizacionSubsidio__c>();
        @AuraEnabled
        public List<RL2_MatrizParametrizacionSubsidio__c> lstMedioAtencion = new List<RL2_MatrizParametrizacionSubsidio__c>();
    }

    /**
     * ResultWrapper Class
     */
    public class ResultWrapper {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String text;
        @AuraEnabled
        public String val;
    }

    /**
     * FileInfo Class
     */
    public class FileInfo {
        public String title;
        public Blob versionData;
    }
    
}