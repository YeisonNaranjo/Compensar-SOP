public without sharing class COS_reasignacionGrupo_cls {
    //--- Reasignación cuentas
    public static boolean reasignacionCuenta_mtd(list<account> lstAcc, list<user> lstUser, set<Id> memIds, string idUser){
        system.debug('--- reasignacionCuenta_mtd ---');
        system.debug('lstAcc --->'+lstAcc);
        system.debug('lstUser --->'+lstUser);
        system.debug('memIds --->'+memIds);
        system.debug('idUser --->'+idUser);
        boolean response = false;
        integer intTopCtasReasignadas = 0;
        integer intCtasReasignadas = 0;
        integer intCtasAssignadas = 0;
        string idAccount = '';
        string keyFind = '';
        string oldOwnerId = '';
        map<string, string> mapRecordTypeOpp = new map<string, string>();
        map<string, AccountTeamMember> mapATM = new map<string, AccountTeamMember>();
        list<AccountTeamMember> lstATM_delete = new list<AccountTeamMember>();
        list<AccountTeamMember> lstATM_new = new list<AccountTeamMember>();
        list<AccountTeamMember> lstATM_find = new list<AccountTeamMember>();
        AccountTeamMember newATM = new AccountTeamMember();
        list<opportunity> lstOppUpdate = new list<opportunity>();
        list<opportunity> lstOppUser = new list<opportunity>();
        list<string> idATM = new list<string>();
        user regUser = new user();
        
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
            mapRecordTypeOpp.put(rt.DeveloperName, rt.id);
        }
        lstATM_find = [select id, accountId, UserId from AccountTeamMember where TeamMemberRole = 'COS_AsesorConsorcioSalud' and AccountId in:memIds];
        if(lstATM_find.size()>0){
            for(AccountTeamMember atm:lstATM_find){
                string key = string.valueOf(atm.accountId)+string.valueof(atm.UserId);
               // mapATM.put(key,atm);
               mapATM.put(atm.accountId, atm);
            }
        }
            
        
        if(idUser != 'N/A'){
            regUser = [select id, name, COS_No_Cuentas_reasignadas__c from user where id=:idUser];
            lstUser = new list<user>();
        }
        
        for(account ac:lstAcc){
            //oldOwnerId = ac.ownerId;
            idAccount = ac.id;
            keyFind = string.valueof(idAccount);
            if(mapATM.containsKey(keyFind)){
            	oldOwnerId = mapATM.get(keyFind).UserId;
            	system.debug('oldOwnerid --->'+oldOwnerId);    
            }
            // keyFind = string.valueof(idAccount)+string.valueof(oldOwnerId);
            
            newATM = new AccountTeamMember();
            //--- Asignación por distribución en grupo de coordinador
            if(lstUser.size()>0){
                system.debug('--- asignacion por cargas ---');
                intTopCtasReasignadas = integer.valueof(lstUser[lstUser.size()-1].COS_No_Cuentas_reasignadas__c);
                if(intTopCtasReasignadas==null){intTopCtasReasignadas=0;}
                for(user us:lstUser){
                    //if(ac.ownerId != us.Id){
                    if(oldOwnerId != us.Id){
                        intCtasReasignadas = integer.valueof(us.COS_No_Cuentas_reasignadas__c);
                        if(intCtasReasignadas==null){intCtasReasignadas = 0;}
                        if(intCtasReasignadas <= intTopCtasReasignadas){
                      //      keyFind = string.valueof(ac.id)+string.valueof(oldOwnerId);
                      //      system.debug('keyFind --->'+keyFind);
                            if(us.COS_No_Cuentas_reasignadas__c == null){us.COS_No_Cuentas_reasignadas__c = 1;}
                            else{us.COS_No_Cuentas_reasignadas__c = intCtasReasignadas + 1;}
                            
                            newATM.UserId 					= 	us.Id;
                            newATM.AccountId 				= 	ac.Id;
                            newATM.AccountAccessLevel       =   'Edit';
                            newATM.CaseAccessLevel          =   'Edit';
                            newATM.OpportunityAccessLevel	=   'Edit';
                            newATM.TeamMemberRole           =   'COS_AsesorConsorcioSalud';
                            lstATM_new.add(newATM);
                            
                            system.debug('keyFind --->'+keyFind);
                            if(mapATM.containsKey(keyFind)){
                            	system.debug('mapATM.get(keyFind) --->'+mapATM.get(keyFind));
                            	idATM.add(mapATM.get(keyFind).id); 
                            }
                            //   lstATM_delete.add(mapATM.get(keyFind));
                            lstOppUser = new list<opportunity>();
                           // lstOppUser = [select id, name, OwnerId from opportunity where AccountId =: ac.Id and OwnerId=:oldOwnerId and IsClosed=false];  //RecordTypeId = mapRecordTypeOpp.get('COS_ConsorcioSalud')
                            lstOppUser = [select id, name, OwnerId from opportunity where AccountId =: ac.Id and RecordTypeId=:mapRecordTypeOpp.get('COS_ConsorcioSalud') and IsClosed=false];
                            if(lstOppUser.size()>0){
                                for(opportunity op:lstOppUser){
                                    op.OwnerId = us.Id;
                                    lstOppUpdate.add(op);
                                }
                            }
                            break;
                        }    
                    }
                }
            }
            //--- Asignación a asesor seleccionado
            if(idUser != 'N/A'){
                system.debug('--- asignacion a unico asesor ---');
                //if(ac.ownerId != idUser){
                system.debug('oldOwnerId --->'+oldOwnerId);
                system.debug('idUser --->'+idUser);
                if(oldOwnerId != idUser){
//                    oldOwnerId = ac.ownerId;
                    newATM.UserId 					= 	regUser.Id;
                    newATM.AccountId 				= 	ac.Id;
                    newATM.AccountAccessLevel       =   'Edit';
                    newATM.CaseAccessLevel          =   'Edit';
                    newATM.OpportunityAccessLevel	=   'Edit';
                    newATM.TeamMemberRole           =   'COS_AsesorConsorcioSalud';
                    lstATM_new.add(newATM);
                    intCtasAssignadas = intCtasAssignadas + 1;
                    
                    if(mapATM.containsKey(keyFind)){
                        system.debug('mapATM.get(keyFind) --->'+mapATM.get(keyFind));
                        idATM.add(mapATM.get(keyFind).id);
                    }
          //          lstATM_delete.add(mapATM.get(keyFind));
                    lstOppUser = new list<opportunity>();
                   // lstOppUser = [select id, name, OwnerId from opportunity where AccountId =: ac.Id and OwnerId=:oldOwnerId and IsClosed=false];
                    lstOppUser = [select id, name, OwnerId from opportunity where AccountId =: ac.Id and RecordTypeId=:mapRecordTypeOpp.get('COS_ConsorcioSalud') and IsClosed=false];
					system.debug('lstOppUser --->'+lstOppUser);                            
                    if(lstOppUser.size()>0){
                        for(opportunity op:lstOppUser){
                            op.OwnerId = idUser;
                            lstOppUpdate.add(op);
                        }
                    }
                }
            }
        }
        if(intCtasAssignadas > 0){
            system.debug('regUser.COS_No_Cuentas_reasignadas__c --->'+regUser.COS_No_Cuentas_reasignadas__c);
            if(regUser.COS_No_Cuentas_reasignadas__c == null){
                regUser.COS_No_Cuentas_reasignadas__c = intCtasAssignadas;
            }else{
        		regUser.COS_No_Cuentas_reasignadas__c = integer.valueof(regUser.COS_No_Cuentas_reasignadas__c) + intCtasAssignadas;
            }
			lstUser.add(regUser);    
        }
        system.debug('idATM --->'+idATM);
        if(idATM.size() > 0){
            lstATM_delete = new list<AccountTeamMember>();
            lstATM_delete = [select id, accountId, UserId from AccountTeamMember where id in:idATM];
        }
        
        try{
            system.debug('lstUser --->'+lstUser);
            system.debug('lstATM_new --->'+lstATM_new);
            system.debug('lstOppUpdate --->'+lstOppUpdate);
            system.debug('lstATM_delete --->'+lstATM_delete);
        	update lstUser;
        	insert lstATM_new;
            if(lstOppUpdate.size()>0){update lstOppUpdate;}
            if(lstATM_delete.size()>0){delete lstATM_delete;}
            
            response = true;
        }catch(Exception e){
            system.debug('Exception --->'+e);
            response = false;
        }   
        system.debug('response --->'+response);
        return response;
    }
    
    //--- Reasignación oportunidades salud
    public static boolean reasignacionOportunidad_mtd(list<opportunity> lstOpp, list<user> lstUser, set<Id> memIds, string idUser){
        system.debug('--- reasignacionOportunidad_mtd ---');
        system.debug('lstOpp --->'+lstOpp);
        system.debug('lstUser --->'+lstUser);
        system.debug('memIds --->'+memIds);
        system.debug('idUser --->'+idUser);
        boolean response = false;
        integer intTopOppReasignadas = 0;
        integer intOppReasignadasUs = 0;
        integer intCtasAssignadas = 0;
        string idOpportunity = '';
        string oldOwnerId = '';
        map<string, string> mapRecordTypeOpp = new map<string, string>();
        user regUser = new user();
        
        if(idUser != 'N/A'){
            regUser = [select id, name, COS_No_Oportunidades_reasignadas__c from user where id=:idUser];
            lstUser = new list<user>();
        }
        
        for(opportunity op:lstOpp){
            //--- Asignación por distribución en grupo de coordinador
            if(lstUser.size()>0){
                intTopOppReasignadas = integer.valueof(lstUser[lstUser.size()-1].COS_No_Oportunidades_reasignadas__c);
                if(intTopOppReasignadas==null){intTopOppReasignadas = 0;}
                system.debug('intTopOppReasignadas --->'+intTopOppReasignadas);
                for(user us:lstUser){
                    if(op.OwnerId != us.Id){
                        intOppReasignadasUs = integer.valueof(us.COS_No_Oportunidades_reasignadas__c);
                        
                        if(intOppReasignadasUs==null){intOppReasignadasUs=0;}
                        system.debug('us.Id --->'+us.Id+'  --//--  intOppReasignadasUs --->'+intOppReasignadasUs);
                        if(intOppReasignadasUs <= intTopOppReasignadas){
                            op.OwnerId = us.id;
                            if(us.COS_No_Oportunidades_reasignadas__c == null){
                                us.COS_No_Oportunidades_reasignadas__c = 1;
                            }else{
                                us.COS_No_Oportunidades_reasignadas__c = intOppReasignadasUs + 1;
                            }
                            break;
                        }    
                    }
                }
            }
            //--- Asignación a asesor seleccionado
            if(idUser != 'N/A'){
                if(op.OwnerId != idUser){
                    op.OwnerId = idUser;
                    intCtasAssignadas = intCtasAssignadas + 1;
                }
            }
        }

        if(intCtasAssignadas > 0){
            system.debug('regUser.COS_No_Oportunidades_reasignadas__c --->'+regUser.COS_No_Oportunidades_reasignadas__c);
            if(regUser.COS_No_Oportunidades_reasignadas__c == null){
                regUser.COS_No_Oportunidades_reasignadas__c = intCtasAssignadas;
            }else{
        		regUser.COS_No_Oportunidades_reasignadas__c = integer.valueof(regUser.COS_No_Oportunidades_reasignadas__c) + intCtasAssignadas;
            }
			lstUser.add(regUser);    
        }
        try{
            system.debug('lstUser --->'+lstUser);
        	update lstUser;
            update lstOpp;
            response = true;
        }catch(Exception e){
            system.debug('Exception --->'+e);
            system.debug('Exception --->'+e.getMessage());
            response = false;
        }   
        system.debug('response --->'+response);
        return response;
    }
    
    
    //--- Reasignación prospectos salud
	public static boolean reasignacionProspecto_mtd(list<lead> lstLead, list<user> lstUser, set<Id> memIds, string idUser){
        system.debug('--- reasignacionOportunidad_mtd ---');
        system.debug('lstLead --->'+lstLead);
        system.debug('lstUser --->'+lstUser);
        system.debug('memIds --->'+memIds);
        system.debug('idUser --->'+idUser);
        boolean response = false;
        integer intTopLeadReasignados = 0;
        integer intLeadReasignadasUs = 0;
        integer intLeadAssignadas = 0;
        string idLead = '';
        string oldOwnerId = '';
        map<string, string> mapRecordTypeLead = new map<string, string>();
        user regUser = new user();
        
        if(idUser != 'N/A'){
            regUser = [select id, name, COS_No_Cuentas_reasignadas__c, COS_No_Prospectos_asignados__c from user where id=:idUser];
            lstUser = new list<user>();
        }
        
        for(lead ld:lstLead){
            //--- Asignación por distribución en grupo de coordinador
            if(lstUser.size()>0){
                intTopLeadReasignados = integer.valueof(lstUser[lstUser.size()-1].COS_No_Prospectos_asignados__c);
                if(intTopLeadReasignados==null){intTopLeadReasignados = 0;}
                system.debug('intTopLeadReasignados --->'+intTopLeadReasignados);
                for(user us:lstUser){
                    if(ld.OwnerId != us.Id){
                        intLeadReasignadasUs = integer.valueof(us.COS_No_Prospectos_asignados__c);
                        if(intLeadReasignadasUs==null){intLeadReasignadasUs=0;}
                        system.debug('intLeadReasignadasUs --->'+intLeadReasignadasUs);
                        system.debug('us.COS_No_Prospectos_asignados__c --->'+us.COS_No_Prospectos_asignados__c);
                        if(intLeadReasignadasUs <= intTopLeadReasignados){
                            ld.OwnerId = us.id;
                            if(us.COS_No_Prospectos_asignados__c == null){
                                us.COS_No_Prospectos_asignados__c = 1;
                            }else{
                                us.COS_No_Prospectos_asignados__c = intLeadReasignadasUs + 1;
                            }
                            break;
                        }    
                    }
                }
            }
            //--- Asignación a asesor seleccionado
            if(idUser != 'N/A'){
                if(ld.OwnerId != idUser){
                    ld.OwnerId = idUser;
                    intLeadAssignadas = intLeadAssignadas + 1;
                }
            }
        }
		system.debug('intLeadAssignadas --->'+intLeadAssignadas);
        if(intLeadAssignadas > 0){
            system.debug('regUser.COS_No_Prospectos_asignados__c --->'+regUser.COS_No_Prospectos_asignados__c);
            if(regUser.COS_No_Prospectos_asignados__c == null){
                regUser.COS_No_Prospectos_asignados__c = intLeadAssignadas;
            }else{
        		regUser.COS_No_Prospectos_asignados__c = integer.valueof(regUser.COS_No_Prospectos_asignados__c) + intLeadAssignadas;
            }
			lstUser.add(regUser);    
        }
        try{
            system.debug('lstUser --->'+lstUser);
        	update lstUser;
            update lstLead;
            response = true;
        }catch(Exception e){
            system.debug('Exception --->'+e);
            response = false;
        }   
        system.debug('response --->'+response);
        return response;
        }
}