/****************************************************************************************************
Información general
-------------------
author: Yeison Naranjo
email: yeison.naranjo@globant.com
company: Globant Colombia
Description: Clase COM_ActualizarCodARL_bch para Actualización de Código ARL

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       05-Febrero-2020 Yeison Naranjo               Creación de la Clase
****************************************************************************************************/
global class COM_ActualizarCodARL_bch implements Database.Batchable<sObject>, Database.stateful{
    
    global integer counter = 0;
    
    global COM_ActualizarCodARL_bch() {
        system.debug('Entra actualizar Código de ARL');
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([ 
            SELECT  Id, COM_EsARL__c, COM_CodigoARL__c
            FROM    Account
            WHERE   COM_EsARL__c = false and COM_CodigoARL__c != Null]);        
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Account> LstCtaUpd = new List<Account>();
        for (Account cta : scope) {
            cta.COM_CodigoARL__c = Null;
            LstCtaUpd.add(cta);            
        }
        Update LstCtaUpd;
        List<Database.SaveResult> results = Database.update(LstCtaUpd , false);
        for(Database.SaveResult result : results){
            if(result.isSuccess()){
                counter++;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Registros actualizados: ' + counter);
    }    
}