/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase donde se realizan los siguientes procesos:
					- Consultar tablas parametricas de dominio

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     28/07/17             Cristian David Mejia (CM)             Creación Clase.
    ************************************************************************************************/

    public with sharing class COM_ConsultarTablaDominio_cls {
    	public COM_ConsultarTablaDominio_cls() {
    		
    	}

	/**
	 * Consulta un valor de label de las tablas parametricas
	 * @param  nombreTabla [Nombre de la tabla parametrica]
	 * @param  codigoTabla [Codigo del valor solicitado]
	 * @return             [Retorna el Label del valor solicitado]
	 */
	 public static String consultarValorTabla(String nombreTabla, String codigoTabla){
	 	List<CON_TABLAS_DOMINIOM__mdt> lstConfig = [SELECT com_valor__c FROM CON_TABLAS_DOMINIOM__mdt WHERE com_tabla__c =: nombreTabla and 	com_codigo__c =: codigoTabla];

		//Se valida que se halla encontrado una configuración con el identificador ingresado
		if(lstConfig.isEmpty())
		return '';
		else
		return lstConfig[0].com_valor__c != null ? lstConfig[0].com_valor__c  : '';
	}

	/**
	 * Consulta el codigo de un valor de una tabla parametrica
	 * @param  nombreTabla [Nombre de la tabla parametrica]
	 * @param  valorTabla  [Label del valor de la tabla]
	 * @return             [Retorna el codigo del valor solicitado]
	 */
	 public static Integer consultarCodigoTabla(String nombreTabla, String valorTabla){
	 	List<CON_TABLAS_DOMINIOM__mdt> lstConfig = [SELECT com_codigo__c FROM CON_TABLAS_DOMINIOM__mdt WHERE com_tabla__c =: nombreTabla and 	com_valor__c =: valorTabla];

		//Se valida que se halla encontrado una configuración con el identificador ingresado
		if(lstConfig.isEmpty())
		return null;
		else
		return Integer.valueOf(lstConfig[0].com_codigo__c);
	}


}