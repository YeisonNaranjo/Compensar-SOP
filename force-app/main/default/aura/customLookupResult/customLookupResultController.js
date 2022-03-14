({
	 selectAccount : function(component, event, helper){      
    // get the selected Account from list
      var varCampoCaso = component.get("v.CampoCaso");
      console.log("varCampoCaso....",varCampoCaso);
      var getSelectAccount = component.get("v.oAccount");
      console.log("getSelectAccount---->>>",getSelectAccount);
      var getLupaTipo = component.get("v.lupaTipo");

    // call the event   
      var compEvent = component.getEvent("oSelectedAccountEvent");
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"accountByEvent" : getSelectAccount,"lupaTipo": getLupaTipo,"CampoCaso":varCampoCaso}); 
         
    // fire the event  
         compEvent.fire();
    },
})