/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para realizar notificaciones de paz y salvo
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     28/07/2017      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.1     24/09/2019      Paula Bohórquez (PB)            Migración Lightning - Se reemplazan Attachments por Content Documents.
*************************************************************************************************************/

global class COM_NotificacionPazYSalvo_cls implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Map<Id, AccountContactRelation> mapClientes = new Map<Id, AccountContactRelation>();
        List<Opportunity> lstOpps = new List<Opportunity>([SELECT Id, AccountId 
                FROM Opportunity 
                WHERE COM_Vencimiento60diashabiles__c = :Date.Today().addDays(5)]);
        for(Opportunity opp : lstOpps){
            mapClientes.put(opp.AccountId,null);
        }
        List<AccountContactRelation> lstContactsRel = [SELECT Id, ContactId, AccountId, Contact.Account.COM_CorreoElectronico__c 
                FROM AccountContactRelation 
                WHERE AccountId IN :mapClientes.keySet() AND Roles INCLUDES ('Representante Legal') AND isActive = true LIMIT 1];
        for(AccountContactRelation acr : lstContactsRel){
            mapClientes.put(acr.AccountId, acr);
        }
        for(Id idContacto : mapClientes.keySet()){
            if(mapClientes.get(idContacto) != null && mapClientes.get(idContacto).Contact.Account.COM_CorreoElectronico__c != ''){
                COM_UtilidadCorreo_cls.enviarCorreoTemplate(new Set<String>{mapClientes.get(idContacto).Contact.Account.COM_CorreoElectronico__c}, 
                                                            new List<ContentVersion>(), 'COM_PlantillaNotificacionVencimientoPazSalvo', 
                                                            mapClientes.get(idContacto).ContactId, idContacto);
            }
        }

    }

}