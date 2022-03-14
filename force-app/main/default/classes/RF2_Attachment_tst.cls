/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase de pruebas para la clase RF2_Attachment_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/19      Juan David Uribe Ruiz       Creación Clase.
    1.1     2018/06/18      Jordan Steven Parra         Modificación de calse de prueba
************************************************************************************************/
@isTest
public with sharing class RF2_Attachment_tst {
    
    private static void createData(Id idCuenta){
        List<RF2_ConfAudCasos__mdt> ojbLst = [SELECT DeveloperName,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c FROM RF2_ConfAudCasos__mdt];
            
        RF2_ContAudCasos__c conf = new RF2_ContAudCasos__c();
        conf.Name = '1';
        conf.RF2_ConEnvioCasoCalidadGIE__c = 0;
        conf.RF2_ConEnvioCasoCalidadPCE__c = 0;
        conf.RF2_ConEnvioSondeoPCE__c = 0;
        insert conf;

        Entitlement ent = new Entitlement();
        ent.AccountId = idCuenta;
        ent.Name = Label.RF2_NombreANSGenerico_lbl;
        ent.RF2_Canal__c = 'Call Center';
        ent.Rf2_GCN__c = 'Otros';
        ent.RF2_ObligatorioCalidad__c = false;
        insert ent;
    
     }
    
    @istest
    public static void eliminarCaso() {
        
        DescribeFieldResult describe = Case.RF2_ProcesoDestinoMatrizResponsable__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Account accAnonima = COM_DataGenerator_cls.insertarAccAnonima(true);
        Contact cona = new Contact();
        cona.FirstName = 'Pepe';
        cona.LastName = 'Perez';
        cona.AccountId = accAnonima.Id;
        cona.Email = 'pruebas@micorreo.com';
        cona.COM_TipoIdentificacion__c = '1';
        cona.COM_Numeroidentificacion__c = '9999';
        insert cona;
        //Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cona.Id, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);
        User objUserPAF  = [Select Id FROM User WHERE UserRole.Name like '%Asesor - PVE%' AND Id !=: UserInfo.getUserId() AND isActive = true Limit 1];
        User objUser     = [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() AND isActive = true Limit 1];
        String strError;
        
        Attachment objAttachment;
        Attachment objAttachment2;
        Test.startTest();
            objAttachment = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
            System.runAs(objUser){
                try{
                    delete objAttachment;
                } catch(Exception e){
                    strError = e.getMessage();
                    system.debug('EEXXCCEEPPTTIIOONN 1: ' + e.getMessage());
                }
            }
            system.debug('EEXXCCEEPPTTIIOONN 1: ' + strError);
            system.debug('............... caso.Status : ' + caso.Status );
            
            caso.RF2_FechaRecepcion__c = system.today();
            caso.RF2_MedioRespuesta__c = 'Correo Electronico';
            caso.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
            /*caso.RF2_Subdireccion__c = 'Bienestar';
            caso.RF2_Proceso__c = 'Desarrollo y promocion de vivienda';
            caso.RF2_SubprocesoLinea__c = 'Posventa';*/
            caso.RF2_Ciclos__c = 'Subsidio';
            /*caso.RF2_ProgrmaArea__c = 'N/A';
            caso.RF2_CausalSalida__c = 'Pago administracion';
            caso.RF2_Complejidad__c = 'Baja';
            caso.RF2_FasesCliente__c = 'Prestacion';
            caso.RF2_Ejes__c = 'Resolutividad';*/
            caso.RF2_ConceptosOrganizaciones__c = 'Financiero';
            caso.RF2_ImpactoOrganizacional__c = 'Legal'; 
            caso.RF2_ImpactoCliente__c  = 'Integridad'; 
            caso.RF2_AfectacionEconomica__c  = 'Si'; 
            caso.RF2_Procedencia__c = 'Si'; 
            caso.Status = 'Gestión';
            update caso;
            
            caso.Status = 'Solucionado';
            try{
                update caso;
            } catch(Exception e){
                system.debug('EEXXCCEEPPTTIIOONN update caso: ' + e.getMessage());
            }
            
            System.runAs(objUser){
                try{
                    delete objAttachment;
                } catch(Exception e){
                    strError = e.getMessage();
                    system.debug('EEXXCCEEPPTTIIOONN 2: ' + e.getMessage());
                }
            }
            system.debug('EEXXCCEEPPTTIIOONN 2: ' + strError);
            
            try{
                delete objAttachment;
            } catch(Exception e){
                system.debug('EEXXCCEEPPTTIIOONN 3: ' + e.getMessage());
            }
            
            objAttachment2 = COM_DataGenerator_cls.creaAdjunto(true, acc.Id);
            System.runAs(objUser){
                try{
                    system.debug('--------------- va a eliminar attachment 2');
                    delete objAttachment2;
                } catch(Exception e){
                    system.debug('EEXXCCEEPPTTIIOONN 4: ' + e.getMessage());
                }
            }
        Test.stopTest();   
    }
// Inicio 1.1
        @istest
        public static void eliminarAdjuntoTarea() {
        
        DescribeFieldResult describe = Case.RF2_ProcesoDestinoMatrizResponsable__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Account accAnonima = COM_DataGenerator_cls.insertarAccAnonima(true);
        Contact cona = new Contact();
        cona.FirstName = 'Pepe';
        cona.LastName = 'Perez';
        cona.AccountId = accAnonima.Id;
        cona.Email = 'pruebas@micorreo.com';
        cona.COM_TipoIdentificacion__c = '1';
        cona.COM_Numeroidentificacion__c = '9999';
        insert cona;
        //Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cona.Id, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);
        User objUserPAF  = [Select Id FROM User WHERE UserRole.Name like '%Asesor - PVE%' AND Id !=: UserInfo.getUserId()  AND isActive = true  Limit 1];
        User objUser     = [Select Id FROM User WHERE (NOT UserRole.Name like '%PAF%') AND Id !=: UserInfo.getUserId() AND isActive = true  Limit 1];
        String strError;
        
        Attachment objAttachment;
        Attachment objAttachment2;
        Task tarea1;
        Test.startTest();
            tarea1 = new Task();
            tarea1.WhatId = caso.Id;
            insert tarea1;
            objAttachment = COM_DataGenerator_cls.creaAdjunto(true, tarea1.Id);
            System.runAs(objUser){
                try{
                    delete objAttachment;
                } catch(Exception e){
                    strError = e.getMessage();
                    system.debug('EEXXCCEEPPTTIIOONN 1: ' + e.getMessage());
                }
            }
            system.debug('EEXXCCEEPPTTIIOONN 1: ' + strError);
            system.debug('............... caso.Status : ' + caso.Status );
            
            caso.RF2_FechaRecepcion__c = system.today();
            caso.RF2_MedioRespuesta__c = 'Correo Electronico';
            caso.RF2_ComentarioCierre__c = 'Todo bien Patroncito!!';
            /*caso.RF2_Subdireccion__c = 'Bienestar';
            caso.RF2_Proceso__c = 'Desarrollo y promocion de vivienda';
            caso.RF2_SubprocesoLinea__c = 'Posventa';*/
            caso.RF2_Ciclos__c = 'Subsidio';
            /*caso.RF2_ProgrmaArea__c = 'N/A';
            caso.RF2_CausalSalida__c = 'Pago administracion';
            caso.RF2_Complejidad__c = 'Baja';
            caso.RF2_FasesCliente__c = 'Prestacion';
            caso.RF2_Ejes__c = 'Resolutividad';*/
            caso.RF2_ConceptosOrganizaciones__c = 'Financiero';
            caso.RF2_ImpactoOrganizacional__c = 'Legal'; 
            caso.RF2_ImpactoCliente__c  = 'Integridad'; 
            caso.RF2_AfectacionEconomica__c  = 'Si'; 
            caso.RF2_Procedencia__c = 'Si'; 
            caso.Status = 'Gestión';
            update caso;
            
            caso.Status = 'Solucionado';
            try{
                update caso;
            } catch(Exception e){
                system.debug('EEXXCCEEPPTTIIOONN update caso: ' + e.getMessage());
            }
            
            System.runAs(objUser){
                try{
                    delete objAttachment;
                } catch(Exception e){
                    strError = e.getMessage();
                    system.debug('EEXXCCEEPPTTIIOONN 2: ' + e.getMessage());
                }
            }
            system.debug('EEXXCCEEPPTTIIOONN 2: ' + strError);
            
            try{
                delete objAttachment;
            } catch(Exception e){
                system.debug('EEXXCCEEPPTTIIOONN 3: ' + e.getMessage());
            }
            
            objAttachment2 = COM_DataGenerator_cls.creaAdjunto(true, acc.Id);
            System.runAs(objUser){
                try{
                    system.debug('--------------- va a eliminar attachment 2');
                    delete objAttachment2;
                } catch(Exception e){
                    system.debug('EEXXCCEEPPTTIIOONN 4: ' + e.getMessage());
                }
            }
        Test.stopTest();   
    }
// Fin 1.1
}