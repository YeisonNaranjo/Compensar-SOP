public class ENC_PreguntaAbierta_ctr
{
	transient String strRespuesta;
	
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
	
	public String getStrRespuesta()
	{
		strRespuesta = preguntaInterna.strRespuesta;
		return strRespuesta;
	}
	
	public void setStrRespuesta( String value )
	{
		strRespuesta = value;
		if( value != null && value.trim() != '' && blnMostrarPregunta )
		{
			value = value.trim();
			strRespuesta = value;
			preguntaInterna.strRespuesta = strRespuesta;
			preguntaInterna.blnMostrarError = false;
			if( preguntaInterna.pregunta.Tipo_pregunta__c.equalsIgnoreCase( Label.ENC_003_Pregunta_numerica ) )
			{
				//Numeric Format
				String RE_Num = '[0-9]+';
				Pattern MyPattern = Pattern.compile( RE_Num );
				
				// Then instantiate a new Matcher object "MyMatcher"
				Matcher MyMatcher = MyPattern.matcher( value );
				
				if ( !MyMatcher.matches() )
					preguntaInterna.blnMostrarError = true;
			}
			else if( preguntaInterna.pregunta.Tipo_pregunta__c.equalsIgnoreCase( Label.ENC_004_Pregunta_fecha ) )
			{
				//date format (dd/mm/yyyy)
				String RE_date = '(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[012])/((19|20)\\d\\d)';
				Pattern MyPattern = Pattern.compile( RE_date );
				
				// Then instantiate a new Matcher object "MyMatcher"
				Matcher MyMatcher = MyPattern.matcher( value );
				
				if ( !MyMatcher.matches() )
					preguntaInterna.blnMostrarError = true;
				else{
					list<String> lstDate = value.split( '/' );
					Date myDate = date.newinstance( Integer.valueOf( lstDate.get( 2 ) ), Integer.valueOf( lstDate.get( 1 ) ), Integer.valueOf( lstDate.get( 0 ) ) );
					Boolean blnFechaValida = true;

					blnFechaValida = myDate.year() != Integer.valueOf( lstDate.get( 2 ) ) ? false : blnFechaValida;
					blnFechaValida = myDate.month() != Integer.valueOf( lstDate.get( 1 ) ) ? false : blnFechaValida;
					blnFechaValida = myDate.day() != Integer.valueOf( lstDate.get( 0 ) ) ? false : blnFechaValida;

					if ( !blnFechaValida )
						preguntaInterna.blnMostrarError = true;
				}
			}
			else if( preguntaInterna.pregunta.Tipo_pregunta__c.equalsIgnoreCase( Label.ENC_005_Pregunta_email ) )
			{
				String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
				Pattern MyPattern = Pattern.compile( emailRegex );
				
				// Then instantiate a new Matcher object "MyMatcher"
				Matcher MyMatcher = MyPattern.matcher( value );
				
				if ( !MyMatcher.matches() )
					preguntaInterna.blnMostrarError = true;
			}
		}
		else if( ( ctr == null || !ctr.blnGuardarTemporal ) && preguntaInterna.pregunta.Obligatorio__c && blnMostrarPregunta )
			preguntaInterna.blnMostrarError = true;
		else
			preguntaInterna.blnMostrarError = false;
	}
	
	/* CONSTRUCTOR */
	
	/* METODOS PUBLICOS */
	public Boolean getEstaGuardando()
	{
		if( ctr != null )
			return ctr.blnGuardarEncuesta;
		
		return false;
	}
}