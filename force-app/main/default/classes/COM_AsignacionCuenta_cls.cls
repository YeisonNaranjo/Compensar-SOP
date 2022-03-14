/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             William Alexander Aldana Carvajal (WA)
Proyecto:          Compensar
Descripción:       Clase Trigger COM_AsginacionCuente_tgr donde se realizan los siguientes operaciones
- Asignar usuario al equipo de cuenta
Actualmente solo funciona para PAF
Envia correos informando de la asignacion

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     04/08/2017      William Aldana (WA)     Creación Clase.
1.1     25/06/2019      Jordan Parra (JP)       Inserción de logs de error.
1.2     15/08/2019      Andrés Ariza            Ajustes para evitar 101 Queries
1.3     23/01/2020		Yeison Naranjo          Validar si es ARL.
****************************************************************************************************/
public class COM_AsignacionCuenta_cls 
{    
    Public Integer intCountAsigPAF = 0;
    Public Integer intCountAsigADM = 0;
    
    public List<User> administrador {get; set;}
    public List<UserRole> lstRol {get; set;}
    public List<AccountTeamMember> lstMembers {get; set;}
    public List<AccountShare> lstAccShareList {get; set;}
    public List<COM_UtilidadCorreo_cls.CorreoSimple> lstCorreosEnviar {get; set;}
    public List<COM_Asignacion__c> lstAsesoresPAF {get; set;}
    public List<COM_Asignacion__c> lstAsesoresADM {get; set;}
    
    public Contact tempContact;
    
    Set<String> setCorreos = new Set<String>();
    Set<COM_Asignacion__c>  lstAsignaciones = new Set<COM_Asignacion__c>();
    
    public COM_AsignacionCuenta_cls(){               
        lstCorreosEnviar = new List<COM_UtilidadCorreo_cls.CorreoSimple>();
        lstAccShareList = new List<AccountShare>();
        lstMembers = new list<AccountTeamMember>();        
        
        If(lstRol == null){
            //Inicio 1.2
            //lstRol = [SELECT Name FROM UserRole where Id in (SELECT UserRoleId from User where Id =: UserInfo.getUserId())];
            lstRol = COM_AsignacionCuentaCachedResult_cls.lstRol();
            //lstAsesoresPAF = [SELECT COM_Usuario__c, COM_Usuario__r.Email, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PAF_nameAsesor order by COM_FechaAsignacion__c asc];
            lstAsesoresPAF = COM_AsignacionCuentaCachedResult_cls.lstAsesoresPAF();
            //lstAsesoresADM = [SELECT COM_Usuario__c, COM_Usuario__r.Email, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PAF_nameAsesorADM order by COM_FechaAsignacion__c asc];
            lstAsesoresADM = COM_AsignacionCuentaCachedResult_cls.lstAsesoresADM();
            List<RecordType> idJuridico = [SELECT Id FROM RecordType where Name = 'Jurídico'];
            //administrador = [SELECT Id from User where Name =: Label.COM_Administrador_CRM];
            administrador = COM_AsignacionCuentaCachedResult_cls.administrador();
            // Fin 1.2
        }  
        
        //Contact tempContact;
    }
    /**
* [asignarAdminitrador description]
* @param lstNewRecords [description]
*/
    public void asignarAdminitrador(List<Account> lstNewRecords){
        //cambiar el Owner a Administrador
        if(!administrador.isEmpty()){
            for(Account cuenta : lstNewRecords)
            {
                cuenta.OwnerId = administrador.get(0).Id;
            }
        }
    }
    
    /**
* [asignarCuenta description]
* @param lstNewRecords [description]
*/
    public void asignarCuenta(List<Account> lstNewRecords)
    {
        tempContact = new Contact(email = 'correo@servidor.com', firstName = 'Dummy', lastName = 'User');
        insert tempContact;
        //Inicio v1.1
        list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
        COM_LogTransacciones__c objLog;
        String strRequestAux = '';
        //Final  v1.1
        for(Account cuenta : lstNewRecords)
        {
            setCorreos = new Set<String>();
            // si el usuario no es digitador se trata de asignar
            if(!lstRol.isEmpty() && !lstRol.get(0).Name.containsIgnoreCase('Digitador'))
            {
                // se verifica que el usuario que realiza la creacion es un Asesor PAF
                if(!lstRol.isEmpty() && lstRol.get(0).Name.containsIgnoreCase('PAF'))
                {
                    System.debug('entro a paf');
                    // se crea el account Team member a la cuenta
                    lstMembers.add(New AccountTeamMember(AccountId = cuenta.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId= UserInfo.getUserId()));      
                    setCorreos.add(UserInfo.getUserEmail());
                    crearCorreoEnviar(UserInfo.getUserId(), cuenta, setCorreos);          
                }else{
                    /*System.debug('no entro a paf');
if(!lstRol.isEmpty() && lstRol.get(0).Name.containsIgnoreCase('PVE')){
System.debug('entro a pve');
if(cuenta.RecordTypeId == idJuridico.get(0).Id){
AsignarCuentaPrivate(cuenta);
}
}else{
System.debug('no entro a nada');
AsignarCuentaPrivate(cuenta);
}*/
                }
            } /*else{
AsignarCuentaPrivate(cuenta);
}*/
            // siempre debemos asignar un AccoutShare para el creador de la cuenta
            addAccountShare(cuenta.Id, UserInfo.getUserId(), 'Edit');
        }
        
        try {
            insert lstMembers;
            system.debug('>>>>>>>>>>>>>>>> lstAsignaciones: ' + lstAsignaciones);
            update new List<COM_Asignacion__c>(lstAsignaciones);
            upsert lstAccShareList; 
            try{
                COM_UtilidadCorreo_cls.enviarListCorreo(lstCorreosEnviar);
            }
            catch(Exception ex) {
                System.debug('ERROR ENVIANDO CORREO: ' + ex.getMessage());    
            }
        }
        catch(Exception e) {
            //Inicio v1.1
            for (AccountTeamMember actMember : lstMembers){
                strRequestAux = 'TeamMemberRole: ' + actMember.TeamMemberRole;
                strRequestAux += '; UserId: ' + actMember.UserId;
                objLog = COM_Utilidades_cls.generarLog(actMember.AccountId, strRequestAux, null, Label.COM_AsignacionCuentasError,  e.getMessage() + ' ' + e.getStackTraceString());
                lstLogs.add(objLog);
            }
            insert lstLogs;
            //Final  v1.1
            System.debug(e.getMessage());    
        }
        
        try{delete tempContact;} catch(Exception ex) {}
        
    }
    
