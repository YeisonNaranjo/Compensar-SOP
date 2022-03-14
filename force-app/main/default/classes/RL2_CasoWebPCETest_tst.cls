@isTest
private class RL2_CasoWebPCETest_tst {

    private static final List<Map<Object,Object>> FIELDS = new List<Map<Object,Object>>{
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RF2_RelacionadoCon__c.getSObjectField().getDescribe().getName()},
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RF2_TipoSolicitud__c.getSObjectField().getDescribe().getName()}
    };

    @TestSetup
    static void setup(){

        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);

        Account clienteNit = COM_DataGenerator_cls.crearCuenta2(true);
        Contact contN = COM_DataGenerator_cls.crearContacto2(true, clienteNit.Id);

        Account accAnonimo = COM_DataGenerator_cls.insertarAccAnonima(true);
        

        List<RL2_Poblacion__c> lstPoblacion = new List<RL2_Poblacion__c>();

        List<RL2_Poblacion__c> vNewPoblaciones = new List<RL2_Poblacion__c>{
            new RL2_Poblacion__c(Name = 'COLOMBIA',RL2_EsPais__c = true),
            new RL2_Poblacion__c(Name = 'BOGOTÁ D.C.', RL2_EsDepartamento__c = true),
            new RL2_Poblacion__c(Name = 'BOGOTÁ D.C.', RL2_EsMunicipio__c = true)
        };
        insert vNewPoblaciones;

        vNewPoblaciones[1].RL2_PoblacionPadre__c = vNewPoblaciones[0].Id;
        vNewPoblaciones[2].RL2_PoblacionPadre__c = vNewPoblaciones[1].Id;
        
        update vNewPoblaciones;
    }
    
    @isTest
    static void getTipoDocumentosTest(){
        List<RL2_CasoWebPCE_ctr.ResultWrapper> vResult = RL2_CasoWebPCE_ctr.getTipoDocumentos();
        System.assert(vResult != null, '');
    }

    @isTest
    static void getMediosRespuestaTest(){
        List<RL2_CasoWebPCE_ctr.ResultWrapper> vResult = RL2_CasoWebPCE_ctr.getMediosRespuesta();
        System.assert(vResult != null, '');
        System.assertEquals(3, vResult.size(), '');
    }

    @isTest
    static void getDefaultCountryTest(){
        RL2_CasoWebPCE_ctr.ResultWrapper vResult = RL2_CasoWebPCE_ctr.getDefaultCountry();
        System.assert(vResult != null, '');
        System.assertEquals(System.Label.RL2_DefaultCountry_lbl, vResult.text, '');
    }

    @isTest
    static void getDefaultStateTest(){
        RL2_Poblacion__c vPoblacion = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c WHERE RL2_EsPais__c = true LIMIT 1];
        RL2_CasoWebPCE_ctr.ResultWrapper vResult = RL2_CasoWebPCE_ctr.getDefaultState(vPoblacion.Id);
        System.assert(vResult != null, '');
        System.assertEquals(System.Label.RL2_DefaultState_lbl, vResult.text, '');
    }

    @isTest 
    static void getDefaultCityTest(){
        RL2_Poblacion__c vPoblacion = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c WHERE RL2_EsDepartamento__c = true LIMIT 1];
        RL2_CasoWebPCE_ctr.ResultWrapper vResult = RL2_CasoWebPCE_ctr.getDefaultCity(vPoblacion.Id);
        System.assert(vResult != null, '');
        System.assertEquals(System.Label.RL2_DefaultCity_lbl, vResult.text, '');
    }

    @isTest
    static void findPicklistOptionsTest(){
        List<RL2_CasoWebPCE_ctr.ResultWrapper> vResult = RL2_CasoWebPCE_ctr.findPicklistOptions(String.valueOf(Case.Schema.SObjectType), String.valueOf(FIELDS[0].get('fieldApiName')), 'Solicitud GIE');
        System.assert(vResult.size() > 0, '');

        try{
            vResult = RL2_CasoWebPCE_ctr.findPicklistOptions(String.valueOf(Case.Schema.SObjectType), '', 'Solicitud GIE');
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void findPicklistOptionsFailTest(){
        try{
            List<RL2_CasoWebPCE_ctr.ResultWrapper> vResult = RL2_CasoWebPCE_ctr.findPicklistOptions(String.valueOf(Case.Schema.SObjectType), '', 'Solicitud GIE');
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void getDependentMapTest(){
        List<RL2_CasoWebPCE_ctr.DependencyResultWrapper> vResult = RL2_CasoWebPCE_ctr.getDependentMap(new Case(), String.valueOf(FIELDS[0].get('fieldApiName')), String.valueOf(FIELDS[1].get('fieldApiName')));
        System.assert(vResult.size() > 0, '');
    }

    @isTest
    static void getDependentMapFailTest(){
        try{
            List<RL2_CasoWebPCE_ctr.DependencyResultWrapper> vResult = RL2_CasoWebPCE_ctr.getDependentMap(null, String.valueOf(FIELDS[0].get('fieldApiName')), String.valueOf(FIELDS[1].get('fieldApiName')));
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void base64ToBitsTest(){
        String str = RL2_DependentField_ctr.base64ToBits('');
        System.assert(str == '', '');
        
        RL2_DependentField_ctr.PicklistEntryWrapper vPcklistEntryWrapper = new RL2_DependentField_ctr.PicklistEntryWrapper();
        vPcklistEntryWrapper.active = 'true';
        vPcklistEntryWrapper.defaultValue = 'test';
        vPcklistEntryWrapper.label = 'test'; 
        vPcklistEntryWrapper.value = 'test'; 
        vPcklistEntryWrapper.validFor = 'true';
    }
    
    @isTest
    static void createCaseTest(){
        Case vCaso = getCase('1', '12345678909');
        Test.startTest();
        Case tmpCaso = RL2_CasoWebPCE_ctr.createCase(vCaso);
        Test.stopTest();
        System.assert(tmpCaso.Id != null, '');
    }

    @isTest
    static void createCaseNitTest(){
        Case vCaso = getCase('2', '12345678909');
        Test.startTest();
        Case tmpCaso = RL2_CasoWebPCE_ctr.createCase(vCaso);
        Test.stopTest();
        System.assert(tmpCaso.Id != null, '');
    }

    @isTest
    static void createCaseFailTest(){
        Case vCaso = new Case();
        vCaso.RL2_RadicaNombrePropio__c = 'Prueba';
        try{
            Test.startTest();
            vCaso = RL2_CasoWebPCE_ctr.createCase(vCaso);
            Test.stopTest();
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void createCaseAnonimoTest(){

        Account anonimo = [SELECT Id, Name FROM Account WHERE COM_TipoIdentificacion__c =:System.Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numero_de_identificacion__c =:System.Label.RF2_NumeroIdentificacionClienteAnonimo_lbl];
        Case caso = new Case();
        caso.AccountId = anonimo.Id;
        caso.Origin = System.Label.RF2_OrigenCasoPaginaWeb_lbl;
        caso.Status = System.Label.RF2_EstadoCasoAbierto;
        caso.RF2_TipoSolicitud__c = 'Queja';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'URL PCE';
        caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
        caso.RF2_Anonimo__c = true;
        
        try{
            Test.startTest();
            Case vCaso = RL2_CasoWebPCE_ctr.createCase(caso);
            Test.stopTest();
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void saveCaseFilesTest() {
        String userId = UserInfo.getUserId();
        Case vCaso = getCase('1', '12345678909');
        //List<Object> filesToInsert = new list<Object>();
        String strFiles = '{"data":[{ "Title" : "Formulario de afiliación firmado por el independiente.pdf", "VersionData" : "Prueba", "Size" : "1389133" }]}';
        Map<String, Object> vMapFiles = (Map<String, Object>)JSON.deserializeUntyped(strFiles);
        List<Object> filesToInsert = (List<Object>) vMapFiles.get('data');
        Test.startTest();
        Case vResult = RL2_CasoWebPCE_ctr.saveCaseFiles(userId,vCaso,filesToInsert);
        Test.stopTest();
        System.assert(vResult != null, '');
    }


    static Case getCase(String tipoIdentificacion, String numeroIdentificacion){
        RL2_Poblacion__c vPais = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c WHERE RL2_EsPais__c = true LIMIT 1];
        RL2_Poblacion__c vDept = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c WHERE RL2_EsDepartamento__c = true LIMIT 1];
        RL2_Poblacion__c vCiudad = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c WHERE RL2_EsMunicipio__c = true LIMIT 1];
        Case vCaso = new Case();
        vCaso.RF2_Anonimo__c = false;
        vCaso.RL2_ActuaSolicitante__c = 'Niño';
        vCaso.RF2_TipoIdentificacionHuerfano__c = tipoIdentificacion;
        vCaso.RF2_NumeroIdentificacionHuerfano__c = numeroIdentificacion;
        
        vCaso.RF2_NombreContactoHuerfano__c = 'Prueba I';
        vCaso.RF2_CorreoelectronicoHuerfano__c = 'test@example.com';
        vCaso.RF2_DireccionHuerfano__c = 'Calle Falsa 123';
        vCaso.RF2_TelefonoHuerfano__c = '6410000';
        vCaso.RF2_TelefonoMovilHuerfano__c = '3100000000';

        vCaso.RL2_Pais__c = vPais.Id;
        vCaso.RL2_Departamento__c = vDept.Id;
        vCaso.RL2_Municipio__c = vCiudad.Id;
        
        vCaso.RL2_RadicaNombreDe__c = 'Radica Propio Nombre';
        vCaso.RL2_RadicaNombrePropio__c = 'No';
        
        

        
        vCaso.RF2_CompanyaHuerfano__c = 'Razon Social';
        vCaso.RF2_TipoIdentificacionContactoHuerfano__c = tipoIdentificacion;
        vCaso.RF2_NumeroIdentificacionContactoHuerfano__c = numeroIdentificacion;
        

        vCaso.RF2_SedeSuceso__c = 'Agencia Bosa';
        vCaso.RF2_FechaSuceso__c = System.Date.today();
        vCaso.RF2_TipoSolicitud__c = 'Solicitud PCE';
        vCaso.RF2_ProcesoDestinoMatrizResponsable__c = 'URL PCE';
        vCaso.RF2_RelacionadoCon__c = 'Alimentos';
        
        vCaso.RF2_MedioRespuesta__c = 'Telefonico';
        vCaso.Description = 'Esto es una prueba';

        vCaso.RF2_Autorizaenviorespuestaemail__c = true;
        vCaso.RF2_AutorizacionHabeasData__c = true;
        return vCaso;
    }
}