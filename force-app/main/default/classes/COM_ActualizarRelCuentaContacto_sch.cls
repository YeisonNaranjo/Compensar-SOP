/****************************************************************************************************
    Información general
    -------------------
    author: Daniel Alejandro López Monsalve
    email: dlopez@avanxo.com
    company: Avanxo Colombia
    Project: Implementación Salesforce
    Customer: Compensar RHino
    Description: Clase batch para actualización masiva de la relación cuenta contacto en migración.
    
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       22-Dic-2016     Daniel Alejandro López       Método para actualización vía batch
****************************************************************************************************/

global without sharing class COM_ActualizarRelCuentaContacto_sch implements Schedulable {
    
    global void execute( SchedulableContext sc ) 
    {
        COM_ActualizarRelCuentaContacto_bch batchProcess = new COM_ActualizarRelCuentaContacto_bch();
        database.executebatch(batchProcess,149);
    }
    
    
    
    
}