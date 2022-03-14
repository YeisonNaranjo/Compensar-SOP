public with sharing class COS_AsignacionCasosSalud_cls {
    /**
* @Method:      asignacionCasos
* @param:       List<Case> lstNewCasos
* @Description: Realiza la asignación de los casos
*/
    public static void asignacionCasos(List<Case> lstNewCasos){
        
        string strRecordTypeCaseSalud = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('COS_RetencionRenovacionSalud').getRecordTypeId();
         
        
        //Si el perfil de usuario creador es igual a 'Asesor Comercial Salud','Coordinador Comercial Salud','Asesor Postventa Salud' no se realiza la asignacion
        Id profileId= userinfo.getProfileId();
        
        //automatedProcess metadata
        COS_idPerfilCarga__mdt idPerfilCarga;
        idPerfilCarga = [Select COS_idPerfilCagaSalud__c, COS_idPerfilAdministrador__c FROM COS_idPerfilCarga__mdt];
        
        if(idPerfilCarga.COS_idPerfilCagaSalud__c != profileId && idPerfilCarga.COS_idPerfilAdministrador__c != profileId ){
            return;
        }
    
            
        //Lista para identificar luego los casos para distribucion de cargas
        //es decir, el resultado de la consulta NO obtuvo datos de empresas o clientes priorizados
        List <Case> listaCasosDistriCarga = New List <Case>();
        List<User> listaUsuariosAsesores = New List<User>();
        List<String> listaEmailOwner = New List<String>();
        List<Account> listaAccountInfo = New List<Account>();
        
        
        
        //Me guardo los Documentos y tipo / NIT de cada Caso para luego buscar las cuentas correspondientes
        Map<String,String> mapCuentaxTM = new Map <String,String>();
        Map<String,String> mapCaseEmailOwner = New Map<String,String>();
        Set<string> setDocumento = new Set<string>(); //---Milton Romero estaba--> Set<decimal>
        Set<String> setTipo = new Set<String>();
        Set<String> setAccountId = new Set<String>();
        String noAplica = 'noAplica';
        String noAplicaTipo = '15';
        
        for(Case objCaseMap:lstNewCasos){
            if (objCaseMap.RecordTypeId == strRecordTypeCaseSalud){
                
                System.debug('---------- accountID AccountId   ' + objCaseMap.AccountId);
             
                
                if (objCaseMap.COS_NumeroDocumento__c <> null && objCaseMap.COS_TipoDocumento__c <> null ){
                    setDocumento.add(objCaseMap.COS_NumeroDocumento__c);
                    setTipo.add(objCaseMap.COS_TipoDocumento__c);
                    setAccountId.add(objCaseMap.AccountId);
                } else {
                    setDocumento.add(noAplica);
                    setTipo.add(noAplicaTipo);
                    setAccountId.add(objCaseMap.AccountId);
                }
                
                if (objCaseMap.COS_TipoCaso__c == 'Fidelización' || objCaseMap.COS_TipoCaso__c == 'Retención'){
                    listaEmailOwner.add(objCaseMap.COS_EmailOwner__c);
                }
                
            } else {
                setDocumento.add(noAplica);
                setTipo.add(noAplicaTipo);
            }
            
            

        }
        
        //Lista de Usuarios para asingar casos (Direccion de email para asignar el propietario al Caso (retencion y fidelizacion))
        List<User> lstUserOwner = [Select id, Username FROM User WHERE Username IN: listaEmailOwner AND IsActive = TRUE AND COS_Usuario_no_disponible__c = FALSE];
        
        for(User objUser : lstUserOwner){
            mapCaseEmailOwner.put(objUser.Username,objUser.id);
        }
        
        //Lista de Account Teams (clientes) que tiene relacion con el Caso
        List<AccountTeamMember> lstAccTM = [SELECT Id,
                                            Account.COM_TipoIdentificacion__c,
                                            Account.COM_Numero_de_identificacion__c,
                                            UserId,
                                            User.COS_Usuario_no_disponible__c
                                            FROM AccountTeamMember WHERE
                                            (Account.id IN: setAccountId OR
                                            (Account.COM_TipoIdentificacion__c IN: setTipo
                                            AND Account.COM_Numero_de_identificacion__c IN: setDocumento))
                                            AND User.Profile.Name = 'Asesor Comercial Salud']; //And Account.Id 
        
        System.debug('---------- lstAccTM ....>>>    ' + lstAccTM);

        for(AccountTeamMember objAccTM : lstAccTM){
            //verifico si el usuario presenta alguna novedad
            if (!objAccTM.User.COS_Usuario_no_disponible__c){
                mapCuentaxTM.put(objAccTM.Account.COM_TipoIdentificacion__c+objAccTM.Account.COM_Numero_de_identificacion__c,objAccTM.UserId);
                mapCuentaxTM.put(objAccTM.Account.id,objAccTM.UserId);
               }
        }
        
        System.debug('---------- mapCuentaxTM ....>>>    ' + mapCuentaxTM);
        
        for(Case objCase: lstNewCasos){
            
            if (objCase.RecordTypeId == strRecordTypeCaseSalud && objCase.COS_TipoCaso__c == 'Renovación'){
                if (mapCuentaxTM.containsKey(objCase.COS_TipoDocumento__c+objCase.COS_NumeroDocumento__c) || mapCuentaxTM.containsKey(objCase.AccountId)) {
                    System.debug('---------- ENTRO POR EL IF PORQUE ENCONTRO CUENTA POR TIPO Y NUMERO DE DOCUMENTO....');
                    if(objCase.COS_TipoDocumento__c <> null && objCase.COS_NumeroDocumento__c <> null ){
                        objCase.OwnerId = mapCuentaxTM.get(objCase.COS_TipoDocumento__c+objCase.COS_NumeroDocumento__c);
                    } else {
                        objCase.OwnerId = mapCuentaxTM.get(objCase.AccountId);
                    }
                    
                    
                    
                }
                else{
                    System.debug('---------- LA BUSQUEDA NO TUVO RESULTADOS, PASO EL CASO A DISTRIBUCION DE CARGA');
                    listaCasosDistriCarga.add(objCase);
                    
                }
                // Para el caso donde el owner viene como parte de la carga en el campo "Email Owner"
            } else if (objCase.COS_TipoCaso__c == 'Fidelización' || objCase.COS_TipoCaso__c == 'Retención' ){
                System.debug('---------- El caso es de tipo Fidelización o Retención');
                if (mapCaseEmailOwner.containsKey(objCase.COS_EmailOwner__c)) {
                    objCase.OwnerId = mapCaseEmailOwner.get(objCase.COS_EmailOwner__c);       
                    System.debug('---------- objCase mapCaseEmailOwner.get(objCase.COS_EmailOwner__c) --> ' + objCase);
                    
                }
                else{
                    System.debug('---------- El username no se encontro, PASO EL CASO A DISTRIBUCION DE CARGA');
                    listaCasosDistriCarga.add(objCase);
                }
                
            }
            
        }
        
        System.debug('---------- listaCasosDistriCarga --> '+ listaCasosDistriCarga );
        
        //Los casos no asignados pasan a Distribucion de cargas.
        if (!listaCasosDistriCarga.isEmpty()){
            asignacionCasosDistCarga(listaCasosDistriCarga);
        }
        
    }
    
    
    
    /*****************************************************
* @Method:      asignacionCasos (VEN010)
* @param:       List<Lead> lstNewLead
* @Description: Realiza la asignación de los Casos por distribucion de carga
*/
    public static void asignacionCasosDistCarga(List<Case> lstCaseCarga){
        
        List <User> lstUser = new list<User>();
        List <User> updateUserlst = New List <User>();
        List <Case> updateCaselst = New List <Case>();
        
        //Obtengo el ID del grupo publico de Coordinadores de Salud
        List<Group> idListGrupoPublico = new List<Group>();
        idListGrupoPublico = [Select id FROM Group WHERE DeveloperName = 'COS_CoordinacionFR' LIMIT 1];
        Set<Id> setIdGrupoPublico = New Set<Id>();
        setIdGrupoPublico.add(idListGrupoPublico.get(0).id);
        
        Set<id> usuariosGrupoPublico = obtenerUsuariosPG(setIdGrupoPublico);
        
        // lista de usuarios activos y sin novedad que estan dentro del grupo publico COS_CoordinacionFR
        lstUser = [Select Id, COS_Usuario_no_disponible__c FROM User WHERE Id IN:usuariosGrupoPublico AND IsActive = TRUE AND COS_Usuario_no_disponible__c = FALSE]; 
        
        System.debug('---------- lstUser LISTA DE USUARIOS EN PUBLIC GROUP ....>>>    ' + lstUser);

        Integer indexLista = 0;
        Integer listUsercount = lstUser.size();
        Integer listCasecount = lstCaseCarga.size();

        for(Case cs: lstCaseCarga){
            //--- Asignación por distribución en grupo de coordinador
            
            if (indexLista >= listUsercount ){
                indexLista = 0;
            }
            
            if(lstUser.size() > 0){
                cs.OwnerId = lstUser.get(indexLista).id;
                indexLista++;
            }
        }
        
    }
    
    
    public static Set<id> obtenerUsuariosPG(Set<Id> groupIds)
    {
        
        Set<Id> resultado= New Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();
        // Recorre todos los miembros del grupo en un grupo
        for(GroupMember m : [Select Id, UserOrGroupId, Group.Type, Group.RelatedId From GroupMember Where GroupId in :groupIds])
        {
            // verifica si UserOrGroupId es un Usuario
            if(((String)m.UserOrGroupId).startsWith(userType))
            {
                resultado.add(m.UserOrGroupId);
            }
            // Si el ID de usuario o grupo es un grupo
            else if (((String)m.UserOrGroupId).startsWith(groupType))
            {
                groupIdProxys.add(m.userOrGroupId);
                
            }
        }
        
        /*if(groupIdProxys.size() > 0)
        {  
            Set<id> groupId = new set<id>();
            Set<id> roleId = new set<id>();
            Set<id> roleAndSubId = new set<Id>();
            
            for(Group g2 : [Select Id, Type, relatedId From Group Where Id = :groupIdProxys]){
                if(g2.Type == 'Role'){
                    roleId.add(g2.relatedId);    
                }
                else if(g2.Type== 'RoleAndSubordinates'){
                    roleAndSubId.add(g2.relatedId);    
                }
                else if(g2.Type== 'PRMOrganization'){
                    roleId.add(g2.relatedId);    
                }
                else if(g2.Type== 'Regular'){
                    groupId.add(g2.id);    
                }
                system.debug(g2);
            }
            if(roleAndSubId.size()>0){
                //roleId.addAll(obtenerRoles(roleAndSubId));
            }
            if(roleId.size()>0){
                for(User u: [select id from user where UserRoleId IN: roleId]){
                    resultado.add(u.id);
                }
            }
            if(groupId.size()>0){
                for(GroupMember gm : [select id, UserOrGroupId from GroupMember where GroupId IN: groupId]){
                    resultado.add(gm.UserOrGroupId);        
                }
            }
        }*/
        return resultado;  
    }
      
}