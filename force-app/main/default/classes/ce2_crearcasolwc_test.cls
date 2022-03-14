/************************************************************************************************
Desarrollado por:  Globant
Autor:             Harlinsson Chvarro (HCH)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase ce2_crearcasolwc_ctr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/12/19         Harlinsson Chvarro      Creación Clase.  
************************************************************************************************/
@isTest
public class ce2_crearcasolwc_test {
    static  Map<String , Schema.RecordTypeInfo> mapRecordTypeMatriz  = Schema.SObjectType.CE2_matrizTipificacion__c.getRecordTypeInfosByDeveloperName();
     @TestSetup
     static void setup(){ 
        Id relacionadoConId =  mapRecordTypeMatriz.get('CE2_RelacionadoCon').getRecordTypeId();
        Id mediosAtencionId =  mapRecordTypeMatriz.get('C2E_MedioAtencion').getRecordTypeId();
        Id solicitudId =  mapRecordTypeMatriz.get('CE2_Solicitud').getRecordTypeId();
        Id requisitoId =  mapRecordTypeMatriz.get('CE2_Requisitos').getRecordTypeId();
        Account cliente = COM_DataGenerator_cls.crearCuenta5(false);
        cliente.COM_TipoIdentificacion__c = '2';
        cliente.Phone = '2780675';
        insert cliente;
        Contact contacto = COM_DataGenerator_cls.crearContacto(false,cliente.Id);
        contacto.COM_Numeroidentificacion__c = '12345678909';
        contacto.COM_TipoIdentificacion__c = '2';
        insert contacto;
        AccountContactRelation contactoRel = COM_DataGenerator_cls.crearContRelation(false,cliente.Id, contacto.Id);
        contactoRel.Roles = 'CEO';
        upsert contactoRel;
        Case caso = COM_DataGenerator_cls.crearCaso(true, cliente.Id, contacto.Id);
        List<COM_Poblacion__c> lstpoblacion =new List<COM_Poblacion__c>();
        COM_Poblacion__c poblacion =new COM_Poblacion__c();
        COM_Poblacion__c poblacion1 =new COM_Poblacion__c();
        poblacion.Name = 'Pruebas';
        poblacion.COM_Codigo__c = '11001';
        poblacion1.Name = 'Pruebas1';
        poblacion1.COM_Codigo__c = '11002';
        lstpoblacion.add(poblacion);
        lstpoblacion.add(poblacion1);
        insert lstpoblacion;
        CE2_matrizTipificacion__c matrizSolicitud = new CE2_matrizTipificacion__c();
        matrizSolicitud.RecordTypeId = solicitudId;
        matrizSolicitud.CE2_apiName__c = 'Aclaración';
        matrizSolicitud.CE2_textoOpcion__c = 'Aclaración';
        matrizSolicitud.CE2_activo__c = true;
        matrizSolicitud.CE2_Programas__c = 'Empresarial';
        matrizSolicitud.CE2_MediosAtencion__c = 'Formulario web';
        insert matrizSolicitud;
        CE2_matrizTipificacion__c matrizRelacionadoCon = new CE2_matrizTipificacion__c();
        matrizRelacionadoCon.RecordTypeId = relacionadoConId;
        matrizRelacionadoCon.CE2_apiName__c = 'Reporte Novedades vinculacion';
        matrizRelacionadoCon.CE2_textoOpcion__c = 'Informe de estado de vinculación de los trabajadores';
        matrizRelacionadoCon.CE2_activo__c = true;
        matrizRelacionadoCon.CE2_Programas__c = 'Empresarial';
        matrizRelacionadoCon.CE2_MediosAtencion__c = 'Formulario web';
        matrizRelacionadoCon.CE2_nivelSuperior__c = matrizSolicitud.Id;
        insert matrizRelacionadoCon;
        CE2_matrizTipificacion__c matrizMediosAtencion = new CE2_matrizTipificacion__c();
        matrizMediosAtencion.RecordTypeId = mediosAtencionId;
        matrizMediosAtencion.CE2_apiName__c = 'Formulario web';
        matrizMediosAtencion.CE2_textoOpcion__c = 'Formulario web';
        matrizMediosAtencion.CE2_activo__c = true;
        matrizMediosAtencion.CE2_Programas__c = 'Empresarial';
        insert matrizMediosAtencion;
        CE2_matrizTipificacion__c matrizRequisito = new CE2_matrizTipificacion__c();
        matrizRequisito.RecordTypeId = requisitoId;
        matrizRequisito.CE2_apiName__c = 'Formulario';
        matrizRequisito.CE2_textoOpcion__c = 'Formulario';
        matrizRequisito.CE2_activo__c = true;
        matrizRequisito.CE2_Programas__c = 'Empresarial';
        matrizRequisito.CE2_nivelSuperior__c = matrizRelacionadoCon.Id;
        insert matrizRequisito;

        
    }
        
