/****************************************************************************************************
    Información general
    -------------------
    author: Daniel Alejandro López Monsalve
    email: dlopez@avanxo.com
    company: Avanxo Colombia
    Project: Implementación Salesforce
    Customer: Compensar RHino
    Description: Clase batch para actualización masiva deL CONTADOR de representantes legales.
                 Solo se utiliza en migración. 
    
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       28-SEO-2017     Daniel Alejandro López       Método para actualización vía batch
****************************************************************************************************/

global without sharing class COM_ActualizarContadorRepLegales_sch implements Schedulable {
    
    global void execute( SchedulableContext sc ) 
    {
        COM_ActualizarContadorRepLegales_bch batchProcess = new COM_ActualizarContadorRepLegales_bch();
        database.executebatch(batchProcess,999);
    }
 }