@isTest
private class COM_DataGenerator_tst {
	
	@isTest static void test_method_1() {
		COM_DataGenerator_cls.crearConfiguracionWebService(false);
		COM_DataGenerator_cls.crearConfiguracionHeaderWS(false);
	}
	
	@isTest static void test_method_2() {
		COM_DataGenerator_cls.crearCuenta(false);
		COM_DataGenerator_cls.crearCuenta(true);
	}

	@isTest static void test_method_3() {
		COM_DataGenerator_cls.crearCuenta2(false);
		COM_DataGenerator_cls.crearCuenta2(true);
	}

	/*Inicio 1.0*/

	@isTest static void test_method_crearCuenta3() {
		COM_DataGenerator_cls.crearCuenta3(false);
		COM_DataGenerator_cls.crearCuenta3(true);

	}
	@isTest static void test_method_crearCuenta4() {
		COM_DataGenerator_cls.crearCuenta4(false);
		COM_DataGenerator_cls.crearCuenta4(true);

	}
	@isTest static void test_method_crearCuenta5() {
		COM_DataGenerator_cls.crearCuenta5(false);
		COM_DataGenerator_cls.crearCuenta5(true);

	}


	@isTest static void test_method_crearCuentaAnom() {
		COM_DataGenerator_cls.insertarAccAnonima(false);
		COM_DataGenerator_cls.insertarAccAnonima(true);
	}
	

