({       
    generaPDF : function (component, helper) {
       var ActaId 		=   component.get("v.recordId") ;
       helper.showToast('Generando Encuentro con Directivos...','success',"Buen trabajo!");
       var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+ActaId+"&tipo=EncuentroDirectivos";
       var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
         "url": strUrl
       });
       urlEvent.fire();
       $A.get("e.force:closeQuickAction").fire();  
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