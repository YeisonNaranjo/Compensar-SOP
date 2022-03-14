public class ENC_OrdenarPreguntas_ctr
{
	/* ATRIBUTOS PRIVADOS */
	private final Apexpages.Standardcontroller ctr;
	private map<string, AVX_ENC_PreguntaEncuesta__c> mapPreguntasById;
	
	/* ATRIBUTOS PUBLICOS */
	public list<AVX_ENC_PreguntaEncuesta__c> lstPreguntas { get; set; }
	public Integer numPregs { get; set; }
	public String idsOrdenados { get; set; }
	
	/* CONSTRUCTOR */
	public ENC_OrdenarPreguntas_ctr( Apexpages.Standardcontroller controller )
	{
		ctr = controller;
		mapPreguntasById = new map<string, AVX_ENC_PreguntaEncuesta__c> ();
		lstPreguntas = new list<AVX_ENC_PreguntaEncuesta__c>();
		
		for( AVX_ENC_PreguntaEncuesta__c p : [	Select	Id, Name, Numero_de_pregunta__c, Pregunta__c
										From	AVX_ENC_PreguntaEncuesta__c
										where	Plantilla_encuesta__c = :ctr.getId() 
										Order By Numero_de_pregunta__c ])
		{
			lstPreguntas.add( p );
			mapPreguntasById.put( p.Id, p );
		}
							
		numPregs = lstPreguntas.size();
		idsOrdenados = '';
	}
	
	/* METODOS PUBLICOS */
	public PageReference ordenar()
	{
		PageReference pr = null;
		Integer i = 1;
		list<string> lstIds = idsOrdenados.split( ';' );
		
		system.debug( idsOrdenados );
		system.debug( lstIds );
		
		for( String strId : lstIds )
		{
			AVX_ENC_PreguntaEncuesta__c p = mapPreguntasById.get( strId );
			p.Numero_de_pregunta__c = i;
			i++;
		}
		
		update mapPreguntasById.values();
		
		pr = new PageReference( '/' + ctr.getId() );
		pr.setRedirect( true );
		return pr;
	}
}