({
	doInit : function(component, event, helper) {

        helper.validarDevice(component, event, helper);
	},
	handleClick: function (component, event, helper) {
		helper.getDocuments(component, event, helper);
	},
    handleClickReafiliacion: function (component, event, helper) {
		component.set("v.blnShowDivReafiliacion",true);
	},
    handleClickTipificacion1: function (component, event, helper) {
		component.set("v.blnShowTipificacion1",true);
	},
	handleClickTipificacion2: function (component, event, helper) {
		component.set("v.blnShowTipificacion2",true);
	},
	handleClickTipificacion3: function (component, event, helper) {
		component.set("v.blnShowTipificacion3",true);
	},    
    handleComponentEvent: function (component, event, helper) {
		component.set("v.blnShowDivReafiliacion",false);
		component.set("v.blnShowTipificacion1",false);
		component.set("v.blnShowTipificacion2",false);
		component.set("v.blnShowTipificacion3",false);
	}    
})