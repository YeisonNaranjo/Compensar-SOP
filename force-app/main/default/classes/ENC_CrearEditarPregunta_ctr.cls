public class ENC_CrearEditarPregunta_ctr
{
	/* ATRIBUTOS PRIVADOS */
	private final Apexpages.Standardcontroller ctr;
	private ENC_Query_int doQuery;
	
	/* ATRIBUTOS PUBLICOS */
	public Boolean blnModoEdicion { get; set; }
	public Boolean blnPreguntaAbierta { get; set; }
	public list<Selectoption> lstPreguntasDependientes { get; set; }
	public list<Selectoption> lstValoresDependientesSeleccionados { get; set; }
	public list<Selectoption> lstValoresDependientesDisponibles
	{
		get
		{
			if( lstValoresDependientesDisponibles == null )
				lstValoresDependientesDisponibles = cargarValoresDependientes();
			return lstValoresDependientesDisponibles;
		}
		set;
	}

	/* CONSTRUCTOR */
	public ENC_CrearEditarPregunta_ctr( Apexpages.Standardcontroller controller )
	{
		//Inicialización de variables
		ctr = controller;
		doQuery = new ENC_Query_imp();
		blnPreguntaAbierta = true;
		
		//Configuración de campos dado los parámetros
		AVX_ENC_PreguntaEncuesta__c pe = (AVX_ENC_PreguntaEncuesta__c)ctr.getRecord();
		system.debug( 'OPCIONES:: ' + pe.Opciones_de_respuesta__c );
		map<String,String> mapParametros = Apexpages.currentPage().getParameters();
		
		blnModoEdicion = ( mapParametros.get( 'save_new' ) != null && mapParametros.get( 'save_new' ) == '1' ) || mapParametros.get( 'retURL' ) != null;
		
		if( mapParametros.containsKey( 'RecordType' ) )
		{
			RecordType rtPregunta = (RecordType)doQuery.getSObject( 'RecordType', 'Id, Name, DeveloperName', 'Id = \'' + mapParametros.get( 'RecordType' ) + '\'' );
			pe.RecordType = rtPregunta;
			blnPreguntaAbierta = rtPregunta != null && rtPregunta.DeveloperName == 'Abierta';
		}
		
		lstPreguntasDependientes = ENC_Utils_cls.nuevaListaSelectOption();
		String strWhere = 'Plantilla_encuesta__c = \'' + pe.Plantilla_encuesta__c + '\' AND RecordType.DeveloperName = \'' + 'Cerrada' + '\'';
		strWhere +=  pe.Id != null ? ' AND Id != \'' + pe.Id + '\'' : '';
		for( AVX_ENC_PreguntaEncuesta__c peTemp : (list<AVX_ENC_PreguntaEncuesta__c>)doQuery.getListaSObject( 'AVX_ENC_PreguntaEncuesta__c', 'Id, Name', strWhere, 999, 'Name' ) )
		{
			lstPreguntasDependientes.add( new Selectoption( peTemp.Id, peTemp.Name) );
		}
		
		//Carga los valores dependientes seleccionados
		if( pe.Valor_dependiente__c == null )
			pe.Valor_dependiente__c = '';
		for( String strKey : pe.Valor_dependiente__c.split( ';' ) )
		{
			if( lstValoresDependientesSeleccionados == null )
				lstValoresDependientesSeleccionados = new list<SelectOption>();
			if( strKey != null && strKey != '' )
				lstValoresDependientesSeleccionados.add( new SelectOption( strKey, strKey ) );
		}
	}
	/* METODOS PUBLICOS */
	public Integer getNumValoresDependientes()
	{
		return lstValoresDependientesDisponibles.size();
	}
	
	public Integer getNumPreguntasDependientes()
	{
		return lstPreguntasDependientes.size();
	}
	
	public Pagereference actualizarPagina()
	{
		lstValoresDependientesDisponibles = null;
		lstValoresDependientesSeleccionados = new list<SelectOption>();
		return null;
	}
	
	public Pagereference save()
	{
		AVX_ENC_PreguntaEncuesta__c pe = (AVX_ENC_PreguntaEncuesta__c)ctr.getRecord();
		pe.Valor_dependiente__c = '';
		for( Selectoption so : lstValoresDependientesSeleccionados )
		{
			pe.Valor_dependiente__c += pe.Valor_dependiente__c == '' ? '' : ';';
			pe.Valor_dependiente__c += so.getValue();
		}
		
		return ctr.save();
	}
	
	/* METODOS PRIVADOS */
	private list<Selectoption> cargarValoresDependientes()
	{
		AVX_ENC_PreguntaEncuesta__c pregunta = (AVX_ENC_PreguntaEncuesta__c)ctr.getRecord();
		list<Selectoption> lstValores = new list<Selectoption>();
		set<String> setValoresSeleccionados = new set<String>();
		for( Selectoption so : lstValoresDependientesSeleccionados )
			setValoresSeleccionados.add( so.getValue().toUpperCase() );
		
		
		if( pregunta.Pregunta_dependiente__c != null )
		{
			AVX_ENC_PreguntaEncuesta__c preguntaDependiente = (AVX_ENC_PreguntaEncuesta__c)doQuery.getSObject( 'AVX_ENC_PreguntaEncuesta__c', 'Id, Opciones_de_respuesta__c', 'Id = \'' + pregunta.Pregunta_dependiente__c + '\'' );
			if( preguntaDependiente.Opciones_de_respuesta__c != null && preguntaDependiente.Opciones_de_respuesta__c != '' )
			{
				try
				{
					system.debug( 'OPCIONES BD: ' + preguntaDependiente.Opciones_de_respuesta__c );
					list<String> lstOPs = preguntaDependiente.Opciones_de_respuesta__c.split( 'Õ' );
					system.debug( 'OPCIONES LST: ' + lstOPs );
					for( String strOP : lstOPs )
					{
						list<String> lstCampo = strOP.split( 'Ã' );
						system.debug( 'SIZE POR CAMPO: ' + lstCampo.size() + ' LISTA CAMPOS: ' + lstCampo );
						if( lstCampo.size() == 2 )
						{
							if( !setValoresSeleccionados.contains( lstCampo.get( 0 ).toUpperCase() ) )
								lstValores.add( new Selectoption( lstCampo.get( 0 ), lstCampo.get( 0 ) ) );
						}
					}
				}
				catch( system.exception e ){ system.debug( 'EXCEPTION: ' + e ); }
			}
		}
		
		return lstValores;
	}
	/* CLASES INTERNAS */
	
}