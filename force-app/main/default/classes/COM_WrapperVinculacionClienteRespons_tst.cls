@isTest
private class COM_WrapperVinculacionClienteRespons_tst {
	
	@isTest static void test_method_one() {
		COM_WrapperVinculacionClienteRespons_cls.ProcesarVinculacionResponse procesarVinculacionResponse = new COM_WrapperVinculacionClienteRespons_cls.ProcesarVinculacionResponse();
		procesarVinculacionResponse.resultadoOperacion = '';
		procesarVinculacionResponse.resultadoMensaje = '';
		COM_WrapperVinculacionClienteRespons_cls.Body body = new COM_WrapperVinculacionClienteRespons_cls.Body();
		body.ProcesarVinculacionResponse = procesarVinculacionResponse;
		COM_WrapperVinculacionClienteRespons_cls.CustomerAdminProcesarVinculacionResponse customerAdminProcesarVinculacionResponse = new COM_WrapperVinculacionClienteRespons_cls.CustomerAdminProcesarVinculacionResponse();
		customerAdminProcesarVinculacionResponse.Header = new COM_BaseWrapperResponse_cls.Header();
		customerAdminProcesarVinculacionResponse.Body = body;
		COM_WrapperVinculacionClienteRespons_cls wpr = new COM_WrapperVinculacionClienteRespons_cls();
		wpr.CustomerAdmin_ProcesarVinculacion_Response = customerAdminProcesarVinculacionResponse;
	}

}