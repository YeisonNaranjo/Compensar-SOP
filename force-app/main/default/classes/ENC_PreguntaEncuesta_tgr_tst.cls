@isTest
private class ENC_PreguntaEncuesta_tgr_tst {
	
	@isTest static void test_method_one() {
		AVX_ENC_PlantillaEncuesta__c pl = COM_DataGenerator_cls.generarPlantillaAlone(true);
		AVX_ENC_PreguntaEncuesta__c pe = COM_DataGenerator_cls.preguntaEncuesta(true, pl.Id);
	}

}