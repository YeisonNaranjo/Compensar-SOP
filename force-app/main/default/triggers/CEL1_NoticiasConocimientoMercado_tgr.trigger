/************************************************************************************************
Desarrollado por:  Globant
Autor:             Paula Bohórquez (PB)
Proyecto:          Compensar
Descripción:       Trigger del objeto Noticias Conocimiento Mercadeo

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     12/03/20         Paula Bohórquez  (PB)                    Creación Clase.
**************************************************************************************************/

trigger CEL1_NoticiasConocimientoMercado_tgr on CEL1_NoticiasConocimientoMercado__c (after update) {
	if(Trigger.isAfter){
        if (Trigger.isUpdate) {
            CEL1_NoticiasConocMercadoHandler_cls.afterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }    
}