    /**
* [AsignarCuentaPrivate description]
* @param cuenta [description]
*/
    @TestVisible
    private void AsignarCuentaPrivate(Account cuenta){
        // se crea la asignacion del account team buscando en las Asignaciones
        if(!lstAsesoresPAF.isEmpty())
        {
            COM_Asignacion__c asignacion =  lstAsesoresPAF.get(intCountAsigPAF);
            asignacion.COM_FechaAsignacion__c = System.now();
            lstAsignaciones.add(asignacion);
            
            lstMembers.add(New AccountTeamMember(AccountId = cuenta.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId= asignacion.COM_Usuario__c));     
            // si el usuario asignado es diferente del creador
            if(asignacion.COM_Usuario__c != UserInfo.getUserId()){
                // se crear el AccountShare al usuario asignado
                addAccountShare(cuenta.Id, asignacion.COM_Usuario__c, 'Edit');
            }
            setCorreos.add(asignacion.COM_Usuario__r.Email);
            crearCorreoEnviar(asignacion.COM_Usuario__c, cuenta, setCorreos);                       
            intCountAsigPAF++;
            if(intCountAsigPAF == lstAsesoresPAF.size()){
                intCountAsigPAF=0;      
            }
        }else if(!lstAsesoresADM.isEmpty())
        {
            // buscar en la lista de Asesores Administrativos
            COM_Asignacion__c asignacionA =  lstAsesoresADM.get(intCountAsigPAF);
            asignacionA.COM_FechaAsignacion__c = System.now();
            lstAsignaciones.add(asignacionA);
            lstMembers.add(New AccountTeamMember(AccountId = cuenta.Id, TeamMemberRole = Label.COM_PAF_TypeTeamAsesor, UserId= asignacionA.COM_Usuario__c));        
            setCorreos.add(asignacionA.COM_Usuario__r.Email);
            if (!Test.isRunningTest()){crearCorreoEnviar(asignacionA.COM_Usuario__c, cuenta, setCorreos);}
            // si el usuario asignado es diferente del creador
            if(asignacionA.COM_Usuario__c != UserInfo.getUserId()){
                // se crear el AccountShare al usuario asignado
                addAccountShare(cuenta.Id, asignacionA.COM_Usuario__c, 'Edit');
            }
            
            intCountAsigADM++;
            if(intCountAsigADM == lstAsesoresADM.size()){
                intCountAsigADM=0;      
            }
        }
        
    }
    
    /**
* [crearCorreoEnviar description]
* @param userId  [description]
* @param account [description]
*/
    private void crearCorreoEnviar(Id userId, Account account, Set<String> setCorreos)
    {
        lstCorreosEnviar.add(new COM_UtilidadCorreo_cls.CorreoSimple(setCorreos, null, null, null, Label.COM_PAF_CorreoAsignacionCuentaTpl, tempContact.Id, account.Id));
    }
    
    /**
* [addAccountShare description]
* @param accountId [description]
* @param userId    [description]
* @param value     [description]
*/
    private void addAccountShare(Id accountId, Id userId, String value){
        System.debug('entro a accshr '+accountId+' '+userId+' '+value);
        AccountShare acctShare = new AccountShare();
        acctShare.AccountId = accountId;
        acctShare.UserOrGroupId = userId;
        acctShare.AccountAccessLevel = value;
        acctShare.CaseAccessLevel = value;
        acctShare.OpportunityAccessLevel = value;
        lstAccShareList.add(acctShare);
    }
    
    /* Inicio 1.3 */
    public void validarEsARL(List<Account> lstNewRecords){
        for(Account cuenta : lstNewRecords)
        {	
            System.debug('COM_EsARL__c ' + cuenta.COM_EsARL__c);
            System.debug('COM_ARL1__c ' + cuenta.COM_CodigoARL__c);
            If(!cuenta.COM_EsARL__c && (cuenta.COM_CodigoARL__c != Null || String.isNotBlank(cuenta.COM_CodigoARL__c))){
                cuenta.COM_CodigoARL__c = Null;
            }
        }
    }
    /* Fin 1.3 */
}