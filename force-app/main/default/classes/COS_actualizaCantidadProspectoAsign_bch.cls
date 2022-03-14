global class COS_actualizaCantidadProspectoAsign_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
    global Database.QueryLocator start(database.BatchableContext DC){
		
        map<string,string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Lead']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        system.debug('mapRecordType --->'+mapRecordType);
        return database.getQueryLocator([select id, name, OwnerId, ConvertedDate from lead where RecordTypeId=:mapRecordType.get('COS_ProspectoSalud') and ConvertedDate=:system.today()]);
    }
    
    global void execute(database.BatchableContext BC, list<lead> scope){
        system.debug('scope --->'+scope);
        map<string,integer> mapLeadAssign = new map<string,integer>();
        integer intNoAsignados = 0;
        integer intNoConvertidos = 0;
        
        for(lead ld:scope){
            if(mapLeadAssign.keyset().contains(ld.OwnerId)){
                intNoConvertidos = integer.valueof(mapLeadAssign.get(ld.OwnerId))+1;
                mapLeadAssign.put(ld.OwnerId,intNoConvertidos);
            }else{
                mapLeadAssign.put(ld.OwnerId,1);
            }
        }
        
        set<string> lstIdUser = mapLeadAssign.keyset();
        list<User> lstUser = [select id, name, COS_No_Prospectos_asignados__c from user where id in:lstIdUser];
        for(User us:lstUser){
            intNoAsignados = integer.valueof(us.COS_No_Prospectos_asignados__c);
            us.COS_No_Prospectos_asignados__c = intNoAsignados - integer.valueof(mapLeadAssign.get(us.Id));
        }
        update lstUser;
    }
    
    global void finish(database.BatchableContext BC){
        
    }
}