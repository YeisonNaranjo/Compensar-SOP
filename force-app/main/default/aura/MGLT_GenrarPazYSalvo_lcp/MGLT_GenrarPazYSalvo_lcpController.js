({    
	doInit : function(component, event, helper) {
		helper.fillPickList(component, event, helper); 
        helper.validarDevice(component, event, helper); 
    },    
    generar : function(component, event, helper) {
        helper.gotoURL(component, event, helper);
    },
 
})