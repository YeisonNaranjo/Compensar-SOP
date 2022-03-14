({
    // Sets an empApi error handler on component initialization
    onInit : function(component, event, helper) {
        // Get the empApi component
        const empApi = component.find('empApi');

        // Uncomment below line to enable debug logging (optional)
        empApi.setDebugFlag(false);

        // Register error listener and pass in the error handler function
        empApi.onError($A.getCallback(error => {
            // Error can be any type of error (subscribe, unsubscribe...)
            console.error('EMP API error: ', error);
            console.log('>>> Error Received : ' + JSON.stringify(error));
        }));

        // Get configured channel name
        let channelName = '/event/' + $A.get("$Label.c.MGLT_GestorColasNombreCanalNotificaciones");
        //console.log("channelName: " + channelName);
        component.set('v.channelName', channelName);

        // Subscribe
        helper.subscribe(component, event, helper);
    }
})