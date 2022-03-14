({
    doInit : function(component, event, helper) {
        // console.log("doInit");

        var utilityBarAPI = component.find("QueueManagerUtilityBar");
        utilityBarAPI.getAllUtilityInfo().then(function (response) {
            if (typeof response !== 'undefined') {
                var eventHandler = function(response) {
                    helper.openModal(component, response);
                };

                utilityBarAPI.onUtilityClick({
                    eventHandler: eventHandler
                }).then(function(result) {
                    // console.log("Resultado de la inicialización del handler: " + result);
                }).catch(function(error) {
                    console.log('Error al inicializar el handler para el gestor de colas: ' + JSON.stringify(error));
                });
            } else {
                console.log('Error al cargar la barra de utilidades para el gestor de colas');
            }
        });
    },

    cancel : function(component, event, helper) {
        // console.log("cancel");

        var utilityBarAPI = component.find("QueueManagerUtilityBar");
        utilityBarAPI.minimizeUtility();
    }
})