    @isTest
    public static void severalLittleTets() {
        List<ce2_crearcasolwc_ctr.ResultWrapper> wrapperList = new List<ce2_crearcasolwc_ctr.ResultWrapper>();
        List<ce2_crearcasolwc_ctr.ResultWrapper> documentosList = new List<ce2_crearcasolwc_ctr.ResultWrapper>();
        List<ce2_crearcasolwc_ctr.ResultWrapper> mediosList = new List<ce2_crearcasolwc_ctr.ResultWrapper>();
        ce2_crearcasolwc_ctr.returnValuesWpr returnData = new ce2_crearcasolwc_ctr.returnValuesWpr();
        Test.startTest();
        wrapperList = ce2_crearcasolwc_ctr.obtenerListas();
        List<Contact> contactosLst = ce2_crearcasolwc_ctr.getContactList();
        documentosList = ce2_crearcasolwc_ctr.getTiposDoc();
        mediosList = ce2_crearcasolwc_ctr.getMediosAtencion();
        returnData = ce2_crearcasolwc_ctr.searchMatrizCase();
        Test.stopTest();
    }
    @isTest
    public static void extrareRequisitosTest() {
        List<ce2_crearcasolwc_ctr.ResultWrapper> wrapperList = new List<ce2_crearcasolwc_ctr.ResultWrapper>();
        CE2_matrizTipificacion__c matrizRelacionado = [SELECT Id FROM CE2_matrizTipificacion__c WHERE CE2_apiName__c = 'Reporte Novedades vinculacion' LIMIT 1];
        Test.startTest();
        List<CE2_matrizTipificacion__c> matricesLst = ce2_crearcasolwc_ctr.extraeRequisitos('Empresarial',matrizRelacionado.Id,'');
        Test.stopTest();
    }
    
    @isTest
    public static void crearCasoTest() {
        Account cliente = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1];
        Contact contacto = COM_DataGenerator_cls.crearContacto(true,cliente.Id);
        Map<String , Schema.RecordTypeInfo> mapRecordTypeMatriz  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName();
        Id compensarCaseId =  mapRecordTypeMatriz.get('RF2_Compensar').getRecordTypeId();

