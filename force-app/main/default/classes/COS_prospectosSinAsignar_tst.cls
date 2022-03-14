@istest
public class COS_prospectosSinAsignar_tst {
   
    @testSetup
    public static void prospectosSinAsignar_stp(){
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
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        
        
  	    COS_prospectosSinAsignar_bch b = new COS_prospectosSinAsignar_bch();
        Database.executeBatch(b);   
        //Test.setMock(HttpCalloutMock.class, new RestMock2());
        //COS_prospectosSinAsignar_bch b2 = new COS_prospectosSinAsignar_bch();
        //Database.executeBatch(b2);        
        Test.stopTest();
    }
    
    
    
        private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            //String fullJson = '{"ConsultarDatosVinculacionOut":{"Vinculacion":[{"ProgramaVinculacion":"CE 050121 Cónyuge","Estado":0,"FechaInicio":20200201,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"},{"ProgramaVinculacion":"EP 021311 Cónyuge","Estado":0,"FechaInicio":20190812,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"}],"GrupoFamiliar":[{"TipoIdentificacion":1,"NumeroIdentificacion":"1018466460","Nombre":"MIRELLA ZAIDA ARANDA BOZA","FechaNacimiento":19940419,"Genero":"F","Parentesco":"CY","Direccion":"CL 238 356 A 19","Correo":"Consprb0385619270@davivienda.c","Plan":"CE"},{"TipoIdentificacion":1,"NumeroIdentificacion":"1018466460","Nombre":"MIRELLA ZAIDA ARANDA BOZA","FechaNacimiento":19940419,"Genero":"F","Parentesco":"CY","Direccion":"CL 238 356 A 19","Correo":"Consprb0385619270@davivienda.c","Plan":"EP"}],"Empresa":[{"NIT":901275320,"RazonSocial":"COLOR ADS SAS","Contacto":"keren gissela gomez castro","Correo":"Consprb0385619270@davivienda.c","Telefono":0,"Direccion":"AC 385 261 C 92","CantidadTrabajadoresPBS":3,"CantidadTrabajadoresPCE":0,"CantidadTrabajadoresPCV":0,"CantidadTrabajadores":3}]}}';
           	String fullJson = '{"ConsultarDatosVinculacionOut":{"Vinculacion":[{"ProgramaVinculacion":"EP 021201 Dependiente","Estado":1,"FechaInicio":20191226,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"}],"GrupoFamiliar":[{"TipoIdentificacion":7,"NumeroIdentificacion":"1025071705","Nombre":"GALILEO NARCISO LASTRA QUINDOS","FechaNacimiento":20130707,"Genero":"M","Parentesco":"HI","Direccion":"CL 392 G 370 A 38","Correo":"Consprb2703856192@outlook.com","Plan":"EP"}],"Empresa":[{"NIT":90128690123,"RazonSocial":"SOLUCION INTEGRAL EN CONSTRUCION SAS","Contacto":"","Correo":"Consprb0385619270@outlook.com ,Consprb2703856192@gmail.com","Telefono":0,"Direccion":"KR 185 361 92","CantidadTrabajadoresPBS":870,"CantidadTrabajadoresPCE":3,"CantidadTrabajadoresPCV":0,"CantidadTrabajadores":873}]}}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
        private class RestMock2 implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
           	String fullJson = '{"ConsultarDatosVinculacionOut":{"Vinculacion":[{"ProgramaVinculacion":"EP 021203 Independiente","Estado":0,"FechaInicio":20161005,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"},{"ProgramaVinculacion":"CE 05011 Trabajadores","Estado":5,"FechaInicio":20200101,"Estrato":1,"AUTENVEMAIL":"SI","AUTENVSMS":"SI"}],"GrupoFamiliar":[{"TipoIdentificacion":1,"NumeroIdentificacion":"79322730","Nombre":"GALILEO AMARU POBLETE PIMENTEL","FechaNacimiento":19640902,"Genero":"M","Parentesco":"CP","Direccion":"KR 27 D 03 F 85 IN 61 AP 92","Correo":"Consprb6192703856@achcolombia.","Plan":"EP"},{"TipoIdentificacion":1,"NumeroIdentificacion":"79322730","Nombre":"GALILEO AMARU POBLETE PIMENTEL","FechaNacimiento":19640902,"Genero":"M","Parentesco":"CY","Direccion":"KR 27 D 03 F 85 IN 61 AP 92","Correo":"Consprb6192703856@achcolombia.","Plan":"CE"}],"Empresa":[]}}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    

    
}