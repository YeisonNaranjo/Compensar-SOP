/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase de pruebas para el controlador RF2_CrearEncuestaSinResponder_ctr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/05      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
@istest
public class RF2_CrearEncuestaSinResponder_tst {
	
	@istest
    public static void pruebaEncuestaSinResponderOpp() {
    	RF2_CrearEncuestaSinResponder_ctr objController;
    	ApexPages.StandardController objStandardController;
    	
    	Account objAcc;
		Contact objContact;
		Opportunity objOpp;
		
		objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objOpp = COM_DataGenerator_cls.crearOportunidad(true, objAcc.Id);
		
		AVX_ENC_PlantillaEncuesta__c plt =  COM_DataGenerator_cls.generarPlantillaAlone(true);
		AVX_ENC_PreguntaEncuesta__c prg1 = COM_DataGenerator_cls.preguntaEncuesta(true, plt.Id);
		AVX_ENC_PreguntaEncuesta__c prg2 = COM_DataGenerator_cls.preguntaEncuesta(true, plt.Id);
		plt.Activo__c = true;
		update plt;
		
		Test.startTest();
			objController = new RF2_CrearEncuestaSinResponder_ctr(null);
			objStandardController = new ApexPages.StandardController(objOpp);
			objController = new RF2_CrearEncuestaSinResponder_ctr(objStandardController);
			objController.strContacto = objContact.Id;
			objController.strPlantilla = plt.Id;
			objController.guardar();
			
			objController.strContacto = null;
			objController.strPlantilla = plt.Id;
			objController.guardar();
			
			objController.strContacto = objContact.Id;
			objController.strPlantilla = null;
			objController.guardar();
		Test.stopTest();
    }
    
}