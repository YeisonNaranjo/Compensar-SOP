/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase Helper para la clase Handler CEL1_LeadHandler_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     18/06/21        Jorge Pozo (JPA)		Creación Clase.
**************************************************************************************************/
public without sharing class RL2_LeadHelper_cls {
    
    /**
    * @Method:      validarCandidatoDuplicado
    * @param:       List<Lead> listNewLead
    * @Description: Valida Leads (Prospecto Afiliación Caja) duplicados 
    * 				en base a los campos Tipo de Documento, Número de Documento, 
    * 				Estado (Nuevo y En gestión) y Tipo de Aportante
    * @author       Jorge Pozo (JPA) - 18/06/21
    */
    public static void validarCandidatoDuplicado(List<Lead> listNewLead) {
        Set<String> setNumDocumento = new Set<String>();
        Set<String> setTipoDocumento = new Set<String>();
        Set<String> setLlave = new Set<String>();
        
        String strRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        
        for(Lead lead: listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == strRecordTypeAfiliacionCaja){
                    setTipoDocumento.add(lead.CEL1_TipoDocumento__c);
                    setNumDocumento.add(lead.CEL1_NumeroDocumento__c);
                }
            }
        }
        
        for(Lead lead: [SELECT Id, Status, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, RL2_TipoDeSolicitud__c 
                        FROM Lead 
                        WHERE CEL1_TipoDocumento__c IN:setTipoDocumento 
                        AND CEL1_NumeroDocumento__c IN:setNumDocumento
                        AND Status IN ('Nuevo', 'EnGestion') 
                        AND RecordType.DeveloperName = 'RL2_ProspectoAfiliacionCaja']) {
            setLlave.add(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c + lead.RL2_TipoDeSolicitud__c);
        }
        
        for(Lead lead: listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == strRecordTypeAfiliacionCaja){
                    if(setLlave.contains(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c + lead.RL2_TipoDeSolicitud__c)){
                        lead.addError(Label.RL2_CandidatoExistente);
                    }
                }
            }
        }
    }
    
    /**
    * @Method:      asignarPropietarioDeCuenta
    * @param:       List<Lead> listNewLead
    * @Description: Asigna propietario al Lead (Prospecto Afiliación Caja) creado y 
    * 				crea Miembro de Equipo en caso existiera una Cuenta sin Miembro 
    * 				de Equipo con el mismo Tipo y Númeor de Documento
    * @author       Jorge Pozo (JPA) - 18/06/21
    */
    public static void asignarPropietarioDeCuenta(List<Lead> listNewLead) {
        Map<String, AccountTeamMember> mapAccountTeamMemberLlave = new Map<String, AccountTeamMember>();
        List<AccountTeamMember> listAccMemberIns = new List<AccountTeamMember>();
        List<Lead> listLeadUpd = new List<Lead>();
        List<User> listUserUpd = new List<User>();
        Map<String, Account> mapAccountLlave = new Map<String, Account>();
        Map<String, Lead> mapLeadLlave = new Map<String, Lead>();
        Set<String> setNumDocumento = new Set<String>();
        Set<String> setTipoDocumento = new Set<String>();
        Set<String> setLlave = new Set<String>();
        Set<Id> setIdAcc = new Set<Id>();
        Integer intTopLeadReasignadosEmp;
        Integer intLeadReasignadasEmp;
        Integer intTopLeadReasignadosSede;
        Integer intLeadReasignadasSede;
        
        List<RecordType> lstRecordType = [SELECT DeveloperName, Id FROM RecordType WHERE SobjectType = 'Lead'];
        Map<String,Id> mapRecordType = new Map<String,Id>();
        
        for (RecordType objRecord: lstRecordType) {
            mapRecordType.put(objRecord.DeveloperName, objRecord.Id);
        }
        
        for(Lead lead: listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == mapRecordType.get('RL2_ProspectoAfiliacionCaja')) {
                    setTipoDocumento.add(lead.CEL1_TipoDocumento__c);
                    setNumDocumento.add(lead.CEL1_NumeroDocumento__c);
                }
            }
        }
        
        for(Lead lead: [SELECT Id, OwnerId, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c 
                        FROM Lead 
                        WHERE CEL1_TipoDocumento__c IN:setTipoDocumento 
                        AND CEL1_NumeroDocumento__c IN:setNumDocumento 
                        AND RecordType.DeveloperName = 'RL2_ProspectoAfiliacionCaja'
                        AND isConverted = False]) {
            mapLeadLlave.put(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c, lead);
        }
        
        for(Account acc: [SELECT Id, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c 
                          FROM Account 
                          WHERE COM_TipoIdentificacion__c IN:setTipoDocumento 
                          AND COM_Numero_de_identificacion__c IN:setNumDocumento 
                          AND RecordType.DeveloperName IN ('COM_Natural', 'COM_Juridico')]) {
            mapAccountLlave.put(acc.COM_TipoIdentificacion__c + acc.COM_Numero_de_identificacion__c, acc);
            setIdAcc.add(acc.Id);
        }
        
        for(AccountTeamMember accTeamMember: [SELECT Id, AccountId, UserId 
                                              FROM AccountTeamMember 
                                              WHERE AccountId IN:setIdAcc 
                                              AND TeamMemberRole =:Label.COM_PAF_TypeTeamAsesor]) {
            mapAccountTeamMemberLlave.put(accTeamMember.AccountId, accTeamMember);
        }
        
        List<User> listUserAsesorEmpAsig = [SELECT Id, RL2_AsignadoProspectoAfiliacionCaja__c 
                                            FROM User 
                                            WHERE Profile.Name = 'Asesor - PAF' 
                                            AND IsActive = True AND RL2_Empresa__c = 'Asesor Empresarial' AND RL2_AsignadoProspectoAfiliacionCaja__c = False];
        
        List<User> listUserAsesorEmp = [SELECT Id, RL2_AsignadoProspectoAfiliacionCaja__c
                                        FROM User 
                                        WHERE Profile.Name = 'Asesor - PAF' 
                                        AND IsActive = True AND RL2_Empresa__c = 'Asesor Empresarial' AND RL2_AsignadoProspectoAfiliacionCaja__c = True];
        
        
        List<User> listUserAsesorSedeAsig = [SELECT Id, RL2_AsignadoProspectoAfiliacionCaja__c 
                                            FROM User 
                                            WHERE Profile.Name = 'Asesor - PAF' 
                                            AND IsActive = True AND RL2_Empresa__c = 'Asesor Sede' AND RL2_AsignadoProspectoAfiliacionCaja__c = False];
        
        List<User> listUserAsesorSede = [SELECT Id, RL2_AsignadoProspectoAfiliacionCaja__c
                                        FROM User 
                                        WHERE Profile.Name = 'Asesor - PAF' 
                                        AND IsActive = True AND RL2_Empresa__c = 'Asesor Sede' AND RL2_AsignadoProspectoAfiliacionCaja__c = True];
        
        List<User> listUserAsesorEmpAux = new List<User>();
        List<User> listUserAsesorSedeAux = new List<User>();
        Integer intRandom = 0;
        for(Lead lead: listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == mapRecordType.get('RL2_ProspectoAfiliacionCaja')) {
                    if(mapAccountLlave.containsKey(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c)) {
                        // Si tiene cuenta
                        System.debug('Lead 1 ==> SI TIENE CUENTA');
                        Account acc = mapAccountLlave.get(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c);
                        if(mapAccountTeamMemberLlave.containsKey(acc.Id)) {
                            // Si tiene cuenta y asesor asignado
                            System.debug('Lead 1.1 ==> SI TIENE CUENTA Y ASESOR ASIGNADO');
                            AccountTeamMember accTeamMember = mapAccountTeamMemberLlave.get(acc.Id);
                            lead.OwnerId = accTeamMember.UserId;
                        } else {
                            // Si tiene cuenta, pero no asesor
                            System.debug('Lead 1.2 ==> SI TIENE CUENTA PERO NO ASESOR ASIGNADO');
                            if(mapLeadLlave.containsKey(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c)) {
                                // Si existe como Lead
                                System.debug('Lead 1.2.1 ==> SI EXISTE COMO LEAD');
                                Lead leadTemp = mapLeadLlave.get(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c);
                                lead.OwnerId = leadTemp.OwnerId;
                                
                                // Agregar asesor a la cuenta
                                listAccMemberIns.add(new AccountTeamMember(AccountId = acc.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId = leadTemp.OwnerId, AccountAccessLevel = 'Edit'));
                            } else {
                                // Si no existe como Lead, asignar nuevo Propietario
                                System.debug('Lead 1.2.2 ==> NO EXISTE COMO LEAD');
                                if(lead.LeadSource == 'Call Center') {
                                    if(lead.CEL1_TipoDocumento__c == '2') {
                                        if(listUserAsesorEmp.isEmpty()) {
                                            listUserAsesorEmp = listUserAsesorEmpAux;
                                            listUserAsesorEmpAux = new List<User>();
                                        }
                                        
                                        if (!listUserAsesorEmpAsig.isEmpty()) {
                                            intRandom = Integer.valueOf(Math.random() * listUserAsesorEmpAsig.size());
                                            lead.OwnerId = listUserAsesorEmpAsig.get(intRandom).Id;
                                            listUserAsesorEmpAsig.get(intRandom).RL2_AsignadoProspectoAfiliacionCaja__c = True;
                                            listUserAsesorEmpAux.add(listUserAsesorEmpAsig.get(intRandom));
                                            listUserAsesorEmpAsig.remove(intRandom);
                                        } else {
                                            if (!listUserAsesorEmp.isEmpty()) {
                                                intRandom = Integer.valueOf(Math.random() * listUserAsesorEmp.size());
                                                lead.OwnerId = listUserAsesorEmp.get(intRandom).Id;
                                                listUserAsesorEmpAux.add(listUserAsesorEmp.get(intRandom));
                                                listUserAsesorEmp.remove(intRandom);
                                            }
                                        }
                                    } else if (lead.CEL1_TipoDocumento__c == '1' || lead.CEL1_TipoDocumento__c == '4' || lead.CEL1_TipoDocumento__c == '5' || lead.CEL1_TipoDocumento__c == '10' || lead.CEL1_TipoDocumento__c == '11' || lead.CEL1_TipoDocumento__c == '14') {
                                        if(listUserAsesorSede.isEmpty()) {
                                            listUserAsesorSede = listUserAsesorSedeAux;
                                            listUserAsesorSedeAux = new List<User>();
                                        }
                                        
                                        if (!listUserAsesorSedeAsig.isEmpty()) {
                                            intRandom = Integer.valueOf(Math.random() * listUserAsesorSedeAsig.size());
                                            lead.OwnerId = listUserAsesorSedeAsig.get(intRandom).Id;
                                            listUserAsesorSedeAsig.get(intRandom).RL2_AsignadoProspectoAfiliacionCaja__c = True;
                                            listUserAsesorSedeAux.add(listUserAsesorSedeAsig.get(intRandom));
                                            listUserAsesorSedeAsig.remove(intRandom);
                                        } else {
                                            if (!listUserAsesorSede.isEmpty()) {
                                                intRandom = Integer.valueOf(Math.random() * listUserAsesorSede.size());
                                                lead.OwnerId = listUserAsesorSede.get(intRandom).Id;
                                                listUserAsesorSedeAux.add(listUserAsesorSede.get(intRandom));
                                                listUserAsesorSede.remove(intRandom);
                                            }
                                        }
                                    }
                                    
                                    listAccMemberIns.add(new AccountTeamMember(AccountId = acc.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId = lead.OwnerId, AccountAccessLevel = 'Edit'));
                                } else if (lead.LeadSource == 'Chat' || lead.LeadSource == 'Atención Presencial') {
                                    if(listUserAsesorSede.isEmpty()) {
                                        listUserAsesorSede = listUserAsesorSedeAux;
                                        listUserAsesorSedeAux = new List<User>();
                                    }
                                    
                                    if (!listUserAsesorSedeAsig.isEmpty()) {
                                        intRandom = Integer.valueOf(Math.random() * listUserAsesorSedeAsig.size());
                                        lead.OwnerId = listUserAsesorSedeAsig.get(intRandom).Id;
                                        listUserAsesorSedeAsig.get(intRandom).RL2_AsignadoProspectoAfiliacionCaja__c = True;
                                        listUserAsesorSedeAux.add(listUserAsesorSedeAsig.get(intRandom));
                                        listUserAsesorSedeAsig.remove(intRandom);
                                    } else {
                                        if (!listUserAsesorSede.isEmpty()) {
                                            intRandom = Integer.valueOf(Math.random() * listUserAsesorSede.size());
                                            lead.OwnerId = listUserAsesorSede.get(intRandom).Id;
                                            listUserAsesorSedeAux.add(listUserAsesorSede.get(intRandom));
                                            listUserAsesorSede.remove(intRandom);
                                        }
                                    }
                                    
                                    listAccMemberIns.add(new AccountTeamMember(AccountId = acc.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId = lead.OwnerId, AccountAccessLevel = 'Edit'));
                                }
                            }
                        }
                    } else {
                        // Si no tiene cuenta
                        System.debug('Lead 2 ==> NO TIENE CUENTA');
                        if(mapLeadLlave.containsKey(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c)) {
                            // Si existe como Lead
                            System.debug('Lead 2.1 ==> SI EXISTE COMO LEAD');
                            Lead leadTemp = mapLeadLlave.get(lead.CEL1_TipoDocumento__c + lead.CEL1_NumeroDocumento__c);
                            lead.OwnerId = leadTemp.OwnerId;
                        } else {
                            // Si no existe como Lead, asignar nuevo Propietario
                            System.debug('Lead 2.2 ==> NO EXISTE COMO LEAD');
                            if(lead.LeadSource == 'Call Center') {
                                if(lead.CEL1_TipoDocumento__c == '2') {
                                    if(listUserAsesorEmp.isEmpty()) {
                                        listUserAsesorEmp = listUserAsesorEmpAux;
                                        listUserAsesorEmpAux = new List<User>();
                                    }
                                    
                                    if (!listUserAsesorEmpAsig.isEmpty()) {
                                        intRandom = Integer.valueOf(Math.random() * listUserAsesorEmpAsig.size());
                                        lead.OwnerId = listUserAsesorEmpAsig.get(intRandom).Id;
                                        listUserAsesorEmpAsig.get(intRandom).RL2_AsignadoProspectoAfiliacionCaja__c = True;
                                        listUserAsesorEmpAux.add(listUserAsesorEmpAsig.get(intRandom));
                                        listUserAsesorEmpAsig.remove(intRandom);
                                    } else {
                                        if (!listUserAsesorEmp.isEmpty()) {
                                            intRandom = Integer.valueOf(Math.random() * listUserAsesorEmp.size());
                                            lead.OwnerId = listUserAsesorEmp.get(intRandom).Id;
                                            listUserAsesorEmpAux.add(listUserAsesorEmp.get(intRandom));
                                            listUserAsesorEmp.remove(intRandom);
                                        }
                                    }
                                } else if (lead.CEL1_TipoDocumento__c == '1' || lead.CEL1_TipoDocumento__c == '4' || lead.CEL1_TipoDocumento__c == '5' || lead.CEL1_TipoDocumento__c == '10' || lead.CEL1_TipoDocumento__c == '11' || lead.CEL1_TipoDocumento__c == '14') {
                                    if(listUserAsesorSede.isEmpty()) {
                                        listUserAsesorSede = listUserAsesorSedeAux;
                                        listUserAsesorSedeAux = new List<User>();
                                    }
                                    
                                    if (!listUserAsesorSedeAsig.isEmpty()) {
                                        intRandom = Integer.valueOf(Math.random() * listUserAsesorSedeAsig.size());
                                        lead.OwnerId = listUserAsesorSedeAsig.get(intRandom).Id;
                                        listUserAsesorSedeAsig.get(intRandom).RL2_AsignadoProspectoAfiliacionCaja__c = True;
                                        listUserAsesorSedeAux.add(listUserAsesorSedeAsig.get(intRandom));
                                        listUserAsesorSedeAsig.remove(intRandom);
                                    } else {
                                        if (!listUserAsesorSede.isEmpty()) {
                                            intRandom = Integer.valueOf(Math.random() * listUserAsesorSede.size());
                                            lead.OwnerId = listUserAsesorSede.get(intRandom).Id;
                                            listUserAsesorSedeAux.add(listUserAsesorSede.get(intRandom));
                                            listUserAsesorSede.remove(intRandom);
                                        }
                                    }
                                }
                            } else if (lead.LeadSource == 'Chat' || lead.LeadSource == 'Atención Presencial') {
                                if(listUserAsesorSede.isEmpty()) {
                                    listUserAsesorSede = listUserAsesorSedeAux;
                                    listUserAsesorSedeAux = new List<User>();
                                }
                                
                                if (!listUserAsesorSedeAsig.isEmpty()) {
                                    intRandom = Integer.valueOf(Math.random() * listUserAsesorSedeAsig.size());
                                    lead.OwnerId = listUserAsesorSedeAsig.get(intRandom).Id;
                                    listUserAsesorSedeAsig.get(intRandom).RL2_AsignadoProspectoAfiliacionCaja__c = True;
                                    listUserAsesorSedeAux.add(listUserAsesorSedeAsig.get(intRandom));
                                    listUserAsesorSedeAsig.remove(intRandom);
                                } else {
                                    if (!listUserAsesorSede.isEmpty()) {
                                        intRandom = Integer.valueOf(Math.random() * listUserAsesorSede.size());
                                        lead.OwnerId = listUserAsesorSede.get(intRandom).Id;
                                        listUserAsesorSedeAux.add(listUserAsesorSede.get(intRandom));
                                        listUserAsesorSede.remove(intRandom);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        try {
            if (!listUserAsesorEmpAux.isEmpty())
                update listUserAsesorEmpAux;
            
            if (listUserAsesorEmpAsig.isEmpty()) {
                if(!listUserAsesorEmp.isEmpty()){
                    for (User us: listUserAsesorEmp) {
                        us.RL2_AsignadoProspectoAfiliacionCaja__c = False;
                        listUserAsesorEmpAsig.add(us);
                    }
                }  
            }
            
            if(!listUserAsesorEmpAsig.isEmpty())
                update listUserAsesorEmpAsig;
            
            if (!listUserAsesorSedeAux.isEmpty())
                update listUserAsesorSedeAux;
            
            if (listUserAsesorSedeAsig.isEmpty()) {
                if(!listUserAsesorSede.isEmpty()){
                    for (User us: listUserAsesorSede) {
                        us.RL2_AsignadoProspectoAfiliacionCaja__c = False;
                        listUserAsesorSedeAsig.add(us);
                    }
                }  
            }
            
            if(!listUserAsesorSedeAsig.isEmpty())
                update listUserAsesorSedeAsig;
            
            if(!listAccMemberIns.isEmpty())
                insert listAccMemberIns;
        } catch (Exception e) {
            System.debug('Error in  RL2_LeadHelper_cls.asignarPropietarioDeCuenta() ===> ' + e.getMessage());
        }
    }
    
    /**
    * @Method:      actualizarCuentaConvertida
    * @param:       List<Lead> listNewLead
    * @Description: Actualiza el datos de la Cuenta en base al Lead
    * @author       Jorge Pozo (JPA) - 18/06/21
    */
    public static void actualizarCuentaConvertida(List<Lead> listNewLead, Map<Id,Lead> mapOldLead) {
        Map<String, Lead> mapAccIdxLead = new Map<String, Lead>();
        List<Account> listAccountUpd = new List<Account>();
        Set<Id> accIdsConv = new Set<Id>();
        
        String strRecTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        
        for(Lead lead: listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == strRecTypeAfiliacionCaja) {
                    if((mapOldLead.get(lead.Id).isConverted != lead.isConverted) && lead.isConverted){
                        mapAccIdxLead.put(lead.ConvertedAccountId, lead);
                        accIdsConv.add(lead.ConvertedAccountId);
                    }
                }
            }
        }
        
        Account accUpd;
        for(Account acc: [SELECT Id, RecordTypeId 
                          FROM Account 
                          WHERE Id IN:accIdsConv
                          AND RecordType.DeveloperName IN ('COM_Natural', 'COM_Juridico')]) {
            if(mapAccIdxLead.containsKey(acc.Id)) {
                Lead lead = mapAccIdxLead.get(acc.Id);
                accUpd = new Account();
                accUpd.COM_Digitoverificacion__c = lead.RL2_DigitoDeVerificacion__c;
                accUpd.COM_Trabajadoresderechosubsidio__c = lead.RL2_NoTrabajadoresQueRecibenSubsidio__c;
                accUpd.COM_Valor_Actual_de_la_Nomina__c = lead.RL2_ValorDeNomina__c;
                accUpd.COM_CorreoElectronico__c = lead.Email;
                accUpd.COM_Movil__c = lead.MobilePhone;
                accUpd.Id = acc.Id;
                listAccountUpd.add(accUpd);
                
                try {
                    CEL1_LeadHelper_cls.agregarNautcliClienteFuture(acc.Id);
                } catch (Exception ex) {
                    System.debug('Error in CEL1_LeadHelper_cls.agregarNautcliClienteFuture() ==>' + ex.getMessage());
                }
            }
        }
        
        try {
            if(listAccountUpd.size() > 0)
                update listAccountUpd;
            
            System.debug('Success in RL2_LeadHelper_cls.actualizarCuentaConvertida() ==> ' + listAccountUpd.size());
        } catch (Exception ex) {
            System.debug('Error in RL2_LeadHelper_cls.actualizarCuentaConvertida() ==>' + ex.getMessage());              
        }
    }
    
    /**
    * @Method:      validarCuentaExistente
    * @param:       List<Lead> listNewLead
    * @Description: Valida que no se selecciona una Cuenta con diferente Tipo y Número de Documento del Lead
    * @author       Jorge Pozo (JPA) - 18/06/21
    */
    public static void validarCuentaExistente(List<Lead> listNewLead) {
        Map<String, Account> mapAccountLlave = new Map<String, Account>();
        Set<Id> accIdsConv = new Set<Id>();
        Set<Id> setIdAcc = new Set<Id>();
        
        String strRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        
        for (Lead lead:listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == strRecordTypeAfiliacionCaja){
                    if(lead.IsConverted == true){
                        accIdsConv.add(lead.ConvertedAccountId);
                    }
                }
            }
        }
        
        for(Account acc: [SELECT Id, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c 
                          FROM Account 
                          WHERE Id IN:accIdsConv
                          AND RecordType.DeveloperName IN ('COM_Natural', 'COM_Juridico')]) {
            mapAccountLlave.put(acc.Id, acc);
            setIdAcc.add(acc.Id);
        }
        
        for (Lead lead:listNewLead) {
            if(lead.RecordTypeId != null) {
                if(lead.RecordTypeId == strRecordTypeAfiliacionCaja){
                    if(lead.IsConverted == true){
                        if(mapAccountLlave.containsKey(lead.ConvertedAccountId)) {
                            Account acc = mapAccountLlave.get(lead.ConvertedAccountId);
                            if(!(acc.COM_TipoIdentificacion__c == lead.CEL1_TipoDocumento__c) && !(acc.COM_Numero_de_identificacion__c == lead.CEL1_NumeroDocumento__c)) {
                                lead.addError(label.RL2_CuentaDiferente);
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}