({
    /**
     * On initialization of this component, set the prechatFields attribute and render pre-chat fields.
     * 
     * @param cmp - The component for this state.
     * @param evt - The Aura event.
     * @param hlp - The helper for this state.
     */
    onInit: function(cmp, evt, hlp) {
        var lc = new Date();
        var isbhour = hlp.isBusinessHour2(lc);
        console.log('browserDatectr: '+lc);
        console.log('isBusinessHourctr: '+isbhour);
        cmp.set("v.bhour", isbhour);
        
        // Get pre-chat fields defined in setup using the prechatAPI component
            var prechatFields = cmp.find("prechatAPI").getPrechatFields();
            // Get pre-chat field types and attributes to be rendered
            var prechatFieldComponentsArray = hlp.getPrechatFieldAttributesArray1(prechatFields);
             
            console.log("Campos del Fomulario: "+prechatFieldComponentsArray);
            // Make asynchronous Aura call to create pre-chat field components
            // 
            var lc = new Date();
            var isbhour = hlp.isBusinessHour2(lc);
            
            console.log('browserDatectr: '+lc);
            console.log('isBusinessHourctr: '+isbhour);
        if(isbhour){
            $A.createComponents(
                prechatFieldComponentsArray,
                function(components, status, errorMessage) {
                    console.log('Estado: '+status);
                    console.log('errorMessage: '+errorMessage);
                    
                    if(status === "SUCCESS") {
                        cmp.set("v.prechatFieldComponents", components);
                        console.log("Formulario: "+components);
                    }
                }
            );            
        }
    },
    
    /**
     * Event which fires when start button is clicked in pre-chat
     * 
     * @param cmp - The component for this state.
     * @param evt - The Aura event.
     * @param hlp - The helper for this state.
     */
    handleStartButtonClick: function(cmp, evt, hlp) {
       
        //Validate that all required fields are populated
        hlp.validateFields(cmp, evt);
        //If validation is successful, then call the standard prechat validation 
        if(cmp.get("v.validationSuccessful") ){
            hlp.onStartButtonClick(cmp);
            
        }      
    },
    
    handleCheck : function(component, event, helper) {
        //var check = component.find("checkBox").get("v.value");

        var check = document.getElementById("checkBox").checked;

        component.set("v.checkbox", check);
        console.log("checked: LIGHTNING2" + check);
    },
    
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        alert('thanks for like Us :)');
        component.set("v.isOpen", false);
    }
});