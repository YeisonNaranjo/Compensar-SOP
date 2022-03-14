@isTest
private class COM_PVE_CotizacionAlojamiento_ctr_tst {
    
    @isTest static void test_method_1() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        system.debug('relacion--'+rel);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'Lagomar');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        System.debug(ppp.nombreAsesor);
        System.debug(ppp.cargoAsesor);
        System.debug(ppp.celularAsesor);
        System.debug(ppp.emailAsesor);
        System.debug(ppp.nombreTipoAsesor);
        System.debug(ppp.dependenciaAsesor);
        System.debug(ppp.lugarCotizado);
        System.debug(ppp.otroNombreLugarCotizado);
        System.debug(ppp.urlCompensar);
        System.debug(ppp.contratoLagosol);
        System.debug(ppp.contratoLagomar);
        System.debug(ppp.cargoContactoPrincipal);
        System.debug(ppp.hTelefono);
        System.debug(ppp.hCelular);
        System.debug(ppp.hDireccion);
        System.debug(ppp.hEmail);
        System.debug(ppp.hContacto);
        System.debug(ppp.hEmpresa);
        }
    }
    
    @isTest static void test_method_1A() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.COM_Fechahorafinalizacion__c = null;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'Lagomar');
        test.startTest();  
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    @isTest static void test_method_2() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'Lagosol');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    
    @isTest static void test_method_2A() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.COM_Fechahorafinalizacion__c = null;
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'Lagosol');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    
    @isTest static void test_method_3() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'PasadiaLagomar');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    @isTest static void test_method_3A() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.COM_Fechahorafinalizacion__c = null;
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'PasadiaLagomar');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    @isTest static void test_method_4A() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.COM_Fechahorafinalizacion__c = null;
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'PasadiaLagosol');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    @isTest static void test_method_4() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'PasadiaLagosol');
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        test.stopTest();
        }
    }
    
    @isTest static void test_method_5() {
        User u = [SELECT Id FROM User WHERE (Profile.name = 'Administrador del sistema' OR Profile.name = 'System Administrator') and isActive = true Limit 1];
        System.runAs(u){
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont =  COM_DataGenerator_cls.crearContacto(true, account.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeInsert' );
        Opportunity opp = COM_DataGenerator_cls.crearOportunidad(true, account.Id);
        opp.Contacto__c = cont.Id;
        COM_TriggerExecutionControl_cls.setAlreadyDone( 'COM_Opportunity_tgr', 'BeforeUpdate' );
        update opp;
        AccountContactRelation rel = COM_DataGenerator_cls.crearContRelation(true, account.Id, cont.Id);
        Quote cot = COM_DataGenerator_cls.crearQuote(true, opp.Id);
        ApexPages.currentPage().getParameters().put('idCotizacion', cot.Id);
        ApexPages.currentPage().getParameters().put('tipoDoc', 'PasadiaLagosol');
        
        test.startTest();
        COM_PVE_CotizacionAlojamiento_ctr ppp = new COM_PVE_CotizacionAlojamiento_ctr();
        ppp.setTextCarta('');
        ppp.getTextCarta();
        ppp.setHeaderLabelServiciosAdicionales('');
        ppp.getHeaderLabelServiciosAdicionales();
        ppp.setLabelSubtotalAdicionales('');
        ppp.getLabelSubtotalAdicionales();
        ppp.setImagenFirma('');
        ppp.getImagenFirma();
        
        COM_PVE_CotizacionAlojamiento_ctr.COM_PVE_ConceptosCotizacion_cls p2 = new COM_PVE_CotizacionAlojamiento_ctr.COM_PVE_ConceptosCotizacion_cls();
        p2.getNombreConcepto();
        p2.getSubTotal();
        p2.getDescuento();
        p2.setNombreConcepto('');
        p2.setSubTotal('');
        p2.setDescuento('');
        p2.getNumeroPax();
        p2.setNumeroPax('');
        p2.getValorPorPersona();
        p2.setValorPorPersona('');
        p2.getNumeroNoches();
        p2.setNumeroNoches('');
        p2.getValorTotal();
        p2.setValorTotal('');
        ppp.cargarGenericDataPDF('', '', '', '', '', '', true, '', '', '', '', '', '', '', ''); 
        
        ppp.poblarConceptoAdicionales('', '', '1', '1', '', '', '', '', '', '', '');
        ppp.setColorTablaServiciosAdicionales('');
        ppp.getColorTablaServiciosAdicionales();
        ppp.isMostrarOfertasDesayuno();
        ppp.setMostrarMenuEspeciales(true);
        ppp.isMostrarMenuEspeciales();
        ppp.setLabelSubtotalConceptos('');
        ppp.getLabelSubtotalConceptos();
        ppp.setFechaEntradaYSalida(true);
        ppp.getfechaEntradaYSalida();
        ppp.setPasadiaLagosol(true);
        ppp.getPasadiaLagosol();
        ppp.setPasadiaLagomar(true);
        ppp.getPasadiaLagomar();
        ppp.setLagosol(true);
        ppp.getLagosol();
        ppp.setLagomar(true);
        ppp.getLagomar();
        ppp.setLabelFechaEntrada('');
        ppp.getLabelFechaEntrada();
        ppp.setOfertasDesayuno(new List<String>());
        ppp.getOfertasDesayuno();
        ppp.setMenuEspeciales(new List<String>());
        ppp.getMenuEspeciales();
        ppp.setColorCajasInfoCia('');
        ppp.getColorCajasInfoCia();
        ppp.setColorTabla('');
        ppp.getColorTabla();
        ppp.setSubtotalAdicionales('1');
        ppp.getSubtotalAdicionales();
        ppp.setAplazamientos(new List<String>());
        ppp.getAplazamientos();
        ppp.setFechaActual('');
        ppp.getFechaActual();
        ppp.setServiciosOpcionales(new List<COM_PVE_CotizacionAlojamiento_ctr.COM_PVE_ServiciosOpcionales_cls>());
        ppp.getServiciosOpcionales();
        ppp.setServiciosAdicionales(new List<COM_PVE_CotizacionAlojamiento_ctr.COM_PVE_ServiciosAdicionales_cls>());
        ppp.getServiciosAdicionales();
        ppp.setConceptosCotizacions(new List<COM_PVE_CotizacionAlojamiento_ctr.COM_PVE_ConceptosCotizacion_cls>());
        ppp.getConceptosCotizacions();
        ppp.setCancelaciones(new List<String>());
        ppp.getCancelaciones();
        ppp.setCondicionesComerciales(new List<String>());
        ppp.getCondicionesComerciales();
        ppp.setTotalServicios('1');
        ppp.getTotalServicios();
        ppp.setTotalPreliquidacion('1');
        ppp.getTotalPreliquidacion();
        ppp.setSubtotalConcepts('1');
            ppp.getSubtotalConcepts();
        ppp.setFechaSalidaEvento('');
        ppp.getFechaSalidaEvento();
        ppp.setFechaEntradaEvento('');
        ppp.getFechaEntradaEvento();
            ppp.setNit('');
            ppp.getNit();
            ppp.setNumeroCotizacion('');
        ppp.getNumeroCotizacion();
            ppp.setNombreCliente('');
            ppp.getNombreCliente();            
        ppp.setNombreRepresentateLegal('');
            ppp.getNombreRepresentateLegal();
        COM_PVE_CotizacionAlojamiento_ctr.getContactoPrincipal(account.Id); 
        ppp.setMostrarOfertasDesayuno(true); 
        ppp.poblarConcepto('', '', '1', '1', '1', '1', '1', '1', '1', '1', '1');
        Product2 prod = new Product2();
        prod.Name = 'prod';
        prod.IsActive = true;
        prod.Family = 'hola';
        insert prod;
        Id idListaPrecio = Test.getStandardPricebookId();
        PricebookEntry itemListaPrecio = new PricebookEntry(Pricebook2Id = idListaPrecio, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert itemListaPrecio;
        opp.Pricebook2Id = idListaPrecio;
        opp.Contacto__c = cont.Id;
        opp.AccountId = account.Id;
        opp.amount = 10000;
        //COM_Opportunity_cls.stopTrigger();
        update opp;
        List<OpportunityLineItem>  oli = new List<OpportunityLineItem>();
        OpportunityLineItem item = new OpportunityLineItem();
        item.PricebookEntryId = itemListaPrecio.Id;
        item.Product2Id = prod.Id;
        item.OpportunityId = opp.Id;
        item.Quantity = 1;
        item.UnitPrice = 10000;
        item.Discount = 0;
        //COM_OpportunityLineItem_cls.stopTrigger();
        insert item;
        oli.add(item);
        ppp.cargarConceptosAdicionalesLagoSol(oli);  
        prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Adicionales').getRecordTypeId();
        prod.COM_SubCategoriaSalud__c = 'Incluído';
        update prod;
        OpportunityLineItem item2 = new OpportunityLineItem();
        item2.PricebookEntryId = itemListaPrecio.Id;
        item2.Product2Id = prod.Id;
        item2.OpportunityId = opp.Id;
        item2.Quantity = 1;
        item.UnitPrice = 10000;
        item2.TotalPrice = 10000;
        item2.Discount = 0;
        oli = null;
        oli = new List<OpportunityLineItem>();
        oli.add(item2);
        ppp.cargarConceptosAdicionalesLagoSol(oli);  
        ppp.cargarConceptosLagoSol(oli);
        test.stopTest();
    }
    }
}