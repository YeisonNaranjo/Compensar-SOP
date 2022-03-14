@isTest 
private class RF2_EnviarDocumentosOnBase_tst{
    
    @testSetup static void dataInit(){
        Account acc = COM_DataGenerator_cls.crearCuenta2(true);
        List<Case> lstCase= new List<Case>();        
        //for(Integer i=0 ;i<10;i++){
            Case cas = new Case();
            cas.RF2_EnviarOnBase__c = true;
            cas.Status = Label.RF2_EstadoCasoAbierto;
            cas.Origin = Label.RF2_OrigenCasoOnBase_lbl;
            cas.RF2_SolucionadoPrimerContacto__c = true;
            cas.Subject = '0xxxxxxxxxxx';
            cas.RF2_TipoCierre__c = 'Exitoso';
            cas.RF2_NombreContactoHuerfano__c = 'h';
            cas.AccountId = acc.Id;
            lstCase.add(cas);
        //}        
        insert lstCase;
        Blob blbBody=Blob.valueOf('adjunto');
        //AVX PB Migración Lightning : Se reemplazan Attachments por Content Documents
        List<ContentVersion> lstCV = new List<ContentVersion>();
        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.title='Prueba';
        objContentVersion.PathOnClient ='testCrear.pdf';
        objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
        //insert objContentVersion;
        lstCV.add(objContentVersion);
        ContentVersion objContentVersion2 = new ContentVersion();
        objContentVersion2.title='Prueba2';
        objContentVersion2.PathOnClient ='testCrear2.pdf';
        objContentVersion2.versiondata=EncodingUtil.base64Decode('Unit Test2 Attachment Body URL');
        lstCV.add(objContentVersion2);
        insert lstCV;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>();
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=lstCase[0].id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=documents[0].Id;
        contentlink.Visibility = 'AllUsers'; 
        lstCDL.add(contentLink);
        ContentDocumentLink contentlink2=new ContentDocumentLink();
        contentlink2.LinkedEntityId=lstCase[0].id;
        contentlink2.ShareType= 'V';
        contentlink2.ContentDocumentId=documents[1].Id;
        contentlink2.Visibility = 'AllUsers'; 
        lstCDL.add(contentLink2);        
        insert lstCDL; 

    }
    static testMethod void test_method_1(){
        String responseOK = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><SOAP-ENV:Body><ns0:WsDocServ_ExecuteOnBase_Rs xmlns:ns0="http://www.compensar.com/Common/WS/DocumentServices/ExecuteOnBase/OUT/v1.0"><ns1:Header xmlns:ns1="http://www.compensar.com.co/webservices/commons/WsResponseHeader"><ns1:System_x><ns1:RequestDate>2017-11-21T12:23:26.749-05:00</ns1:RequestDate><ns1:ResponseDate>2017-11-21T12:23:28.871-05:00</ns1:ResponseDate><ns1:SystemInvokedService>CRM</ns1:SystemInvokedService><ns1:TransactionID>12620171121122325349</ns1:TransactionID></ns1:System_x></ns1:Header><ns1:OnBaseServ_Execute_Rs xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.compensar.com.co/Commons/framework/BusMessage/v1.0" xmlns:ns1="http://www.compensar.com/OnBaseServices/Execute/Response/v1.0"><ns1:ExecuteResponse><ns1:ExecuteResult><xml><Response><Code>00</Code><Description></Description><Result><DocumentHandle>87223777</DocumentHandle></Result></Response></xml></ns1:ExecuteResult></ns1:ExecuteResponse></ns1:OnBaseServ_Execute_Rs></ns0:WsDocServ_ExecuteOnBase_Rs></SOAP-ENV:Body></SOAP-ENV:Envelope>';
               
        Test.startTest();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            RF2_EnviarDocumentosOnBase_bch bch = new RF2_EnviarDocumentosOnBase_bch();
            DataBase.executeBatch(bch); 
        
        Test.stopTest();
    }
    
    @isTest static void test_method_2(){
        String responseOK = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><SOAP-ENV:Body><ns0:WsDocServ_ExecuteOnBase_Rs xmlns:ns0="http://www.compensar.com/Common/WS/DocumentServices/ExecuteOnBase/OUT/v1.0"><ns1:Header xmlns:ns1="http://www.compensar.com.co/webservices/commons/WsResponseHeader"><ns1:System_x><ns1:RequestDate>2017-11-21T12:23:26.749-05:00</ns1:RequestDate><ns1:ResponseDate>2017-11-21T12:23:28.871-05:00</ns1:ResponseDate><ns1:SystemInvokedService>CRM</ns1:SystemInvokedService><ns1:TransactionID>12620171121122325349</ns1:TransactionID></ns1:System_x></ns1:Header><ns1:OnBaseServ_Execute_Rs xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.compensar.com.co/Commons/framework/BusMessage/v1.0" xmlns:ns1="http://www.compensar.com/OnBaseServices/Execute/Response/v1.0"><ns1:ExecuteResponse><ns1:ExecuteResult><xml><Response><Code>00</Code><Description></Description><Result><DocumentHandle>87223777</DocumentHandle></Result></Response></xml></ns1:ExecuteResult></ns1:ExecuteResponse></ns1:OnBaseServ_Execute_Rs></ns0:WsDocServ_ExecuteOnBase_Rs></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        List<Case> lstCase = [SELECT Id,RF2_NumeroRadicadoExterno__c FROM Case WHERE Subject = '0xxxxxxxxxxx'];       
        
        Test.startTest();
            COM_CalloutGenericRestMock_tst tstMock = new COM_CalloutGenericRestMock_tst(responseOK, 200, 'OK');
            Test.setMock(HttpCalloutMock.class, tstMock);
            lstCase[0].RF2_NumeroRadicadoExterno__c = 'AF20198298';
            update lstCase[0];
            RF2_EnviarDocumentosOnBase_bch bch2 = new RF2_EnviarDocumentosOnBase_bch();
            DataBase.executeBatch(bch2); 
        Test.stopTest();
        
    }

    @isTest static void test_method_3(){
        Test.startTest();
            List<ContentDocument> lstCD = [SELECT Id FROM ContentDocument];
            delete lstCD;
            RF2_EnviarDocumentosOnBase_sch sch = new RF2_EnviarDocumentosOnBase_sch();
            sch.execute(null);
        Test.stopTest();
    }

}