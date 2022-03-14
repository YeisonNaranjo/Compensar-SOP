/*******************************************************************************
Desarrollado por:  Avanxo Colombia 
Autor:   <Manuel Mendez> 
Proyecto:  <Compensar Celula> 
Descripción:  Clase Schedulable para el batch CEL1_ActualizarLogCorreo_bch

Cambios (Versiones)     
-------------------------------------     
No.     Fecha        Autor                        Descripción     
------  ----------   --------------------------   -----------     
1.0     09-12-2019   Manuel Mendez                Create Class      
*******************************************************************************/
global class CEL1_ActualizarLogCorreo_bch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('Entro a batch start....');
        DateTime dtaFecha = System.now();
        DateTime dtaFechaBuscar = dtaFecha.addHours(-2);
        // DateTime dtaFechaBuscar = dtaFecha.addDays(-5);
        return Database.getQueryLocator([SELECT Id,
                                        ActivityId,
                                        FirstOpenedDate,
                                        IsOpened,
                                        LastOpenedDate 
                                        FROM EmailMessage
                                        WHERE FirstOpenedDate <=:dtaFecha
                                        AND FirstOpenedDate >=:dtaFechaBuscar]);
                
    }

    global void execute(Database.BatchableContext BC, List<EmailMessage> lstEmailMessage) 
    {
        System.debug('lstEmailMessage....'+lstEmailMessage);
        Set<Id> setIdActivity = new Set<Id>();
        for (EmailMessage objEMS: lstEmailMessage) {
            setIdActivity.add(objEMS.ActivityId);
        }

        List<Task> lstTask = [SELECT Id,
                            Status,
                            WhatId,
                            WhoId
                            FROM Task
                            WHERE Id IN: setIdActivity];
        Map<Id,Id> mapTaskLead = new Map<Id,Id>();
        for(Task objTarea: lstTask)
        {
            mapTaskLead.put(objTarea.Id,objTarea.WhoId);
        }
        System.debug('mapTaskLead---->>>>>'+mapTaskLead);
        List<Log_Correo_Electronico__c> lstLogCorreoElec = [SELECT Id,
                                                            CEL1_Candidato__c
                                                            FROM Log_Correo_Electronico__c
                                                            WHERE CEL1_Candidato__c IN: mapTaskLead.values()];
        System.debug('lstLogCorreoElec....'+lstLogCorreoElec);
        Map<Id,Id> mapLogLead = new Map<Id,Id>();
        for(Log_Correo_Electronico__c objLogCorreo : lstLogCorreoElec){
            System.debug('objLogCorreo.CEL1_Candidato__c....'+objLogCorreo.CEL1_Candidato__c);
            System.debug('objLogCorreo.Id....'+objLogCorreo.Id);
            if (objLogCorreo.CEL1_Candidato__c != null) {
                mapLogLead.put(objLogCorreo.CEL1_Candidato__c,objLogCorreo.Id);
            }
        }
        System.debug('mapLogLead.....'+mapLogLead);
        System.debug('mapTaskLead....'+mapTaskLead);
        List<Log_Correo_Electronico__c> lstLogCorreo = new List<Log_Correo_Electronico__c>();
        for (EmailMessage objEMS2: lstEmailMessage) {
            if(objEMS2.IsOpened && mapLogLead.get(mapTaskLead.get(objEMS2.ActivityId)) != null){
                lstLogCorreo.add(new Log_Correo_Electronico__c(Id=mapLogLead.get(mapTaskLead.get(objEMS2.ActivityId)), CEL1_Candidato__c = mapTaskLead.get(objEMS2.ActivityId), Estado__c= 'Abierto', CEL1_FechaAbierto__c= objEMS2.FirstOpenedDate));
            }
        }
        System.debug('lstLogCorreo....'+lstLogCorreo);
        if(!lstLogCorreo.isEmpty())
            update lstLogCorreo;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'CEL1_ActualizarLogCorreo_bch - finish' + '   <<<<<<<<<<\n-=#=-\n');
    }    
}