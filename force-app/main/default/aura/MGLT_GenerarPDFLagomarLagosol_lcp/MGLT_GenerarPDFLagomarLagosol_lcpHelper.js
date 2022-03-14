({  
	fillPickList : function(component, event, helper) {
        var opts = [
            { "class": "optionClass", label: "Convencion Lagomar", value: "Lagomar", selected: "true" },
            { "class": "optionClass", label: "Convencion Lagosol", value: "Lagosol" },
            { "class": "optionClass", label: "Pasadia Lagomar", value: "PasadiaLagomar" },
            { "class": "optionClass", label: "Pasadia Lagosol", value: "PasadiaLagosol" }   
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
        var action = component.get('c.getQuoteOppLagos'); 
        var returnQuote;
        
        action.setParams({
            "strQuoteId" : component.get("v.recordId") 
        });
         
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state 
            var hayError=false;
            if(state == 'SUCCESS') {
                returnQuote =  a.getReturnValue(); 
                if(returnQuote!=null){
                    
                    if(returnQuote.objQuote.Opportunity.RecordType.DeveloperName!='COM_Alojamiento'){
                        hayError=true;
                        helper.showToast('No se puede generar PDF de Lagomar/Lagosol para esta cotización.','error',"!");
                        $A.get("e.force:closeQuickAction").fire();
                    }
                    
                    if(returnQuote.objQuote.Opportunity.COM_Fechahorainicio__c == null || returnQuote.objQuote.Opportunity.COM_Fechahorafinalizacion__c == null)
                    {
                        hayError=true;
                        helper.showToast('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha de inicio y fecha fin.','error',"!");
                        $A.get("e.force:closeQuickAction").fire();                        
                    }

                    if(returnQuote.objQuote.Opportunity.Contacto__c == null )
                    {
                        hayError=true;
                        helper.showToast('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.','error',"!");
                        $A.get("e.force:closeQuickAction").fire();                        
                    }

                    if(returnQuote.objOpportunityLineItem == null )
                    {
                        hayError=true;
                        helper.showToast('La oportunidad no tiene un producto de PyS, por favor adicione un producto de esta familia.','error',"!");
                        $A.get("e.force:closeQuickAction").fire();                        
                    }
                        
                    if(hayError==false){
                        helper.showToast('Generando PDF...','success',"Por favor espere!");
                        helper.gotoURL(component, helper);
                        $A.get("e.force:closeQuickAction").fire();                        
                        
                    }
                }               
            }else{
               helper.showToast('No se puede generar PDF Lagomar/Lagosol para esta cotización','error',"Ha ocurrido un incidente!"); 
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoURL : function (component, helper) {
     	var QuoteId 		=   component.get("v.recordId") ;
        var dynamicCmp 		= 	component.find("InputSelectDynamic");
        var tipdoc 	= 	dynamicCmp.get("v.value");
        var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+QuoteId+"&tipo=COM_PVE_CotizacionAlojamiento_pag&idCotizacion="+QuoteId+"&tipoDoc="+tipdoc;
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