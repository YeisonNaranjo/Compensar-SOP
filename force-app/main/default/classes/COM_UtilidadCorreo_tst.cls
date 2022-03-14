/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_Georeferenciacion_ws
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    31/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_UtilidadCorreo_tst {
	
	@isTest static void enviarCorreo(){
		
		//EmailTemplate objEmailTemplate = COM_DataGenerator_cls.crearEmailTemplate(true);
		Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
		//Attachment objAtt = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);

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


		Contact objContact = COM_DataGenerator_cls.crearContacto(true, objCuenta.Id);
		String templateToTest = 'CotizacionPasadiaLagoSol';
		
		Test.startTest();
			set<String> setCorreos = new set<String>();
			set<Id> setIdAdjuntos = new set<Id>();
			
			//setCorreos.add('juriberuiz@gmail.com');
			//setCorreos.add('lauris856.lfe@gmail.com');
			//setCorreos.add('juriberuiz@yahoo.es');
			setCorreos.add('pbohorquez@avanxo.com');
			setCorreos.add('paula.bohorquez@globant.com');
			
			setIdAdjuntos.add(objContentVersion.Id);
			
			
			COM_UtilidadCorreo_cls.enviarCorreoSimple(setCorreos, setIdAdjuntos, 'Asunto Correo', 'Cuerpo del Correo');
			//list<EmailTemplate> lstEmailTemplate = [SELECT Id, DeveloperName FROM EmailTemplate];
			//System.debug('Templates Encontradas '+lstEmailTemplate.Size());
			//System.debug('Nombre Plantilla ' +  lstEmailTemplate.get(1).DeveloperName);
			//if(lstEmailTemplate != null && !lstEmailTemplate.isEmpty()){
			//	COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, setIdAdjuntos, lstEmailTemplate.get(1).DeveloperName, objContact.Id, objCuenta.Id);
			//} else{
			//	system.debug('================ NO ENCOTRO EMAIL TEMPLATE');
			//} 
			
			COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, setIdAdjuntos, templateToTest, objContact.Id, objCuenta.Id);
		Test.stopTest();
	}

	@isTest static void enviarCorreo2(){
		
		//EmailTemplate objEmailTemplate = COM_DataGenerator_cls.crearEmailTemplate(true);
		Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
		//Attachment objAtt = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);
		
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

		
		Contact objContact = COM_DataGenerator_cls.crearContacto(true, objCuenta.Id);
		String templateToTest = 'CotizacionPasadiaLagoSol';

		
		Test.startTest();
			set<String> setCorreos = new set<String>();
			set<Id> setIdAdjuntos = new set<Id>();
			
			/*setCorreos.add('juriberuiz@gmail.com');
			setCorreos.add('lauris856.lfe@gmail.com');
			setCorreos.add('juriberuiz@yahoo.es');*/
			setCorreos.add('pbohorquez@avanxo.com');
			setCorreos.add('paula.bohorquez@globant.com');
			

			setIdAdjuntos.add(objContentVersion.Id);
			
			
			COM_UtilidadCorreo_cls.enviarCorreoSimple(setCorreos, setIdAdjuntos, 'Asunto Correo', 'Cuerpo del Correo');
			//list<EmailTemplate> lstEmailTemplate = [SELECT Id, DeveloperName FROM EmailTemplate];
			//System.debug('Templates Encontradas '+lstEmailTemplate.Size());
			//System.debug('Nombre Plantilla ' +  lstEmailTemplate.get(1).DeveloperName);
			//if(lstEmailTemplate != null && !lstEmailTemplate.isEmpty()){
			//	COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, setIdAdjuntos, lstEmailTemplate.get(1).DeveloperName, objContact.Id, objCuenta.Id);
			//} else{
			//	system.debug('================ NO ENCOTRO EMAIL TEMPLATE');
			//} 

			/*
			list<Attachment> attLst = new list<Attachment>();
			attLst.add(objContentVersion);
			COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, attLst, templateToTest, objContact.Id, objCuenta.Id);*/
			
			
			list<ContentVersion> attLst = new list<ContentVersion>();
			attLst.add(objContentVersion);
			COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, attLst, templateToTest, objContact.Id, objCuenta.Id);

		Test.stopTest();
	}
    
	@isTest static void enviarCorreo3(){
		
		//EmailTemplate objEmailTemplate = COM_DataGenerator_cls.crearEmailTemplate(true);
		Account objCuenta = COM_DataGenerator_cls.crearCuenta(true);
		//Attachment objAtt = COM_DataGenerator_cls.creaAdjunto(true, objCuenta.Id);

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

		Contact objContact = COM_DataGenerator_cls.crearContacto(true, objCuenta.Id);
		String templateToTest = 'CotizacionPasadiaLagoSol';
		
		Test.startTest();
			set<String> setCorreos = new set<String>();
			set<Id> setIdAdjuntos = new set<Id>();
			/*
			setCorreos.add('juriberuiz@gmail.com');
			setCorreos.add('lauris856.lfe@gmail.com');
			setCorreos.add('juriberuiz@yahoo.es');*/
			setCorreos.add('pbohorquez@avanxo.com');
			setCorreos.add('paula.bohorquez@globant.com');
			
			setIdAdjuntos.add(objContentVersion.Id);
			
			
			COM_UtilidadCorreo_cls.enviarCorreoSimple(setCorreos, setIdAdjuntos, 'Asunto Correo', 'Cuerpo del Correo');
			//list<EmailTemplate> lstEmailTemplate = [SELECT Id, DeveloperName FROM EmailTemplate];
			//System.debug('Templates Encontradas '+lstEmailTemplate.Size());
			//System.debug('Nombre Plantilla ' +  lstEmailTemplate.get(1).DeveloperName);
			//if(lstEmailTemplate != null && !lstEmailTemplate.isEmpty()){
			//	COM_UtilidadCorreo_cls.enviarCorreoTemplate(setCorreos, setIdAdjuntos, lstEmailTemplate.get(1).DeveloperName, objContact.Id, objCuenta.Id);
			//} else{
			//	system.debug('================ NO ENCOTRO EMAIL TEMPLATE');
			//} 
			/*list<Attachment> attLst = new list<Attachment>();
			attLst.add(objAtt);*/
			list<ContentVersion> attLst = new list<ContentVersion>();
			attLst.add(objContentVersion);
			List<COM_UtilidadCorreo_cls.CorreoSimple> csList = new List<COM_UtilidadCorreo_cls.CorreoSimple>();
			csList.add(new COM_UtilidadCorreo_cls.CorreoSimple(setCorreos, attLst, 'Correo de Prueba', 'Esto es una prueba', null, objCuenta.Id, objContact.Id));
			COM_UtilidadCorreo_cls.enviarListCorreo(csList);
			
		Test.stopTest();
	}

}