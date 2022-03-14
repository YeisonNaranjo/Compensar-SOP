/**
* Avanxo Colombia
* @author           Paula Bohórquez href=<pbohorquez@avanxo.com>
* Project:          Compensar
* Description:      Clase de prueba para batch y scheduleable CEL1_EnvioCorreoCuentaAcreedora_bch
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2019-12-13      Paula Bohórquez (PB)            Creación de la clase
*************************************************************************************************************/
@isTest
public class CEL1_EnvioCorreoCuentaAcreedora_tst {

    @TestSetup
    static void crearData(){
		//Crear Leads

        List<Lead> lstLeadInsert = new List<Lead>();
        for (Integer i = 0 ; i<50 ; i++) {
            lstLeadInsert.add(new Lead(
                FirstName               ='Prueba',
                MiddleName              ='TestPN',
                LastName                ='Compensar',
                CEL1_TipoCandidato__c   ='CEL1_ProspectoCuentaAcreedoraPN',
                CEL1_TipoAportante__c   =Label.CEL1_TipoAportanteIndependiente,
                CEL1_TipoDocumento__c   ='1',
                CEL1_NumeroDocumento__c ='18337474'+String.valueOf(i),
                Phone = '13213213'+String.valueOf(i)
               // Email                   ='prueba@prueba'+String.valueOf(i)+'.com'
            ));
        }

        for (Integer i = 0 ; i<50 ; i++) {
            lstLeadInsert.add(new Lead(
                FirstName               ='Prueba',
                MiddleName              ='TestPJ',
                LastName                ='Compensar',
                CEL1_TipoCandidato__c   ='CEL1_ProspectoCuentaAcreedoraPJ',
                CEL1_TipoDocumento__c   ='1',
                CEL1_TipoAportante__c   =Label.CEL1_TipoAportanteJuridica,
                CEL1_NumeroDocumento__c ='13483474'+String.valueOf(i),
                Phone = '13213213'+String.valueOf(i)
                //Email                   ='pruebaPJ@prueba'+String.valueOf(i)+'.com'
            ));
        }
        
        insert lstLeadInsert;
        
        
    }
    
    @istest
    public static void enviarCorreosBch_tst(){
        List<Lead> lstLeadUpd = new List<Lead>();
        Integer i = 0;
        for(Lead objCandidato : [SELECT Id,Email FROM Lead limit 10]){
            objCandidato.Email = 'test'+String.valueOf(i)+'@test.com';
            i++;
            lstLeadUpd.add(objCandidato);
        }
        update lstLeadUpd; 
        Test.startTest();
            CEL1_EnvioCorreoCuentaAcreedora_sch envioAc = new CEL1_EnvioCorreoCuentaAcreedora_sch();
            String sch = '0 0 23 * * ?';
            System.schedule('Test CEL1_EnvioCorreoCuentaAcreedora_sch', sch, envioAc);           
         //   Id bchId = Database.executeBatch(envioAc,100);
        Test.stopTest();
    }
    
    @istest
    public static void enviarCorreosBchError_tst(){
        Test.startTest();
            CEL1_EnvioCorreoCuentaAcreedora_bch envioAc = new CEL1_EnvioCorreoCuentaAcreedora_bch();
            envioAc.intEmailsDisponiblesEnviar = 0;
        	Id bchId = Database.executeBatch(envioAc,100);
        Test.stopTest();
    }

}