public class ENC_PreguntaMatricial_ctr
{
	transient String strRespuestas;
	transient List<infoPregunta> lstPreguntas;

	/* ATRIBUTOS PRIVADOS */
	private map<String,String> mapNombreOpcionXLlave;
	
	/* ATRIBUTOS PUBLICOS */
	public ENC_ResponderEncuesta_ctr ctr { get; set; }
	public ENC_PreguntaInterna_cls preguntaInterna { get; set; }

	public Boolean blnMostrarPregunta
	{
		get
		{
			blnMostrarPregunta = true;
			
			if( preguntaInterna.pregunta.Pregunta_dependiente__c != null && ctr != null )
			{
				blnMostrarPregunta = false;
				String strRespTemp = ctr.darRespuestas( preguntaInterna.pregunta.Pregunta_dependiente__c );
				set<String> setValoresSeleccionados = new set<String>();
				if( preguntaInterna.pregunta.Valor_dependiente__c != null )
				{
					for( String strKey : preguntaInterna.pregunta.Valor_dependiente__c.split( ';' ) )
					{
						if( strKey != null && strKey != '' )
							setValoresSeleccionados.add( strKey.toUpperCase() );
					}
				}
				if( preguntaInterna.pregunta.Valor_dependiente__c != null && strRespTemp != null && setValoresSeleccionados.contains( strRespTemp.toUpperCase() ) )
					blnMostrarPregunta = true;
				else
				{
					preguntaInterna.strRespuesta = '';
					preguntaInterna.intRespuesta = null;
				}
			}
			
			return blnMostrarPregunta;
		}
		set;
	}
	
	public List<infoPregunta> getLstPreguntas()
	{
		if( lstPreguntas == null )
		{
			//En la lista lstOPs se obtienen las parejas de texto y valor de las opciones.
			list<String> lstOPs = preguntaInterna.pregunta.Opciones_de_respuesta__c != null ? preguntaInterna.pregunta.Opciones_de_respuesta__c.split( 'Õ' ) : new list<String>();
			
			mapNombreOpcionXLlave = new map<String,String>();
			

			//System.debug( '-*//*- Opciones: ' + lstOpciones );

			lstPreguntas = new List<infoPregunta>();

			//En la lista lstPregs se obtienen las preguntas.
			list<String> lstPregs = preguntaInterna.pregunta.ListaPreguntas__c != null ? preguntaInterna.pregunta.ListaPreguntas__c.split( '\\{!Õ}' ) : new list<String>();

			for( Integer intKey : preguntaInterna.mapRespuestaXPregunta.keySet() )
			{
				ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls resp = preguntaInterna.mapRespuestaXPregunta.get( intKey );
				list<infoOpcion> lstOpciones = new list<infoOpcion>();
				Integer intNumOpcion = 0;
				for( String strOpcion : lstOPs )
				{
					//Se separan por cada una de las parejas de las opciones el texto y el valor.
					list<String> lstCampo = strOpcion.split( 'Ã' );
					//Se valida y se incluye como opción solamente aquellas que tengan texto y valor.
					if( lstCampo.size() == 2 ){
						mapNombreOpcionXLlave.put( '' + intNumOpcion, lstCampo.get( 0 ) + 'Ã' + lstCampo.get( 1 ) );
						lstOpciones.add( new infoOpcion( lstCampo.get( 0 ), '' + lstOpciones.size(), resp.strRespuesta != null && resp.strRespuesta.equalsIgnoreCase( lstCampo.get( 0 ) ), intNumOpcion ) );
						intNumOpcion++;
					}
				}
				lstPreguntas.add( new infoPregunta( resp.strPreguntaAbreviada, '' + resp.numPreguntaTemp, lstOpciones ) );
			}

			System.debug( '-*//*- Preguntas: ' + lstPreguntas );
		}
		return lstPreguntas;
	}

	public void setLstPreguntas( List<infoPregunta> lTemp )
	{
		lstPreguntas = lTemp;
	}

	public String getStrRespuestas()
	{
		if( strRespuestas == null || strRespuestas == '' ){
			strRespuestas = '';
			for( infoPregunta iPregunta : getLstPreguntas() ){
				String sTemp = '';
				for( infoOpcion iOpcion : iPregunta.lstOpciones ){
					if( iOpcion.isSelected ){
						sTemp += sTemp == '' ? '' : '|Ã|';
						sTemp += iOpcion.strValue;
					}
				}
				sTemp = sTemp == '' ? 'NULL' : sTemp;
				strRespuestas += strRespuestas == '' ? '' : '|Õ|';
				strRespuestas += sTemp;
			}
		}
		return strRespuestas;
	}
	
