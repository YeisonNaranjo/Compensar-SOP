@isTest
private class COM_WrapperConsultaRequisitoResponse_tst {
	@isTest static void test_method_one() {
		COM_WrapperConsultaRequisitoResponse_cls.Requisito requisito = new COM_WrapperConsultaRequisitoResponse_cls.Requisito();
		requisito.Tipo = '';
		requisito.FechaInicio = '';
		requisito.FechaFin = '';
		requisito.ValorAlfanumerico = '';
		requisito.ValorNumerico = '';
		requisito.ValorBooleano = '';
		COM_WrapperConsultaRequisitoResponse_cls.Requisitos requisitos = new COM_WrapperConsultaRequisitoResponse_cls.Requisitos();
			List<COM_WrapperConsultaRequisitoResponse_cls.Requisito> lstRequisito = new List<COM_WrapperConsultaRequisitoResponse_cls.Requisito>();		
			lstRequisito.add(requisito);
		requisitos.Requisito = lstRequisito;
		COM_WrapperConsultaRequisitoResponse_cls.Body body = new COM_WrapperConsultaRequisitoResponse_cls.Body();
		body.Requisitos = requisitos;
		COM_WrapperConsultaRequisitoResponse_cls.ConsultaRequisitos_Response consultaRequisitos_Response = new COM_WrapperConsultaRequisitoResponse_cls.ConsultaRequisitos_Response();
		consultaRequisitos_Response.Header = new COM_BaseWrapperResponse_cls.Header();
		consultaRequisitos_Response.Body = body;
		COM_WrapperConsultaRequisitoResponse_cls wpr = new COM_WrapperConsultaRequisitoResponse_cls();
		wpr.ConsultaRequisitos_Response = consultaRequisitos_Response;
	}	
}