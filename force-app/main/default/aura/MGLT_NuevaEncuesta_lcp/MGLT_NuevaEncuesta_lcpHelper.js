({       
    crearEncuesta : function (component, helper) {
        var oppId 		=   component.get("v.recordId") ;
        alert('oppId-->'+oppId);
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "AVX_ENC_Encuesta__c",
            "defaultFieldValues": {
                'COM_Oportunidad__c' : oppId,
               'COM_Cliente__c' : null
            }
        });
        createAcountContactEvent.fire();
        
       
       //helper.showToast('Generando Encuenotr con directivos...','success',"Buen trabajo!");
 
   
   }, 
    validarDevice: function (component,event, helper) 
    {
        var device = $A.get("$Browser.formFactor");
        if(device!='DESKTOP'){
            helper.showToast('la funcionalidad no esta disponible en dispositivos moviles','warning',"Por favor espere!");
        	$A.get("e.force:closeQuickAction").fire();
            
        }
        

    },    
    showToast: function (message,type,tittle) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
            //"title": tittle,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	}
    
})