public class COS_HistoricoEstadosLeadSaludHelper_cls {
    public static void resetNoGestionLead_mtd(list<COS_HistoricoEstadosProspectoSalud__c> lstNewHistorico, map<Id,COS_HistoricoEstadosProspectoSalud__c> mapOldHistorico){
        double dblTiempoTopEstado = 0;
        double dblTiempoEstado = 0;
        Datetime startDT;
        Datetime endDT;
        Long difference;
        Double hoursEstado = 0;
        double diasEstado = 0;
        Id businessHourId = [SELECT Id FROM BusinessHours WHERE Name = 'Compensar'].Id;
        list<string> idProspecto = new list<string>();
        
        map<string, decimal> mapANS_Salud = new map<string, decimal>();
        for(COS_ANSSalud__mdt ans:[select COS_Estado__c, COS_TiempoEstado__c from COS_ANSSalud__mdt]){
            mapANS_Salud.put(ans.COS_Estado__c, ans.COS_TiempoEstado__c);
        }
        
        for(COS_HistoricoEstadosProspectoSalud__c h:lstNewHistorico){
            if(h.COS_FechaFin__c!=null && mapOldHistorico.get(h.Id).COS_FechaFin__c==null){
                idProspecto.add(h.COS_IDProspecto__c);
				dblTiempoTopEstado = mapANS_Salud.get(h.COS_EstadoInicial__c);
                startDT = h.COS_FechaInicio__c;
                endDT = h.COS_FechaFin__c;
                difference = BusinessHours.diff(businessHourId, startDT, endDT);
                hoursEstado = difference/3600000;
                system.debug('hours --->'+hoursEstado);
                diasEstado = hoursEstado/8;
                system.debug('diasEstado --->'+diasEstado);
                if(diasEstado < dblTiempoTopEstado){
                    h.COS_Dias_en_el_estado__c = diasEstado;
                }
            }
            if(idProspecto.size()>0){
                list<lead> lstLead = [select id, name, COS_ProspectoNoGestionado__c from lead where id in:idProspecto];
                
                for(lead ld:lstLead){
                    ld.COS_ProspectoNoGestionado__c = false;
                }
                update lstLead;
                system.debug('lstLead --->'+lstLead);
            }
        }
    }
}