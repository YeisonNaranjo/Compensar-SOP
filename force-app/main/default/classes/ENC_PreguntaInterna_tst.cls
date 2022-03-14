@isTest
private class ENC_PreguntaInterna_tst {
	
	@isTest static void test_method_one() {
		// Implement test code
		ENC_PreguntaInterna_cls pic = new ENC_PreguntaInterna_cls(11, 111, '', null);
		pic.mapRespuestaXPregunta = new map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls>();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		ENC_PreguntaInterna_cls pic = new ENC_PreguntaInterna_cls(11, new map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls>(), new AVX_ENC_PreguntaEncuesta__c());
	}

	@isTest static void test_method_three() {
		// Implement test code
		ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls enc = new ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls(1,2,3,'123');

	}
	
}