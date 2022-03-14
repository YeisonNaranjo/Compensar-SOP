@isTest
private class COM_WrapperConsultaClienteGCRequest_tst {
	@isTest static void test_method_one() {
		COM_WrapperConsultaClienteGCRequest_cls.Cliente cliente = new COM_WrapperConsultaClienteGCRequest_cls.Cliente();
		cliente.tipoIdentificacion = 1;
		cliente.numeroIdentificacion = 1;
		cliente.id = 1;
		cliente.tipoIdResponsable = 1;
		cliente.numeroIdResponsable = 1;
		cliente.opcionConsulta = 1;
		COM_WrapperConsultaClienteGCRequest_cls.Body body = new COM_WrapperConsultaClienteGCRequest_cls.Body();
		body.cliente = cliente;
		COM_WrapperConsultaClienteGCRequest_cls.CustomerMng_ConsultaCliente_Request customerMng_ConsultaCliente_Request = new COM_WrapperConsultaClienteGCRequest_cls.CustomerMng_ConsultaCliente_Request();
		customerMng_ConsultaCliente_Request.Header = new COM_BaseWrapper_cls.Header();
		customerMng_ConsultaCliente_Request.Body = body;
		COM_WrapperConsultaClienteGCRequest_cls wpr = new COM_WrapperConsultaClienteGCRequest_cls();
		wpr.CustomerMng_ConsultaCliente_Request = customerMng_ConsultaCliente_Request;
	}
}