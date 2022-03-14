@isTest
private class COM_WrapperConsultaClienteGC_tst {
	@isTest static void test_method_one() {
		COM_WrapperConsultaClienteGC_cls.Cliente cliente = new COM_WrapperConsultaClienteGC_cls.Cliente();
		cliente.tipoIdentificacion = 1;
		cliente.numeroIdentificacion = 1;
		cliente.id = 1;
		cliente.tipoIdResponsable = 1;
		cliente.numeroIdResponsable = 1;
		cliente.opcionConsulta = 1;
		COM_WrapperConsultaClienteGC_cls.Body body = new COM_WrapperConsultaClienteGC_cls.Body();
		body.cliente = cliente;
		COM_WrapperConsultaClienteGC_cls.CustomerMng_ConsultaCliente_Request customerMng_ConsultaCliente_Request = new COM_WrapperConsultaClienteGC_cls.CustomerMng_ConsultaCliente_Request();
		customerMng_ConsultaCliente_Request.Header = new COM_BaseWrapper_cls.Header();
		customerMng_ConsultaCliente_Request.Body = body;
		COM_WrapperConsultaClienteGC_cls wpr = new COM_WrapperConsultaClienteGC_cls();
		wpr.CustomerMng_ConsultaCliente_Request = customerMng_ConsultaCliente_Request;
	}
}