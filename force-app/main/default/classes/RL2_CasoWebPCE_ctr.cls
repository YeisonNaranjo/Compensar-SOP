/***********************************************************************************************
Desarrollado por:   Globant Colombia
Autor:              Carlos Suarez (CS)
Proyecto:           Compensar Release Q2 (RL2)
Descripción:        Clase Caso Web PCE
Cambios (Versiones)
-----------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    -----------------------------------------------------
1.0     2021-05-26      Carlos Suarez           Creación de la clase
*************************************************************************************************/
public without sharing class RL2_CasoWebPCE_ctr {

    private final static String NIT = '2';

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
     * Get Tipo Documentos
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getTipoDocumentos() {
        try {

            List<RL2_TipoDocumentoCaso__mdt> lstTipoDocumentos = [SELECT RL2_DocumentoId__c, RL2_TipoDocumento__c FROM RL2_TipoDocumentoCaso__mdt WHERE RL2_PCE__c = true ORDER BY RL2_DocumentoId__c ASC];
        
            List<ResultWrapper> lstDocumentos = new List<ResultWrapper>();
            
            for(RL2_TipoDocumentoCaso__mdt mdtTipoDocumento : lstTipoDocumentos)
            {
                ResultWrapper lstWrapObj = new ResultWrapper();
                lstWrapObj.name = 'RL2_TipoDocumentoCaso__mdt';
                lstWrapObj.text = mdtTipoDocumento.RL2_TipoDocumento__c;
                lstWrapObj.val = mdtTipoDocumento.RL2_DocumentoId__c;
                lstDocumentos.add(lstWrapObj);
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
        
            for(medioRespuesta__mdt mdtMedio : lstMRespuesta)
            {
                ResultWrapper lstWrapObj = new ResultWrapper();
                lstWrapObj.name = 'medioRespuesta__mdt';
                lstWrapObj.text = mdtMedio.MasterLabel;
                lstWrapObj.val = mdtMedio.CE2_APIListaValor__c;
                lstMedios.add(lstWrapObj);
            }
            return lstMedios;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Find Pick List Options
     * @param String objAPIName
     * @param String fieldAPIname
     * @param String toExclude
     * @return List<ResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> findPicklistOptions(String objAPIName, String fieldAPIname, String toExclude) {
        try {
            List<ResultWrapper> lstValues = new List<ResultWrapper>();
            List<Schema.PicklistEntry> values = RL2_Utilities.findPicklistOptions(objAPIName, fieldAPIname, toExclude);
            for (Schema.PicklistEntry p: values) {
                if(!toExclude.contains(String.valueOf(p.getLabel()))) {
                    ResultWrapper pl = new ResultWrapper();
                    pl.name = objAPIName;
                    pl.text = p.getLabel();
                    pl.val = p.getValue();
                    lstValues.add(pl);
                }
            }
            system.debug('*****lstValues'+lstValues);
            return lstValues;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    /**
     * Get Dependency Fields
     * @param SObject obj
     * @param String ctrl
     * @param String dep
     * @return List<DependencyResultWrapper>
     */
    @AuraEnabled(cacheable=true)
    public static List<DependencyResultWrapper> getDependentMap(SObject obj, String ctrl, String dep){
        try {
            String objName = RL2_Utilities.getSObjectName(obj);
            Set<String> lstTipo = RL2_Utilities.getFilterList(objName, dep, System.Label.RL2_Solicitud_GIE_lbl);
            List<DependencyResultWrapper> dependencies = RL2_DependentField_ctr.getDependentMap(obj, ctrl, dep, lstTipo);
            
            return dependencies;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    public static Map<String, List<String>> getProcessDependencies(SObject obj, String vField){
        String vDependent = vField.toLowerCase();
        Schema.sObjectType objType = obj.getSObjectType();
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        Schema.SObjectField vDeptField = objFieldMap.get(vDependent);
        return getDependentPicklistValues(vDeptField, System.Label.RL2_Proceso);
    }

    /**
     * Get Dependency Fields
     * @param SObject obj
     * @param String ctrl
     * @param String dep
     * @return Map<String, List<String>>
     */
    public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken, String vProceso) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0){
                        continue;
                    }
                    if((String) controlValue == vProceso){
                        if (!dependentPicklistValues.containsKey((String) controlValue)) {
                            dependentPicklistValues.put((String) controlValue, new List<String>());
                        }
                        dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                    }
                }
            }
        }
        return dependentPicklistValues;
    }

    /**
     * Create Case 
     * @param Case vCaso
     * @return Caso
     */
    public static Case createCase( Case vCaso ){
        Case tmpCaso = vCaso;
        Date fechaSuceso;
        String tipoIdentificacionAnonimo = System.Label.RF2_TipoIdentificacionClienteAnonimo_lbl;
        String numeroIdentAnonimo = System.Label.RF2_NumeroIdentificacionClienteAnonimo_lbl;
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
        tmpCaso.RF2_FechaSuceso__c = Date.valueOf(tmpCaso.RF2_FechaSuceso__c);

        List<AccountContactRelation> lstRelacion = new List<AccountContactRelation>();
        List<Contact> lstContact = new List<Contact>();
        List<Account> lstClientes = new List<Account>();

        if(tmpCaso.RF2_Anonimo__c){
            lstContact = getContactAnonimo(tipoIdentificacionAnonimo, numeroIdentAnonimo);
            if(lstContact.isEmpty()) {
                throw new AuraHandledException('No se encontró el Cliente Anónimo, consulte el administrador CRM.');
            }
            tmpCaso.AccountId = lstContact.get(0).AccountId;
            tmpCaso.ContactId = lstContact.get(0).Id;
        }else{

            if(NIT.equals(tmpCaso.RF2_TipoIdentificacionHuerfano__c)){
                tipoIdContacto = tmpCaso.RF2_TipoIdentificacionContactoHuerfano__c;
                numeroIdContacto = tmpCaso.RF2_NumeroIdentificacionContactoHuerfano__c;
            }

            lstClientes = getClienteByIdTypeNum(tipoId, numId);
            if(!lstClientes.isEmpty()) {
                tmpCaso.AccountId = lstClientes.get(0).Id;
                if(NIT == tmpCaso.RF2_TipoIdentificacionHuerfano__c) {
                    lstRelacion = getAccountRelationByAccountId(lstClientes.get(0).Id, tipoIdContacto, numeroIdContacto);
                    if(!lstRelacion.isEmpty()) {
                        tmpCaso.ContactId = lstRelacion.get(0).ContactId;
                    }
                } else {
                    lstContact = [SELECT Id FROM Contact
                                    WHERE COM_TipoIdentificacion__c = :tipoId
                                    AND COM_Numeroidentificacion__c = :numId
                                    AND AccountId =: lstClientes.get(0).Id LIMIT 1];
                    if(!lstContact.isEmpty()) {
                        tmpCaso.ContactId = lstContact.get(0).Id;
                    }
                }
            }else {
                system.debug('No se ha encontrado informacion del cliente TipoID: ' + tipoId + ', numID: ' +numId);
            }

        }

        try{
            insert tmpCaso;
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        tmpCaso = getCaseById(tmpCaso.Id);
        return tmpCaso;
    }

    /**
     * Save Case Files
     * @param String parentId
     * @param Case vCaso
     * @param List<Object> filesToInsert
     * @return Case
     */
    @AuraEnabled
    public static Case saveCaseFiles(String parentId, Case vCaso, List<Object> filesToInsert){
        
        Case nCaso = createCase(vCaso);
        //if(!Test.isRunningTest()){
            List<Id> lstContentVersionIds = new list<Id>();
            List<ContentVersion> lstContentVersion = new List<ContentVersion>();
            
            for (Object file : filesToInsert) {
                FileInfo fileData = (FileInfo) System.JSON.deserialize(System.JSON.serialize(file), FileInfo.class);
                ContentVersion vContentVersion = new ContentVersion();
                vContentVersion.PathOnClient = '/' + fileData.title;
                vContentVersion.FirstPublishLocationId = nCaso.Id;
                vContentVersion.Title = fileData.title;
                vContentVersion.VersionData = fileData.versionData;
                lstContentVersion.add(vContentVersion);
            }
            
            if(!lstContentVersion.isEmpty()) {
                insert lstContentVersion;
            }
            
            system.debug('Content Version --->' +lstContentVersion);
        //}   

        return nCaso;
    }

    /**
     * Get Cliente By TipoIdentificacion, NumeroIdentificacion
     * @param String tipoIdentificacion
     * @param String numeroIdentificacion
     * @return List<Account>
     */
    private static List<Account> getClienteByIdTypeNum( String tipoIdentificacion, String numeroIdentificacion ){
        List<Account> lstAccount = new List<Account>();
        if(
            Account.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Account.fields.Id.isAccessible() &&
            Schema.SObjectType.Account.fields.Name.isAccessible()
        ){
            lstAccount = [SELECT Id, Name FROM Account WHERE COM_TipoIdentificacion__c = :tipoIdentificacion AND COM_Numero_de_identificacion__c = :numeroIdentificacion LIMIT 1];
        }

        return lstAccount;
    }

    /**
     * Get Contact By TipoIdentificacionAnonimo, NumeroIdentificacionAnonimo
     * @param String idTypeAnonimo
     * @param String numIdentAnonimo
     * @return List<Contact>
     */
    private static List<Contact> getContactAnonimo(String idTypeAnonimo, String numIdentAnonimo){
        List<Contact> lstContact = new List<Contact>();
        if(
            Contact.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Contact.fields.Id.isAccessible() &&
            Schema.SObjectType.Contact.fields.AccountId.isAccessible()
        ){
            lstContact = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :idTypeAnonimo AND COM_Numeroidentificacion__c = :numIdentAnonimo LIMIT 1];
        }

        return lstContact;
    }

    /**
     * Get AccountRelation by AccountId
     * @param Id acId
     * @param String tipoIdContacto
     * @param String numeroIdContacto
     * @return List<AccountRelation>
     */
    private static List<AccountContactRelation> getAccountRelationByAccountId( Id acId, String tipoIdContacto, String numeroIdContacto){
        List<AccountContactRelation> lstRelation = new List<AccountContactRelation>();
        if(
            AccountContactRelation.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.AccountContactRelation.fields.Id.isAccessible() &&
            Schema.SObjectType.AccountContactRelation.fields.ContactId.isAccessible()
        ){
            lstRelation = [SELECT Id, ContactId FROM AccountContactRelation
                                             WHERE AccountId = :acId
                                                AND Contact.COM_TipoIdentificacion__c = :tipoIdContacto
                                                AND Contact.COM_Numeroidentificacion__c = :numeroIdContacto
                                                LIMIT 1];
        }

        return lstRelation;
    }

    /**
     * Get Case By Id
     * @param Id caseId
     * @return Case
     */
    private static Case getCaseById(Id caseId){
        List<Case> lstCase = new List<Case>();
        if(
            Case.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Case.fields.Id.isAccessible() &&
            Schema.SObjectType.Case.fields.CaseNumber.isAccessible()
        ){
            lstCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseId LIMIT 1];
        }
        
        return lstCase[0];
    }

    /**
     * Return default Country
     * @return ResultWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getDefaultCountry(){
        
        ResultWrapper lstWrapObj = new ResultWrapper();
                
        List<RL2_Poblacion__c> lstPoblacion = new List<RL2_Poblacion__c>();
        String vPais = System.Label.RL2_DefaultCountry_lbl;
        lstPoblacion  = [SELECT Id, Name FROM RL2_Poblacion__c WHERE Name =: vPais AND RL2_EsPais__c = true LIMIT 1];
        
        if(!lstPoblacion.isEmpty()){
            lstWrapObj.name = 'RL2_Poblacion__c';
            lstWrapObj.text = lstPoblacion[0].Name;
            lstWrapObj.val = lstPoblacion[0].Id;
        }
        
        return lstWrapObj;
    }

    /**
     * Return default State
     * @return ResultWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getDefaultState(String parentId){
        
        ResultWrapper lstWrapObj = new ResultWrapper();
                
        List<RL2_Poblacion__c> lstPoblacion = new List<RL2_Poblacion__c>();
        String vState = System.Label.RL2_DefaultState_lbl;
        lstPoblacion  = [SELECT Id, Name FROM RL2_Poblacion__c WHERE RL2_EsDepartamento__c = true AND RL2_PoblacionPadre__c =:parentId AND Name =:vState LIMIT 1];
        
        if(!lstPoblacion.isEmpty()){
            lstWrapObj.name = 'RL2_Poblacion__c';
            lstWrapObj.text = lstPoblacion[0].Name;
            lstWrapObj.val = lstPoblacion[0].Id;
        }
        
        return lstWrapObj;
    }

    /**
     * Return default City
     * @return ResultWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getDefaultCity(String parentId){
        
        ResultWrapper lstWrapObj = new ResultWrapper();
                
        List<RL2_Poblacion__c> lstPoblacion = new List<RL2_Poblacion__c>();
        String vCity = System.Label.RL2_DefaultCity_lbl;
        lstPoblacion  = [SELECT Id, Name FROM RL2_Poblacion__c WHERE RL2_EsMunicipio__c  = true AND RL2_PoblacionPadre__c =:parentId AND Name =:vCity LIMIT 1];        
        if(!lstPoblacion.isEmpty()){
            lstWrapObj.name = 'RL2_Poblacion__c';
            lstWrapObj.text = lstPoblacion[0].Name;
            lstWrapObj.val = lstPoblacion[0].Id;
        }
        
        return lstWrapObj;
    }

    /**
     * Dependency Result Wrapper
     */
    public class DependencyResultWrapper {

        @AuraEnabled
        public String text;

        @AuraEnabled
        public String val;

        @AuraEnabled
        public List<String> lstVal;
    }

    /**
     * FileInfo Class
     */
    public class FileInfo {
        public String title;
        public Blob versionData;
    }

    
    
}