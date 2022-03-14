@isTest
public class COS_HistoricoEstadosLeadSalud_tst {
	@testSetup static void setupCustomValues(){
        map<string,string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Lead']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        lead nlead = new lead();
            nlead.CEL1_TipoDocumento__c = '1';
            nlead.CEL1_NumeroDocumento__c = '79937988';
            nlead.FirstName = 'nombreTest';
            nlead.LastName = 'apellidoTest';
            nlead.Phone = '3107553366';
            nlead.MobilePhone = '3107553366';
            nlead.Email = 'emailtes@gmail.com';
            nlead.COS_Nit_empresa__c = '';
            nlead.COS_Genero__c = 'Masculino';
            nlead.COS_FechaIngresoSolicitud__c = system.now().addDays(-1);
            nlead.LeadSource = 'Sede Av. 68';
            nlead.COS_Categoria_Caja__c = 'Categoria Caja';
            nlead.COS_Asignado_salud__c = true;
            nlead.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');		
			nlead.Status = 'Validado';
        	nlead.COS_Dia_de_contacto__c = 'Martes';
            nlead.COS_Horario_ideal_contacto__c = 'Tarde';
            nlead.COS_Asegurabilidad__c = 'Si';
        insert nlead;
        
        COS_HistoricoEstadosProspectoSalud__c nHis = new COS_HistoricoEstadosProspectoSalud__c();
        nHis.COS_EstadoInicial__c = 'Validado';
        nHis.COS_FechaInicio__c = system.now().addDays(-12);
        nHis.COS_IDProspecto__c = nlead.Id;
        nHis.COS_FechaFin__c = null;
        insert nHis;
    }
    
    @isTest
    public static void historicoEstadosLeadSalud_tst1(){
        String cronExpr = '0 0 0 15 3 ? 2022';
        Test.startTest();
        	COS_HistoricoEstadosProspectoSalud__c regH = [select id, name, COS_EstadoInicial__c, COS_FechaInicio__c, COS_IDProspecto__c, COS_FechaFin__c 
                                                          from COS_HistoricoEstadosProspectoSalud__c 
                                                          where COS_FechaFin__c=null
                                                          limit 1];
        	
        	regH.COS_FechaFin__c = system.now();
        	update regH;
        Test.stopTest(); 
    }
}