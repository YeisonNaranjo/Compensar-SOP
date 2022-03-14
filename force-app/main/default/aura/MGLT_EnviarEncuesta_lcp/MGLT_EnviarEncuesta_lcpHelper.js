({
	enviarEncuesta : function(component,event,helper) {
		var action = component.get("c.validarEncuesta");
		var nombreEncuesta = component.get("v.encuestaRecord.Name");
		var hlp = helper;
		console.log('--->>>EL NOMBRE DE LA ENCUESTA ES :'+nombreEncuesta);
		action.setParams({ strNomEncuesta: nombreEncuesta });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var res = response.getReturnValue();
				console.log('--->>>RESPUESTA DOINIT : ' + res.strMensaje);
				console.log('--->>>RESPUESTA strStatus : ' + res.strStatus);				
				hlp.showToast(res.strMensaje, res.strStatus);
				$A.get("e.force:closeQuickAction").fire();

			}
			else {
				console.log('Error en la respuesta del servidor.');
				$A.get("e.force:closeQuickAction").fire();
			}
		});
		$A.enqueueAction(action);

	},

	showToast: function (message, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"type": type,
			"message": message
		});
		toastEvent.fire();
	}
	
})