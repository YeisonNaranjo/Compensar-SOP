@istest //(SeeAllData=true)
public class COS_AsignacionProspectos_tst {
     //(SeeAllData=true)
//    public List<Lead> lstInsert = new  List<Lead>();
    
    
    @testSetup
    public static void reasignacionGrupo_stp(){    
	    string idRecordType = [select id, name from RecordType where DeveloperName ='COS_ProspectoSalud' limit 1].id;
//        string idRecordTypeAcc = [select id, name from RecordType where DeveloperName ='Juridico' limit 1].id;
	    
	    List<Lead> lstInsert = new  List<Lead>();
	    List<Account> lstInsertAcc = new  List<Account>();
        Account objAcc = new account();
        objAcc.COM_TipoIdentificacion__c    = '2';
        objAcc.COM_Numero_de_identificacion__c = '9834837';
        objAcc.Name = 'Empresa';
        ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        ObjAcc.Phone = '2341421';
	    COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
		
        user regUser = [select id, name from user where isActive=TRUE AND Profile.Name = 'Asesor Comercial Salud' limit 1];
        
        //string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        string idProfileA = [select id, name from profile where name = 'Asesor Comercial Salud'].id;
        string idProfileC = [select id, name from profile where name = 'Coordinador Comercial Salud'].id;
        User usr = new User();
        	usr.firstname = 'Alan';
        	usr.lastName = 'McCarthy';
       	 	usr.email = 'test@test.org';
        	usr.Username = 'test11@tests.org.pr';
        	usr.EmailEncodingKey = 'ISO-8859-1';
        	usr.Alias = 'test'; 
        	usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr.LocaleSidKey = 'en_US'; 
        	usr.LanguageLocaleKey = 'en_US'; 
        	usr.ProfileId = idProfileC; 
        	usr.COS_No_Cuentas_reasignadas__c = 1;
        	usr.COS_No_Oportunidades_reasignadas__c = 1;
        insert usr;
        
        User usr1 = new User();
        	usr1.firstname = 'Alan';
        	usr1.lastName = 'McCarthy';
       	 	usr1.email = 'test@test.org';
        	usr1.Username = 'test1@tests.org.pr';
        	usr1.EmailEncodingKey = 'ISO-8859-1';
        	usr1.Alias = 'test'; 
        	usr1.TimeZoneSidKey = 'America/Los_Angeles'; 
        	usr1.LocaleSidKey = 'en_US'; 
        	usr1.LanguageLocaleKey = 'en_US'; 
        	usr1.ProfileId = idProfileA; 
        	usr1.COS_No_Cuentas_reasignadas__c = 1;
        	usr1.COS_No_Oportunidades_reasignadas__c = 1;
        	usr1.ManagerId = usr.Id;
        insert usr1;
        
        AccountTeamMember ATM = new AccountTeamMember();
        ATM.UserId = usr1.Id;
        ATM.AccountId = objAcc.Id;
        ATM.TeamMemberRole = 'COS_AsesorConsorcioSalud';
        insert ATM;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba1';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar1';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '71234567891';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.RecordTypeId				= 	idRecordType;
        objCandidato.Status 					= 	'Validado';
        lstInsert.add(objCandidato);

        Lead objCandidato2                       =   new Lead();
        objCandidato2.FirstName                  =   'Prueba2GM';
        objCandidato2.MiddleName                 =   'Test';
        objCandidato2.LastName                   =   'Compensar2';
        objCandidato2.CEL1_TipoDocumento__c      =   '1';
        objCandidato2.CEL1_NumeroDocumento__c    =   '71234567892';
        objCandidato2.COS_Nit_empresa__c	     =   '9834837';
        objCandidato2.Email                      =   'prueba@prueba.com';
        objCandidato2.RecordTypeId				= 	idRecordType;
        objCandidato2.Status 					= 	'Validado';
        lstInsert.add(objCandidato2);

        Lead objCandidato3                       =   new Lead();
        objCandidato3.FirstName                  =   'Prueba3';
        objCandidato3.MiddleName                 =   'Test';
        objCandidato3.LastName                   =   'Compensar3';
        objCandidato3.CEL1_TipoDocumento__c      =   '1';
        objCandidato3.CEL1_NumeroDocumento__c    =   '71234567893';
        objCandidato3.Email                      =   'prueba@prueba.com';
        objCandidato3.RecordTypeId				= 	idRecordType;
        objCandidato3.Status 					= 	'Validado';
                
        lstInsert.add(objCandidato3);
        
        Lead objCandidato4                       =   new Lead();
        objCandidato4.FirstName                  =   'Prueba4';
        objCandidato4.MiddleName                 =   'Test';
        objCandidato4.LastName                   =   'Compensar4';
        objCandidato4.CEL1_TipoDocumento__c      =   '1';
        objCandidato4.CEL1_NumeroDocumento__c    =   '71234567894';
        objCandidato4.COS_Nit_empresa__c	     =   '433223';
        objCandidato4.Email                      =   'prueba@prueba.com';
        objCandidato4.LeadSource				 =   'Cotizador';
        objCandidato4.RecordTypeId				= 	idRecordType;
        objCandidato4.Status 					= 	'Validado';
        lstInsert.add(objCandidato4);
        
        Lead objCandidato5                       =   new Lead();
        objCandidato5.FirstName                  =   'Prueba5';
        objCandidato5.MiddleName                 =   'Test';
        objCandidato5.LastName                   =   'Compensar5';
        objCandidato5.CEL1_TipoDocumento__c      =   '1';
        objCandidato5.CEL1_NumeroDocumento__c    =   '71234567895';
        objCandidato5.Email                      =   'prueba@prueba.com';
        objCandidato5.RecordTypeId				= 	idRecordType;
        objCandidato5.Status 					= 	'Validado';
        lstInsert.add(objCandidato5);
        
        for (Integer i=0; i< 11; i++){
            
            Lead objCandidatofor                       =   new Lead();
        	objCandidatofor.FirstName                  =   'Name_' + i;
        	objCandidatofor.MiddleName                 =   'M_Name' + i;
        	objCandidatofor.LastName                   =   'last_Name' + i;
        	objCandidatofor.CEL1_TipoDocumento__c      =   '1';
        	objCandidatofor.CEL1_NumeroDocumento__c    =   '3211441242424' + i;
        	objCandidatofor.Email                      =   'prueba@prueba.com';
            objCandidatofor.RecordTypeId			   = idRecordType;
            objCandidatofor.Status 					   = 'Validado';
        	lstInsert.add(objCandidatofor);
        }
        
        insert lstInsert;
    }
    
    @istest
    public static void unit_Test1(){
        Test.startTest();
        	list<lead> lstLead = [select id, FirstName, MiddleName, LastName, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Email, RecordTypeId, Status, COS_Nit_empresa__c, LeadSource, OwnerId from lead];
        	COS_AsignacionProspectos_cls.asignacionProspectos(lstLead);
        	COS_AsignacionProspectos_cls.asignacionProspectosDistCarga(lstLead);
        Test.stopTest();
    }

}