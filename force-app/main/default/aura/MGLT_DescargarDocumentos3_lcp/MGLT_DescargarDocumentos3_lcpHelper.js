({
	getDocuments: function (component, event, helper) {
		
		var action = component.get("c.getURL");
		var rcrdId = component.get("v.recordId");
		var hlp = this;
        
        action.setParams({ strRecordId: rcrdId });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var res = response.getReturnValue();
				var strURL = res.strURLDownload;
                console.log('--->URL : '+strURL);
                var state = '';
                if (strURL != null){
                    state = 'Success';
                    var wd = window.open(strURL, '_parent');
                }
                else{
                    state = 'Warning';
                }
                hlp.showToast(res.strMensaje,state);
                $A.get("e.force:closeQuickAction").fire();
                
			}
			else {
				console.log('Error en la respuesta del servidor.')
				$A.get("e.force:closeQuickAction").fire();
            }
		});
		$A.enqueueAction(action);
		
    },
    //Permite descargar uno a uno los archivos 
    descargarArchivos: function (component,helper,mapa,llaves,current) {
      
        var next = current + 1;
        console.log('next : '+next);
        if (next > llaves.length){
            return;
        }
        else{
            var key = llaves[current];
            console.log('Va a descargar archivos - key : '+key);
            console.log('Va a descargar archivos - value : ' + mapa[key]);
          
            var hiddenElement = document.createElement('a');
            hiddenElement.target = '_blank';
            hiddenElement.href = key;
            hiddenElement.download = mapa[key];
            hiddenElement.click();            
            
            setTimeout(function () {
                helper.descargarArchivos(component, helper, mapa, llaves, next);
            }, 1700);          
            
        }       

    },
    
    validarDevice: function (component,event, helper) 
    {
        var device = $A.get("$Browser.formFactor");
        if(device!='DESKTOP'){
            component.set("v.blnIsMobile",true);
        
            helper.showToast('La funcionalidad no está disponible en dispositivos móviles','warning',"Por favor espere!");
        	$A.get("e.force:closeQuickAction").fire();
            
        }
        else{
            var recordId = component.get("v.recordId");
            if (recordId.startsWith('500')) {
                component.set("v.blnIsCase", true);
                console.log('---<< ES UN CASOOO');
            }
            else {
                component.set("v.blnIsCase", false);
                helper.getDocuments(component, event, helper);
            }
        }

    },
    
    showToast : function(message,type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "type": type,
        "message": message
    });
    toastEvent.fire(); }
})