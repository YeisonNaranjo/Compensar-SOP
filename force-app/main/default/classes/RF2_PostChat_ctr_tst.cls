@isTest
private class RF2_PostChat_ctr_tst {
	
	private static void createData(Id idCuenta){
	 	List<RF2_ConfAudCasos__mdt> ojbLst = [SELECT DeveloperName,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c FROM RF2_ConfAudCasos__mdt];
	 		
	 	RF2_ContAudCasos__c conf = new RF2_ContAudCasos__c();
	 	conf.Name = '1';
	 	conf.RF2_ConEnvioCasoCalidadGIE__c = ojbLst.get(0).RF2_RecEnvioCalidadGIE__c;
	 	conf.RF2_ConEnvioCasoCalidadPCE__c = ojbLst.get(0).RF2_RecEnvioCalidadPCE__c;
	 	conf.RF2_ConEnvioSondeoPCE__c = ojbLst.get(0).RF2_RecEnvioSondeoPCE__c;
	 	insert conf;

	 	Entitlement ent = new Entitlement();
	 	ent.AccountId = idCuenta;
	 	ent.Name = Label.RF2_NombreANSGenerico_lbl;
	 	ent.RF2_Canal__c = 'Call Center';
	 	ent.Rf2_GCN__c = 'Otros';
	 	ent.RF2_ObligatorioCalidad__c = false;
	 	insert ent;
	 }
	
	@isTest static void test_method_one() {
		//Case caso = COM_DataGenerator_cls.crearCaso(true, null, null);
		COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		createData(acc.Id);
		//Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de Aportes', 'Aportes', 'Pagina Web', true);
		Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', true);
		ApexPages.currentPage().getParameters().put('attachedRecords', '{"CaseId":"'+ caso.Id +'", "ContactId":""}');
		ApexPages.currentPage().getParameters().put('chatKey', 'XXXXXX');
		LiveChatVisitor lcv = COM_DataGenerator_cls.crearLiveChatVisitor(true);
		LiveChatTranscript lct = COM_DataGenerator_cls.crearTranscripcion(true, caso.Id, lcv.Id);
		RF2_PostChat_ctr ppp = new RF2_PostChat_ctr();

		RF2_PostChat_ctr.finalizar('', '', '', '', caso.Id, 'XXXXXX'); 
	}
	
	
}