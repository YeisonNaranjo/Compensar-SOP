@isTest
private class DescargarMultiplesArchivos_tst {

	@isTest static void test_method_1() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Case cas = COM_Datagenerator_cls.crearCasoAnonimo(true, acc.id);
		//Attachment objAttachment = COM_DataGenerator_cls.creaAdjunto(true, acc.Id);
        //Attachment objAttachment2 = COM_DataGenerator_cls.creaAdjunto(true, cas.Id);
		//AVX PB 25-09-2019 Se reemplazan Attachments por ContentDocuments

		ContentVersion objContentVersion = new ContentVersion();
		objContentVersion.title='Prueba';
		objContentVersion.PathOnClient ='testCrear.pdf';
		Blob b1=Blob.valueOf('Unit Test Attachment Body1');
		objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
		insert objContentVersion;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>();
		ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.LinkedEntityId=acc.id;
		contentlink.ShareType= 'V';
		contentlink.ContentDocumentId=documents[0].Id;
		contentlink.Visibility = 'AllUsers'; 
		lstCDL.add(contentlink);
		ContentDocumentLink contentlink2=new ContentDocumentLink();
		contentlink2.LinkedEntityId=cas.id;
		contentlink2.ShareType= 'V';
		contentlink2.ContentDocumentId=documents[0].Id;
		contentlink2.Visibility = 'AllUsers';
		lstCDL.add(contentlink2);
		insert lstCDL; 

        
		Test.startTest();
			ApexPages.currentPage().getParameters().put('Id', acc.Id); 
			DescargarMultiplesArchivos_ctr clase = new DescargarMultiplesArchivos_ctr();
            clase.getAttachments();
			DescargarMultiplesArchivos_ctr.getAttachments2(cas.Id);
			DescargarMultiplesArchivos_ctr.getBodyBase64(objContentVersion.Id);
		Test.stopTest();
	}
    //AVX PB 16-09-2019 Se agrega el método en el controlador para el componente lightning
    @isTest static void getURL_tst() {
        
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Case cas = COM_Datagenerator_cls.crearCasoAnonimo(true, acc.id);
		
		Test.startTest();
		DescargarMultiplesArchivos_ctr.getURL(cas.Id);
		ContentVersion objContentVersion = new ContentVersion();
		objContentVersion.title='Prueba';
		objContentVersion.PathOnClient ='testCrearHSE';
		Blob b1=Blob.valueOf('Unit Test Attachment Body1');
		objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
		insert objContentVersion;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.LinkedEntityId=cas.id;
		contentlink.ShareType= 'V';
		contentlink.ContentDocumentId=documents[0].Id;
		contentlink.Visibility = 'AllUsers'; 
		insert contentlink; 
		DescargarMultiplesArchivos_ctr.getURL(cas.Id);
		Test.stopTest();
        
    }
    
    
    
}