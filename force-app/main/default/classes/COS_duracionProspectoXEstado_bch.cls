global class COS_duracionProspectoXEstado_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
	static final string query = 'select id, name, COS_EstadoInicial__c, COS_FechaInicio__c, COS_IDProspecto__c, COS_ProspectoNoGestionado__c, COS_Dias_en_el_estado__c from COS_HistoricoEstadosProspectoSalud__c where COS_FechaFin__c = null and COS_IDProspecto__c != null';
    
    global Database.QueryLocator start(database.BatchableContext DC){
		return database.getQueryLocator(query);
    }
    
    global void execute(database.BatchableContext BC, list<COS_HistoricoEstadosProspectoSalud__c> scope){
//        list<COS_ANSSalud__mdt> lstANS_Salud = [select DeveloperName, MasterLabel, COS_Estado__c, COS_TiempoEstado__c from COS_ANSSalud__mdt];
		double dblTiempoTopEstado = 0;
        double dblTiempoEstado = 0;
        Datetime startDT;
        Datetime endDT;
        Long difference;
        Double hoursEstado = 0;
        double diasEstado = 0;
        system.debug('scope --->'+scope);    
        map<string, decimal> mapANS_Salud = new map<string, decimal>();
        for(COS_ANSSalud__mdt ans:[select COS_Estado__c, COS_TiempoEstado__c from COS_ANSSalud__mdt]){
            mapANS_Salud.put(ans.COS_Estado__c, ans.COS_TiempoEstado__c);
        }
        
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE Name = 'Compensar'].Id;
//        Date dtToday = system.today().addDays(-16);
//        datetime dttToday = datetime.newInstance(dtToday.year(), dtToday.month(), dtToday.day(), 10, 0, 0);
//        Boolean isWithinBusinessHour = BusinessHours.isWithin(businessHourId, dttToday);
		list<string> idProspecto = new list<string>();
        
        for(COS_HistoricoEstadosProspectoSalud__c h:scope){
			dblTiempoTopEstado = mapANS_Salud.get(h.COS_EstadoInicial__c);
            
            startDT = h.COS_FechaInicio__c;
            endDT = DateTime.Now();
            difference = BusinessHours.diff(businessHourId, startDT, endDT);
            hoursEstado = difference/3600000;
            system.debug('hours --->'+hoursEstado);
            diasEstado = hoursEstado/8;
            system.debug('diasEstado --->'+diasEstado);
            
            if(diasEstado < dblTiempoTopEstado){
                h.COS_Dias_en_el_estado__c = diasEstado;
            }else{
                idProspecto.add(h.COS_IDProspecto__c);
                h.COS_Dias_en_el_estado__c = diasEstado;
                h.COS_ProspectoNoGestionado__c = true;
            }
        }
        
        if(idProspecto.size()>0){
            list<lead> lstLead = [select id, name, COS_ProspectoNoGestionado__c from lead where id in:idProspecto];
            
            for(lead ld:lstLead){
                ld.COS_ProspectoNoGestionado__c = true;
            }
            COM_TriggerExecutionControl_cls.setAlreadyDone('CEL1_Lead_tgr','BEFORE');
            COM_TriggerExecutionControl_cls.setAlreadyDone('CEL1_Lead_tgr','AFTER');
            update lstLead;
            system.debug('lstLead --->'+lstLead);
        }
        update scope;
        system.debug('scope update --->'+scope);
    }
    
    global void finish(database.BatchableContext BC){
        
    }
    
}