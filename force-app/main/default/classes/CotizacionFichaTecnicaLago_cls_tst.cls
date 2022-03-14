@isTest
public class CotizacionFichaTecnicaLago_cls_tst {
	@isTest static void test_method_one() {
		Account acc = COM_DataGenerator_cls.crearCuenta(true);
		Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		Opportunity opp = new Opportunity();
		opp.Name = 'opp';
		opp.StageName = 'En revisión';
		opp.CloseDate = Date.newInstance(2018,04, 11);
		opp.Contacto__c = con.Id;
		opp.AccountId = acc.Id;
		insert opp;

		PageReference pag = Page.COM_PVE_CotizacionTiqueteras_pag;
		Test.setCurrentPageReference(pag);
		System.currentPageReference().getParameters().put('IdCustomObject', opp.Id);
		ApexPages.StandardController controller = new ApexPages.StandardController(opp);
		COM_PVE_CotizacionFichaTecnicaLago_ctr ppp = new COM_PVE_CotizacionFichaTecnicaLago_ctr(controller);
	}
}