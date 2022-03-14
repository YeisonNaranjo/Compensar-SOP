@isTest
private class COM_NotificacionPazYSalvo_cls_tst {
	
	@isTest static void test_method_two() {
		Account acc =  COM_DataGenerator_cls.crearCuenta(true);
		Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
		Opportunity opp =  COM_DataGenerator_cls.crearOportunidad(true, acc.Id);
		AccountContactRelation arl = COM_DataGenerator_cls.crearContRelation(true, acc.Id, con.Id);
		opp.COM_Vencimiento60diashabiles__c = Date.Today().addDays(5);
		update opp;
		COM_NotificacionPazYSalvo_cls ppp = new COM_NotificacionPazYSalvo_cls();
		ppp.execute(null);
	}

	
}