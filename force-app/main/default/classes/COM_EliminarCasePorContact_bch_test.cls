/**
* Avanxo Colombia
* @author 			Gonzalo Rivas Valenzuela (GR)
* Project:			Compensar
* Description:		Clase encargada de ejecutar test de un batch para desasociar casos a contactos temporales
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		13/01/2021		Gonzalo Rivas (GR)		Implementacion inicial del test.
**/
@isTest
public class COM_EliminarCasePorContact_bch_test {
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
        logencuesta.COM_TempCon__c = true;
        logencuesta.COM_Id_Contacto__c = testEncuesta.COM_Contacto__c;
        logencuesta.COM_Cuenta__c = testEncuesta.Id; 
        insert logencuesta;
        
       /* AVX_log_encuestas__c logencuesta1 = new AVX_log_encuestas__c();
        logencuesta1.Name = testEncuesta.name+'_log2';
        logencuesta1.COM_Correos__c = testEncuesta.COM_Caso__r.RF2_CorreoElectronicoRespuesta__c;
        logencuesta1.COM_Plantilla__c = lstplantillasTest.get(0).Name;
        logencuesta1.COM_TempCon__c = true;
        logencuesta1.COM_Id_Contacto__c = testEncuesta.COM_Contacto__c;
        logencuesta1.COM_Cuenta__c = testEncuesta.Id; 
        insert logencuesta1;*/
        
        Test.startTest();
        	COM_EliminarCasePorContact_bch pruebaB = new COM_EliminarCasePorContact_bch();
        	Database.executeBatch(pruebaB);
            //COM_EnviarCorreoTemplate_bch prueba_batch = new COM_EnviarCorreoTemplate_bch();
            //Database.executeBatch(prueba_batch);
             String sch = '0 0 * * * ?';
        COM_EliminarCasePorContact_sch sch1 = new COM_EliminarCasePorContact_sch();
        String strSch = '0 0 23 * * ?'; 
			system.schedule('Programar', strSch, sch1); 
        Test.stopTest();
/*/ prueba*/


    }
 
}