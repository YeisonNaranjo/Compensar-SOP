@isTest( seeAllData=true )
private class ENC_CrearEditarPregunta_tst
{
	static testMethod void myUnitTest()
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		AVX_ENC_PreguntaEncuesta__c preguntaDependiente = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Cerrada' );
		
		pregunta.Pregunta_dependiente__c = preguntaDependiente.Id;
		pregunta.Valor_dependiente__c = 'OPCION_1';
		
		Test.startTest();
			Apexpages.Standardcontroller stdCtr = new Apexpages.Standardcontroller( pregunta );
			Apexpages.currentPage().getParameters().put( 'retURL', '/home/home.jsp' );
			Apexpages.currentPage().getParameters().put( 'RecordType', pregunta.RecordTypeId );
			ENC_CrearEditarPregunta_ctr controller = new ENC_CrearEditarPregunta_ctr( stdCtr );

			list<Selectoption> lstValoresDependientes = controller.lstValoresDependientesDisponibles;
			controller.getNumValoresDependientes();
			controller.getNumPreguntasDependientes();
			controller.actualizarPagina();
			
			list<Selectoption> lstValoresSeleccionados = new list<Selectoption>();
			lstValoresSeleccionados.add( new Selectoption( 'OPCION_1', '1' ) );
			controller.lstValoresDependientesSeleccionados = lstValoresSeleccionados;
			
			controller.save();
		Test.stopTest();
	}
}