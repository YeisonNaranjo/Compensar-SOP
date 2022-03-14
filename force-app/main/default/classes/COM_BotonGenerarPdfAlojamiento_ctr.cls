/**
* Avanxo Colombia
* @author           William Aldana href=<waldana@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce COM_BotonGenerarPdfAlojamiento_pag
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-30      William Aldana (WAC)            Creación clase.
*************************************************************************************************************/
public with sharing class COM_BotonGenerarPdfAlojamiento_ctr {

	public Quote objQuote {get; set;} 
	public List<Quote> quoteValues {get; set;}
	public List<OpportunityLineItem> lstOppLineItem {get; set;}
	public String strTipoDoc {get; set;}
	public Boolean noError {get; set;}

	public COM_BotonGenerarPdfAlojamiento_ctr(ApexPages.StandardController controller) {
		objQuote = (Quote) controller.getRecord();  
		quoteValues = [Select OpportunityId, Opportunity.RecordType.DeveloperName, Opportunity.COM_Fechahorainicio__c, 
		Opportunity.COM_Fechahorafinalizacion__c, Opportunity.Contacto__c 
		From Quote where Id =:objQuote.Id];
		noError = false; 
		if(!quoteValues.isEmpty()) { 
			if(quoteValues.get(0).Opportunity.RecordType.DeveloperName != 'COM_Alojamiento'){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No se puede generar PDF de Lagomar/Lagosol para esta cotización.'));
				return;
			}
			if(quoteValues.get(0).Opportunity.COM_Fechahorainicio__c == null || quoteValues.get(0).Opportunity.COM_Fechahorafinalizacion__c == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha de inicio y fecha fin.'));
				return;
			}
			if(quoteValues.get(0).Opportunity.Contacto__c == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.'));
				return;
			}

			lstOppLineItem = [select Id, COM_Familia__c FROM OpportunityLineItem WHERE OpportunityId =: quoteValues.get(0).OpportunityId AND COM_Familia__c = 'PyS']; 
			
			if(lstOppLineItem.isEmpty()){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'La oportunidad no tiene un producto de PyS, por favor adicione un producto de esta familia.'));
				return;
			}
		}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Imposible Obtener la informacion de la oportunidad asociada a la cotizacion'));
				return;
		}
		noError = true; 
	}

	public PageReference redireccionar(){
		PageReference pageRef = new PageReference('/apex/COM_Visualizador_pag?customObjectId='+objQuote.Id+'&tipo=COM_PVE_CotizacionAlojamiento_pag&idCotizacion='+objQuote.Id+'&tipoDoc='+strTipoDoc);
		return pageRef;
	}

}