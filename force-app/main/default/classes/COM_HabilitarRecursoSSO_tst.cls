/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_HabilitarRecursoSSO_WS

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/

@isTest
private class COM_HabilitarRecursoSSO_tst 
{
	public static void createData()
	{
        /*COM_ConfiguracionSSO__c objSettingService = new COM_ConfiguracionSSO__c();
        objSettingService.Name 					  = 'Test';
        objSettingService.COM_AplicacionClienteSSO__c = 'SWPR108';
        objSettingService.COM_AplicacionDestinoSSO__c = 'SWPR108';
        objSettingService.COM_DelegadoDepSSO__c = '0';
        objSettingService.COM_EndPointSSO__c = 'https://esbpruebas.compensar.com/Services/Utility/WSEGURIDADSSO/WS/Implementation/WSEGURIDADSSO.serviceagent/SSOSoapEndpoint?wsdl';
        objSettingService.COM_idAplicacionSSO__c = 'SWEX58';
		objSettingService.COM_NormalizarSSO__c = 'false';
		objSettingService.COM_OrgSSO__c = '8';
		objSettingService.COM_PasswordSSO__c = 'xRCDG74vNQte3pmITOHiHw==-03';
		objSettingService.COM_strTidUsuarioSSO__c = '1';
		objSettingService.COM_UserNameSSO__c = 'I9zjMMsWTrqaiENO0XFw+g==-03';
		objSettingService.COM_ActionSSO__c = '/Services/Utility/WSEGURIDADSSO/WS/Implementation/WSEGURIDADSSO.serviceagent/SSOSoapEndpoint/HabilitarRecurso';
        insert objSettingService;*/
	}

	public static testMethod void test_method_sucess() 
	{
		createData();
		User objUser = [Select COM_IdUsuarioSSO__c FROM User WHERE Id =: UserInfo.getUserId()];
		objUser.COM_IdUsuarioSSO__c = '	51939441';
		update objUser;

		COM_HabilitarRecursoSSOMock_tst clsMock = new COM_HabilitarRecursoSSOMock_tst();
		Test.setMock(HttpCalloutMock.class, clsMock);
		Test.startTest();
			COM_HabilitarRecursoSSO_WS obj = new COM_HabilitarRecursoSSO_WS();
			String strToken = obj.getTokenSSO();
			System.assertEquals(strToken, clsMock.strToken);
		Test.stopTest();
	}

	public static testMethod void test_method_errorUser() 
	{
		createData();
		
		User objUser = [Select COM_IdUsuarioSSO__c FROM User WHERE Id =: UserInfo.getUserId()];
		objUser.COM_IdUsuarioSSO__c = null;
		update objUser;

		Test.setMock(HttpCalloutMock.class, new COM_HabilitarRecursoSSOMock_tst());
		Test.startTest();
			COM_HabilitarRecursoSSO_WS obj = new COM_HabilitarRecursoSSO_WS();
			String strToken = obj.getTokenSSO();
			System.assertEquals(strToken, Label.COM_UsuarioSinIdSSO);
		Test.stopTest();
	}

	public static testMethod void test_method_errorMock() 
	{
		createData();
		COM_HabilitarRecursoSSOErrorMock_tst clsMockError =new COM_HabilitarRecursoSSOErrorMock_tst();
		Test.setMock(HttpCalloutMock.class, clsMockError);
		Test.startTest();
			COM_HabilitarRecursoSSO_WS obj = new COM_HabilitarRecursoSSO_WS();
			String strToken = obj.getTokenSSO();
			//System.assertEquals(strToken, clsMockError.strError);
		Test.stopTest();
	}
}