/************************************************************************************************
    Desarrollado por:  Avanxo
    Autor:             William Alexander Aldana Carvajal (WA)
    Proyecto:          Compensar
    Descripción:       Clase Trigger COM_PVE_AsignarOpVenta_tgr donde se realizan los siguientes operaciones
                        - Asignar la oportunidad de venta al asesor del equipo de cuenta
                        - Sino sacarlo del grupo de Asignaciones

    Cambios (Versiones)
    -------------------------------------------------------------------------------------------------
        No.     Fecha                  Autor                                 Descripción
    ----------  -------------   ----------------------  ---------------------------------------------
        1.0     04/08/2017      William Aldana (WA)     Creación Clase.
        2.0     03/11/2017      William Aldnana (WA)    Adicion de funcion Financiera
        3.0     11/07/2018      Nilyan Berti            NOLA 5014
        4.0     22/05/2019      Camilo Gamarra (CG13)   NOLA 00263774 -- Se excluyen los registros que contengan activo el campo
                                                        No Generar Correo Opp o si Se hizo ya primer contacto con el cliente
        4.1     17/07/2019      Jordan Parra (JP)       NOLA 00264602 -- Se agrega la opción de proceso de venta alojamiento para
                                                        la asignación de la oportunidad al Account Team.
		4.2     26/07/2019      Jordan Parra (JP)       NOLA 0026XXXX -- Se genera excepción para el tipo de registro Alojamientos
														para que se asigne al asesor Integral.
        *****************************************************************************************************/

        public with sharing class COM_PVE_AsignarOpVenta_cls {
            Set<Id> lstIdOportunidadesVenta  {get; set;}
            List<COM_Asignacion__c> lstAsesoresPVE {get; set;}
            List<COM_Asignacion__c> lstAsesoresADM {get; set;}
            List<COM_TiposAsesoresAccountTeamM__mdt> lstAsesoresPVETypes {get; set;}
            Set<RecordType> lstRecordTypesVenta  {get; set;}
            List<COM_UtilidadCorreo_cls.CorreoSimple> lstCorreosEnviar = new List<COM_UtilidadCorreo_cls.CorreoSimple>();
            List<User> lstUser {get; set;}
            //Inicio NOLA-2175
            Map<Id, BusinessProcess> mapBP;
            //Fin NOLA-2175

            public COM_PVE_AsignarOpVenta_cls() {
            //TODO: falta llenar los nombre de los recordtypes de las oportunidades de venta
            lstIdOportunidadesVenta =  new Set<Id>();
            lstRecordTypesVenta = new Set<RecordType>();
//Inicio v4.1
            //for(RecordType r : [SELECT Id, Name, BusinessProcessId FROM RecordType where BusinessProcessId in (SELECT Id FROM BusinessProcess where Name =: Label.COM_PVE_nameProcess or Name =: Label.COM_PVE_FIN_nameProcess)]){ //Se comenta esta línea de código v4.1 (JP)
              for(RecordType r : [SELECT Id, Name, BusinessProcessId FROM RecordType where BusinessProcessId in (SELECT Id FROM BusinessProcess where Name =: Label.COM_PVE_nameProcess or Name =: Label.COM_PVE_FIN_nameProcess or Name=: Label.COM_PVE_ALOJ_nameProcess)]){
//Final  v4.1                
                lstIdOportunidadesVenta.add(r.Id);
                lstRecordTypesVenta.add(r);
            }
            //Inicio NOLA-2175
            mapBP = new Map<Id, BusinessProcess>([Select Id, Name From BusinessProcess]);
            //Fin NOLA-2175
            lstAsesoresPVE = [SELECT COM_Usuario__c, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PVE_nameAsesor order by COM_FechaAsignacion__c asc];
            lstAsesoresADM = [SELECT COM_Usuario__c, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PVE_nameAsesorADM order by COM_FechaAsignacion__c asc];
            lstAsesoresPVETypes = [SELECT COM_NombreTipoAsesor__c,Com_RecordTypeName__c, COM_ApiNameTipoAsesor__c FROM COM_TiposAsesoresAccountTeamM__mdt where COM_AreaTipoAsesor__c = 'PVE'];
            lstUser = [SELECT Profile.Name FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
        }

    /**
     * [asignarOportunidadPVE description]
     * @param lstOportunidades [description]
     */
     public void asignarOportunidadPVE(List<Opportunity> lstOportunidades){

        Boolean actualizarListaPVE = false;
        Boolean actualizarListaADM = false;
        for(Opportunity op : lstOportunidades){
          if(!op.RF2_NoAsignar__c && !op.COM_Gestionado_en_primer_contacto__c){  //NOLA 5014
              System.debug('COM_PVE_AsignarOpVenta_cls::Entra a asignar oportunidad');
              // se verifica si la oportunidad es de algun tipo valido de vinculacion
              RecordType rtOportunidad = obtenerRecordType(lstRecordTypesVenta, op.RecordTypeId);
              if(rtOportunidad != null){
                  Set<String> setCorreos = new Set<String>();
                  // Se busca si la oportunidad esta asociada a una cuenta que tiene
                  // TeamAccountMember
                  String strTipoTeamRol = obtenerTipoTeamRol(lstAsesoresPVETypes, rtOportunidad.Name, op.COM_CicloNegocio__c);
                  
                  List<User> userId = obtenerUsuarioFromAccountTeamMember(op.AccountId, strTipoTeamRol);
                  //Inicio NOLA-2175 - Se valida el Tipo de Proceso de Ventas Si es Proceso de venta empresarial Se asigna al asesor Integral
                  if(userId == null && strTipoTeamRol != System.Label.COM_PVE_apiNameAsesorIntegal){
                      if(null != mapBP && mapBP.get(rtOportunidad.BusinessProcessId).Name == label.COM_PVE_nameProcess){
                          strTipoTeamRol = System.Label.COM_PVE_apiNameAsesorIntegal;
                          userId = obtenerUsuarioFromAccountTeamMember(op.AccountId, strTipoTeamRol);
                          System.debug(strTipoTeamRol);
                      }
                  }

                  // NOLA 2392 coger el asesor del empleador.
                  if(strTipoTeamRol == System.Label.COM_PVE_apiNameAsesorCredito){
                        System.debug('exito');
                          userId = obtenerUsuarioFromAccountTeamMember(op.COM_Empleador__c, strTipoTeamRol);
                          System.debug(strTipoTeamRol);
                      
                  }

                  //END
                  System.debug(strTipoTeamRol);
                  //Fin NOLA-2175
                  System.debug(userId);
                  if(userId != null){
                      // este usuario asociado a la cuenta en el TeamAccountMember
                      //setCorreos.add(userId.get(0).email);
                      op.OwnerId = userId.get(0).Id;                  
                      //crearCorreoEnviar(op.OwnerId, op, setCorreos);
                      }else{
                      // no hay una cuenta asociada en el teamMemberAccount
                      // se busca en la lista de asesores PVE
                      COM_Asignacion__c asignacion = null;
                      if(!lstAsesoresPVE.isEmpty()){
                          asignacion =  obtenerAsignacionMenorFecha(lstAsesoresPVE);
                          actualizarListaPVE = true;
                          }else if(!lstAsesoresADM.isEmpty()){
                          // buscar en la lista de Asesores Administrativos
                          asignacion =  obtenerAsignacionMenorFecha(lstAsesoresADM);
                          actualizarListaADM = true;
                      }

                      if(asignacion != null){
                          asignacion.COM_FechaAsignacion__c = System.now();
                          op.OwnerId = asignacion.COM_Usuario__c;
                          /*List<User> lstUsers = [SELECT Id, Email, Name FROM User where Id =: op.OwnerId limit 1];
                          if(!lstUsers.isEmpty()){
                              setCorreos.add(lstUsers.get(0).email);
                          }
                          crearCorreoEnviar(asignacion.COM_Usuario__c, op, setCorreos);*/
                      }
                  }
              }
            }
          }
          if (actualizarListaPVE) update lstAsesoresPVE;
          if (actualizarListaADM) update lstAsesoresADM;
          //COM_UtilidadCorreo_cls.enviarListCorreo(lstCorreosEnviar);
        }
        
        public void enviarCorreOpp(List<Opportunity> lstOportunidades){
          map<Id, Opportunity> mapOpp;
          list<Opportunity> lstOpp;
          set<Id> setIdOpp;
          Set<String> setCorreos = new Set<String>();
          Set<String> correoAux = new Set<String>(); 

          setIdOpp = new set<Id>();
          for(Opportunity op : lstOportunidades){
            setIdOpp.add(op.Id);
          }
          
          lstOpp = [SELECT Id, OwnerId, Owner.Email, Owner.Name, Contacto__c FROM Opportunity WHERE Id IN :setIdOpp];
          mapOpp = new map<Id, Opportunity>(lstOpp);
          Contact tempContact = new Contact(email = 'correo@servidor.com', firstName = 'Dummy', lastName = 'User');
          insert tempContact;
          for(Opportunity op : lstOportunidades){
            
            if((!op.COM_Gestionado_en_primer_contacto__c) && (!op.No_Generar_Correo_Opp__c)){//Validación versión 4.0 CG13

                RecordType rtOportunidad = obtenerRecordType(lstRecordTypesVenta, op.RecordTypeId);
                    if(rtOportunidad != null){
                  setCorreos.add(mapOpp.get(op.Id).Owner.Email);
                  system.debug('................... setCorreos: ' + setCorreos);

                 
                  correoAux=setCorreos.clone();

                  crearCorreoEnviar(tempContact.Id, op, correoAux);
                  setCorreos.clear();
                    }
              }
          }
          system.debug('................... va a enviar los correos');
          try{
            System.debug('lstBris ' + lstCorreosEnviar);
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
         private List<User> obtenerUsuarioFromAccountTeamMember(Id accountId, String teamMemberRole){
            List<User> lstAccountMember = [SELECT Id, Email, Name FROM User where Id in 
            (SELECT UserId
                FROM AccountTeamMember where AccountId =: accountId and TeamMemberRole =: teamMemberRole)]; 
            if(!lstAccountMember.isEmpty()) return lstAccountMember;
            return null;
         }
        /**
         * [obtenerRecordType description]
         * @param  lstRecordType [description]
         * @param  idRecordType  [description]
         * @return               [description]
         */
         private RecordType obtenerRecordType(Set<RecordType> lstRecordType, Id idRecordType){

            for(RecordType obj : lstRecordType)
            {
                if(obj.Id == idRecordType) return obj;      
            }
            return null;
         }

        /**
         * [obtenerTipoTeamRol description]
         * @param  lstAsesoresPVETypes [description]
         * @param  recordTypeValue     [description]
         * @return                     [description]
         */
         private String obtenerTipoTeamRol(List<COM_TiposAsesoresAccountTeamM__mdt> lstAsesoresPVETypes, String recordTypeValue, String strCiclos){
            if(strCiclos!= null && strCiclos.split(';').size()>1){
                return System.Label.COM_PVE_apiNameAsesorIntegal;
                }else{
                    for(COM_TiposAsesoresAccountTeamM__mdt obj : lstAsesoresPVETypes)
                    {
//Inicio v4.2
                        if(recordTypeValue == 'Alojamiento'){
                            return System.Label.COM_PVE_apiNameAsesorIntegal;
                        }
//Final  v4.2
                        if(obj.Com_RecordTypeName__c == recordTypeValue){
                            return obj.COM_ApiNameTipoAsesor__c;    
                        }
                    }
                }
                return null;
            }

         /**
          * [obtenerMenorFecha description]
          * @param  lstAsesores [description]
          * @return             [description]
          */
          private COM_Asignacion__c obtenerAsignacionMenorFecha(List<COM_Asignacion__c> lstAsesores){
            if(!lstAsesores.isEmpty()){
                COM_Asignacion__c menor = lstAsesores.get(0);
                if(lstAsesores.size() > 1){
                    for (Integer i = 1; i < lstAsesores.size(); i++) {
                        if(lstAsesores[i].COM_FechaAsignacion__c < menor.COM_FechaAsignacion__c){
                            menor = lstAsesores[i];
                        }
                    }
                }
                return menor;
            }
            return null;
          }


    /**
     * [crearCorreoEnviar description]
     * @param userId  [description]
     * @param account [description]
     */
     public void crearCorreoEnviar(Id userId, Opportunity oportunidad, Set<String> setCorreos)
     {
        System.debug('COM_PVE_AsignarOpVenta_cls:crearCorreoEnviar::userId:::'+userId+' oportunidad '+oportunidad.Id+' Correos:::'+setCorreos);
        lstCorreosEnviar.add(new COM_UtilidadCorreo_cls.CorreoSimple(setCorreos, null, null, null, Label.COM_PVE_CorreoAsignacionOportunidadTpl, userId, oportunidad.Id));
     }
    }