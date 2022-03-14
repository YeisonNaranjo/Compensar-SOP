/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Daniel Alejandro López Monsalve (DALM)
Proyecto:          Compensar
Descripción:       Trigger del objeto AVX_Encuesta

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/09/17             Daniel Alejandro López Monsalve (DL)  Creación Clase.
************************************************************************************************/
trigger COM_AVX_Encuesta_tgr on AVX_ENC_Encuesta__c 
    (
        before insert, 
        before update 
    ) 
{
   
    if (Trigger.isBefore) 
                {
                    if(Trigger.isInsert ||  Trigger.isUpdate)
                    {
                        //ENC_Utils_cls  objEncuesta = new ENC_Utils_cls();
                        ENC_Utils_cls.consultarCliente(Trigger.new);
                        System.debug('Asignar la cuenta a la encuesta');
                    }
                    
                
                } 
                    
}