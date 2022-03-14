({  
	fillPickList : function(component, event, helper) {
        var opts = [
            { "class": "optionClass", label: "Reafiliación A, A1", value: "BienvenidaA_A1", selected: "true" },
            { "class": "optionClass", label: "Reafiliación B, C, D", value: "BienvenidaB_C_D" },
            { "class": "optionClass", label: "Reafiliación Pensionados", value: "BienvenidaPensionados" },
            { "class": "optionClass", label: "Reafiliación Primer Empleo", value: "BienvenidaPrimerEmpleo" } 
        ];
        component.find("InputSelectDynamic").set("v.options", opts);    
    }, 
    validarDevice: function (component,event, helper) 
    {
        var device = $A.get("$Browser.formFactor");
        if(device!='DESKTOP'){
            helper.showToast('la funcionalidad no esta disponible en dispositivos moviles','warning',"Por favor espere!");
        	$A.get("e.force:closeQuickAction").fire();
            
        }
        

    },    
    getQuote : function(component, event, helper) {
        var action = component.get('c.getCartaReafiliacion'); 
        var returnCarta;
        action.setParams({
            "caseId" : component.get("v.caseIdParam") 
        });

        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state   
            if(state == 'SUCCESS') {
                returnCarta =  a.getReturnValue();  
                if(returnCarta!=null){
                    console.log('A ver-->'+returnCarta.objCase.Account);
                    if(returnCarta.objCase.Account == null )
                    {
                        helper.showToast('El caso no tiene cliente asociado','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();

                    }else if(returnCarta.objCase.Account.COM_Numero_de_identificacion__c == null || returnCarta.objCase.Account.COM_Ciudad__c == null)
                    {
                        helper.showToast('Faltan campos de la cuenta: Identifiacion y/o Ciuad.','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();

                    }else if(returnCarta.objAccountContactRelation==null)
                    {
                        helper.showToast('La cuenta no tiene representante legal','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();
                    }else if(returnCarta.objAccountContactRelation.RF2_CorreoCorporativo__c == null)
                    {
                        helper.showToast('El Representante legal no tiene un correo asignado, añada el correo en el campo Correo corporativo del registro de la relación.','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();
                    }else{
                        helper.showToast('Generando Carta de Bienvenida...','success',"Buen trabajo!");
                        helper.gotoURL(component, helper);
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }               
            }else{
               helper.showToast('No se puede generar PDF de Carta de Reafiliacion','error',"Ha ocurrido un incidente!"); 
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoURL : function (component, helper) {
     	var CaseId 		=   component.get("v.caseIdParam") ;
        var dynamicCmp 		= 	component.find("InputSelectDynamic");
        var tipdoc 	= 	dynamicCmp.get("v.value");
        var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+CaseId+"&tipo=CartaReafiliacion&tipoDoc="+tipdoc;
    	var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      	"url": strUrl
    	});
    	urlEvent.fire();
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