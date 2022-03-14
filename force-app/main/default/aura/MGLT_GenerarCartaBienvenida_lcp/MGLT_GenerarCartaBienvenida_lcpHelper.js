({  
	fillPickList : function(component, event, helper) {
        var opts = [
            { "class": "optionClass", label: "Bienvenida A, A1", value: "BienvenidaA_A1", selected: "true" },
            { "class": "optionClass", label: "Bienvenida B, C, D", value: "BienvenidaB_C_D" },
            { "class": "optionClass", label: "Bienvenida Primer Empleo", value: "BienvenidaPrimerEmpleo" },
            { "class": "optionClass", label: "Bienvenida Independientes 0.6%", value: "Bienvenida_Carta_de_Aceptaci_n_Independientes_0_6" },
            { "class": "optionClass", label: "Bienvenida Independientes 2%s", value: "Bienvenida_Carta_de_Aceptaci_n_Independientes_2_004" },
            { "class": "optionClass", label: "Bienvenida Pensionados 0.6%", value: "Bienvenida_Carta_de_Aceptaci_n_Pensionados_0_6" },
            { "class": "optionClass", label: "Bienvenida Pensionados 2%", value: "Bienvenida_Carta_de_Aceptaci_n_Pensionados_2" }    
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
        var action = component.get('c.getCartaBienvenida'); 
        var returnCarta;
        
        action.setParams({
            "opportunityId" : component.get("v.recordId") 
        });
         
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state           
            if(state == 'SUCCESS') {
                returnCarta =  a.getReturnValue();  
                if(returnCarta!=null){
                    if(returnCarta.objOpportunity.Account.COM_Numero_de_identificacion__c == null || returnCarta.objOpportunity.Account.COM_Ciudad__c == null)
                    {
                        helper.showToast('Faltan campos de la cuenta','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();

                    }else if(returnCarta.objAccountContactRelation==null)
                    {
                        helper.showToast('La cuenta no tiene representante legal','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();
                    }else if(returnCarta.objAccountContactRelation.RF2_CorreoCorporativo__c == null)
                    {
                        helper.showToast('El Representante legal no tiene un correo asignado, añada el correo en el campo Correo corporativo del registro de la relación.l','error',"Ha ocurrido un incidente!"); 
                		$A.get("e.force:closeQuickAction").fire();
                    }else{
                        helper.showToast('Generando Carta de Bienvenida...','success',"Buen trabajo!");
                        helper.gotoURL(component, helper);
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }               
            }else{
               helper.showToast('No se puede generar PDF de Carta de Bienvenida','error',"Ha ocurrido un incidente!"); 
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoURL : function (component, helper) {
     	var OppId 		=   component.get("v.recordId") ;
        var dynamicCmp 		= 	component.find("InputSelectDynamic");
        var tipdoc 	= 	dynamicCmp.get("v.value");
		var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+OppId+"&tipo=CartaBienvenida&tipoDoc="+tipdoc;
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