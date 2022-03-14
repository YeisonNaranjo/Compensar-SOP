/**********************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Daniel Delgado
Descripción: Clase que implementa la interfaz para la ejecución de queries y búsqueda 
			 de registros.
Cambios (Versiones)
---------------------------------------------------------------------------------
No.		Fecha		Autor				Descripción
------ ---------- ---------------------------------------------------------------
1.0		17-12-2014	Daniel Delgado (DD)	Creación de clase.
***********************************************************************************/
public class ENC_Query_imp implements ENC_Query_int
{
	public sObject getSObject( string strNombreObjeto, string strCampos, string strFiltros )
	{
		String strQuery = 'Select ' + strCampos + ' From ' + strNombreObjeto;
		
		//Genera el WHERE únicamente si tiene filtro
		if( strFiltros != null && strFiltros != '' )
			strQuery += ' Where ' + strFiltros;
		
		//Dado que solo debe retornar un solo registro, se limita desde el query
		strQuery += ' limit 1 ';
		
		system.debug( '\n\nQUERY: ' + strQuery + '\n\n' );
		
		try
		{
			return Database.query( strQuery );
		}
		catch( system.exception e )
		{
			system.debug( '\n\nQUERY ERROR: ' + strQuery + '\n\nEXCEPTION: ' + e.getMessage() );
		}
		
		return null;
	}
	
	public list<sObject> getListaSObject( string strNombreObjeto, string strCampos, string strFiltros, integer intLimite, string strOrden )
	{
		String strQuery = 'Select ' + strCampos + ' From ' + strNombreObjeto;
		
		//Genera el WHERE únicamente si tiene filtro
		if( strFiltros != null && strFiltros != '' )
			strQuery += ' Where ' + strFiltros;
		
		//Incluye el orden cuando se reciba la información
		if( strOrden != null && strOrden != '' )
			strQuery += ' Order by ' + strOrden;
			
		//Incluye el límite únicamente si tiene valor mayor a 0
		if( intLimite != null && intLimite > 0 )
			strQuery += ' limit ' + intLimite;
		else
			strQuery += ' limit 10000';//Por defecto el límite será 10.000
			
		system.debug( '\n\nQUERY: ' + strQuery + '\n\n' );
		
		return Database.query( strQuery );
	}
	
	public list<sObject> getFuncionAggregate( string strNombreObjeto, string strCampos, string strFiltros, integer intLimite, string strOrden, string strAgrupado )
	{
		String strQuery = 'Select ' + strCampos + ' From ' + strNombreObjeto;
		
		//Genera el WHERE únicamente si tiene filtro
		if( strFiltros != null && strFiltros != '' )
			strQuery += ' Where ' + strFiltros;
		
		//Incluye la agrupación
		if( strAgrupado != null && strAgrupado != '' )
			strQuery += ' Group by ' + strAgrupado;
			
		//Incluye el orden cuando se reciba la información
		if( strOrden != null && strOrden != '' )
			strQuery += ' Order by ' + strOrden;
			
		//Incluye el límite únicamente si tiene valor mayor a 0
		if( intLimite != null && intLimite > 0 )
			strQuery += ' limit ' + intLimite;
		else
			strQuery += ' limit 10000';//Por defecto el límite será 10.000
			
		system.debug( '\n\nQUERY: ' + strQuery + '\n\n' );
		
		return Database.query( strQuery );
	}
	
	public Apexpages.Standardsetcontroller getControladorEstandar( String strNombreObjeto, String strNombreConjuntoCampos, String strPalabras, integer intLimite, string strOrden, String strFiltroAdicional )
	{
		Apexpages.Standardsetcontroller ApexStOut = null;
		string strSOQL;
		
		//Obtiene la lista de los campos del conjunto de campos.
		set<string> setCampos = ENC_Utils_cls.getFieldSetByObjectName( strNombreObjeto, strNombreConjuntoCampos );
		
		//Crea el select del query
		strSOQL = construirSelect( setCampos );
		strSOQL += ' FROM ' + strNombreObjeto;
		//Envía como parámetro adicional el nombre del tipo de registro. OJO Esto solo funciona para la página CRM_LookupReference_pag
		strSOQL += construirWhere( strFiltroAdicional, setCampos, strPalabras );
		//Incluye el orden cuando se reciba la información
		if( strOrden != null && strOrden != '' )
			strSOQL += ' Order by ' + strOrden;
			
		//Incluye el límite únicamente si tiene valor mayor a 0
		if( intLimite != null && intLimite > 0 )
			strSOQL += ' limit ' + intLimite;
		else
			strSOQL += ' limit 10000';//Por defecto el límite será 10.000
		
		system.debug('===>strSOQL='+strSOQL);
		
		ApexStOut = new Apexpages.Standardsetcontroller( DataBase.getQueryLocator( strSOQL ) );
		
		return ApexStOut;
	}
	
