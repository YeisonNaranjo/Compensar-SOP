/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz
Proyecto:          Compensar
Descripción:       Clase con la logica para el trigger de OpportunityLineItem

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     05/10/2017      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
public with sharing class COM_OpportunityLineItem_cls {
    
    public static Boolean allow = true;
    
    public static void stopTrigger(){
        allow = false;
    }
    
    public static boolean canIRun(){
        return allow;
    }
    
    public static void startTrigger(){
        allow = false;
    }
    
    public void procesarOpportunityLineItem(list<OpportunityLineItem> lstOLINew, list<OpportunityLineItem> lstOLIOld){
        map<Id, Opportunity> mapOpportunityxOLI;
        map<Id, PricebookEntry> mapPricebookEntryxOLI;
        list<Opportunity> lstOpportunity;
        list<Opportunity> lstOpportunityActualizar;
        list<PricebookEntry> lstPricebookEntry;
        set<Id> setIdOpportunity;
        set<Id> setIdPricebookEntry;
        OpportunityLineItem objOpportunityLineItem;
        Opportunity objOpportunity;
        
        setIdOpportunity = new set<Id>();
        setIdPricebookEntry = new set<Id>();
        for(Integer i = 0; i < lstOLINew.size(); i++){
            setIdOpportunity.add(lstOLINew[i].OpportunityId);
            setIdPricebookEntry.add(lstOLINew[i].PricebookEntryId);
        }
        
        //Se consultan los RecordType asociados a los OpportunityLineItem
        lstOpportunity = [SELECT Id, RecordType.DeveloperName, Name, COM_NombrePYS__c, COM_PYS__c  
                         FROM Opportunity 
                         WHERE Id IN :setIdOpportunity];
        mapOpportunityxOLI = new map<Id, Opportunity>(lstOpportunity);
        
        lstPricebookEntry = [SELECT Id, Product2.RecordType.DeveloperName, Product2.Name, Product2Id  
                             FROM PricebookEntry 
                             WHERE Id IN : setIdPricebookEntry];
        mapPricebookEntryxOLI = new map<Id, PricebookEntry>(lstPricebookEntry);
        
        lstOpportunityActualizar = new list<Opportunity>();
        
        for(Integer i = 0; i < lstOLINew.size(); i++){
            objOpportunityLineItem = lstOLINew[i];
            system.debug('Prueba otro: ' + mapOpportunityxOLI.get(objOpportunityLineItem.OpportunityId).RecordType.DeveloperName);
            if(mapOpportunityxOLI.get(objOpportunityLineItem.OpportunityId).RecordType.DeveloperName.equals('COM_Alojamiento')){
                system.debug('............... RecordType Opportunity = COM_Alojamiento');
                if(objOpportunityLineItem.COM_NumeroNoches__c != null && objOpportunityLineItem.COM_NumeroNoches__c > 0){
                    system.debug('............... objOpportunityLineItem.Quantity: ' + objOpportunityLineItem.Quantity);
                    objOpportunityLineItem.COM_CantidadAnterior__c = objOpportunityLineItem.Quantity;
                    objOpportunityLineItem.Quantity = objOpportunityLineItem.Quantity * objOpportunityLineItem.COM_NumeroNoches__c;
                    system.debug('............... objOpportunityLineItem.COM_CantidadAnterior__c: ' + objOpportunityLineItem.COM_CantidadAnterior__c);
                    system.debug('............... objOpportunityLineItem.Quantity: ' + objOpportunityLineItem.Quantity);
                    system.debug('............... objOpportunityLineItem.COM_NumeroNoches__c: ' + objOpportunityLineItem.COM_NumeroNoches__c);
                }
            }

            if(objOpportunityLineItem.PricebookEntryId != null && mapPricebookEntryxOLI.get(objOpportunityLineItem.PricebookEntryId) != null && mapPricebookEntryxOLI.get(objOpportunityLineItem.PricebookEntryId).Product2 != null){
                if(mapPricebookEntryxOLI.get(objOpportunityLineItem.PricebookEntryId).Product2.RecordType.DeveloperName.equals('COM_Venta_Empresarial') && 
                    (objOpportunityLineItem.COM_TipoRegistroOpp__c.equals('Eventos') 
                        || objOpportunityLineItem.COM_TipoRegistroOpp__c.equals('Alojamiento')
                        || objOpportunityLineItem.COM_TipoRegistroOpp__c.equals('Salud')
                        || objOpportunityLineItem.COM_TipoRegistroOpp__c.equals('Financiero'))){

                    system.debug('............... RecordType Product2 = COM_Venta_Empresarial');
                    //Se debe subir a la oportunidad el Id del producto y el nombre, pero no se debe disparar el trigger de oportunidad
                    objOpportunity = mapOpportunityxOLI.get(objOpportunityLineItem.OpportunityId);
                    objOpportunity.COM_NombrePYS__c = mapPricebookEntryxOLI.get(objOpportunityLineItem.PricebookEntryId).Product2.Name;
                    objOpportunity.COM_PYS__c = mapPricebookEntryxOLI.get(objOpportunityLineItem.PricebookEntryId).Product2Id;
                    lstOpportunityActualizar.add(objOpportunity);
                }else if(objOpportunityLineItem.COM_TipoRegistroOpp__c.equals('Alojamiento')){
                    objOpportunity = mapOpportunityxOLI.get(objOpportunityLineItem.OpportunityId);
                    objOpportunity.COM_PYS__c = mapPricebookEntryxOLI.get(objOpportunityLineItem.PricebookEntryId).Product2Id;
                    
                    if(lstOpportunityActualizar.indexOf(objOpportunity)==-1){
                        lstOpportunityActualizar.add(objOpportunity);
                    }else{
                        system.debug('Lo contiene');
                        lstOpportunityActualizar.set(lstOpportunityActualizar.indexOf(objOpportunity),objOpportunity);
                    }
                    //lstOpportunityActualizar.add(objOpportunity);

                }
            }
        }
        system.debug('lstOpportunityActualizar----->>>>>'+lstOpportunityActualizar);
        if(!lstOpportunityActualizar.isEmpty()){
            COM_OpportunityLineItem_cls.stopTrigger();
            Set<Opportunity> setOpportunitylineitems = new Set<Opportunity>();
            setOpportunitylineitems.addAll(lstOpportunityActualizar);   
            update new List<Opportunity> (setOpportunitylineitems);
            COM_OpportunityLineItem_cls.startTrigger();
        }
        
    }
    
}