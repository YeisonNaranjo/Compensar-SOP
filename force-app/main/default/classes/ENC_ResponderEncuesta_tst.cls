@isTest
private class ENC_ResponderEncuesta_tst
{
	static testMethod void soloVisualizar()
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		
		Test.startTest();
			Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller( new AVX_ENC_Encuesta__c() );
			Apexpages.currentPage().getParameters().put( 'idEncuesta', encuesta.Id );
			ENC_ResponderEncuesta_ctr ctr = new ENC_ResponderEncuesta_ctr( controller );
			ctr.guardar();
		Test.stopTest();
	}
	
	static testMethod void responderEncuestaAbiertaConError()
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		encuesta.Activo__c = true;
		update encuesta;
		AVX_ENC_Encuesta__c respuesta = ENC_DataGenerator_cls.crearEncuesta( true, encuesta.Id );
		
		Test.startTest();
			Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller( respuesta );
			Apexpages.currentPage().getParameters().put( 'id', respuesta.Id );
			ENC_ResponderEncuesta_ctr ctr = new ENC_ResponderEncuesta_ctr( controller );
			List<ENC_PreguntaInterna_cls> lstPreguntas = ctr.lstPreguntas;
			lstPreguntas.get( 0 ).blnMostrarError = true;
			ctr.guardar();
		Test.stopTest();
	}
	
	static testMethod void responderEncuestaAbiertaSinError()
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		encuesta.Activo__c = true;
		update encuesta;
		AVX_ENC_Encuesta__c respuesta = ENC_DataGenerator_cls.crearEncuesta( true, encuesta.Id );
		
		Test.startTest();
			Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller( respuesta );
			Apexpages.currentPage().getParameters().put( 'id', respuesta.Id );
			ENC_ResponderEncuesta_ctr ctr = new ENC_ResponderEncuesta_ctr( controller );
			ctr.guardar();
		Test.stopTest();
	}
	
	static testMethod void responderEncuestaCerrada()
	{
		ENC_Query_int doQuery = new ENC_Query_imp();
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		encuesta.Activo__c = true;
		update encuesta;
		AVX_ENC_Encuesta__c respuesta = ENC_DataGenerator_cls.crearEncuesta( false, encuesta.Id );
		RecordType rt = (RecordType)doQuery.getSObject( 'RecordType', 'Id, Name', 'sObjectType = \'AVX_ENC_Encuesta__c\' AND DeveloperName <> \'Sin_contestar\' AND DeveloperName <> \'Pendiente_respuesta\'' );
		respuesta.RecordTypeId = rt.Id;
		insert respuesta;
		
		Test.startTest();
			Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller( respuesta );
			Apexpages.currentPage().getParameters().put( 'id', respuesta.Id );
			ENC_ResponderEncuesta_ctr ctr = new ENC_ResponderEncuesta_ctr( controller );
			List<ENC_PreguntaInterna_cls> lstPreguntas = ctr.lstPreguntas;
			lstPreguntas.get( 0 ).blnMostrarError = true;
			ctr.guardar();
		Test.stopTest();
	}
}