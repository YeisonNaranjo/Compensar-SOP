/****************************************************************************************************
    Información general
    -------------------
    author: Jordan Parra
    email: jsparra@avanxo.com
    company: Avanxo Colombia
    Description: Clase COM_EnviarCorreoTemplate_sch_tst clase de prueba para la cobertura de la clase
	COM_EnviarCorreoTemplate_sch
        
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       07-Octubre-2019     Jordan Parra              Creación de la Clase de prueba
****************************************************************************************************/
@istest
public class COM_EnviarCorreoTemplate_sch_tst {
    static testmethod void testbatch() {      
        Account accTest = new Account();
        accTest.Name = 'prueba1';
        insert accTest;
        
        Contact conTest = new Contact();
        conTest.FirstName = 'prueba';
        conTest.LastName = 'uno';
        conTest.AccountId = accTest.id;
        insert conTest;
        
        Case testCasePCE = new Case();
        testCasePCE.RF2_EsPCE__c = true;
        testCasePCE.RF2_EsGIE__c = false;
        testCasePCE.RF2_MedioRespuesta__c = 'Correspondencia';
        testCasePCE.Origin = 'Asesor';
        testCasePCE.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        testCasePCE.RF2_RelacionadoCon__c = 'Alimentos';
        testCasePCE.RF2_TipoSolicitud__c = 'Solicitud PCE';
        testCasePCE.Description = 'prueba uno';
        testCasePCE.RF2_CorreoElectronicoRespuesta__c = 'jsparra@avanxo.com';
        testCasePCE.AccountId = accTest.id;
        testCasePCE.ContactId = conTest.id;
        insert testCasePCE;
        
        list<AVX_ENC_PlantillaEncuesta__c> lstplantillasTest = new list<AVX_ENC_PlantillaEncuesta__c>();
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = 'Encuesta Sondeo PCE1';
        lstplantillasTest.add(plantillaTestPCE);
        insert lstplantillasTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        AVX_ENC_Encuesta__c testEncuesta = new AVX_ENC_Encuesta__c();
        testEncuesta.Plantilla_encuesta__c = plantillaTestPCE.id;
        testEncuesta.COM_Cliente__c = testCasePCE.AccountId;
        testEncuesta.COM_Caso__c = testCasePCE.id;
        testEncuesta.COM_Contacto__c = testCasePCE.ContactId;
        insert testEncuesta;
// prueba
        AVX_log_encuestas__c logencuesta = new AVX_log_encuestas__c();
        logencuesta.Name = testEncuesta.name+'_log';
        logencuesta.COM_Correos__c = testEncuesta.COM_Caso__r.RF2_CorreoElectronicoRespuesta__c;
        logencuesta.COM_Plantilla__c = lstplantillasTest.get(0).Name;
        logencuesta.COM_TempCon__c = false;
        logencuesta.COM_Id_Contacto__c = testEncuesta.COM_Contacto__c;
        logencuesta.COM_Cuenta__c = testEncuesta.Id; 
        insert logencuesta;
        Test.startTest();
            COM_EnviarCorreoTemplate_bch prueba_batch = new COM_EnviarCorreoTemplate_bch();
            Database.executeBatch(prueba_batch);
        Test.stopTest();
/*/ prueba
        Test.startTest();
        String sch = '0 0 * * * ?';
        system.schedule('Test COM_EnviarCorreoTemplate_sch_tst SCH', sch, new COM_EnviarCorreoTemplate_sch(setCorreos, new set<Id>(), lstplantillasTest.get(0).Name, testEncuesta.COM_Contacto__c, testEncuesta.id, null));
        Test.stopTest(); */      
    }
    static testmethod void testscheduler() {
        Test.startTest();
            COM_EnviarCorreoTemplate_sch sh1 = new COM_EnviarCorreoTemplate_sch();
            String sch = '0 0 2 * * ?';
            system.schedule('Test schedule', sch, sh1);
        Test.stopTest();
    }
    
}