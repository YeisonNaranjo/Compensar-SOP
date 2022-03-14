public class ENC_PreguntaCerrada_ctr
{
	transient String strRespuesta;
	transient String opc;
	transient List<String> lstRespuestasSeleccionadas;
	transient List<SelectOption> lstOpciones;
	
	private map<String,Integer> mapValoresXOpcion;
	
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
	
	public List<SelectOption> getLstOpciones()
	{
		if( lstOpciones == null )
		{
			lstOpciones = new List<SelectOption>();
			mapValoresXOpcion = new map<String,Integer>();
			//Si la pregunta es de tipo lista se crea la opción el valor inicial como -- Seleccionar --
			if( preguntaInterna.pregunta.Tipo_pregunta__c == Label.ENC_009_Pregunta_lista )
				lstOpciones = ENC_Utils_cls.nuevaListaSelectOption();
				
			//En la lista lstOPs se obtienen las parejas de texto y valor de las opciones.
			list<String> lstOPs = preguntaInterna.pregunta.Opciones_de_respuesta__c != null ? preguntaInterna.pregunta.Opciones_de_respuesta__c.split( 'Õ' ) : new list<String>();
			
			for( String strOpcion : lstOPs )
			{
				//Se separan por cada una de las parejas de las opciones el texto y el valor.
				list<String> lstCampo = strOpcion.split( 'Ã' );
				
				//Se valida y se incluye como opción solamente aquellas que tengan texto y valor.
				if( lstCampo.size() == 2 )
				{
					lstOpciones.add( new SelectOption( lstCampo.get( 0 ) + 'Ã' + lstCampo.get( 1 ), lstCampo.get( 0 ) ) );
					mapValoresXOpcion.put( lstCampo.get( 0 ), Integer.valueOf( lstCampo.get( 1 ) ) );
				}
			}
			System.debug( '-*//*- Opciones: ' + lstOpciones );
		}
		return lstOpciones;
	}

	public void setLstOpciones( List<SelectOption> lTemp )
	{
		lstOpciones = lTemp;
	}
	
	public List<String> getLstRespuestasSeleccionadas()
	{
		if( lstRespuestasSeleccionadas == null )
		{
			if( preguntaInterna.pregunta.Tipo_pregunta__c.equalsIgnoreCase( Label.ENC_008_Pregunta_casilla ) && ctr != null )
			{
				String strTemp = preguntaInterna.strRespuesta != null ? preguntaInterna.strRespuesta : '';
				lstRespuestasSeleccionadas = new list<String>();
				
				for( String strValorTemp : strTemp.split( '; ' ) )
				{
					String strValOpcion = mapValoresXOpcion.containsKey( strValorTemp ) ? '' + mapValoresXOpcion.get( strValorTemp ) : '0';
					lstRespuestasSeleccionadas.add( strValorTemp + 'Ã' + strValOpcion );
				}
			}
			else
				lstRespuestasSeleccionadas = new List<String>();
		}
		return lstRespuestasSeleccionadas;
	}
	
	public void setLstRespuestasSeleccionadas( List<String> value )
	{
		if( preguntaInterna.pregunta.Tipo_pregunta__c.equalsIgnoreCase( Label.ENC_008_Pregunta_casilla ) )
		{
			preguntaInterna.blnMostrarError = false;
			if( ctr != null && blnMostrarPregunta )
			{
				if( value != null && !value.isEmpty() )
				{
					lstRespuestasSeleccionadas = value;
					String strTemp = '';
					Integer intTemp = 0;
					for( String s : lstRespuestasSeleccionadas )
					{
						list<String> lstRespuestaTemp = s.split( 'Ã' );
						strTemp = strTemp == '' ? lstRespuestaTemp.get( 0 ) : strTemp + '; ' + lstRespuestaTemp.get( 0 );
						system.debug( 'lstRespuestaTemp.get( 1 ) --> ' + lstRespuestaTemp.get( 1 ) );
						intTemp += Integer.valueOf( lstRespuestaTemp.get( 1 ) );
					}
					preguntaInterna.intRespuesta = intTemp;
					preguntaInterna.strRespuesta = strTemp;
					preguntaInterna.blnMostrarError = false;
				}
				else if( ( ctr == null || !ctr.blnGuardarTemporal ) && preguntaInterna.pregunta.Obligatorio__c )
				{
					system.debug( 'PROCESO DETENIDO POR ' + preguntaInterna );
					preguntaInterna.blnMostrarError = true;
				}
			}
		}
	}
	
	public String getStrRespuesta()
	{
		if( strRespuesta == null )
		{
			strRespuesta = preguntaInterna.strRespuesta + 'Ã' + preguntaInterna.intRespuesta;
		}
		return strRespuesta;
	}
	
	public void setStrRespuesta( String value )
	{
		if( !preguntaInterna.pregunta.Tipo_pregunta__c.equalsIgnoreCase( Label.ENC_008_Pregunta_casilla ) )
		{
			preguntaInterna.blnMostrarError = false;
			if( ctr != null && blnMostrarPregunta )
			{
				if( value != null && value.trim() != '' )
				{
					strRespuesta = value;
					list<String> lstResultadosTemp = value.split( 'Ã' );
					preguntaInterna.intRespuesta = Integer.valueOf( lstResultadosTemp.get( 1 ) );
					preguntaInterna.strRespuesta = lstResultadosTemp.get( 0 );
					preguntaInterna.blnMostrarError = false;
				}
				else if( ( ctr == null || !ctr.blnGuardarTemporal ) && preguntaInterna.pregunta.Obligatorio__c )
				{
					system.debug( 'PROCESO DETENIDO POR ' + preguntaInterna );
					preguntaInterna.blnMostrarError = true;
				}
			}
		}
	}
	
	/* METODOS PUBLICOS */
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
}