/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_ConsultarDocOnBase_ctr
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    29/09/2017      William Aldana                      Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_ConsultarDocOnBase_tst {
	public COM_ConsultarDocOnBase_tst() {
		
	}

	private static Account crearCuenta(){
		COM_AccountContactRelation_cls.stopTrigger();
		Account arl = new Account();
		arl.Name ='Prueba';
		arl.COM_TipoIdentificacion__c = '2';
		arl.COM_Numero_de_identificacion__c = '123456789';
		insert arl;
		COM_AccountContactRelation_cls.startTrigger();
		return arl;
	}

	private static Account crearCuentaAnonimo(){
		COM_AccountContactRelation_cls.stopTrigger();
		Account arl = new Account();
		arl.Name ='Prueba';
		arl.COM_TipoIdentificacion__c = '2';
		arl.COM_Numero_de_identificacion__c = '9999';
		insert arl;
		COM_AccountContactRelation_cls.startTrigger();
		return arl;
	}

	@isTest static void pruebaConsultarDocOnBase(){
		Account account = crearCuenta();
		Test.startTest();
		//Account account = new Account();
		//account.Id = 'asd';
        //account.COM_TipoIdentificacion__c = '2';
        //account.COM_Numero_de_identificacion__c = '123456789';
        ApexPages.StandardController controller = new ApexPages.StandardController(account);
		COM_ConsultarDocOnBase_ctr app = new COM_ConsultarDocOnBase_ctr(controller);
		app.strTipoDoc = '';
		app.strNumDoc  = '';
		app.strDocBase64  = '';
		app.strItem  = '';
		app.CompId  = '';
		app.Id  = '';
		Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
		list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
		lstLogs.add(COM_Utilidades_cls.generarLog(account.Id, 'xxx', 'xxxx', 'xxxxx', label.COM_WS_ConsultarBiarioDocumentoOnBase, 'xxxxxxx'));
		Cache.Org.put('local.partition1.logs', lstLogs);
		app.getDocumentos();
		Cache.Org.put('local.partition1.logs', lstLogs);
		app.descargar();
		 
		Test.stopTest();
	}
	
	@isTest static void pruebaConsultarDocOnBaseError(){
		Account account = crearCuenta();
		Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(account);
		COM_ConsultarDocOnBase_ctr app = new COM_ConsultarDocOnBase_ctr(controller);
		app.strTipoDoc = '2';
		app.strNumDoc  = '123456789';
		app.strDocBase64  = '';
		app.strItem  = '';
		app.CompId  = '';
		app.Id  = '';
		Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
		list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
		lstLogs.add(COM_Utilidades_cls.generarLog(account.Id, 'xxx', 'xxxx', 'xxxxx', label.COM_WS_ConsultarBiarioDocumentoOnBase, 'xxxxxxx'));
		Cache.Org.put('local.partition1.logs', lstLogs);
		insert lstLogs;
		app.getDocumentos();
		Cache.Org.put('local.partition1.logs', lstLogs);
		Test.stopTest();
	}


	@isTest static void pruebaConsultarDocOnBase2(){
		//crearDatos();
		Test.startTest();
		Account account = new Account();
        account.COM_TipoIdentificacion__c = '';
        account.COM_Numero_de_identificacion__c = '';
        Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
        ApexPages.StandardController controller = new ApexPages.StandardController(account);
		COM_ConsultarDocOnBase_ctr app = new COM_ConsultarDocOnBase_ctr(controller);
	 	app.getDocumentos();
		Test.stopTest();
	}

	@isTest static void pruebaDocumento(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
		COM_ConsultarDocOnBase_ctr.Documento doc = new COM_ConsultarDocOnBase_ctr.Documento();
		doc.strNomDoc = '';
		doc.strTipoDoc = '';
		doc.strNombreArch = '';
		doc.strDocumentoId = '';
		Test.stopTest();
	}

	@isTest static void pruebaDocumento2(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
		COM_ConsultarDocOnBase_ctr.Documento doc = new COM_ConsultarDocOnBase_ctr.Documento('', '', '', '');
		Test.stopTest();
	}

	@isTest static void pruebaDocumento3(){
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
		COM_ConsultarDocOnBase_ctr.Documento doc = new COM_ConsultarDocOnBase_ctr.Documento('', '', '', '', '');
		Test.stopTest();
	}
	
	@isTest static void pruebaDescargarDocumento(){
		Account account = crearCuenta();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
		ApexPages.StandardController controller = new ApexPages.StandardController(account);
		COM_ConsultarDocOnBase_ctr app = new COM_ConsultarDocOnBase_ctr(controller);
		app.Id = '87218442';
		list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
		lstLogs.add(COM_Utilidades_cls.generarLog(account.Id, 'xxx', 'xxxx', 'xxxxx', label.COM_WS_ConsultarBiarioDocumentoOnBase, 'xxxxxxx'));
		Cache.Org.put('local.partition1.logs', lstLogs);
		app.descargar();
		Cache.Org.put('local.partition1.logs', lstLogs);
		Test.stopTest();
	}
}