@isTest
public class COS_duracionProspectoXEstado_tst {
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
        
        lead nlead2 = new lead();
            nlead2.CEL1_TipoDocumento__c = '1';
            nlead2.CEL1_NumeroDocumento__c = '79937999';
            nlead2.FirstName = 'nombreTest2';
            nlead2.LastName = 'apellidoTest2';
            nlead2.Phone = '3107553366';
            nlead2.MobilePhone = '3107553366';
            nlead2.Email = 'emailtes2@gmail.com';
            nlead2.COS_Nit_empresa__c = '';
            nlead2.COS_Genero__c = 'Masculino';
            nlead2.COS_FechaIngresoSolicitud__c = system.now().addDays(-1);
            nlead2.LeadSource = 'Sede Av. 68';
            nlead2.COS_Categoria_Caja__c = 'Categoria Caja';
            nlead2.COS_Asignado_salud__c = true;
            nlead2.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');		
			nlead2.Status = 'Validado';
        	nlead2.COS_Dia_de_contacto__c = 'Martes';
            nlead2.COS_Horario_ideal_contacto__c = 'Tarde';
            nlead2.COS_Asegurabilidad__c = 'Si';
        insert nlead2;
        
        COS_HistoricoEstadosProspectoSalud__c nHis2 = new COS_HistoricoEstadosProspectoSalud__c();
        nHis2.COS_EstadoInicial__c = 'Validado';
        nHis2.COS_FechaInicio__c = system.now().addDays(-5);
        nHis2.COS_IDProspecto__c = nlead2.Id;
        nHis2.COS_FechaFin__c = null;
        insert nHis2;
    }
    
	@isTest
    public static void duracionProspectoXEstado_tst1(){
        String cronExpr = '0 0 0 15 3 ? 2022';
        Test.startTest();
        	COS_duracionProspectoXEstado_sch abs = new COS_duracionProspectoXEstado_sch();
        	String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
        	abs.execute(null);
        
	        COS_duracionProspectoXEstado_bch b = new COS_duracionProspectoXEstado_bch();
	        Database.executeBatch (b,5);
        Test.stopTest(); 
    }    
}