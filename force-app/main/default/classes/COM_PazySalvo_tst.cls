/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_PazySalvo_ctr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     04/08/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/

@isTest
private class COM_PazySalvo_tst 
{
    public static EmailTemplate objEmailT;
    public static Account objAcc;

    public static void createData()
    {
        COM_ConfiguracionConsecutivos__c objConf    = new COM_ConfiguracionConsecutivos__c();
        objConf.Name                                = 'Test';
        objConf.COM_Formato__c                      = 'TST-####-ddmmAAAA';
        objConf.COM_IdentificadorProceso__c         = 'TST';
        insert objConf;

        objAcc                              = COM_DataGenerator_cls.crearCuenta(false);
        objAcc.COM_TipoIdentificacion__c    = '3';
        //objAcc.COM_Numeroidentificacion__c  = '123456789';
        objAcc.COM_Numero_de_identificacion__c = '123456789';
        objAcc.COM_Genero__c                = 'M';
        objAcc.COM_FechaAfiliacion__c       = System.today();
        objAcc.COM_FechaRetiro__c           = System.today();
        objAcc.COM_Periodoultimoaporte__c   = System.today();
                
        objEmailT = [Select id,DeveloperName FROM EmailTemplate where DeveloperName = 'COM_FichaTecnicaLagoMarSol'][0];
    }

    public static testMethod void test_method_sucess() 
    {
        createData();
        insert objAcc;
        PageReference pageRef = Page.COM_PazySalvo_pag;
        Test.setCurrentPage(pageRef);
        System.debug([Select id,DeveloperName FROM EmailTemplate]);
        ApexPages.currentPage().getParameters().put('tipoDoc', objEmailT.DeveloperName);
        ApexPages.currentPage().getParameters().put('idProc', 'TST');

        Test.startTest();
            ApexPages.Standardcontroller stdController =  new ApexPages.StandardController(objAcc);
            COM_PazySalvo_ctr controller = new COM_PazySalvo_ctr(stdController);
            controller.getBody();
        Test.stopTest();
    }

    public static testMethod void test_method_sucess2() 
    {
        createData();
        objAcc.COM_Genero__c                = 'F';
        insert objAcc;
        PageReference pageRef = Page.COM_PazySalvo_pag;
        Test.setCurrentPage(pageRef);
        System.debug([Select id,DeveloperName FROM EmailTemplate]);
        ApexPages.currentPage().getParameters().put('tipoDoc', objEmailT.DeveloperName);

        Test.startTest();
            ApexPages.Standardcontroller stdController =  new ApexPages.StandardController(objAcc);
            COM_PazySalvo_ctr controller = new COM_PazySalvo_ctr(stdController);
            controller.getBody();
        Test.stopTest();
    }
}