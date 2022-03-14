/**
* Avanxo Colombia
* @author           Paula Bohórquez href=<pbohorquez@avanxo.com>
* Project:          Compensar
* Description:      Batch para enviar correos electrónicos de los candidatos Cuenta Acreedora
                    creados que no tengan marcado el check de 'Correo Enviado'
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2019-09-12      Paula Bohórquez (PB)            Creación de la clase
*************************************************************************************************************/
global class CEL1_EnvioCorreoCuentaAcreedora_bch implements Database.Batchable<sObject>, Database.Stateful{

    global Integer intEmailsDisponiblesEnviar;
    global Integer intRegistrosProcesados;
    global String strHtmlTemplateIndependiente;
    global String strHtmlTemplateJuridico;
    global String strHtmlTemplateDomestico;
    global String strHtmlTemplateNatural;
    
    global CEL1_EnvioCorreoCuentaAcreedora_bch(){

        List<CEL1_ConfiguracionLogCorreos__mdt> lstMdt = [SELECT CEL1_NumeroCorreosSalientes__c FROM CEL1_ConfiguracionLogCorreos__mdt LIMIT 1];
        Integer intMaxCorreosDiarios = Integer.valueOf(lstMdt[0].CEL1_NumeroCorreosSalientes__c);
        Integer intCorreosEnviadosHoy = [SELECT count() FROM Log_Correo_Electronico__c WHERE CEL1_Candidato__c != '' AND Fecha_Envio__c >=: System.today()];
        intEmailsDisponiblesEnviar = intMaxCorreosDiarios - intCorreosEnviadosHoy;
        intRegistrosProcesados  = 0;
        System.debug('**** CEL1_EnvioCorreoCuentaAcreedora_bch : intEmailsDisponiblesEnviar: '+intEmailsDisponiblesEnviar);
        List<EmailTemplate> lstETIndependiente = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAIndependiente];
        strHtmlTemplateIndependiente = lstETIndependiente.isEmpty()?'':lstETIndependiente[0].Id;
        List<EmailTemplate> lstETJuridico = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAPerJuridica];
        strHtmlTemplateJuridico = lstETJuridico.isEmpty()?'':lstETJuridico[0].Id;
        List<EmailTemplate> lstETDomestico = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAEmpleDomes];
        strHtmlTemplateDomestico = lstETDomestico.isEmpty()?'':lstETDomestico[0].Id;
        List<EmailTemplate> lstETNatural = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAPerNatural];
        strHtmlTemplateNatural = lstETNatural.isEmpty()?'':lstETNatural[0].Id;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(intEmailsDisponiblesEnviar > 0){
            String query = 'SELECT Id,Email,CEL1_TipoAportante__c,CEL1_EmailFueEnviado__c FROM Lead WHERE CEL1_EmailFueEnviado__c = false AND IsConverted = false AND Email != null AND (RecordType.DeveloperName = \'CEL1_ProspectoCuentaAcreedoraPN\' OR RecordType.DeveloperName = \'CEL1_ProspectosCuentaAcreedoraPJ\') LIMIT '+String.valueOf(intEmailsDisponiblesEnviar);
            System.debug('****** QUERY :: '+query);
            return Database.getQueryLocator(query);
        }
        else{
            String query2 = 'SELECT Id FROM Lead WHERE Id = \'\'';
            System.debug('****** QUERY :: '+query2);
            return Database.getQueryLocator(query2);
        }        
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> lstCandidatos) {
        System.debug('****** CEL1_EnvioCorreoCuentaAcreedora_bch : registrosProcesadosBef :'+intRegistrosProcesados);
        System.debug('****** lstCandidatos '+lstCandidatos);
        Set<Id> setIdsIndependiente = new Set<Id>();
        Set<Id> setIdsJuridico = new Set<Id>();
        Set<Id> setIdsDomestico = new Set<Id>();
        Set<Id> setIdsNatural = new Set<Id>();
        for(Lead objCandidato : lstCandidatos){
            if(String.isNotBlank(objCandidato.Email)){     
                if(objCandidato.CEL1_TipoAportante__c==Label.CEL1_TipoAportanteIndependiente){
                    setIdsIndependiente.add(objCandidato.Id);
                    intRegistrosProcesados ++;
                } else if (objCandidato.CEL1_TipoAportante__c==Label.CEL1_TipoAportanteJuridica){
                    setIdsJuridico.add(objCandidato.Id);
                    intRegistrosProcesados ++;
                } else if (objCandidato.CEL1_TipoAportante__c==Label.CEL1_TipoAportanteEmpleDomes){
                    setIdsDomestico.add(objCandidato.Id);
                    intRegistrosProcesados ++;
                } else {
                    setIdsNatural.add(objCandidato.Id);
                    intRegistrosProcesados ++;
                }               
            }
        }
        System.debug('****** CEL1_EnvioCorreoCuentaAcreedora_bch : intEmailsDisponiblesEnviar :'+intEmailsDisponiblesEnviar);
        System.debug('****** CEL1_EnvioCorreoCuentaAcreedora_bch : registrosProcesadosBef :'+intRegistrosProcesados);
        
        if(intRegistrosProcesados<=intEmailsDisponiblesEnviar){
            COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsIndependiente,strHtmlTemplateIndependiente);        
            COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsJuridico,strHtmlTemplateJuridico);        
            COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsDomestico,strHtmlTemplateDomestico);        
            COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsNatural,strHtmlTemplateNatural);        
        }      
        
    }   
    
    global void finish(Database.BatchableContext BC) {      
        CEL1_CreacionLogCorreoCA_bch bchCrearLog = new CEL1_CreacionLogCorreoCA_bch();
        Id batchJob = Database.executeBatch(bchCrearLog);
        System.debug('**** Se lanza el batch CEL1_CreacionLogCorreoCA_bch '+batchJob);

    }
}