/***********************************************************************************************
Desarrollado por:   Globant Colombia
Autor:              Carlos Suarez (CS)
Proyecto:           Compensar Release Q2 (RL2)
Descripción:        Clase Utilities
Cambios (Versiones)
-----------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    -----------------------------------------------------
1.0     2021-05-27      Carlos Suarez           Creación de la clase
1.1     2021-06-28      Carlos Suarez           Métodos Tipificación Agregados
*************************************************************************************************/
public without sharing class RL2_Utilities {

    /**
     * Get Filter List
     * @param String objApi
     * @param String fieldApi
     * @param String toExclude
     * @return Set<String>
     */
    public static Set<String> getFilterList(String objApi, String fieldApi, String toExclude){
        Set<String> lstTipo = new Set<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.sObjectType objType = schemaMap.get(objApi);
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		Map<String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
		
		List<Schema.PicklistEntry> values = fieldMap.get(fieldApi).getDescribe().getPickListValues();
		for (Schema.PicklistEntry p: values) {
			if(!toExclude.contains(String.valueOf(p.getLabel()))){
                lstTipo.add(String.valueOf(p.getLabel()));
            }
		}
        return lstTipo;
    }

    /**
     * Get SObject Name
     * @param SObject obj
     * @return String
     */
    public static String getSObjectName(SObject obj){
        Schema.SObjectType objectType = obj.getSObjectType();
        return objectType.getDescribe().getName();
    }

    /**
     * Get PickList Value
     * @param String objAPIName
     * @param String fieldAPIname
     * @param String toExclude
     * @return List<Schema.PicklistEntry>
     */
    public static List<Schema.PicklistEntry> findPicklistOptions(String objAPIName, String fieldAPIname, String toExclude) {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.sObjectType objType = schemaMap.get(objAPIName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        List<Schema.PicklistEntry> values = fieldMap.get(fieldAPIname).getDescribe().getPickListValues();
        
        
        return values;
    }

    /**
     * Get Cliente By TipoIdentificacion, NumeroIdentificacion
     * @param String tipoIdentificacion
     * @param String numeroIdentificacion
     * @return List<Account>
     */
    public static List<Account> getClienteByIdTypeNum( String tipoIdentificacion, String numeroIdentificacion ){
        List<Account> lstAccount = [SELECT Id, Name FROM Account WHERE COM_TipoIdentificacion__c = :tipoIdentificacion AND COM_Numero_de_identificacion__c = :numeroIdentificacion WITH SECURITY_ENFORCED LIMIT 1];
        return lstAccount;
    }

    /**
     * Get AccountRelation by AccountId
     * @param Id acId
     * @param String tipoIdContacto
     * @param String numeroIdContacto
     * @return List<AccountRelation>
     */
    public static List<AccountContactRelation> getAccountRelationByAccountId( Id acId, String tipoIdContacto, String numeroIdContacto){
        List<AccountContactRelation> lstRelation = [SELECT Id, ContactId FROM AccountContactRelation
                                                    WHERE AccountId = :acId
                                                    AND Contact.COM_TipoIdentificacion__c = :tipoIdContacto
                                                    AND Contact.COM_Numeroidentificacion__c = :numeroIdContacto WITH SECURITY_ENFORCED
                                                    LIMIT 1];
        return lstRelation;
    }

    /**
     * Get Case By Id
     * @param Id caseId
     * @return Case
     */
    public static Case getCaseById(Id caseId){
        List<Case> lstCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseId WITH SECURITY_ENFORCED LIMIT 1];
        return lstCase[0];
    }

    /**
     * Get Tipificación de Servicios
     * @param String vSubsidio
     * @param String vRelacionadoRecordType
     * @param String vServicioRecordType
     * @return List<CE2_matrizTipificacion__c>
     */
    public static List<CE2_matrizTipificacion__c> getTipificacionServicios(String vSubsidio, String vRelacionadoRecordType, String vServicioRecordType){
        List<CE2_matrizTipificacion__c> lstServicios = new List<CE2_matrizTipificacion__c>();
        try{
            lstServicios = [SELECT Id, Name, CE2_activo__c,CE2_MediosAtencion__c,CE2_Programas__c,CE2_apiName__c,/*RL2_Tooltip__c,*/
                                CE2_textoOpcion__c, (SELECT Id,Name, CE2_apiName__c,CE2_nivelSuperior__c,CE2_textoOpcion__c,CE2_MediosAtencion__c 
                                FROM Nivel_superior_matriz__r 
                                WHERE CE2_activo__c = true AND RecordType.DeveloperName =: vRelacionadoRecordType
                                AND CE2_Programas__c includes(:vSubsidio)) 
                                FROM CE2_matrizTipificacion__c
                                WHERE RecordType.DeveloperName =: vServicioRecordType AND CE2_activo__c = true 
                                AND CE2_Programas__c includes(:vSubsidio) WITH SECURITY_ENFORCED
                                ORDER BY CE2_apiName__c ASC];            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return lstServicios;
    }

    /**
     * Get Tipificacion Api Relacionado
     * @param String vRelacionadoId
     * @return String
     */
    public static String getTipificacionApiRelacionado (String vRelacionadoId)
    {
        String vApiRelacionado = '';
        CE2_matrizTipificacion__c vRelacionado = [SELECT Id, Name, CE2_apiName__c 
                                                                    FROM CE2_matrizTipificacion__c 
                                                                    WHERE Id = :vRelacionadoId WITH SECURITY_ENFORCED];
        if(String.isNotBlank(vRelacionado.Id)){ vApiRelacionado = vRelacionado.CE2_apiName__c; }
        return vApiRelacionado;
    }

    /**
     * Get Tipificacion Requisito - Medios Atencion
     * @param String vSubsidio
     * @param String vRequisitoRecordType
     * @param Set<Id> lstRelacionadoConId
     * @param String vMedioARecordType
     * @return List<CE2_matrizTipificacion__c>
     */
    public static List<CE2_matrizTipificacion__c> getTipificacionRequisitoMedio(String vSubsidio, 
    String vRequisitoRecordType, 
    Set<Id> lstRelacionadoConId, 
    String vMedioARecordType){
        List<CE2_matrizTipificacion__c> lstRequisitoMedio = new List<CE2_matrizTipificacion__c>();
        try{
            lstRequisitoMedio = [SELECT Id, Name, CE2_apiName__c, 
                                    CE2_nivelSuperior__c,CE2_textoOpcion__c,CE2_Icono__c,CE2_EtiquetaDescargas__c,        
                                    CE2_MediosAtencion__c,CE2_NombreRequisito__c,RecordType.DeveloperName 
                                    FROM CE2_matrizTipificacion__c
                                    WHERE (RecordType.DeveloperName =: vRequisitoRecordType AND CE2_Programas__c includes(:vSubsidio) 
                                    AND CE2_nivelSuperior__c IN:lstRelacionadoConId  AND CE2_activo__c = true) 
                                    OR (RecordType.DeveloperName =: vMedioARecordType AND CE2_activo__c = true) WITH SECURITY_ENFORCED];
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return lstRequisitoMedio;
    }

    /**
     * Get Tipificacion Requisitos
     * @param String vSubsidio
     * @param String vRelacionado
     * @param String vRelacionado
     * @return List<CE2_matrizTipificacion__c>
     */
    public static List<CE2_matrizTipificacion__c> getTipificacionRequisitos(String vSubsidio, String vRelacionado, String vRequisitoRecordType){
        String vApiRelacionado = getTipificacionApiRelacionado(vRelacionado);
        List<CE2_matrizTipificacion__c> lstRequisitos = new List<CE2_matrizTipificacion__c>();
        try{
            lstRequisitos = [SELECT Id, Name,CE2_activo__c, CE2_NombreRequisito__c, CE2_apiName__c, 
                                        CE2_nivelSuperior__r.Name,CE2_nivelSuperior__r.CE2_nivelSuperior__r.Name, 
                                        CE2_nivelSuperior__r.CE2_nivelSuperior__r.CE2_Programas__c, CE2_textoOpcion__c
                                        FROM CE2_matrizTipificacion__c 
                                        WHERE RecordType.DeveloperName =: vRequisitoRecordType
                                        AND CE2_nivelSuperior__r.CE2_apiName__c = :vApiRelacionado
                                        AND CE2_Programas__c includes (:vSubsidio)
                                        AND CE2_activo__c = true WITH SECURITY_ENFORCED];
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
        return lstRequisitos;
    }

    /**
     * Get Dependency Fields
     * @param SObject obj
     * @param String ctrl
     * @param String dep
     * @return Map<String, List<String>>
     */
    public static Map<String,List<Map<String,String>>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String,List<Map<String,String>>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<Map<String, String>>> dependentPicklistValues = new Map<String,List<Map<String, String>>>();
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
                    
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<Map<String,String>>());
                    }
                    //dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                    dependentPicklistValues.get((String) controlValue).addAll(new List <Map<String, String>> {
                        new Map<String, String>{ 'label'=>entry.getLabel() , 'value'=>entry.getValue() }
                       });
                    
                }
            }
        }
        return dependentPicklistValues;
    }

    /**
     * Dependency Result Wrapper
     */
    public class DependencyResultWrapper {
        @AuraEnabled
        public Map<String,List<Map<String,String>>> mapVal;
        /*@AuraEnabled
        public String text;

        @AuraEnabled
        public String val;

        @AuraEnabled
        public List<String> lstVal;*/
    }
}