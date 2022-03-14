@isTest
private class COM_WrapperConsultaRequisitosRequest_tst {
	@isTest static void test_method_one() {
		COM_WrapperConsultaRequisitosRequest_cls.Requisito requisito = new COM_WrapperConsultaRequisitosRequest_cls.Requisito();
		requisito.Tipo = '';
		COM_WrapperConsultaRequisitosRequest_cls.Requisitos requisitos = new COM_WrapperConsultaRequisitosRequest_cls.Requisitos();
			List<COM_WrapperConsultaRequisitosRequest_cls.Requisito> lstRequisito = new List<COM_WrapperConsultaRequisitosRequest_cls.Requisito>();		
			lstRequisito.add(requisito);
		requisitos.Requisito = lstRequisito;
		COM_WrapperConsultaRequisitosRequest_cls.Body body = new COM_WrapperConsultaRequisitosRequest_cls.Body();
		body.Requisitos = requisitos;
		body.TipoIdAfiliado = '';
		body.NumeroIdAfiliado = '';
		COM_WrapperConsultaRequisitosRequest_cls.ConsultaRequisitos_Request consultaRequisitos_Request = new COM_WrapperConsultaRequisitosRequest_cls.ConsultaRequisitos_Request();
		consultaRequisitos_Request.Header = new COM_BaseWrapper_cls.Header();
		consultaRequisitos_Request.Body = body;
		COM_WrapperConsultaRequisitosRequest_cls wpr = new COM_WrapperConsultaRequisitosRequest_cls();
		wpr.ConsultaRequisitos_Request = consultaRequisitos_Request;
	}	
}