/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase CEL1_BorrarLogCorreo_tst

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/12/19         Manuel Mendez (MM)      Creación Clase.
************************************************************************************************/
@isTest
public class CEL1_BorrarLogCorreo_tst {
    @istest
    public static void unitTets1()
	{

        CEL1_ConfiguracionLogCorreos__mdt objMetadata = [SELECT CEL1_NumeroCorreosSalientes__c,
                                                        CEL1_RangoDiasBorrarLogsCorreo__c,
                                                        Id
                                                        FROM CEL1_ConfiguracionLogCorreos__mdt
                                                        limit 1];
        Integer intDias = Integer.valueOf(objMetadata.CEL1_RangoDiasBorrarLogsCorreo__c);
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '8800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        insert objCandidato;

        Log_Correo_Electronico__c objLogCorreo = new Log_Correo_Electronico__c();
        objLogCorreo.CEL1_Candidato__c      =   objCandidato.Id;
        objLogCorreo.CEL1_FechaAbierto__c   =   System.now();
        insert objLogCorreo;
        Datetime yesterday = Datetime.now().addDays(-intDias);
        Test.setCreatedDate(objLogCorreo.Id, yesterday);

        Test.startTest();
            CEL1_BorrarLogCorreo_sch clsSCH = new CEL1_BorrarLogCorreo_sch();
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, clsSCH);
        Test.stopTest();
    }
}