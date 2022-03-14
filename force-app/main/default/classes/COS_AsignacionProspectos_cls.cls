/************************************************************************************************
Desarrollado por:  Globant
Autor:             Gonzalo Mansilla
Proyecto:          Compensar
Descripción:       Clase Helper Handler COS_LeadHandler_cls / CA01, CA02, CA03
**************************************************************************************************/ 

public with sharing class COS_AsignacionProspectos_cls {
    /**
* @Method:      asignacionProspectos
* @param:       List<Lead> lstNewLead
* @Description: Realiza la asignación de los prospectos
*/
    public static void asignacionProspectos(List<Lead> lstNewLead){
        
        //Si el perfil de usuario creador es igual a 'Asesor Comercial Salud' && 'Coordinador Comercial Salud no se realiza la asignacion
        Id profileId= userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);     
        
        if (profileName == 'Asesor Comercial Salud' || profileName == 'Coordinador Comercial Salud'){
            system.debug('El perfil es igual a asesor comercial salud o coordinador comercial salud --'+ profileName);
            return;
        }
        
        //Lista para identificar luego los prospectos para distribucion de cargas
        //es decir, el resultado de la consulta NO obtuvo datos de empresas o clientes priorizados
        List <Lead> listaLeadsDistriCarga = New List <Lead>();
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        
        
        //Me guardo los Documentos y tipo / NIT de cada Lead para luego buscar las cuentas correspondientes
        Set<String> setNit = new Set<String>();
        Set<String> setDoc = new Set<String>();
        Map<String,String> mapCuentaxTM = new Map <String,String>();
        Set<String> setDocumento = new Set<String>();
        Set<String> setTipo = new Set<String>();
        map<string, user> mapUser = new map<string, user>();
        string idProfile = [select id, name from profile where name = 'Asesor Comercial Salud'].id;
        String noAplica = 'NOAPLICA';
        
        for(user us:[select id, name, ManagerId, COS_Usuario_no_disponible__c from user where isActive = true and ProfileId =: idProfile]){
            mapUser.put(us.Id, us);
        }
        
        for(Lead objLeadMap:lstNewLead){
            setDocumento.add(objLeadMap.CEL1_NumeroDocumento__c);
            setTipo.add(objLeadMap.CEL1_TipoDocumento__c);
            if (objLeadMap.COS_Nit_empresa__c <> null){
               setNit.add(objLeadMap.COS_Nit_empresa__c);
            } else {
               setNit.add(noAplica);
            }
            //setDoc.add(objLeadMap.CEL1_NumeroDocumento__c);
            //setDoc.add(objLeadMap.COS_Nit_empresa__c);
        }
        
        //Lista de Account Teams (clientes) que tiene relacion con el Lead
        List<AccountTeamMember> lstAccTM = [SELECT Id,
                                            Account.COM_TipoIdentificacion__c,
                                            Account.COM_Numero_de_identificacion__c,
                                            UserId
//                                          User.ManagerId,
//                                          User.COS_Usuario_no_disponible__c
                                            FROM AccountTeamMember WHERE 
                                            Account.COM_TipoIdentificacion__c = '2' // busco por tipo NIT
                                            AND Account.COM_Numero_de_identificacion__c IN: setNit
                                            AND TeamMemberRole = 'COS_AsesorConsorcioSalud'];
   
        if(lstAccTM.size()>0){
            for(AccountTeamMember objAccTM : lstAccTM){
                user regUser = mapUser.get(objAccTM.UserId);
                //if (objAccTM.User.COS_Usuario_no_disponible__c){
                if (regUser.COS_Usuario_no_disponible__c){
                    mapCuentaxTM.put(objAccTM.Account.COM_TipoIdentificacion__c+objAccTM.Account.COM_Numero_de_identificacion__c,regUser.ManagerId);
                } else {
                    mapCuentaxTM.put(objAccTM.Account.COM_TipoIdentificacion__c+objAccTM.Account.COM_Numero_de_identificacion__c,objAccTM.UserId);
                }
            }
        }
        
    
        //RECORRO LA LISTA DE CANDIDATOS PARA ASIGNAR: SI TIENE NIT, VA EL OWNER DE LA CUENTA NIT, SINO, POR DISTRIBICION DE CARGAS.
        for(Lead objLead: lstNewLead){
            
            if (objLead.LeadSource != 'VVP' && objLead.RecordTypeId == strRecordTypeLeadSalud && objLead.Status == 'Validado' ){
                if (mapCuentaxTM.containsKey('2'+objLead.COS_Nit_empresa__c) && objLead.COS_Nit_empresa__c <> null ){
                    System.debug('---------- ENTRO POR EL IF PORQUE ENCONTRO CUENTA POR NIT....');
                    objLead.OwnerId = mapCuentaxTM.get('2'+objLead.COS_Nit_empresa__c);
                    objLead.COS_Asignado_salud__c = TRUE;
                    
                }

                else{
                    System.debug('---------- LA BUSQUEDA NO TUVO RESULTADOS, PASO EL LEAD A DISTRIBUCION DE CARGA');
                    objLead.COS_Asignado_salud__c = FALSE;
                    
                    
                }
            }
        }
        
                
    }
    
    
    /*****************************************************
* @Method:      asignacionProspectos (CA02 - CA03)
* @param:       List<Lead> lstNewLead
* @Description: Realiza la asignación de los prospectos por distribucion de carga
*/
    public static void asignacionProspectosDistCarga(List<Lead> lstLeadCarga){
        
        List <User> lstUser = new list<User>();
        List <User> updateUserlst = New List <User>();
        List <Lead> updateLeadlst = New List <Lead>();
        
        Integer intTopLeadReasignados;
        Integer intLeadReasignadasUs;
        
        lstUser = [Select Id, COS_Usuario_no_disponible__c, COS_No_Prospectos_asignados__c FROM User 
                   WHERE Profile.Name = 'Asesor Comercial Salud' AND IsActive = TRUE AND COS_Usuario_no_disponible__c = FALSE ORDER BY COS_No_Prospectos_asignados__c ASC];  // lista de usuarios activos y sin novedad ordenados por COS_No_Prospectos_asignados__c de menor a mayor
        
        for(lead ld:lstLeadCarga){
            //--- Asignación por distribución en grupo de coordinador
            
            intTopLeadReasignados = integer.valueof(lstUser[lstUser.size()-1].COS_No_Prospectos_asignados__c);   // mayor usuario con No. de prospectos asignados
            if(intTopLeadReasignados==null){intTopLeadReasignados = 0;}
            system.debug('intTopLeadReasignados --->'+intTopLeadReasignados);
            if(lstUser.size()>0){
                for(user us:lstUser){
                    if(ld.OwnerId != us.Id){
                        intLeadReasignadasUs = integer.valueof(us.COS_No_Prospectos_asignados__c); //cantidad usuarios asignados del usuario sobre el que se itera
                        if(intLeadReasignadasUs==null){intLeadReasignadasUs=0;} // como null no es un numero hay que validarlo
                        
                        if(intLeadReasignadasUs <= intTopLeadReasignados){
                            ld.OwnerId = us.id;
                            ld.COS_Asignado_salud__c = TRUE;
                            if(us.COS_No_Prospectos_asignados__c == null){
                                us.COS_No_Prospectos_asignados__c = 1;
                            }else{
                                us.COS_No_Prospectos_asignados__c = intLeadReasignadasUs + 1;
                            }
                            
                            updateUserlst.add(us);
                            
                            updateLeadlst.add(ld);
                            
                            break; // al asignar prospecto, se para el for sobre los usuarios para continuar con el siguiente prospecto
                        }    
                    } else {ld.COS_Asignado_salud__c = TRUE;
                            updateLeadlst.add(ld);}
                }
            }
            
        }
        
        if (!trigger.isExecuting){
            system.debug('--------------------- !trigger.isExecuting --->');
            if (!updateLeadlst.isEmpty()){
                //update updateLeadlst;
                update lstLeadCarga;
                update lstUser;
            }
        }
/*        
        if (!updateUserlst.isEmpty()){
            try {
                Set<User> myset = new Set<User>();
                List<User> result = new List<USer>();
                myset.addAll(updateUserlst);
                result.addAll(myset);
                update result;
                
            } catch (Exception ex) {
                System.debug('****** ERROR AL ACTUALIZAR USUARIO: '+ex.getMessage());
            }
        } 
  */      
    }
    
    
}