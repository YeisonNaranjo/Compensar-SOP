public class ENC_PreguntaInterna_cls
{
	public Integer numPregunta { get; set; }
	public Integer intRespuesta { get; set; }
	public String strRespuesta { get; set; }
	public AVX_ENC_PreguntaEncuesta__c pregunta { get; set; }
	public Boolean blnMostrarError { get; set; }
	public map<Integer,ENC_RespuestaPregunta_cls> mapRespuestaXPregunta { get; set; }
	
	public ENC_PreguntaInterna_cls( Integer intPreg, Integer intResp, String strResp, AVX_ENC_PreguntaEncuesta__c preg )
	{
		numPregunta = intPreg;
		intRespuesta = intResp;
		strRespuesta = strResp;
		pregunta = preg;
		blnMostrarError = false;
	}
	
	public ENC_PreguntaInterna_cls( Integer intPreg, map<Integer,ENC_RespuestaPregunta_cls> mapRespXPregunta, AVX_ENC_PreguntaEncuesta__c preg )
	{
		numPregunta = intPreg;
		mapRespuestaXPregunta = mapRespXPregunta;
		pregunta = preg;
		blnMostrarError = false;
	}

	/* CLASE INTERNA */
	public class ENC_RespuestaPregunta_cls{
		public Integer numPregunta { get; set; }
		public Integer numPreguntaTemp { get; set; }
		public Integer intRespuesta { get; set; }
		public String strRespuesta { get; set; }
		public String strPreguntaAbreviada { get; set; }
		public String strPreguntacompleta { get; set; }

		public ENC_RespuestaPregunta_cls( Integer intPreg, Integer intPregTemp, Integer intResp, String strResp )
		{
			numPregunta = intPreg;
			numPreguntaTemp = intPregTemp;
			intRespuesta = intResp;
			strRespuesta = strResp;
			strPreguntaAbreviada = '';
			strPreguntacompleta = '';
		}
	}
}