/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase Helper para el Trigger COM_Account_tgr
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     18/06/21        Jorge Pozo (JPA)		Creación Clase.
**************************************************************************************************/
public without sharing class RL2_AccountHelper_cls {
    
    /**
    * @Method:      asignacionMiembroDeEquipo
    * @param:       List<Account> listNewAccounts
    * @Description: Crea un Miembro de Equipo a la Cuenta (Júridico o Natural) creada,
    * 				el Miembro de Equipo tiene el rol de Asesor PAF y este llega a ser
    * 				el propietario del Lead (Prospecto Afiliación Caja) encontrado por 
    * 				Tipo y Número de Documento. Ademas eliminar el anterior Asesor PAF
    * @author       Jorge Pozo (JPA) - 18/06/21
    */
    public static void asignacionMiembroDeEquipo(List<Account> listNewAccounts) {
        List<AccountTeamMember> listAccTeamDel = new List<AccountTeamMember>();
        List<AccountTeamMember> listMembersIns = new List<AccountTeamMember>();
        Map<String, Lead> mapLeadLlave = new Map<String, Lead>();
        Set<String> setTipoDocumento = new Set<String>();
        Set<String> setNumDocumento = new Set<String>();
        Set<Id> accIds = new Set<Id>();
        
        UserRole roleOwner = [SELECT Name FROM UserRole WHERE Id IN (SELECT UserRoleId FROM User WHERE Id =: UserInfo.getUserId())]; 
        List<RecordType> lstRecordType = [SELECT DeveloperName, Id FROM RecordType WHERE SobjectType = 'Account'];
        Map<String,Id> mapRecordType = new Map<String,Id>();
        
        for (RecordType objRecord: lstRecordType) {
            mapRecordType.put(objRecord.DeveloperName, objRecord.Id);
        }
        
        for(Account acc: listNewAccounts) {
            if(acc.RecordTypeId == mapRecordType.get('COM_Natural') || acc.RecordTypeId == mapRecordType.get('COM_Juridico')) {
                if(acc.CEL1_OrigenEsProspecto__c == False) {
                    setTipoDocumento.add(acc.COM_TipoIdentificacion__c);
                    setNumDocumento.add(acc.COM_Numero_de_identificacion__c);
                }
            }
        }
        
        for(Lead lead: [SELECT Id, OwnerId, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c 
                                FROM Lead
                                WHERE CEL1_TipoDocumento__c IN:setTipoDocumento 
                                AND CEL1_NumeroDocumento__c IN:setNumDocumento
                                AND RecordType.DeveloperName = 'RL2_ProspectoAfiliacionCaja' AND IsConverted = FALSE]) {
            mapLeadLlave.put(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c, lead);
        }
        
        for(Account acc: listNewAccounts) {
            if(mapLeadLlave.containsKey(acc.COM_TipoIdentificacion__c + acc.COM_Numero_de_identificacion__c)){
                Lead lead = mapLeadLlave.get(acc.COM_TipoIdentificacion__c + acc.COM_Numero_de_identificacion__c);
                listMembersIns.add(new AccountTeamMember(AccountId = acc.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId = lead.OwnerId, AccountAccessLevel = 'Edit'));
                accIds.add(acc.Id);
            }
        }
        
        AccountTeamMember accTeammUpd;
        for(AccountTeamMember accTeamMember: [SELECT Id, AccountId, UserId 
                                              FROM AccountTeamMember 
                                              WHERE AccountId IN:accIds 
                                              AND TeamMemberRole =:Label.COM_PAF_TypeTeamAsesor]) {
            listAccTeamDel.add(accTeamMember);
        }
        
        try {
            if(listAccTeamDel.size() > 0)
                delete listAccTeamDel;
            
            if(listMembersIns.size() > 0)
                insert listMembersIns;
        } catch(Exception e) {
            System.debug('Error in RL2_AccountHelper_cls.asignacionMiembroDeEquipo() ===> ' + e.getMessage());
        }
    }
    
    /**
    * @Method:      actualizarTipoRegistro
    * @param:       List<Account> listNewAccounts
    * @Description: Actualiza el tipo de regitro de la Cuenta en base al Tipo de Identificación
    * 				en caso viniera de un Lead
    * @author       Jorge Pozo (JPA) - 08/07/21
    */
    public static void actualizarTipoRegistro(List<Account> listNewAccounts) {
        List<RecordType> lstRecordType = [SELECT DeveloperName, Id FROM RecordType WHERE SobjectType = 'Account'];
        Map<String,Id> mapRecordType = new Map<String,Id>();
        
        for (RecordType objRecord: lstRecordType) {
            mapRecordType.put(objRecord.DeveloperName, objRecord.Id);
        }
        
        for(Account acc: listNewAccounts) {
            if(acc.RecordTypeId == mapRecordType.get('COM_Natural') || acc.RecordTypeId == mapRecordType.get('COM_Juridico')) {
                if(acc.CEL1_OrigenEsProspecto__c == True) {
                    if(acc.AccountSource != null) {
                        if(acc.AccountSource == 'Call Center' || acc.AccountSource == 'Chat' || acc.AccountSource == 'Atención Presencial') {
                            if(acc.COM_TipoIdentificacion__c == '2') {
                                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('COM_Juridico').getRecordTypeId(); 
                            } else if(acc.COM_TipoIdentificacion__c == '1' || acc.COM_TipoIdentificacion__c == '4' || acc.COM_TipoIdentificacion__c == '5' || acc.COM_TipoIdentificacion__c == '10' || acc.COM_TipoIdentificacion__c == '11' || acc.COM_TipoIdentificacion__c == '14') {
                                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('COM_Natural').getRecordTypeId();
                            }
                        }
                    }
                }
            }
        }
    }

}