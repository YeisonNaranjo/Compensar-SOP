/************************************************************************************************
    Desarrollado por:  Avanxo
    Autor:             William Alexander Aldana Carvajal (WA)
    Proyecto:          Compensar
    Descripción:       Clase Trigger COM_PAF_AsignarOVinculacion_tgr donde se realizan los siguientes operaciones
                        - Asignar la oportunidad al asesor del equipo de cuenta
                        - Sino sacarlo del grupo de Asignaciones

    Cambios (Versiones)
    -------------------------------------------------------------------------------------------------
        No.     Fecha                  Autor                                 Descripción
    ----------  -------------   ----------------------  ---------------------------------------------
    1.0     04/08/2017      William Aldana (WA)     Creación Clase.
    1.1     16/05/2019      Stifen Panche (SP)      Se inserta el usuario asignado al equipo de clientes.
************************************************************************************************/
public with sharing class COM_PAF_AsignarOVinculacion_cls {

        List<COM_UtilidadCorreo_cls.CorreoSimple> lstCorreosEnviar = new List<COM_UtilidadCorreo_cls.CorreoSimple>();
        Set<Id> lstIdOportunidadesVinculacion  {get; set;}
        List<COM_Asignacion__c> lstAsesoresPAF {get; set;}
        List<COM_Asignacion__c> lstAsesoresADM {get; set;}
        Set<RecordType> lstRecordTypesPAF  {get; set;}
        List<User> lstUser  {get; set;}
        List<OpportunityShare> lstOppShareList  {get; set;}

        public COM_PAF_AsignarOVinculacion_cls() {
            lstRecordTypesPAF = new Set<RecordType>();
            lstIdOportunidadesVinculacion =  new Set<Id>();
            lstOppShareList = new List<OpportunityShare>();
            for(RecordType r : [SELECT Id, Name FROM RecordType where BusinessProcessId in (SELECT Id FROM BusinessProcess where Name =: Label.COM_PAF_nameProcess)]){
                lstIdOportunidadesVinculacion.add(r.Id);
                lstRecordTypesPAF.add(r);
            }
            lstAsesoresPAF = [SELECT COM_Usuario__c, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PAF_nameAsesor order by COM_FechaAsignacion__c asc];
            lstAsesoresADM = [SELECT COM_Usuario__c, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PAF_nameAsesorADM order by COM_FechaAsignacion__c asc];
            lstUser = [SELECT Id, Profile.Name, Email FROM User where Id =: UserInfo.getUserId()];
        }

        /**
         * [asignarOportunidadDeVincualacion description]
         * @param lstOportunidades [description]
         */
         public void asignarOportunidadDeVincualacion(List<Opportunity> lstOportunidades){
            Boolean actualizarListaPAF = false;
            Boolean actualizarListaADM = false;
            for(Opportunity op : lstOportunidades){
                // se verifica si la oportunidad es de algun tipo valido de vinculacion
                if(lstIdOportunidadesVinculacion.contains(op.RecordTypeId)){
                    Set<String> setCorreos = new Set<String>();
                    // Se busca si la oportunidad esta asociada a una cuenta que tiene
                    // TeamAccountMember
                    
                    // si la oportunidad fue creada por un digitador la puede seguir modificando
                    if(!lstUser.isEmpty() && lstUser.get(0).Profile != null && lstUser.get(0).Profile.Name !=null && lstUser.get(0).Profile.Name.containsIgnoreCase('Digitador')){
                        addOpportunityShare(op.Id, UserInfo.getUserId(), 'Edit');
                    } 
                    
                    system.debug('lstUser.get(0).Profile.Name ' + lstUser.get(0).Profile.Name + ' Label.COM_PAF_nameAsesor ' + Label.COM_PAF_nameAsesor);
                    // Si el usuario que esta creando la oportunidad es una asesor PAF se la debe asingnar a si mismo
                    if(!lstUser.isEmpty() && lstUser.get(0).Profile != null && lstUser.get(0).Profile.Name !=null && lstUser.get(0).Profile.Name.containsIgnoreCase(Label.COM_PAF_nameAsesor))
                    {
                        // se asigna a el mismo
                        op.OwnerId = UserInfo.getUserId();
                        /*setCorreos.add(lstUser.get(0).Email);   
                        crearCorreoEnviar(UserInfo.getUserId(), op, setCorreos);*/

                    }
                    else{
                        List<User> userId = obtenerIdUsuarioFromAccountTeamMember(op.AccountId, Label.COM_PAF_TypeTeamAsesor);
                        if(userId != null){
                            // este usuario asociado a la cuenta en el TeamAccountMember
                            op.OwnerId = userId.get(0).Id;
                            /*setCorreos.add(userId.get(0).Email);    
                            crearCorreoEnviar(userId.get(0).Id, op, setCorreos); */                                                       
                            }else{
                            // no hay una cuenta asociada en el teamMemberAccount
                            // se busca en la lista de asesores PAF
                            if(!lstAsesoresPAF.isEmpty()){
                                COM_Asignacion__c asignacion =  lstAsesoresPAF.get(0);
                                asignacion.COM_FechaAsignacion__c = System.now();
                                actualizarListaPAF = true;
                                op.OwnerId = asignacion.COM_Usuario__c;


                                 /*Inicio 1.1*/

                                AccountTeamMember teamMember = new AccountTeamMember();
                                teamMember.Accountid = op.AccountId;
                                teamMember.UserId = asignacion.COM_Usuario__c;
                                teamMember.TeamMemberRole = Label.COM_PAF_TypeTeamAsesor;
                                Insert teamMember;

                                /*Fin 1.1*/
                                /*List<User> lstUsers = [SELECT Id, Email, Name FROM User where Id =: op.OwnerId limit 1];
                                if(!lstUsers.isEmpty()){
                                    setCorreos.add(lstUsers.get(0).email);
                                }
                                crearCorreoEnviar(asignacion.COM_Usuario__c, op, setCorreos);*/
                            }else if(!lstAsesoresADM.isEmpty()){
                                // buscar en la lista de Asesores Administrativos
                                COM_Asignacion__c asignacionA =  lstAsesoresADM.get(0);
                                asignacionA.COM_FechaAsignacion__c = System.now();
                                actualizarListaADM = true;
                                op.OwnerId = asignacionA.COM_Usuario__c;

                                
                                /*Inicio 1.1*/

                                AccountTeamMember teamMember = new AccountTeamMember();
                                teamMember.Accountid = op.AccountId;
                                teamMember.UserId = asignacionA.COM_Usuario__c;
                                teamMember.TeamMemberRole = Label.COM_PAF_TypeTeamAsesor;
                                Insert teamMember;

                                /*Fin 1.1*/

                                /*List<User> lstUsers = [SELECT Id, Email, Name FROM User where Id =: op.OwnerId limit 1];
                                if(!lstUsers.isEmpty()){
                                    setCorreos.add(lstUsers.get(0).email);
                                }
                                crearCorreoEnviar(asignacionA.COM_Usuario__c, op, setCorreos);*/
                            }
                        }
                    }
                }
            }
            
            try {
                if (actualizarListaPAF) update lstAsesoresPAF;
                if (actualizarListaADM) update lstAsesoresADM;
                upsert lstOppShareList;
                //COM_UtilidadCorreo_cls.enviarListCorreo(lstCorreosEnviar);
            }
            catch(Exception e) {
                system.debug(':::::::: Excepcion asignarOportunidadDeVincualacion [updates] :::::::::');
                system.debug( e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
        
        public void enviarCorreOpp(List<Opportunity> lstOportunidades){
        	map<Id, Opportunity> mapOpp;
        	list<Opportunity> lstOpp;
        	set<Id> setIdOpp;
        	Set<String> setCorreos = new Set<String>();
        	
        	setIdOpp = new set<Id>();
        	for(Opportunity op : lstOportunidades){
        		setIdOpp.add(op.Id);
        	}
        	
        	lstOpp = [SELECT Id, OwnerId, Owner.Email, Owner.Name, Contacto__c FROM Opportunity WHERE Id IN :setIdOpp];
        	System.debug('lstOpp::'+lstOpp);
            mapOpp = new map<Id, Opportunity>(lstOpp);

        	Contact tempContact = new Contact(email = 'correo@servidor.com', firstName = 'Dummy', lastName = 'User');
        	insert tempContact;
        	for(Opportunity op : lstOportunidades){
        		// se verifica si la oportunidad es de algun tipo valido de vinculacion
                if(lstIdOportunidadesVinculacion.contains(op.RecordTypeId)){
	        		setCorreos.add(mapOpp.get(op.Id).Owner.Email);
                    
	        		crearCorreoEnviar(tempContact.Id, op, setCorreos);
                }
        	}
        	try{
        		COM_UtilidadCorreo_cls.enviarListCorreo(lstCorreosEnviar);
        	} catch(Exception e){
        		system.debug('Error enviando el correo: ' + e.getMessage());
        	}
        	delete tempContact;
        }

        /**
         * [obtenerIdUsuarioFromAccountTeamMember description]
         * @param  accountId      [description]
         * @param  teamMemberRole [description]
         * @return                [description]
         */
         private List<User> obtenerIdUsuarioFromAccountTeamMember(Id accountId, String teamMemberRole){
            List<User> lstAccountMember = [SELECT Id, Email, Name FROM User where Id in (SELECT UserId
                FROM AccountTeamMember where AccountId =: accountId and TeamMemberRole =: teamMemberRole)]; 
            if(!lstAccountMember.isEmpty()) return lstAccountMember;
            return null;
         }


    /**
     * [crearCorreoEnviar description]
     * @param userId  [description]
     * @param account [description]
     */
     public void crearCorreoEnviar(Id userId, Opportunity oportunidad, Set<String> setCorreos)
     {
        lstCorreosEnviar.add(new COM_UtilidadCorreo_cls.CorreoSimple(setCorreos, null, null, null, Label.COM_PAF_CorreoAsignacionOportunidadTpl, userId, oportunidad.Id));
     }

    /**
     * [addAccountShare description]
     * @param accountId [description]
     * @param userId    [description]
     * @param value     [description]
     */
     private void addOpportunityShare(Id oppID, Id userId, String value){
        OpportunityShare oppShare = new OpportunityShare();
        oppShare.OpportunityId = oppID;
        oppShare.UserOrGroupId = userId;
        //oppShare.AccountAccessLevel = value;
        oppShare.OpportunityAccessLevel = value;
        lstOppShareList.add(oppShare);
     }
}