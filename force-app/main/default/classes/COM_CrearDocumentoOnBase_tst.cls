/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_CrearDocumentoOnBase_ctr
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    29/09/2017      Juan David Uribe Ruiz                     Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_CrearDocumentoOnBase_tst {
    
    
    @isTest static void pruebaCrearDocumentoCuentaOnBase(){
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
        //Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objCuenta.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 
        
		/* Inicio 3.1 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 3.1 */
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);
        	COM_CrearDocumentoOnBase_ws.crearDocumentoOnBaseSupport(objContentVersion.Id, lstConfig[0].Id,user_Identificacion);
            COM_CrearDocumentoOnBase_ws.DTORespuesta dto = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(objContentVersion, lstConfig[0], objContentVersion.Id, user_Identificacion);
        Test.stopTest();
    }
    
    @isTest static void pruebaCrearDocumentoOportunidadOnBase(){
        Account objAcc;
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Contact objContact;
        
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
       // Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objOpp.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objOpp.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 
        
		        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            
            try{
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);                
            } catch(Exception e){
                system.debug('ERROR [pruebaCrearDocumentoActasOnBase]: ' + e.getMessage());
            }
        Test.stopTest();
    }
    
    @isTest static void pruebaCrearDocumentoCotizacionOnBase(){
        Account objAcc;
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Contact objContact;
        Quote objQuote;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
        
        objQuote = COM_DataGenerator_cls.crearQuote(false, objOpp.Id);
        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
        objQuote.Status = 'Aprobada';
        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
        insert objQuote;
        
        
        //Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objQuote.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objQuote.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            
            try{
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);
            } catch(Exception e){
                system.debug('ERROR [pruebaCrearDocumentoActasOnBase]: ' + e.getMessage());
            }
        Test.stopTest();
    }
    
    @isTest static void pruebaCrearDocumentoActasOnBase(){
        Account objAcc;
        COM_Actas__c objActa;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objActa = COM_DataGenerator_cls.crearActa(true, objAcc.Id);
        
       // Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objActa.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objActa.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
                         
            try{
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);
            } catch(Exception e){
                system.debug('ERROR [pruebaCrearDocumentoActasOnBase]: ' + e.getMessage());
            }
        Test.stopTest();
    }
    
    @isTest static void pruebaCrearDocumentoErrorOnBase(){
        Account objAcc;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        //Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objAcc.Id);
        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objAcc.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];

            COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, null);
            COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(null, lstConfig[0].Id);
        Test.stopTest();
    }
    @isTest static void PruebaCase(){
        Account objAcc;
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Contact objContact;
        Case objCase;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        objCase = COM_DataGenerator_cls.CrearCaso(true, objAcc.Id, objContact.id);
        
       // Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objOpp.Id);
        
        ContentVersion objContentVersionCase = new ContentVersion();
        objContentVersionCase.title='Prueba';
        objContentVersionCase.PathOnClient ='testCrear.pdf';
        Blob b2s=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersionCase.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersionCase;
        List<ContentDocument> documentsCase = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlinkCase =new ContentDocumentLink();
        contentlinkCase.LinkedEntityId=objCase.id;
        contentlinkCase.ShareType= 'V';
        contentlinkCase.ContentDocumentId=documentsCase[0].Id;
        contentlinkCase.Visibility = 'AllUsers'; 
        insert contentlinkCase; 
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            
            try{
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersionCase.Id, lstConfig[0].Id);
            } catch(Exception e){
                system.debug('ERROR [pruebaCrearDocumentoActasOnBase]: ' + e.getMessage());
            }
        Test.stopTest();
    }
    
    @isTest static void testErrores(){
        
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
        //Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objCuenta.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 

        /* Inicio 3.1 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 3.1 */
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'Prueba'];
            //COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);
            COM_CrearDocumentoOnBase_ws.DTORespuesta dto = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(objContentVersion, null, objContentVersion.Id, user_Identificacion);
        Test.stopTest();
        
        
    }
    @isTest static void pruebaCrearDocumentoCuentaOnBaseExcel(){
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
        //Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.xlsx';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objCuenta.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 
        
		/* Inicio 3.1 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 3.1 */
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);
            COM_CrearDocumentoOnBase_ws.DTORespuesta dto = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(objContentVersion, lstConfig[0], objContentVersion.Id, user_Identificacion);
        Test.stopTest();
    }
    @isTest static void pruebaCrearDocumentoCuentaOnBaseDocs(){
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
        //Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.docx';
        Blob b1=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=objCuenta.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink; 

		/* Inicio 3.1 */
        String user_Identificacion =  [Select COM_Identificacion__c From User Where Id = :UserInfo.getUserId()][0].COM_Identificacion__c;
        /* Fin 3.1 */
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersion.Id, lstConfig[0].Id);
            COM_CrearDocumentoOnBase_ws.DTORespuesta dto = COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase2(objContentVersion, lstConfig[0], objContentVersion.Id, user_Identificacion);
        Test.stopTest();
    }
    @isTest static void coberTestUtilitadWebS(){
        Account objAcc;
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Contact objContact;
        Quote objQuote;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
        COM_WrapperVinculacionClienteRequest_cls objWrapperVinculacionClienteRequest;
        COM_WrapperVinculacionClienteRespons_cls objWrapperVinculacionClienteResponse;
        COM_WrapperConsultaClienteGCRequest_cls.customerMng_ConsultaCliente_Request reqContenido = new COM_WrapperConsultaClienteGCRequest_cls.customerMng_ConsultaCliente_Request();
        reqContenido.Header                                       = COM_UtilidadWebService_cls.obtenerCabecera(Label.COM_WS_ConsultarClienteGC);
        objWrapperVinculacionClienteResponse = (COM_WrapperVinculacionClienteRespons_cls)COM_UtilidadWebService_cls.consumirWS(objWrapperVinculacionClienteRequest, label.COM_WS_VincularClienteGC, COM_WrapperVinculacionClienteRespons_cls.class, objOpp.Id);
        Test.stopTest();
    }
    @isTest static void PruebaCase2(){
        Account objAcc;
        Opportunity objOpp;
        AccountContactRelation objAccountContactRelation;
        Contact objContact;
        Case objCase;
        list<COM_ConfiguracionEnvioDocsM__mdt> lstConfig;
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        objCase = COM_DataGenerator_cls.crearCaso2(true, objAcc.Id, objContact.id);
        
       // Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, objOpp.Id);
        
        ContentVersion objContentVersionCase = new ContentVersion();
        objContentVersionCase.title='Prueba';
        objContentVersionCase.PathOnClient ='testCrear.pdf';
        Blob b2s=Blob.valueOf('Unit Test Attachment Body1');
        objContentVersionCase.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        insert objContentVersionCase;
        List<ContentDocument> documentsCase = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlinkCase =new ContentDocumentLink();
        contentlinkCase.LinkedEntityId=objCase.id;
        contentlinkCase.ShareType= 'V';
        contentlinkCase.ContentDocumentId=documentsCase[0].Id;
        contentlinkCase.Visibility = 'AllUsers'; 
        insert contentlinkCase; 
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
            lstConfig = [SELECT Id, COM_EnvioEmail__c, COM_EnvioOnBase__c, COM_DiskGroupName__c, COM_DocumentTypeName__c, COM_FileFormat__c 
                         FROM COM_ConfiguracionEnvioDocsM__mdt 
                         WHERE COM_IdentificadorProceso__c = 'APO'];
            
            try{
                COM_CrearDocumentoOnBase_ws.crearDocumentoOnBase(objContentVersionCase.Id, lstConfig[0].Id);
            } catch(Exception e){
                system.debug('ERROR [pruebaCrearDocumentoActasOnBase]: ' + e.getMessage());
            }
        Test.stopTest();
    }
   
    
}