({  
	fillPickList : function(component, event, helper) {
        
        var opts = [
            { "class": "optionClass", label: "Cotizacion Capacitaciones", value: "1587482240000/COM_PVE_CotizacionCapacitaciones_pag", selected: "true" },
            { "class": "optionClass", label: "Cotización de chequeos médicos", value: "1587482240000/COM_PVECotizacionChequeosMedicos_pag" },
            { "class": "optionClass", label: "Cotizacion Riesgo Psicosocial", value: "1587482240000/COM_PVE_CotizacionRiesgoPsicosocial_pag" },
            { "class": "optionClass", label: "Cotización Exámenes Bogotá", value: "1586293141000/COM_PVE_SOExamenesBogota_pag" },
            { "class": "optionClass", label: "Cotizacion Vacunación", value: "1589398596000/COM_PVE_AnexoCotizacionvacunacion_pag" },
            { "class": "optionClass", label: "Cotización Riesgo Psicosocial2", value: "1589398597000/COM_PVE_riesgopsicosocialacy20202_pag" },
            { "class": "optionClass", label: "Cotización SST Exámenes AF", value: "1589249495000/COM_PVE_SSTexamenesAF_pag" },
            { "class": "optionClass", label: "Cotizaciones Profeciograma", value: "1589398597000/COM_PVE_PROFESIOGRAMA_pag" },
            { "class": "optionClass", label: "Cotizaciones Salud Empresarial", value: "1589398597000/COM_PVE_SaludEmpresarial_pag" },
            { "class": "optionClass", label: "Cotizaciones Capacitaciones NA 2020", value: "1589398597000/COM_PVE_CotizacionCapacitacionesNA2020_pag" }
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
        var action = component.get('c.getQuote'); 
        var returnQuote;
        
      
        
        action.setParams({
            "strQuoteId" : component.get("v.recordId") 
        });
         
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            
              
            
            if(state == 'SUCCESS') {
                returnQuote =  a.getReturnValue();  
                if(returnQuote!=null){
                    if(returnQuote.Opportunity.RecordType.DeveloperName=='COM_Salud'){
                        helper.showToast('Generando PDF...','success',"Buen trabajo!");
                        helper.gotoURL(component, helper);
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }               
            }else{
               helper.showToast('No se puede generar PDF de Salud para esta cotización.','error',"Ha ocurrido un incidente!"); 
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoURL : function (component, helper) {
     	var QuoteId 		=   component.get("v.recordId") ;
        var dynamicCmp 		= 	component.find("InputSelectDynamic");
        var strVisualForce 	= 	dynamicCmp.get("v.value");
        
        //var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+QuoteId+"&idCotizacion="+QuoteId+"&tipo="+strVisualForce;
        
        var strUrl = "/apex/COM_VisualizadorCotizacion_pag?customObjectId="+QuoteId+"&idCotizacion="+QuoteId+"&tipo="+strVisualForce;
        //var strUrl = "/resource/" + strVisualForce;

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