	@isTest static void test_method_crearActa() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		COM_DataGenerator_cls.crearActa(false, ac.Id);
		COM_DataGenerator_cls.crearActa(true, ac.Id);
	}


	@isTest static void test_method_crearActa2() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		COM_DataGenerator_cls.crearActa2(false, ac.Id);
		COM_DataGenerator_cls.crearActa2(true, ac.Id);
	}

	@isTest static void test_method_crearPob() {
		COM_DataGenerator_cls.crearPoblacion(false);
		COM_DataGenerator_cls.crearPoblacion(true);
	}


	@isTest static void test_method_preguntaEncuesta() {
		AVX_ENC_PlantillaEncuesta__c plantilla = COM_DataGenerator_cls.generarPlantillaAlone(true);
        COM_DataGenerator_cls.preguntaEncuesta(true, plantilla.Id);
        COM_DataGenerator_cls.preguntaEncuesta(false, plantilla.Id);
	}

	@isTest static void test_method_preguntaEncuestaMatricial() {
		AVX_ENC_PlantillaEncuesta__c plantilla = COM_DataGenerator_cls.generarPlantillaAlone(true);
        COM_DataGenerator_cls.preguntaEncuestaMatricial(true, plantilla.Id);
        COM_DataGenerator_cls.preguntaEncuestaMatricial(false, plantilla.Id);
	}

	/*@isTest static void test_method_genEncuesta() {
		AVX_ENC_PlantillaEncuesta__c plantilla = COM_DataGenerator_cls.generarPlantilla2(true);
        COM_DataGenerator_cls.generarEncuesta(true, plantilla.Id);
        COM_DataGenerator_cls.generarEncuesta(false, plantilla.Id);
        COM_DataGenerator_cls.generarPlantilla2(true);
	}*/

	public static testMethod void test_method_crearVinculacion() {
        COM_DataGenerator_cls.crearProgramaVinculacion(true);
        COM_DataGenerator_cls.crearProgramaVinculacion1(true, true);
        COM_DataGenerator_cls.crearProgramaVinculacion2(false, false);
	}


	@isTest static void test_method_crearActividad() {
        COM_DataGenerator_cls.crearActividadEconomicaCIIU(true);
        COM_DataGenerator_cls.crearActividadEconomicaCIIU(false);
	}


	@isTest static void test_method_crearCalcSuperavit() {
        COM_DataGenerator_cls.crearCalculadoraSuperavit2(true);
        COM_DataGenerator_cls.crearCalculadoraSuperavit2(false);
	}

		@isTest static void test_method_crearMetaAnualAfil() {
        COM_DataGenerator_cls.crearMetaAnualAfiliacion(true);
        COM_DataGenerator_cls.crearMetaAnualAfiliacion(false);
	}


		@isTest static void test_method_crearMatResCasos() {
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(false);
	}

		@isTest static void test_method_crearOperador() {
        COM_DataGenerator_cls.crearOperador(true);
        COM_DataGenerator_cls.crearOperador(false);
	}

	@isTest static void test_method_crearQuote() {

		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, ac.Id);
        COM_DataGenerator_cls.crearQuote(true, opp.Id);
        COM_DataGenerator_cls.crearQuote(false, opp.Id);
	}


	@isTest static void test_method_crearDocumento() {

        COM_DataGenerator_cls.crearDocumento(true, 'Documento');
        COM_DataGenerator_cls.crearDocumento(false, 'Documento');
	}
    

	  @isTest static void test_method_crearMetaIndividual() {
	  	Account ac = COM_DataGenerator_cls.crearCuenta(true);
      COM_MetaAnual__c metaAnual =  COM_DataGenerator_cls.crearMetaAnualAfiliacion(true);
      COM_MetasMensual__c metaMens = COM_DataGenerator_cls.crearMetaMensualAfiliacion(true, metaAnual.Id);
      COM_DataGenerator_cls.crearMetaIndividualAfiliacion(true, metaMens.Id, ac);
	}


	@isTest static void test_method_crearLiveChatVisitor() {
        COM_DataGenerator_cls.crearLiveChatVisitor(true);
        COM_DataGenerator_cls.crearLiveChatVisitor(false);
	}


	/*@isTest static void test_method_crearEncuestaCasos() {
        Account ac = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, ac.Id);
		Case caso = COM_DataGenerator_cls.crearCaso(true, ac.id, cont.id);
        COM_DataGenerator_cls.crearEncuestaCaso(true, caso.id);

	}*/
	@isTest static void crearCaso(){
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, ac.Id);
		Case caso = COM_DataGenerator_cls.crearCaso(true, ac.id, cont.id);
	}
	@isTest static void crearCaso2(){
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		Contact cont = COM_DataGenerator_cls.crearContacto(true, ac.Id);
		Case caso =  COM_DataGenerator_cls.crearCasox(true, ac.Id, cont.Id, 'Queja', 'URL PCE', 'Alimentos', 'Aportes', 'Pagina Web', false);
		
	}

	@isTest static void crearEncuesta2(){
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		Contact cont = COM_DataGenerator_cls.crearContacto(true, ac.Id);
		Case caso = COM_DataGenerator_cls.crearCaso(true, ac.id, cont.id);
		COM_DataGenerator_cls.crearEncuestaCaso(true,caso.id);
	}

	@isTest static void test_method_crearCasoAnonimo() {
        Account ac = COM_DataGenerator_cls.crearCuenta(true);
	   COM_DataGenerator_cls.crearCasoAnonimo(true, ac.id);
       

	}

