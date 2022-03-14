public interface ENC_Query_int
{
	/**
	*Función para obtener un registro del sObject solicitado, enviando los campos, tipo de objeto, filtros del query y orden 
	*@strNombreObjeto STRING Nombre del objeto del que se desea hacer la consulta
	*@strCampos STRING Campos separados por comas que se quieren obtener del registro
	*@strFiltros STRING Condiciones del query para filtrar el resultado
	*@return SOBJECT Registro encontrado en la base de datos.
	**/
	sObject getSObject( string strNombreObjeto, string strCampos, string strFiltros );

	/**
	*Función para obtener la lista de registros del sObject solicitado, enviando los campos, tipo de objeto, filtros, 
	*número máximo de registros y orden del query 
	*@strNombreObjeto STRING Nombre del objeto del que se desea hacer la consulta
	*@strCampos STRING Campos separados por comas que se quieren obtener del registro
	*@strFiltros STRING Condiciones del query para filtrar el resultado
	*@intLimite INTEGER Número máximo de registros a retornar
	*@strOrden STRING Campos según el cual se ordenarán los registros encontrados
	*@return LIST<SOBJECT> Lista de registros entontrados en la base de datos
	**/
	list<sObject> getListaSObject( string strNombreObjeto, string strCampos, string strFiltros, integer intLimite, string strOrden );
	
	/**
	*Función para obtener la lista de registros de tipo aggregate del sObject solicitado, enviando los campos, tipo de objeto, filtros, 
	*número máximo de registros y orden del query 
	*@strNombreObjeto STRING Nombre del objeto del que se desea hacer la consulta
	*@strCampos STRING Campos separados por comas que se quieren obtener del registro
	*@strFiltros STRING Condiciones del query para filtrar el resultado
	*@intLimite INTEGER Número máximo de registros a retornar
	*@strOrden STRING Campos según el cual se ordenarán los registros encontrados
	*@strAgrupado STRING Campos según el cual se harán las agrupaciones.
	*@return LIST<SOBJECT> Lista de registros entontrados en la base de datos
	**/
	list<sObject> getFuncionAggregate( string strNombreObjeto, string strCampos, string strFiltros, integer intLimite, string strOrden, string strAgrupado );
	
	/**
	*Función para obtener el controlador estandar de registros. El query de los resultados se generará con base 
	*al conjunto de campos configurado en el objeto en mención y cuyo nombre se especifique en la solicitud. Adicionalmente, 
	*se creará un filtro sobre los campos del query para que contengan parte de alguna de las palabras solicitadas
	*@strNombreObjeto STRING Nombre del objeto del cual se desea hacer la consulta
	*@strNombreConjuntoCampos STRING Nombre API del conjunto de campos a utilizar
	*@strPalabras STRING Palabras para filtrar en cada uno de los campos del query. Las palabras están separadas por espacios.
	*@intLimite INTEGER Número máximo de registros a retornar
	*@strOrden STRING Campos según el cual se ordenarán los registros encontrados
	*@strFiltroAdicional STRING Valores opcionales que deben ser especificados en el query en la clausula WHERE
	*@return ApexPages.StandardSetController Controlador de registros estandar para ser usado como paginador
	**/
	Apexpages.Standardsetcontroller getControladorEstandar( String strNombreObjeto, String strNombreConjuntoCampos, String strPalabras, Integer intLimite, String strOrden, String strFiltroAdicional );
	
	/**
	*Función para obtener el controlador estandar de registros. El query de los resultados se generará con base 
	*al conjunto de campos configurado en el objeto en mención y cuyo nombre se especifique en la solicitud. Adicionalmente, 
	*se creará un filtro sobre los campos del query para que contengan parte de alguna de las palabras solicitadas
	*@strNombreObjeto STRING Nombre del objeto del cual se desea hacer la consulta
	*@setCampos SET<STRING> Lista de campos que se utilizarán en el query
	*@strPalabras STRING Palabras para filtrar en cada uno de los campos del query. Las palabras están separadas por espacios.
	*@intLimite INTEGER Número máximo de registros a retornar
	*@strOrden STRING Campos según el cual se ordenarán los registros encontrados
	*@strFiltroAdicional STRING Valores opcionales que deben ser especificados en el query en la clausula WHERE
	*@return ApexPages.StandardSetController Controlador de registros estandar para ser usado como paginador
	**/
	Apexpages.Standardsetcontroller getControladorEstandar( String strNombreObjeto, set<String> setCampos, String strPalabras, integer intLimite, string strOrden, String strFiltroAdicional );
	
	/**
	*Función para obtener el resultado de un SOSL
	*@strSObjeto STRING Nombre(s) del objeto(s) y lista de campos (opcionales) del que se desea hacer la(s) consulta(s)
	*@strPalabras STRING Palabras para filtrar en cada uno de los campos del query. Las palabras están separadas por comas.
	*@return list<list<sObject>> lista de lista de objetos encontrados
	**/
	list<list<sObject>> getSOSLResult( String strSObjeto, String strPalabras );
}