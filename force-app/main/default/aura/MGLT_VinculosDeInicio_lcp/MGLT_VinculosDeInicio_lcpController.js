({
	handleClick : function(component, event, helper) {
		var idBoton = event.getSource().getLocalId();
		var url = '';
		switch (idBoton) {
			case '1':
				var idEncuesta = $A.get("$Label.c.MGLT_IdInformeClientes_lbl");
				url = '/'+idEncuesta;
				break;
			case '2':
				url ='/apex/COM_PAF_Calculadora_pag';
				break;
			case '3':
				url = '/apex/COM_PAF_ConsultarCliente_pag';
				break;
			case '4':
				url = '/apex/COM_ConsultarDocOnBase_pag';
				break;
			case '5':
				url = '/lightning/settings/personal/UnresolvedItemsSetup/home';
				break;
			default:
				break;
		}

		if(url != ''){
			console.log('URL : '+url);
			helper.goToURL(url);
		}
	}
})