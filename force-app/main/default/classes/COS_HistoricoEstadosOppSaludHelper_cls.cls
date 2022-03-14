public class COS_HistoricoEstadosOppSaludHelper_cls {
    public static void resetNoGestionLead_mtd(list<Opportunity_stage_history__c> lstNewHistorico, map<Id,Opportunity_stage_history__c> mapOldHistorico){
        system.debug('lstNewHistorico --->'+lstNewHistorico);
        system.debug('mapOldHistorico --->'+mapOldHistorico);
        double dblTiempoTopEstado = 0;
        double dblTiempoEstado = 0;
        Datetime startDT;
        Datetime endDT;
        Long difference;
        Double hoursEstado = 0;
        double diasEstado = 0;
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE Name = 'Compensar'].Id;
        list<string> idProspecto = new list<string>();
        list<string> idOpp = new list<string>();
        map<string,boolean> mapOppGestion = new map<string,boolean>();
        
        map<string, decimal> mapANS_Salud = new map<string, decimal>();
        for(COS_ANSSaludOportunidad__mdt ans:[select COS_Etapa__c, COS_TiempoEtapa__c from COS_ANSSaludOportunidad__mdt]){
            mapANS_Salud.put(ans.COS_Etapa__c, ans.COS_TiempoEtapa__c);
        }
        
        for(Opportunity_stage_history__c h:lstNewHistorico){
            system.debug('h.End_date__c --->'+h.End_date__c);
            system.debug('mapOldHistorico.get(h.Id).End_date__c --->'+mapOldHistorico.get(h.Id).End_date__c);
            
            if(h.End_date__c!=null && mapOldHistorico.get(h.Id).End_date__c==null){
                idOpp.add(h.Opportunity__c);
//                mapOppGestion.put(idOpp,true);
                dblTiempoTopEstado = mapANS_Salud.get(h.Start_stage__c);
                system.debug('dblTiempoTopEstado --->'+dblTiempoTopEstado);
                startDT = h.Start_date__c;
                system.debug('startDT --->'+startDT);
                endDT = h.End_date__c;
                system.debug('endDT --->'+endDT);
                difference = BusinessHours.diff(businessHourId, startDT, endDT);
                system.debug('difference --->'+difference);
                hoursEstado = difference/3600000;
                system.debug('hours --->'+hoursEstado);
                diasEstado = hoursEstado/8;
                system.debug('diasEstado --->'+diasEstado);
                 h.COS_DiasEtapa__c = diasEstado;
//                if(diasEstado < dblTiempoTopEstado){
//                    mapOppGestion.put(idOpp,true);
//                }
            }
            if(idOpp.size()>0){
                list<opportunity> lstOpp = [select id, name, COS_OportunidadNoGestionada__c from opportunity where id in:idOpp];
                
                for(opportunity op:lstOpp){
                    op.COS_OportunidadNoGestionada__c = false;
                }
                update lstOpp;
                system.debug('lstOpp --->'+lstOpp);
            }
        }
    }
}