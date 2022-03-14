@isTest
public class COS_reasignacionSalud_tst {
	@testSetup
    public static void reasignacionSalud_stp(){
        list<account> lstAcc = new list<account>();
        list<opportunity> lstOpp = new list<opportunity>();
        list<user> lstUsr = new list<user>();
        list<AccountTeamMember> lstATM = new list<AccountTeamMember>();
		
        map<string, string> mapRecordTypeOpp = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
            mapRecordTypeOpp.put(rt.DeveloperName, rt.id);
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
        	usr2.ManagerId = usr.Id;
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
        	objOpp.RecordTypeId = mapRecordTypeOpp.get('COS_ConsorcioSalud');
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
        	objOpp2.RecordTypeId = mapRecordTypeOpp.get('COS_ConsorcioSalud');
        lstOpp.add(objOpp2);
        

        insert lstOpp;
        
    }
    
    @isTest
    public static void reasignacionSalud_tst1(){
        list<account> lstAcc = [select id, OwnerId from account];
        system.debug('lstAcc size --->'+lstAcc.size());
        test.startTest();
//        	test.setCurrentPage(page.COS_reasignacionCuenta_vfp);
			pageReference pagRef = page.COS_reasignacionCuenta_vfp;
        	test.setCurrentPage(pagRef);
      //  	ApexPages.StandardController sc = new ApexPages.StandardController(lstAcc[0]);
        	ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstAcc);
        	COS_reasignacionSalud_ctr objController = new COS_reasignacionSalud_ctr(controller);
        	controller.setSelected(lstAcc);	
        	objController.getselectedaccnamefields();
        	objController.cancelar();
        	objController.selectedAsesor = '- None -'; 
        	objController.asesorDistribucion = false;
        	objController.reasignar();
        	controller.getSelected();
        test.stopTest();
    }
    
    @isTest
    public static void reasignacionSalud_tst2(){
        list<account> lstAcc = [select name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, OwnerId, Owner.Name from account];
        set<Id> Ids = new Set<Id>();
        for(account ac:lstAcc){
            Ids.add(ac.id);
        }
        // list<user> lstUser = [select id, name, COS_No_Cuentas_reasignadas__c from user where COS_Usuario_no_disponible__c= false order by COS_No_Cuentas_reasignadas__c asc];
        list<user> lstUser = new list<user>(); 
        system.debug('lstAcc size --->'+lstAcc.size());
        test.startTest();
			pageReference pagRef = page.COS_reasignacionCuenta_vfp;
        	test.setCurrentPage(pagRef);
        	ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstAcc);
        	COS_reasignacionSalud_ctr objController = new COS_reasignacionSalud_ctr(controller);
        	controller.setSelected(lstAcc);	
        	objController.memIds = Ids;
        	objController.lstAcc = lstAcc;
        	objController.lstUser = lstUser;
        	objController.selectedAsesor = '- None -'; 
        	objController.asesorDistribucion = true;
        	objController.reasignar();
        	controller.getSelected();
        test.stopTest();
    }
    
    @isTest
    public static void reasignacionSalud_tst3(){
        list<account> lstAcc = [select name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, OwnerId, Owner.Name from account];
        set<Id> Ids = new Set<Id>();
        for(account ac:lstAcc){
            Ids.add(ac.id);
        }
        list<user> lstUser = [select id, name, COS_No_Cuentas_reasignadas__c from user where COS_No_Cuentas_reasignadas__c > 0 and COS_Usuario_no_disponible__c= false order by COS_No_Cuentas_reasignadas__c asc];
        list<user> lstUserNull = new list<user>();
        system.debug('lstAcc size --->'+lstAcc.size());
        test.startTest();
			pageReference pagRef = page.COS_reasignacionCuenta_vfp;
        	test.setCurrentPage(pagRef);
        	ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstAcc);
        	COS_reasignacionSalud_ctr objController = new COS_reasignacionSalud_ctr(controller);
        	controller.setSelected(lstAcc);	
        	objController.memIds = Ids;
        	objController.lstAcc = lstAcc;
        	objController.lstUser = lstUserNull;
        	objController.selectedAsesor = lstUser[0].id; 
        	objController.asesorDistribucion = false;
        	objController.reasignar();
        	controller.getSelected();
        test.stopTest();
    }
}