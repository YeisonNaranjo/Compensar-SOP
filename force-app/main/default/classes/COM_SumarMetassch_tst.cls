@isTest
private class COM_SumarMetassch_tst {
	
	@isTest static void test_method_one() {

		// Implement test code

		Test.StartTest();
			COM_SumarMetas_sch sch = new COM_SumarMetas_sch();
			String strSch = '0 0 23 * * ?'; 
			system.schedule('Programar', strSch, sch); 
		Test.stopTest(); 
	}

	@isTest static void test_Borrar_Opty_Metas() {

		// Implement test code

		Test.StartTest();
		insert new COM_Fecha_Metas_bch__c(Anio__c = '2018');
			COM_BorrarOptyMetas_sch sch = new COM_BorrarOptyMetas_sch();
			String strSch = '0 0 23 * * ?'; 
			system.schedule('ProgramarBorrar', strSch, sch); 
		Test.stopTest(); 
	}

	private static COM_CalculadoraSuperavit2__c objCalculadoraSuperavit2;
	private static Account objAcc;
	private static Opportunity objOpp;
	private static Quote objQuote;
	private static COM_TiposAsesoresAccountTeamM__mdt objTAseAccTeam;
	private static RecordType objRecordType;
	private static AccountContactRelation objAccountContactRelation;
	private static Contact objContact;
	//private static User objUsuario;
	private static COM_MetaAnual__c objMetaAnual;
	private static COM_MetasMensual__c objMetasMensual;
	private static COM_MetasIndividuales__c objMetasIndividuales;
	
	@isTest static void test_method_two() {
		// Implement test code

		list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Vinculacion_Pensionado'];
    	
    	objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objCalculadoraSuperavit2 = COM_DataGenerator_cls.crearCalculadoraSuperavit2(true); 
        objMetaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacion(true);
    	objMetasMensual =  COM_DataGenerator_cls.crearMetaMensualAfiliacion(true, objMetaAnual.Id);
    	objMetasIndividuales =  COM_DataGenerator_cls.crearMetaIndividualAfiliacion(true, objMetasMensual.Id, objAcc);
    	Product2 objProduct2 = COM_DataGenerator_cls.crearProductoAlojamiento(true);
        COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU = COM_DataGenerator_cls.crearActividadEconomicaCIIU(true);
        COM_ProgramaVinculacion__c objProgramaVinculacion = COM_DataGenerator_cls.crearProgramaVinculacion(true);

           insert new COM_Fecha_Metas_bch__c(Anio__c = '2018');

        
        Account objCuenta = new Account();
		objCuenta.Name = 'Test ARL';
		objCuenta.AccountNumber = '654328';
		objCuenta.BillingStreet = 'Calle 138';
		objCuenta.BillingCity = 'Bogota';
		objCuenta.BillingCountry = 'Colombia';
		objCuenta.BillingState = 'Cundinamarca';
		objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
		objCuenta.COM_Numero_de_identificacion__c = '8888387437';
		objCuenta.COM_FechaLimiteRetencion__c = System.today();
		objCuenta.COM_EsAFP__c = true;
		objCuenta.COM_EsARL__c = true;

		COM_AccountContactRelation_cls.stopTrigger();
		insert objCuenta;
		COM_AccountContactRelation_cls.startTrigger();
    	
        
		
		lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Alojamiento'];
        Opportunity objOppAlojamiento;
        objOppAlojamiento = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
		objOppAlojamiento.COM_ActividadeconomicaSENA__c = '400';
		objOppAlojamiento.COM_ValorActualNomina__c = 10000000.0;
		objOppAlojamiento.COM_TotalTrabajadores__c = 10.0;
		objOppAlojamiento.COM_TotalHijosDerechoSubsidio__c = 2.0;
		objOppAlojamiento.COM_Comite__c = objMetasMensual.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
		objOppAlojamiento.StageName = 'En tramite';
		objOppAlojamiento.COM_SectorEconomico__c = '2';
		objOppAlojamiento.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU.Id;
		objOppAlojamiento.COM_ARL1__c = objCuenta.Id;
		objOppAlojamiento.COM_EntidadPensionadora1__c = objCuenta.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
        objOppAlojamiento.COM_ProgramaVinculacion1__c = objProgramaVinculacion.Id;
        objOppAlojamiento.COM_PYS__c = objProduct2.Id+'';
        
        Test.startTest();

        	insert objOppAlojamiento;
        	
        	objQuote = COM_DataGenerator_cls.crearQuote(false, objOppAlojamiento.Id);
	        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
	        objQuote.Status = 'Aprobada';
	        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
	        insert objQuote;
        	
        	objOppAlojamiento.COM_ValorActualNomina__c = 9000000.0;
	        objOppAlojamiento.COM_TotalTrabajadores__c = 9.0;
	        objOppAlojamiento.COM_TotalHijosDerechoSubsidio__c = 1.0;
	        objOppAlojamiento.StageName = 'Facturada';
	        objOppAlojamiento.CloseDate = System.today();
	        objOppAlojamiento.COM_FechaFacturacion__c = System.today();
	        objOppAlojamiento.Amount = 300000.0;
        	objOppAlojamiento.COM_Valor_antes_impuesto__c= 300000.0;
        	update objOppAlojamiento;

        	COM_BorrarOptyMetas_bch obj = new COM_BorrarOptyMetas_bch();
            DataBase.executeBatch(obj); 

        Test.stopTest();
	}
	
}