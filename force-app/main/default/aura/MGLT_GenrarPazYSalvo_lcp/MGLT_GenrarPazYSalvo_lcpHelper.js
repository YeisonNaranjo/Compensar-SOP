({  
    fillPickList : function(component, event, helper) {
        
        var action = component.get('c.getClientePazySalvo'); 
        var returnCliente;
        
        action.setParams({
            "AccountId" : component.get("v.recordId") 
        });
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state           
            if(state == 'SUCCESS') {
                returnCliente =  a.getReturnValue();  
                if(returnCliente!=null){
                    
                    if( returnCliente.COM_TipoIdentificacion__c == null || returnCliente.COM_Numero_de_identificacion__c == null || returnCliente.COM_FechaAportePazSalvo__c == null || returnCliente.COM_FechaAfiliacion__c== null || returnCliente.COM_FechaRetiro__c == null || returnCliente.COM_CorreoElectronico__c == null)
                    {
                        helper.showToast('Para generar un paz y salvo los campos "Correo Electrónico, Fecha de afiliación", "Fecha de Retiro" y "Fecha ultimo aporte paz y salvo" deben de estar diligenciados.','error',"Ha ocurrido un incidente!"); 
                        $A.get("e.force:closeQuickAction").fire();
                    }else{                   
                        var opts = [
                            { "class": "optionClass", label: "Empresa 4%s", value: "Empresas4", selected: "true" },
                            { "class": "optionClass", label: "Empresas Ley 1429", value: "EmpresasLey1429" },
                            { "class": "optionClass", label: "Empresas Ley 590", value: "EmpresasLey590" }  
                        ];
                        
                        if(returnCliente.RecordType.DeveloperName=='COM_Natural'){
                            opts = [
                                { "class": "optionClass", label: "Independiente 2%", value: "Independiente2",selected: "true" },
                                { "class": "optionClass", label: "Independiente 0.6", value: "Independiente06" },
                                { "class": "optionClass", label: "Servicio Domestico", value: "ServicioDomestico" },
                                { "class": "optionClass", label: "Pensionado 2%", value: "Pensionado2" },
                                { "class": "optionClass", label: "Pensionado 0.6%", value: "Pensionado06g" }   
                            ];                                              
                        }
                        component.find("InputSelectDynamic").set("v.options", opts);  
                    }  
                }
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
    
    gotoURL : function (component,event, helper) {
        var ClienteId 		=   component.get("v.recordId") ;
        var dynamicCmp 		= 	component.find("InputSelectDynamic");
        var tipodoc 	= 	dynamicCmp.get("v.value");
        helper.showToast('Generando Paz y Salvo, por favor espere...','success',"Por favor espere!");
        var strUrl = "/apex/COM_Visualizador_pag?customObjectId="+ClienteId+"&tipo=PazySalvo&tipoDoc="+tipodoc;       
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