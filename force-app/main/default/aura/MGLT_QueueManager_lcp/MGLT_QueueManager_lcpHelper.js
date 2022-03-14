({
    openModal : function(component, response) {
        // console.log("openModal");

        if (response.panelVisible) {
            this.setModalMode(component, true);
            this.disableUtilityPopOut(component);
            component.find('queueManager').refreshAgentList();
        }
    },

    setModalMode : function(component, modalMode) {
        // console.log("setModalMode");

        var utilityBarAPI = component.find("QueueManagerUtilityBar");
        utilityBarAPI.toggleModalMode({
            enableModalMode: modalMode
        }).then(function(result) {
            // console.log("Resultado de setModalMode: " + result);
        }).catch(function(error) {
            console.log('Error en setModalMode: ' + JSON.stringify(error));
        });
    },

    disableUtilityPopOut : function(component) {
        // console.log("disableUtilityPopOut");

        var utilityBarAPI = component.find("QueueManagerUtilityBar");
        utilityBarAPI.disableUtilityPopOut({
            disabled:           true,
            disabledText:       ''
        }).then(function(result) {
            // console.log("Resultado de disableUtilityPopOut: " + result);
        }).catch(function(error) {
            console.log('Error en disableUtilityPopOut: ' + JSON.stringify(error));
        });
    }
})