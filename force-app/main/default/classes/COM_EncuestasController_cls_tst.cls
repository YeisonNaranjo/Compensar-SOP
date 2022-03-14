@isTest
private class COM_EncuestasController_cls_tst {
	//AVX PB 16-09-2019 - Se agrega método para componente lightning
	@TestSetup
	static void cargarData(){
		Account objAccount = COM_DataGenerator_cls.crearCuenta(true);
        Contact objContact = COM_DataGenerator_cls.crearContacto(false, objAccount.Id);
		objContact.email = 'test@test.com';
		insert objContact;
		AVX_ENC_PlantillaEncuesta__c plt =  COM_DataGenerator_cls.generarPlantillaAlone(true);
		AVX_ENC_PreguntaEncuesta__c prg1 = COM_DataGenerator_cls.preguntaEncuesta(true, plt.Id);
		AVX_ENC_PreguntaEncuesta__c prg2 = COM_DataGenerator_cls.preguntaEncuesta(true, plt.Id);
		plt.Activo__c = true;
		update plt;
		Id rtSinContestar = Schema.SObjectType.AVX_ENC_Encuesta__c.getRecordTypeInfosByDeveloperName().get('Sin_contestar').getRecordTypeId();
		AVX_ENC_Encuesta__c enc = COM_DataGenerator_cls.generarEncuesta(false, plt.id);
		enc.COM_Contacto__c = objContact.Id;
		enc.COM_Cliente__c = objAccount.Id;
		enc.RecordTypeId = rtSinContestar;
		insert enc;
	}

	@isTest static void test_method_two() {
		
		List<AVX_ENC_Encuesta__c> lstEncuestas = [SELECT Id,Plantilla_encuesta__c, Name,COM_Contacto__c FROM AVX_ENC_Encuesta__c LIMIT 1];
		Contact objContact = new Contact(Id = lstEncuestas[0].COM_Contacto__c);
		String strNomEncuesta = lstEncuestas[0].Name;
		Test.startTest();
        	ApexPages.StandardController controller = new ApexPages.StandardController(lstEncuestas[0]);
			COM_EncuestasController_cls objController = new COM_EncuestasController_cls(controller);
			objController.procesarEncuestaPagina();
			objContact.email = '';
			update objContact;
			objController.procesarEncuestaPagina();
			delete lstEncuestas;
			objController.procesarEncuestaPagina();
			
		Test.stopTest();
	}
	//AVX PB 16-09-2019 - Se agrega método para componente lightning
	@isTest static void validarEncuesta(){
		
		List<AVX_ENC_Encuesta__c> lstEncuestas = [SELECT Id,Name, RecordTypeId,COM_Contacto__c FROM AVX_ENC_Encuesta__c LIMIT 1];
		Contact objContact = new Contact(Id = lstEncuestas[0].COM_Contacto__c);
		Test.startTest();
			COM_EncuestasController_cls enCtrl = new COM_EncuestasController_cls();
			COM_EncuestasController_cls.validarEncuesta(lstEncuestas[0].Name);
			objContact.email = '';
			update objContact;
			COM_EncuestasController_cls.validarEncuesta(lstEncuestas[0].Name);
			lstEncuestas[0].RecordTypeId = Schema.SObjectType.AVX_ENC_Encuesta__c.getRecordTypeInfosByDeveloperName().get('Contestada').getRecordTypeId();
			update lstEncuestas;
			COM_EncuestasController_cls.validarEncuesta(lstEncuestas[0].Name);
			delete lstEncuestas;
			COM_EncuestasController_cls.validarEncuesta(lstEncuestas[0].Name);
		Test.stopTest();
	
	}
	
}