/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Luis Rafael Peñaranda (LP)
Proyecto:          Compensar
Descripción:       Controlador de la pde compoenntes de botones migrados de JS encargado de:
* Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     01/09/19             Luis Rafael Peñaranda (LP)             Creación Clase.
************************************************************************************************/
public class MGLT_GenerarPDF_ctr {
    public static Map<Id, String> recordtypemap {get;set;}
    /**
* @method       getQuote
* @description  Método que consulta la cotización  para el PDF Salud 
* @author       Luis Peñaranda - 11-09-2019
*/
    @AuraEnabled
    public static Quote getQuote(String strQuoteId){
        list<Quote> lstQuote;
        Quote objQuote;
        System.debug('strQuoteId-->'+strQuoteId);
        lstQuote = [select Opportunity.RecordType.DeveloperName from Quote where Id=:strQuoteId];
        System.debug('Stif lstQuote-->'+lstQuote);
        return lstQuote.get(0);
    }
    
    /**
* @method       getQuote
* @description  Método que consulta el cliente para el PDF de Generar Paz y Salvo
* @author       Luis Peñaranda - 11-09-2019
*/
    @AuraEnabled
    public static Account getClientePazySalvo(String AccountId){
        list<Account> lstAccount;
        Account objAccount;
        System.debug('strQuoteId-->'+AccountId);
        lstAccount = [SELECT RecordType.DeveloperName, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, COM_Genero__c, COM_FechaAportePazSalvo__c, COM_FechaAfiliacion__c, COM_FechaRetiro__c, COM_CorreoElectronico__c FROM Account where Id=:AccountId];
        System.debug('lstAccount-->'+lstAccount);
        return lstAccount.get(0);
    }
    
    /**
* @method       getQuote
* @description  Método que consulta la cotización y la Oportunidad para el PDF Lagomar/Lagosol
* @author       Luis Peñaranda - 11-09-2019
*/
    @AuraEnabled
    public static Response getQuoteOppLagos(String strQuoteId){
        Response objResponse = new Response();
        
        list<Quote> lstQuote;
        Quote objQuote;
        
        list<OpportunityLineItem> lstOpportunityLineItem;
        OpportunityLineItem objOpportunityLineItem;
        
        System.debug('strQuoteId-->'+strQuoteId);
        lstQuote = [select OpportunityId, Opportunity.RecordType.DeveloperName, Opportunity.COM_Fechahorainicio__c, Opportunity.COM_Fechahorafinalizacion__c, Opportunity.Contacto__c from Quote where Id=:strQuoteId];
        System.debug('lstQuote2-->'+lstQuote);
        objResponse.objQuote = lstQuote.get(0);
        
        System.debug('Stif test');
        lstOpportunityLineItem = [select Id, COM_Familia__c FROM OpportunityLineItem WHERE OpportunityId =:lstQuote.get(0).OpportunityId  AND COM_Familia__c = 'PyS'];
        System.debug('lstOpportunityLineItem-->'+lstOpportunityLineItem);
        if(!lstOpportunityLineItem.isEmpty()){
            objResponse.objOpportunityLineItem = lstOpportunityLineItem.get(0);
        }
        
        
        return objResponse;
    }  
    
    public class Response{
        @AuraEnabled public Quote objQuote;
        @AuraEnabled public OpportunityLineItem objOpportunityLineItem;     
    }
    
    /**
* @method       getQuote
* @description  Método que consulta de cliete de oportundiad y AccountContactRelation
* @author       Luis Peñaranda - 11-09-2019
*/
    @AuraEnabled
    public static ResponseCartaBienvenida getCartaBienvenida(String opportunityId){
        ResponseCartaBienvenida objResponse = new ResponseCartaBienvenida();
        
        list<Opportunity> lstOpportunity;
        Opportunity objOpportunity;
        
        list<AccountContactRelation> lstAccountContactRelation;
        AccountContactRelation objAccountContactRelation;
        
        System.debug('opportunityId-->'+opportunityId);
        lstOpportunity = [SELECT AccountId, Account.COM_Nombre_completo_del_cliente__c, Account.COM_Numero_de_identificacion__c, Account.COM_Ciudad__c FROM Opportunity WHERE Id =:opportunityId];
        System.debug('lstOpportunity-->'+lstOpportunity);
        objOpportunity = lstOpportunity.get(0);
        objResponse.objOpportunity = objOpportunity;
        
        lstAccountContactRelation = [SELECT Contact.Name, RF2_CorreoCorporativo__c FROM AccountContactRelation WHERE Roles INCLUDES ('Representante Legal') AND isActive = true AND AccountId =:objOpportunity.AccountId];
        System.debug('lstAccountContactRelation-->'+lstAccountContactRelation);
        if(!lstAccountContactRelation.isEmpty())
        {
            objResponse.objAccountContactRelation = lstAccountContactRelation.get(0);
        }else{
            objResponse.objAccountContactRelation=null;  
        }
        
        return objResponse;
    }  
    
