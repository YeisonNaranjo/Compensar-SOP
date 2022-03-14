/****************************************************************************************************
    Información general
    -------------------
    author: Daniel Alejandro López Monsalve
    email: dlopez@avanxo.com
    company: Avanxo Colombia
    Project: Compensar
    Customer: Rhino
    Description: Proceso batch para actualizar los campos es migrado, fecha de migración y función (Como representante
                 legal).
    
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       22-Sept-2017     Daniel Alejandro López       Creación de la Clase
****************************************************************************************************/
global class COM_ActualizarRelCuentaContacto_bch implements Database.Batchable<sObject>  {
    
    global String query {get;set;}
    
    global COM_ActualizarRelCuentaContacto_bch() 
    {

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String recordTypeId = String.valueOf(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Natural').getRecordTypeId());
        return Database.getQueryLocator([ 
            Select  Id
            From    AccountContactRelation
            Where   Account.RecordTypeId =:recordTypeId AND Roles EXCLUDES ('Representante Legal')]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {   
        List<AccountContactRelation> lstActRel = new List<AccountContactRelation>(); 
        for (sObject s : scope) {
                 AccountContactRelation actRel = (AccountContactRelation) s;
                 actRel.COM_FechaMigracion__c = Date.today();
                 actRel.COM_EsMigrado__c = true;
                 actRel.Roles = Label.COM_IdentificadorRepresentanteLegal;
                 lstActRel.add(actRel);                
        }
        update lstActRel;
    }
    
    global void finish( Database.BatchableContext BC ) 
    {
        
        
    }

}