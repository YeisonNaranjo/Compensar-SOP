/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Compensar
* Descripción:      Clase encargada de generar la data para todas las clases de prueba. 
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    31/07/2017      Juan David Uribe Ruiz               Creación de la clase
*           -----   ----------      ---------------------               ---------------
* @version   2.0    19/08/2020      Yeison Stic Naranjo                 Oportunidad con programa de vinculación
*           -----   ----------      ---------------------               ---------------
* @version   3.0    24/09/2020      Yeison Stic Naranjo                 Aumento cobertura NOLA 00020102.
****************************************************************************************************************/
public with sharing class COM_DataGenerator_cls {
    
    public static list<COM_ConfiguracionWebServiceM__mdt> crearConfiguracionWebService(boolean doInsert){
        /*COM_ConfiguracionWebService__c objConfiguracionWebService;
        list<COM_ConfiguracionWebService__c> lstConfiguracionWebService;
        
        lstConfiguracionWebService = new list<COM_ConfiguracionWebService__c>();
        
        objConfiguracionWebService = new COM_ConfiguracionWebService__c();
        objConfiguracionWebService.Name = 'Georeferenciacion';
        objConfiguracionWebService.COM_Protocolo__c = 'https';
        objConfiguracionWebService.COM_DireccionIp__c = 'devesb.compensar.com';
        objConfiguracionWebService.COM_Puerto__c = null;
        objConfiguracionWebService.COM_Recurso__c = '/Compensar/Services/Georeferencia';
        objConfiguracionWebService.COM_Metodo__c = 'GET';
        lstConfiguracionWebService.add(objConfiguracionWebService);
        
        if(doInsert){
            insert lstConfiguracionWebService;
        }
        
        return lstConfiguracionWebService;*/
        return [Select COM_Protocolo__c, COM_DireccionIp__c, COM_Puerto__c, COM_Recurso__c, COM_Metodo__c From COM_ConfiguracionWebServiceM__mdt where Label = 'Georeferenciacion' limit 1];
    }

    public static list<COM_ConfiguracionHeaderWSM__mdt> crearConfiguracionHeaderWS(boolean doInsert){
        /*COM_ConfiguracionHeaderWS__c objConfiguracionHeaderWS;
        list<COM_ConfiguracionHeaderWS__c> lstConfiguracionHeaderWS;
        
        lstConfiguracionHeaderWS = new list<COM_ConfiguracionHeaderWS__c>();
        
        objConfiguracionHeaderWS = new COM_ConfiguracionHeaderWS__c();
        objConfiguracionHeaderWS.Name = 'TIBCO-Georeferenciacion';
        objConfiguracionHeaderWS.COM_ApplicationId__c = 'SWEX126';
        objConfiguracionHeaderWS.COM_Password__c = 'pwrGEO';
        objConfiguracionHeaderWS.COM_DireccionIp__c = '192.168.0.1';
        objConfiguracionHeaderWS.COM_InputSystem__c = 'Portal';
        objConfiguracionHeaderWS.COM_Usuario__c = 'usrGEO';
        lstConfiguracionHeaderWS.add(objConfiguracionHeaderWS);
        
        if(doInsert){
            insert lstConfiguracionHeaderWS;
        }
        
        return lstConfiguracionHeaderWS;*/
        return [Select COM_Usuario__c, COM_Password__c, COM_InputSystem__c, COM_ApplicationId__c, COM_DireccionIp__c, COM_PrefijoTransaccionId__c From COM_ConfiguracionHeaderWSM__mdt where Label ='TIBCO-Georeferenciacion' limit 1];

    }

    public static Account crearCuenta(boolean doInsert){
          Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test';
          objCuenta.AccountNumber = '654321';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
          objCuenta.COM_TipoIdentificacion__c   =   '1';
          objCuenta.COM_Numero_de_identificacion__c = '12345678909';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
    	  /* Inicio 3.0 */
          objCuenta.COM_Direccion__c   = 'KR 30 # 50';
          objCuenta.Phone = '2780675';
          /* Fin 3.0 */
        
          if(doInsert){
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
    
        return objCuenta;
    }
    
    public static Account crearCuenta3(boolean doInsert){
          Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test2';
          objCuenta.AccountNumber = '654321';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac6662@hotmail.com';
          objCuenta.COM_TipoIdentificacion__c = '1';
          objCuenta.COM_Numero_de_identificacion__c = '8800990077';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
    
          if(doInsert){
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
    
        return objCuenta;
    } 
    public static Account crearCuenta4(boolean doInsert){
          Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test';
          objCuenta.AccountNumber = '654321';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
          objCuenta.COM_Numero_de_identificacion__c = '12345678909';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
          objCuenta.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
    
          if(doInsert){
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
    
        return objCuenta;
    }
      public static Account crearCuenta5(boolean doInsert){
          Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test';
          objCuenta.AccountNumber = '654321';
          objCuenta.Phone = '2423435';
          objCuenta.COM_Barrio__c = 'barrio';
          objCuenta.COM_Tipodireccion__c = 'U';
          objCuenta.COM_Direccion__c = 'cr 5 cl 4';
          objCuenta.COM_NAUTCLI__c='qwrwqrq2434';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
          objCuenta.COM_Numero_de_identificacion__c = '12345678909';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
          objCuenta.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
    
          if(doInsert){
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
    
        return objCuenta;
    }
    

    public static Account insertarAccAnonima(Boolean guardar){
        Account acc = new Account();
        acc.Name = 'a1';
        acc.COM_TipoIdentificacion__c = '1';
        acc.COM_Numero_de_identificacion__c = '9999';
        if(guardar){
            insert acc;
        }
        return acc;
    }

    public static COM_Actas__c crearActa(Boolean crear, Id idCuenta){
        COM_Actas__c acta = new COM_Actas__c();
        acta.COM_ContactoTrabajadores__c = 'pruebas'; 
        acta.COM_EsMigrado__c = false;
        acta.COM_Cuenta__c = idCuenta;
        acta.COM_FechaRealizacion__c = System.today();
        acta.RecordTypeId = Schema.SObjectType.COM_Actas__c.getRecordTypeInfosByName().get('Encuentro con directivos').getRecordTypeId();
        
        if(crear){
            insert acta;
        }
        return acta;
    }

    public static COM_Actas__c crearActa2(Boolean crear, Id idCuenta){
        COM_Actas__c acta = new COM_Actas__c();
        acta.COM_ContactoTrabajadores__c = 'pruebasx'; 
        acta.COM_EsMigrado__c = false;
        acta.COM_Cuenta__c = idCuenta;
        acta.COM_FechaRealizacion__c = System.today();
        acta.RecordTypeId = Schema.SObjectType.COM_Actas__c.getRecordTypeInfosByName().get('Encuentro con directivos').getRecordTypeId();
        
        if(crear){
            insert acta;
        }
        return acta;
    }

    public static COM_Poblacion__c crearPoblacion(boolean crear){
        COM_Poblacion__c pob = new COM_Poblacion__c();
        pob.COM_Codigo__c = '1111';
        pob.COM_Departamento__c = 'PRUEBA';
        pob.Name = 'CiudadPrueba';
        
        if(crear){
            insert pob;
        }
        return pob;
    }




public static Account crearCuenta2(boolean doInsert){
    Account objCuenta;

    objCuenta = new Account();
    objCuenta.Name = 'Test';
        //objCuenta.Lastname = 'Test';
        objCuenta.AccountNumber = '654321';
        objCuenta.BillingStreet = 'Calle 138';
        objCuenta.BillingCity = 'Bogota';
        objCuenta.BillingCountry = 'Colombia';
        objCuenta.BillingState = 'Cundinamarca';
        objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
        objCuenta.COM_Numero_de_identificacion__c = '12345678909';
        objCuenta.COM_TipoIdentificacion__c = '2';
		/* Inicio 3.0 */
        objCuenta.COM_Direccion__c   = 'KR 30 # 50';
        objCuenta.Phone = '2780675';
        /* Fin 3.0 */
    
        COM_Poblacion__c pob = new COM_Poblacion__c();
        pob.COM_Codigo__c = '1111';
        pob.COM_Departamento__c = 'PRUEBA';
        pob.Name = 'CiudadPrueba';

        if(doInsert){
            insert pob;
            objCuenta.COM_Ciudad__c = pob.Id;
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
        
        return objCuenta;
    }

    public static Attachment creaAdjunto(boolean doInsert, Id parentId){
        Attachment objAtt;
        
        objAtt= new Attachment();
        objAtt.Name = 'Prueba.txt';
        objAtt.Body = blob.valueOf('MS4gSW5ncmVzYXIgYSBtYW50aXMgcG9yIGxhIFVSTCBxdWUgbGxlZ2EgZW4gZWwgY29ycmVvIGRlbCBjYXNvIChzaSBlcyBuZWNlc2FyaW8gaW5pY2lhciBzZXNpbyBzZSBoYWNlIGNvbiBlbCB1c3VhcmlvICdnc2FuY2hleicgc2luIHBhc3N3b3JkKQ0KMi4gU3ViaXIgYXJjaGl2byBjb24gZXZpZGVuY2lhIGRlIHNvbHVjaW9uDQozLiBkYXIgY2xpYyBlbiBlZGl0YXINCjMuMSBDYW1iaWFyICJBc2lnbmFkbyBhIiB5IGFzaWduYSBhbCBJbmZvcm1hZG9yDQozLjIgQ2FtYmlhciBlc3RhZG8gYSAiUmVzdWFsdGEiDQozLjMgQWdyZWdhciBub3RhIGNvbiBjb21lbnRhcmlvIGluZGljYW5kbyBxdWUgeWEgc2Ugc29sdWNpb25vIGVsIGNhc28NCjMuNCBzZSBkYSBjbGljIGVuICJBY3R1YWxpemFyIGluZm9tcmFjaW9uIg==');
        objAtt.ParentId = parentId;
        
        if(doInsert)
        {
            insert objAtt;
        }
        return objAtt;
    }
    
    public static EmailTemplate crearEmailTemplate(boolean doInsert){
        EmailTemplate objEmailTemplate;
        
        objEmailTemplate = new EmailTemplate();
        
        objEmailTemplate.Body = 'Hello, Customer! We\'re committed to delivering top-notch customer service. Thank you for your inquiry; we will get back to you as soon as possible. Regards, Northern Trail Outfitters Team';
        objEmailTemplate.Name = 'Email First Response Test';
        objEmailTemplate.DeveloperName = 'Email_First_Response_Test';
        objEmailTemplate.Encoding = 'ISO-8859-1';
        objEmailTemplate.TemplateType = 'custom';
        objEmailTemplate.Subject = 'Thanks for contacting NTO';
        objEmailTemplate.HtmlValue = 'Hello, Customer! <br /> <br /> We\'re committed to delivering top-notch customer service. Thank you for your inquiry; we will get back to you as soon as possible.<br /> <br /> Regards, <br /> Northern Trail Outfitters Team';
        objEmailTemplate.IsActive = true;
        objEmailTemplate.FolderId = UserInfo.getUserId();
        
        if(doInsert)
        {
            insert objEmailTemplate;
        }
        return objEmailTemplate;
    }
    
    public static Contact crearContacto(Boolean doInsert, Id idCuenta)
    {
        Contact objContact;
        objContact = new Contact();
        objContact.FirstName = 'Pepe';
        objContact.LastName = 'Perez';
        objContact.AccountId = idCuenta;
        objContact.Email = 'pruebas@micorreo.com';
        objContact.COM_TipoIdentificacion__c = '1';
        objContact.COM_Numeroidentificacion__c = '12345678909';

        if(doInsert)
        {
            COM_AccountContactRelation_cls.stopTrigger();
            insert objContact;
            COM_AccountContactRelation_cls.startTrigger();
            
        }
        return objContact;
    }

    /* Inicio 2.0 */
    public static Contact crearContacto3(Boolean doInsert, Id idCuenta)
    {
        Contact objContact;
        objContact = new Contact();
        objContact.FirstName = 'Pepe';
        objContact.LastName = 'Perez';
        objContact.AccountId = idCuenta;
        objContact.Email = 'pruebas@micorreo.com';
        objContact.COM_TipoIdentificacion__c = '1';
        objContact.COM_Numeroidentificacion__c = '8800990077';

        if(doInsert)
        {
            COM_AccountContactRelation_cls.stopTrigger();
            insert objContact;
            COM_AccountContactRelation_cls.startTrigger();
            
        }
        return objContact;
    }
    /* Fin 2.0 */
    
    /* Inicio 3.0 */
    public static Contact crearContacto2(Boolean doInsert, Id idCuenta)
    {
        Contact objContact;
        objContact = new Contact();
        objContact.FirstName = 'Pepe';
        objContact.LastName = 'Perez';
        objContact.AccountId = idCuenta;
        objContact.Email = 'pruebas@micorreo.com';
        objContact.COM_TipoIdentificacion__c = '2';
        objContact.COM_Numeroidentificacion__c = '12345678909';

        if(doInsert)
        {
            COM_AccountContactRelation_cls.stopTrigger();
            insert objContact;
            COM_AccountContactRelation_cls.startTrigger();
            
        }
        return objContact;
    }
    /* Fin 3.0 */
    
    public static Opportunity crearOportunidad(Boolean doInsert, Id idCuenta)
    {
        Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = idCuenta;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Cotizado';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_Fecharadicacioncartaretiro__c = System.today();
        objOpportunity.COM_PYS__c = '01t6A000002a4wLQAQ';
        objOpportunity.COM_DSCalc__c = 1000000;
		objOpportunity.COM_SustitucionPatronalAumentoTrab__c = True;//objOpportunity
        //COM_Alojamiento
        
        if(doInsert)
        {
            insert objOpportunity;
        }
        return objOpportunity;
    }
  public static Opportunity crearOportunidad2(Boolean doInsert)
    {
        Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Cotizado';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        //objOpportunity
        //COM_Alojamiento
        
        if(doInsert)
        {
            insert objOpportunity;
        }
        return objOpportunity;
    }
    
    /* Inicio 2.0 */
    public static Opportunity crearOportunidadConPrgVinc(Boolean doInsert, Id idCuenta, Id idPrgVinc)
    {
        Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = idCuenta;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Cotizado';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_ProgramaVinculacion1__c = idPrgVinc;
        objOpportunity.COM_ValorActualNomina__c = 1000000;
        if(doInsert)
        {
            insert objOpportunity;
        }
        return objOpportunity;
    }    
    /* Fin 2.0 */
    
    public static Quote crearQuote(Boolean crear, Id idOpp){
        Quote qt = new Quote();
        qt.OpportunityId = idOpp;
        qt.BillingName = 'La Empresa LTDA.';
        qt.Name = 'Prueba QQ';
        if(crear){
            insert qt;
        }
        return qt;

    }

    public static Document crearDocumento(Boolean crear, String name){
        /*List<Document> fld =[SELECT Folder.Id, Folder.Name, Folder.DeveloperName FROM Document where Folder.IsReadOnly = false];
        Document doc = new Document();
        doc.Name = name;
        doc.DeveloperName = name;*/

        Document document;
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = name;
        document.IsPublic = true;
        document.Name = name;
        List<Folder> sObjectList = [select id, Name from folder where isreadonly = false];
        document.FolderId = sObjectList.get(1).id;



        /*if(!fld.isEmpty()){
            doc.FolderId = fld.get(0).Folder.Id;
            }*/
            if(crear){
                insert document;
            }
            return document;

        }



          public static List<COM_TiposAsesoresAccountTeamM__mdt> crearTiposAsesoresAccountTeam(Boolean doInsert)
        {
        /*COM_TiposAsesoresAccountTeam__c objTipoAsAccTeam;
        objTipoAsAccTeam = new COM_TiposAsesoresAccountTeam__c();
        objTipoAsAccTeam.Name = 'Test';
        objTipoAsAccTeam.COM_AreaTipoAsesor__c = 'PVE';
        objTipoAsAccTeam.COM_NombreTipoAsesor__c = 'Test';
        objTipoAsAccTeam.COM_ApiNameTipoAsesor__c = 'Test';
        
        if(doInsert)
        {
            insert objTipoAsAccTeam;
        }
        return objTipoAsAccTeam;*/

        return [Select COM_AreaTipoAsesor__c, COM_NombreTipoAsesor__c, COM_ApiNameTipoAsesor__c From COM_TiposAsesoresAccountTeamM__mdt where COM_AreaTipoAsesor__c = 'PVE'];
    }


    public static COM_Operador__c crearOperador(Boolean crear){
        COM_Operador__c op = new COM_Operador__c();
        op.COM_CorreoElectronico__c = 'micorreo@compensar.com';
        
        op.COM_Direccion__c = 'DireccionFicti';
        op.COM_EsMigrado__c = false;
        op.COM_Telefono__c = '23141432';
        op.Name = 'Lagomar';
        if(crear){
            insert op;
        }
        return op;
    }

    public static AccountContactRelation crearContRelation(Boolean crear, Id idcuenta, Id idContacto){
        List<AccountContactRelation> acrs = [Select Id, Roles, COM_CargoEmpresa__c from AccountContactRelation where AccountId =:idcuenta and ContactId =:idContacto];
        System.debug('acrs....'+acrs);
        if(!acrs.isEmpty()){
            acrs.get(0).Roles = 'Representante Legal';
            acrs.get(0).COM_CargoEmpresa__c= 'Luchador';
            acrs.get(0).isActive= True;
            acrs.get(0).RF2_CorreoCorporativo__c= 'pruebas@compensar.com';
            if(crear){
                update acrs;
            }
            return acrs.get(0);
            }else{        
                AccountContactRelation acr = new AccountContactRelation();
                acr.COM_EsMigrado__c = false;
                acr.ContactId = idContacto;
                acr.AccountId = idcuenta;
                acr.COM_CargoEmpresa__c= 'Luchador';
                acr.Roles = 'CEO';
                if(crear){
                    insert acr;
                }
                return acr;
            }
        }

        public static AccountTeamMember crearAccountTeamMember(Boolean doInsert, Id idCuenta)
        {
           AccountTeamMember objAccTeamMember;
           objAccTeamMember = new AccountTeamMember();
           objAccTeamMember.AccountId = idCuenta;
           objAccTeamMember.TeamMemberRole = Label.COM_PAF_TypeTeamAsesor;
           objAccTeamMember.UserId = UserInfo.getUserId();

           if(doInsert)
           {
            insert objAccTeamMember;
        }
        return objAccTeamMember;
    }

    public static COM_Asignacion__c crearAsignacion(Boolean doInsert, String straName, Id userId)
    {
        System.debug('usuarios:::'+straName);
        COM_Asignacion__c objAsginacion         = new COM_Asignacion__c();
        //objAsginacion.Name                      = straName;
        objAsginacion.COM_Usuario__c            = userId;
        objAsginacion.COM_FechaAsignacion__c    = System.now().addDays(-5);
        objAsginacion.COM_perfil__c = straName;
        
        if(doInsert)
        {
            insert objAsginacion;
        }
        return objAsginacion;
    }

    /**
     * Metodo encargado de generar la configuracion perzonalizada tabla dominio.
     * @param name
     * @param codigo
     * @param valor
     * @param nombreTabla
     * @return la configuracion generada.
     */
    public static CON_TABLAS_DOMINIOM__mdt generateTableDominio(String name,
     String codigo, String valor, String nombreTabla) {
        /*CON_TABLAS_DOMINIO__c tablasDominio = new CON_TABLAS_DOMINIO__c();
        tablasDominio.Name = name;
        tablasDominio.com_valor__c = valor;
        tablasDominio.com_tabla__c = nombreTabla;
        tablasDominio.com_codigo__c = codigo;

        return tablasDominio;*/
        return null;
    }


    public static AVX_ENC_PreguntaEncuesta__c preguntaEncuesta(Boolean crear, Id planilla){
        AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c();
        pregunta.esValida__c = true;
        pregunta.Name = 'Cosa';
        pregunta.NumeroOpciones__c = 0;
        pregunta.NumeroPreguntas__c = 1;
        pregunta.Numero_de_pregunta__c = 1;
        pregunta.Obligatorio__c = true;
        pregunta.Tipo_pregunta__c = 'Texto';
        pregunta.Pregunta__c = 'Que cosa';
        pregunta.Plantilla_encuesta__c=planilla;

        if(crear){
            insert pregunta;
        }
        return pregunta;

    }

    public static AVX_ENC_PreguntaEncuesta__c preguntaEncuestaMatricial(Boolean crear, Id planilla){
        AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c();
        pregunta.esValida__c = true;
        pregunta.Name = 'Cosa';
        pregunta.NumeroOpciones__c = 0;
        pregunta.NumeroPreguntas__c = 1;
        pregunta.Numero_de_pregunta__c = 1;
        pregunta.Obligatorio__c = true;
        pregunta.Tipo_pregunta__c = 'Numérico';
        pregunta.Pregunta__c = 'Que cosa';
        pregunta.Plantilla_encuesta__c=planilla;
        List<RecordType> rtList =  [SELECT Id FROM RecordType where Name = 'Matricial' limit 1]; 
        pregunta.RecordTypeId  = rtList.get(0).Id;

        if(crear){
            insert pregunta;
        }
        return pregunta;

    }


    public static AVX_ENC_PlantillaEncuesta__c generarPlantillaAlone(Boolean insertar){

        AVX_ENC_PlantillaEncuesta__c plantilla = new AVX_ENC_PlantillaEncuesta__c();
        plantilla.Activo__c = false;
        plantilla.Name = 'Plantilla';

        AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c();
        pregunta.esValida__c = true;
        pregunta.Name = 'Cosa';
        pregunta.NumeroOpciones__c = 0;
        pregunta.NumeroPreguntas__c = 1;
        pregunta.Numero_de_pregunta__c = 1;
        pregunta.Obligatorio__c = true;
        pregunta.Tipo_pregunta__c = 'Texto';
        pregunta.Pregunta__c = 'Que cosa';
        pregunta.Opciones_de_respuesta__c = '1Ã1Õ2Ã2Õ3Ã3Õ4Ã4Õ5Ã5Õ6Ã6ÕNAÃ0';



        if(insertar){
            insert plantilla;
        }
        return plantilla;
    }


    public static AVX_ENC_Encuesta__c generarEncuesta(Boolean crear, Id plantilla){

        List<RecordType> rt = [Select Id FROM RecordType where DeveloperName = 'Contestada'];
        AVX_ENC_Encuesta__c enc = new AVX_ENC_Encuesta__c();
        enc.Plantilla_encuesta__c = plantilla;
        enc.RecordTypeId = rt.get(0).Id;
        if(crear){
            insert enc;
        }
        return enc;

    }


    public static AVX_ENC_PlantillaEncuesta__c generarPlantilla(Boolean insertar){

        AVX_ENC_PlantillaEncuesta__c plantilla = new AVX_ENC_PlantillaEncuesta__c();
        plantilla.Activo__c = false;
        plantilla.Name = 'Plantilla';

        AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c();
        pregunta.esValida__c = true;
        pregunta.Name = 'Cosa';
        pregunta.NumeroOpciones__c = 0;
        pregunta.NumeroPreguntas__c = 1;
        pregunta.Numero_de_pregunta__c = 1;
        pregunta.Obligatorio__c = true;
        pregunta.Tipo_pregunta__c = 'Texto';
        pregunta.Pregunta__c = 'Que cosa';




        if(insertar){
            insert plantilla;
            pregunta.Plantilla_encuesta__c = plantilla.Id;
            insert pregunta;
            plantilla.Activo__c = true;
            update plantilla;
        }
        return plantilla;
    }
	


    public  static List<OpportunityLineItem> oppLineItem(Boolean crear, Id oportunidad, Id producto, Id pricebook2, Integer iniIndex, Integer finIndex){
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
        for(Integer i = iniIndex; i<= finIndex; i++){
            OpportunityLineItem opp = new OpportunityLineItem();
            
        }
        
        if(crear){
            insert lstOLI;
        }
        return lstOLI;
    }

    public static Pricebook2 createPriceBook(Boolean crear){
        Pricebook2 pb = new Pricebook2();
        //pb.IsActive(true);
        //pb.IsStandard(true);
        pb.Name = 'Test Price Book';
        if(crear){
            insert pb;
        }
        return pb;

    }

    public static Product2 crearProductoAlojamiento(Boolean crear){
        Product2 pd = new Product2();
        pd.Family= 'P&S';
        pd.COM_Ciclo__c = 'Alojamiento';
        pd.COM_Duracion__c = 1;
        pd.COM_Idciclo__c = 2;
        pd.Name = 'Prueba Producto';
        //pd.RecordTypeId = 

        if(crear){
            insert pd;
        }
        return pd;

    }
    
    public static COM_ProgramaVinculacion__c crearProgramaVinculacion(boolean doInsert){
        
        COM_ProgramaVinculacion__c objProgramaVinculacion = new COM_ProgramaVinculacion__c();
        objProgramaVinculacion.Name = 'Programa Vinculacion';
        objProgramaVinculacion.COM_Codigo__c = '1010';
        if(doInsert){
            insert objProgramaVinculacion;
        }

        return objProgramaVinculacion;
    }
    
    /* Inicio 2.0 */
    public static COM_ProgramaVinculacion__c crearProgramaVinculacion1(boolean doInsert, boolean PermDupOpp){
        
        COM_ProgramaVinculacion__c objProgramaVinculacion = new COM_ProgramaVinculacion__c();
        objProgramaVinculacion.Name = 'Programa Vinculacion';
        objProgramaVinculacion.COM_Codigo__c = '1011';
        objProgramaVinculacion.COM_Permite_Multiples_Oportunidades__c = PermDupOpp;
        if(doInsert){
            insert objProgramaVinculacion;
        }

        return objProgramaVinculacion;
    }
    
    public static COM_ProgramaVinculacion__c crearProgramaVinculacion2(boolean doInsert, boolean PermDupOpp){
        
        COM_ProgramaVinculacion__c objProgramaVinculacion = new COM_ProgramaVinculacion__c();
        objProgramaVinculacion.Name = 'Programa Vinculacion 2';
        objProgramaVinculacion.COM_Codigo__c = '1012';
        objProgramaVinculacion.COM_Permite_Multiples_Oportunidades__c = PermDupOpp;
        if(doInsert){
            insert objProgramaVinculacion;
        }

        return objProgramaVinculacion;
    }
    /* Fin 2.0 */
    
    public static COM_ActividadEconomicaCIIU__c crearActividadEconomicaCIIU(boolean doInsert){
        COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU = new COM_ActividadEconomicaCIIU__c();
        objActividadEconomicaCIIU.Name = 'ActividadEconomicaCIIU';
        objActividadEconomicaCIIU.COM_Codigo__c = '8424';
        
        if(doInsert){
            insert objActividadEconomicaCIIU;
        }

        return objActividadEconomicaCIIU;
    }
    
    public static COM_ActividadEconomicaCIIU__c crearActividadEconomicaCIIU2(boolean doInsert, String strCodigo){
        COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU = new COM_ActividadEconomicaCIIU__c();
        objActividadEconomicaCIIU.Name = 'ActividadEconomicaCIIU';
        objActividadEconomicaCIIU.COM_Codigo__c = strCodigo;
        
        if(doInsert){
            insert objActividadEconomicaCIIU;
        }

        return objActividadEconomicaCIIU;
    }
    
    public static COM_CalculadoraSuperavit2__c crearCalculadoraSuperavit2(boolean doInsert){
        COM_CalculadoraSuperavit2__c objCalculadoraSuperavit2 = new COM_CalculadoraSuperavit2__c();
        objCalculadoraSuperavit2.COM_PorcentajeAporte__c = 0.040000;
        objCalculadoraSuperavit2.COM_PorcentajeApropiacion__c = 0.450000;
        objCalculadoraSuperavit2.COM_PorcentajeFactor__c = 0.982000;
        objCalculadoraSuperavit2.COM_CalcValorPagarSubsidio__c = 29600.000000;
        
        if(doInsert){
            insert objCalculadoraSuperavit2;
        }

        return objCalculadoraSuperavit2;
    }
    
    public static COM_MetaAnual__c crearMetaAnualAfiliacion(boolean doInsert){
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetaAnual__c' AND DeveloperName = 'COM_Afiliacion'];
        
        COM_MetaAnual__c objMetaAnual = new COM_MetaAnual__c();
        objMetaAnual.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetaAnual.COM_Anio__c = '2018';
        
        if(doInsert){
            insert objMetaAnual;
        }

        return objMetaAnual;
    }
    
    public static COM_MetasMensual__c crearMetaMensualAfiliacion(boolean doInsert, Id idMetaAnual){
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetasMensual__c' AND DeveloperName = 'COM_Afiliacion'];
        
        COM_MetasMensual__c objMetasMensual = new COM_MetasMensual__c();
        objMetasMensual.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetasMensual.COM_MetaAnual__c = idMetaAnual;
        objMetasMensual.COM_Mes__c = 'Octubre';
        objMetasMensual.COM_Comite_Activo__c  = true;
        
        if(doInsert){
            insert objMetasMensual;
        }

        return objMetasMensual;
    }
    
    public static COM_MetasIndividuales__c crearMetaIndividualAfiliacion(boolean doInsert, Id idMetaMensual, Account ac){
        COM_MetasIndividuales__c objMetasIndividuales = new COM_MetasIndividuales__c();
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetasIndividuales__c' AND DeveloperName = 'COM_Afiliacion'];
        objMetasIndividuales.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetasIndividuales.COM_Superavit__c = 13000000;
        objMetasIndividuales.COM_Asesor__c = UserInfo.getUserId();
        objMetasIndividuales.COM_MetaMensuale__c = idMetaMensual;


        if(doInsert){
            insert objMetasIndividuales;
        }

         Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = ac.Id;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Cotizado';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_FechaFacturacion__c = System.today();
        objOpportunity.COM_MetaIndividual__c = objMetasIndividuales.Id;

        //objOpportunity
        //COM_Alojamiento
        
       
            insert objOpportunity;
      

        return objMetasIndividuales;
    }
    
    /*public static User crearUsuario(boolean doInsert){
        
        UserRole r = [SELECT Id FROM UserRole WHERE DeveloperName = 'Administrador_del_Sistema'].get(0);
        
        User objUser = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = r.Id
        );
        
        if(doInsert){
            insert objUser;
        }
            
        return objUser;
        }*/

    public static list<RF2_MatrizResponsablesCaso__c> crearMatrizREsponsablesCaso(boolean doInsert){
        list<RF2_MatrizResponsablesCaso__c> lstMatrizResponsable = new list<RF2_MatrizResponsablesCaso__c>();
        RF2_MatrizResponsablesCaso__c objMatrizResponsables;
        String strResponsableCaso;
        
        List<QueueSobject> lstQueueSobject = [SELECT QueueId FROM QueueSobject where Queue.DeveloperName NOT IN (:Label.RF2_NombreColaPendienteAsignacion, :label.RF2_NombreColaAnalistasSondeo_lbl) AND Queue.Type = 'Queue'];
        
        if(!lstQueueSobject.isEmpty()){
            strResponsableCaso = lstQueueSobject.get(0).QueueId;
        } else{
            strResponsableCaso = null;
        }
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Queja';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Otros';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'CRM PCE';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Alimentos';
        objMatrizResponsables.RF2_IdExterno__c = '11';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Queja';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Otros';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'URL PCE';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Alimentos';
        objMatrizResponsables.RF2_IdExterno__c = '91';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Solicitud GIE';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Vacios';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'Empresarial';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Traslado de aportes a otras CCF';
        objMatrizResponsables.RF2_IdExterno__c = '230';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Solicitud GIE';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Vacios';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'Pensionado';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Traslado de aportes a otras CCF';
        objMatrizResponsables.RF2_IdExterno__c = '232';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        if(doInsert){
            insert lstMatrizResponsable;
        }
            
        return lstMatrizResponsable;
    }

    public static Case crearCaso(Boolean guardar, Id idCuenta, Id idContacto){
        Case caso = new Case();
        caso = new Case();
        caso.ContactId = idContacto;
        caso.AccountId = idCuenta;
        caso.Origin = 'Call Center';
        caso.Status = 'Abierto';
        caso.RF2_GrupoCicloNegocio__c = 'Aportes';
        caso.RF2_TipoSolicitud__c = 'Queja';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
        caso.Subject = 'subject';
        if(idCuenta == null && idContacto == null){
            COM_Poblacion__c pob = crearPoblacion(true);
            caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
            caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
            caso.RF2_CiudadHuerfano__c = pob.Id;
            caso.RF2_CompanyaHuerfano__c = 'company';
            caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
            caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
            caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
            caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
            caso.RF2_TelefonoHuerfano__c = '323333232';
            caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
            caso.RF2_TipoIdentificacionHuerfano__c = '1';
        }
        if(guardar){
            insert caso;
        }
        return caso;
    }
    
    public static Case crearCaso2(Boolean guardar, Id idCuenta, Id idContacto){
        Case caso = new Case();
        caso = new Case();
        idContacto = null;
        idCuenta = null;
        caso.ContactId = idContacto;
        caso.AccountId = idCuenta;
        caso.Origin = 'Call Center';
        caso.Status = 'Abierto';
        caso.RF2_GrupoCicloNegocio__c = 'Aportes';
        caso.RF2_TipoSolicitud__c = 'Queja';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
        caso.Subject = 'subject';
        if(idCuenta == null && idContacto == null){
            COM_Poblacion__c pob = crearPoblacion(true);
            caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
            caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
            caso.RF2_CiudadHuerfano__c = pob.Id;
            caso.RF2_CompanyaHuerfano__c = 'company';
            caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
            caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
            caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
            caso.RF2_NumeroIdentificacionHuerfano__c  = null;
            caso.RF2_TelefonoHuerfano__c = '323333232';
            caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
            caso.RF2_TipoIdentificacionHuerfano__c = '1';
        }
        if(guardar){
            insert caso;
        }
        return caso;
    }

     public static Case crearCasoAnonimo(Boolean guardar, Id idCuenta){
        Case caso = new Case();
        caso = new Case();
        //caso.ContactId = idContacto;
        caso.AccountId = idCuenta;
        caso.Origin = 'Call Center';
        caso.Status = 'Abierto';
        caso.RF2_GrupoCicloNegocio__c = 'Aportes';
        caso.RF2_TipoSolicitud__c = 'Queja';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
        caso.RF2_Anonimo__c = true;
        caso.RF2_SolucionadoPrimerContacto__c = true;
        if(guardar){
            insert caso;
        }
        return caso;
    }

     public static Case crearCasox(Boolean guardar, Id idCuenta, Id idContacto, String tipoSolicitud, String procesoDestino, String relacionadoCon, String cicloNegocio, String origen, Boolean primerContacto){
        Case caso = new Case();
        caso.ContactId = idContacto;
        caso.AccountId = idCuenta;
        caso.Origin = origen;
        caso.Status = 'Abierto';
        caso.RF2_GrupoCicloNegocio__c = cicloNegocio;
        caso.RF2_TipoSolicitud__c = tipoSolicitud;
        caso.RF2_ProcesoDestinoMatrizResponsable__c = procesoDestino;
        caso.RF2_RelacionadoCon__c = relacionadoCon;
        caso.RF2_SolucionadoPrimerContacto__c = primerContacto;
        if(idCuenta == null && idContacto == null){
            COM_Poblacion__c pob = crearPoblacion(true);
            caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
            caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
            caso.RF2_CiudadHuerfano__c = pob.Id;
            caso.RF2_CompanyaHuerfano__c = 'company';
            caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
            caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
            caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
            caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
            caso.RF2_TelefonoHuerfano__c = '323333232';
            caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
            caso.RF2_TipoIdentificacionHuerfano__c = '1';
        }
        if(guardar){
            insert caso;
        }
        return caso;
    }


    public static LiveChatTranscript crearTranscripcion(Boolean guardar, Id idCaso, Id idLiveChatVisitor){
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.Body = 'TODO bien Niño';
        lct.Location = 'Buenos Aires, C, Argentina';
        lct.CaseId = idCaso;
        lct.LiveChatVisitorId = idLiveChatVisitor;
        lct.ChatKey = 'XXXXXX';
        if(guardar){
            insert lct;
        }
        return lct;
    }

    public static LiveChatVisitor crearLiveChatVisitor(Boolean guardar){
        LiveChatVisitor lcv = new LiveChatVisitor();
        if(guardar){
            insert lcv;
        }
        return lcv;
    }

    public static RF2_EncuestasCasos__c crearEncuestaCaso(Boolean guardar, Id idCaso){
        RF2_EncuestasCasos__c encCaso = new RF2_EncuestasCasos__c();
        encCaso.RecordTypeId = Schema.SObjectType.RF2_EncuestasCasos__c.getRecordTypeInfosByName().get('Encuesta Sondeo').getRecordTypeId();
        encCaso.OwnerId = UserInfo.getUserId();
        encCaso.RF2_Caso__c = idCaso;
        encCaso.RF2_Estado__c = 'Abierta'; 
        encCaso.RF2_ChatKey__c = 'XXXXXX';
        if(guardar){
            insert encCaso;
        }
        return encCaso;
    }

    public static Lead crearCandidato(Boolean guardar){
        Lead lead = new Lead();
        lead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Cuenta Acreedora PN').getRecordTypeId();
        lead.FirstName = 'Nombre Test';
        lead.LastName = 'Test';
        lead.CEL1_NumeroDocumento__c = '21312874124';
        lead.CEL1_TipoDocumento__c = '1';       
        lead.Email = 'correo@correo.com';   
        if(guardar){
            insert lead;
        }
        return lead;
    }

    public static CEL1_NoticiasConocimientoMercado__c crearNoticiasMuro(Boolean guardar){
        CEL1_NoticiasConocimientoMercado__c objNoticias = new CEL1_NoticiasConocimientoMercado__c();
        objNoticias.CEL1_Categoria__c = 'Servicios;Promociones';
        objNoticias.CEL1_DescripcionFinal__c = 'Descripcion finaaal';
        objNoticias.CEL1_DescripcionNoticia__c = 'Descripción noticia';
        objNoticias.CEL1_Estado__c = 'Sin validar';
        objNoticias.CEL1_GrupoInteres__c = 'Analistas';
       
        if(guardar){
            insert objNoticias;
        }
        return objNoticias;
    }
    public static CEL1_NoticiasConocimientoMercado__c crearNoticiasMuro2(Boolean guardar){
        CEL1_NoticiasConocimientoMercado__c objNoticias2 = new CEL1_NoticiasConocimientoMercado__c();
        objNoticias2.CEL1_Categoria__c = 'Servicios;Promociones';
        objNoticias2.CEL1_DescripcionFinal__c = 'Descripcion finaaal';
        objNoticias2.CEL1_DescripcionNoticia__c = 'Descripción noticia';
        objNoticias2.CEL1_Estado__c = 'Sin validar';
        objNoticias2.CEL1_GrupoInteres__c = 'Gerencia';
      
       
        if(guardar){
            insert objNoticias2;
        }
        return objNoticias2;
    }
    public static CollaborationGroup crearGrupoChatter(Boolean guardar){

        CollaborationGroup objGroup =  new CollaborationGroup();
        objGroup.Name= 'Analistas tst';
        objGroup.CollaborationType='Private';
        if(guardar){
            insert objGroup;
        }
        return objGroup;
    }

    public static CollaborationGroup crearGrupoChatter2(Boolean guardar){

        CollaborationGroup objGroup2 =  new CollaborationGroup();
        objGroup2.Name= 'Auxiliares test';
        objGroup2.CollaborationType='Private';
       
        if(guardar){
            insert objGroup2;
        }
        return objGroup2;
    }
    
    
    
    /*Inicio S*/
     public static COM_MetasIndividuales__c crearMetaIndividualAfiliacionDesembolso(boolean doInsert, Id idMetaMensual, Account ac){
        COM_MetasIndividuales__c objMetasIndividuales = new COM_MetasIndividuales__c();
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetasIndividuales__c' AND DeveloperName = 'COM_Afiliacion'];
        objMetasIndividuales.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetasIndividuales.COM_Superavit__c = 13000000;
        objMetasIndividuales.COM_Asesor__c = UserInfo.getUserId();
        objMetasIndividuales.COM_Canal__c = '11';
        objMetasIndividuales.COM_Ciclo__c = 'Alojamiento'; 
        objMetasIndividuales.COM_MetaMensuale__c = idMetaMensual;

	
		list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Alojamiento'];
         
        if(doInsert){
            insert objMetasIndividuales;
        }

         Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = ac.Id;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Facturada';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.RecordTypeId = lstRecordType.get(0).Id;
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_FechaFacturacion__c = System.today();
        objOpportunity.COM_MetaIndividual__c = objMetasIndividuales.Id;
        objOpportunity.COM_Valor_antes_Impuesto__c = 20000;
        objOpportunity.COM_Canalventas__c = '11';
        objOpportunity.OwnerId =  UserInfo.getUserId();

        //objOpportunity
        //COM_Alojamiento
        
       
            insert objOpportunity;
      

        return objMetasIndividuales;
    }
    
    
    public static COM_MetasIndividuales__c crearMetaIndividualAfiliacionDesembolso2(boolean doInsert, Id idMetaMensual, Account ac){
        COM_MetasIndividuales__c objMetasIndividuales = new COM_MetasIndividuales__c();
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetasIndividuales__c' AND DeveloperName = 'COM_Afiliacion'];
        objMetasIndividuales.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetasIndividuales.COM_Superavit__c = 13000000;
        objMetasIndividuales.COM_Asesor__c = UserInfo.getUserId();
        objMetasIndividuales.COM_Canal__c = '11';
        objMetasIndividuales.COM_Ciclo__c = 'Financiero Crédito'; 
        objMetasIndividuales.COM_MetaMensuale__c = idMetaMensual;

	
		list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_FinancieroCredito'];
         
        if(doInsert){
            insert objMetasIndividuales;
        }

         Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = ac.Id;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'DESEMBOLSADO';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.RecordTypeId = lstRecordType.get(0).Id;
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_FechaFacturacion__c = System.today();
        objOpportunity.COM_MetaIndividual__c = objMetasIndividuales.Id;
        objOpportunity.COM_Valor_antes_Impuesto__c = 20000;
        objOpportunity.COM_Canalventas__c = '11';
        objOpportunity.OwnerId =  UserInfo.getUserId();
        objOpportunity.COM_FechaFacturacion__c = System.today();

        //objOpportunity
        //COM_Alojamiento
        
       
            insert objOpportunity;
      

        return objMetasIndividuales;
    }
    
    
     public static COM_MetaAnual__c crearMetaAnualAfiliacionCurrentYear(boolean doInsert){
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetaAnual__c' AND DeveloperName = 'COM_Afiliacion'];
        
        COM_MetaAnual__c objMetaAnual = new COM_MetaAnual__c();
        objMetaAnual.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetaAnual.COM_Anio__c = String.valueOf(date.today().year());
        
        if(doInsert){
            insert objMetaAnual;
        }

        return objMetaAnual;
    }
    
    public static COM_MetasMensual__c crearMetaMensualAfiliacionCurrentMonth(boolean doInsert, Id idMetaAnual){
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetasMensual__c' AND DeveloperName = 'COM_Afiliacion'];
        
        COM_MetasMensual__c objMetasMensual = new COM_MetasMensual__c();
        objMetasMensual.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetasMensual.COM_MetaAnual__c = idMetaAnual;
        objMetasMensual.COM_Mes__c = COM_Utilidades_cls.obtenerMes(date.today().month());
        objMetasMensual.COM_Comite_Activo__c  = true;
        
        if(doInsert){
            insert objMetasMensual;
        }

        return objMetasMensual;
    }
    
    
    
    
    public static COM_MetasIndividuales__c crearMetaIndividualAfiliacionDesembolso3(boolean doInsert, Id idMetaMensual, Account ac){
        COM_MetasIndividuales__c objMetasIndividuales = new COM_MetasIndividuales__c();
        list<RecordType> lstRecordTypeMetas = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'COM_MetasIndividuales__c' AND DeveloperName = 'COM_Afiliacion'];
        objMetasIndividuales.RecordTypeId = lstRecordTypeMetas.get(0).Id;
        objMetasIndividuales.COM_Superavit__c = 13000000;
        objMetasIndividuales.COM_Asesor__c = UserInfo.getUserId();
        objMetasIndividuales.COM_Canal__c = '11';
        objMetasIndividuales.COM_Ciclo__c = 'Financiero Crédito'; 
        objMetasIndividuales.COM_MetaMensuale__c = idMetaMensual;

	
		list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_VEmpresas'];
         
        if(doInsert){
            insert objMetasIndividuales;
        }

         Opportunity objOpportunity;
        objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = ac.Id;
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'DESEMBOLSADO';
        objOpportunity.COM_Fechahorainicio__c = System.today();
        objOpportunity.COM_Fechahorafinalizacion__c = System.today();
        objOpportunity.RecordTypeId = lstRecordType.get(0).Id;
        objOpportunity.amount = 100; 
        objOpportunity.COM_Requieretransporte__c = true;
        objOpportunity.COM_FechaFacturacion__c = System.today();
        objOpportunity.COM_MetaIndividual__c = objMetasIndividuales.Id;
        objOpportunity.COM_Valor_antes_Impuesto__c = 20000;
        objOpportunity.COM_Canalventas__c = '11';
        objOpportunity.OwnerId =  UserInfo.getUserId();
        objOpportunity.COM_FechaFacturacion__c = System.today();

        //objOpportunity
        //COM_Alojamiento
        
       
            insert objOpportunity;
      

        return objMetasIndividuales;
    }
    
    
    /*Fin S*/

   
    
}