({       
    doInit : function(component, event, helper) {
        helper.validarDevice(component, event, helper); 
        helper.generaPDF(component,  helper);
        //helper.validarEtapa(component, event, helper);
    },
 
})