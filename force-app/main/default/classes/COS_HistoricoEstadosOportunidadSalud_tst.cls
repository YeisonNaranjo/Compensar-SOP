@isTest
public class COS_HistoricoEstadosOportunidadSalud_tst {
	@testSetup static void HistoricoEstadosOportunidadSalud_stp(){
        map<string,string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        list<account> lstAcc = new list<account>();
        list<opportunity> lstOpp = new list<opportunity>();
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        
        User usr = new User();
        	usr.firstname = 'Alan';
        	usr.lastName = 'McCarthy';
       	 	usr.email = 'test@test.org';
        	usr.Username = 'test@test.org.pr';
        	usr.EmailEncodingKey = 'ISO-8859-1';
        	usr.Alias = 'test'; 
        	usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr.LocaleSidKey = 'en_US'; 
        	usr.LanguageLocaleKey = 'en_US'; 
        	usr.ProfileId = ProfileId; 
        	usr.COS_No_Cuentas_reasignadas__c = 2;
        	usr.COS_No_Oportunidades_reasignadas__c = 1;
        insert usr;
        
        Account objAcc = new account();
        	objAcc.COM_TipoIdentificacion__c    = '2';
        	objAcc.COM_Numero_de_identificacion__c = '98348377';
        	objAcc.Name = 'Empresa';
        	ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        	ObjAcc.OwnerId = usr.Id;
	    	COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
        
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
            objOpp.COM_DSCalc__c = 1000000;
            objOpp.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        	objOpp.OwnerId = usr.Id;
        	objOpp.RecordTypeId = mapRecordType.get('COS_ConsorcioSalud');
		insert objOpp;
        
        Opportunity_stage_history__c nHis = new Opportunity_stage_history__c();
        nHis.Start_stage__c = 'Validado';
        nHis.Start_date__c = system.now().addDays(-12);
        nHis.Opportunity__c = objOpp.Id;
        nHis.End_date__c = null;
        insert nHis;
    }
    
    @isTest
    public static void HistoricoEstadosOportunidadSalud_tst1(){
        String cronExpr = '0 0 0 15 3 ? 2022';
        Test.startTest();
        	Opportunity_stage_history__c regH = [select id, name, Start_stage__c, Start_date__c, Opportunity__c, End_date__c 
                                                          from Opportunity_stage_history__c 
                                                          where End_date__c	=null
                                                          limit 1];
        	
        	regH.End_date__c = system.now();
        	update regH;
        Test.stopTest(); 
    }
    
    @isTest
    public static void HistoricoEstadosOportunidadSalud_tst2(){
        string cronExpr = '0 0 0 15 3 ? 2022';
        Test.startTest();
        	COS_duracionOportunidadXEstado_sch abs = new COS_duracionOportunidadXEstado_sch();
        	String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
        	abs.execute(null);
        
	        COS_duracionOportunidadXEstado_bch b = new COS_duracionOportunidadXEstado_bch();
	        Database.executeBatch (b,5);
        Test.stopTest(); 
    }
}