    public class ResponseCartaBienvenida{
        @AuraEnabled public Opportunity objOpportunity;
        @AuraEnabled public AccountContactRelation objAccountContactRelation;     
    }
    
    /**
* @method       getQuote
* @description  Método que consulta de cliete de oportundiad y AccountContactRelation
* @author       Luis Peñaranda - 11-09-2019
*/
    @AuraEnabled
    public static ResponseCartaReafiliacion getCartaReafiliacion(String caseId){
        ResponseCartaReafiliacion objResponse = new ResponseCartaReafiliacion();
        
        list<Case> lstCase;
        Case objCase;
        
        list<AccountContactRelation> lstAccountContactRelation;
        AccountContactRelation objAccountContactRelation;
        
        System.debug('caseId-->'+caseId);
        lstCase = [SELECT AccountId, Account.COM_Nombre_completo_del_cliente__c, Account.COM_Numero_de_identificacion__c, Account.COM_Ciudad__c FROM Case WHERE Id =: caseId ];
        
        System.debug('lstCase-->'+lstCase);
        if(!lstCase.isEmpty())
        {
            objCase = lstCase.get(0);
            objResponse.objCase = objCase;
            
            
            lstAccountContactRelation = [SELECT Contact.Name, RF2_CorreoCorporativo__c FROM AccountContactRelation WHERE Roles INCLUDES ('Representante Legal') AND isActive = true AND AccountId =:objCase.AccountId];
            System.debug('lstAccountContactRelation-->'+lstAccountContactRelation);
            if(!lstAccountContactRelation.isEmpty())
            {
                objResponse.objAccountContactRelation = lstAccountContactRelation.get(0);
            }else{
                objResponse.objAccountContactRelation=null;  
            }
        }
        return objResponse;
    }  
    
    public class ResponseCartaReafiliacion{
        @AuraEnabled public Case objCase;
        @AuraEnabled public AccountContactRelation objAccountContactRelation;     
    }
    
    @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = AVX_ENC_Encuesta__c.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Principal')
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        system.debug('Map-->'+recordtypemap.values());
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){       
        Id recid = Schema.SObjectType.AVX_ENC_Encuesta__c.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        return recid;
    }         
    
    @AuraEnabled
    public static String obtainStage(Id recordId) {
        String strStage;
        
        Opportunity objOpportunity = [SELECT StageName FROM Opportunity where Id =: recordId];
        System.debug('objOpportunity.StageName: ' + objOpportunity.StageName);
        strStage = objOpportunity.StageName;
        return strStage;
    } 
    
    /**
    * @method       validarEtapa
    * @description  Método que consulta la oportundiad y valida la etapade la misma
    * @author       Steven Moque - 23-10-2020
    */
    
    @AuraEnabled
    public static String validarEtapa(String ObjectId){
        System.debug('@@ObjectId: '+ObjectId);
        String strEstado = '';
        Opportunity objOpp  = [SELECT Id, StageName        
                                    FROM Opportunity 
                                    WHERE Id =: ObjectId];

                                    // System.debug('@@objOpp: '+objOpp); 
                                    // System.debug('Id: '+  objOpp.Id);         
                                    // System.debug('StageName: '+  objOpp.StageName);
        
        if (objOpp.StageName == 'Autorizada'){
                                        // if (objOpp.StageName == 'AUTORIZADO'){
            // System.debug('@@Entra if');
            strEstado = 'SUCCESS';            

        }else{
            //System.debug('--->Entra else');
            strEstado = 'FAIL';
        }

        // System.debug('@@strEstado: '+strEstado);
        
        return strEstado;
    }    
}