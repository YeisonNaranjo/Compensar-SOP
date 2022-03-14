/**
 * Created by cristianmosquera on 3/02/20.
 */
({
    doInit : function (component, event, helper) {
        helper.callGenericService(component, event, helper, 'c.getQueues', null, null, 'queueResponseDTO');
    }
})