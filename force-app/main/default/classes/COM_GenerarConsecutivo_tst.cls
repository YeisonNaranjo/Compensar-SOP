/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_GenerarConsecutivo_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/

@isTest
private class COM_GenerarConsecutivo_tst 
{
	public static void createData()
	{
        COM_ConfiguracionConsecutivos__c objConf    = new COM_ConfiguracionConsecutivos__c();
        objConf.Name                                = 'Test';
        objConf.COM_Formato__c                      = 'TST-####-ddmmAAAA';
        objConf.COM_IdentificadorProceso__c         = 'TST';
        insert objConf;

        objConf    = new COM_ConfiguracionConsecutivos__c();
        objConf.Name                                = 'Test2';
        objConf.COM_Formato__c                      = 'TST2-###-mmAA';
        objConf.COM_IdentificadorProceso__c         = 'TST2';
        insert objConf;
	}

	public static testMethod void test_method_sucess() 
	{
		createData();
		Test.startTest();
			String strFormat = COM_GenerarConsecutivo_cls.GenerarConsecutivo('TST');
			System.assertEquals(strFormat,'TST-0001-'+Datetime.now().format('ddMMyyyy'));

			strFormat = COM_GenerarConsecutivo_cls.GenerarConsecutivo('TST');
			System.assertEquals(strFormat,'TST-0002-'+Datetime.now().format('ddMMyyyy'));

			strFormat = COM_GenerarConsecutivo_cls.GenerarConsecutivo('TST');
			System.assertEquals(strFormat,'TST-0003-'+Datetime.now().format('ddMMyyyy'));

			strFormat = COM_GenerarConsecutivo_cls.GenerarConsecutivo('TST2');
			System.assertEquals(strFormat,'TST2-001-'+Datetime.now().format('MMyy'));
		Test.stopTest();
	}

	public static testMethod void test_method_Errors() 
	{
		createData();
		Test.startTest();
			String strFormat = COM_GenerarConsecutivo_cls.GenerarConsecutivo(null);
			System.assertEquals(strFormat,Label.COM_SinIdentificadorProceso);

			strFormat = COM_GenerarConsecutivo_cls.GenerarConsecutivo('Prueba');
			System.assertEquals(strFormat,Label.COM_NoEncontroConfiguracion);
		Test.stopTest();
	}
}