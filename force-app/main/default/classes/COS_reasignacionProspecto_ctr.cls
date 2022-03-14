public class COS_reasignacionProspecto_ctr {
    public list<lead> selLeadLst {get;set;}
    private ApexPages.StandardSetController controller;
    private ApexPages.StandardController standardController;
    
    public string leadIds;
    public set<Id> memIds = new Set<Id>();
    private map<string, string> mapOptions = new map<string, string>();
    List<selectoption> lstnamesel = new List<selectoption>();
    public map<string, string> mapProfile = new map<string, string>();
    public map<string, string> mapIdProfile = new map<string, string>();
    public string selectedAsesor {get; set;}
    public List<lead> lstLead {get; set;}
    public list<user> lstUser {get; set;}
    public boolean asesorDistribucion {get; set;}
    public boolean blnExitoso {get; set;}
    public boolean blnFallido {get; set;}
    public boolean blnSelectOption {get; set;}
    public boolean blnUsersNull {get; set;}
    
    public COS_reasignacionProspecto_ctr(ApexPages.StandardSetController controller){
        this.controller = controller;
        selLeadLst = new list<lead>();
        string UserId = UserInfo.getUserId();//Returns the context user's ID.
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        
        for(lead ld:(list<lead>)controller.getSelected()){
            memIds.add(ld.Id);
        }
        
        for(profile pf:[select id, name from profile]){
            mapProfile.put(pf.id,pf.Name);
            mapIdProfile.put(pf.Name, pf.id);
        }
        system.debug('mapProfile --->'+mapProfile);
        system.debug('memIds --->'+memIds);
        lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead where id in:memIds];
//        lstAcc = (list<Account>)controller.getSelected();
        system.debug('lstLead --->'+lstLead);
    }
    
    public List<Selectoption> getselectedaccnamefields(){
        string UserId = UserInfo.getUserId();//Returns the context user's ID.
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        string idPerfilAsesor = mapIdProfile.get('Asesor Comercial Salud');
        lstUser = [select id, name, COS_No_Cuentas_reasignadas__c, COS_No_Oportunidades_reasignadas__c, COS_No_Prospectos_asignados__c from user 
                   where ManagerId=:UserId 
                     and ProfileId =:idPerfilAsesor
                     and IsActive=true 
                     and COS_Usuario_no_disponible__c= false 
                   order by COS_No_Oportunidades_reasignadas__c asc];
        
        List<selectoption> lstnamesel = new List<selectoption>();
        
        lstnamesel.add(new selectOption('', '- None -'));
//        if(mapProfile.get(ProfileId)=='Coordinador Comercial Salud'){
            for(User us:lstUser){
                lstnamesel.add(new selectoption(us.id,us.Name));
            }
        	system.debug('mapOptions --->'+mapOptions);
//        }
        System.debug('lstnamesel --->'+lstnamesel);
        return lstnamesel; 
    }
    
    public PageReference cancelar(){
     //   window.history.back();
        PageReference cancel = controller.cancel();
            return null;
    }
    
    public PageReference reasignar(){
        blnExitoso = false;
		blnFallido = false;
        blnSelectOption = false;
        blnUsersNull = false;
        boolean blnEstadoReasignacion = false;
        system.debug('--- reasignar ---');
        system.debug('selectedAsesor --->'+selectedAsesor);
        system.debug('asesorDistribucion --->'+asesorDistribucion);
        if((selectedAsesor==null || selectedAsesor=='' || selectedAsesor=='- None -') && asesorDistribucion == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Debe seleccionar una opción de reasignación'));
            blnSelectOption = true;
        }
        if(selectedAsesor!=null && selectedAsesor!='' && selectedAsesor!='- None -' && asesorDistribucion == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Debe seleccionar una sola opción de reasignación'));
            blnSelectOption = true;
        }
        //--- Asignación por distribución de cargas de grupo de coordinador
        if(lstUser.size()>0){
            if((selectedAsesor==null || selectedAsesor=='' || selectedAsesor=='- None -') && asesorDistribucion == true){
                blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionProspecto_mtd(lstLead, lstUser, memIds, 'N/A');
                if(blnEstadoReasignacion == true){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Prospectos reasignadas exitosamente'));
                    blnExitoso = true;
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ocurrio un error en la reasignación de prospectos, intente de nuevo por favor'));
                    blnFallido = true;
                }
            }
        }else{
            blnUsersNull = true;
        }
        //--- Asignación a asesor seleccionado
        if(selectedAsesor!=null && selectedAsesor!='' && selectedAsesor!='- None -' && asesorDistribucion==false){
			list<user> lstUserNull = new list<user>();
            blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionProspecto_mtd(lstLead, lstUserNull, memIds, selectedAsesor);
            if(blnEstadoReasignacion == true){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Prospectos reasignadas exitosamente'));
                blnExitoso = true;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ocurrio un error en la reasignación de prospectos, itente de nuevo por favor'));
                blnFallido = true;
            }
        }
        lstLead = [select id, name, OwnerId, Owner.Name, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, Status from lead where id in:memIds];
        return null;
    }
}