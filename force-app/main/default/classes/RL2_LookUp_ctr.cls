/***********************************************************************************************
Desarrollado por:   Globant Colombia
Autor:              Carlos Suarez (CS)
Proyecto:           Compensar Release Q2 (RL2)
Descripción:        Clase Lookup
Cambios (Versiones)
-----------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    -----------------------------------------------------
1.0     2021-05-31      Carlos Suarez           Creación de la clase
*************************************************************************************************/
public without sharing class RL2_LookUp_ctr {

    private static final String NAME_FIELD = 'Name';
    
    @AuraEnabled(Cacheable=true)
    public static SObject getRecord(Id recordId, List<Object> fields) {
        String vFieldsString = String.join(getApiNamesFromFields(fields), ',');
        if(!vFieldsString.contains(NAME_FIELD)) { vFieldsString += ',Name'; }
        String vType = recordId.getSobjectType().getDescribe().getName();
        SObject vResult = Database.query(String.format('SELECT {0} FROM {1} WHERE Id = :recordId LIMIT 1', new String[]{vFieldsString, vType}));
        return vResult;
    }

    @AuraEnabled(Cacheable=true)
    public static List<SObject> searchRecords(String valSearch, Object valObjectApiName, List<Object> valFields) {
        String vObjectApiName = String.valueOf(((Map<Object, Object>)valObjectApiName).get('objectApiName'));
        List<SObject> vResult = new List<SObject>();
        List<String> vFields = getApiNamesFromFields(valFields);
        String vFieldsString = String.join(vFields, ',');
        if(!vFieldsString.contains(NAME_FIELD)) { vFieldsString += ',Name'; }

        if(String.isNotBlank(valSearch)) {
            valSearch = String.format('%{0}%', new String[]{valSearch.trim()});
            List<String> vWhereField = new List<String>();
            for(String vField: vFields) {
                vWhereField.add(String.format('{0} LIKE :valSearch', new String[]{vField}));
            }
            System.debug(vWhereField);
            vResult = Database.query(String.format('SELECT {0} FROM {1} WHERE {2} ORDER BY Name DESC LIMIT 99', 
                new String[]{vFieldsString, vObjectApiName, String.join(vWhereField, ' OR ')}));
        } else {
            vResult = Database.query(String.format('SELECT {0} FROM {1} ORDER BY Name DESC LIMIT 9', new String[]{vFieldsString, vObjectApiName}));
        }
        return vResult;
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> lookUp(String searchTerm, String myObject, String filter) {
        String myQuery = null;
        
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' ORDER BY Name ASC'; 
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where CreatedDate != NULL ORDER BY CreatedDate DESC LIMIT  5'; 
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        System.debug('myQuery: ' + myQuery);
        List<SObject> lookUpList = Database.query(myQuery);

        return lookUpList;  
    }

    public static List<String> getApiNamesFromFields(List<Object> valFields) {
        List<String> vResult = new List<String>();
        for(Object vField: valFields) {
            vResult.add(String.valueOf(((Map<Object, Object>)vField).get('fieldApiName')));
        }
        return vResult;
    }

    // Method to fetch lookup default value 
    @AuraEnabled
    public static sObject fetchDefaultRecord(String recordId , String sObjectApiName) {
        if(recordId != null && recordId != ''){
            string sRecId = recordId;
            string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
            for (SObject obj: database.query(sQuery)) {
                return obj;
            }
        }
        return null;
    }

}