        Case caso = new Case(Status='Abierto',
        RF2_AutorizacionHabeasData__c=true,
        Description='sdsd',
        RF2_Anonimo__c=false,
        RF2_DireccionHuerfano__c='sdsd',
        RF2_RelacionadoCon__c='Reporte Novedades vinculacion',
        RF2_TelefonoMovilHuerfano__c='3005295386',
        RF2_NumeroIdentificacionHuerfano__c='12345678909',
        RF2_CorreoelectronicoHuerfano__c='prueba@prueba.com',
        RF2_MedioRespuesta__c='Correspondencia',
        RF2_TipoSolicitud__c='Solicitud GIE',
        RecordTypeId=compensarCaseId,
        RF2_Autorizaenviorespuestaemail__c=true,
        RF2_NombreContactoHuerfano__c='dsdsds sdsd',
        RF2_ProcesoDestinoMatrizResponsable__c='Empresarial',
        RF2_TelefonoHuerfano__c='3005295386',
        RF2_TipoIdentificacionHuerfano__c='2', Origin = 'Pagina Web');
        Test.startTest();
        Case casoBack = ce2_crearcasolwc_ctr.crearCaso(caso);
        Test.stopTest();
    }
    
    @isTest
    public static void crearCasoTestnoNIT() {
        Account cliente = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1];
        cliente.COM_TipoIdentificacion__c = '1';
        update cliente;
        Contact contacto = COM_DataGenerator_cls.crearContacto(true,cliente.Id);
        Map<String , Schema.RecordTypeInfo> mapRecordTypeMatriz  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName();
        Id compensarCaseId =  mapRecordTypeMatriz.get('RF2_Compensar').getRecordTypeId();

        Case caso = new Case(Status='Abierto',
        RF2_AutorizacionHabeasData__c=true,
        Description='sdsd',
        RF2_Anonimo__c=false,
        RF2_DireccionHuerfano__c='sdsd',
        RF2_RelacionadoCon__c='Reporte Novedades vinculacion',
        RF2_TelefonoMovilHuerfano__c='3005295386',
        RF2_NumeroIdentificacionHuerfano__c='12345678909',
        RF2_CorreoelectronicoHuerfano__c='prueba@prueba.com',
        RF2_MedioRespuesta__c='Correspondencia',
        RF2_TipoSolicitud__c='Solicitud GIE',
        RecordTypeId=compensarCaseId,
        RF2_Autorizaenviorespuestaemail__c=true,
        RF2_NombreContactoHuerfano__c='dsdsds sdsd',
        RF2_ProcesoDestinoMatrizResponsable__c='Empresarial',
        RF2_TelefonoHuerfano__c='3005295386',
        RF2_TipoIdentificacionHuerfano__c='1', Origin = 'Pagina Web');
        Test.startTest();
        Case casoBack = ce2_crearcasolwc_ctr.crearCaso(caso);
        Test.stopTest();
    }
    
    @isTest
    public static void saveFilesTest() {
        
        
        Map<String , Schema.RecordTypeInfo> mapRecordTypeMatriz  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName();
        Id compensarCaseId =  mapRecordTypeMatriz.get('RF2_Compensar').getRecordTypeId();
        
        CE2_matrizTipificacion__c auxMatrix = [Select Id, name,CE2_apiName__c 
                                               from CE2_matrizTipificacion__c 
                                               where CE2_apiName__c = 'Reporte Novedades vinculacion'];
        string matrizId = auxMatrix.Id;
        Case caso = new Case(Status='Abierto',
        RF2_AutorizacionHabeasData__c=true,
        Description='sdsd',
        RF2_Anonimo__c=false,
        RF2_DireccionHuerfano__c='sdsd',
        RF2_RelacionadoCon__c = matrizId,
        RF2_TelefonoMovilHuerfano__c='3005295386',
        RF2_NumeroIdentificacionHuerfano__c='12345678909',
        RF2_CorreoelectronicoHuerfano__c='prueba@prueba.com',
        RF2_MedioRespuesta__c='Correspondencia',
        RF2_TipoSolicitud__c='Solicitud GIE',
        RecordTypeId=compensarCaseId,
        RF2_Autorizaenviorespuestaemail__c=true,
        RF2_NombreContactoHuerfano__c='dsdsds sdsd',
        RF2_ProcesoDestinoMatrizResponsable__c='Empresarial',
        RF2_TelefonoHuerfano__c='3005295386',
        RF2_TipoIdentificacionHuerfano__c='2', Origin = 'Pagina Web');
        list<Object> filesToInsert = new list<Object>();
        Test.startTest();
        Case casoBack = ce2_crearcasolwc_ctr.saveFiles('',caso,filesToInsert);
        Test.stopTest();
    }
    
    @isTest
    public static void getSolicRelateConTest() {
        ce2_crearcasolwc_ctr.returnValuesWpr returndata = new ce2_crearcasolwc_ctr.returnValuesWpr();
        Test.startTest();
        returndata = ce2_crearcasolwc_ctr.getSolicRelateCon('Empresarial');
        Test.stopTest();
    }        
  
}