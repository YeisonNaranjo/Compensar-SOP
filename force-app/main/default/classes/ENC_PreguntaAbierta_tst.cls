@isTest(SeeAllData=true)
private class ENC_PreguntaAbierta_tst
{
	static testMethod void ENC_PreguntaAbierta()
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		
		pregunta.Pregunta_dependiente__c = preguntaDependiente.Id;
		
		
		String strValue = 'Prueba';
		Boolean blnPrevisua = false;
		pregunta.Tipo_pregunta__c = 'Numérico';
		pregunta.Valor_dependiente__c = 'Si';
		ENC_PreguntaInterna_cls pInterna = new ENC_PreguntaInterna_cls( 1, 1, 'Prueba', pregunta );
		
		Test.startTest();
			ENC_ResponderEncuesta_ctr enc_visualizar = new ENC_ResponderEncuesta_ctr( new Apexpages.Standardcontroller( new AVX_ENC_Encuesta__c() ) );
			
			ENC_PreguntaAbierta_ctr preguntaAbierta = new ENC_PreguntaAbierta_ctr();
			preguntaAbierta.getEstaGuardando();
			preguntaAbierta.ctr = ENC_visualizar;
			preguntaAbierta.preguntaInterna = pInterna;
			preguntaAbierta.preguntaInterna.pregunta.Pregunta_dependiente__c = pregunta.Pregunta_dependiente__c;
			
			preguntaAbierta.getStrRespuesta();
			String strTest=preguntaAbierta.getStrRespuesta();
			boolean bolTest = preguntaAbierta.blnMostrarPregunta;
			preguntaAbierta.setStrRespuesta( strValue );
			preguntaAbierta.blnMostrarPregunta = true;
			preguntaAbierta.getEstaGuardando();
			preguntaAbierta.preguntaInterna.pregunta.Pregunta_dependiente__c = null;
			system.assertEquals( false, preguntaAbierta.preguntaInterna.blnMostrarError );
			pregunta.Tipo_pregunta__c = Label.ENC_003_Pregunta_numerica;
			//Error de tipo de datos
			strValue = 'Prueba';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( true, preguntaAbierta.preguntaInterna.blnMostrarError );
			//Caso correcto
			strValue = '123';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( false, preguntaAbierta.preguntaInterna.blnMostrarError );
			pregunta.Tipo_pregunta__c = Label.ENC_004_Pregunta_fecha;
			//Error de formato
			strValue = 'as/11/2015';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( true, preguntaAbierta.preguntaInterna.blnMostrarError );
			//Fecha correcta
			strValue = '01/01/2015';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( false, preguntaAbierta.preguntaInterna.blnMostrarError );
			//Fecha inválida
			strValue = '31/11/2015';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( true, preguntaAbierta.preguntaInterna.blnMostrarError );
			//Fecha correcto
			strValue = '01/01/2015';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( false, preguntaAbierta.preguntaInterna.blnMostrarError );
			pregunta.Tipo_pregunta__c = Label.ENC_005_Pregunta_email;
			//Correo inválido
			strValue = 'mycorreo';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( true, preguntaAbierta.preguntaInterna.blnMostrarError );
			//Fecha correcto
			strValue = 'micorreo@demo.com';
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( false, preguntaAbierta.preguntaInterna.blnMostrarError );

			preguntaAbierta.preguntaInterna.pregunta.Obligatorio__c = true;
			strValue = null;
			preguntaAbierta.setStrRespuesta( strValue );
			system.assertEquals( true, preguntaAbierta.preguntaInterna.blnMostrarError );
		Test.stopTest();
	}
}