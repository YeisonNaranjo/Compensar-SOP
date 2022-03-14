/***********************************************************************************************
Desarrollado por:   Globant Colombia
Autor:              Carlos Suarez (CS)
Proyecto:           Compensar Release Q2 (RL2)
Descripción:        Clase para obtener las dependencias entre campos
Cambios (Versiones)
-----------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    -----------------------------------------------------
1.0     2021-05-27      Carlos Suarez           Creación de la clase
*************************************************************************************************/
public without sharing class RL2_DependentField_ctr {

    /**
     * Get Dependent PickList Value
     * @param SObject objDetail
     * @param String contrfieldApiName
     * @param String depfieldApiName
     * @param Set<String> lstFields
     * @return List<RL2_CasoWebPCE_ctr.DependencyResultWrapper>
     */
    public static List<RL2_CasoWebPCE_ctr.DependencyResultWrapper> getDependentMap(Sobject objDetail, 
    String contrfieldApiName,
    String depfieldApiName,
    Set<String> lstFields) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        List<RL2_CasoWebPCE_ctr.DependencyResultWrapper> outPutResult = new List<RL2_CasoWebPCE_ctr.DependencyResultWrapper>();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        List<Map<String, String>> lstStrOBject = new List<Map<String, String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return outPutResult;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return outPutResult;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            lstStrOBject.addAll(new List <Map<String, String>> {
                new Map<String, String>{ 'label'=>label , 'value'=>ple.getValue() }
               });
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    if(lstFields.contains(label)){
                        objResults.get(controllingValues.get(i)).add(label);
                    }else{
                        objResults.remove(controllingValues.get(i));
                    }
                }
            }
        }
        Map<String, List<String>> mpProcess = RL2_CasoWebPCE_ctr.getProcessDependencies(objDetail, contrfieldApiName);
        List<String> lstProceso = mpProcess.get(System.Label.RL2_Proceso);
        for(Map<String, String> mp : lstStrOBject){
            if(objResults.containsKey(mp.get('label')) && lstProceso.contains(mp.get('label'))){
                RL2_CasoWebPCE_ctr.DependencyResultWrapper otp = new RL2_CasoWebPCE_ctr.DependencyResultWrapper();
                otp.text = mp.get('label');
                otp.val = mp.get('value');
                otp.lstVal = objResults.get(mp.get('label'));
                outPutResult.add(otp);
            }
        }

        return outPutResult;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) {
            return '';
        }
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = BASE64CHARS.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String BASE64CHARS = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> pLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(pLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
    }

    
}