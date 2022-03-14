/****************************************************************************************************
    Información general
    -------------------
    author: Daniel Alejandro López Monsalve
    email: dlopez@avanxo.com
    company: Avanxo Colombia
    Project: Compensar
    Customer: Rhino
    Description: Proceso batch para actualizar el campo contador de representantes legales en la cuenta, 
                 como ultimo paso de la migración.
                 Solo se usa para migración. 
    
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       22-Sept-2017     Daniel Alejandro López       Creación de la Clase
    1.1       31-Octu-2017     Juan David Uribe Ruiz        Se agrega filtro a la consulta del QueryLocator
****************************************************************************************************/
global class COM_ActualizarContadorRepLegales_bch implements Database.Batchable<sObject>  {
    
    global String query {get;set;}
    
    global COM_ActualizarContadorRepLegales_bch() 
    {

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator([ 
            Select  Id
            From    Account 
          Where COM_CantidadLegales__c = NULL]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {   
        Account objAccount = new Account(); 
        List<Account> listActualizar = new List<Account>();
        for (sObject s : scope) {
                 
                 objAccount = (Account) s;
                 listActualizar.add(objAccount);    
                 
                 
                 
        }
        COM_UtilidadesMigracion_cls  objUtil = new COM_UtilidadesMigracion_cls();
        objUtil.contadorRepLegalesBatch(listActualizar);
        
    }
    
    global void finish( Database.BatchableContext BC ) 
    {
        
        
    }

}