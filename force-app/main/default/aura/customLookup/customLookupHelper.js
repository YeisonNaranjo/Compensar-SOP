({
    keyPressController : function(component, event, helper,tipoLupa,filtro) {
        // get the search Input keyword  s
        console.log("ENTRO A HELPER keyPressController--->>>>");
        // var getInputkeyWord ;
        // if(tipoLupa=='RF2_Negocio__c'){
        //     getInputkeyWord = component.get('v.ValorLupa');
        // }else if(tipoLupa=='Programa'){
        //     getInputkeyWord = component.get('v.SearchKeyWordPrograma');              
        // }else if(tipoLupa=='Servicio'){
        //     getInputkeyWord = component.get('v.selectedServicio');             
        // }else if(tipoLupa=='Asunto'){
        //     getInputkeyWord = component.get('v.selectedAsunto');                
        // }else if(tipoLupa=='GIE'){
        //     getInputkeyWord = component.get('v.selectedGIE');                    
        // } 
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        var varSearch = event.target.value;
        if( tipoLupa.length > 0 ){
            console.log("ENTRO A IF tipoLupa porq tiene algo-.....");
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,varSearch,tipoLupa,filtro);
        }
        else{  
            /*component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
               */
            //component.set("v.SearchKeyWord", "ac");
            helper.searchHelper(component,event,varSearch,tipoLupa,filtro);
            // helper.keyPressController2(component, event, helper);
        }
            
        },
    searchHelper : function(component,event,getInputkeyWord,tipoLupa,filtro) {
        // call the apex class method 
        // alert('entro-->'+action);
        console.log("ENTRO A searchHelper---->>>");
        var action = component.get("c.obtenerQuery");
        action.setParams({strObjeto:tipoLupa,strFiltro:filtro,strSearchKeyWord:getInputkeyWord});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state valor: " , state);
            if (state === "SUCCESS") 
            {
                console.log("response---->>> " , response.getReturnValue());
                var storeResponse = response.getReturnValue();
                component.set("v.listOfSearchRecords",response.getReturnValue());
            }else{
                
            }
        });
        $A.enqueueAction(action);
    },
    defaultValuesWithFilter : function(component, event, helper,tipoLupa,filtro) {
        var getInputkeyWord ;
        console.log("ENTRO AL HELPER----->>>>");
        console.log("tipoLupa----->>>>",tipoLupa);
        console.log("filtro----->>>>",filtro);
        var forOpen = component.find("searchRes");
        console.log("forOpen...HELPER..",forOpen);
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        helper.searchHelper(component,event,component.get('v.ValorSearch'),tipoLupa,filtro);
        // var varValorCampo = component.get("v.campoCaso");
        // console.log("varValorCampo...",varValorCampo);
        // var compEvent = component.getEvent("valorMenu");
        // component.set("v.blnLanzoEvento",true);
        // compEvent.setParams({"valorCampo" : varValorCampo});
        // compEvent.fire();
    },

    // closeMenu: function(component, event, helper){
    //     var forOpen = component.find("searchRes");
    //     $A.util.removeClass(forOpen, 'slds-is-open');
    // },

    // eventoMenu: function(component, event, helper){
    //     alert('ENTRO A HANDLER EVENTO eventoMenu....');
    // },
    
    
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