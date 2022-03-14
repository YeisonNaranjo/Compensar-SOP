@isTest
public class COS_reasignacionProspecto_tst {
	@testSetup
    public static void reasignacionProspecto_stp(){
        list<lead> lstLead = new list<lead>();
        list<user> lstUsr = new list<user>();
        
        map<string, string> mapRecordTypeLd = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Lead']){
            mapRecordTypeLd.put(rt.DeveloperName, rt.id);
        }
		
        map<string, string> mapProfiles = new map<string, string>();
        for(profile pf:[select id, name from profile]){
            mapProfiles.put(pf.name, pf.Id);
        }
        
		string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        User usr = new User();
        	usr.firstname = 'Alan';
        	usr.lastName = 'McCarthy';
       	 	usr.email = 'test@test.org';
        	usr.Username = 'test1@test.org.pr';
        	usr.EmailEncodingKey = 'ISO-8859-1';
        	usr.Alias = 'test'; 
        	usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr.LocaleSidKey = 'en_US'; 
        	usr.LanguageLocaleKey = 'en_US'; 
        	usr.ProfileId = mapProfiles.get('Coordinador Comercial Salud'); 
        	usr.COS_No_Cuentas_reasignadas__c = 1;
        	usr.COS_No_Oportunidades_reasignadas__c = 1;
        insert usr;
        
        User usr2 = new User();
        	usr2.firstname = 'Alan';
        	usr2.lastName = 'McCarthy';
       	 	usr2.email = 'test@test.org';
        	usr2.Username = 'test2@test.org.pr';
        	usr2.EmailEncodingKey = 'ISO-8859-1';
        	usr2.Alias = 'test'; 
        	usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr2.LocaleSidKey = 'en_US'; 
        	usr2.LanguageLocaleKey = 'en_US'; 
        	usr2.ProfileId = mapProfiles.get('Asesor Comercial Salud');
        	usr2.COS_No_Cuentas_reasignadas__c = 2;
        	usr2.COS_No_Oportunidades_reasignadas__c = 2;
        	usr2.ManagerId = usr.Id;
		lstUsr.add(usr2);
        
        User usr3 = new User();
        	usr3.firstname = 'Alan';
        	usr3.lastName = 'McCarthy';
       	 	usr3.email = 'test@test.org';
        	usr3.Username = 'test@test.org.pr';
        	usr3.EmailEncodingKey = 'ISO-8859-1';
        	usr3.Alias = 'test'; 
        	usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr3.LocaleSidKey = 'en_US'; 
        	usr3.LanguageLocaleKey = 'en_US'; 
        	usr3.ProfileId = mapProfiles.get('Asesor Comercial Salud'); 
        	usr3.COS_No_Cuentas_reasignadas__c = 3;
        	usr3.COS_No_Oportunidades_reasignadas__c = 3;
        	usr2.ManagerId = usr.Id;
        lstUsr.add(usr3);
        insert lstUsr;
        
        lead nld = new lead();
            nld.CEL1_TipoDocumento__c = '1';
            nld.CEL1_NumeroDocumento__c = '79937988';
            nld.FirstName = 'nombreTest';
            nld.LastName = 'apellidoTest';
            nld.Phone = '3107553366';
            nld.MobilePhone = '3107553366';
            nld.Email = 'emailtes@gmail.com';
            nld.COS_Nit_empresa__c = '';
            nld.COS_Genero__c = 'Masculino';
            nld.COS_FechaIngresoSolicitud__c = system.now().addDays(-1);
            nld.LeadSource = 'Sede Av. 68';
            nld.COS_Categoria_Caja__c = 'Categoria Caja';
            nld.COS_Asignado_salud__c = true;
            nld.RecordTypeId = mapRecordTypeLd.get('COS_ProspectoSalud');		
			nld.Status = 'Validado';
        	nld.COS_Dia_de_contacto__c = 'Martes';
            nld.COS_Horario_ideal_contacto__c = 'Tarde';
            nld.COS_Asegurabilidad__c = 'Si';
        	nld.OwnerId = usr2.id;
        lstLead.add(nld);
        
