@isTest
private class COM_WrapperCrearClienteGCResponse_tst {
	
	@isTest static void test_method_one() {
		COM_WrapperCrearClienteGCResponse_cls.Cliente cliente = new COM_WrapperCrearClienteGCResponse_cls.Cliente();
		cliente.TipoIdentificacion = '';
		cliente.NumeroIdentificacion = '';
		cliente.IdCliente = '';
		COM_WrapperCrearClienteGCResponse_cls.Body body = new COM_WrapperCrearClienteGCResponse_cls.Body();
		body.Cliente = cliente;
		COM_WrapperCrearClienteGCResponse_cls.CustomerMng_CrearClienteResponse customerMng_CrearClienteResponse = new COM_WrapperCrearClienteGCResponse_cls.CustomerMng_CrearClienteResponse();
		customerMng_CrearClienteResponse.header = new COM_BaseWrapperResponse_cls.Header();
		customerMng_CrearClienteResponse.Body = body;
		COM_WrapperCrearClienteGCResponse_cls wpr = new COM_WrapperCrearClienteGCResponse_cls();
		wpr.CustomerMng_CrearClienteResponse = customerMng_CrearClienteResponse;
	}
	
}