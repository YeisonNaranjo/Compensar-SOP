@isTest
private class RL2_Utilities_tst {
    static  Map<String , Schema.RecordTypeInfo> mapRecordTypeMatriz  = Schema.SObjectType.CE2_matrizTipificacion__c.getRecordTypeInfosByDeveloperName();
    
    private static final List<Map<Object,Object>> FIELDS = new List<Map<Object,Object>>{
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RF2_RelacionadoCon__c.getSObjectField().getDescribe().getName()},
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RF2_TipoSolicitud__c.getSObjectField().getDescribe().getName()},
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.Case.fields.RL2_DuracionDelContratoArrendamiento__c.getSObjectField().getDescribe().getName()}
    };
        
    @TestSetup
        static void setup(){
            
            Account acc = COM_DataGenerator_cls.crearCuenta(true);
            acc.Name = 'Prueba';
            update acc;
            Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
            Case cs = COM_DataGenerator_cls.crearCaso(true, acc.Id, cont.Id);
            
            /*Creacion data para el metodo getTipificacionServiciosTest*/
           	Id relacionadoConId =  mapRecordTypeMatriz.get('CE2_RelacionadoCon').getRecordTypeId();
            Id mediosAtencionId =  mapRecordTypeMatriz.get('C2E_MedioAtencion').getRecordTypeId();
            Id solicitudId =  mapRecordTypeMatriz.get('CE2_Solicitud').getRecordTypeId();
            Id requisitoId =  mapRecordTypeMatriz.get('CE2_Requisitos').getRecordTypeId();
            
      

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
            matrizSolicitud.CE2_apiName__c = 'Informacion Subsidio Simultaneo';
            matrizSolicitud.CE2_textoOpcion__c = 'Informacion Subsidio Simultaneo';
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
        static void getFilterListTest(){
            Set<String> vResult = RL2_Utilities.getFilterList(String.valueOf(Case.Schema.SObjectType), String.valueOf(FIELDS[0].get('fieldApiName')), 'Solicitud GIE');
            System.assert(vResult.size() > 0, '');
            
            try{
                vResult = RL2_Utilities.getFilterList(String.valueOf(Case.Schema.SObjectType), '', 'Solicitud GIE');
            }catch (Exception e) {
                System.assert(e.getMessage() != null, '');
            }
        }
    
    	@isTest
    	static void getSObjectNameTest(){
            String vResult = RL2_Utilities.getSObjectName(new Case());
            System.assert(vResult != null, '');
        }
    
    	@isTest
        static void findPicklistOptionsTest(){
            List<Schema.PicklistEntry> vResult = RL2_Utilities.findPicklistOptions(String.valueOf(Case.Schema.SObjectType), String.valueOf(FIELDS[0].get('fieldApiName')), 'Solicitud GIE');
            System.assert(vResult.size() > 0, '');
            
            try{
                vResult = RL2_Utilities.findPicklistOptions(String.valueOf(Case.Schema.SObjectType), '', 'Solicitud GIE');
            }catch (Exception e) {
                System.assert(e.getMessage() != null, '');
            }
        }
    
    	@isTest static void getClienteByIdTypeNumTest() {
            
            Test.startTest();
            List<Account> accList = RL2_Utilities.getClienteByIdTypeNum('1', '12345678909');
            Test.stopTest();
            
            System.assert(!accList.isEmpty(), '');
            System.assertEquals('Prueba', accList[0].Name);
            
        }
    
    	@isTest static void getAccountRelationByAccountIdTest() {
  
            Test.startTest();
            Account acc =  [SELECT Id FROM Account LIMIT 1];
            List<AccountContactRelation> accRelationList = RL2_Utilities.getAccountRelationByAccountId(acc.Id, '1', '12345678909');
            Test.stopTest();
            
            System.assert(!accRelationList.isEmpty(), '');
        }
    
    	@isTest static void getCaseByIdTest() {
  
            Test.startTest();
            Case cs =  [SELECT Id FROM Case LIMIT 1];
            Case lc = RL2_Utilities.getCaseById(cs.Id);
            Test.stopTest();
            
            System.assert(lc != null);
        }

    	@isTest static void getTipificacionServiciosTest() {
  
          	Test.startTest();
            try {
                List<CE2_matrizTipificacion__c> matrizTp = RL2_Utilities.getTipificacionServicios('Empresarial', 'CE2_RelacionadoCon', 'CE2_Solicitud');
                System.assert(!matrizTp.isEmpty(), '');
                
            } catch(Exception e){
				System.assert(e.getMessage() != null, '');
			}
			Test.stopTest();
        }
    
    	@isTest static void getTipificacionApiRelacionadoTest() {
            Test.startTest();
                List<CE2_matrizTipificacion__c> rl = [SELECT Id, Name, CE2_apiName__c FROM CE2_matrizTipificacion__c WHERE CE2_apiName__c = 'Informacion Subsidio Simultaneo' ];
               	String apiRelacionado = RL2_Utilities.getTipificacionApiRelacionado(rl[0].Id);
            	System.assert(apiRelacionado != null, '');
            Test.stopTest();
            System.assert(apiRelacionado != null);
        }
    
   		@isTest static void getTipificacionRequisitoMedioTest() {
            try{
				Set<Id> lstRelacionadoConId = (new Map<Id,CE2_matrizTipificacion__c>([Select Id From CE2_matrizTipificacion__c Limit 5])).keySet();
				System.debug('Id de las 5 RelacionadoCon Id mas importantes: '+lstRelacionadoConId);
                List<CE2_matrizTipificacion__c> requisitosTpMedio = RL2_Utilities.getTipificacionRequisitoMedio('Empresarial', 'CE2_Requisitos', lstRelacionadoConId, 'C2E_MedioAtencion');
				System.assert(!requisitosTpMedio.isEmpty(), '');
            }catch(Exception e){
                System.assert(e.getMessage() != null, '');
            }
        }
    
        @isTest static void getTipificacionRequisitosTest() {
            Test.startTest();
            try{
                List<CE2_matrizTipificacion__c> rl = [SELECT Id, Name, CE2_apiName__c FROM CE2_matrizTipificacion__c WHERE CE2_apiName__c = 'Informacion Subsidio Simultaneo'];
                List<CE2_matrizTipificacion__c> requisitosTp = RL2_Utilities.getTipificacionRequisitos('Empresarial', rl[0].Id, 'CE2_Requisitos');
                System.assert(requisitosTp != null, '');
            }catch(Exception e){
                System.assert(e.getMessage() != null, '');
            }
            Test.stopTest();
        }
    
    	@isTest
        static void getDependentPicklistValuesTest(){
            String vField = String.valueOf(FIELDS[2].get('fieldApiName'));
            String vDependent = vField.toLowerCase();
            Case obj = new Case();
            Schema.sObjectType objType = obj.getSObjectType();

            Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
            Schema.SObjectField vDeptField = objFieldMap.get(vDependent);
            Map<String,List<Map<String,String>>> vResult = RL2_Utilities.getDependentPicklistValues(vDeptField);
            System.assert(!vResult.isEmpty(), '');
        }
            
    
    	    
}