public class COS_reasignacionSalud_ctr {
    public list<account> selAccLst {get;set;}
    private ApexPages.StandardSetController controller;
    private ApexPages.StandardController standardController;
    
    public string accIds;
    public set<Id> memIds = new Set<Id>();
    private map<string, string> mapOptions = new map<string, string>();
//    list<options> lstOptions = new list<options>();
    List<selectoption> lstnamesel = new List<selectoption>();
    public string selectedAsesor {get; set;}
    public list<account> lstAcc {get; set;}
    public list<AccountTeamMember> lstATM {get; set;}
    public list<user> lstUser {get; set;}
    public boolean asesorDistribucion {get; set;}
    public map<string, string> mapProfile = new map<string, string>();
    public map<string, string> mapIdProfile = new map<string, string>();
    public boolean blnExitoso {get; set;}
    public boolean blnFallido {get; set;}
    public boolean blnSelectOption {get; set;}
    public boolean blnUsersNull {get; set;}
    public map<string, string> mapATM = new map<string, string>();
    
    public COS_reasignacionSalud_ctr(ApexPages.StandardSetController controller){
        this.controller = controller;
        selAccLst = new list<account>();
        string UserId = UserInfo.getUserId();//Returns the context user's ID.
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        
        for(account ac:(list<Account>)controller.getSelected()){
            memIds.add(ac.Id);
        }
        
        mapProfile = new map<string, string>();
        for(profile pf:[select id, name from profile]){
            mapProfile.put(pf.id,pf.Name);
            mapIdProfile.put(pf.Name, pf.id);
        }
        system.debug('mapProfile --->'+mapProfile);
        system.debug('memIds --->'+memIds);
        lstAcc = [select id, name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, OwnerId, Owner.Name from account where id in:memIds];
        lstATM = [select id, AccountId, Account.Name, UserId, User.Name, user.ProfileId from AccountTeamMember where AccountId in:memIds and user.ProfileId=:mapIdProfile.get('Asesor Comercial Salud')]; 
        system.debug('lstAcc PRE --->'+lstAcc);
        system.debug('lstATM --->'+lstATM);
        for(AccountTeamMember tm: lstATM){
            mapATM.put(tm.AccountId, tm.UserId);
        }
        for(account ac:lstAcc){
            system.debug('Salud OwnerId --->'+mapATM.get(ac.Id));
			ac.OwnerId = mapATM.get(ac.Id);
        }
        
        
//        lstAcc = (list<Account>)controller.getSelected();
        system.debug('lstAcc POST --->'+lstAcc);
    }
    
/*	public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__COS_reasignacionCuenta_cmp?c__listofAccounts='+memIds+'&c__fieldMap='+mapOptions+'&options='+lstnamesel;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    public class options{
    	public string id {get;set;}
    	public string label {get;set;}    
    }
*/    
    public List<Selectoption> getselectedaccnamefields(){
        string UserId = UserInfo.getUserId();//Returns the context user's ID.
        string ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
        string idPerfilAsesor = mapIdProfile.get('Asesor Comercial Salud');
        lstUser = [select id, name, COS_No_Cuentas_reasignadas__c from user 
                   where ManagerId=:UserId 
                     and ProfileId =:idPerfilAsesor
                     and IsActive=true 
                     and COS_Usuario_no_disponible__c= false 
                   order by COS_No_Cuentas_reasignadas__c asc];
        
        List<selectoption> lstnamesel = new List<selectoption>();
        
        lstnamesel.add(new selectOption('', '- None -'));
        if(mapProfile.get(ProfileId)=='Coordinador Comercial Salud' || mapProfile.get(ProfileId)=='System Administrator'){
            for(User us:lstUser){
                lstnamesel.add(new selectoption(us.id,us.Name));
            }
        	system.debug('mapOptions --->'+mapOptions);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Su perfil de usuario no apto para ejecutar la acción'));
        }
        System.debug('lstnamesel --->'+lstnamesel);
        return lstnamesel; 
    }
    
    public PageReference cancelar(){
        PageReference cancel = controller.cancel();
//        controller.save();
//        cancel.setRedirect(true);    
            return null;
    }

    public PageReference reasignar(){
        boolean blnEstadoReasignacion = false;
        blnExitoso = false;
		blnFallido = false;
        blnSelectOption = false;
        blnUsersNull = false;
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
        if(lstUser.size()>0){
            if((selectedAsesor==null || selectedAsesor=='' || selectedAsesor=='- None -') && asesorDistribucion == true){
                blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionCuenta_mtd(lstAcc, lstUser, memIds, 'N/A');
                if(blnEstadoReasignacion == true){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Cuentas reasignadas exitosamente'));
                    blnExitoso = true;
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ocurrio un error en la reasignación de cuentas, intente de nuevo por favor'));
                    blnFallido = true;
                }
            }
        }else{
            blnUsersNull = true;
        }
        //--- Asignación a asesor seleccionado
        if(selectedAsesor!=null && selectedAsesor!='' && selectedAsesor!='- None -' && asesorDistribucion==false){
            system.debug('selectedAsesor --->'+selectedAsesor);
            system.debug('lstAcc --->'+lstAcc);
			system.debug('memIds --->'+memIds);			
            list<user> lstUserNull = new list<user>();
            blnEstadoReasignacion = COS_reasignacionGrupo_cls.reasignacionCuenta_mtd(lstAcc, lstUserNull, memIds, selectedAsesor);
            if(blnEstadoReasignacion == true){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Cuentas reasignadas exitosamente'));
                blnExitoso = true;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ocurrio un error en la reasignación de cuentas, intente de nuevo por favor'));
                blnFallido = true;
            }
        }
        
        return null;
    }
    
}