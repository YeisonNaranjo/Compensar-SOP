/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase Helper Handler CEL1_LeadHandler_cls
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     01/11/19		Manuel Mendez  (MM)		Creación Clase.
	1.1		18/06/2021		Jorge Pozo (JPA)		asignacionAsesores() - Se agregó la condición para que no aplique
													a los Leads (Prospecto Afiliación Caja)
**************************************************************************************************/ 
public with sharing class CEL1_AsignacionAsesores_cls {
    /**
    * @Method:      asignacionAsesores
    * @param:       List<Lead> lstNewLead
    * @Description: Realiza la asignación de los usuarios que van a quedar a propiedad de los candidatos
                    cargados por dataloader.
    * @author       Manuel Mendez- 05 de Noviembre 2019 
    */
    public static void asignacionAsesores(List<Lead> lstNewLead){
        System.debug('ENTRO A asignacionAsesores----->>>>');
        string strRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        Map<String,String> mapCuentaxEquipo = new Map<String,String>();
        Set<String> setDocumento = new Set<String>();
        Set<String> setTipo = new Set<String>();
        for(Lead objLeadMap:lstNewLead){
            if(objLeadMap.RecordTypeId != strRecordTypeAfiliacionCaja) {
                setDocumento.add(objLeadMap.CEL1_NumeroDocumento__c);
                setTipo.add(objLeadMap.CEL1_TipoDocumento__c);
            }
        }
        System.debug('setDocumento----->>>>'+setDocumento);
        List<AccountTeamMember> lstAccTM = [SELECT Id,
                                            Account.COM_TipoIdentificacion__c,
                                            Account.COM_Numero_de_identificacion__c,
                                            Account.COM_Tiponumeroidentificacion__c,
                                            UserId
                                            FROM AccountTeamMember
                                            WHERE Account.COM_TipoIdentificacion__c IN: setTipo
                                            AND Account.COM_Numero_de_identificacion__c IN: setDocumento
                                            AND TeamMemberRole = 'COM_AuxiliarAdministrativoPAF'
                                            ORDER BY CreatedDate ASC NULLS FIRST
                                            LIMIT 1];
        for(AccountTeamMember objAccTM : lstAccTM){
            mapCuentaxEquipo.put(objAccTM.Account.COM_TipoIdentificacion__c+objAccTM.Account.COM_Numero_de_identificacion__c,objAccTM.UserId);
        }
        System.debug('mapCuentaxEquipo---->>>'+mapCuentaxEquipo);
        List<COM_Asignacion__c> lstAsesores = [SELECT COM_perfil__c,
                                                COM_Usuario__c,
                                                Id,
                                                CEL1_Asignado__c,
                                                Name 
                                                FROM COM_Asignacion__c
                                                WHERE CEL1_Asignado__c = false and COM_perfil__c =: label.CEL1_TipoAsesorPAF];
        System.debug('lstAsesores--->>>>'+lstAsesores);

        List<COM_Asignacion__c> lstAsesoresPriori = [SELECT COM_perfil__c,
                                                    COM_Usuario__c,
                                                    Id,
                                                    CEL1_Asignado__c,
                                                    Name 
                                                    FROM COM_Asignacion__c
                                                    WHERE CEL1_Asignado__c = true and COM_perfil__c =: label.CEL1_TipoAsesorPAF];                                                
        System.debug('lstAsesoresPriori--->>>>'+lstAsesoresPriori);
        List<COM_Asignacion__c> lstAsesoresAux = new List<COM_Asignacion__c>();
        Integer intRandom = 0;
        for (Lead objLead: lstNewLead) {
            if (mapCuentaxEquipo.containsKey(objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c)) {
                System.debug('ENTRO POR EL IF PORQUE ENCONTRO CUENTA....');
                objLead.OwnerId = mapCuentaxEquipo.get(objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c);
            }else {
                System.debug('ENTRO POR ELSE POR NO TENER CUENTA EXISTENTE....');
                if (objLead.CEL1_TipoCandidato__c != null && label.CEL1_AsignacionCandidatos.contains(objLead.CEL1_TipoCandidato__c)) {
                    System.debug('ENTRO POR if principal....');
                    if (lstAsesores.isEmpty()) {
                        System.debug('ENTRO A LLENAR lstAsesores--->>>>');
                        lstAsesores = lstAsesoresAux;
                        lstAsesoresAux = new List<COM_Asignacion__c>();
                    }
                    System.debug('ENTRO A LLENAR lstAsesores--->>>>'+lstAsesoresAux);
                    System.debug('ENTRO A LLENAR lstAsesores--lstAsesores>>>>'+lstAsesores);
                    if (!lstAsesoresPriori.isEmpty()) {
                        System.debug('ENTRO POR lstAsesoresPriori---->>>>');
                        intRandom = Integer.valueOf(Math.random()*lstAsesoresPriori.size());
                        System.debug('lstAsesoresPriori asignar--->>>>'+lstAsesoresPriori);
                        objLead.OwnerId = lstAsesoresPriori.get(intRandom).COM_Usuario__c;
                        lstAsesoresPriori.get(intRandom).CEL1_Asignado__c = false;
                        lstAsesoresAux.add(lstAsesoresPriori.get(intRandom));
                        lstAsesoresPriori.remove(intRandom);
                    } else {
                        System.debug('ENTRO POR else de la listas---->>>>');
                        if (!lstAsesores.isEmpty()) {
                            System.debug('ENTRO POR lstAsesores---->>>>');
                            intRandom = Integer.valueOf(Math.random()*lstAsesores.size());
                            objLead.OwnerId = lstAsesores.get(intRandom).COM_Usuario__c;
                            lstAsesoresAux.add(lstAsesores.get(intRandom));
                            lstAsesores.remove(intRandom);
                        }
                    }
                }
                
            }
        }

        if (!lstAsesoresAux.isEmpty())
            update lstAsesoresAux;
        
        System.debug('lstUserBolsa---->>'+lstAsesores);
        if (lstAsesoresPriori.isEmpty()) 
        {
            if(!lstAsesores.isEmpty()){
                for (COM_Asignacion__c objUserPriori: lstAsesores) {
                    objUserPriori.CEL1_Asignado__c = true;
                    lstAsesoresPriori.add(objUserPriori);
                }
            }  
        }
        update lstAsesoresPriori;
    }
}