	public Apexpages.Standardsetcontroller getControladorEstandar( String strNombreObjeto, set<String> setCampos, String strPalabras, integer intLimite, string strOrden, String strFiltroAdicional )
	{
		Apexpages.Standardsetcontroller ApexStOut = null;
		string strSOQL;
		
		//Crea el select del query
		strSOQL = construirSelect( setCampos );
		strSOQL += ' FROM ' + strNombreObjeto;
		//Envía como parámetro adicional el nombre del tipo de registro. OJO Esto solo funciona para la página CRM_LookupReference_pag
		strSOQL += construirWhere( strFiltroAdicional, setCampos, strPalabras );
		//Incluye el orden cuando se reciba la información
		if( strOrden != null && strOrden != '' )
			strSOQL += ' Order by ' + strOrden;
			
		//Incluye el límite únicamente si tiene valor mayor a 0
		if( intLimite != null && intLimite > 0 )
			strSOQL += ' limit ' + intLimite;
		else
			strSOQL += ' limit 10000';//Por defecto el límite será 10.000
		
		system.debug('===>strSOQL='+strSOQL);
		
		ApexStOut = new Apexpages.Standardsetcontroller( DataBase.getQueryLocator( strSOQL ) );
		
		return ApexStOut;
	}
	
	/* Genera el SELECT del query dado una lista de campos. Por defecto incluye el campo id. */
	private String construirSelect( set<String> setFields )
	{
		string strSOQL = 'SELECT Id ';
		
		//Obtiene y recorre los campos del objeto Maestra de Filtros y el conjunto de campos dependiendo del tipo de registro.
		for( String strField : setFields )
		{
			if( !strField.equalsIgnoreCase( 'Id' ) )
				strSOQL += ', ' + strField;
		}
		
		return strSOQL;
	}
	
	/* Genera el WHERE del query dependiendo la información recibida. Cuando se recibe un conjunto de campos y conjunto de
	palabras, se crea el where de forma tal que las palabras recibidas hagan parte de alguno de los campos enviados. */
	public String construirWhere( string strFiltroInicial, set<String> setCampos, string strPalabras )
	{
		string strSOQL = ' WHERE ';
		//Bandera que permite identificar si el filtro de palabras inicia con el AND o el OR
		Boolean blnConFiltroInicial = false;
		
		//Incluye el filtro inical
		if( strFiltroInicial != null && strFiltroInicial != '' )
		{
			strSOQL += strFiltroInicial;
			blnConFiltroInicial = true;
		}
		
		//Incluye únicamente si tiene campos y palabras
		if( setCampos != null && setCampos.size() > 0 && strPalabras != null && strPalabras != '' )
		{
			Boolean blnEsPrimeraVez = true;
			
			//Recorre cada uno de los campos para agregar al WHERE
			for( String strCampo : setCampos )
			{
				//Crea la lógica para cualquier campo menos para el ID  !strCampo.equalsIgnoreCase( 'Id' ) ||
				if( !strCampo.contains('Id') )
				{
					//Por cada campo agrega las palabras en el filtro
					String strCampoTemp = strPalabras;
					
					if( blnEsPrimeraVez )
					{
						strSOQL += blnConFiltroInicial ? ' AND ' : '';
						
						if( strCampoTemp != null && ( strCampoTemp.startsWith( '*' ) || strCampoTemp.endsWith( '*' ) ) )
						{
							strSOQL += ' ( ' + strCampo + ' LIKE ';
							if( strCampoTemp.startsWith( '*' ) )
							{
								strCampoTemp = strCampoTemp.subString( 1, strCampoTemp.length() );
								strSOQL += '\'%';
							}
							else
								strSOQL += '\'';
							strSOQL += strCampoTemp.endsWith( '*' ) ? strCampoTemp.subString( 0, strCampoTemp.length() - 1 ) + '%\'' : strCampoTemp + '\'';
						}
						else
							strSOQL += ' ( ' + strCampo + ' = \'' + strCampoTemp + '\'' ;
						blnEsPrimeraVez = false;
					}
					else
					{
						if( strCampoTemp != null && ( strCampoTemp.startsWith( '*' ) || strCampoTemp.endsWith( '*' ) ) )
						{
							strSOQL += ' OR ' + strCampo + ' LIKE ';
							if( strCampoTemp.startsWith( '*' ) )
							{
								strCampoTemp = strCampoTemp.subString( 1, strCampoTemp.length() );
								strSOQL += '\'%';
							}
							else
								strSOQL += '\'';
							strSOQL += strCampoTemp.endsWith( '*' ) ? strCampoTemp.subString( 0, strCampoTemp.length() - 1 ) + '%\'' : strCampoTemp + '\'';
						}
						else
							strSOQL += ' OR ' + strCampo + ' = \'' + strCampoTemp + '\'' ;
					}
				}
			}
			strSOQL += ' )';
		}
		
		return strSOQL;
	}
	
	public list<list<sObject>> getSOSLResult( String strSObjeto, String strPalabras )
	{
		String qryString = 'FIND {' + strPalabras + '} IN ALL FIELDS RETURNING ' + strSObjeto;
		qryString = 'FIND \'' + strPalabras + '\' IN ALL FIELDS RETURNING ' + strSObjeto;
		system.debug( 'SOSL: ' + qryString );
		
		try
		{
			return search.query( qryString );
		}
		catch( system.exception e ){ system.debug( 'EXCEPTION: ' + e ); }
		return null;
	}
}