/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase de pruebas para el controlador RF2_CrearCasoWeb_ctr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/06      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
@istest
public with sharing class RF2_CrearCasoWeb_tst {
    
    private final Static String WEB_PCE = 'WEB_PCE';
    private final Static String WEB_GIE = 'WEB_GIE';
    
    @istest
    public static void pruebaCrearCasoWeb() {
        
        RF2_CrearCasoWeb_ctr objCrearCasoWeb;
        
        Account objCuenta = RF2_CrearCasoWeb_tst.crearCuenta2(true);//12345678909
        Account objCuenta2 = RF2_CrearCasoWeb_tst.crearCuenta3(true);//8800990077
        Contact objContacto = RF2_CrearCasoWeb_tst.crearContacto(true, objCuenta.Id);//9988776655
        AccountContactRelation objAccountContactRelation = RF2_CrearCasoWeb_tst.crearContRelation(true, objCuenta.Id, objContacto.Id);
        COM_Poblacion__c objPoblacion = RF2_CrearCasoWeb_tst.crearPoblacion(true);
        list<RF2_MatrizResponsablesCaso__c> lstMatrizResponsable = RF2_CrearCasoWeb_tst.crearMatrizREsponsablesCaso(true);
        
        Test.startTest();
            PageReference pageRef = Page.RF2_CrearCasoWeb_pag;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('negocio', WEB_PCE);
            objCrearCasoWeb = new RF2_CrearCasoWeb_ctr();
            
            ApexPages.currentPage().getParameters().put('negocio', WEB_GIE);
            objCrearCasoWeb = new RF2_CrearCasoWeb_ctr();
            RF2_CrearCasoWeb_ctr.obtenerDocumentosCaso('Queja', 'CRM PCE', 'Alimentos');
            
            RF2_CrearCasoWeb_ctr.ArchivosWrapper objArchivosWrapper = new RF2_CrearCasoWeb_ctr.ArchivosWrapper();
            objCrearCasoWeb.document.Body = Blob.valueOf('Some Text');
            objCrearCasoWeb.strNombreArchivo = 'elArchivo.txt';
            objCrearCasoWeb.cargarArchivo();
            
            objCrearCasoWeb.document.Body = Blob.valueOf('Some Text');
            objCrearCasoWeb.strNombreArchivo = 'elArchivo2.txt';
            objCrearCasoWeb.cargarArchivo();
            
            objCrearCasoWeb.intRow = 1;
            objCrearCasoWeb.eliminarDocumento();
            if(objCrearCasoWeb.lstDocumentos != null && !objCrearCasoWeb.lstDocumentos.isEmpty()){
                   system.debug('................. strIdDocumento= ' + objCrearCasoWeb.lstDocumentos.get(0).strIdDocumento);
                
                
                RF2_CrearCasoWeb_ctr.finalizar(false, 'Empresarial', 'Traslado de aportes a otras CCF', 'Descripcion', 
                                true, true, '2', '12345678909', 
                                'RAZON SOCIAL', '1', '9988776655', 'NOMBRE CONTACTO', 
                                'correo@correo.com', 'DIRECCION CONTACTO', objPoblacion.Id, '5555555', '3000000000', 
                                'Agencia Bosa', '2017-12-06', 'Correspondencia' , WEB_GIE, '["'+objCrearCasoWeb.lstDocumentos.get(0).strIdDocumento+'"]', 'Solicitud GIE');
                                
                RF2_CrearCasoWeb_ctr.finalizar(false, '	URL PCE', 'Alimentos', 'Descripcion', 
                                true, true, '2', '12345678909', 
                                'RAZON SOCIAL', '1', '888888888', 'NOMBRE CONTACTO', 
                                'correo@correo.com', 'DIRECCION CONTACTO', objPoblacion.Id, '5555555', '3000000000', 
                                'Agencia Bosa', '2017-12-06', 'Correspondencia', WEB_PCE, '["'+objCrearCasoWeb.lstDocumentos.get(0).strIdDocumento+'"]', 'Solicitud GIE');
                
                /*RF2_CrearCasoWeb_ctr.finalizar(false, 'Empresarial', 'Traslado de Aportes', 'Descripcion', 
                                true, true, '1', '8800990077', 
                                'RAZON SOCIAL', '1', '888888888', 'NOMBRE CONTACTO', 
                                'correo@correo.com', 'DIRECCION CONTACTO', objPoblacion.Id, '5555555', '3000000000', 
                                'Agencia Bosa', '2017-12-06', WEB_PCE, '["'+objCrearCasoWeb.lstDocumentos.get(0).strIdDocumento+'"]', 'Solicitud GIE');
            */}
            objCrearCasoWeb.eliminarTodosDocumento();
            
        	Case c = new Case(origin = 'web');
            COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterInsert');
        	insert c;	
            list<Case> lstCasos = [SELECT Id FROM Case];
            if(!lstCasos.isEmpty()){
                RF2_CrearCasoWeb_ctr.consultarCaso(lstCasos.get(0).Id);
            }
        Test.stopTest();
    }
    
    public static Account crearCuenta2(boolean doInsert){
    Account objCuenta;

    objCuenta = new Account();
    objCuenta.Name = 'Test';
        //objCuenta.Lastname = 'Test';
        objCuenta.AccountNumber = '654321';
        objCuenta.BillingStreet = 'Calle 138';
        objCuenta.BillingCity = 'Bogota';
        objCuenta.BillingCountry = 'Colombia';
        objCuenta.BillingState = 'Cundinamarca';
        objCuenta.COM_CorreoElectronico__c = 'wac666@hotmail.com';
        objCuenta.COM_Numero_de_identificacion__c = '12345678909';
        objCuenta.COM_TipoIdentificacion__c = '2';

        COM_Poblacion__c pob = new COM_Poblacion__c();
        pob.COM_Codigo__c = '1111';
        pob.COM_Departamento__c = 'PRUEBA';
        pob.Name = 'CiudadPrueba';

        if(doInsert){
            insert pob;
            objCuenta.COM_Ciudad__c = pob.Id;
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
        
        return objCuenta;
    }
    
    public static Account crearCuenta3(boolean doInsert){
          Account objCuenta;
    
          objCuenta = new Account();
          objCuenta.Name = 'Test2';
          objCuenta.AccountNumber = '654321';
          objCuenta.BillingStreet = 'Calle 138';
          objCuenta.BillingCity = 'Bogota';
          objCuenta.BillingCountry = 'Colombia';
          objCuenta.BillingState = 'Cundinamarca';
          objCuenta.COM_CorreoElectronico__c = 'wac6662@hotmail.com';
          objCuenta.COM_TipoIdentificacion__c = '1';
          objCuenta.COM_Numero_de_identificacion__c = '8800990077';
          objCuenta.COM_FechaLimiteRetencion__c = System.today();
    
          if(doInsert){
            COM_AccountContactRelation_cls.stopTrigger();
            insert objCuenta;
            COM_AccountContactRelation_cls.startTrigger();
        }
    
        return objCuenta;
    }
    
    public static Contact crearContacto(Boolean doInsert, Id idCuenta)
    {
        Contact objContact;
        objContact = new Contact();
        objContact.FirstName = 'Pepe';
        objContact.LastName = 'Perez';
        objContact.AccountId = idCuenta;
        objContact.Email = 'pruebas@micorreo.com';
        objContact.COM_TipoIdentificacion__c = '1';
        objContact.COM_Numeroidentificacion__c = '9988776655';

        if(doInsert)
        {
            COM_AccountContactRelation_cls.stopTrigger();
            insert objContact;
            COM_AccountContactRelation_cls.startTrigger();
            
        }
        return objContact;
    }
    
    public static AccountContactRelation crearContRelation(Boolean crear, Id idcuenta, Id idContacto){
        List<AccountContactRelation> acrs = [Select Id, Roles, COM_CargoEmpresa__c from AccountContactRelation where AccountId =:idcuenta and ContactId =:idContacto]; 
        if(!acrs.isEmpty()){
            acrs.get(0).Roles = 'Representante Legal';
            acrs.get(0).COM_CargoEmpresa__c= 'Luchador';
            if(crear){
                update acrs;
            }
            return acrs.get(0);
            }else{        
                AccountContactRelation acr = new AccountContactRelation();
                acr.COM_EsMigrado__c = false;
                acr.ContactId = idContacto;
                acr.AccountId = idcuenta;
                acr.COM_CargoEmpresa__c= 'Luchador';
                acr.Roles = 'Representante Legal';
                if(crear){
                    insert acr;
                }
                return acr;
            }
        }
    
        public static COM_Poblacion__c crearPoblacion(boolean crear){
        COM_Poblacion__c pob = new COM_Poblacion__c();
        pob.COM_Codigo__c = '1111';
        pob.COM_Departamento__c = 'PRUEBA';
        pob.Name = 'CiudadPrueba';
        
        if(crear){
            insert pob;
        }
        return pob;
    }
    
    public static list<RF2_MatrizResponsablesCaso__c> crearMatrizREsponsablesCaso(boolean doInsert){
        list<RF2_MatrizResponsablesCaso__c> lstMatrizResponsable = new list<RF2_MatrizResponsablesCaso__c>();
        RF2_MatrizResponsablesCaso__c objMatrizResponsables;
        String strResponsableCaso;
        
        List<QueueSobject> lstQueueSobject = [SELECT QueueId FROM QueueSobject where Queue.DeveloperName NOT IN (:Label.RF2_NombreColaPendienteAsignacion, :label.RF2_NombreColaAnalistasSondeo_lbl) AND Queue.Type = 'Queue'];
        
        if(!lstQueueSobject.isEmpty()){
            strResponsableCaso = lstQueueSobject.get(0).QueueId;
        } else{
            strResponsableCaso = null;
        }
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Queja';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Otros';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'CRM PCE';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Alimentos';
        objMatrizResponsables.RF2_IdExterno__c = '11';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Queja';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Otros';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'URL PCE';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Alimentos';
        objMatrizResponsables.RF2_IdExterno__c = '91';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Solicitud GIE';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Vacios';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'Empresarial';
        //objMatrizResponsables.RF2_RelacionadoCon__c = 'Traslado de Aportes';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Traslado de aportes a otras CCF';
        objMatrizResponsables.RF2_IdExterno__c = '230';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        objMatrizResponsables = new RF2_MatrizResponsablesCaso__c();
        objMatrizResponsables.RF2_TipoSolicitud__c = 'Solicitud GIE';
        objMatrizResponsables.RF2_ResponsableCaso__c = strResponsableCaso;
        objMatrizResponsables.RF2_GCN__c = 'Vacios';
        objMatrizResponsables.RF2_ProcesoDestino__c = 'Pensionado';
        //objMatrizResponsables.RF2_RelacionadoCon__c = 'Traslado de Aportes';
        objMatrizResponsables.RF2_RelacionadoCon__c = 'Traslado de aportes a otras CCF';
        objMatrizResponsables.RF2_IdExterno__c = '232';
        objMatrizResponsables.RF2_DocumentosRequeridos__c = '1. Documentos requjeridos';
        lstMatrizResponsable.add(objMatrizResponsables);
        
        if(doInsert){
            insert lstMatrizResponsable;
        }
            
        return lstMatrizResponsable;
    }
}