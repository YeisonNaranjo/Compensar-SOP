/** Globant Colombia
* 	@author 			Yeison Naranjo (YN)
* 	Project:			Compensar
* 	Description:		Test Class ejecutora del batch para enviar PDF no generados
*					
* 	Changes (Version)
* 	-------------------------------------
*	No.		Date			Author					Description
*	-----	----------		--------------------	---------------
* 	1.0		03/11/2021		Yeison Naranjo (YN)		Test Class para enviar PDFs no generados **/

@isTest
public class COM_EnviarPDFCaso_tst {
    static testmethod void testbatch() {      
        Account accTest = new Account();
        accTest.Name = 'prueba1';
        insert accTest;
        
        Contact conTest = new Contact();
        conTest.FirstName = 'prueba';
        conTest.LastName = 'uno';
        conTest.AccountId = accTest.id;
        insert conTest;
        
        Account accTest2 = new Account();
        accTest2.Name = 'prueba1';
        accTest2.COM_Numero_de_identificacion__c = '002';
        insert accTest2;
        
        Contact conTest2 = new Contact();
        conTest2.FirstName = 'prueba';
        conTest2.LastName = 'uno';
        conTest2.COM_TipoIdentificacion__c = Label.RF2_TipoIdentificacionClienteAnonimo_lbl;
        conTest2.COM_Numeroidentificacion__c = Label.RF2_NumeroIdentificacionClienteAnonimo_lbl;
        conTest2.AccountId = accTest.id;
        insert conTest2;
        
        Case testCasePCE = new Case();
        testCasePCE.RF2_EsPCE__c = true;
        testCasePCE.RF2_EsGIE__c = false;
        testCasePCE.RF2_MedioRespuesta__c = 'Correo Electronico';
        testCasePCE.Origin = 'Asesor';
        testCasePCE.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
        testCasePCE.RF2_RelacionadoCon__c = 'Alimentos';
        testCasePCE.RF2_TipoSolicitud__c = 'Solicitud PCE';
        testCasePCE.Description = 'prueba uno';
        testCasePCE.RF2_CorreoElectronicoRespuesta__c = 'yeison.naranjo@globant.com';
        testCasePCE.AccountId = accTest.id;
        testCasePCE.ContactId = conTest.id;
        testCasePCE.Crear_PDF__c = true;
        testCasePCE.RF2_Anonimo__c = false;
        
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeInsert');
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeUpdate');
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterInsert');
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        
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
        
        Test.startTest();
        String sch = '0 0 * * * ?';
        COM_EnviarPDFCaso_sch sch1 = new COM_EnviarPDFCaso_sch();
        String strSch = '0 0 23 * * ?'; 
        system.schedule('Programar', strSch, sch1); 
        Test.stopTest();
    }
}