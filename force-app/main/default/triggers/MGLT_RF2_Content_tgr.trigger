/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Lionner Steven Moque Quintero
Proyecto:          Compensar
Descripción:       Trigger para los archivos adjuntos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2019/09/25      Lionner Steven Moque    Creación Clase.
************************************************************************************************/
trigger MGLT_RF2_Content_tgr on ContentDocument (before /*insert,*/ delete) {
    
    MGLT_RF2_Content_cls objMGLTRF2Content = new MGLT_RF2_Content_cls();
    objMGLTRF2Content.validarEliminarAdjunto(trigger.oldMap);
    /*Inicio 1.1*/
    objMGLTRF2Content.validarEliminarAdjuntoTarea(trigger.oldMap);
    /*Fin 1.1*/
}