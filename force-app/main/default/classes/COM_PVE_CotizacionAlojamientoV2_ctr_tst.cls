@isTest
private class COM_PVE_CotizacionAlojamientoV2_ctr_tst {
	
	@isTest static void test_method_one() {
		Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
		 Contact cont = COM_DataGenerator_cls.crearContacto(true, cuenta.Id);
		 Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, cuenta.Id);
		 Quote qt = COM_DataGenerator_cls.crearQuote(true, opp.Id);

		 Document doc = COM_DataGenerator_cls.crearDocumento(true, 'logo'+'COM_FichaTecnicaLagoMarSol');
		 AccountContactRelation acr = COM_DataGenerator_cls.crearContRelation(true, cuenta.Id, cont.ID);

		ApexPages.currentPage().getParameters().put('tipoDoc', 'COM_FichaTecnicaLagoMarSol');
		Apexpages.currentPage().getParameters().put( 'id', qt.Id );// id de la quote
		
		COM_PVE_CotizacionAlojamientoV2_ctr pp = new COM_PVE_CotizacionAlojamientoV2_ctr(null);
	}
}