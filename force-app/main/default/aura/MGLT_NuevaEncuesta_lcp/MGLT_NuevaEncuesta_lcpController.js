({
    
    fetchListOfRecordTypes: function(component, event, helper) {
        helper.validarDevice(component, event, helper); 
        var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response) {
            var valores = response.getReturnValue();;
            var opt =[];
            
            for(var i=0;i<=valores.length-1;i++){
                var valor = valores[i];
                if(i==0){
                    opt.push({label:valor,value:valor,isChecked:true});
                    component.set("v.selOption", valor);
                }
                else{
                    opt.push({label:valor,value:valor,isChecked:false});   
                }
            }
            component.set("v.lstOfRecordType", opt);
        });
        $A.enqueueAction(action);
        
    },
    
    createRecord: function(component, event, helper) {
        
        var action = component.get("c.getRecTypeId");
        var recordTypeLabel = component.find("selectid").get("v.value");
        action.setParams({
            "recordTypeLabel": recordTypeLabel
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var objId 		=   component.get("v.recordId") ;
                var RecTypeID  	= response.getReturnValue(); 
                
                var myIdPrefix = objId.substring(0, 3);
                
                alert(myIdPrefix);
                var createEncuestaContactEvent = $A.get("e.force:createRecord");
                if(myIdPrefix=='006')
                {                
                    createEncuestaContactEvent.setParams({
                        "entityApiName": "AVX_ENC_Encuesta__c",
                        'recordTypeId' :RecTypeID,
                        "defaultFieldValues": {
                            'COM_Oportunidad__c' : objId,
                            
                        }
                    });
                }else{
                    createEncuestaContactEvent.setParams({
                        "entityApiName": "AVX_ENC_Encuesta__c",
                        'recordTypeId' :RecTypeID,
                        "defaultFieldValues": {
                            'COM_Cliente__c' : objId,
                            
                        }
                    });                    
                }
                createEncuestaContactEvent.fire();             
                
                
                
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "NO se puede completar la operacion, conctacte a su administrador"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "NO se puede completar la operacion, conctacte a su administrador"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
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