/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_Account_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     11/08/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
@isTest
private class  COM_Opportunity_tst 
{
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
	
	public static void createData()
    {
        objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
        
        insert objOpp;
        
        objQuote = COM_DataGenerator_cls.crearQuote(false, objOpp.Id);
        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
        objQuote.Status = 'Aprobada';
        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
        insert objQuote;
        
    }

    public static testMethod void test_method_one() 
    {
    	String strResponse = '{"Cliente" : {"TipoIdentificacion" : "1","NumeroIdentificacion" : "1032449954","IdCliente" : "9999803459316283"},"atributosComunes" : ""}';
    	COM_CalloutGenericRestMock_tst clsMock = new COM_CalloutGenericRestMock_tst(strResponse,1003,'ok');
		Test.setMock(HttpCalloutMock.class, clsMock);

    	createData();

    	Test.startTest();
    		objOpp.StageName = 'Reconfirmado';
	    	update objOpp;
    	Test.stopTest();

    }

    public static testMethod void test_method_two() 
    {
        createData();
        Test.startTest();
        objOpp.StageName = 'Reconfirmado';
        update objOpp;
        Test.stopTest();
    }
    
    public static testMethod void procesarOpp() 
    {
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
         Test.startTest();
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
    	
    	objOpp = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
        objOpp.COM_ActividadeconomicaSENA__c = '400';
        objOpp.COM_ValorActualNomina__c = 10000000.0;
        objOpp.COM_TotalTrabajadores__c = 10.0;
        objOpp.COM_TotalHijosDerechoSubsidio__c = 2.0;
        objOpp.COM_Comite__c = objMetasMensual.Id;
        objOpp.RecordTypeId = lstRecordType.get(0).Id;
        objOpp.StageName = 'En tramite';
        objOpp.COM_SectorEconomico__c = '2';
        objOpp.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU.Id;
        objOpp.COM_ARL1__c = objCuenta.Id;
        objOpp.COM_EntidadPensionadora1__c = objCuenta.Id;
        objOpp.RecordTypeId = lstRecordType.get(0).Id;
        objOpp.COM_ProgramaVinculacion1__c = objProgramaVinculacion.Id;
        
        lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_VEmpresas'];
        Opportunity objOppVEmpresa;
        objOppVEmpresa = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
		objOppVEmpresa.COM_ActividadeconomicaSENA__c = '400';
		objOppVEmpresa.COM_ValorActualNomina__c = 10000000.0;
		objOppVEmpresa.COM_TotalTrabajadores__c = 10.0;
		objOppVEmpresa.COM_TotalHijosDerechoSubsidio__c = 2.0;
		objOppVEmpresa.COM_Comite__c = objMetasMensual.Id;
		objOppVEmpresa.RecordTypeId = lstRecordType.get(0).Id;
		objOppVEmpresa.StageName = 'En tramite';
		objOppVEmpresa.COM_SectorEconomico__c = '2';
		objOppVEmpresa.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU.Id;
		objOppVEmpresa.COM_ARL1__c = objCuenta.Id;
		objOppVEmpresa.COM_EntidadPensionadora1__c = objCuenta.Id;
		objOppVEmpresa.RecordTypeId = lstRecordType.get(0).Id;
		objOppVEmpresa.COM_ProgramaVinculacion1__c = objProgramaVinculacion.Id;
		objOppVEmpresa.COM_Fecharadicacioncartaretiro__c = System.today();
        objOppVEmpresa.COM_PYS__c = objProduct2.Id;
        objOppVEmpresa.COM_DSCalc__c = 1000000;
		objOppVEmpresa.COM_SustitucionPatronalAumentoTrab__c = True;
        /*Inicio S*/
        
        /*Fin S*/
        
        	insert objOpp;
        	objQuote = COM_DataGenerator_cls.crearQuote(false, objOpp.Id);
	        list<RecordType> lstRecordTypeQuote = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'COM_Cotizacion'];
	        objQuote.Status = 'Aprobada';
	        objQuote.RecordTypeId = lstRecordTypeQuote.get(0).Id;
	        insert objQuote;
        
        
        	/*objOpp.COM_ValorActualNomina__c = 9000000.0;
	        objOpp.COM_TotalTrabajadores__c = 9.0;
	        objOpp.COM_TotalHijosDerechoSubsidio__c = 1.0;
        	update objOpp;*/
        	objCuenta.COM_CantidadLegales__c =1;
            update objCuenta;
        	insert objOppVEmpresa;
        
