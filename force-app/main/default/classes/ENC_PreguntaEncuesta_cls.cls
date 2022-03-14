public class ENC_PreguntaEncuesta_cls
{
	/******************************************************************************
	Desarrollado por: Avanxo Colombia
	Autor: Daniel Delgado
	Nombre: actualizarNumeroPregunta
	Parámetro lstPreguntasNew: lista que contiene las preguntas que fueron modificadas
	Parámetro lstPreguntasOld: lista que contiene las cuentas antes de ser modificadas
	Descripción: Método que se encarga de actualizar los números de preguntas cuando 
				estas son creadas o actualizadas y no tienen número de preguntas.
	Cambios (Versiones)
	-------------------------------------------------------------------------------
	No.	Fecha		Autor					Descripción
	------ ---------- -------------------------------------------------------------
	1.0	12-22-2014	Daniel Delgado (DD)	Creación del método.
	*******************************************************************************/
	public static void actualizarNumeroPregunta( list<AVX_ENC_PreguntaEncuesta__c> lstCuentasNew, list<AVX_ENC_PreguntaEncuesta__c> lstCuentasOld )
	{
		map<String,Integer> mapNumPreguntasXEncuesta = new map<String,Integer>();
		
		for( AVX_ENC_PreguntaEncuesta__c pe : lstCuentasNew )
		{
			if( pe.Id == null || pe.Numero_de_pregunta__c == null )
				mapNumPreguntasXEncuesta.put( pe.Plantilla_encuesta__c, 0 );
		}
		
		for( AggregateResult ar : [	Select	Plantilla_encuesta__c, COUNT(Id) numPreg
									From	AVX_ENC_PreguntaEncuesta__c
									Where	Plantilla_encuesta__c IN :mapNumPreguntasXEncuesta.keySet() AND Numero_de_pregunta__c <> null 
									Group by Plantilla_encuesta__c ] )
		{
			Integer numPregs = (Integer)ar.get( 'numPreg' );
			mapNumPreguntasXEncuesta.put( (String)ar.get( 'Plantilla_encuesta__c' ), numPregs );
		}
		
		for( AVX_ENC_PreguntaEncuesta__c pe : lstCuentasNew )
		{
			if( pe.Id == null || pe.Numero_de_pregunta__c == null )
			{
				mapNumPreguntasXEncuesta.put( pe.Plantilla_encuesta__c, mapNumPreguntasXEncuesta.get( pe.Plantilla_encuesta__c ) + 1 );
				pe.Numero_de_pregunta__c = mapNumPreguntasXEncuesta.get( pe.Plantilla_encuesta__c );
			}
		}
	}
	
	/*****************************************************************************
	Desarrollado por: Avanxo Colombia
	Autor: Daniel Delgado
	Nombre: actualizarNumeroPregunta
	Parámetro lstPreguntasNew: lista que contiene las preguntas que fueron modificadas
	Parámetro lstPreguntasOld: lista que contiene las cuentas antes de ser modificadas
	Descripción: Método que valida la estructura del campo opciones de respuesta.
	Cambios (Versiones)
	-------------------------------------------------------------------------------
	No.	Fecha		Autor					Descripción
	------ ---------- -------------------------------------------------------------
	1.0	12-22-2014	Daniel Delgado (DD)	Creación del método.
	******************************************************************************/
	public static void validarOpcionesRespuesta( list<AVX_ENC_PreguntaEncuesta__c> lstCuentasNew, list<AVX_ENC_PreguntaEncuesta__c> lstCuentasOld )
	{
		for( AVX_ENC_PreguntaEncuesta__c pe : lstCuentasNew )
		{
			//Set utilizado para validar que no hayan opciones igual dentro de una misma pregunta
			set<String> setOpciones = new set<String>();
			
			if( pe.Opciones_de_respuesta__c != null )
			{
				pe.Opciones_de_respuesta__c.trim();
				list<String> lstOPs = pe.Opciones_de_respuesta__c.split( 'Õ' );
				String strOpcionesFinales = '';
				
				//Por cada opción de respuesta se valida que tenga el formato TEXTOÃVALOR
				for( String strOpcionTemp : lstOPs )
				{
					//Se separan por cada una de las parejas de las opciones el texto y el valor.
					list<String> lstCampo = strOpcionTemp.split( 'Ã' );
					
					//Si cumple con la estructura se valida que la opción sea única
					if( lstCampo.size() == 2 )
					{
						system.debug( 'OPCION ACTUAL: ' + lstCampo + '\nOPCIONES: ' + setOpciones );
						String strOpcion = lstCampo.get( 0 );
						if( setOpciones.contains( lstCampo.get( 0 ).trim().toUpperCase() ) )
							pe.addError( 'La opción de respuesta \'' + strOpcion + '\' se encuentra duplicada.' );
						if( lstCampo.get( 0 ).trim() == '' )
							pe.addError( 'Cada una de las opciones debe tener información.' );
						else
							setOpciones.add( lstCampo.get( 0 ).trim().toUpperCase() );
						
						//Se valida que el valor si sea entero
						try
						{
							Integer intValorOpcion = Integer.valueOf( lstCampo.get( 1 ) );
							strOpcionesFinales += strOpcionesFinales == '' ? '' : 'Õ';
							strOpcionesFinales += strOpcion.trim() + 'Ã' + intValorOpcion;
						}
						catch( system.exception e )
						{
							pe.addError( 'La opción de respuesta \'' + strOpcion + '\' no tiene un formato válido.' );
						}
					}
				}
				
				pe.Opciones_de_respuesta__c = strOpcionesFinales;
			}
		}
	}

	/*****************************************************************************
	Desarrollado por: Avanxo Colombia
	Autor: Daniel Delgado
	Nombre: contarPreguntasOpciones
	Parámetro lstPreguntasNew: lista que contiene las preguntas que fueron modificadas
	Parámetro lstPreguntasOld: lista que contiene las cuentas antes de ser modificadas
	Descripción: Método que calcula el número de preguntas y opciones que tiene cada registro.
	Cambios (Versiones)
	-------------------------------------------------------------------------------
	No.	Fecha		Autor					Descripción
	------ ---------- -------------------------------------------------------------
	1.0	12-22-2014	Daniel Delgado (DD)	Creación del método.
	******************************************************************************/
	public static void contarPreguntasOpciones( list<AVX_ENC_PreguntaEncuesta__c> lstCuentasNew, list<AVX_ENC_PreguntaEncuesta__c> lstCuentasOld )
	{
		ID idPreguntaAbierta = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Abierta' ).getRecordTypeId();
		ID idPreguntaCerrada = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Cerrada' ).getRecordTypeId();
		ID idPreguntaMatricial = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Matricial' ).getRecordTypeId();

		for( AVX_ENC_PreguntaEncuesta__c pe : lstCuentasNew )
		{
			//Conteo de preguntas
			Integer numPreguntas = pe.RecordTypeId != idPreguntaMatricial ? 1 : 0;//Para las preguntas abiertas o cerradas siempre es 1

			if( numPreguntas == 0 )
				numPreguntas = pe.ListaPreguntas__c != null && pe.ListaPreguntas__c.trim() != '' ? pe.ListaPreguntas__c.split( '\\{!Õ}' ).size() : 0;

			pe.NumeroPreguntas__c = numPreguntas;

			//Conteo de opciones
			Integer numOpciones = 0;

			if( pe.Opciones_de_respuesta__c != null && pe.Opciones_de_respuesta__c.trim() != null )
				numOpciones = pe.Opciones_de_respuesta__c.split( 'Õ' ).size();
				
			pe.NumeroOpciones__c = numOpciones;
		}
	}



	/*****************************************************************************
	Desarrollado por: Avanxo Colombia
	Autor: Daniel Delgado
	Nombre: validarPreguntas
	Parámetro lstPreguntasNew: lista que contiene las preguntas que fueron modificadas
	Parámetro lstPreguntasOld: lista que contiene las cuentas antes de ser modificadas
	Descripción: Método que valida si una pregunta es válida dependiendo su tipo.
	Cambios (Versiones)
	-------------------------------------------------------------------------------
	No.	Fecha		Autor					Descripción
	------ ---------- -------------------------------------------------------------
	1.0	12-22-2014	Daniel Delgado (DD)	Creación del método.
	******************************************************************************/
	public static void validarPreguntas( list<AVX_ENC_PreguntaEncuesta__c> lstCuentasNew, list<AVX_ENC_PreguntaEncuesta__c> lstCuentasOld )
	{
		ID idPreguntaAbierta = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Abierta' ).getRecordTypeId();
		ID idPreguntaCerrada = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Cerrada' ).getRecordTypeId();
		ID idPreguntaMatricial = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Matricial' ).getRecordTypeId();

		for( AVX_ENC_PreguntaEncuesta__c pe : lstCuentasNew )
		{
			//Preguntas abiertas siempre son válidas
			if( pe.RecordTypeId == idPreguntaAbierta )
				pe.esValida__c = true;
			else if( pe.RecordTypeId == idPreguntaCerrada )
				pe.esValida__c = pe.NumeroOpciones__c > 0;
			else if( pe.RecordTypeId == idPreguntaMatricial )
				pe.esValida__c = pe.NumeroOpciones__c > 0 && pe.NumeroPreguntas__c > 0;
		}
	}
}