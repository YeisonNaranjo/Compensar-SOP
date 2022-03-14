@isTest
private class ENC_VisualizarPregunta_tst
{
	static testMethod void ENC_VisualizarPregunta_tst(){
		AVX_ENC_PreguntaEncuesta__c enc = new AVX_ENC_PreguntaEncuesta__c();
		enc.RecordTypeId = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Matricial' ).getRecordTypeId();
		enc.ListaPreguntas__c = 'a. Montaje y organización del evento{!Õ}b. Estado del escenario donde se realizó el evento{!Õ}c. Condiciones de aseo y orden del escenario';
		Apexpages.Standardcontroller ctrTest = new Apexpages.Standardcontroller(enc);
		ENC_VisualizarPregunta_ctr ctrClass = new ENC_VisualizarPregunta_ctr( ctrTest );
	}

	static testMethod void ENC_VisualizarPregunta_tst2(){
		AVX_ENC_PreguntaEncuesta__c enc = new AVX_ENC_PreguntaEncuesta__c();
		enc.ListaPreguntas__c = 'a. Montaje y organización del evento{!Õ}b. Estado del escenario donde se realizó el evento{!Õ}c. Condiciones de aseo y orden del escenario';
		Apexpages.Standardcontroller ctrTest = new Apexpages.Standardcontroller(enc);
		ENC_VisualizarPregunta_ctr ctrClass = new ENC_VisualizarPregunta_ctr( ctrTest );
	}
}