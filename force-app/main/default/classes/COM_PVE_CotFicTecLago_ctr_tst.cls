@isTest
private class COM_PVE_CotFicTecLago_ctr_tst {
	
	@isTest static void test_method_one() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		Opportunity opp =  COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		AccountContactRelation acr = COM_DataGenerator_cls.crearContRelation(true, acc.Id, con.Id);
		COM_Operador__c op = COM_DataGenerator_cls.crearOperador(true);
		opp.COM_Operador__c = op.Id;
		update opp;

		ApexPages.currentPage().getParameters().put('IdCustomObject', opp.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(opp); 	
		COM_PVE_CotizacionFichaTecnicaLago_ctr ppp = new COM_PVE_CotizacionFichaTecnicaLago_ctr(sc);
		System.debug(ppp.strBody);
		System.debug(ppp.condReservaciones);
		System.debug(ppp.condPagoAnticipado);
		System.debug(ppp.condCancelacion);
		System.debug(ppp.condAplazamientos);
		System.debug(ppp.condServicio);
		System.debug(ppp.condAceptacion);
		System.debug(ppp.lstColumnas);
		System.debug(ppp.accCliente);
		System.debug(ppp.conContacto);
		System.debug(ppp.oppOportunidad);
		System.debug(ppp.pliProductos);
		System.debug(ppp.strOperador);
		System.debug(ppp.strServicios);
		System.debug(ppp.strAlojamiento);
		System.debug(ppp.cfoFacturacion);
		System.debug(ppp.mapAlojamiento);
		System.debug(ppp.mapAlojamientoValor);
		System.debug(ppp.lstServicios);
		System.debug(ppp.lstEventoActividad);
		System.debug(ppp.decSubTotalServicio);
		System.debug(ppp.decSubTotalEventoActividad);
		System.debug(ppp.decTotalEvento);
	}
	
	@isTest static void test_method_two() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		Opportunity opp =  COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		COM_Operador__c op = COM_DataGenerator_cls.crearOperador(true);
		opp.COM_Operador__c = op.Id;
		update opp;

		ApexPages.currentPage().getParameters().put('IdCustomObject', opp.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(opp); 	
		COM_PVE_CotizacionFichaTecnicaLago_ctr ppp = new COM_PVE_CotizacionFichaTecnicaLago_ctr(sc);

	}
	
}