        	COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU1 = COM_DataGenerator_cls.crearActividadEconomicaCIIU2(true, '8425');
        
        	objOppVEmpresa.COM_ValorActualNomina__c = 9000000.0;
	        objOppVEmpresa.COM_TotalTrabajadores__c = 9.0;
	        objOppVEmpresa.COM_TotalHijosDerechoSubsidio__c = 1.0;
	        objOppVEmpresa.StageName = 'Registrado';
       		objOppVEmpresa.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU1.Id;
        
        	update objOppVEmpresa;
        	
        Test.stopTest();
    }
    
    public static testMethod void procesarOpp2() 
    {
    	list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_VEmpresas'];
    	
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
	        objOppAlojamiento.StageName = 'Facturado';
	        objOppAlojamiento.CloseDate = System.today();
	        objOppAlojamiento.COM_FechaFacturacion__c = System.today();
	        objOppAlojamiento.Amount = 300000.0;
        	update objOppAlojamiento;
        Test.stopTest();
    }
    
    
     public static testMethod void procesarOppNotFinCredito() 
    {
    	list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Alojamiento'];
    	
    	objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objCalculadoraSuperavit2 = COM_DataGenerator_cls.crearCalculadoraSuperavit2(true); 
        objMetaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacionCurrentYear(true);
    	objMetasMensual =  COM_DataGenerator_cls.crearMetaMensualAfiliacionCurrentMonth(true, objMetaAnual.Id);
    	objMetasIndividuales =  COM_DataGenerator_cls.crearMetaIndividualAfiliacionDesembolso(true, objMetasMensual.Id, objAcc);
    	Product2 objProduct2 = COM_DataGenerator_cls.crearProductoAlojamiento(true);
        COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU = COM_DataGenerator_cls.crearActividadEconomicaCIIU(true);
        COM_ProgramaVinculacion__c objProgramaVinculacion = COM_DataGenerator_cls.crearProgramaVinculacion(true);
        
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
		objOppAlojamiento.StageName = 'Aceptada';
		objOppAlojamiento.COM_SectorEconomico__c = '2';
		objOppAlojamiento.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU.Id;
		objOppAlojamiento.COM_ARL1__c = objCuenta.Id;
		objOppAlojamiento.COM_EntidadPensionadora1__c = objCuenta.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
        objOppAlojamiento.COM_ProgramaVinculacion1__c = objProgramaVinculacion.Id;
         objOppAlojamiento.COM_FechaFacturacion__c = System.today();
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
	        objOppAlojamiento.StageName = 'Aceptada';
	        objOppAlojamiento.CloseDate = System.today();
	        objOppAlojamiento.COM_FechaFacturacion__c = System.today();
	        objOppAlojamiento.Amount = 300000.0;
        	update objOppAlojamiento;
        Test.stopTest();
    }
    
    
     public static testMethod void procesarOppFinCredito() 
    {
    	list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Alojamiento'];
    	
    	objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objCalculadoraSuperavit2 = COM_DataGenerator_cls.crearCalculadoraSuperavit2(true); 
        objMetaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacionCurrentYear(true);
    	objMetasMensual =  COM_DataGenerator_cls.crearMetaMensualAfiliacionCurrentMonth(true, objMetaAnual.Id);
    	objMetasIndividuales =  COM_DataGenerator_cls.crearMetaIndividualAfiliacionDesembolso2(true, objMetasMensual.Id, objAcc);
    	Product2 objProduct2 = COM_DataGenerator_cls.crearProductoAlojamiento(true);
        COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU = COM_DataGenerator_cls.crearActividadEconomicaCIIU(true);
        COM_ProgramaVinculacion__c objProgramaVinculacion = COM_DataGenerator_cls.crearProgramaVinculacion(true);
        
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
    	
        
		
		lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_FinancieroCredito'];
        Opportunity objOppAlojamiento;
        objOppAlojamiento = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
		objOppAlojamiento.COM_ActividadeconomicaSENA__c = '400';
		objOppAlojamiento.COM_ValorActualNomina__c = 10000000.0;
		objOppAlojamiento.COM_TotalTrabajadores__c = 10.0;
		objOppAlojamiento.COM_TotalHijosDerechoSubsidio__c = 2.0;
		objOppAlojamiento.COM_Comite__c = objMetasMensual.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
		objOppAlojamiento.StageName = 'DESEMBOLSADO';
		objOppAlojamiento.COM_SectorEconomico__c = '2';
		objOppAlojamiento.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU.Id;
		objOppAlojamiento.COM_ARL1__c = objCuenta.Id;
		objOppAlojamiento.COM_EntidadPensionadora1__c = objCuenta.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
        objOppAlojamiento.COM_ProgramaVinculacion1__c = objProgramaVinculacion.Id;
         objOppAlojamiento.COM_FechaFacturacion__c = System.today();
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
	        objOppAlojamiento.StageName = 'Aceptada';
	        objOppAlojamiento.CloseDate = System.today();
	        objOppAlojamiento.COM_FechaFacturacion__c = System.today();
	        objOppAlojamiento.Amount = 300000.0;
        	update objOppAlojamiento;
        Test.stopTest();
    }
    
    
    
     public static testMethod void procesarOppVentas() 
    {
    	list<RecordType> lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_Alojamiento'];
    	
    	objAcc = COM_DataGenerator_cls.crearCuenta(true);
        objContact = COM_DataGenerator_cls.crearContacto(true, objAcc.Id);
        objAccountContactRelation = COM_DataGenerator_cls.crearContRelation(true, objAcc.Id, objContact.Id);
        
        objCalculadoraSuperavit2 = COM_DataGenerator_cls.crearCalculadoraSuperavit2(true); 
        objMetaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacionCurrentYear(true);
    	objMetasMensual =  COM_DataGenerator_cls.crearMetaMensualAfiliacionCurrentMonth(true, objMetaAnual.Id);
    	objMetasIndividuales =  COM_DataGenerator_cls.crearMetaIndividualAfiliacionDesembolso3(true, objMetasMensual.Id, objAcc);
    	Product2 objProduct2 = COM_DataGenerator_cls.crearProductoAlojamiento(true);
        COM_ActividadEconomicaCIIU__c objActividadEconomicaCIIU = COM_DataGenerator_cls.crearActividadEconomicaCIIU(true);
        COM_ProgramaVinculacion__c objProgramaVinculacion = COM_DataGenerator_cls.crearProgramaVinculacion(true);
        
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
    	
        
		
		lstRecordType = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'COM_FinancieroCredito'];
        Opportunity objOppAlojamiento;
        objOppAlojamiento = COM_DataGenerator_cls.crearOportunidad(false,objAcc.Id);
		objOppAlojamiento.COM_ActividadeconomicaSENA__c = '400';
		objOppAlojamiento.COM_ValorActualNomina__c = 10000000.0;
		objOppAlojamiento.COM_TotalTrabajadores__c = 10.0;
		objOppAlojamiento.COM_TotalHijosDerechoSubsidio__c = 2.0;
		objOppAlojamiento.COM_Comite__c = objMetasMensual.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
		objOppAlojamiento.StageName = 'DESEMBOLSADO';
		objOppAlojamiento.COM_SectorEconomico__c = '2';
		objOppAlojamiento.COM_ActividadEconomicaCIIU__c = objActividadEconomicaCIIU.Id;
		objOppAlojamiento.COM_ARL1__c = objCuenta.Id;
		objOppAlojamiento.COM_EntidadPensionadora1__c = objCuenta.Id;
		objOppAlojamiento.RecordTypeId = lstRecordType.get(0).Id;
        objOppAlojamiento.COM_ProgramaVinculacion1__c = objProgramaVinculacion.Id;
         objOppAlojamiento.COM_FechaFacturacion__c = System.today();
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
	        objOppAlojamiento.StageName = 'Aceptada';
	        objOppAlojamiento.CloseDate = System.today();
	        objOppAlojamiento.COM_FechaFacturacion__c = System.today();
	        objOppAlojamiento.Amount = 300000.0;
        	update objOppAlojamiento;
        Test.stopTest();
    }
}