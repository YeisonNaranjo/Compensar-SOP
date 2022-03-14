/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Andrés Ariza(AA)
Proyecto:          Compensar
Descripción:       Clase cached para evitar repeticiones de queries
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     15/08/2019          Andrés Ariza(AA)           Creación Clase.
****************************************************************************************************/

public class COM_AsignacionCuentaCachedResult_cls {

    private static List<USerRole> lstRolStatic                  = new List<USerRole>();
    private static List<COM_Asignacion__c> lstAsesoresPAFStatic = new List<COM_Asignacion__c>();
    private static List<COM_Asignacion__c> lstAsesoresADMStatic = new List<COM_Asignacion__c>();
    private static List<User> administradorStatic               = new List<User>();
    private static Boolean isCachedRol           =  false;
    private static Boolean isCachedAsesoresPAF   =  false;
    private static Boolean isCachedAsesoresADM   =  false;
    private static Boolean isCachedAdministrador =  false;
    
    
    public static List<UserRole> lstRol(){
        if(isCachedRol){
            return lstRolStatic;
        }else{
            cacheRol();
            return lstRolStatic;
        }
    }

    public static List<COM_Asignacion__c> lstAsesoresPAF(){
        if(isCachedAsesoresPAF){
            return lstAsesoresPAFStatic;
        }else{
            cacheAsesoresPAF();
            return lstAsesoresPAFStatic;
        }
    }

    public static List<COM_Asignacion__c> lstAsesoresADM(){
        if(isCachedAsesoresADM){
            return lstAsesoresADMStatic;
        }else{
            cacheAsesoresADM();
            return lstAsesoresADMStatic;
        }
    }
    
    public static List<User> administrador(){
        if(isCachedAdministrador){
            return administradorStatic;
        }else{
            cacheadministrador();
            return administradorStatic;
        }
    }
    
    private static void cacheRol(){
        lstRolStatic         = [SELECT Name FROM UserRole where Id in (SELECT UserRoleId from User where Id =: UserInfo.getUserId())];
        isCachedRol = true;
    }
    
    private static void cacheAsesoresPAF(){
        lstAsesoresPAFStatic = [SELECT COM_Usuario__c, COM_Usuario__r.Email, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PAF_nameAsesor order by COM_FechaAsignacion__c asc];
        isCachedAsesoresPAF = true;
    }

    private static void cacheAsesoresADM(){
        lstAsesoresADMStatic = [SELECT COM_Usuario__c, COM_Usuario__r.Email, COM_FechaAsignacion__c FROM COM_Asignacion__c where COM_perfil__c =: Label.COM_PAF_nameAsesorADM order by COM_FechaAsignacion__c asc];
        isCachedAsesoresADM = true;
    }

    private static void cacheadministrador(){
        administradorStatic  = [SELECT Id from User where Name =: Label.COM_Administrador_CRM];
        isCachedAdministrador = true;
    }        
}