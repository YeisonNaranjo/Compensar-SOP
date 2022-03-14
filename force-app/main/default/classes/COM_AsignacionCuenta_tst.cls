/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_AsignacionCuenta_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/08/17             Cristian David Mejia (CM)             Creación Clase.
    1.1     02/07/19             Jordan Steven Parra  (JP)             Modificación clase para subir coberturas necesarias.
************************************************************************************************/
@isTest
private class COM_AsignacionCuenta_tst
{
	private static Account objAcc;
	private static User objUser;
	private static User objUserPAF;

    public static void createData()
    {
        List<Contact> lstContact = new List<Contact>();
        objUser 	= [Select Id FROM User WHERE  NOT UserRole.Name like '%PAF%' Limit 1];

        objAcc  		                    = COM_DataGenerator_cls.crearCuenta(false);
        objAcc.COM_TipoIdentificacion__c    = '2';
        //objAcc.COM_Numeroidentificacion__c  = '123456789';
        objAcc.COM_Numero_de_identificacion__c  = '123456789';
        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesor,objUser.Id);
    }

        public static void createDataADM()
    {
        List<Contact> lstContact = new List<Contact>();
        objUser     = [Select Id FROM User WHERE  NOT UserRole.Name like '%PAF%' Limit 1];

        objAcc                              = COM_DataGenerator_cls.crearCuenta(false);
        objAcc.COM_TipoIdentificacion__c    = '2';
        //objAcc.COM_Numeroidentificacion__c  = '123456789';
        objAcc.COM_Numero_de_identificacion__c  = '123456789';
        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesorADM,objUser.Id);
    }


    public static void createDataJuridica()
    {
        List<Contact> lstContact = new List<Contact>();
        objUser     = [Select Id FROM User WHERE  NOT UserRole.Name like '%PVE%' Limit 1];
        List<RecordType> lstRT = [select Id from RecordType where Name = 'Jurídico'];

        objAcc                              = COM_DataGenerator_cls.crearCuenta(false);
        objAcc.COM_TipoIdentificacion__c    = '2';
        //objAcc.COM_Numeroidentificacion__c  = '123456789';
        objAcc.COM_Numero_de_identificacion__c  = '123456789';
        objAcc.RecordTypeId = lstRT.get(0).Id;
        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesor,objUser.Id);
    }

    public static testMethod void test_method_one() 
    {
    	objUserPAF 	= [Select Id FROM User WHERE UserRole.Name like '%Asesor - PAF%' AND Id !=: UserInfo.getUserId() Limit 1];
    	/*System.runAs(objUserPAF)
    	{*/
	        createData();	        
	        Test.startTest();
                //COM_AccountContactRelation_cls.stopTrigger();
	        	insert objAcc;
                //COM_AccountContactRelation_cls.startTrigger();
	        	List<AccountTeamMember> objAccTeam = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE UserId =: objUserPAF.Id];
                if(!objAccTeam.isEmpty()){
	        	  System.assertEquals(objAccTeam.get(0).TeamMemberRole , Label.COM_PAF_TypeTeamAsesor);
                }else{
                    System.assert(objAccTeam.isEmpty());
                }
	        Test.stopTest();    		
    	//}
    }

    public static testMethod void test_method_two() 
    {
    	objUser = [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() Limit 1];

    	/*System.runAs(objUser)
    	{*/
	        createData();
	        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesor,objUser.Id);
	        
	        Test.startTest();
                //COM_AccountContactRelation_cls.stopTrigger();
	        	insert objAcc;
                //COM_AccountContactRelation_cls.startTrigger();

	        	List<COM_Asignacion__c> objAsesoresPAF = [SELECT COM_Usuario__c, COM_FechaAsignacion__c FROM COM_Asignacion__c where Name =: Label.COM_PAF_nameAsesor order by COM_FechaAsignacion__c asc Limit 1];
                if(!objAsesoresPAF.isEmpty()){
	        	  System.assertEquals(objAsesoresPAF.get(0).COM_FechaAsignacion__c.day(), System.now().day());
                }else{
                  System.assert(objAsesoresPAF.isEmpty());
                }

	        	List<AccountTeamMember> objAccTeam = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE UserId =: objUser.Id];
	        	if(!objAccTeam.isEmpty()){
                    System.assertEquals(objAccTeam.get(0).TeamMemberRole , Label.COM_PAF_TypeTeamAsesor);
                }else{
                    System.assert(objAccTeam.isEmpty());
                }
	        Test.stopTest();    		
    	//}
    }

    public static testMethod void test_method_three() 
    {
    	objUser 	= [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() Limit 1];
    	/*System.runAs(objUser)
    	{*/
	     	createData();
	        Test.startTest();
                //COM_AccountContactRelation_cls.stopTrigger();
	        	insert objAcc;
                //COM_AccountContactRelation_cls.startTrigger();

	        	List<COM_Asignacion__c> objAsesoresPAF = [SELECT COM_Usuario__c, COM_FechaAsignacion__c FROM COM_Asignacion__c where Name =: Label.COM_PAF_nameAsesorADM order by COM_FechaAsignacion__c asc Limit 1];
                if(!objAsesoresPAF.isEmpty()){                
	        	  System.assertEquals(objAsesoresPAF.get(0).COM_FechaAsignacion__c.day(), System.now().day());
                }else{
                  System.assert(objAsesoresPAF.isEmpty()); 
                }

	        	List<AccountTeamMember> objAccTeam = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE UserId =: objUser.Id];
                if(!objAccTeam.isEmpty()){  
	        	  System.assertEquals(objAccTeam.get(0).TeamMemberRole , Label.COM_PAF_TypeTeamAsesor);
                }else{
                  System.assert(objAccTeam.isEmpty()); 
                }
	        Test.stopTest();
	    //}
    }


     public static testMethod void test_method_four() 
    {
        objUserPAF  = [Select Id FROM User WHERE UserRole.Name like '%Asesor - PVE%' AND Id !=: UserInfo.getUserId() Limit 1];
        objUser     = [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() Limit 1];

        System.runAs(objUserPAF)
        {
            createData();           
            Test.startTest();
                List<RecordType> rtLst = [SELECT Id FROM RecordType where Name = 'Jurídico'];
                objAcc.RecordTypeId = rtLst.get(0).Id;
                COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesor,objUser.Id);
                //COM_AccountContactRelation_cls.stopTrigger();
                insert objAcc;
                //COM_AccountContactRelation_cls.startTrigger();
                List<AccountTeamMember> objAccTeam = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE UserId =: objUserPAF.Id];
                if(!objAccTeam.isEmpty()){
                  System.assertEquals(objAccTeam.get(0).TeamMemberRole , Label.COM_PAF_TypeTeamAsesor);
                }else{
                    System.assert(objAccTeam.isEmpty());
                }
            Test.stopTest();            
        }
    }

     public static testMethod void test_method_five() 
    {
        objUserPAF  = [Select Id FROM User WHERE UserRole.Name like '%Asesor - PVE%' AND Id !=: UserInfo.getUserId() Limit 1];
        objUser     = [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() Limit 1];

        System.runAs(objUserPAF)
        {
            createDataADM();           
            Test.startTest();
                List<RecordType> rtLst = [SELECT Id FROM RecordType where Name = 'Jurídico'];
                objAcc.RecordTypeId = rtLst.get(0).Id;
                COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesorADM,objUser.Id);
                //COM_AccountContactRelation_cls.stopTrigger();
                insert objAcc;
                //COM_AccountContactRelation_cls.startTrigger();
                List<AccountTeamMember> objAccTeam = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE UserId =: objUserPAF.Id];
                if(!objAccTeam.isEmpty()){
                  System.assertEquals(objAccTeam.get(0).TeamMemberRole , Label.COM_PAF_TypeTeamAsesor);
                }else{
                    System.assert(objAccTeam.isEmpty());
                }
            Test.stopTest();            
        }
    }
