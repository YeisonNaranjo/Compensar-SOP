@isTest
public class COS_consolidaMetaSaludDiario_tst {

    @testSetup static void consolidaMetaSaludDiario_stp(){
        map<string,string> mapRecordType = new map<string, string>();
        //for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
        for(recordtype rt:[select id, DeveloperName from recordtype]){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        map<integer,string> monthMap = new map<integer,string>();
    	monthMap.put(1,'Enero');
    	monthMap.put(2,'Febrero');
    	monthMap.put(3,'Marzo');
    	monthMap.put(4,'Abril');
    	monthMap.put(5,'Mayo');
    	monthMap.put(6,'Junio');
    	monthMap.put(7,'Julio');
    	monthMap.put(8,'Agosto');
    	monthMap.put(9,'Septiembre');
    	monthMap.put(10,'Octubre');
    	monthMap.put(11,'Noviembre');
    	monthMap.put(12,'Diciembre');
        
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
            objOpp.StageName = 'Confirmada Salud';
            objOpp.COM_Fechahorainicio__c = System.today();
            objOpp.COM_Fechahorafinalizacion__c = System.today();
            objOpp.amount = 100; 
            objOpp.COM_Requieretransporte__c = true;
            objOpp.COM_Fecharadicacioncartaretiro__c = System.today();
            objOpp.COM_DSCalc__c = 1000000;
            objOpp.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        	objOpp.OwnerId = usr.Id;
        	objOpp.RecordTypeId = mapRecordType.get('COS_ConsorcioSalud');
        	objOpp.COS_Fecha_confirmada_salud__c = system.today();
		insert objOpp;
        
        Opportunity objOpp1 = new Opportunity();
            objOpp1.Name = 'Test';
            objOpp1.AccountId = objAcc.id;
        	objOpp1.COS_TipoPlan__c = 'CE';
            objOpp1.CloseDate = System.today();
            objOpp1.StageName = 'Finalizada';
            objOpp1.COM_Fechahorainicio__c = System.today();
            objOpp1.COM_Fechahorafinalizacion__c = System.today();
            objOpp1.amount = 100; 
            objOpp1.COM_Requieretransporte__c = true;
            objOpp1.COM_Fecharadicacioncartaretiro__c = System.today();
            objOpp1.COM_DSCalc__c = 1000000;
            objOpp1.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        	objOpp1.OwnerId = usr.Id;
        	objOpp1.RecordTypeId = mapRecordType.get('COS_ConsorcioSalud');
        	objOpp1.COS_Fecha_finalizada_salud__c = system.today();
		insert objOpp1;
        
        Opportunity objOpp2 = new Opportunity();
            objOpp2.Name = 'Test';
            objOpp2.AccountId = objAcc.id;
        	objOpp2.COS_TipoPlan__c = 'CE';
            objOpp2.CloseDate = System.today();
            objOpp2.StageName = 'Finalizada';
            objOpp2.COM_Fechahorainicio__c = System.today();
            objOpp2.COM_Fechahorafinalizacion__c = System.today();
            objOpp2.amount = 100; 
            objOpp2.COM_Requieretransporte__c = true;
            objOpp2.COM_Fecharadicacioncartaretiro__c = System.today();
            objOpp2.COM_DSCalc__c = 1000000;
            objOpp2.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        	objOpp2.OwnerId = usr.Id;
        	objOpp2.RecordTypeId = mapRecordType.get('COS_ConsorcioSalud');
        	objOpp2.COS_Fecha_finalizada_salud__c = system.today();
		insert objOpp2;
        
        COM_MetaAnual__c mAnual = new COM_MetaAnual__c();
			mAnual.COM_Asesor__c = usr.Id;
        	mAnual.COM_Anio__c = string.valueOf(system.today().year());
        	mAnual.RecordTypeId = mapRecordType.get('COS_MetaAnualSalud');
        	mAnual.COS_TotalPlanilladas__c = 100;
        	mAnual.COS_TotalReal__c = 100;
		insert mAnual;        
        
		COM_MetasMensual__c mMensual = new COM_MetasMensual__c();
        	mMensual.COS_Asesor__c = usr.Id;
        	mMensual.COM_Mes__c = monthMap.get(system.today().month());
        	mMensual.COM_MetaAnual__c = mAnual.Id;
        	mMensual.COS_MetaMes__c = 10;
        	mMensual.COM_CantidadMeta__c = 12;
        	mMensual.COS_MetaForecast__c = 12;
        	mMensual.Name = 'MetaMes - '+monthMap.get(system.today().month());
        	mMensual.RecordTypeId = mapRecordType.get('COS_MetaMensualSalud');
        	mMensual.COS_TipoPlan__c = 'CE';
        	mMensual.COS_CantidadPlanillados__c = 2;
        	mMensual.COS_CantidadGrabados__c = 2;
        	mMensual.COS_CantidadGrabadosMesAnterior__c = 2;
        	mMensual.COS_MetaForecast__c = 0;
        	mMensual.COS_Inactiva__c = false;
        insert mMensual;
        
/*		COM_MetasIndividuales__c mIndiv = new COM_MetasIndividuales__c();
			mIndiv.COM_Asesor__c = usr.Id;
        	mIndiv.COS_CantidadPlanillados__c = 12;
        	mIndiv.COS_CantidadGrabados__c = 12;
        	mIndiv.COS_CantidadGrabadosMesAnterior__c = 2;
        	mIndiv.COS_Forecast__c = 0;
        	mIndiv.COS_Inactiva__c = false;
        	mIndiv.COM_MetaMensuale__c = mMensual.Id;
        	mIndiv.RecordTypeId = mapRecordType.get('COS_MetasIndividualesSalud');
        	mIndiv.COS_TipoPlan__c = 'CE';
        insert mIndiv;*/
    }
    
    @isTest
    public static void consolidaMetaSaludDiario_tst1(){
        string cronExpr = '0 0 0 15 3 ? 2022';
        Test.startTest();
        	COS_consolidaMetaSaludDiario_shc abs = new COS_consolidaMetaSaludDiario_shc();
        	String jobId = System.schedule('myJobTestJobName', cronExpr, abs);
        	abs.execute(null);
        
	        COS_consolidaMetaSaludDiario_bch b = new COS_consolidaMetaSaludDiario_bch();
	        Database.executeBatch (b,5);
        Test.stopTest(); 
    }
    
}