	public void setStrRespuestas( String value )
	{
		system.debug( 'LLEGAN RESPUESTAS: ' + value );
		preguntaInterna.blnMostrarError = false;

		if( ctr != null && blnMostrarPregunta )
		{
			//Inicializa los valores de las preguntas seleccionadas
			for( infoPregunta iPregunta : lstPreguntas ){
				for( infoOpcion iOpcion : iPregunta.lstOpciones ){
					iOpcion.isSelected = false;
					ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls resp = preguntaInterna.mapRespuestaXPregunta.get( Integer.valueOf( iPregunta.strValue ) );
					resp.strRespuesta = '';
					resp.intRespuesta = null;
				}
			}

			if( value != null && value.trim() != '' ){
				strRespuestas = value;
				list<String> lstOpcionesXPregunta = strRespuestas.split( '\\|Õ\\|' );

				if( !lstOpcionesXPregunta.isEmpty() )
				{
					for( infoPregunta iPregunta : lstPreguntas ){

						list<String> lstRespuestasRecibidas = lstOpcionesXPregunta.get( Integer.valueOf( iPregunta.strValue ) ).split( '\\|Ã\\|' );

						for( String strOpcionSeleccionada : lstRespuestasRecibidas ){
							if( strOpcionSeleccionada != 'NULL' ){
								infoOpcion iOpcion = iPregunta.getOpcion( Integer.valueOf( strOpcionSeleccionada ) );
								iOpcion.isSelected = true;
								String strRespEncode = mapNombreOpcionXLlave.get( '' + iOpcion.intKey );
								ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls resp = preguntaInterna.mapRespuestaXPregunta.get( Integer.valueOf( iPregunta.strValue ) );
								resp.strRespuesta = strRespEncode.split( 'Ã' ).get( 0 );
								resp.intRespuesta = Integer.valueOf( strRespEncode.split( 'Ã' ).get( 1 ) );
							}
							else if( ( ctr == null || !ctr.blnGuardarTemporal ) && preguntaInterna.pregunta.Obligatorio__c ){
								system.debug( 'PROCESO DETENIDO POR ' + preguntaInterna );
								preguntaInterna.blnMostrarError = true;
							}
						}
					}
				}
				else if( ( ctr == null || !ctr.blnGuardarTemporal ) && preguntaInterna.pregunta.Obligatorio__c )
				{
					system.debug( 'PROCESO DETENIDO POR ' + preguntaInterna );
					preguntaInterna.blnMostrarError = true;
				}
			}
			else if( ( ctr == null || !ctr.blnGuardarTemporal ) && preguntaInterna.pregunta.Obligatorio__c )
			{
				system.debug( 'PROCESO DETENIDO POR ' + preguntaInterna );
				preguntaInterna.blnMostrarError = true;
			}
		}
	}
	
	/* METODOS PUBLICOS */
	public Integer getNumPreguntas()
	{
		return lstPreguntas.size();
	}

	public PageReference actualizarPregunta()
	{
		if( ctr != null )
		{
			ctr.blnGuardarEncuesta = false;
		}
		return null;
	}
	
	public Boolean getEstaGuardando()
	{
		if( ctr != null )
			return ctr.blnGuardarEncuesta;
		
		return false;
	}

	/* CLASES INTERNAS */
	public Class infoPregunta {
		public String strLabel { get; set; }
		public String strValue { get; set; }
		public list<infoOpcion> lstOpciones { get; set; }

		public infoPregunta( String strLab, String strVal, list<infoOpcion> lstOpc ){
			strLabel = strLab;
			strValue = strVal;
			lstOpciones = lstOpc;
		}

		public infoOpcion getOpcion( Integer intValue ){
			for( infoOpcion iOpcion : lstOpciones ){
				if( intValue == Integer.valueOf( iOpcion.strValue ) )
					return iOpcion;
			}
			return null;
		}
	}

	public Class infoOpcion {
		public String strLabel { get; set; }
		public String strValue { get; set; }
		public Boolean isSelected { get; set; }
		public Integer intKey { get; set; }

		public infoOpcion( String strLab, String strVal, Boolean isSel, Integer iKey ){
			strLabel = strLab;
			strValue = strVal;
			isSelected = isSel;
			intKey = iKey;
		}
	}
}