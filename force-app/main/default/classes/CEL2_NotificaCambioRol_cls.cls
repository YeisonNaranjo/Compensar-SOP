/************************************************************************************************
Desarrollado por:  Globant
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase  CEL2_NotificaCambioRol_cls para Trigger COM_AccountContactRelation_tgr
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     24/04/20         Manuel Mendez  (MM)                        Creación Clase.
**************************************************************************************************/
public with sharing class CEL2_NotificaCambioRol_cls {
    public static void notificarCambio(List<AccountContactRelation> lstNewACR,List<AccountContactRelation> lstOldACR) {
        System.debug('ENTRO A notificarCambio...');
        System.debug('lstNewACR...'+lstNewACR);
        System.debug('lstOldACR...'+lstOldACR);
        List<Task> lstTareas = new List<Task>();
        Set<Id> setId = new Set<Id>();
        for(AccountContactRelation acc:lstNewACR){
            setId.add(acc.AccountId);
        }
        System.debug('setId....'+setId);
        List<AccountTeamMember> lstATM = [SELECT AccountId,
                                            TeamMemberRole,
                                            UserId 
                                            FROM AccountTeamMember 
                                            WHERE AccountId IN: setId 
                                            AND TeamMemberRole =: label.CEL2_EspecialistMercadeo];
        System.debug('lstATM....'+lstATM);    
        Map<Id,Id> mapUser = new Map<Id,Id>();
        for(AccountTeamMember objATM: lstATM){
            mapUser.put(objATM.AccountId,objATM.UserId);
        }
        System.debug('mapUser....'+mapUser);    

        for (Integer i = 0; i < lstNewACR.size(); i++) {
            System.System.debug('lstNewACR[i].Roles....'+lstNewACR[i].Roles);
            System.System.debug('lstOldACR[i].Roles....'+lstOldACR[i].Roles);
            if(lstNewACR[i].Roles != lstOldACR[i].Roles && lstOldACR[i].Roles != null && label.CEL2_RolesNotificacion.contains(lstOldACR[i].Roles)){
                if(mapUser.containsKey(lstNewACR[i].AccountId)){
                    System.debug('ENTRO PORQ CONTIENE EL MAPA...');
                    Task tempTask = new Task(Description = label.CEL2_ComentarioRolAct+' '+lstNewACR[i].Roles,
                                            Priority = 'Normal',
                                            Subject = label.CEL2_CambioRol,
                                            IsReminderSet = true,
                                            // WhoId = lctemp.getLeadId(),
                                            RF2_Comentarios_de_cierre__c = label.CEL2_ComentarioRolAct+' '+lstNewACR[i].Roles,
                                            WhatId = lstNewACR[i].AccountId,
                                            RF2_Nombre_del_cliente__c = lstNewACR[i].AccountId,
                                            ReminderDateTime = System.now(),
                                            OwnerId =  mapUser.get(lstNewACR[i].AccountId));             
                    lstTareas.add(tempTask);
                }else {
                    Task tempTask = new Task(Description = label.CEL2_ComentarioRolAct+' '+lstNewACR[i].Roles,
                                            Priority = 'Normal',
                                            Subject = label.CEL2_CambioRol,
                                            IsReminderSet = true,
                                            // WhoId = lctemp.getLeadId(),
                                            RF2_Comentarios_de_cierre__c = label.CEL2_ComentarioRolAct+' '+lstNewACR[i].Roles,
                                            WhatId = lstNewACR[i].AccountId,
                                            RF2_Nombre_del_cliente__c = lstNewACR[i].AccountId,
                                            ReminderDateTime = System.now());
                                            // OwnerId =  mapUser.get(lstNewACR[i].AccountId));             
                    lstTareas.add(tempTask);
                }
            }
        }
        System.debug('lstTareas....'+lstTareas);
        if (!lstTareas.isEmpty()) {
            insert lstTareas;
        }
    }

    public static void notificarCambioDelete(List<AccountContactRelation> lstOldACR) {
        System.debug('ENTRO A notificarCambio...');
        // System.debug('lstNewACR...'+lstNewACR);
        System.debug('lstOldACR...'+lstOldACR);
        // List<Task> lstTareas = new List<Task>();
        Set<Id> setId = new Set<Id>();
        for(AccountContactRelation acc:lstOldACR){
            setId.add(acc.AccountId);
        }
        System.debug('setId....'+setId);
        List<AccountTeamMember> lstATM = [SELECT AccountId,
                                            TeamMemberRole,
                                            UserId 
                                            FROM AccountTeamMember 
                                            WHERE AccountId IN: setId 
                                            AND TeamMemberRole =: label.CEL2_EspecialistMercadeo];
        System.debug('lstATM....'+lstATM);    
        Map<Id,Id> mapUser = new Map<Id,Id>();
        for(AccountTeamMember objATM: lstATM){
            mapUser.put(objATM.AccountId,objATM.UserId);
        }
        System.debug('mapUser....'+mapUser);   
        List<Task> lstTareas = new List<Task>();
        for(AccountContactRelation objACR: lstOldACR){
            if (label.CEL2_RolesNotificacion.contains(objACR.Roles)) {
                if(mapUser.containsKey(objACR.AccountId)){
                    Task tempTask = new Task(Description = Label.CEL2_ComentarioRolElim+' '+objACR.Roles,
                                        Priority = 'Normal',
                                        Subject = label.CEL2_CambioRol,
                                        IsReminderSet = true,
                                        // WhoId = lctemp.getLeadId(),
                                        RF2_Comentarios_de_cierre__c = Label.CEL2_ComentarioRolElim+' '+objACR.Roles,
                                        WhatId = objACR.AccountId,
                                        RF2_Nombre_del_cliente__c = objACR.AccountId,
                                        ReminderDateTime = System.now(),
                                        OwnerId =  mapUser.get(objACR.AccountId));             
                lstTareas.add(tempTask);
                }else{
                    Task tempTask = new Task(Description = Label.CEL2_ComentarioRolElim+' '+objACR.Roles,
                                        Priority = 'Normal',
                                        Subject = label.CEL2_CambioRol,
                                        IsReminderSet = true,
                                        // WhoId = lctemp.getLeadId(),
                                        RF2_Comentarios_de_cierre__c = Label.CEL2_ComentarioRolElim+' '+objACR.Roles,
                                        WhatId = objACR.AccountId,
                                        RF2_Nombre_del_cliente__c = objACR.AccountId,
                                        ReminderDateTime = System.now());
                                        // OwnerId =  mapUser.get(objACR.AccountId));             
                lstTareas.add(tempTask);
                }
            }
        }
        if (!lstTareas.isEmpty()) {
            insert lstTareas;
        }
    }
}