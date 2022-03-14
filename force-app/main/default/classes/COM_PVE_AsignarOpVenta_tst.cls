/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase 



Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/08/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
@isTest
private class COM_PVE_AsignarOpVenta_tst 
{
    private static Account objAcc;
    private static Opportunity objOpp;
    private static COM_TiposAsesoresAccountTeamM__mdt objTAseAccTeam;
    private static RecordType objRecordType;
    public static void createData()
    {
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PVE_nameAsesorADM,UserInfo.getUserId());
        objRecordType = [SELECT Id, Name FROM RecordType where BusinessProcessId in (SELECT Id FROM BusinessProcess where Name =: Label.COM_PVE_nameProcess) Limit 1];

        objTAseAccTeam = COM_DataGenerator_cls.crearTiposAsesoresAccountTeam(false).get(0);
        //objTAseAccTeam.Com_RecordTypeName__c = objRecordType.Name;
        //insert objTAseAccTeam;

    }

    public static testMethod void test_method_one() 
    {
        createData();
        AccountTeamMember objAccTMember = COM_DataGenerator_cls.crearAccountTeamMember(false, objAcc.Id);
        objAccTMember.TeamMemberRole = objTAseAccTeam.COM_ApiNameTipoAsesor__c;
        insert objAccTMember;
        Test.startTest();
            objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
            objOpp.RecordTypeId = objRecordType.Id;
            insert objOpp;
        Test.stopTest();
    }

    public static testMethod void test_method_two() 
    {
        createData();
        Test.startTest();
            objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
            objOpp.RecordTypeId = objRecordType.Id;
            insert objOpp;
        Test.stopTest();
    }

    public static testMethod void test_method_three() 
    {
        createData();
        COM_DataGenerator_cls.crearAsignacion(true,Label.COM_PVE_nameAsesor,UserInfo.getUserId());
        Test.startTest();
            objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
            objOpp.RecordTypeId = objRecordType.Id;
            insert objOpp;
        Test.stopTest();
    }
    public static testMethod void test_method_four()
    {
        createData();
        RecordType objRecordType2 = [SELECT Id, Name FROM RecordType where BusinessProcessId in (SELECT Id FROM BusinessProcess where Name =: Label.COM_PVE_FIN_nameProcess) Limit 1];
        objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
        objOpp.RecordTypeId = objRecordType2.Id;
        objOpp.COM_CicloNegocio__c = 'Financiero Crédito';
        objOpp.StageName = 'Registrado';
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'AfterInsert' );
        insert objOpp;
        List<Opportunity> lstOportunidades = new List<Opportunity>();


        lstOportunidades.add(objOpp );
        COM_PVE_AsignarOpVenta_cls aov = new COM_PVE_AsignarOpVenta_cls();
        aov.asignarOportunidadPVE(lstOportunidades);
    }
}