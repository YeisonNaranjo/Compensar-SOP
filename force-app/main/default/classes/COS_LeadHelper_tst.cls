@isTest
public class COS_LeadHelper_tst {
    @istest
    public static void leadHelper_tst1(){
        string idRecordType = [select id, name from RecordType where DeveloperName ='COS_ProspectoSalud' limit 1].id;
        list<Lead> lstLead = new list<Lead>();
        
        Lead objLd                      = new Lead();
        objLd.FirstName                 = 'Prueba1';
        objLd.MiddleName                = 'Test1';
        objLd.LastName                  = 'Compensar1';
        objLd.CEL1_TipoCandidato__c     = 'Salud';
//        objLd.CEL1_TipoDocumento__c     = 'CC';
        objLd.CEL1_NumeroDocumento__c   = '8800990077';
        objLd.Email                     = 'prueba@prueba.com';
        objLd.COS_MigradoSalud__c 		= true;
		objLd.RecordTypeId				= idRecordType;
        objLd.COS_Tipo_documento_carga__c = 'CC';
        objLd.Status					= 'Validado';
        lstLead.add(objLd);
        
        Lead objLd2                     = new Lead();
        objLd2.FirstName                = 'Prueba';
        objLd2.MiddleName               = 'Test';
        objLd2.LastName                 = 'Compensar';
        objLd2.CEL1_TipoCandidato__c    = 'Salud';
//        objLd2.CEL1_TipoDocumento__c    = 'CC';
        objLd2.CEL1_NumeroDocumento__c	= '8800990067';
        objLd2.Email                    = 'prueba@prueba.com';
        objLd2.COS_MigradoSalud__c 		= true;
        objLd2.COS_Tipo_documento_carga__c = 'CC';
		objLd2.RecordTypeId				= idRecordType;
        objLd.Status					= 'Validado';
        lstLead.add(objLd2);
        
        Test.startTest();
			insert lstLead; 
        	system.debug('lstLead --->'+lstLead);
        	COS_LeadHelper_cls.validarProspectoSalud(lstLead);
        Test.stopTest();
        
    }
}