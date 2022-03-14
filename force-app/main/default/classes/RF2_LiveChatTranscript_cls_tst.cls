@isTest
private class RF2_LiveChatTranscript_cls_tst {
	
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
		/*Case case1 = COM_DataGenerator_cls.crearCaso(true, null, null);
		Case case2 = COM_DataGenerator_cls.crearCaso(true, null, null);*/
		
		COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		createData(acc.Id);
		//Case case1 =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de Aportes', 'Aportes', 'Pagina Web', true);
		//Case case2 =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de Aportes', 'Aportes', 'Pagina Web', true);
		Case case1 =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', true);
		Case case2 =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', true);        
		LiveChatVisitor lcv1 = COM_DataGenerator_cls.crearLiveChatVisitor(true);
		LiveChatVisitor lcv2 = COM_DataGenerator_cls.crearLiveChatVisitor(true);

		RF2_EncuestasCasos__c enc1 =  COM_DataGenerator_cls.crearEncuestaCaso(true, case1.Id);
		RF2_EncuestasCasos__c enc2 =  COM_DataGenerator_cls.crearEncuestaCaso(true, case2.Id);
		
		LiveChatTranscript lct1 = COM_DataGenerator_cls.crearTranscripcion(true, case1.Id, lcv1.Id);
		LiveChatTranscript lct2 = COM_DataGenerator_cls.crearTranscripcion(true, case2.Id, lcv2.Id);
		
		list<LiveChatTranscript> lstLCT = new list<LiveChatTranscript>();
		lstLCT.add(lct1);
		lstLCT.add(lct2);

		RF2_LiveChatTranscript_cls pp = new RF2_LiveChatTranscript_cls();
		pp.procesarTranscripcionAfterInsert(lstLCT);
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}