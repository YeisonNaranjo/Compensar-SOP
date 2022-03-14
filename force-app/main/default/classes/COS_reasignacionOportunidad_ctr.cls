public class COS_reasignacionOportunidad_ctr {
	public list<opportunity> selOppLst {get;set;}
    private ApexPages.StandardSetController controller;
    private ApexPages.StandardController standardController;
    
    public string oppIds;
    public set<Id> memIds = new Set<Id>();
    private map<string, string> mapOptions = new map<string, string>();
    List<selectoption> lstnamesel = new List<selectoption>();
    public string selectedAsesor {get; set;}
    public List<opportunity> lstOpp {get; set;}
    public list<user> lstUser {get; set;}
    public boolean asesorDistribucion {get; set;}
    public map<string, string> mapProfile = new map<string, string>();
    public map<string, string> mapIdProfile = new map<string, string>();
    public boolean blnExitoso {get; set;}
    public boolean blnFallido {get; set;}
    public boolean blnSelectOption {get; set;}
    public boolean blnUsersNull {get; set;}
    
    public COS_reasignacionOportunidad_ctr(ApexPages.StandardSetController controller){
        this.controller = controller;
        selOppLst = new list<opportunity>();
        string UserId = UserInfo.getUserId();//Returns the context user's ID.
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        
        for(opportunity op:(list<opportunity>)controller.getSelected()){
            memIds.add(op.Id);
        }
        
        mapProfile = new map<string, string>();
        for(profile pf:[select id, name from profile]){
            mapProfile.put(pf.id,pf.Name);
            mapIdProfile.put(pf.Name, pf.id);
        }
        system.debug('mapProfile --->'+mapProfile);
        system.debug('memIds --->'+memIds);
        lstOpp = [select id, name, AccountId, Account.Name, OwnerId, Owner.Name, CloseDate, StageName, COS_TipoPlan__c, COS_TipoAfiliado__c from opportunity where id in:memIds];
//        lstAcc = (list<Account>)controller.getSelected();
        system.debug('lstOpp --->'+lstOpp);
    }
    
    public List<Selectoption> getselectedaccnamefields(){
        string UserId = UserInfo.getUserId();//Returns the context user's ID.
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        string idPerfilAsesor = mapIdProfile.get('Asesor Comercial Salud');
        lstUser = [select id, name, COS_No_Cuentas_reasignadas__c, COS_No_Oportunidades_reasignadas__c from user 
                   where ManagerId=:UserId 
                     and ProfileId =:idPerfilAsesor
                     and IsActive=true 
                     and COS_Usuario_no_disponible__c= false 
                   order by COS_No_Oportunidades_reasignadas__c asc];
        
        List<selectoption> lstnamesel = new List<selectoption>();
        
        lstnamesel.add(new selectOption('', '- None -'));
        if(mapProfile.get(ProfileId)=='Coordinador Comercial Salud' || mapProfile.get(ProfileId)=='System Administrator'){
            for(User us:lstUser){
                lstnamesel.add(new selectoption(us.id,us.Name));
            }
        	system.debug('mapOptions --->'+mapOptions);
        }
        System.debug('lstnamesel --->'+lstnamesel);
        return lstnamesel; 
    }
    
    public PageReference cancelar(){
     //   window.history.back();
        PageReference cancel = controller.cancel();
            return null;
    }
    
    public PageReference reasignar(){
        boolean blnEstadoReasignacion = false;
        blnExitoso = false;
		blnFallido = false;
        blnSelectOption = false;
        system.debug('--- reasignar ---');
        system.debug('selectedAsesor --->'+selectedAsesor);
        system.debug('asesorDistribucion --->'+asesorDistribucion);
        if((selectedAsesor==null || selectedAsesor=='' || selectedAsesor=='- None -') && asesorDistribucion == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Debe seleccionar una opción de reasignación'));
            blnSelectOption = true;
        }
        if(selectedAsesor!=null && selectedAsesor!='' && selectedAsesor!='- None -' && asesorDistribucion == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Debe seleccionar una sola opción de reasignación'));
//            blnSelectOption = true;
        }
        
        //--- Asignación por distribución de cargas de grupo de coordinador
        if((selectedAsesor==null || selectedAsesor=='' || selectedAsesor=='- None -') && asesorDistribucion == true){
            system.debug('--- Asignación por distribución de cargas de grupo de coordinador ---');
            if(lstUser.size()>0){
                blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionOportunidad_mtd(lstOpp, lstUser, memIds, 'N/A');
                if(blnEstadoReasignacion == true){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Oportunidades reasignadas exitosamente'));
                    blnExitoso = true;
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ocurrio un error en la reasignación de oportunidades, intente de nuevo por favor'));
                    blnFallido = true;
                }
            }else{
                blnUsersNull = true;
            }
        }
        //--- Asignación a asesor seleccionado
        
        if(selectedAsesor!=null && selectedAsesor!='' && selectedAsesor!='- None -' && asesorDistribucion==false){
            system.debug('--- Asignación a asesor seleccionado ---');
			list<user> lstUserNull = new list<user>();
            blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionOportunidad_mtd(lstOpp, lstUserNull, memIds, selectedAsesor);
            if(blnEstadoReasignacion == true){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Oportunidades reasignadas exitosamente'));
                blnExitoso = true;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ocurrio un error en la reasignación de oportunidades, intente de nuevo por favor'));
                blnFallido = true;
            }
        }
        lstOpp = [select id, name, AccountId, Account.Name, OwnerId, Owner.Name, CloseDate, StageName, COS_TipoPlan__c, COS_TipoAfiliado__c from opportunity where id in:memIds];
        return null;
    }
}