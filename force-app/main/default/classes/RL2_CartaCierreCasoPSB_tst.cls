@isTest
private class RL2_CartaCierreCasoPSB_tst {
    public static Case caso;
    public static void crearCasos() {
        caso = new Case();
        caso.Origin = 'Pagina Web';
		caso.Status = 'Abierto';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'Subsidio de Arrendamiento';
        caso.RL2_TipoServicio__c = 'Solicitudes y Trámites';
        caso.RF2_RelacionadoCon__c = 'Aclaracion de fechas de pago subsidio de arrendamiento';
        caso.RF2_TipoSolicitud__c = 'Solicitud PSB';
        caso.Description = 'Descripcion nuevo caso';
        caso.RF2_TipoIdentificacionHuerfano__c = '1';
        caso.RF2_NumeroIdentificacionHuerfano__c = '123456789';
        caso.RF2_NombreContactoHuerfano__c = 'Testing case';
        caso.RF2_CorreoelectronicoHuerfano__c = 'testing@test.com';
        caso.OwnerId = UserInfo.getUserId();
        
        insert caso;
    }
        
    @isTest static void test_validar_ContenidoCarta() {
		crearCasos();
		Contact ct =  COM_DataGenerator_cls.crearContacto3(true, null);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        
		Test.startTest();
			PageReference pag = Page.RL2_CartaCierreCasoPSB_pag;
			Test.setCurrentPageReference(pag);
			System.currentPageReference().getParameters().put('idCase', caso.Id);
			RL2_CartaCierreCasoPSB_ctr controlador = new RL2_CartaCierreCasoPSB_ctr();
    		caso.RF2_ComentarioCierre__c = 'Esto es un test';
			caso.ContactId = ct.Id;
			update caso;
        
			System.currentPageReference().getParameters().put('idCase', caso.Id);
			controlador = new RL2_CartaCierreCasoPSB_ctr();
			caso.ContactId = null;
			caso.AccountId = acc.Id;
        	caso.RF2_ComentarioCierre__c = 'Esto es un test2';
			update caso;
        
			System.currentPageReference().getParameters().put('idCase', caso.Id);
			controlador = new RL2_CartaCierreCasoPSB_ctr();
		Test.stopTest();
    }
    
    @isTest static void test_validar_mes_pce() {
        System.assertEquals('enero',  RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(1));
        System.assertEquals('febrero', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(2));
        System.assertEquals('marzo', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(3));
        System.assertEquals('abril', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(4));
        System.assertEquals('mayo', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(5));
        System.assertEquals('junio', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(6));
        System.assertEquals('julio', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(7));
        System.assertEquals('agosto', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(8));
        System.assertEquals('septiembre', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(9));
        System.assertEquals('octubre', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(10));
        System.assertEquals('noviembre', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(11));
        System.assertEquals('diciembre', RL2_CartaCierreCasoPSB_ctr.obtenerMesPCE(12));
    }
}