/*Fin 1.0*/

	@isTest static void test_method4() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		COM_DataGenerator_cls.creaAdjunto(false, ac.Id);
		COM_DataGenerator_cls.creaAdjunto(true, ac.Id);
	}

	@isTest static void test_method5() {
		
		COM_DataGenerator_cls.crearEmailTemplate(false);
		COM_DataGenerator_cls.crearEmailTemplate(true);
	}

	@isTest static void test_method6() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		COM_DataGenerator_cls.crearContacto(false, ac.Id);
		COM_DataGenerator_cls.crearContacto(true, ac.Id);
        COM_DataGenerator_cls.crearContacto2(true, ac.Id);
        COM_DataGenerator_cls.crearContacto3(true, ac.Id);
	}

	@isTest static void test_method7() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
        COM_ProgramaVinculacion__c pr = COM_DataGenerator_cls.crearProgramaVinculacion(true);
		COM_DataGenerator_cls.crearOportunidad(false, ac.Id);
		COM_DataGenerator_cls.crearOportunidad(true, ac.Id);
        COM_DataGenerator_cls.crearOportunidad2(true);
        COM_DataGenerator_cls.crearOportunidadConPrgVinc(true, ac.Id, pr.Id);
	}	


	@isTest static void test_method8() {
		COM_DataGenerator_cls.crearTiposAsesoresAccountTeam(true);
	}

	@isTest static void test_method9() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		Contact con = COM_DataGenerator_cls.crearContacto(true, ac.Id);
		COM_DataGenerator_cls.crearContRelation(false, ac.Id, con.Id);
		COM_DataGenerator_cls.crearContRelation(true, ac.Id, con.Id);

	}

	@isTest static void test_method10() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		COM_DataGenerator_cls.crearAccountTeamMember(false, ac.Id);
		COM_DataGenerator_cls.crearAccountTeamMember(true, ac.Id);
	}


	@isTest static void test_method11() {

		COM_DataGenerator_cls.crearAsignacion(false, Label.COM_PAF_nameAsesor, UserInfo.getUserId());
		COM_DataGenerator_cls.crearAsignacion(true, Label.COM_PAF_nameAsesor, UserInfo.getUserId());
	}


	@isTest static void test_method12() {

		COM_DataGenerator_cls.generateTableDominio('', '', '', '') ;
	}

	@isTest static void test_method13() {
		COM_DataGenerator_cls.generarPlantilla(false);
		COM_DataGenerator_cls.generarPlantilla(true);
	}

	@isTest static void test_method14() {
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
		Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, ac.Id);
		Pricebook2 pb2 =  COM_DataGenerator_cls.createPriceBook(true);
		Product2 pr2 = COM_DataGenerator_cls.crearProductoAlojamiento(true);
		COM_DataGenerator_cls.oppLineItem(false, opp.Id, pr2.Id, pb2.Id, 0, 1);
		COM_DataGenerator_cls.oppLineItem(true, opp.Id, pr2.Id, pb2.Id, 0, 1);
		
	}
	
	@isTest static void test_method15() {
		COM_DataGenerator_cls.crearCandidato(false);
		// COM_DataGenerator_cls.crearNoticiasMuro(true);
		// COM_DataGenerator_cls.crearNoticiasMuro2(true);
		COM_DataGenerator_cls.crearGrupoChatter(true);
		COM_DataGenerator_cls.crearGrupoChatter2(true);
	}

	@isTest static void crearTranscripcion(){
		LiveChatVisitor lcv1 = COM_DataGenerator_cls.crearLiveChatVisitor(true);
		Account ac = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, ac.Id);
		Case caso = COM_DataGenerator_cls.crearCaso(true, ac.id, cont.id);
		COM_DataGenerator_cls.crearTranscripcion(true,caso.id,lcv1.id);
	}
	
    @isTest static void crearCaso2Test(){
        Account ac = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(true, ac.id);
        COM_DataGenerator_cls.crearCaso2(true, ac.id, con.id);
        COM_DataGenerator_cls.crearCaso(true, null, null);
        COM_DataGenerator_cls.crearCasox(true, null, null, 'Queja', 'URL PCE', 'Alimentos', 'Aportes', 'Pagina Web', false);
    }
    

    
    @isTest static void crearMetaIndividualAfiliacionDesembolsoTest(){
        COM_MetaAnual__c metaAnual = COM_DataGenerator_cls.crearMetaAnualAfiliacion(true);
        COM_MetasMensual__c metaMensual = COM_DataGenerator_cls.crearMetaMensualAfiliacion(true, metaAnual.id);
        Account ac = COM_DataGenerator_cls.crearCuenta(true);
        COM_DataGenerator_cls.crearMetaIndividualAfiliacionDesembolso(true, metaMensual.id, ac);
        COM_DataGenerator_cls.crearMetaIndividualAfiliacionDesembolso2(true, metaMensual.id, ac);
        COM_DataGenerator_cls.crearMetaIndividualAfiliacionDesembolso3(true, metaMensual.id, ac);
        COM_DataGenerator_cls.crearMetaAnualAfiliacionCurrentYear(true);
        COM_DataGenerator_cls.crearMetaMensualAfiliacionCurrentMonth(true, metaAnual.id);
        
        
    }

}