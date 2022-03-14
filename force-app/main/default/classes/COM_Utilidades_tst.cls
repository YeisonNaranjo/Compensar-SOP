@isTest
private class COM_Utilidades_tst {

	static RecordType recordID = [select Id from RecordType limit 1];
	static Account acc = COM_DataGenerator_cls.crearCuenta(true);
	static Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
	//AVX PB 25-09-19 Migración Lightning - Se reemplazan Attachments por Content Documents
	//static Attachment att = COM_DataGenerator_cls.creaAdjunto(true, acc.Id);
	static ContentVersion objContentVersion = new ContentVersion();

	
	@isTest static void test_method_1() {
		COM_Utilidades_cls.obtenerFechaActualFormateadaStr(COM_UtilidadConstantes_cls.FORMATO_FECHA_TRANSACTION_ID);
	}
	
	@isTest static void test_method_2() {
		Datetime GMTDate = Datetime.newInstanceGmt(2011,6,1,12,1,5);
		String strConvertedDate = GMTDate.format('MM/dd/yyyy HH:mm:ss', 'America/New_York');
		COM_Utilidades_cls.stringToDatetime(strConvertedDate);
	}

	@isTest static void test_method_3() {
		COM_Utilidades_cls.generarRandom(1);
	}

	@isTest static void test_method_4() {
		Datetime GMTDate1 = Datetime.newInstanceGmt(2011,6,1,12,1,5);
		Datetime GMTDate2 = Datetime.newInstanceGmt(2012,6,1,12,1,5);
		COM_Utilidades_cls.calculateYearsBetweenFechas(GMTDate2, GMTDate1);
	}

	@isTest static void test_method_5() {
		Datetime GMTDate1 = Datetime.newInstanceGmt(2011,6,1,12,1,5);
		Datetime GMTDate2 = Datetime.newInstanceGmt(2012,6,1,12,1,5);
		COM_Utilidades_cls.calculateDaysBetweenFechas(GMTDate2, GMTDate1);
	}

	@isTest static void test_method_6() {
		Datetime fecha = DateTime.newInstanceGMT(2017,08,24,0,0,0);
		Long milisegundos = 60*24*60*60*1000L;
		COM_Utilidades_cls.calcularFechaDiasHabiles('test compensar',fecha, 60);
	}

	@isTest static void test_method_7() {
		BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
		Datetime dtFecha0 = datetime.newInstanceGmt(2017, 9, 28, 0, 0, 0);
		Datetime dtFecha = datetime.newInstanceGmt(dtFecha0.year(),  dtFecha0.month(), dtFecha0.day(),0,0,0);
		Datetime fechaLR = COM_Utilidades_cls.calcularFechaDiasHabiles(horarioOficina.Id, dtFecha, 60);
	}

	@isTest static void test_method_7A() {
		BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
		Datetime dtFecha0 = datetime.newInstanceGmt(2017, 9, 28, 0, 0, 0);
		Datetime dtFecha = datetime.newInstanceGmt(dtFecha0.year(),  dtFecha0.month(), dtFecha0.day(),5,0,0);
		Datetime fechaLR = COM_Utilidades_cls.calcularFechaDiasHabiles(horarioOficina.Id, dtFecha, 60);
	}

	@isTest static void test_method_8() {
		BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
		Datetime dtFecha0 = datetime.newInstanceGmt(2017, 9, 28, 0, 0, 0);
		COM_Utilidades_cls.calcularNumeroDiasHabiles('test compensar', dtFecha0);
	}

	@isTest static void test_method_9() {
		map<Object, Object> pruebamap =  new map<Object, Object>();
		//pruebamap.put('1', 'First entry');
		pruebamap.put('2', 'Second entry');
		map<Object, Object> map2 = new map<Object, Object>();
		map2.put('1', 'que cosas');
		pruebamap.put('1', map2);
		pruebamap.put('2', map2);

		map<Object, Object> map3 = new map<Object, Object>();
		map3.put('1', 'que cosas');
		List<Object> lstString = new List<Object>(); 
		lstString.add('2');
		lstString.add('1');
		lstString.add(map3);

		
		pruebamap.put('4', lstString);
		COM_Utilidades_cls.convertItemToList(pruebamap, '1');
	}

