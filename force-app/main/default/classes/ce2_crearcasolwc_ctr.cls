/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-24-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   12-21-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global without sharing class ce2_crearcasolwc_ctr {
    
    //Metodo inicial que invoca el JS para cargar las listas de ciudad, el codigo 11001 se usa para ordenar en primer lugar en
    //la lista de valor de ciudad, el registro bogota
    @AuraEnabled(cacheable=true)
    global static List<ResultWrapper> obtenerListas() 
    {
        string poblacionBog = '11001';
        List<ResultWrapper> lstCiudades = new List<ResultWrapper>();
        List<COM_Poblacion__c> poblaciones = [SELECT Id, Name FROM COM_Poblacion__c WHERE COM_Codigo__c = :poblacionBog];
        system.debug('poblacionesBog::'+poblaciones);
        
        for(COM_Poblacion__c auxPoblaciones : poblaciones)
        {
            ResultWrapper obj = new ResultWrapper();
            obj.objName = 'COM_Poblacion__c';
            obj.text = auxPoblaciones.Name;
            obj.val = auxPoblaciones.Id;
            lstCiudades.add(obj);
        }
        
        poblaciones = [SELECT Id, Name FROM COM_Poblacion__c WHERE COM_Codigo__c != :poblacionBog ORDER BY Name];
        system.debug('poblacionesNOBog::'+poblaciones);
        
        for(COM_Poblacion__c auxPoblaciones : poblaciones)
        {
            ResultWrapper obj = new ResultWrapper();
            obj.objName = 'COM_Poblacion__c';
            obj.text = auxPoblaciones.Name;
            obj.val = auxPoblaciones.Id;
            lstCiudades.add(obj);
        }
        
        system.debug('lstCiudades::'+lstCiudades);       
        return lstCiudades;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT Id, Name, Title, Phone, Email
            FROM Contact
            LIMIT 10
        ];
    }
    
    //Metodo usado para extraer los requisitos que se muestran en el componente en el campo "Documentos obligatorios soporte"
    //utiliza los valores programaMatriz "Texto" ejemplo "Empresarial", relacionadoMatriz "Texto" recibe Id de registro objeto
    //matriz relacionado con
    @AuraEnabled(cacheable=true)
    public static List<CE2_matrizTipificacion__c> extraeRequisitos(String programaMatriz, string relacionadoMatriz, string tipoSolMat) {
        system.debug('programaMatriz::'+programaMatriz+' relacionadoMatriz::'+relacionadoMatriz+' tipoSolMat::'+tipoSolMat);
        string apiRelacionado = extraeApiRelacionado(relacionadoMatriz);
        system.debug('apiRelacionado::'+apiRelacionado);
        List<CE2_matrizTipificacion__c> auxRequisitos = [SELECT id, name,CE2_activo__c, CE2_NombreRequisito__c, CE2_apiName__c, 
                                                        CE2_nivelSuperior__r.Name,CE2_nivelSuperior__r.CE2_nivelSuperior__r.Name, 
                                                        CE2_nivelSuperior__r.CE2_nivelSuperior__r.CE2_Programas__c, CE2_EnlaceDescarga__c, CE2_textoOpcion__c
                                                        FROM CE2_matrizTipificacion__c 
                                                        WHERE RecordType.DeveloperName = 'CE2_Requisitos' 
                                                        AND CE2_nivelSuperior__r.CE2_apiName__c = :apiRelacionado
                                                        AND CE2_Programas__c includes (:programaMatriz)/*AND CE2_nivelSuperior__r.CE2_nivelSuperior__r.CE2_Programas__c includes (:programaMatriz)*/
                                                        AND CE2_activo__c = true
                                                        /*AND CE2_nivelSuperior__r.CE2_nivelSuperior__r.Name = :tipoSolMat*/];
        system.debug('auxRequisitos::'+auxRequisitos);
        return auxRequisitos;
    }
    
    //Metodo usado para extraer los valores de lista de valor del campo medios de atencion, utiliza los valores q estan setteados
    //en la metadata medioRespuesta__mdt
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getMediosAtencion() {
        list<medioRespuesta__mdt> mediosRta = [SELECT Id, MasterLabel, CE2_APIListaValor__c FROM medioRespuesta__mdt];
        list<ResultWrapper> lstMedios = new list<ResultWrapper>();
        
        for(medioRespuesta__mdt auxMediosRta : mediosRta)
        {
            ResultWrapper obj = new ResultWrapper();
            obj.objName = 'medioRespuesta__mdt';
            obj.text = auxMediosRta.MasterLabel;
            obj.val = auxMediosRta.CE2_APIListaValor__c;
            lstMedios.add(obj);
        }
        
        system.debug('lstMedios::'+lstMedios);       
        return lstMedios;
    }
    
    //Metodo usado para extraer los valores de lista de valor del campo tipo de documento del componente
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getTiposDoc() {
        list<CE2_TipoDocPortalcaso__mdt> tiposDoc = [SELECT CE2_TipoDoc__c, CE2_CodigTipoDoc__c FROM CE2_TipoDocPortalcaso__mdt];
        list<ResultWrapper> lstTipos = new list<ResultWrapper>();
        
        for(CE2_TipoDocPortalcaso__mdt auxTipoDoc : tiposDoc)
        {
            ResultWrapper obj = new ResultWrapper();
            obj.objName = 'CE2_TipoDocPortalcaso__mdt';
            obj.text = auxTipoDoc.CE2_TipoDoc__c;
            obj.val = auxTipoDoc.CE2_CodigTipoDoc__c;
            lstTipos.add(obj);
        }
        
        system.debug('lstTipos::'+lstTipos);       
        return lstTipos;
    }
    
    //Metodo utilizado para registrar el caso, se lanza desde la funcionalidad de crear archivos adjuntos para darle un id padre
    @AuraEnabled(cacheable=true)
    public static Case crearCaso(Case caso) {
        system.debug('crear caso::'+caso);
        Case auxCaso = caso;
        string NIT = '2';
        List<AccountContactRelation> lstRelacion = new List<AccountContactRelation>();
        List<Account> lstClientes = new List<Account>();
        List<Contact> lstContactos = new List<Contact>();
        auxCaso.Status = System.Label.RF2_EstadoCasoAbierto;
        system.debug(' =====>>>>>prueba a ver ' + Label.RF2_EstadoCasoAbierto);
        auxCaso.Origin = System.Label.RF2_OrigenCasoPaginaWeb_lbl;
        auxCaso.RF2_Anonimo__c = false;
        auxCaso.RF2_FechaRecepcion__c = Date.today();
        ID tipoRegistroCaso = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get( 'RF2_Compensar' ).getRecordTypeId();
        auxCaso.RecordTypeId = tipoRegistroCaso;//'RF2_Compensar'
        
        //Esta seccion proviene de la clase RF2_CrearCasoWeb_ctr metodo finalizar, linea 261
        if(NIT == auxCaso.RF2_TipoIdentificacionHuerfano__c)
        {
            auxCaso.RF2_TipoIdentificacionContactoHuerfano__c = auxCaso.RF2_TipoIdentificacionHuerfano__c;
            auxCaso.RF2_NumeroIdentificacionContactoHuerfano__c = auxCaso.RF2_NumeroIdentificacionHuerfano__c;
        }
        
        lstClientes = [SELECT Id, Name FROM Account WHERE COM_TipoIdentificacion__c = :auxCaso.RF2_TipoIdentificacionHuerfano__c 
                       AND COM_Numero_de_identificacion__c = :auxCaso.RF2_NumeroIdentificacionHuerfano__c LIMIT 1];
        system.debug('lstClientes::'+lstClientes+' auxCaso.RF2_NumeroIdentificacionContactoHuerfano__c::'+auxCaso.RF2_NumeroIdentificacionContactoHuerfano__c+' auxCaso.RF2_TipoIdentificacionHuerfano__c::'+auxCaso.RF2_TipoIdentificacionHuerfano__c);
        if(!lstClientes.isEmpty()) {
            caso.AccountId = lstClientes.get(0).Id;
            if(NIT == auxCaso.RF2_TipoIdentificacionHuerfano__c) {
                lstRelacion = [SELECT Id, ContactId FROM AccountContactRelation
                               WHERE AccountId = :lstClientes.get(0).Id
                               AND Contact.COM_TipoIdentificacion__c = :auxCaso.RF2_TipoIdentificacionHuerfano__c
                               AND Contact.COM_Numeroidentificacion__c = :auxCaso.RF2_NumeroIdentificacionContactoHuerfano__c LIMIT 1];
                if(!lstRelacion.isEmpty()) {
                    caso.ContactId = lstRelacion.get(0).ContactId;
                }
            } else {
                lstContactos = [SELECT Id FROM Contact
                                WHERE COM_TipoIdentificacion__c = :auxCaso.RF2_TipoIdentificacionHuerfano__c
                                AND COM_Numeroidentificacion__c = :auxCaso.RF2_NumeroIdentificacionContactoHuerfano__c
                                AND AccountId =: lstClientes.get(0).Id LIMIT 1];
                if(!lstContactos.isEmpty()) {
                    caso.ContactId = lstContactos.get(0).Id;
                }
            }
        } else {
            system.debug('>> No se ha encontrado informacion del cliente TipoID: ' + auxCaso.RF2_TipoIdentificacionHuerfano__c + ', numID: '+auxCaso.RF2_NumeroIdentificacionContactoHuerfano__c);
        }
        //Aca cierra el codigo de la seccion que proviene de la clase RF2_CrearCasoWeb_ctr metodo finalizar, linea 261
                
        system.debug('CAso::' +auxCaso);
        insert auxCaso;
        auxCaso = [Select Id, CaseNumber from case where id = :auxCaso.Id];
        return auxCaso;
    }
    
    //Metodo que extrae al api para llevarlo al metodo extrae requisitos y tambien al metodo crear caso a partir del id del registro
    //de objeto matriz tipificacion
    public static String extraeApiRelacionado (string idMatrizRelacionado)
    {
        String apiRelacionado;
        system.debug('idMatrizRelacionado::'+idMatrizRelacionado);
        CE2_matrizTipificacion__c auxMatrizRekaciondo = [select id, name, CE2_apiName__c 
                                 from CE2_matrizTipificacion__c 
                                 where id = :idMatrizRelacionado];
        apiRelacionado = auxMatrizRekaciondo.CE2_apiName__c;
        
        return apiRelacionado;
    }
    
    //Metodo que crea el registro de caso y le adjunta los archivos, inserta multiples archivos, Id parent no esta en uso, llega null
    @AuraEnabled
    public static Case saveFiles(string idParent, Case objCaso, list<Object> filesToInsert) {
        // Decoding base64Data
        system.debug('idParent::'+idParent);
        system.debug('objCaso::'+objCaso);
        string auxRelCon = '';
        //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); 
            
        auxRelCon = objCaso.RF2_RelacionadoCon__c;
        system.debug('auxRelCon::'+auxRelCon);
        objCaso.RF2_RelacionadoCon__c = extraeApiRelacionado(auxRelCon);
        system.debug('RF2_RelacionadoCon__c::'+objCaso.RF2_RelacionadoCon__c);
        Case newCaso = crearCaso(objCaso);
        
        if(!test.isRunningTest())
        {
            list<Id> lstCntVerIds = new list<Id>();
            List<ContentVersion> lstVersionsToInsert = new List<ContentVersion>();
            
            for (Object file : filesToInsert) {
                FileInfo fileData = (FileInfo)JSON.deserialize(JSON.serialize(file), FileInfo.class);
                ContentVersion objCntVersion = new ContentVersion();
                objCntVersion.PathOnClient = '/' + fileData.Title;
                objCntVersion.FirstPublishLocationId = newCaso.Id;
                objCntVersion.Title = fileData.Title;
                objCntVersion.VersionData = fileData.VersionData;
                lstVersionsToInsert.add(objCntVersion);
            }
        
            Insert lstVersionsToInsert;
            system.debug('cvInsertado::'+lstVersionsToInsert);
        }       
        
        return newCaso;
    }

     /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro(HCH)
    Descripción: Prueba
    @params: String idAccount
    @return: 
    ----------------------------------------------------------------------------------------------*/
    @AuraEnabled(cacheable=true)
   	public static returnValuesWpr searchMatrizCase(){ 
        returnValuesWpr initValues = new returnValuesWpr();
        List<Schema.PicklistEntry> lstValues = CE2_matrizTipificacion__c.CE2_Programas__c.getDescribe().getPicklistValues();
        List<String> programsLst = new List<String>();
        for( Schema.PicklistEntry program : lstValues){
            programsLst.add(program.getValue());
        }
        System.debug('programsLst '+programsLst);
        initValues.blnResult = true;
        initValues.message = 'success';
        initValues.listProgramas = programsLst;
        System.debug('initValues '+initValues);
        return initValues;
    } 
     /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro(HCH)
    Descripción: Get los registros por el programa seleccionado
    @params: String program
    @return: 
    ----------------------------------------------------------------------------------------------*/
    @AuraEnabled(cacheable=true)
   	public static returnValuesWpr getSolicRelateCon(String program){ 
        System.debug('program '+program);
        returnValuesWpr returnValues = new returnValuesWpr();
        List<CE2_matrizTipificacion__c> solicitudList = new List<CE2_matrizTipificacion__c>();
        List<String> relatedConMedLst = new List<String>();
        Set<String> relatedConMedSet = new Set<String>();
        List<Id> relatedConIdLst = new List<Id>();
        List<String> mediosAtenLst;
        Set<String> mediosAtenSet;
        Map<String,CE2_matrizTipificacion__c> relatedConMap = new Map<String,CE2_matrizTipificacion__c>();
        Map<String,Set<CE2_matrizTipificacion__c>> relatedConSolicMap = new Map<String,Set<CE2_matrizTipificacion__c>>();
        Map<String,solicitudRelatedWrp> soliRelatedWrpMap = new Map<String,solicitudRelatedWrp>();
        relatedConWrp RelatedConWrp;
        List<relatedConWrp> relatedConWrpLst = new List<relatedConWrp>();

        try{
            List<solicitudRelatedWrp> solicitudWprLst = new List<solicitudRelatedWrp>();
            solicitudRelatedWrp solicitudWpr ;
            for(CE2_matrizTipificacion__c solicitud:[SELECT Id, Name, CE2_activo__c,CE2_MediosAtencion__c,CE2_Programas__c,CE2_apiName__c,
                                                                CE2_textoOpcion__c, (SELECT Id,Name, CE2_apiName__c,CE2_nivelSuperior__c,CE2_textoOpcion__c,CE2_MediosAtencion__c FROM Nivel_superior_matriz__r WHERE CE2_activo__c = true AND RecordType.DeveloperName = 'CE2_RelacionadoCon' AND CE2_Programas__c includes(:program)) 
                                                                FROM CE2_matrizTipificacion__c 
                                                                WHERE RecordType.DeveloperName = 'CE2_Solicitud' AND CE2_activo__c = true AND CE2_Programas__c includes(:program)])
            {
                solicitudWpr = new solicitudRelatedWrp();
                solicitudWpr.solicitud = solicitud;
                // solicitudList.add(solicitud);
                for(CE2_matrizTipificacion__c relatedCon :solicitud.Nivel_superior_matriz__r){
                    RelatedConWrp = new relatedConWrp();
                    RelatedConWrp.relacionadoCon = relatedCon;
                    relatedConWrpLst.add(RelatedConWrp);
                    relatedConIdLst.add(relatedCon.Id);
                    solicitudWpr.relacionadoConLst.add(RelatedConWrp);
                }
                solicitudWprLst.add(solicitudWpr);
            }
            List<String> mediosAtLst = new List<String>();
         

            for (CE2_matrizTipificacion__c requisitoMedio : [SELECT Id, Name, CE2_apiName__c, 
                                                          CE2_nivelSuperior__c,CE2_textoOpcion__c,CE2_Icono__c,CE2_EtiquetaDescargas__c,        
                                                          CE2_MediosAtencion__c,CE2_NombreRequisito__c,RecordType.DeveloperName 
                                                          FROM CE2_matrizTipificacion__c 
                                                          WHERE (RecordType.DeveloperName = 'CE2_Requisitos' AND CE2_Programas__c includes(:program) AND CE2_nivelSuperior__c IN:relatedConIdLst  AND CE2_activo__c = true) OR (RecordType.DeveloperName = 'C2E_MedioAtencion' AND CE2_activo__c = true)])
                {
                for (relatedConWrp relateWrp : relatedConWrpLst) {
                        if(requisitoMedio.RecordType.DeveloperName == 'CE2_Requisitos'){
                            if(relateWrp.relacionadoCon.Id == requisitoMedio.CE2_nivelSuperior__c)
                                relateWrp.requisitosLst.add(requisitoMedio);

                        }
                        else if(requisitoMedio.RecordType.DeveloperName == 'C2E_MedioAtencion') {
                            if(relateWrp.relacionadoCon.CE2_MediosAtencion__c != null){
                                if(relateWrp.relacionadoCon.CE2_MediosAtencion__c.contains(requisitoMedio.CE2_apiName__c)){
                                    relateWrp.medioAtenLst.add(requisitoMedio);
                                } 
                            }  
                        }
                }
            }
            // System.debug('solicitudWprLst '+JSON.serializePretty(solicitudWprLst));
            returnValues.solicitudRelateWprLst = solicitudWprLst;
            returnValues.blnResult = true;
            returnValues.message = 'success';
        }catch(Exception e){
            System.debug('Error: '+e.getMessage());
            System.debug('Error Linea: '+e.getLineNumber());
            returnValues.blnResult = false;
            returnValues.message = e.getMessage();

        }
        System.debug('returnValues '+returnValues);
        return returnValues;
    } 
    
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro(HCH)
    Descripción: retorna los valores wrp del preregistro
    ----------------------------------------------------------------------------------------------*/
    global class returnValuesWpr {
        @AuraEnabled 
		public Boolean blnResult;
        @AuraEnabled 
        public String message;
        @AuraEnabled
        public List<solicitudRelatedWrp> solicitudRelateWprLst;
        @AuraEnabled 
        public List<String> listProgramas;
    }

    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro(HCH)
    Descripción: wpr para tener los hijos de solicitud
    ----------------------------------------------------------------------------------------------*/
    global class solicitudRelatedWrp
    {
        @AuraEnabled
        public CE2_matrizTipificacion__c solicitud;
        @AuraEnabled
        public List<relatedConWrp> relacionadoConLst = new List<relatedConWrp>();
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro(HCH)
    Descripción: wpr para tener los hijos de relacionadoCon
    ----------------------------------------------------------------------------------------------*/

    global class relatedConWrp
    {
        @AuraEnabled
        public CE2_matrizTipificacion__c relacionadoCon;
        @AuraEnabled
        public List<CE2_matrizTipificacion__c> requisitosLst = new List<CE2_matrizTipificacion__c>();
        @AuraEnabled
        public List<CE2_matrizTipificacion__c> medioAtenLst = new List<CE2_matrizTipificacion__c>();
    }
    
    //Wrapper utilizado para enviar la data de las listas de valores
    global class ResultWrapper
    {
        @AuraEnabled
        public String objName {get;set;}
        @AuraEnabled
        public String text{get;set;}
        @AuraEnabled
        public String val{get;set;}
    }
    
    public class FileInfo {
        public String Title;
        public Blob VersionData;
    }
}