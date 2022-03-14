@isTest
private class COM_WrapperGeoreferenciaResponse_tst {
	
	@isTest static void test_method_one() {
		COM_WrapperGeoreferenciaResponse_cls wgr = new COM_WrapperGeoreferenciaResponse_cls();
		system.debug(wgr.Georeferencia_Response);

		COM_WrapperGeoreferenciaResponse_cls.System_x ppp = new COM_WrapperGeoreferenciaResponse_cls.System_x();
		system.debug(ppp.RequestDate); 
		system.debug(ppp.ResponseDate); 
		system.debug(ppp.ResponseCode); 
		system.debug(ppp.ResponseDesc); 
		system.debug(ppp.TransactionID);

		COM_WrapperGeoreferenciaResponse_cls.Header hd = new COM_WrapperGeoreferenciaResponse_cls.Header();
		system.debug(hd.System_x);

		COM_WrapperGeoreferenciaResponse_cls.Body bd = new COM_WrapperGeoreferenciaResponse_cls.Body();
		system.debug(bd.DireccionEstandarizada);
		system.debug(bd.Barrio);
		system.debug(bd.Localidad);


		COM_WrapperGeoreferenciaResponse_cls.GeoreferenciaResponse gr = new COM_WrapperGeoreferenciaResponse_cls.GeoreferenciaResponse();
		system.debug(gr.Header);
		system.debug(gr.Body);
	}
	
}