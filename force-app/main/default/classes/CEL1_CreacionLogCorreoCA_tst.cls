/**
* Avanxo Colombia
* @author           Paula Bohórquez href=<pbohorquez@avanxo.com>
* Project:          Compensar
* Description:      Clase de prueba para batch y scheduleable CEL1_CreacionLogCorreoCA_bch
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2019-12-13      Paula Bohórquez (PB)            Creación de la clase
* @version  2.0     2019-12-17      Andrea Contreras (AC)            Creación de los metodos de prueba
*************************************************************************************************************/
@isTest
public class CEL1_CreacionLogCorreoCA_tst {

   @TestSetup
    static void crearData(){
		//Crear Lead
        Lead leadInsert = new Lead();       
        leadInsert.FirstName               ='Prueba';
        leadInsert.MiddleName              ='TestPN';
        leadInsert.LastName                ='Compensar';
        leadInsert.CEL1_TipoCandidato__c   ='CEL1_ProspectoCuentaAcreedoraPN';
        leadInsert.CEL1_TipoDocumento__c   ='1';
        leadInsert.CEL1_NumeroDocumento__c ='18337474';
        leadInsert.Email                   ='prueba@prueba.com';      
       
        insert leadInsert;
        //Crear Task
        Task tarea = new Task();
        tarea.WhoId=leadInsert.Id;
        tarea.Subject='test';
        tarea.Type='Lead';
        tarea.Description='descripción';
        insert tarea;
    }  

    @istest
    public static void creacionLogCorreo_tst(){
        Test.startTest();
        CEL1_CreacionLogCorreoCA_bch creaLog = new CEL1_CreacionLogCorreoCA_bch();
        Id bchId = Database.executeBatch(creaLog,100);
        Test.stopTest();
    }
}