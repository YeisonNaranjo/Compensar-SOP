({
    fireRefresh  : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
        console.log("Triggered Sucessfully")
    }
})