        lead nld2 = new lead();
            nld2.CEL1_TipoDocumento__c = '1';
            nld2.CEL1_NumeroDocumento__c = '79937988';
            nld2.FirstName = 'nombreTest';
            nld2.LastName = 'apellidoTest';
            nld2.Phone = '3107553366';
            nld2.MobilePhone = '3107553366';
            nld2.Email = 'emailtes@gmail.com';
            nld2.COS_Nit_empresa__c = '';
            nld2.COS_Genero__c = 'Masculino';
            nld2.COS_FechaIngresoSolicitud__c = system.now().addDays(-1);
            nld2.LeadSource = 'Sede Av. 68';
            nld2.COS_Categoria_Caja__c = 'Categoria Caja';
            nld2.COS_Asignado_salud__c = true;
            nld2.RecordTypeId = mapRecordTypeLd.get('COS_ProspectoSalud');		
			nld2.Status = 'Validado';
        	nld2.COS_Dia_de_contacto__c = 'Martes';
            nld2.COS_Horario_ideal_contacto__c = 'Tarde';
            nld2.COS_Asegurabilidad__c = 'Si';
        	nld2.OwnerId = usr2.id;
        lstLead.add(nld2);
		insert nld2;
    }
    
    @isTest
    public static void reasignacionProspecto_tst1(){
        list<lead> lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead];
        system.debug('lstLead size --->'+lstLead.size());
        test.startTest();
//        	test.setCurrentPage(page.COS_reasignacionCuenta_vfp);
			pageReference pagRef = page.COS_reasignacionOportunidad_vfp;
        	test.setCurrentPage(pagRef);
      //  	ApexPages.StandardController sc = new ApexPages.StandardController(lstAcc[0]);
        	ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstLead);
        	COS_reasignacionProspecto_ctr objController = new COS_reasignacionProspecto_ctr(controller);
        	controller.setSelected(lstLead);	
        	objController.getselectedaccnamefields();
        	objController.cancelar();
        	objController.selectedAsesor = '- None -'; 
        	objController.asesorDistribucion = false;
        	objController.reasignar();
        	controller.getSelected();
        test.stopTest();
    }
    
    @isTest
    public static void reasignacionProspecto_tst2(){
        list<lead> lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead];
        set<Id> Ids = new Set<Id>();
        for(lead ld:lstLead){
            Ids.add(ld.id);
        }
        // list<user> lstUser = [select id, name, COS_No_Cuentas_reasignadas__c from user where COS_Usuario_no_disponible__c= false order by COS_No_Cuentas_reasignadas__c asc];
        list<user> lstUser = new list<user>(); 
        system.debug('lstLead size --->'+lstLead.size());
        test.startTest();
			pageReference pagRef = page.COS_reasignacionCuenta_vfp;
        	test.setCurrentPage(pagRef);
        	ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstLead);
        	COS_reasignacionProspecto_ctr objController = new COS_reasignacionProspecto_ctr(controller);
        	controller.setSelected(lstLead);	
        	objController.memIds = Ids;
        	objController.lstLead = lstLead;
        	objController.lstUser = lstUser;
        	objController.selectedAsesor = '- None -'; 
        	objController.asesorDistribucion = true;
        	objController.reasignar();
        	controller.getSelected();
        test.stopTest();
    }
    
    @isTest
    public static void reasignacionProspecto_tst3(){
        list<lead> lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead];
        set<Id> Ids = new Set<Id>();
        for(lead ld:lstLead){
            Ids.add(ld.id);
        }
        list<user> lstUser = [select id, name, COS_No_Prospectos_asignados__c from user where COS_No_Prospectos_asignados__c > 0 and COS_Usuario_no_disponible__c= false order by COS_No_Prospectos_asignados__c asc];
        list<user> lstUserNull = new list<user>();
        system.debug('lstLead size --->'+lstLead.size());
        test.startTest();
			pageReference pagRef = page.COS_reasignacionCuenta_vfp;
        	test.setCurrentPage(pagRef);
        	ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstLead);
        	COS_reasignacionProspecto_ctr objController = new COS_reasignacionProspecto_ctr(controller);
        	controller.setSelected(lstLead);	
        	objController.memIds = Ids;
        	objController.lstLead = lstLead;
        	objController.lstUser = lstUserNull;
        	objController.selectedAsesor = lstUser[0].id; 
        	objController.asesorDistribucion = false;
        	objController.reasignar();
        	controller.getSelected();
        test.stopTest();
    }
}