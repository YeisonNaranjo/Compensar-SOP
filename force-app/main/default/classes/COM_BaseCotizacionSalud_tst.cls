/*
 * Created by AVX_RSuarez on 23/10/2017.
*/

@isTest
private class COM_BaseCotizacionSalud_tst {
	public static Quote cotizacion;
	public static void crearDatos(){
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		Product2 prod = new Product2();
		prod.Name = 'prod';
		prod.IsActive = true;
		prod.Family = 'hola';
		insert prod;
		Id idListaPrecio = Test.getStandardPricebookId();
		PricebookEntry itemListaPrecio = new PricebookEntry(Pricebook2Id = idListaPrecio, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert itemListaPrecio;
		Opportunity opp = new Opportunity();
		opp.Name = 'opp';
		opp.StageName = 'En revisión';
		opp.CloseDate = Date.newInstance(2017, 10, 23);
		opp.Pricebook2Id = idListaPrecio;
		opp.Contacto__c = con.Id;
		opp.AccountId = acc.Id;
		COM_Opportunity_cls.stopTrigger();
		insert opp;
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.Product2Id = prod.Id;
		oli.OpportunityId = opp.Id;
		oli.Quantity = 1;
		oli.TotalPrice =10000;
		COM_OpportunityLineItem_cls.stopTrigger();
		insert oli;
		cotizacion = new Quote();
		cotizacion.Name = 'c';
		cotizacion.OpportunityId = opp.Id;
		insert cotizacion;
		list<OpportunityLineItem> lstProdPorOportunidad = [SELECT id, Product2.Name, Product2.Description, Subtotal, Discount, TotalPrice FROM OpportunityLineItem
		WHERE OpportunityId =: opp.Id  AND Product2.Family != 'P&S']; 
        system.debug(lstProdPorOportunidad);
	}
	@isTest static void test_method_one() {
		crearDatos();
		PageReference pag = Page.COM_PVE_CotizacionTiqueteras_pag;
		Test.setCurrentPageReference(pag);
		System.currentPageReference().getParameters().put('IdCustomObject', cotizacion.Id);
		COM_PVE_CotizacionTiqueteras_ctr cotizacion = new COM_PVE_CotizacionTiqueteras_ctr();
	}
	
	@isTest static void test_method_two() {
		crearDatos();
		PageReference pag = Page.COM_PVE_CotizacionCapacitaciones_pag;
		Test.setCurrentPageReference(pag);
		System.currentPageReference().getParameters().put('IdCustomObject', cotizacion.Id);
		COM_PVE_CotizacionCapacitaciones_ctr cotizacion = new COM_PVE_CotizacionCapacitaciones_ctr();
	}
	@isTest static void test_method_three() {
		crearDatos();
		PageReference pag = Page.COM_PVE_CotizacionRiesgoPsicosocial_pag;
		Test.setCurrentPageReference(pag);
		System.currentPageReference().getParameters().put('IdCustomObject', cotizacion.Id);
		COM_PVE_CotizacionRiesgoPsicosocial_ctr cotizacion = new COM_PVE_CotizacionRiesgoPsicosocial_ctr();
		cotizacion.cargarContenidoMetadata('CotizacionProfesiograma__mdt');
	}
	
}