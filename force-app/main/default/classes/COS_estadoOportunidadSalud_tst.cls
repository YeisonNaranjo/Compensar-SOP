@isTest
global class COS_estadoOportunidadSalud_tst {
    @testSetup static void estadoOportunidadSalud_stp(){
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
        	objAcc.COM_TipoIdentificacion__c    = '1';
        	objAcc.COM_Numero_de_identificacion__c = '98348377';
        	objAcc.Name = 'Empresa';
        	ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        	ObjAcc.OwnerId = usr.Id;
	    	COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
        
        Opportunity objOpp = new Opportunity();
            objOpp.Name = 'Test';
            objOpp.AccountId = objAcc.id;
        	objOpp.COS_TipoPlan__c = 'CE';
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
        
        COS_EstadosOportunidadesTemp__c opTem = new COS_EstadosOportunidadesTemp__c();
        	opTem.COM_TipoIdentificacion__c = '1';
        	opTem.COS_NumeroDocumento__c = '98348377';
        	opTem.COS_TipoPlan__c = 'CE';
        	opTem.COS_ProgramaActual__c = '0';
        	opTem.COS_NitEmpresa__c = '900443299';
        	opTem.COS_CodigoEstadoAfiliacion__c = '0';	
        	opTem.COS_CausalNovedad__c = 'Causal novedad';
        	opTem.COS_FechaVinculacion__c = system.today();
            
		insert opTem;
    }
    
    @isTest
    public static void estadoOportunidadSalud_tst(){
        string cronExpr = '0 0 0 15 3 ? 2022';
        Test.startTest();
        	COS_estadoOportunidadSalud_shc abs = new COS_estadoOportunidadSalud_shc();
        	String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
        	abs.execute(null);
        
	        COS_estadoOportunidadSalud_bch b = new COS_estadoOportunidadSalud_bch();
	        Database.executeBatch (b,5);
        Test.stopTest();
    }
}