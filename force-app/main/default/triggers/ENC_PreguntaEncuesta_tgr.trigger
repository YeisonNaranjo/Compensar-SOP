trigger ENC_PreguntaEncuesta_tgr on AVX_ENC_PreguntaEncuesta__c (before insert, before update){
	if( Trigger.isBefore )
	{
		if( Trigger.isInsert || Trigger.isUpdate )
		{
			ENC_PreguntaEncuesta_cls.validarOpcionesRespuesta( Trigger.new, Trigger.old );
			ENC_PreguntaEncuesta_cls.actualizarNumeroPregunta( Trigger.new, Trigger.old );
			ENC_PreguntaEncuesta_cls.contarPreguntasOpciones( Trigger.new, Trigger.old );
			ENC_PreguntaEncuesta_cls.validarPreguntas( Trigger.new, Trigger.old );
		}
	}
}