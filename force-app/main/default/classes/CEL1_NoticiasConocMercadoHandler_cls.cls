/************************************************************************************************
Desarrollado por:  Globant
Autor:             Paula Bohórquez (PB)
Proyecto:          Compensar
Descripción:       Handler del objeto Noticias Conocimiento Mercadeo

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     12/03/20         Paula Bohórquez  (PB)                    Creación Clase.
**************************************************************************************************/

public class CEL1_NoticiasConocMercadoHandler_cls {

        
    public static void afterUpdate(Map<Id,CEL1_NoticiasConocimientoMercado__c> mapNewNoticias,Map<Id,CEL1_NoticiasConocimientoMercado__c> mapOldNoticias)
    
    {
        CEL1_NoticiasConocMercadoHelper_cls.crearPublicacionChatter(mapNewNoticias,mapOldNoticias);
    }
    
}