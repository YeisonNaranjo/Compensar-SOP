/************************************************************************************************
Desarrollado por:  Globant
Autor:             Stifen Panche (SP)
Proyecto:          Compensar
Descripción:       Trigger del objeto Encuestas de Monitoreo

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     02/04/2020         Stifen Panche  (SP)     Creación Trigger.
**************************************************************************************************/

trigger RF2_EncuestaMonitoreo_tgr on Encuestas_de_Monitoreo__c (before insert, before update) {
    
     if (Trigger.isBefore) {
          if(Trigger.isInsert){
              RF2_EncuestaMonitoreo_cls.calcularNotasFinales(Trigger.new);
          }
         
         if(Trigger.isUpdate){
             RF2_EncuestaMonitoreo_cls.calcularNotasFinales(Trigger.new);
          }
     }
    
    

}