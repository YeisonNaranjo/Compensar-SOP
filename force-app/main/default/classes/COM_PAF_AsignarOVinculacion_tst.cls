/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_PAF_AsignarOVinculacion_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/08/17             Cristian David Mejia (CM)             Creación Clase.
    1.1     28/05/19             Stifen Panche Gutierrez (SP)          Creación Cuenta.
************************************************************************************************/
@isTest
private class COM_PAF_AsignarOVinculacion_tst 
{
	private static Account objAcc;
	private static Opportunity objOpp;
    
    /*Inicio 1.1*/
    
    public static Account crearCuenta(boolean doInsert){
          Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test';
          objCuenta.AccountNumber = '654321';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
          objCuenta.COM_Numero_de_identificacion__c = '12345678909';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
          objCuenta.AccountSource = 'Call Center';
    
          if(doInsert){
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
    
        return objCuenta;
    }
    
    /*Fin 1.1*/
    
	public static void createData()
    {
        objAcc = crearCuenta(true);
        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesorADM,UserInfo.getUserId());
    }

    public static testMethod void test_method_one() 
    {
    	createData();
	    AccountTeamMember objACCTeam = COM_DataGenerator_cls.crearAccountTeamMember(true,objAcc.Id);
        Test.startTest();
    	    objOpp = COM_DataGenerator_cls.crearOportunidad(true,objAcc.Id);
        Test.stopTest();
    }

    public static testMethod void test_method_two() 
    {
    	createData();
        Test.startTest();
    	    objOpp = COM_DataGenerator_cls.crearOportunidad(true,objAcc.Id);
        Test.stopTest();
    }

    public static testMethod void test_method_three() 
    {
    	createData();
	    COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesor,UserInfo.getUserId());
        Test.startTest();
    	    objOpp = COM_DataGenerator_cls.crearOportunidad(true,objAcc.Id);
        Test.stopTest();
    }
}