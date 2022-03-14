/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Trigger para los archivos adjuntos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/19      Juan David Uribe Ruiz   Creación Clase.
    1.1     2018/06/18      Stifen Panche (SP)      Validación de tareas archivos adjuntos.
************************************************************************************************/
trigger RF2_Attachment_tgr on Attachment (before delete) {
	
	RF2_Attachment_cls objRF2Attachment = new RF2_Attachment_cls();
	objRF2Attachment.validarEliminarAdjunto(trigger.old);
	/*Inicio 1.1*/
	objRF2Attachment.validarEliminarAdjuntoTarea(trigger.old);
	/*Fin 1.1*/
    
}