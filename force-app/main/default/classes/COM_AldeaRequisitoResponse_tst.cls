@isTest
private class COM_AldeaRequisitoResponse_tst {
	
	@isTest static void test_method_one() {
		COM_AldeaRequisitoResponse_cls ppp = new COM_AldeaRequisitoResponse_cls();
		ppp.setBody(new COM_AldeaRequisitoResponse_cls.Body());
		ppp.getBody();


		ppp.setHeader(new  COM_BaseWrapper_cls.Header());
		ppp.getHeader();
		ppp.toString();

		COM_AldeaRequisitoResponse_cls.Requisitos rr = new COM_AldeaRequisitoResponse_cls.Requisitos();
		ppp.getBody().setRequisitos(rr);
		ppp.getBody().getRequisitos();
		COM_AldeaRequisitoResponse_cls.Requisito r = new COM_AldeaRequisitoResponse_cls.Requisito();
		ppp.getBody().getRequisitos().setRequisito(r);
		ppp.getBody().getRequisitos().getRequisito();
		ppp.getBody().getRequisitos().toString();
		ppp.getBody().getRequisitos().getRequisito().setFechaInicio('pruebaDate');
		ppp.getBody().getRequisitos().getRequisito().getFechaInicio();
		ppp.getBody().getRequisitos().getRequisito().setEstado('pruebaEstado');
		ppp.getBody().getRequisitos().getRequisito().getEstado();
		ppp.getBody().getRequisitos().getRequisito().setTipo('pruebaTipo');
		ppp.getBody().getRequisitos().getRequisito().getTipo();
		ppp.getBody().getRequisitos().getRequisito().setFechaFin('pruebaDate');
		ppp.getBody().getRequisitos().getRequisito().getFechaFin();
		ppp.getBody().getRequisitos().getRequisito().toString();

	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}