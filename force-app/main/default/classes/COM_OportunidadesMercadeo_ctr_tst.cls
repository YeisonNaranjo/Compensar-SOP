@isTest
private class COM_OportunidadesMercadeo_ctr_tst {
	
	@isTest static void test_method_one() {
		COM_OportunidadesMercadeo_ctr ppp = new COM_OportunidadesMercadeo_ctr();
		ppp.operadorLike('LIKE');
		ppp.operadorLike('');
		ppp.castDato('Name');
		ppp.castDato('COM_FechaAfiliacion__c');
		
		ppp.adicionarFiltro();
		ppp.getTipoRegistroOpp();
		ppp.seleccion = new Map<Id, Boolean>();
		Account acc1 = COM_DataGenerator_cls.crearCuenta(true);
		acc1.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.COM_LabelPersonaNatural).getRecordTypeId();
		update acc1;
		Contact cont =  COM_DataGenerator_cls.crearContacto(true, acc1.Id);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, acc1.Id);
		AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, acc1.Id, cont.Id);
		ppp.seleccion.put(rel.Id, true);
		ppp.tipoRegistro = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Alojamiento').getRecordTypeId();
        //ppp.tipoRegistro= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Eventos').getRecordTypeId();
		ppp.nombreOportunidad=' ';
		ppp.crearOportunidades();
		ppp.toggleSeleccionar();
		ppp.filtrarClientes();
		System.debug(ppp.cantidadRegistros); 
		System.debug(ppp.lstCampos); 
		System.debug(ppp.lstOperadores); 
		System.debug(ppp.lstValores); 

	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}