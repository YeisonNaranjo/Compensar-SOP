/**
 * Created by cristianmosquera on 3/02/20.
 */
({

    callGenericService : function (component, event, helper, operationName, messageSuccess, requestResponseDTO, nameWrapperDTO) {
                var toastEvent = $A.get("e.force:showToast");

                if(requestResponseDTO != null) {
                    console.log('requestResponseDTO-->'+ JSON.stringify(requestResponseDTO));
                    action.setParams({"jsonInitParam": JSON.stringify(requestResponseDTO)});
                }
                var action = component.get(operationName);

                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log('State-->'+ state);
                    console.log('IsValid--->',component.isValid());
                    if (component.isValid() && state == "SUCCESS") {
                        //component.set("v.carga", false);
                        console.log('ReturnValue--->',response.getReturnValue());
                        var genericResponse = response.getReturnValue()
                        if (genericResponse.success) {
                            console.log('genericResponse--->',genericResponse);
                            component.set("v."+nameWrapperDTO, genericResponse);

                            if (messageSuccess != null) {
                                toastEvent.setParams({
                                    "type": 'success',
                                    "message": messageSuccess,
                                    "mode":"sticky"
                                });
                                toastEvent.fire();
                            }

                        }
                        else {
                            toastEvent.setParams({
                                "type": 'error',
                                "message": genericResponse.errorMessage,
                                "mode":"sticky"
                            });
                            toastEvent.fire();
                         }


                    }
                    else {
                        toastEvent.setParams({
                            "type": 'error',
                            "message": genericResponse.errorMessage,
                            "mode":"sticky"
                         });
                         toastEvent.fire();
                    }

                    // component.set("v.isLoading", false);

                });
                $A.enqueueAction(action);
               // component.set("v.isLoading", false);
            }
})