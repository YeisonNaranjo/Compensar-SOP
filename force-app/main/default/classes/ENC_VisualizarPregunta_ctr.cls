public class ENC_VisualizarPregunta_ctr
{
	/* ATRIBUTOS PRIVADOS */
	private final Apexpages.Standardcontroller ctr;
	
	/* ATRIBUTOS PUBLICOS */
	public ENC_PreguntaInterna_cls pregunta { get; set; }
	
	public ENC_VisualizarPregunta_ctr( Apexpages.Standardcontroller controller )
	{
		ctr = controller;
		AVX_ENC_PreguntaEncuesta__c p = (AVX_ENC_PreguntaEncuesta__c)ctr.getRecord();
		ID idPreguntaMatricial = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Matricial' ).getRecordTypeId();
		if(p.RecordTypeId !=  null && p.RecordTypeId == idPreguntaMatricial ){

			//En la lista lstPregs se obtienen las preguntas.
			list<String> lstPregs = p.ListaPreguntas__c != null ? p.ListaPreguntas__c.split( '\\{!Õ}' ) : new list<String>();
			map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls> mapRespuestas = new map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls>();

			for( Integer i = 1; i <= lstPregs.size(); i++ )
			{
				String strPregunta = lstPregs.get( i - 1 );
				ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls resp = new ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls( i, i - 1, 0, '' );
				resp.strPreguntaAbreviada = strPregunta;
				resp.strPreguntacompleta = p.Name;
				mapRespuestas.put( i, resp );
			}

			pregunta = new ENC_PreguntaInterna_cls( 1, mapRespuestas, p );
		}
		else
			pregunta = new ENC_PreguntaInterna_cls( 1, 0, '', p );
	}
}