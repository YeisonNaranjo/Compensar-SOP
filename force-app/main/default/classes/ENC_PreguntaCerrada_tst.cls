@isTest(SeeAllData=true)
private class ENC_PreguntaCerrada_tst 
{
	static testMethod void ENC_PreguntaCerrada() 
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		
		pregunta.Pregunta_dependiente__c = preguntaDependiente.Id;
		
		String strValue = 'PruebaÃ1';
		pregunta.Tipo_pregunta__c = 'Lista';
		pregunta.Valor_dependiente__c = 'Si';
		List<SelectOption> lstOption = new List<SelectOption>();
		List<String> lstStr = new List<String>();
		lstStr.add('PruebaÃ1');
		lstStr.add('PruebaÃ2');
		ENC_PreguntaInterna_cls pInterna = new ENC_PreguntaInterna_cls( 1, 1, 'Prueba', pregunta );
		
		Test.startTest();
			ENC_ResponderEncuesta_ctr ENC_visualizar = new ENC_ResponderEncuesta_ctr( new Apexpages.Standardcontroller( new AVX_ENC_Encuesta__c() ) );
			
			Boolean blnPrevisua = false;
			ENC_PreguntaCerrada_ctr preguntaCerrada = new ENC_PreguntaCerrada_ctr();
			preguntaCerrada.ctr = null;
			preguntaCerrada.getEstaGuardando();
			preguntaCerrada.preguntaInterna = pInterna;
			preguntaCerrada.preguntaInterna.pregunta.Pregunta_dependiente__c = pInterna.pregunta.Pregunta_dependiente__c;
			Boolean blnMostrar = preguntaCerrada.blnMostrarPregunta;
			preguntaCerrada.getLstOpciones();
			preguntaCerrada.setLstOpciones(lstOption);

			pregunta.Tipo_pregunta__c = Label.ENC_008_Pregunta_casilla;
			preguntaCerrada.getLstRespuestasSeleccionadas();

			preguntaCerrada = new ENC_PreguntaCerrada_ctr();
			preguntaCerrada.ctr = ENC_visualizar;
			preguntaCerrada.preguntaInterna = pInterna;
			preguntaCerrada.preguntaInterna.pregunta.Pregunta_dependiente__c = pInterna.pregunta.Pregunta_dependiente__c;
			blnMostrar = preguntaCerrada.blnMostrarPregunta;
			preguntaCerrada.getLstOpciones();
			preguntaCerrada.setLstOpciones(lstOption);
			preguntaCerrada.preguntaInterna.pregunta.Pregunta_dependiente__c = null;

			pregunta.Tipo_pregunta__c = Label.ENC_008_Pregunta_casilla;
			preguntaCerrada.preguntaInterna.pregunta.Obligatorio__c = false;
			preguntaCerrada.getLstRespuestasSeleccionadas();
			preguntaCerrada.setLstRespuestasSeleccionadas(lstStr);
			system.assertEquals( false, preguntaCerrada.preguntaInterna.blnMostrarError );


			preguntaCerrada.preguntaInterna.pregunta.Obligatorio__c = true;
			preguntaCerrada.setLstRespuestasSeleccionadas( null );
			system.assertEquals( true, preguntaCerrada.preguntaInterna.blnMostrarError );

			pregunta.Tipo_pregunta__c = Label.ENC_009_Pregunta_lista;
			preguntaCerrada.preguntaInterna.pregunta.Obligatorio__c = false;
			preguntaCerrada.getStrRespuesta();
			strValue = 'Mi opciónÃ1';
			preguntaCerrada.setStrRespuesta(strValue);
			system.assertEquals( false, preguntaCerrada.preguntaInterna.blnMostrarError );

			preguntaCerrada.preguntaInterna.pregunta.Obligatorio__c = true;
			strValue = null;
			preguntaCerrada.setStrRespuesta(strValue);
			system.assertEquals( true, preguntaCerrada.preguntaInterna.blnMostrarError );

			preguntaCerrada.actualizarPregunta();
			preguntaCerrada.getEstaGuardando();
		Test.stopTest();
	}
}