/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Tirgger encargado de validar si una encuestra perteneciente a una transcripicon no 
				   tenia asociado un caso, de ser asi lo asocia al caso de la transcripcion

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                            Descripción
----------  ----------   ----------------------------  ------------------------------------------
    1.0     17/11/2017   Juan David Uribe Ruiz (JDUR)  Creación Clase.
************************************************************************************************/ 
trigger RF2_LiveChatTranscript_tgr on LiveChatTranscript (after insert) {
	
	RF2_LiveChatTranscript_cls logicaLiveChatTranscript;
	
	if (Trigger.isAfter && Trigger.isInsert) {
		logicaLiveChatTranscript = new RF2_LiveChatTranscript_cls();
		logicaLiveChatTranscript.procesarTranscripcionAfterInsert(Trigger.new);
	}
    
}