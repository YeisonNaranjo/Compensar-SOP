@isTest
public class COS_reasignacionGrupo_tst {
//	@istest (SeeAllData=true)
    @testSetup
    public static void reasignacionGrupo_stp(){
        list<account> lstAcc = new list<account>();
        list<opportunity> lstOpp = new list<opportunity>();
        list<user> lstUsr = new list<user>();
        list<AccountTeamMember> lstATM = new list<AccountTeamMember>();
        list<lead> lstLead = new list<lead>();
		set<Id> memIds = new Set<Id>();
        map<string, string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype]){
            mapRecordType.put(rt.DeveloperName, rt.id);
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
        	usr.ProfileId = ProfileId; 
        	usr.COS_No_Cuentas_reasignadas__c = 1;
        	usr.COS_No_Oportunidades_reasignadas__c = 1;
        lstUsr.add(usr);
        
        User usr2 = new User();
        	usr2.firstname = 'Alan';
        	usr2.lastName = 'McCarthy';
       	 	usr2.email = 'test33@test.org';
        	usr2.Username = 'test23@testc.org.pr';
        	usr2.EmailEncodingKey = 'ISO-8859-1';
        	usr2.Alias = 'test'; 
        	usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr2.LocaleSidKey = 'en_US'; 
        	usr2.LanguageLocaleKey = 'en_US'; 
        	usr2.ProfileId = ProfileId; 
        	usr2.COS_No_Cuentas_reasignadas__c = 1;
        	usr2.COS_No_Oportunidades_reasignadas__c = 1;
		lstUsr.add(usr2);
        
        User usr3 = new User();
        	usr3.firstname = 'Alan';
        	usr3.lastName = 'McCarthy';
       	 	usr3.email = 'test11@test.org';
        	usr3.Username = 'test11@testc.org.pr';
        	usr3.EmailEncodingKey = 'ISO-8859-1';
        	usr3.Alias = 'test'; 
        	usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr3.LocaleSidKey = 'en_US'; 
        	usr3.LanguageLocaleKey = 'en_US'; 
        	usr3.ProfileId = ProfileId; 
        	usr3.COS_No_Cuentas_reasignadas__c = 2;
        	usr3.COS_No_Oportunidades_reasignadas__c = 1;
        lstUsr.add(usr3);
        insert lstUsr;
        
        
        Account objAcc = new account();
        	objAcc.COM_TipoIdentificacion__c    = '2';
        	objAcc.COM_Numero_de_identificacion__c = '98348377';
        	objAcc.Name = 'Empresa';
        	ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        	ObjAcc.OwnerId = usr.Id;
	    	COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
		lstAcc.add(objAcc);
        
        Account objAcc2 = new account();
        	objAcc2.COM_TipoIdentificacion__c    = '2';
        	objAcc2.COM_Numero_de_identificacion__c = '98348378';
        	objAcc2.Name = 'Empresa';
        	ObjAcc2.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        	ObjAcc2.OwnerId = usr.Id;
	    	COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc2;
        lstAcc.add(objAcc2);
        memIds.add(objAcc.Id);
        memIds.add(objAcc2.Id);
        
        string UserId = UserInfo.getUserId();
        AccountTeamMember newATM = new AccountTeamMember();
        	newATM.UserId = usr.Id;
			newATM.AccountId = objAcc.Id;
        	newATM.TeamMemberRole = 'COS_AsesorConsorcioSalud';
        lstATM.add(newATM);
        
        AccountTeamMember newATM2 = new AccountTeamMember();
        	newATM2.UserId = usr.Id;
            newATM2.AccountId = objAcc2.Id;
        	newATM2.TeamMemberRole = 'COS_AsesorConsorcioSalud';
        lstATM.add(newATM2);
        insert lstATM;
        
        Opportunity objOpp = new Opportunity();
            objOpp.Name = 'Test';
            objOpp.AccountId = objAcc.id;
            objOpp.CloseDate = System.today();
            objOpp.StageName = 'Cotizado';
            objOpp.COM_Fechahorainicio__c = System.today();
            objOpp.COM_Fechahorafinalizacion__c = System.today();
            objOpp.amount = 100; 
            objOpp.COM_Requieretransporte__c = true;
            objOpp.COM_Fecharadicacioncartaretiro__c = System.today();
    //        objOpp.COM_PYS__c = '01t6A000002a4wLQAQ';
            objOpp.COM_DSCalc__c = 1000000;
            objOpp.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        	objOpp.OwnerId = usr.Id;
        	objOpp.RecordTypeId = mapRecordType.get('COS_ConsorcioSalud');
		lstOpp.add(objOpp);
        
		Opportunity objOpp2 = new Opportunity();
            objOpp2.Name = 'Test2';
            objOpp2.AccountId = objAcc2.id;
            objOpp2.CloseDate = System.today();
            objOpp2.StageName = 'Cotizado';
            objOpp2.COM_Fechahorainicio__c = System.today();
            objOpp2.COM_Fechahorafinalizacion__c = System.today();
            objOpp2.amount = 100; 
            objOpp2.COM_Requieretransporte__c = true;
            objOpp2.COM_Fecharadicacioncartaretiro__c = System.today();
    //        objOpp2.COM_PYS__c = '01t6A000002a4wLQAQ';
            objOpp2.COM_DSCalc__c = 1000000;
            objOpp2.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        	objOpp2.RecordTypeId = mapRecordType.get('COS_ConsorcioSalud');
        lstOpp.add(objOpp2);
        insert lstOpp;
        
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
            nld.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');		
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
            nld2.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');		
			nld2.Status = 'Validado';
        	nld2.COS_Dia_de_contacto__c = 'Martes';
            nld2.COS_Horario_ideal_contacto__c = 'Tarde';
            nld2.COS_Asegurabilidad__c = 'Si';
        	nld2.OwnerId = usr2.id;
        lstLead.add(nld2);
		insert nld2;
        
    }
    
    @isTest
    public static void reasignacionCuenta_tst1(){
        set<Id> memIds = new Set<Id>();
        list<account> lstAcc = [select id, name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, OwnerId, Owner.Name from account];
        for(account ac:lstAcc){
            memIds.add(ac.id);
        }
		list<User> lstUsr = [select id, name, COS_No_Cuentas_reasignadas__c from user where ManagerId<>null and IsActive=true and COS_Usuario_no_disponible__c= false order by COS_No_Cuentas_reasignadas__c asc];
        
        Test.startTest();
        	boolean blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionCuenta_mtd(lstAcc, lstUsr, memIds, 'N/A');
        Test.stopTest();
    }
    
    @isTest
    public static void reasignacionCuenta_tst2(){
        set<Id> memIds = new Set<Id>();
        list<account> lstAcc = [select id, name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, OwnerId, Owner.Name from account];
        for(account ac:lstAcc){
            memIds.add(ac.id);
        }
		list<User> lstUser = new list<user>();
        
        user regUser = [select id, name from user where IsActive=true and COS_Usuario_no_disponible__c= false order by name desc limit 1];
        
        Test.startTest();
        	boolean blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionCuenta_mtd(lstAcc, lstUser, memIds, regUser.id);
        Test.stopTest();
    }
    
    @isTest
    public static void reasignacionOportunidad_tst1(){
        set<Id> memIds = new Set<Id>();
        
        list<opportunity> lstOpp = [select id, name, AccountId, Account.Name, OwnerId, Owner.Name, CloseDate, StageName, COS_TipoPlan__c, COS_TipoAfiliado__c from opportunity];
        for(opportunity op:lstOpp){
            memIds.add(op.id);
        }
		list<User> lstUser = new list<user>();
        
        user regUser = [select id, name from user where IsActive=true and COS_Usuario_no_disponible__c= false order by name desc limit 1];
        
        Test.startTest();
        	boolean blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionOportunidad_mtd(lstOpp, lstUser, memIds, regUser.id);
        Test.stopTest();
    }
    
    @isTest
    public static void reasignacionOportunidad_tst2(){
        set<Id> memIds = new Set<Id>();
        list<opportunity> lstOpp = [select id, name, AccountId, Account.Name, OwnerId, Owner.Name, CloseDate, StageName, COS_TipoPlan__c, COS_TipoAfiliado__c from opportunity];
        for(opportunity op:lstOpp){
            memIds.add(op.id);
        }
		list<User> lstUsr = [select id, name, COS_No_Oportunidades_reasignadas__c from user where IsActive=true and COS_Usuario_no_disponible__c= false order by COS_No_Oportunidades_reasignadas__c asc];
        
        Test.startTest();
        	boolean blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionOportunidad_mtd(lstOpp, lstUsr, memIds, 'N/A');
        Test.stopTest();
    }
    
	@isTest
    public static void reasignacionProspecto_tst1(){
        set<Id> memIds = new Set<Id>();
        list<lead> lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead];
        
        for(lead ld:lstLead){
            memIds.add(ld.id);
        }
		list<User> lstUser = new list<user>();
        user regUser = [select id, name from user where IsActive=true and COS_Usuario_no_disponible__c= false order by name desc limit 1];
        
        Test.startTest();
        	boolean blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionProspecto_mtd(lstLead, lstUser, memIds, regUser.id);
        Test.stopTest();
    }
    
    @isTest
    public static void reasignacionProspecto_tst2(){
        set<Id> memIds = new Set<Id>();
        list<lead> lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead];
        for(lead ld:lstLead){
            memIds.add(ld.id);
        }
		list<User> lstUsr = [select id, name, COS_No_Prospectos_asignados__c from user where IsActive=true and COS_Usuario_no_disponible__c= false order by COS_No_Prospectos_asignados__c asc];
        
        Test.startTest();
        	boolean blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionProspecto_mtd(lstLead, lstUsr, memIds, 'N/A');
        Test.stopTest();
    }
}