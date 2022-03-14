/************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Daniel Delgado
Descripción:		Clase para generar registros que serán utilizados en las clases de prueba

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
	No.		Fecha			Autor					Descripción
----------  -------------	----------------------	---------------------------------------------
	1.0		12-22-2014		Daniel Delgado			Creación de la clase.
************************************************************************************************/
public class ENC_DataGenerator_cls
{
	public static AVX_ENC_PlantillaEncuesta__c crearPlantillaEncuesta(boolean hacerInsert)
	{
		
		AVX_ENC_PlantillaEncuesta__c objEncuesta = new AVX_ENC_PlantillaEncuesta__c();
		objEncuesta.Name = 'Encuesta de clase de prueba';
		objEncuesta.Descripcion__c = 'Descripción de clase de prueba';
		objEncuesta.Activo__c = false;
		objEncuesta.Encabezado__c ='Encabezado de clase de prueba';
		objEncuesta.Pie_pagina__c = ' Pie de encuesta de clase de prueba';
		objEncuesta.Cierre_encuesta__c = 'Cierre de encuesta de clase de prueba';
		
		if( hacerInsert )
			insert objEncuesta;
			
		return objEncuesta;
	}
	
	public static AVX_ENC_PreguntaEncuesta__c crearPregunta( Boolean hacerInsert, String idEncuesta, String strRTDeveloperName )
	{
		ID idRT = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( strRTDeveloperName ).getRecordTypeId();
		AVX_ENC_PreguntaEncuesta__c objPregunta = new AVX_ENC_PreguntaEncuesta__c();
		objPregunta.Plantilla_Encuesta__c = idEncuesta;
		objPregunta.RecordTypeId = idRT;
		objPregunta.Name = 'Resumen pregunta clase de prueba';
		objPregunta.Pregunta__c = 'Pregunta clase de prueba';
		objPregunta.Tipo_pregunta__c = strRTDeveloperName == 'Abierta' ? Label.ENC_007_Pregunta_texto : Label.ENC_008_Pregunta_casilla;
		objPregunta.Orientacion__c = strRTDeveloperName == 'Abierta' ? '' : 'Vertical';
		objPregunta.Opciones_de_respuesta__c = strRTDeveloperName == 'Abierta' ? '' : 'OPCION_1Ã1ÕOPCION_2Ã2';
		objPregunta.ListaPreguntas__c = strRTDeveloperName != 'Matricial' ? '' : 'Pregunta 1{!Õ}Pregunta 2';
		
		if( hacerInsert )
			insert objPregunta;
			
		return objPregunta;
	}
	
	public static AVX_ENC_Encuesta__c crearEncuesta( Boolean hacerInsert, String idEncuesta )
	{
		RecordType rtRespuesta = [ Select Id From RecordType Where sObjectType = 'AVX_ENC_Encuesta__c' and DeveloperName = 'Pendiente_respuesta' limit 1 ];
		AVX_ENC_Encuesta__c objRespuesta = new AVX_ENC_Encuesta__c();
		objRespuesta.RecordTypeId = rtRespuesta.id;
		objRespuesta.Plantilla_Encuesta__c = idEncuesta;
		
		if( hacerInsert )
			insert objRespuesta;
			
		return objRespuesta;
	}
}