({       
    generaPDF : function (component, helper) {
        var opportunityId 		=   component.get("v.recordId") ;
        var oppStageReturn;
        var action				=	component.get("c.obtainStage"); 
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state   
            if(state === "SUCCESS") {
                helper.showToast('Generando Ficha Tecnica Alojamiento...','success',"Buen trabajo!");
                oppStageReturn =  response.getReturnValue();  
                var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+opportunityId+"&tipo=COM_PVE_CotizacionFichaTecnicaLago_pag&tipoDoc=FichaTecnica&stageOpp="+oppStageReturn;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": strUrl
                });
                urlEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }else{
                helper.showToast('No se puede generar PDF de Salud para esta cotización','error',"Ha ocurrido un incidente!"); 
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    }, 
    validarDevice: function (component,event, helper) 
    {
        var device = $A.get("$Browser.formFactor");
        if(device!='DESKTOP'){
            helper.showToast('la funcionalidad no esta disponible en dispositivos moviles','warning',"Por favor espere!");
            $A.get("e.force:closeQuickAction").fire();
            
        }
        
        
    },  
    validarEtapa: function (component,event, helper){
        //alert('@@@validarEtapa');
        //alert("@@@"+intlstProdQuote);
        var validEtapa = false;
        var action 	    = component.get("c.validarEtapa");
        action.setParams({'ObjectId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            alert('Estado:'+state);
            var storeResponse = response.getReturnValue();
            //alert('@@@storeResponse:'+JSON.stringify(storeResponse));
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                if (storeResponse === "SUCCESS"){
                    //console.log("Success ");
                    //console.log("tt",JSON.Stringify(response.getReturnValue()));
                    //alert("Entro a success");            				
                    toastEvent.setParams({
                        "title": "Éxito",
                        "type": "Success",
                        "message": "La oportunidad esta creando la Ficha Tecnica de manera exitosa."
                    });
                    toastEvent.fire()
                    $A.get("e.force:closeQuickAction").fire();
                    helper.generaPDF(component, helper);
                    // validEtapa = true;
                }else{
                    toastEvent.setParams({
                        "title": "Error",
                        "type": "Error",
                        "message": "La oportunidad no esta en etapa 'AUTORIZADO', no puede generar la Ficha Tecnica de Alojamiento."
                        //s"Ocurrio un error al tratar de pero cansiono, @@@@ del sistema."
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    validEtapa = false;
                }
                
            }else{
                alert('Entro a error:'+JSON.stringify(response));
                toastEvent.setParams({
                    "title": "Error",
                    "type": "Error",
                    "message": "Error al validar la etapa de la oportunidad."
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                validEtapa = false;				
            }
        });
        $A.enqueueAction(action);
        return validEtapa;
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