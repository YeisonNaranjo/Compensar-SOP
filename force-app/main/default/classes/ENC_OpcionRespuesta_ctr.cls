public class ENC_OpcionRespuesta_ctr
{
	/* ATRIBUTOS PRIVADOS */
	
	/* ATRIBUTOS PUBLICOS */
	public Boolean blnModoEdicion { get; set; }
	public Integer intPosOP { get; set; }
	public String strOpciones{ get; set; }
	public String strIdPregunta { get; set; }
	public String strIdPreguntaOpcion { get; set; }
	public list<opcionRespuesta> lstOpcionesRespuesta
	{
		get
		{
			if( lstOpcionesRespuesta == null )
				cargarOpciones();
			return lstOpcionesRespuesta;
		}
		set;
	}
	
	/* CONSTRUCTOR */
	public ENC_OpcionRespuesta_ctr()
	{
		//Inicialización de variables
		intPosOP = 0;
	}
	/* METODOS PUBLICOS */
	public Integer getNumeroOpciones()
	{
		return lstOpcionesRespuesta.size();
	}
	
	public Pagereference agregarOpcion()
	{
		lstOpcionesRespuesta.add( new opcionRespuesta( 'Opción ' + lstOpcionesRespuesta.size(), 0, lstOpcionesRespuesta.size() ) );
		return null;
	}
	
	public Pagereference eliminarOpcion()
	{
		system.debug( 'POSICION ELIMINAR: ' + intPosOP );
		try
		{
			lstOpcionesRespuesta.remove( intPosOP );
			//Se organizan nuevamente las posiciones
			for( Integer i = 0; i < lstOpcionesRespuesta.size(); i++ )
			{
				opcionRespuesta op = lstOpcionesRespuesta.get( i );
				op.intPosicion = i;
			}
		}
		catch( system.exception e ){}

		return null;
	}
	
	public Pagereference subirOpcion()
	{
		system.debug( 'POSICION SUBIR: ' + intPosOP );
		try
		{
			opcionRespuesta opDesde = lstOpcionesRespuesta.get( intPosOP );
			opcionRespuesta opHasta = lstOpcionesRespuesta.get( intPosOP - 1 );
			opcionRespuesta opTemp = new opcionRespuesta( opDesde.strOpcion, opDesde.intValor, opDesde.intPosicion );
			
			//Se cambian los valores de las posiciones
			opDesde.strOpcion = opHasta.strOpcion;
			opDesde.intValor = opHasta.intValor;
			opHasta.strOpcion = opTemp.strOpcion;
			opHasta.intValor = opTemp.intValor;
		}
		catch( system.exception e ){}
		return null;
	}
	
	public Pagereference bajarOpcion()
	{
		system.debug( 'POSICION BAJAR: ' + intPosOP );
		try
		{
			opcionRespuesta opDesde = lstOpcionesRespuesta.get( intPosOP );
			opcionRespuesta opHasta = lstOpcionesRespuesta.get( intPosOP + 1 );
			opcionRespuesta opTemp = new opcionRespuesta( opDesde.strOpcion, opDesde.intValor, opDesde.intPosicion );
			
			//Se cambian los valores de las posiciones
			opDesde.strOpcion = opHasta.strOpcion;
			opDesde.intValor = opHasta.intValor;
			opHasta.strOpcion = opTemp.strOpcion;
			opHasta.intValor = opTemp.intValor;
		}
		catch( system.exception e ){}
		return null;
	}
	
	public Pagereference cargarOpcionesPrgeuntaExistente()
	{
		ENC_Query_int doQuery = new ENC_Query_imp();
		String strCampos = 'Id, Name, Opciones_de_respuesta__c';
		String strFiltros = 'Id = \'' + strIdPreguntaOpcion + '\'';
		for( AVX_ENC_PreguntaEncuesta__c pregunta : (list<AVX_ENC_PreguntaEncuesta__c>)doQuery.getListaSObject( 'AVX_ENC_PreguntaEncuesta__c', strCampos, strFiltros, null, 'Name' ) ){
			for( String strDupla : pregunta.Opciones_de_respuesta__c.split( 'Õ' ) )
				lstOpcionesRespuesta.add( new opcionRespuesta( strDupla.split( 'Ã' ).get( 0 ), Integer.valueOf( strDupla.split( 'Ã' ).get( 1 ) ), lstOpcionesRespuesta.size() ) );
		}
		return null;
	}
	
	public Pagereference guardarOpcionesRespuesa()
	{
		String strOR = '';
		set<String> setOpciones = new set<String>();
		
		system.debug( 'codificarOpcionesRespuesa: ' + lstOpcionesRespuesta );
		//Organiza las opciones de respuesta. Estructura esperada: OPCION_1ÃVALOR_1ÕOPCION_2ÃVALOR_2Õ...
		for( opcionRespuesta op : lstOpcionesRespuesta )
		{
			if( op.strOpcion != null && op.strOpcion != '' && op.intValor != null )
			{
				if( !setOpciones.contains( op.strOpcion ) )
				{
					strOR += strOR == '' ? op.strOpcion + 'Ã' + op.intValor : 'Õ' + op.strOpcion + 'Ã' + op.intValor;
					setOpciones.add( op.strOpcion );
				}
				else
				{
					strOR = null;
					ENC_Utils_cls.addMessage( ENC_Utils_cls.ERROR, 'No pueden existir opciones repetidas.' );
					break;
				}
			}
			else
			{
				strOR = null;
				ENC_Utils_cls.addMessage( ENC_Utils_cls.ERROR, 'Para continuar debe ingresar los valores en todas las opciones de respuesta.' );
				break;
			}
		}
		
		try
		{
			if( strOR != null )
			{
				AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c( id = strIdPregunta );
				pregunta.Opciones_de_respuesta__c = strOR;
				update pregunta;
			}
		}
		catch( system.exception e ){}
		
		return null;
	}
	
	/* METODOS PRIVADOS */
	private void cargarOpciones()
	{
		lstOpcionesRespuesta = new list<opcionRespuesta>();
		try
		{
			system.debug( 'OPCIONES BD: ' + strOpciones );
			list<String> lstOPs = strOpciones.split( 'Õ' );
			system.debug( 'OPCIONES LST: ' + lstOPs );
			for( String strOP : lstOPs )
			{
				list<String> lstCampo = strOP.split( 'Ã' );
				system.debug( 'SIZE POR CAMPO: ' + lstCampo.size() + ' LISTA CAMPOS: ' + lstCampo );
				if( lstCampo.size() == 2 )
					lstOpcionesRespuesta.add( new opcionRespuesta( lstCampo.get( 0 ), Integer.valueOf( lstCampo.get( 1 ) ), lstOpcionesRespuesta.size() ) );
			}
		}
		catch( system.exception e ){ system.debug( 'EXCEPTION: ' + e ); }
	}
	
	/* CLASES INTERNAS */
	public class opcionRespuesta
	{
		public String strOpcion { get; set; }
		public Integer intValor { get; set; }
		public Integer intPosicion { get; set; }
		
		public opcionRespuesta( String newOp, Integer newVal, Integer newPos )
		{
			strOpcion = newOp;
			intValor = newVal;
			intPosicion = newPos;
		}
	}

	/* MÉTODOS REMOTOS */
	/**
	* @description Método que retorna el listado de plantillas de encuesta
	*/
	@RemoteAction
	public static list<String> getListaPlantillas() {

		list<String> lstPlantillas = new list<String>();

		ENC_Query_int doQuery = new ENC_Query_imp();
		String strCampos = 'Id, Name';
		String strFiltros = 'NumeroPreguntasCerradas__c > 0';
		for( AVX_ENC_PlantillaEncuesta__c plantilla : (list<AVX_ENC_PlantillaEncuesta__c>)doQuery.getListaSObject( 'AVX_ENC_PlantillaEncuesta__c', strCampos, strFiltros, null, 'Name' ) ){
			lstPlantillas.add( plantilla.Name + 'Ã' + plantilla.Id );
		}

		return lstPlantillas;
	}

	/**
	* @description Método que retorna el listado de preguntas dado un id de plantilla de encuesta
	*/
	@RemoteAction
	public static list<String> getListaPreguntas( String strIdPlantilla ) {
		list<String> lstPreguntas = new list<String>();

		ENC_Query_int doQuery = new ENC_Query_imp();
		String strCampos = 'Name, Id';
		String strFiltros = 'Plantilla_encuesta__c = \'' + strIdPlantilla + '\' AND RecordType.DeveloperName = \'' + Label.ENC_002_Pregunta_seleccion + '\'';
		for( AVX_ENC_PreguntaEncuesta__c pregunta : (list<AVX_ENC_PreguntaEncuesta__c>)doQuery.getListaSObject( 'AVX_ENC_PreguntaEncuesta__c', strCampos, strFiltros, null, 'Name' ) ){
			lstPreguntas.add( pregunta.Name + 'Ã' + pregunta.Id );
		}

		return lstPreguntas;
	}

	/**
	* @description Método que retorna el listado de opciones de respuesta de una prgeunta
	*/
	@RemoteAction
	public static list<String> getListaOpciones( String strIdPregunta ) {
		list<String> lstPreguntas = new list<String>();

		ENC_Query_int doQuery = new ENC_Query_imp();
		String strCampos = 'Id, Name, Opciones_de_respuesta__c';
		String strFiltros = 'Id = \'' + strIdPregunta + '\'';
		for( AVX_ENC_PreguntaEncuesta__c pregunta : (list<AVX_ENC_PreguntaEncuesta__c>)doQuery.getListaSObject( 'AVX_ENC_PreguntaEncuesta__c', strCampos, strFiltros, null, 'Name' ) ){
			for( String strDupla : pregunta.Opciones_de_respuesta__c.split( 'Õ' ) )
				lstPreguntas.add( strDupla.split( 'Ã' ).get( 0 ) + 'Ã' + strDupla.split( 'Ã' ).get( 1 ) );
		}

		return lstPreguntas;
	}

	/**
	* @description Método que recibe la lista de opciones de la página y las guarda en la pregunta
	*/
	@RemoteAction
	public static void guardarOpciones( String strIdPregunta, String strOpcionesTemp ) {

		AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c( id = strIdPregunta );
		pregunta.Opciones_de_respuesta__c = strOpcionesTemp;

		update pregunta;
	}

	/**
	* @description Método que recibe la lista de preguntas de la página y las guarda en el campo ListaPreguntas__c
	*/
	@RemoteAction
	public static void guardarPreguntas( String strIdPregunta, String strPreguntasTemp ) {

		AVX_ENC_PreguntaEncuesta__c pregunta = new AVX_ENC_PreguntaEncuesta__c( id = strIdPregunta );
		pregunta.ListaPreguntas__c = strPreguntasTemp;

		update pregunta;
	}
}