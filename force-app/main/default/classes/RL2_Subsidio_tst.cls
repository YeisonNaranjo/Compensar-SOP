@isTest
private class RL2_Subsidio_tst {
    private static final Map<String , Schema.RecordTypeInfo> MAPRECORDTYPE  = Schema.SObjectType.RL2_MatrizParametrizacionSubsidio__c.getRecordTypeInfosByDeveloperName();
    private static final List<Map<Object,Object>> FIELDS = new List<Map<Object,Object>>{
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.RL2_MatrizParametrizacionSubsidio__c.fields.RL2_Subsidios__c.getSObjectField().getDescribe().getName()},
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.RL2_MatrizParametrizacionSubsidio__c.fields.RL2_MediosAtencion__c.getSObjectField().getDescribe().getName()},
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RL2_NormativaSubsidios__c.getSObjectField().getDescribe().getName()},
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RL2_DuracionDelContratoArrendamiento__c.getSObjectField().getDescribe().getName()}
    };
    
    @TestSetup
    static void setup(){
        Id vServicioId = MAPRECORDTYPE.get(System.Label.RL2_Servicio).getRecordTypeId();
        Id vRelacionadoConId = MAPRECORDTYPE.get(System.Label.RL2_RelacionadoCon).getRecordTypeId();
        Id vRequisitoId = MAPRECORDTYPE.get(System.Label.RL2_Requisito).getRecordTypeId();
        Id vMedioAtencionId = MAPRECORDTYPE.get(System.Label.RL2_MedioAtencion).getRecordTypeId();
        Account vAccount = COM_DataGenerator_cls.crearCuenta(true);
        Contact vContact = COM_DataGenerator_cls.crearContacto(true, vAccount.Id);
        AccountContactRelation vAccountContact = COM_DataGenerator_cls.crearContRelation(false,vAccount.Id, vContact.Id);       

        vAccountContact.Roles = 'CEO';
        upsert vAccountContact;

        Account clienteNit = COM_DataGenerator_cls.crearCuenta2(true);
        Contact contN = COM_DataGenerator_cls.crearContacto2(true, clienteNit.Id);

        //Case vCaso = COM_DataGenerator_cls.crearCaso(true, vAccount.Id, vContact.Id);

        RL2_MatrizParametrizacionSubsidio__c vParamSubsidio = new RL2_MatrizParametrizacionSubsidio__c();
        vParamSubsidio.RecordTypeId = vServicioId;
        vParamSubsidio.RL2_ApiName__c = 'Informacion';
        vParamSubsidio.RL2_Texto__c = 'Información';
        vParamSubsidio.RL2_Activo__c = true;
        vParamSubsidio.RL2_Subsidios__c = 'Subsidio Monetario';
        vParamSubsidio.RL2_MediosAtencion__c = 'Formulario Web';
        insert vParamSubsidio;

        RL2_MatrizParametrizacionSubsidio__c vParamRelacionadoCon = new RL2_MatrizParametrizacionSubsidio__c();
        vParamRelacionadoCon.RecordTypeId = vRelacionadoConId;
        vParamRelacionadoCon.RL2_ApiName__c = 'Informacion Subsidio Monetario';
        vParamRelacionadoCon.RL2_Texto__c = 'Información Subsidio Monetario';
        vParamRelacionadoCon.RL2_Activo__c = true;
        vParamRelacionadoCon.RL2_Subsidios__c = 'Subsidio Monetario';
        vParamRelacionadoCon.RL2_MediosAtencion__c = 'Formulario Web';
        vParamRelacionadoCon.RL2_NivelSuperior__c = vParamSubsidio.Id;
        insert vParamRelacionadoCon;

        RL2_MatrizParametrizacionSubsidio__c vParamMedioAtencion = new RL2_MatrizParametrizacionSubsidio__c();
        vParamMedioAtencion.RecordTypeId = vMedioAtencionId;
        vParamMedioAtencion.RL2_ApiName__c = 'Formulario Web';
        vParamMedioAtencion.RL2_Texto__c = 'Formulario Web';
        vParamMedioAtencion.RL2_Activo__c = true;
        vParamMedioAtencion.RL2_Icono__c = 'utility:display_text';
        insert vParamMedioAtencion;

        RL2_MatrizParametrizacionSubsidio__c vParamRequisito = new RL2_MatrizParametrizacionSubsidio__c();
        vParamRequisito.RecordTypeId = vRequisitoId;
        vParamRequisito.RL2_ApiName__c = 'Formulario';
        vParamRequisito.RL2_Texto__c = 'Formulario';
        vParamRequisito.RL2_Activo__c = true;
        vParamRequisito.RL2_Subsidios__c = 'Subsidio Monetario';
        vParamRequisito.RL2_NombreRequisito__c = 'Prueba de Requisitos';
        vParamRequisito.RL2_NivelSuperior__c = vParamRelacionadoCon.Id;
        insert vParamRequisito;
    }

    @isTest
    static void getTipoDocumentosTest(){
        List<RL2_Subsidio_ctr.ResultWrapper> vResult = RL2_Subsidio_ctr.getTipoDocumentos();
        System.assert(vResult != null, '');
        System.assertEquals(7, vResult.size(),'');
    }

    @isTest
    static void getMediosRespuestaTest(){
        List<RL2_Subsidio_ctr.ResultWrapper> vResult = RL2_Subsidio_ctr.getMediosRespuesta();
        System.assert(vResult != null, '');
        System.assertEquals(2, vResult.size(), '');
    }

    @isTest
    static void getSubsidiosTest(){
        RL2_Subsidio_ctr.ReturnWrapper vResult = RL2_Subsidio_ctr.getSubsidios(String.valueOf(SObjectType.RL2_MatrizParametrizacionSubsidio__c.getName()), String.valueOf(FIELDS[0].get('fieldApiName')), '');
        System.assert(vResult != null, '');
        System.assertEquals(5, vResult.lstSubsidios.size(),'');
    }

    @isTest
    static void getSubsidiosFailTest(){
        try{
            RL2_Subsidio_ctr.ReturnWrapper vResult = RL2_Subsidio_ctr.getSubsidios(String.valueOf(SObjectType.RL2_MatrizParametrizacionSubsidio__c.getName()), '', '');
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void getPickListInfoTest(){        
        List<RL2_Subsidio_ctr.ResultWrapper> vResult = RL2_Subsidio_ctr.getPickListInfo(String.valueOf(Case.Schema.SObjectType), String.valueOf(FIELDS[2].get('fieldApiName')), '');
        System.assert(vResult != null, '');
        System.assertEquals(2, vResult.size(),'');
    }

    @isTest
    static void getServicioRelacionadoTest(){
        RL2_Subsidio_ctr.ReturnWrapper vResult = RL2_Subsidio_ctr.getServicioRelacionado('Subsidio Monetario');
        System.assert(vResult != null, '');
    }

    @isTest
    static void getRequisitosTest(){
        RL2_MatrizParametrizacionSubsidio__c vParamSubsidio = [SELECT Id FROM RL2_MatrizParametrizacionSubsidio__c WHERE RL2_ApiName__c = 'Informacion Subsidio Monetario' LIMIT 1];
        List<RL2_MatrizParametrizacionSubsidio__c> vResult = RL2_Subsidio_ctr.getRequisitos('Subsidio Monetario',vParamSubsidio.Id);
        System.assert(vResult != null, '');
    }

    @isTest
    static void getRequisitosFailTest(){
        RL2_MatrizParametrizacionSubsidio__c vParamSubsidio = [SELECT Id FROM RL2_MatrizParametrizacionSubsidio__c WHERE RL2_ApiName__c = 'Informacion Subsidio Monetario' LIMIT 1];
        List<RL2_MatrizParametrizacionSubsidio__c> vResult = RL2_Subsidio_ctr.getRequisitos('Subsidio Monetario Test',vParamSubsidio.Id);
        System.assert(vResult == null, '');
    }

    @isTest
    static void getCheckBoxInfoTest(){
        RL2_MatrizParametrizacionSubsidio__c vParamSubsidio = [SELECT Id FROM RL2_MatrizParametrizacionSubsidio__c WHERE RL2_ApiName__c = 'Informacion Subsidio Monetario' LIMIT 1];
        RL2_MatrizParametrizacionSubsidio__c vResult = RL2_Subsidio_ctr.getCheckBoxInfo(vParamSubsidio.Id);
        System.assert(vResult.Id != null, '');
    }

    @isTest
    static void getCheckBoxInfoFailTest(){
        try{
            RL2_MatrizParametrizacionSubsidio__c vResult = RL2_Subsidio_ctr.getCheckBoxInfo('');
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void createSubsidioCaseTest(){
        Case vCaso = getCase('1', '12345678909');
        Test.startTest();
        Case tmpCaso = RL2_Subsidio_ctr.createSubsidioCase(vCaso);
        Test.stopTest();
        System.assert(tmpCaso.Id != null, '');
    }

    @isTest
    static void createSubsidioCaseFailTest(){
        Case vCaso = new Case();
        vCaso.RF2_RelacionadoCon__c = 'Prueba II';
        try{
            Test.startTest();
            vCaso = RL2_Subsidio_ctr.createSubsidioCase(vCaso);
            Test.stopTest();
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    @isTest
    static void createSubsidioCaseNiTest(){
        Case vCaso = getCase('2', '12345678909');
        Test.startTest();
        Case tmpCaso = RL2_Subsidio_ctr.createSubsidioCase(vCaso);
        Test.stopTest();
        System.assert(tmpCaso.Id != null, '');
    }

    @isTest
    static void saveSubsidioFilesTest() {
        Case vCaso = getCase('1', '12345678909');
        RL2_MatrizParametrizacionSubsidio__c vParamSubsidio = [SELECT Id FROM RL2_MatrizParametrizacionSubsidio__c WHERE RL2_ApiName__c = 'Informacion Subsidio Monetario' LIMIT 1];
        RL2_MatrizParametrizacionSubsidio__c vParamServicio = [SELECT Id FROM RL2_MatrizParametrizacionSubsidio__c WHERE RL2_ApiName__c = 'Informacion' LIMIT 1];
        vCaso.RL2_TipoServicio__c = vParamServicio.Id;
        vCaso.RF2_RelacionadoCon__c = vParamSubsidio.Id;
        String strFiles = '{"data":[{ "Title" : "Formulario de afiliación firmado por el independiente.pdf", "VersionData" : "Prueba", "Size" : "1389133" }]}';
        Map<String, Object> vMapFiles = (Map<String, Object>)JSON.deserializeUntyped(strFiles);
        List<Object> filesToInsert = (List<Object>) vMapFiles.get('data');
        
        Test.startTest();
        Case vResult = RL2_Subsidio_ctr.saveSubsidioFiles(vCaso,filesToInsert);
        Test.stopTest();
        System.assert(vResult != null, '');
    }
    
    @isTest
    static void saveSubsidioFilesFailTest(){
        Case vCaso = getCase('1', '12345678909');
        List<Object> filesToInsert = new List<Object>();
        try{
            Test.startTest();
            Case vResult = RL2_Subsidio_ctr.saveSubsidioFiles(vCaso,filesToInsert);
            Test.stopTest();
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }

    static Case getCase(String tipoIdentificacion, String numeroIdentificacion){
        Case vCaso = new Case();
        vCaso.RF2_Anonimo__c = false;
        vCaso.RF2_TipoIdentificacionHuerfano__c = tipoIdentificacion;
        vCaso.RF2_NumeroIdentificacionHuerfano__c = numeroIdentificacion;
        
        vCaso.RF2_NombreContactoHuerfano__c = 'Prueba I';
        vCaso.RF2_CorreoelectronicoHuerfano__c = 'test@example.com';
        vCaso.RF2_DireccionHuerfano__c = 'Calle Falsa 123';
        vCaso.RF2_TelefonoHuerfano__c = '6410000';
        vCaso.RF2_TelefonoMovilHuerfano__c = '3100000000';
        
        vCaso.RF2_TipoSolicitud__c = 'Solicitud PSB';
        vCaso.RF2_ProcesoDestinoMatrizResponsable__c = 'Subsidio Monetario';
        vCaso.RF2_RelacionadoCon__c = 'Informacion Subsidio Monetario';
        
        vCaso.RF2_MedioRespuesta__c = 'Telefonico';
        vCaso.Description = 'Esto es una prueba';

        vCaso.RF2_Autorizaenviorespuestaemail__c = true;
        vCaso.RF2_AutorizacionHabeasData__c = true;
        return vCaso;
    }
    
    @isTest
    static void getTipoDocumentosArriendoTest(){
        List<RL2_Subsidio_ctr.ResultWrapper> vResult = RL2_Subsidio_ctr.getTipoDocumentosArriendo();
        System.assert(vResult != null, '');
        System.assertEquals(3, vResult.size(),'');
    }
    
    @isTest
    static void getDependentFieldsTest(){
        RL2_Utilities.DependencyResultWrapper vResult = RL2_Subsidio_ctr.getDependentFields(new Case(), String.valueOf(FIELDS[3].get('fieldApiName')));
        System.assert(vResult != null, '');
    }
    
    @isTest
    static void getDependentFieldsFailTest(){        
        try{
            Test.startTest();
            RL2_Utilities.DependencyResultWrapper vResult = RL2_Subsidio_ctr.getDependentFields(new Case(), '');
            Test.stopTest();
        }catch (Exception e) {
            System.assert(e.getMessage() != null, '');
        }
    }
    
    @isTest
    static void getArriendoDocumentosTest(){
        List<RL2_Subsidio_ctr.ResultWrapper> vResult = RL2_Subsidio_ctr.getArriendoDocumentos();
        System.assert(vResult != null, '');
        System.assertEquals(8, vResult.size(),'');
    }
    
    @isTest
    static void getCityByNameTest(){
        RL2_Subsidio_ctr.ResultWrapper vResult = RL2_Subsidio_ctr.getCityByName('CABRERA');
        System.assert(vResult != null, '');
    }
    
}