/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_UtilidadesMigracion_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     03/10/17        Juan David Uribe Ruiz             Creación Clase.
************************************************************************************************/
@isTest
public with sharing class COM_UtilidadesMigracion_tst {
  
  @isTest
  public static void crearContactoCuentaNatural(){
    
    Account objAccount = new Account();
    objAccount.COM_Primerapellido__c = 'COM_Primerapellido__c';
    objAccount.COM_Primernombre__c = 'COM_Primernombre__c';
    objAccount.COM_FechaNacimiento__c = date.newInstance(1983, 7, 15);
    objAccount.COM_Numero_de_identificacion__c = '87654567';
    objAccount.COM_TipoIdentificacion__c = '1';
    objAccount.COM_Otrosnombres__c = 'COM_Otrosnombres__c';
    objAccount.Name = 'Name';
    
    RecordType objRT = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SobjectType ='Account' AND DeveloperName = 'COM_Natural'].get(0);
    objAccount.RecordTypeId = objRT.Id;
    
    Test.startTest();
      insert objAccount;
      COM_UtilidadesMigracion_cls objUtil = new COM_UtilidadesMigracion_cls();
      List<Account> lstNewRecords = new List<Account>();
      lstNewRecords.add(objAccount);
            if(label.COM_FaseProyecto == 'MIGRACION'){
                objUtil.crearContactoCuentaNatural(lstNewRecords);
                objUtil.asociarRepresentanteLegal(lstNewRecords);
            }
      objUtil.contadorRepLegalesBatch(lstNewRecords);
      
      
      COM_ActualizarContadorRepLegales_sch objSCH_RL = new COM_ActualizarContadorRepLegales_sch();
      objSCH_RL.execute(null);
      
      
      COM_ActualizarRelCuentaContacto_sch objSCH_CC = new COM_ActualizarRelCuentaContacto_sch();
      objSCH_CC.execute(null);
    Test.stopTest();
  }
    
}