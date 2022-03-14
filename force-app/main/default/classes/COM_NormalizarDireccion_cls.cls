/**
 * 
 */
 public without sharing class COM_NormalizarDireccion_cls {

  public static Boolean allow = true;

  public static void stopTrigger(){
    allow = false;
  }

  public static boolean canIRun(){
    return allow;
  }

  public static void startTrigger(){
    allow = false;
  }

  public static Map<String, String> getPoblacionesList(){
    Map<String, String> mapx = new Map<String, String>();
    Schema.DescribeFieldResult fieldResult = Account.COM_Localidad__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for(Schema.PicklistEntry f : ple)
    {
      mapx.put(f.getLabel(), f.getValue());
    }  

    return mapx;
  }


    /**
     * [normalizarDireccion description]
     * @param cuentasNormalizar [description]
     */
    public void normalizarDireccion(List<Account> lstOldCuentasNormalizar, List<Account> lstCuentasNormalizar){
      Map<Id, Profile> mapPerfil = new Map<Id, Profile>([SELECT Id, Name FROM Profile]);
      if(mapPerfil.get(userinfo.getProfileId()).Name != 'integraciones_WS'){
        if(COM_NormalizarDireccion_cls.canIRun()){
          Set<Id> stCuentasNormalizar = new Set<Id>();
          if(lstOldCuentasNormalizar == null){
            for(Account obj : lstCuentasNormalizar)
            {
              stCuentasNormalizar.add(obj.Id);
            }
          }else{
            for(Account objNew : lstCuentasNormalizar)
            {
              for(Account objOld : lstOldCuentasNormalizar)
              {
                if(objnew.Id.equals(objOld.Id)){
                  if(objnew.COM_Direccion__c!= null){
                    if(!objnew.COM_Direccion__c.equals(objOld.COM_Direccion__c)){
                      stCuentasNormalizar.add(objnew.Id);            
                    }
                  }
                }        
              }
            }
          }
          COM_NormalizarDireccion_cls.normalizaCuentas(stCuentasNormalizar);
        }
      }
    }

    /**
     * [normalizaCuentas description]
     */
     @Future(callout=true)
     public static void normalizaCuentas(Set<Id> stCuentasNormalizarIN){
      COM_LogTransacciones__c objLog;
      String strRequestAux;
      User u = [SELECT COM_PermisosEscrituraGC__c FROM User WHERE Id =: userinfo.getUserId()];
      List<Account> lstCuentasNormalizar = [Select COM_Ciudad__c, COM_Direccion__c From Account where ID in: stCuentasNormalizarIN];
      for(Account cuenta : lstCuentasNormalizar){
       if(!String.isEmpty(cuenta.COM_Direccion__c) && cuenta.COM_Ciudad__c != null){
        List<COM_Poblacion__c> lstPoblacion = [Select COM_Codigo__c FROM COM_Poblacion__c where Id =: cuenta.COM_Ciudad__c];
        if(!lstPoblacion.isEmpty()){                
         Integer codigoCiudad = Integer.valueOf(lstPoblacion.get(0).COM_Codigo__c);
         COM_Georeferenciacion_ws ws = new COM_Georeferenciacion_ws();
         try {
          COM_Georeferenciacion_ws.GeoreferenciacionWrapper direccionNormalizada = ws.consultarGeoreferenciacion(cuenta, codigoCiudad); 
          objLog = COM_Utilidades_cls.generarLog(cuenta.Id, cuenta+'<<<<>>>> codigoCiudad: ' + codigoCiudad, direccionNormalizada, Label.COM_WS_Georeferenciacion, null);
          System.debug('dir - '+direccionNormalizada);
          if(direccionNormalizada.strDireccionEstandarizada != null)
            cuenta.COM_Direccion__c = direccionNormalizada.strDireccionEstandarizada;
          if(direccionNormalizada.strLocalidad!= null){
              String localidadCode = COM_NormalizarDireccion_cls.getPoblacionesList().get(direccionNormalizada.strLocalidad);
              cuenta.COM_Localidad__c = localidadCode;
          }
          else
            cuenta.COM_Localidad__c = '98';
          if(direccionNormalizada.strBarrio != null)
            cuenta.COM_Barrio__c = direccionNormalizada.strBarrio;
          else
            cuenta.COM_Barrio__c = '-';
        }
        catch (Exception e) {
                        //cuenta.COM_Barrio__c = e.getMessage() + ' oh oh';
                        objLog = COM_Utilidades_cls.generarLog(cuenta.Id, cuenta+'<<<<>>>> codigoCiudad: ' + codigoCiudad, null, Label.COM_WS_Georeferenciacion, e.getMessage() + ' ' + e.getStackTraceString());
                    }
                }
            }
        }
        
        try{
            if(objLog != null){
       insert objLog;
      }
     } catch(Exception e){
      system.debug('NO SE PUDO GUARDAR EL LOG.');
      System.Debug('====================== EXCEPCION [log normalizaCuentas] ======================');
      System.debug( e.getMessage() + ' ' + e.getStackTraceString());
      System.Debug('========================================================================================');
    }
    
    
    if(u.COM_PermisosEscrituraGC__c){
       COM_AccountContactRelation_cls.stopTrigger();
      COM_NormalizarDireccion_cls.stopTrigger();
        update lstCuentasNormalizar;
      COM_AccountContactRelation_cls.startTrigger();
      COM_NormalizarDireccion_cls.startTrigger();
    } else {
      u.COM_PermisosEscrituraGC__c = true;
      update u;
      COM_AccountContactRelation_cls.stopTrigger();
      COM_NormalizarDireccion_cls.stopTrigger();
      update lstCuentasNormalizar;
      COM_NormalizarDireccion_cls.startTrigger(); 
      COM_AccountContactRelation_cls.startTrigger();
      u.COM_PermisosEscrituraGC__c = false;
      update u;
    }
    
  }
}