@isTest
private class COM_EncuentroConDirectivos_ctr_tst {
	
	@isTest static void test_method_1() {
		Account acc =  COM_DataGenerator_cls.crearCuenta(true);
		COM_Actas__c acta = COM_DataGenerator_cls.crearActa(true, acc.Id);
		system.debug('Crear el acta '+ acta.id);
		//cuentas
		ApexPages.StandardController controller = new ApexPages.StandardController(acta);
		Apexpages.currentPage().getParameters().put( 'id', acta.id);
		COM_EncuentroConDirectivos_ctr ppp = new COM_EncuentroConDirectivos_ctr(controller);
		System.debug(ppp.strSegmento);
		System.debug(ppp.objActa);
		System.debug(ppp.lstOppotunidades);
		System.debug(ppp.valorTotal);
		System.debug(ppp.ano);
		System.debug(ppp.mes);
		System.debug(ppp.dia);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Alojamiento').getRecordTypeId();
        System.debug('Test_opp: '+ opp);
        //opp.RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Eventos').getRecordTypeId();
        update opp;
		ppp.getOportunidades(acc.Id);
	}




}