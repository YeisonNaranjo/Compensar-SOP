@isTest //(SeeAllData=true)
private class COS_ConsultaGFyVinculacionesV2_ctr_tst {
    
    @testSetup
    public static void ConsultaGFyVinculacionesV2_stp(){
        string idProfileA = [select id, name from profile where name = 'Asesor Comercial Salud'].id;
        string idProfileC = [select id, name from profile where name = 'Coordinador Comercial Salud'].id;
        
        map<string,string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Lead']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        List<Lead> lstInsert = new  List<Lead>();
        Account objAcc = new account();
        objAcc.COM_TipoIdentificacion__c    = '2';
        objAcc.COM_Numero_de_identificacion__c = '90128690123';
        objAcc.Name = 'Empresa';
        ObjAcc.Phone = '2341421';
        ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
	    COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
        
        Account objAcc2 = new account();
        objAcc2.COM_TipoIdentificacion__c    = '2';
        objAcc2.COM_Numero_de_identificacion__c = '901286901234';
        objAcc2.Name = 'Empresa';
        ObjAcc2.Phone = '2341422';
        objAcc2.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
	    COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc2;
		
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
        	usr1.firstname = 'Alany';
        	usr1.lastName = 'McCarthyy';
       	 	usr1.email = 'test@test.org';
        	usr1.Username = 'test1@testsy.org.pr';
        	usr1.EmailEncodingKey = 'ISO-8859-1';
        	usr1.Alias = 'testy'; 
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
        
        lead leadIns = new lead();
            leadIns.CEL1_TipoDocumento__c = '1';
            leadIns.CEL1_NumeroDocumento__c = '100272874567';
            leadIns.FirstName = 'TestLlead';
            leadIns.LastName = 'apellidoTestLead';
            leadIns.Email = 'emailtes@gmail.com';
            leadIns.COS_Nit_empresa__c = '';
            leadIns.COS_Asignado_salud__c = false;
            leadIns.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');		
			leadIns.Status = 'Validado';
        insert leadIns;
        
        Lead objCandidato4                       =   new Lead();
        objCandidato4.FirstName                  =   'Prueba4';
        objCandidato4.MiddleName                 =   'Test';
        objCandidato4.LastName                   =   'Compensar4';
        objCandidato4.CEL1_TipoDocumento__c      =   '1';
        objCandidato4.CEL1_NumeroDocumento__c    =   '7123456332124';
        objCandidato4.COS_Nit_empresa__c	     =   '';
        objCandidato4.Email                      =   'prueba2@prueba.com';
        leadIns.COS_Asignado_salud__c = false;
        objCandidato4.RecordTypeId				= 	mapRecordType.get('COS_ProspectoSalud');	
        objCandidato4.Status 					= 	'Validado';
        insert objCandidato4;
        
        Lead objCandidato5                       =   new Lead();
        objCandidato5.FirstName                  =   'Prueba5';
        objCandidato5.MiddleName                 =   'Test';
        objCandidato5.LastName                   =   'Compensar5';
        objCandidato4.CEL1_TipoDocumento__c      =   null;
        objCandidato5.CEL1_NumeroDocumento__c    =   '7123456332143';
        objCandidato5.COS_Nit_empresa__c	     =   '';
        objCandidato5.Email                      =   'prueba2@prueb23a.com';
        objCandidato5.COS_Asignado_salud__c = false;
        objCandidato5.RecordTypeId				= 	mapRecordType.get('COS_ProspectoSalud');	
        objCandidato5.Status 					= 	'Validado';
        insert objCandidato5;
		
        lstInsert.add(leadIns);
        lstInsert.add(objCandidato4);
        lstInsert.add(objCandidato5);
    }
    
    
	@istest
    public static void unit_Test1(){
        lead objCandidato = [select FirstName, MiddleName, LastName, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, COS_Nit_empresa__c, Email, COS_Asignado_salud__c, RecordTypeId, Status from lead limit 1];
        account objAcc = [select id, name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, CEL1_LineaNegocio__c from account limit 1];
        
        Test.setMock(HttpCalloutMock.class, new RestMock());
               
        Test.startTest();
            COS_ConsultaGFyVinculacionesV2_ctr.obtenerGrupoFamiliar(objAcc.id);
            COS_ConsultaGFyVinculacionesV2_ctr.obtenerGrupoFamiliar(objCandidato.id);
            COS_ConsultaGFyVinculacionesV2_ctr.homologacionTipoDocumento(objCandidato.CEL1_TipoDocumento__c);
            COS_ConsultaGFyVinculacionesV2_ctr.homologacionParentesco('CY');
    
            
            Test.setMock(HttpCalloutMock.class, new RestMock2());
            COS_ConsultaGFyVinculacionesV2_ctr.obtenerGrupoFamiliar(objAcc.id);
            COS_ConsultaGFyVinculacionesV2_ctr.obtenerGrupoFamiliar(objCandidato.id);
            COS_ConsultaGFyVinculacionesV2_ctr.homologacionTipoDocumento(objCandidato.CEL1_TipoDocumento__c);
            COS_ConsultaGFyVinculacionesV2_ctr.homologacionParentesco('CY');
        Test.StopTest();
		

    }
    
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"ConsultarDatosVinculacionOut":{"Vinculacion":[{"ProgramaVinculacion":"CE 050121 Cónyuge","Estado":0,"FechaInicio":20200201,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"},{"ProgramaVinculacion":"EP 021311 Cónyuge","Estado":0,"FechaInicio":20190812,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"}],"GrupoFamiliar":[{"TipoIdentificacion":1,"NumeroIdentificacion":"1018466460","Nombre":"MIRELLA ZAIDA ARANDA BOZA","FechaNacimiento":19940419,"Genero":"F","Parentesco":"CY","Direccion":"CL 238 356 A 19","Correo":"Consprb0385619270@davivienda.c","Plan":"CE"},{"TipoIdentificacion":1,"NumeroIdentificacion":"1018466460","Nombre":"MIRELLA ZAIDA ARANDA BOZA","FechaNacimiento":19940419,"Genero":"F","Parentesco":"CY","Direccion":"CL 238 356 A 19","Correo":"Consprb0385619270@davivienda.c","Plan":"EP"}],"Empresa":[{"NIT":901275320,"RazonSocial":"COLOR ADS SAS","Contacto":"keren gissela gomez castro","Correo":"Consprb0385619270@davivienda.c","Telefono":0,"Direccion":"AC 385 261 C 92","CantidadTrabajadoresPBS":3,"CantidadTrabajadoresPCE":0,"CantidadTrabajadoresPCV":0,"CantidadTrabajadores":3}]}}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    
    private class RestMock2 implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJsonError = '{"ConsultarDatosVinculacionOut":{"Errores":[{"IdError":"D0001","Error":"No existe información"}]}}';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJsonError);
            res.setStatusCode(200);
            return res;
        }
    }
}