({    
	doInit : function(component, event, helper) {
		helper.fillPickList(component, event, helper);
        helper.validarDevice(component, event, helper); 
    },    
    generar : function(component, event, helper) {
        helper.getQuote(component, event, helper);
        var compEvent = component.getEvent("sampleComponentEvent");  
        compEvent.fire();
    },
    cancelar : function(component, event, helper) {
		 var compEvent = component.getEvent("sampleComponentEvent");  
        compEvent.fire();
    }, 
})