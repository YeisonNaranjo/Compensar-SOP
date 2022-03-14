/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_Account_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     20/06/19        Stifen Panche (SP)             Creación Clase.
----------  -------------   ----------------------  ---------------------------------------------
2.0     19/08/20        Yeison Naranjo (YN)            Oportunidad con programa de vinculación.
************************************************************************************************/
@isTest
public class COM_OpportunityHandler_tst {
    
    private static Account objAcc;
    private static Opportunity objOpp;
    private static Contact objContact;
    /* Inicio 2.0 */
    private static Opportunity objOpp2;
    private static COM_ProgramaVinculacion__c objProgramaVinculacion;
    private static COM_CalculadoraSuperavit2__c objCalculadora;
    
	private static Opportunity objOpp3;
    private static Opportunity objOpp4;
    private static Id rtId;
    /* Fin 2.0 */
    
    public static void createData()
    {
        rtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COS_ConsorcioSalud').getRecordTypeId();
        
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'BeforeInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Account_tgr', 'AfterInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Contact_tgr', 'BeforeInsert' );
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Contact_tgr', 'AfterInsert' );
        
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        
        /* Inicio 2.0 */ 
        objProgramaVinculacion = COM_DataGenerator_cls.crearProgramaVinculacion1(true, true);
        objCalculadora = COM_DataGenerator_cls.crearCalculadoraSuperavit2(true);
        //objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id, objProgramaVinculacion.Id);      
        objOpp = COM_DataGenerator_cls.crearOportunidadConPrgVinc(false,objAcc.Id, objProgramaVinculacion.Id);
        objOpp.StageName = 'En tramite';
        objOpp.RecordTypeId = rtId;
        
        
        // objOpp1 = COM_DataGenerator_cls.crearOportunidad(false,objOpp1.Id); 
        
        /* Fin 2.0 */
        objOpp3 = COM_DataGenerator_cls.crearOportunidadConPrgVinc(false,objAcc.Id, objProgramaVinculacion.Id);
        objOpp3.StageName = 'En tramite';
        objOpp3.RecordTypeId = rtId;
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(objOpp3);
        oppList.add(objOpp);
        
        insert oppList;
        
        oppList.clear();
        
        objOpp3.Nombre_Unico_Oportunidad__c = crearLlave(objOpp3);
        objOpp.Nombre_Unico_Oportunidad__c = crearLlave(objOpp);
        oppList.add(objOpp3);
        oppList.add(objOpp);
        
        update oppList;
        
    }
    
    public static testMethod void test_method_one() 
    {
        createData();
        
        objOpp2 = COM_DataGenerator_cls.crearOportunidadConPrgVinc(false,objAcc.Id, objProgramaVinculacion.Id);
        insert objOpp2;
    }  
    
    @isTest static void crear_crearOportunidad_Tets(){
        createData();
        
        List<Opportunity> listOpp = new List<Opportunity>();
       	listOpp.add(objOpp3);
        
       	Test.startTest();
        COM_OpportunityHandler_cls.resetNombreUnicoDupInsert(listOpp);
        Test.stopTest();
        
        System.assert(objOpp3 != null);
    }
    
    @isTest static void crear_crearOportunidadTwo_Test(){
        createData();
        
        List<Opportunity> listOpp = new List<Opportunity>();
        listOpp.add(objOpp);
        objOpp3.StageName = 'Registrado';
        update objOpp3;
        objOpp4 = COM_DataGenerator_cls.crearOportunidadConPrgVinc(false,objAcc.Id, objProgramaVinculacion.Id);
        objOpp4.StageName = 'Asignada';
        objOpp4.RecordTypeId = rtId;
        insert objOpp4;
        objOpp4.Nombre_Unico_Oportunidad__c = objOpp3.Nombre_Unico_Oportunidad__c;
        update objOpp4;
        
       	Test.startTest();
        COM_OpportunityHandler_cls.resetNombreUnicoDupInsert(listOpp);
       
        Test.stopTest();
    }
    
    private static String crearLlave(Opportunity opp){
        Integer varAnio = System.today().year();
        return opp.COM_TipoDocumento__c + opp.COM_NumeroIdentificacion__c + 
            opp.COM_ProgramaVinculacion1__c + String.valueOf(opp.RecordTypeId).substring(0,15) + varAnio;
    }
}