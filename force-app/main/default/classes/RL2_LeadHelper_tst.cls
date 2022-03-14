/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase RL2_LeadHelper_clsy y RL2_OpportunityHelper_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     18/06/21        Jorge Pozo (JPA)      	Creación Clase.
************************************************************************************************/
@isTest
public class RL2_LeadHelper_tst {
    private static String idRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
    
    @isTest
    public static void validarCandidatoDuplicado_tst() {
        List<Lead> listLead1 = new List <Lead>();
        Lead objCandidato1                      =   new Lead();
        objCandidato1.FirstName                 =   'Prueba';
        objCandidato1.MiddleName                =   'Test';
        objCandidato1.LastName                  =   'Compensar';
        objCandidato1.CEL1_TipoDocumento__c     =   '1';
        objCandidato1.CEL1_NumeroDocumento__c   =   '8800990077';
        objCandidato1.Email                     =   'prueba@prueba.com';
        objCandidato1.Status					=	'Nuevo';
        objCandidato1.RL2_TipoDeSolicitud__c	= 	'Traslado';
		objCandidato1.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead1.add(objCandidato1);
        insert listLead1;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '8800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        Try {
            insert listLead;
        } Catch (Exception e) {
            System.assert(e.getMessage().contains(label.RL2_CandidatoExistente));			
        }
        Test.stopTest();
    }
    
    // Lead con Cuenta y Asesor asignado
    @isTest
    public static void asignarPropietarioDeCuenta1_tst() {
        Map<string, string> mapProfiles = new Map<string, string>();
        
        for(Profile pf: [SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
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
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        insert usr;
        
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '18800990077';
        insert objCuenta;
        
        AccountTeamMember accTeamMember = new AccountTeamMember();
        accTeamMember.AccountId = objCuenta.Id;
        accTeamMember.TeamMemberRole = Label.COM_PAF_TypeTeamAsesor;
        accTeamMember.UserId = usr.Id;
        insert accTeamMember;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
        
        Lead lead = [SELECT OwnerId FROM Lead WHERE Id =: objCandidato.Id];
        System.assertEquals(usr.Id, lead.OwnerId, 'Diferentes propietarios');
    }
    
    // Lead con Cuenta pero sin Asesor asignado y con Lead
    @isTest
    public static void asignarPropietarioDeCuenta2_tst() {        
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '18800990077';
        insert objCuenta;
        
        List<Lead> listLead1 = new List <Lead>();
        Lead objCandidato1                      =   new Lead();
        objCandidato1.FirstName                 =   'Prueba';
        objCandidato1.MiddleName                =   'Test';
        objCandidato1.LastName                  =   'Compensar';
        objCandidato1.CEL1_TipoDocumento__c     =   '1';
        objCandidato1.CEL1_NumeroDocumento__c   =   '18800990077';
        objCandidato1.Email                     =   'prueba@prueba.com';
        objCandidato1.Status					=	'Nuevo';
        objCandidato1.RL2_TipoDeSolicitud__c	= 	'Traslado';
		objCandidato1.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead1.add(objCandidato1);
        insert listLead1;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Pensionado 2%';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
        
        Lead lead = [SELECT OwnerId FROM Lead WHERE Id =: objCandidato.Id];
        Lead lead1 = [SELECT OwnerId FROM Lead WHERE Id =: objCandidato1.Id];
        AccountTeamMember accTeam = [SELECT UserId FROM AccountTeamMember WHERE AccountId =: objCuenta.Id];   
        System.assertEquals(lead1.OwnerId, lead.OwnerId, 'Diferentes propietarios');
        System.assertEquals(lead1.OwnerId, accTeam.UserId, 'Sin asesor');
    }
    
    // Lead con Cuenta pero sin Asesor asignado, sin Lead y canal Call Center
    @isTest
    public static void asignarPropietarioDeCuenta3_tst() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Sede';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Sede';
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Sede';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr3);
        insert lstUsr;
        
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '18800990077';
        insert objCuenta;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Call Center';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Lead con Cuenta pero sin Asesor asignado, sin Lead y canal Chat
    @isTest
    public static void asignarPropietarioDeCuenta4_tst() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Sede';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = False;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Sede';
        usr2.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Sede';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr3);
        insert lstUsr;
        
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Numero_de_identificacion__c = '18800990077';
        insert objCuenta;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Chat';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Lead sin Cuenta, sin Lead y canal Call Center
    @isTest
    public static void asignarPropietarioDeCuenta5_tst() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Sede';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Sede';
        usr2.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Sede';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = False;
        lstUsr.add(usr3);
        insert lstUsr;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Call Center';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Lead sin Cuenta, sin Lead y canal Chat
    @isTest
    public static void asignarPropietarioDeCuenta6_tst() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Sede';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Sede';
        usr2.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Sede';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = False;
        lstUsr.add(usr3);
        insert lstUsr;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Atención Presencial';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Lead con Cuenta pero sin Asesor asignado, sin Lead y canal Call Center y Empresa
    @isTest
    public static void asignarPropietarioDeCuenta7_tst() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Empresarial';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Empresarial';
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Empresarial';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr3);
        insert lstUsr;
        
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '2';
        objCuenta.COM_Numero_de_identificacion__c = '18800990077';
        insert objCuenta;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '2';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Call Center';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        objCandidato.Company					=	'Text255';
        objCandidato.NumberOfEmployees			=	10;
        objCandidato.RL2_NoTrabajadoresQueRecibenSubsidio__c = 12;
        objCandidato.RL2_ValorDeNomina__c		=	15;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    // Lead sin Cuenta, sin Lead y canal Call Center y Empresa
    @isTest
    public static void asignarPropietarioDeCuenta8_tst() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Empresarial';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Empresarial';
        usr2.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Empresarial';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = False;
        lstUsr.add(usr3);
        insert lstUsr;
        
        List<Lead> listLead = new List <Lead>();
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '2';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Call Center';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        objCandidato.Company					=	'Text255';
        objCandidato.NumberOfEmployees			=	10;
        objCandidato.RL2_NoTrabajadoresQueRecibenSubsidio__c = 12;
        objCandidato.RL2_ValorDeNomina__c		=	15;
        listLead.add(objCandidato);
        
        Test.startTest();
        try {
            insert listLead;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    public static void actualizarCuentaConvertida() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Sede';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Sede';
        usr2.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Sede';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = False;
        lstUsr.add(usr3);
        insert lstUsr;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Call Center';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        
        try {
            insert objCandidato;
            objCandidato.Status = 'EnGestion';
            update objCandidato;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setConvertedStatus('Convertido');
        
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.stopTest();
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        System.assertEquals(true, lcr.isSuccess());
    }
    
    @isTest
    public static void actualizarCuentaConvertida2() {
        List<user> lstUsr = new List<user>();
        
        Map<string, string> mapProfiles = new Map<string, string>();
        for(Profile pf:[SELECT Id, Name FROM Profile]){
            mapProfiles.put(pf.Name, pf.Id);
        }
        
        User usr = new User();
        usr.firstname = 'Alan';
        usr.lastName = 'McCarthy';
        usr.email = 'test1@test.org';
        usr.Username = 'test1@test.org.pr';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.Alias = 'test1'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.LocaleSidKey = 'en_US'; 
        usr.LanguageLocaleKey = 'en_US'; 
        usr.ProfileId = mapProfiles.get('Asesor - PAF');
        usr.RL2_Empresa__c = 'Asesor Sede';
        usr.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr);
        
        User usr2 = new User();
        usr2.firstname = 'Alan';
        usr2.lastName = 'McCarthy';
        usr2.email = 'test2@test.org';
        usr2.Username = 'test2@test.org.pr';
        usr2.EmailEncodingKey = 'ISO-8859-1';
        usr2.Alias = 'test2'; 
        usr2.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr2.LocaleSidKey = 'en_US'; 
        usr2.LanguageLocaleKey = 'en_US'; 
        usr2.ProfileId = mapProfiles.get('Asesor - PAF');
        usr2.RL2_Empresa__c = 'Asesor Sede';
        usr2.RL2_AsignadoProspectoAfiliacionCaja__c = True;
        lstUsr.add(usr2);
        
        User usr3 = new User();
        usr3.firstname = 'Alan';
        usr3.lastName = 'McCarthy';
        usr3.email = 'test3@test.org';
        usr3.Username = 'test3@test.org.pr';
        usr3.EmailEncodingKey = 'ISO-8859-1';
        usr3.Alias = 'test3'; 
        usr3.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr3.LocaleSidKey = 'en_US'; 
        usr3.LanguageLocaleKey = 'en_US'; 
        usr3.ProfileId = mapProfiles.get('Asesor - PAF');
        usr3.RL2_Empresa__c = 'Asesor Sede';
        usr3.RL2_AsignadoProspectoAfiliacionCaja__c = False;
        lstUsr.add(usr3);
        insert lstUsr;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoDocumento__c      =   '2';
        objCandidato.CEL1_NumeroDocumento__c    =   '18800990';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.Status						=	'Nuevo';
        objCandidato.RL2_TipoDeSolicitud__c		= 	'Traslado';
        objCandidato.LeadSource					=	'Call Center';
		objCandidato.RecordTypeId				=	idRecordTypeAfiliacionCaja;
        objCandidato.Company					=	'Text255';
        objCandidato.NumberOfEmployees			=	10;
        objCandidato.RL2_NoTrabajadoresQueRecibenSubsidio__c = 12;
        objCandidato.RL2_ValorDeNomina__c		=	15;
        
        try {
            insert objCandidato;
            objCandidato.Status = 'EnGestion';
            update objCandidato;
        } catch (Exception e) {
            System.debug('--->> ERROR AL INSERTAR CANDIDATO: ' + e.getMessage());
        }
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setConvertedStatus('Convertido');
        
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.stopTest();
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        System.assertEquals(true, lcr.isSuccess());
    }
}