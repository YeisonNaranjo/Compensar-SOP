@isTest
public class COS_actualizaCantidadProspectoAsign_tst {
	@testSetup
    public static void actualizaCantidadProspectoAsign_stp(){
        string idRecordType = [select id, name from RecordType where DeveloperName ='COS_ProspectoSalud' limit 1].id;
//        string idRecordTypeAcc = [select id, name from RecordType where DeveloperName ='Juridico' limit 1].id;
	    
	    list<Lead> lstLead = new list<Lead>();
	    list<Account> lstInsertAcc = new list<Account>();
        list<user> lstUsr = new list<user>();
        
        map<string, string> mapProfiles = new map<string, string>();
        for(profile pf:[select id, name from profile]){
            mapProfiles.put(pf.name, pf.Id);
        }
        
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
        	usr.COS_No_Cuentas_reasignadas__c = 12;
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
        	usr2.COS_No_Cuentas_reasignadas__c = 12;
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
        	usr3.COS_No_Cuentas_reasignadas__c = 13;
        	usr2.ManagerId = usr.Id;
        lstUsr.add(usr3);
        insert lstUsr;
        
        Account objAcc = new account();
        objAcc.COM_TipoIdentificacion__c    = '2';
        objAcc.COM_Numero_de_identificacion__c = '9834837';
        objAcc.Name = 'Empresa';
        ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
	    COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
		
        user regUser = [select id, name from user where Profile.Name = 'Asesor Comercial Salud' limit 1];
        
        AccountTeamMember ATM = new AccountTeamMember();
        ATM.UserId = regUser.Id;
        ATM.AccountId = objAcc.Id;  
        insert ATM;
        
        Lead objLead = new Lead();
        objLead.FirstName = 'Prueba1';
        objLead.MiddleName = 'Test';
        objLead.LastName = 'Compensar1';
        objLead.Company = 'Prueba1 compensar';
        objLead.CEL1_TipoDocumento__c = '1';
        objLead.CEL1_NumeroDocumento__c = '71234567891';
        objLead.Email = 'prueba@prueba.com';
        objLead.RecordTypeId = idRecordType;
        objLead.Status = 'Validado';
        //objLead.ConvertedDate = system.today();
        //objLead.IsConverted = true;
        objLead.OwnerId = usr2.Id;
        lstLead.add(objLead);
        
        
        Lead objLead2 = new Lead();
        objLead2.FirstName = 'Prueba2';
        objLead2.MiddleName = 'Test2';
        objLead2.LastName = 'Compensar1';
        objLead.Company = 'Prueba2 compensar1';
        objLead2.CEL1_TipoDocumento__c = '1';
        objLead2.CEL1_NumeroDocumento__c = '71122337891';
        objLead2.Email = 'prueba@prueba.com';
        objLead2.RecordTypeId = idRecordType;
        objLead2.Status = 'Validado';
        //objLead2.ConvertedDate = system.today();
        //objLead2.IsConverted = true;
        objLead2.OwnerId = usr2.Id;
        lstLead.add(objLead2);
        insert lstLead;
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        list<Database.LeadConvert> leadsToConvert = new list<Database.LeadConvert>();
        
        Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(objLead.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedstatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc, false);
        system.debug('LeadConvertResult --->'+lcr);
        
        lc = new database.LeadConvert();
		lc.setLeadId(objLead2.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedstatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr2 = Database.convertLead(lc, false);
        system.debug('LeadConvertResult --->'+lcr2);
        
        list<lead> lstLeadConvert = [select id, name, OwnerId, ConvertedDate, IsConverted from lead where RecordTypeId=:idRecordType];
        system.debug('lstLeadConvert --->'+lstLeadConvert);
    }
    
    @isTest
    public static void actualizaCantidadProspectoAsign_tst1(){
        String cronExpr = '0 0 0 15 3 ? 2022';
        test.startTest();
        	COS_actualizaCantidadProspectoAsign_sch abs = new COS_actualizaCantidadProspectoAsign_sch();
        	String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
        	abs.execute(null);
        
	        COS_actualizaCantidadProspectoAsign_bch b = new COS_actualizaCantidadProspectoAsign_bch();
	        Database.executeBatch (b,5);
        test.stopTest(); 
    }
    
    @isTest
    public static void actualizaCantidadProspectoAsign_tst2(){
        map<string,Lead> mapLead = new map<string,Lead>();
        
        for(lead ld:[select id, name, CEL1_TipoDocumento__c,CEL1_NumeroDocumento__c,RecordTypeid,OwnerId from lead limit 1]){
            mapLead.put(ld.Id,ld);
        }
        
        test.startTest();
        	map<id,lead> mapResult = CEL1_ClienteCuentaAcreedora_cls.asignarPropietarioCandidato(null,mapLead,true,true);	
        test.stopTest(); 
    }
    
    @isTest
    public static void actualizaCantidadProspectoAsign_tst3(){
        map<string,string> mapLead = new map<string,string>();
        
        for(lead ld:[select id, name, CEL1_TipoDocumento__c,CEL1_NumeroDocumento__c,RecordTypeid,OwnerId from lead limit 1]){
            mapLead.put(ld.Id,ld.Name);
        }
        
        test.startTest();
        	map<id,lead> mapResult2 = CEL1_ClienteCuentaAcreedora_cls.asignarPropietarioCandidato(mapLead,null,true,false);	
        test.stopTest(); 
    }
}