/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase Helper para el Trigger COM_Opportunity_tgr, Clase Test es RL2_LeadHelper_tst
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     08/07/21        Jorge Pozo (JPA)		Creación Clase.
**************************************************************************************************/
public without sharing class RL2_OpportunityHelper_cls {
    
    /**
    * @Method:      actualizarTipoRegistro
    * @param:       List<Opportunity> listNewOpps
    * @Description: Actuliza el tipo de registro de la Oportunidad en base al Tipo de Solicitud de Candidato
    * @author       Jorge Pozo (JPA) - 08/07/21
    */
    public static void actualizarTipoRegistro(List<Opportunity> listNewOpps) {
        
        for(Opportunity opp: listNewOpps) {
            if(opp.COS_DesdeProspectoOpp__c == True) {
                if(opp.RL2_TipoDeSolicitudDeCandidato__c != null) {
                    if(opp.RL2_TipoDeSolicitudDeCandidato__c == 'Contratista 0.6 %' || opp.RL2_TipoDeSolicitudDeCandidato__c == 'Contratista 2 %') {
                        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_Vinculacion_Contratista').getRecordTypeId();
                    } else if(opp.RL2_TipoDeSolicitudDeCandidato__c == 'Empleador Servicio Domestico' || opp.RL2_TipoDeSolicitudDeCandidato__c == 'Empresa nueva') {
                        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_VEmpresas').getRecordTypeId();
                    } else if(opp.RL2_TipoDeSolicitudDeCandidato__c == 'Independiente 0.6%' || opp.RL2_TipoDeSolicitudDeCandidato__c == 'Independiente 2%') {
                        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_VIndependientes').getRecordTypeId();
                    } else if(opp.RL2_TipoDeSolicitudDeCandidato__c == 'Pensionado 0.6%' || opp.RL2_TipoDeSolicitudDeCandidato__c == 'Pensionado 2%' || opp.RL2_TipoDeSolicitudDeCandidato__c == 'Traslado') {
                        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('COM_Vinculacion_Pensionado').getRecordTypeId();
                    }                
                }
                
                if(opp.LeadSource != null) {
                    if(opp.LeadSource == 'Call Center' || opp.LeadSource == 'Chat' || opp.LeadSource == 'Atención Presencial') {
                        opp.COM_Origen_de_afiliacion__c = opp.LeadSource;
                    }
                }
            }
        }
    }

}