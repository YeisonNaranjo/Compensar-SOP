global class COS_duracionOportunidadXEstado_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
	static final string strRecordTypeOppSalud = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COS_ConsorcioSalud').getRecordTypeId();
    static final string query = 'select id, name, Start_date__c, Start_stage__c, End_date__c, Opportunity__c, COS_OportunidadNoGestionada__c, COS_DiasEtapa__c from Opportunity_stage_history__c where End_date__c = null and Opportunity__c != null and Opportunity__r.RecordTypeId =:strRecordTypeOppSalud';
    
    global Database.QueryLocator start(database.BatchableContext DC){
		return database.getQueryLocator(query);
    }
    
    global void execute(database.BatchableContext BC, list<Opportunity_stage_history__c> scope){
//        list<COS_ANSSalud__mdt> lstANS_Salud = [select DeveloperName, MasterLabel, COS_Estado__c, COS_TiempoEstado__c from COS_ANSSalud__mdt];
		double dblTiempoTopEstado = 0;
        double dblTiempoEstado = 0;
        Datetime startDT;
        Datetime endDT;
        Long difference;
        Double hoursEstado = 0;
        double diasEstado = 0;
        map<string, decimal> mapANS_Salud = new map<string, decimal>();
        for(COS_ANSSaludOportunidad__mdt ans:[select COS_Etapa__c, COS_TiempoEtapa__c from COS_ANSSaludOportunidad__mdt]){
            mapANS_Salud.put(ans.COS_Etapa__c, ans.COS_TiempoEtapa__c);
        }
        
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE Name = 'Compensar'].Id;
//        Date dtToday = system.today().addDays(-16);
//        datetime dttToday = datetime.newInstance(dtToday.year(), dtToday.month(), dtToday.day(), 10, 0, 0);
//        Boolean isWithinBusinessHour = BusinessHours.isWithin(businessHourId, dttToday);
		list<string> idProspecto = new list<string>();
        list<string> idOpp= new list<string>();
        
        for(Opportunity_stage_history__c h:scope){
			dblTiempoTopEstado = mapANS_Salud.get(h.Start_stage__c);
            
            startDT = h.Start_date__c;
            endDT = DateTime.Now();
            difference = BusinessHours.diff(businessHourId, startDT, endDT);
            hoursEstado = difference/3600000;
            diasEstado = hoursEstado/8;
            
            if(diasEstado < dblTiempoTopEstado){
                h.COS_DiasEtapa__c = diasEstado;
            }else{
                idOpp.add(h.Opportunity__c);
                h.COS_DiasEtapa__c = diasEstado;
                h.COS_OportunidadNoGestionada__c = true;
            }
        }
        
        if(idOpp.size()>0){
            list<opportunity> lstOpp = [select id, name, COS_OportunidadNoGestionada__c from opportunity where id in:idOpp];
            
            for(opportunity op:lstOpp){
                op.COS_OportunidadNoGestionada__c = true;
            }
            update lstOpp;
		}
        update scope;
    }
    
    global void finish(database.BatchableContext BC){
        
    }
    
}