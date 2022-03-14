/************************************************************************************************
Desarrollado por:  Globant
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase Helper para Trigger CEL5_AccountTeamMember_tgr
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/02/20         Manuel Mendez  (MM)                    Creación Clase.
**************************************************************************************************/
public with sharing class CEL5_AsignacionAccountTM_cls {
    /**
    * @Method:      asignacionAsesores
    * @param:       List<AccountTeamMember> lstNewAccountTeamMember
    * @Description: Realiza la validación para asignar un nuevo Asesor PAF en el equipo de cuentas.
    * @author       Manuel Mendez - 12 de Febrero 2020 
    */
    public static void validaAsesor(List<AccountTeamMember> lstNewAccTM){
        Map<String,String> mapAccTM = new Map<String,String>();
        Set<String> setAccount = new Set<String>();
        for (AccountTeamMember objAccTM: lstNewAccTM) {
            setAccount.add(objAccTM.AccountId);
        }
        System.debug('setAccount.....'+setAccount);
        
        List<AccountTeamMember> lstAccTMOld = [SELECT Id,
                                                AccountId,
                                                TeamMemberRole
                                                FROM AccountTeamMember
                                                WHERE AccountId IN:setAccount];
        System.debug('lstAccTMOld.....'+lstAccTMOld);
        for(AccountTeamMember objAccTMOld: lstAccTMOld){
            mapAccTM.put(objAccTMOld.AccountId+objAccTMOld.TeamMemberRole,objAccTMOld.TeamMemberRole);
        }
        System.debug('mapAccTM.....'+mapAccTM);
        
        for(AccountTeamMember objAccTMNew: lstNewAccTM){
            if(mapAccTM.containsKey(objAccTMNew.AccountId+objAccTMNew.TeamMemberRole)){
                if(mapAccTM.get(objAccTMNew.AccountId+objAccTMNew.TeamMemberRole).contains(label.CEL5_AccountTMAsesorPAF)){
                    objAccTMNew.addError(label.CEL5_ErrorAccountTM);
                }
            }
        }
    }
}