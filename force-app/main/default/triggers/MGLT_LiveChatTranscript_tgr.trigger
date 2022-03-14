/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Luis Rafael Peñaranda (LRP)
Proyecto:          Compensar
Descripción:       Trigger del objeto LiveChatTranscript

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/11/19             Luis Rafael Peñaranda (LRP)             Creación Clase.
************************************************************************************************/
trigger MGLT_LiveChatTranscript_tgr on LiveChatTranscript (before insert, before update) {
    if (Trigger.isInsert && Trigger.isBefore) 
    {
        MGLT_LiveChatTranscript_cls.asociarClienteATranscripcion(Trigger.New);
    }  
    
    if (Trigger.isupdate && Trigger.isBefore) 
    {             
        MGLT_LiveChatTranscript_cls.cambiarPropietarioCaso(Trigger.New, Trigger.oldMap);
        MGLT_LiveChatTranscript_cls.actualizarConsultaTranscripcion(Trigger.New);
    }  
}