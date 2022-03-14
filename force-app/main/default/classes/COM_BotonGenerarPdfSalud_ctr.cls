public with sharing class COM_BotonGenerarPdfSalud_ctr {

	public Quote objQuote {get; set;} 
	public List<Quote> quoteValues {get; set;}
	//public List<OpportunityLineItem> lstOppLineItem {get; set;}
	public String strTipoDoc {get; set;}
	public Boolean noError {get; set;}

	public COM_BotonGenerarPdfSalud_ctr(ApexPages.StandardController controller) {
		noError = false;
		objQuote = (Quote) controller.getRecord();  
		quoteValues = [Select Opportunity.RecordType.DeveloperName from Quote where Id =:objQuote.Id];

		if(!quoteValues.isEmpty()) { 
			if(quoteValues.get(0).Opportunity.RecordType.DeveloperName != 'COM_Salud'){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No se puede generar PDF de Salud para esta cotización.'));
				return;
			}
			
		}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Imposible Obtener la informacion de la oportunidad asociada a la cotizacion'));
				return;
		}
		noError = true;
	}

	public PageReference redireccionar(){
			PageReference pageRef = new PageReference('/apex/COM_Visualizador_pag?customObjectId='+objQuote.Id+'&idCotizacion='+objQuote.Id+'&tipo=' + strTipoDoc);
			return pageRef;
	}
}