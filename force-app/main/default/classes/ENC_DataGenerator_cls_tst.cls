@isTest
private class ENC_DataGenerator_cls_tst {
	
	@isTest static void test_method_one() {
		AVX_ENC_PlantillaEncuesta__c pl = ENC_DataGenerator_cls.crearPlantillaEncuesta(true);
		AVX_ENC_PreguntaEncuesta__c pr1 = ENC_DataGenerator_cls.crearPregunta(true, pl.id, 'Abierta'); 
		AVX_ENC_PreguntaEncuesta__c pr2 = ENC_DataGenerator_cls.crearPregunta(true, pl.id, 'Matricial'); 
	}
	
	@isTest static void test_method_two() {
		AVX_ENC_PlantillaEncuesta__c pl = ENC_DataGenerator_cls.crearPlantillaEncuesta(true);
		AVX_ENC_PreguntaEncuesta__c pr1 = ENC_DataGenerator_cls.crearPregunta(true, pl.id, 'Abierta'); 
		pl.Activo__c = true;
		update pl;
		AVX_ENC_Encuesta__c enc = ENC_DataGenerator_cls.crearEncuesta(true, pl.id);
	}
	
}