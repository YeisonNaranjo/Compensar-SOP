public class COS_LeadHelper_cls {
	public static void validarProspectoSalud(List<Lead> lstLeadNew){
        string strTipoDocumento = '';
        List<RecordType> lstRecordType = [select DeveloperName, Id from RecordType where SobjectType = 'Lead'];
        Map<String,Id> mapRecordType = new Map<String,Id>();
        
        for (RecordType objRecord: lstRecordType) {
            mapRecordType.put(objRecord.DeveloperName, objRecord.Id);
        }
        
        list<COS_Homologacion_tipo_documento__mdt> lstDocType = [select DeveloperName, MasterLabel, COS_Codigo_cotizador__c, COS_Codigo_Salesforce__c, COS_Codigo_VVP__c, COS_Valor_carga__c 
                                                           		from COS_Homologacion_tipo_documento__mdt];
        
        Map<string,string> mapDocType = new Map<string,string>();
        for(COS_Homologacion_tipo_documento__mdt htd: lstDocType){
            mapDocType.put(htd.COS_Valor_carga__c, htd.COS_Codigo_Salesforce__c);
        }
        
        for(Lead ld:lstLeadNew){
            if(ld.COS_MigradoSalud__c==true && ld.isClone()==false){ //agrego condicion para verificar si el registro es clonado
                if(mapDocType.get(ld.COS_Tipo_documento_carga__c)=='null' || mapDocType.get(ld.COS_Tipo_documento_carga__c)==null || mapDocType.get(ld.COS_Tipo_documento_carga__c)==''){
                    ld.CEL1_TipoDocumento__c = '999';
                }else{    
            		ld.CEL1_TipoDocumento__c = mapDocType.get(ld.COS_Tipo_documento_carga__c);  
                }
                ld.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');
            	
            }
        }
    }
}