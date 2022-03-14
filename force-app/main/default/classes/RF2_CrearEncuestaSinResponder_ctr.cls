/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Controlador para la pagina encargada de crear encuestas desde las oportunidades

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/04      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
public with sharing class RF2_CrearEncuestaSinResponder_ctr {
	
	public AVX_ENC_Encuesta__c objEncuesta {get; set;}
	public String strContacto {get; set;}
	public String strPlantilla {get; set;}
	public Opportunity objOpportunity {get; set;}
	public list<SelectOption> lstContactos {get; set;}
	public list<SelectOption> lstOpcionesPlantillas {get; set;}
	
	private final String SIN_CONTACTO = 'NoContacto';
	private final String SIN_PLANTILLA = 'NoPlantilla';
	
	public RF2_CrearEncuestaSinResponder_ctr(ApexPages.StandardController controller) {
		list<RecordType> lstRecordType;
		list<AVX_ENC_PlantillaEncuesta__c> lstPlantillasEncuestas;
		
		if(controller == null){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No llegó oportunidad'));
			return;
		}
		
		objOpportunity = (Opportunity) controller.getRecord();  
		
		objOpportunity = [SELECT Id, Name, Account.Name, AccountId  FROM Opportunity WHERE Id = :objOpportunity.Id].get(0);
		
		objEncuesta = new AVX_ENC_Encuesta__c();
		
		lstRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'AVX_ENC_Encuesta__c' AND DeveloperName = 'Sin_contestar'];
		
		if(lstRecordType.isEmpty()){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No se ha configurado el tipo de registro para encuesta Sin Contestar.'));
			return;
		}
		
		lstPlantillasEncuestas = [SELECT Id, Name FROM AVX_ENC_PlantillaEncuesta__c WHERE Activo__c = true];
		
		lstOpcionesPlantillas = new list<SelectOption>();
		if(!lstPlantillasEncuestas.isEmpty()){
			for(AVX_ENC_PlantillaEncuesta__c objPlantilla : lstPlantillasEncuestas){
				lstOpcionesPlantillas.add(new SelectOption(objPlantilla.Id, objPlantilla.Name));
			}
		} else{
			lstOpcionesPlantillas.add(new SelectOption(SIN_PLANTILLA,'No hay plantillas para seleccionar')); 
		}
		
		objEncuesta.RecordTypeId = lstRecordType.get(0).Id;
		objEncuesta.COM_Cliente__c = objOpportunity.AccountId;
		objEncuesta.COM_Oportunidad__c = objOpportunity.Id;
		
		List<AccountContactRelation> lstRelacion = new List<AccountContactRelation>();
		lstRelacion = [SELECT Id, ContactId, Contact.Name FROM AccountContactRelation 
					   WHERE AccountId = :objOpportunity.AccountId];
		
		lstContactos = new list<SelectOption>();
		if(!lstRelacion.isEmpty()){
			for(AccountContactRelation objAccountContactRelation : lstRelacion){
				lstContactos.add(new SelectOption(objAccountContactRelation.ContactId, objAccountContactRelation.Contact.Name));
			}
		} else{
			lstContactos.add(new SelectOption(SIN_CONTACTO,'No hay contactos para seleccionar')); 
		}
	} 
	
	public PageReference guardar(){
		
		if(strContacto == null || strContacto.equals(SIN_CONTACTO)){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sin Contacto no se puede guardar la encuesta.'));
			return null;
		}
		
		if(strPlantilla == null || strPlantilla.equals(SIN_PLANTILLA)){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sin plantilla no se puede guardar la encuesta.'));
			return null;
		}
		
		objEncuesta.COM_Contacto__c = strContacto;
		objEncuesta.Plantilla_encuesta__c = strPlantilla;
		
		insert objEncuesta;
		
		PageReference newPage = New PageReference('/' + objOpportunity.Id);
		newPage.setRedirect(true);
		return newPage;
	}
    
}