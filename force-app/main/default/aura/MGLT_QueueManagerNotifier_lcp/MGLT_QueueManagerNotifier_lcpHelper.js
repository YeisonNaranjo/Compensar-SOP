({
    // Invokes the subscribe method on the empApi component
    subscribe : function(component, event, helper) {
        // Get the empApi component
        const empApi = component.find('empApi');
        // Get the channel name
        const channel = component.get('v.channelName');
        // Replay option to get new events
        const replayId = -1;

        // Subscribe to an event
        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            // Process event (this is called each time we receive an event)
            // console.log('Received event ', JSON.stringify(eventReceived));
            this.checkIfIsCurrentUser(component, event, helper, eventReceived);
        }))
        .then(subscription => {
            // Confirm that we have subscribed to the event channel.
            // We haven't received an event yet.
            // console.log('Subscribed to channel ', subscription.channel);
            // Save subscription to unsubscribe later
            component.set('v.subscription', subscription);
        });
    },

    // Invokes the unsubscribe method on the empApi component
    unsubscribe : function(component, event, helper) {
        // Get the empApi component
        const empApi = component.find('empApi');
        // Get the subscription that we saved when subscribing
        const subscription = component.get('v.subscription');

        // Unsubscribe from event
        empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
            // Confirm that we have unsubscribed from the event channel
            // console.log('Unsubscribed from channel '+ unsubscribed.subscription);
            component.set('v.subscription', null);
        }));
    },

    // Check if the platform event is for the current user
    checkIfIsCurrentUser : function(component, event, helper, eventReceived) {
        if (eventReceived && eventReceived.data && eventReceived.data.payload && eventReceived.data.payload.MGLT_IdUsuario__c &&
            eventReceived.data.payload.MGLT_IdUsuario__c === $A.get("$SObjectType.CurrentUser.Id")) {
            this.showMessage(component, event, helper);
        } else {
            // console.log("The received message is not for the current user");
        }
    },

    // Shows the notification message
    showMessage : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            "title": "",
            "message": $A.get("$Label.c.MGLT_GestorColasMensajeNotificacionAgente"),
            "type" : "warning"
        });
        toastEvent.fire();
    }
})