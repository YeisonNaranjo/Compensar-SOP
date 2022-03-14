/**
* Avanxo Colombia
* @author           William Aldana href=<waldana@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce COM_BotonEncuentroConDirectivos_ctr
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-12-04      William Aldana (WAC)            Creación clase.
*************************************************************************************************************/
public with sharing class COM_BotonEncuentroConDirectivos_ctr {

	public COM_Actas__c objActa {get; set;} 
	public List<COM_Actas__c> actaValues {get; set;}
	//public List<OpportunityLineItem> lstOppLineItem {get; set;}
	public String strTipoDoc {get; set;}
	public Boolean noError {get; set;}

	public COM_BotonEncuentroConDirectivos_ctr(ApexPages.StandardController controller) {
		noError = false;
		objActa = (COM_Actas__c) controller.getRecord();  
		actaValues = [SELECT RecordType.DeveloperName FROM COM_Actas__c where Id =:objActa.Id];
		if(!actaValues.isEmpty()) { 
			if(actaValues.get(0).RecordType.DeveloperName != 'COM_Encuentro_con_directivos'){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No se puede generar PDF de Encuentro con Directivos para esta Acta.'));
				return;
			}
		}else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Imposible Obtener la informacion del Acta'));
				return;
		}
		noError = true;
	}


	public PageReference redireccionar(){
		PageReference pageRef = new PageReference('/apex/COM_Visualizador_pag?customObjectId='+objActa.Id+'&tipo=EncuentroDirectivos');
		return pageRef;
	}
}