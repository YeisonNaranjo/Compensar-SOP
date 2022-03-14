/************************************************************************************************
Desarrollado por:  Globant
Autor:             Paula Bohórquez(PB)
Proyecto:          Compensar
Descripción:       Clase para control de clientes pertenecientes a Cuenta Acreedora 

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     12/02/20         Paula Bohórquez  (PB)    Creación Clase.
    1.1     17/02/20         Manuel Mendez    (MM)    Modificación Clase.   
**************************************************************************************************/
public class CEL1_ClienteCuentaAcreedora_cls {

    /**
    * @Method:      asignarPropietarioCandidato
    * @param:       String idCliente, Lead idCandidato, Boolean blnIsAccount
    * @Description: Asigna como propietario del Candidato cuenta Acreedora al asesor PAF del equipo
                    de cuentas del cliente relacionado a dicho candidato
    * @author       Paula Bohórquez Alfonso- 12/02/2020 
    */
    public static Map<Id,Lead> asignarPropietarioCandidato(Map<String,String> mapIdClientexIdLead, Map<String,Lead> mapIdLeadxLead, Boolean blnIsAccount,Boolean blntmp){
        Map<Id,Lead> mapCandidatosUpdate = new Map<Id,Lead>();
       	string idRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        System.debug('===>>> asignarPropietarioCandidato : mapIdClientexIdLead '+mapIdClientexIdLead);
        System.debug('===>>> asignarPropietarioCandidato : mapIdLeadxLead '+mapIdLeadxLead);
        
        if(blnIsAccount && mapIdClientexIdLead != null){
            //PB - Si el método se llama desde el trigger de Cuentas
            for(AccountTeamMember objAccMember : [SELECT UserId,AccountId FROM AccountTeamMember WHERE AccountId IN: mapIdClientexIdLead.keySet() AND TeamMemberRole =: Label.CEL1_RolAsesorPAF ORDER BY CreatedDate DESC NULLS FIRST]){
                mapIdLeadxLead.get(mapIdClientexIdLead.get(objAccMember.AccountId)).OwnerId = objAccMember.UserId;
                mapIdLeadxLead.get(mapIdClientexIdLead.get(objAccMember.AccountId)).CEL1_ConvertidoDesdeCliente__c = true;
                if(blntmp)
                    mapIdLeadxLead.get(mapIdClientexIdLead.get(objAccMember.AccountId)).CEL1_ConversionAuomatica__c = true;
                mapCandidatosUpdate.put(mapIdClientexIdLead.get(objAccMember.AccountId),mapIdLeadxLead.get(mapIdClientexIdLead.get(objAccMember.AccountId)));
            }
           
           
            System.debug('===>>> asignarPropietarioCandidato : mapCandidatosUpdate '+mapCandidatosUpdate);
            return mapCandidatosUpdate;
        }
        else{
            if(!mapIdLeadxLead.isEmpty()){
                Lead objLead = [SELECT Id, CEL1_TipoDocumento__c,CEL1_NumeroDocumento__c,RecordTypeid,OwnerId FROM Lead WHERE Id IN:mapIdLeadxLead.keySet()];
                if (objLead != null) {
                    Account[] objAccount = [SELECT Id, COM_TipoIdentificacion__c,COM_Numero_de_identificacion__c FROM Account WHERE COM_TipoIdentificacion__c =: objLead.CEL1_TipoDocumento__c AND COM_Numero_de_identificacion__c =: objLead.CEL1_NumeroDocumento__c LIMIT 1];
                    if (objAccount.size()>0) {
                        AccountTeamMember objAccTM = new AccountTeamMember();
                        objAccTM.AccountId = objAccount[0].Id;
                        objAccTM.AccountAccessLevel     =   'Edit';
                        objAccTM.CaseAccessLevel        =   'Edit';
                        objAccTM.OpportunityAccessLevel =   'Read';
                        if(idRecordTypeLeadSalud==objLead.RecordTypeId){objAccTM.TeamMemberRole = 'COS_AsesorConsorcioSalud';}
                        else{objAccTM.TeamMemberRole    =   'COM_AuxiliarAdministrativoPAF';}
                        objAccTM.UserId                 =   objLead.OwnerId;
                        
                        insert objAccTM;
                    }
                    
                } 
            }

            return null;
        }        
    } 
}