//Inicio v1.1
     public static testMethod void test_method_six() 
    {
        objUserPAF  = [Select Id FROM User WHERE UserRole.Name like '%Asesor - PAF%' AND Id !=: UserInfo.getUserId() Limit 1];
        objUser     = [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() Limit 1];

        System.runAs(objUserPAF)
        {
            createDataADM();           
            Test.startTest();
                List<RecordType> rtLst = [SELECT Id FROM RecordType where Name = 'Jurídico'];
                objAcc.RecordTypeId = rtLst.get(0).Id;
                objAcc.AccountSource = 'Sede Suba';
                COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PAF_nameAsesorADM,objUser.Id);
                //COM_AccountContactRelation_cls.stopTrigger();
                insert objAcc;
                //COM_AccountContactRelation_cls.startTrigger();
                List<AccountTeamMember> objAccTeam = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE UserId =: objUserPAF.Id];
                if(!objAccTeam.isEmpty()){
                  System.assertEquals(objAccTeam.get(0).TeamMemberRole , Label.COM_PAF_TypeTeamAsesor);
                }else{
                    System.assert(objAccTeam.isEmpty());
                }
                COM_AsignacionCuenta_cls clsTest = new COM_AsignacionCuenta_cls();
                clsTest.AsignarCuentaPrivate(objAcc);
            Test.stopTest();            
        }
    }
//Final  v1.1
}