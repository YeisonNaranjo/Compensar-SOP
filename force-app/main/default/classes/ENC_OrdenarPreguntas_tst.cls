@isTest
private class ENC_OrdenarPreguntas_tst 
{
	static testMethod void myUnitTest()
	{
		AVX_ENC_PlantillaEncuesta__c encuesta = ENC_DataGenerator_cls.crearPlantillaEncuesta( true );
		AVX_ENC_PreguntaEncuesta__c pregunta1 = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Abierta' );
		AVX_ENC_PreguntaEncuesta__c pregunta2 = ENC_DataGenerator_cls.crearPregunta( true, encuesta.Id, 'Abierta' );
		
		Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller( encuesta );
	
		Test.startTest();
			ENC_OrdenarPreguntas_ctr controller = new ENC_OrdenarPreguntas_ctr(stdController);
			controller.idsOrdenados = '' + pregunta1.Id + ';' + pregunta2.Id;
			controller.ordenar();
		Test.stopTest();
	}
}