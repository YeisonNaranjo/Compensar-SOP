@isTest (SeeAllData=true)
private class ENC_Utils_tst
{
	static testMethod void addMessage_tst()
	{
		Test.startTest();
			ENC_Utils_cls.addMessage( ApexPages.Severity.FATAL, '');
		Test.stopTest();
	}
	static testMethod void getSchemaFieldSetByObjectName_1_tst()
	{
		Test.startTest();
			ENC_Utils_cls.blCatch = true;
			ENC_Utils_cls.getSchemaFieldSetByObjectName('Account', 'Name');
		Test.stopTest();
	}
	static testMethod void getSchemaFieldSetByObjectName_2_tst()
	{
		Test.startTest();
			ENC_Utils_cls.getSchemaFieldSetByObjectName('Account', 'Name');
		Test.stopTest();
	}
	static testMethod void getFieldSetByObjectName_1_tst()
	{
		Test.startTest();
			ENC_Utils_cls.blCatch = true;
			ENC_Utils_cls.getFieldSetByObjectName( 'Account', 'Name' );
		Test.stopTest();
	}
	static testMethod void idIsOfSObj_1_tst()
	{
		Test.startTest();
			ENC_Utils_cls.idIsOfSObj( 'Account', null );
		Test.stopTest();
	}

	static testMethod void getFieldSetByObjectName_tst()
	{
		Test.startTest();
			ENC_Utils_cls.getFieldSetByObjectName('Account', 'DetalleCaso');
		Test.stopTest();
	}
	
	static testMethod void getPicklistValuesTst()
	{ 
		Test.startTest();
			ENC_Utils_cls.getPicklistValues( new Contact(), 'CleanStatus', true );
			ENC_Utils_cls.getPicklistValuesOption( new Contact(), 'CleanStatus', true );
		Test.stopTest();
	}

	static testMethod void createListWhereTst()
	{ 
		set<String> whered = new set<String>();
		whered.add('a = b');
		whered.add('1 = 2');
		Test.startTest();
			ENC_Utils_cls.createListWhere(whered);
			
		Test.stopTest();
	}


	static testMethod void consultarClienteTst()
	{ 
		
		

		Test.startTest();
			Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
			Contact contacto = COM_DataGenerator_cls.crearContacto(true, cuenta.Id);
			Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, cuenta.Id);
			AVX_ENC_Encuesta__c encuesta = new AVX_ENC_Encuesta__c();
			encuesta.COM_Cliente__c = cuenta.Id;
			encuesta.COM_Contacto__c = contacto.Id;
			encuesta.COM_Oportunidad__c = opp.Id;

			AVX_ENC_PlantillaEncuesta__c plantilla = COM_DataGenerator_cls.generarPlantilla(true);
			encuesta.Plantilla_encuesta__c = plantilla.Id;
			insert encuesta;
		 	List<AVX_ENC_Encuesta__c> lstEncuestas = new List<AVX_ENC_Encuesta__c>();
		 	lstEncuestas.add(encuesta);
			ENC_Utils_cls.consultarCliente(lstEncuestas);
			
		Test.stopTest();
	}
}