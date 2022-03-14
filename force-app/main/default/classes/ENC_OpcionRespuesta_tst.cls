@isTest
private class ENC_OpcionRespuesta_tst
{
	static testMethod void myUnitTest()
	{
		AVX_ENC_PlantillaEncuesta__c plantillaEncuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, plantillaEncuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaPrevia = ENC_DataGenerator_cls.crearPregunta( true, plantillaEncuesta.Id, 'Cerrada' );
		
		Test.startTest();
			ENC_OpcionRespuesta_ctr controller = new ENC_OpcionRespuesta_ctr();
			controller.blnModoEdicion = false;
			controller.strOpciones = pregunta.Opciones_de_respuesta__c;
			controller.strIdPregunta = pregunta.Id;
			list<ENC_OpcionRespuesta_ctr.opcionRespuesta> lstOpcionesRespuesta = controller.lstOpcionesRespuesta;
			
			//Se agrega una opción para poder eliminar una opción
			controller.strIdPreguntaOpcion = preguntaPrevia.Id;
			controller.cargarOpcionesPrgeuntaExistente();
			controller.agregarOpcion();
			controller.agregarOpcion();
			Integer numPos = controller.getNumeroOpciones();
			controller.intPosOP = numPos - 1;
			controller.eliminarOpcion();
			
			//Se crean 2 opciones para poder subir y bajar las opciones
			controller.agregarOpcion();
			controller.agregarOpcion();
			controller.intPosOP = 0;
			controller.bajarOpcion();
			controller.intPosOP = 1;
			controller.subirOpcion();
			
			controller.guardarOpcionesRespuesa();
			
			//Error por opciones repetidas
			lstOpcionesRespuesta = controller.lstOpcionesRespuesta;
			for( ENC_OpcionRespuesta_ctr.opcionRespuesta op : lstOpcionesRespuesta )
				op.strOpcion = 'A';
			controller.guardarOpcionesRespuesa();
			
			//Error por opciones nulas
			lstOpcionesRespuesta = controller.lstOpcionesRespuesta;
			for( ENC_OpcionRespuesta_ctr.opcionRespuesta op : lstOpcionesRespuesta )
				op.strOpcion = '';
			controller.guardarOpcionesRespuesa();
		Test.stopTest();
	}

	static testMethod void metodosEstaticos() {
		AVX_ENC_PlantillaEncuesta__c plantillaEncuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, plantillaEncuesta.Id, 'Cerrada' );

		Test.startTest();
			list<String> lstPlantillas = ENC_OpcionRespuesta_ctr.getListaPlantillas();
			system.assertEquals( 1, lstPlantillas.size() );

			list<String> lstPreguntas = ENC_OpcionRespuesta_ctr.getListaPreguntas( lstPlantillas.get( 0 ).split( 'Ã' ).get( 1 ) );
			system.assertEquals( 1, lstPreguntas.size() );

			list<String> lstOpciones = ENC_OpcionRespuesta_ctr.getListaOpciones( lstPreguntas.get( 0 ).split( 'Ã' ).get( 1 ) );
			system.assertEquals( 2, lstOpciones.size() );

			String strNewOpciones = pregunta.Opciones_de_respuesta__c + 'ÕMi OpcionÃ3';
			ENC_OpcionRespuesta_ctr.guardarOpciones( pregunta.Id, strNewOpciones );
			system.assertNotEquals( pregunta.Opciones_de_respuesta__c, [ Select Opciones_de_respuesta__c From AVX_ENC_PreguntaEncuesta__c Where Id = :pregunta.Id ].Opciones_de_respuesta__c );

			String strNewPreguntas = 'Pregunta 1';
			ENC_OpcionRespuesta_ctr.guardarPreguntas( pregunta.Id, strNewPreguntas );
			system.assertNotEquals( pregunta.ListaPreguntas__c, [ Select ListaPreguntas__c From AVX_ENC_PreguntaEncuesta__c Where Id = :pregunta.Id ].ListaPreguntas__c );
		Test.stopTest();
	}
}