	@isTest static void test_method_10() {

		//AVX PB 25-09-19 Migración Lightning - Se reemplazan Attachments por Content Documents

		objContentVersion.title='Prueba';
		objContentVersion.PathOnClient ='testCrear.pdf';
		objContentVersion.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body URL');
		insert objContentVersion;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.LinkedEntityId=acc.id;
		contentlink.ShareType= 'V';
		contentlink.ContentDocumentId=documents[0].Id;
		contentlink.Visibility = 'AllUsers'; 
		insert contentlink; 


		COM_Utilidades_cls.generarLog(recordID.Id, '', '', '', '', '');
		COM_Utilidades_cls.generarLog(acc.Id, '', '', '', '', '');
		COM_Utilidades_cls.generarLog(documents[0].Id, '', '', '', '', '');
		//COM_Utilidades_cls.generarLog(att.Id, '', '', '', '', '');
		COM_Utilidades_cls.generarLog(opp.Id, '', '', '', '', '');
	}

	@isTest static void test_method_11() {
	//RecordType recordID = [select Id from RecordType limit 1];
	COM_Utilidades_cls.generarLog(recordID.Id, '', '', '', '');
}

@isTest static void test_method_11A() {
	//RecordType recordID = [select Id from RecordType limit 1];
	COM_Utilidades_cls.generarLog(recordID.Id, '', null, '', '');
}

@isTest static void test_method_12() {
	object objRequest = '';
	object objResponse = '';
	COM_Utilidades_cls.generarLog(recordID.Id, '', objRequest, objResponse, '', '');
}

@isTest static void test_method_12A() {
	object objRequest = null;
	object objResponse = null;
	COM_Utilidades_cls.generarLog(recordID.Id, '', objRequest, objResponse, '', '');
}

@isTest static void test_method_13() {

	COM_Utilidades_cls.obtenerMes(1);
	COM_Utilidades_cls.obtenerMes(2);
	COM_Utilidades_cls.obtenerMes(3);
	COM_Utilidades_cls.obtenerMes(4);
	COM_Utilidades_cls.obtenerMes(5);
	COM_Utilidades_cls.obtenerMes(6);
	COM_Utilidades_cls.obtenerMes(7);
	COM_Utilidades_cls.obtenerMes(8);
	COM_Utilidades_cls.obtenerMes(9);
	COM_Utilidades_cls.obtenerMes(10);
	COM_Utilidades_cls.obtenerMes(11);
	COM_Utilidades_cls.obtenerMes(12);
	COM_Utilidades_cls.obtenerMes(13);
 }

@isTest static void test_method_14(){

	Test.startTest();
	List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
    System.debug('--->>PB AVX : BH :'+bhs);
	COM_Utilidades_cls.threadSleep(10);
	Datetime objDT = System.now().addDays(-5);
	if(!bhs.isEmpty())
	COM_Utilidades_cls.calcularNumeroDiasHabilesDecimal(bhs[0].Id, objDT, 3);
	Test.stopTest();
}
    /* Descomentar cuando se haya pasado OPTIN a UAT
@isTest static void test_method_15(){
	Test.startTest();
	Account acc = [Select Name, BillingStreet, AccountNumber FROM Account LIMIT 1];
	COM_Utilidades_cls.compararValorObjetoConMetadata(acc,'Name');
	Test.stopTest();
}*/

@isTest static void test_method_16(){
	List<EmailTemplate> lstETIndependiente = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAIndependiente];
	Set<Id> setIdCandidatos = new Set<Id>();
	Lead lead = COM_DataGenerator_cls.crearCandidato(true);
	setIdCandidatos.add(lead.Id);
	Test.startTest();
	COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdCandidatos,lstETIndependiente.get(0).Id);
	Test.stopTest();
}












}