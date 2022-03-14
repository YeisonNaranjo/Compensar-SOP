({  
    doInit: function(component,event,helper){
        console.log("v.selectedNegocio....",component.get("v.selectedNegocio"));
        var varSelected = component.get("v.selectedNegocio");
        // component.set("v.selectedNegocio",component.get("v.selectedNegocio"));
        if(varSelected !=null && varSelected != ''){
            var forcloseNeg = component.find("lookup-pill");
            $A.util.addClass(forcloseNeg, 'slds-show');
            $A.util.removeClass(forcloseNeg, 'slds-hide');
            
            
            forcloseNeg = component.find("searchRes");
            $A.util.addClass(forcloseNeg, 'slds-is-close');
            $A.util.removeClass(forcloseNeg, 'slds-is-open');
            
            var lookUpTargetNeg = component.find("lookupField");
            $A.util.addClass(lookUpTargetNeg, 'slds-hide');
            $A.util.removeClass(lookUpTargetNeg, 'slds-show');
        }
    },
    cerrarVentana : function(component, event, helper) {
		 var compEvent = component.getEvent("cerrarModal");  
        compEvent.fire();
    },

    eventoMenu: function(component, event, helper){
        // alert('ENTRO A HANDLER EVENTO eventoMenu....');
        console.log("ENTRO A EVENTO MENU HIJO.....");
        // var varLst = component.get("v.ListCamposLupa");
        // console.log('varLst-HIJO->',varLst);
        var varCampoCaso = component.get("v.campoCaso");
        var varBLN = component.get("v.campoVariableMenu");
        console.log("varBLN....",varBLN);
        console.log("varCampoCaso..HIJO..",varCampoCaso);
        var forOpen = component.find("searchRes");
        if(varBLN!=varCampoCaso){
            $A.util.removeClass(forOpen, 'slds-is-open');
            $A.util.addClass(forOpen, 'slds-is-close');
        }
        // for(var i = 0; i < varLst.length; i++)
        // {
        //     console.log("varLst[i].strCampoCaso.HIJO..",varLst[i].strCampoCaso);
        //     console.log("varLst[i].blnValorMenu..HIJO.",varLst[i].blnValorMenu);
        //     if(!varLst[i].blnValorMenu){
        //         console.log("ENTRO A IF PARA OCULTAR MENU....");
        //         console.log("forOpen....", JSON.stringify(forOpen));
        //         $A.util.removeClass(forOpen, 'slds-is-open');
        //         $A.util.addClass(forOpen, 'slds-is-close');
        //         // var forcloseNeg = component.find("lookup-pill");
        //         // $A.util.addClass(forcloseNeg, 'slds-show');
        //         // $A.util.removeClass(forcloseNeg, 'slds-hide');
        //         // var lookUpTargetNeg = component.find("lookupField");
        //         // $A.util.addClass(lookUpTargetNeg, 'slds-hide');
        //         // $A.util.removeClass(lookUpTargetNeg, 'slds-show');
        //     }
        // }
    },

   actualizarCaso : function(component, event, helper) {
		 helper.showToast('EL caso ha sido tipificado exitosamente...','success',"Por favor espere!");
    }, 
    
    
    
    defaultValuesNegocio: function(component, event, helper) {
        console.log("defaultValuesNegocio---->>>");
        var varListaIterar = component.get("v.ListCamposLupa");
        console.log("varListaIterar---->>>",varListaIterar);
        var varObject = component.get("v.selectedNegocio");
        var varCampoFiltro = component.get("v.filtro");
        var varobjPadre = component.get("v.objetoPadre");
        var varFiltroComplemento = component.get("v.filtroComplementario");
        var varselected = component.get("v.valorObjeto");
        var varFiltrar;
        var miMapa = new Map();
        console.log("varCampoFiltro--->>>",varCampoFiltro);
        console.log("varObject--->>>",varObject.Id);
        for(var i = 0; i < varListaIterar.length; i++){
            miMapa.set(varListaIterar[i].strObjeto,varListaIterar[i].strValorLupa);
        }
        console.log("miMapa............",miMapa);
        console.log("varobjPadre............",varobjPadre);
        
        console.log("miMapa.get(varobjPadre)....",miMapa.get(varobjPadre));
        if(miMapa.get(varobjPadre) != undefined && varCampoFiltro != undefined && varFiltroComplemento == undefined){
            console.log("ENTRO PRIMER IF.....");
            varFiltrar = varCampoFiltro + "=" + "'" + miMapa.get(varobjPadre) + "'";
            console.log("varFiltrar for...",varFiltrar);
        }
        
        if(miMapa.get(varobjPadre) != undefined && varCampoFiltro != undefined && varFiltroComplemento != undefined){
            console.log("ENTRO SEGUNDO IF.....");
            // varFiltrar = varCampoFiltro + "=" + "'" + miMapa.get(varobjPadre) + "'";
            varFiltrar = varCampoFiltro + "="+ "'" +miMapa.get(varobjPadre)+"'"+" AND "+ varFiltroComplemento + "=TRUE";
            console.log("varFiltrar for...",varFiltrar);
        }
        console.log("registro evento......");
        var varValorCampo = component.get("v.campoCaso");
        console.log("varValorCampo...",varValorCampo);
        var compEvent = component.getEvent("valorMenu");
        component.set("v.blnLanzoEvento",true);
        compEvent.setParams({"valorCampo" : varValorCampo});
        compEvent.fire();

        // console.log("miMapa--->>>",miMapa);
        console.log("varFiltrar---->>>",varFiltrar);
        
        component.set("v.currentLupa",component.get("v.Label"));
        helper.defaultValuesWithFilter(component, event, helper,component.get("v.ObjetoSeleccionado"),varFiltrar);
        component.set("v.valorObjeto",null);
    },

    classOnblur:function(component, event, helper){
        console.log("entro a onblur....");
        var forOpen = component.find("searchRes");
        $A.util.removeClass(forOpen, 'slds-is-open');
        $A.util.addClass(forOpen, 'slds-is-close');
    },

    handleValueChange: function(component,event,helper){
        console.log("ENTRO A handleValueChange.....");
        var varEventValue = event.getParam("value");
        console.log("varEventValue---->>>",varEventValue);
        var varEventOldValue = event.getParam("oldValue");
        console.log("varEventOldValue---->>>",varEventOldValue);
    },
    
    KeyPressPrograma: function(component, event, helper) {
        // var tipoLupa='Programa';
        var myEvent = $A.get("e.yournamespace:KeyPressPrograma");
        console.log("myEvent....",myEvent);
        var varSerach = component.get("v.ValorSearch");
        console.log("varSerach--->>>>",varSerach);
        console.log("ENTRO POR KeyPressPrograma.....");
        var KEYCODE_ENTER = 13;
        var KEYCODE_UP = 80;
        var KEYCODE_DOWN = 40;
        var KEYCODE_TAB = 9;
        var KEYCODE_shift = 16;

        var keyCode = event.which || event.keyCode || 0;
        console.log("keyCode---->>>>",keyCode);
        if(keyCode === KEYCODE_shift){
            console.log("ENTRO A LA TECLA SHIFT....");
            var forOpen = component.find("searchRes");
            $A.util.removeClass(forOpen, 'slds-is-open');
            $A.util.addClass(forOpen, 'slds-is-close');
        }
        if(keyCode === KEYCODE_ENTER){
            console.log("entro por el enter");
            
        }else{

            if(keyCode === KEYCODE_TAB){
                console.log("ENTRO A IF DE KeyPressPrograma.....");
                var a = component.get("c.defaultValuesNegocio"); 
                $A.enqueueAction(a);
            }else{
                var varListaIterar = component.get("v.ListCamposLupa");
                console.log("varListaIterar---->>>",varListaIterar);
                var varCampoFiltro = component.get("v.filtro");
                var varobjPadre = component.get("v.objetoPadre");
                var varFiltroComplemento = component.get("v.filtroComplementario");
                var varselected = component.get("v.valorObjeto");
                var varFiltrar;
                var miMapa = new Map();
                console.log("varCampoFiltro--->>>",varCampoFiltro);
                for(var i = 0; i < varListaIterar.length; i++){
                    miMapa.set(varListaIterar[i].strObjeto,varListaIterar[i].strValorLupa);
                }
                console.log("miMapa............",miMapa);
                console.log("varobjPadre............",varobjPadre);
                
                console.log("miMapa.get(varobjPadre)....",miMapa.get(varobjPadre));
                if(miMapa.get(varobjPadre) != undefined && varCampoFiltro != undefined && varFiltroComplemento == undefined){
                    console.log("ENTRO PRIMER IF.....");
                    varFiltrar = varCampoFiltro + "=" + "'" + miMapa.get(varobjPadre) + "'";
                    console.log("varFiltrar for...",varFiltrar);
                }
                
                if(miMapa.get(varobjPadre) != undefined && varCampoFiltro != undefined && varFiltroComplemento != undefined){
                    console.log("ENTRO SEGUNDO IF.....");
                    // varFiltrar = varCampoFiltro + "=" + "'" + miMapa.get(varobjPadre) + "'";
                    varFiltrar = varCampoFiltro + "="+ "'" +miMapa.get(varobjPadre)+"'"+" AND "+ varFiltroComplemento + "=TRUE";
                    console.log("varFiltrar for...",varFiltrar);
                }
                
                var filtro  = component.get("v.filtro");
                component.set("v.currentLupa",component.get("v.ObjetoSeleccionado"));
                helper.keyPressController(component, event, helper,component.get("v.ObjetoSeleccionado"),varFiltrar);
            }
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){

        var varclear = component.find('lookupField');
        console.log("varclear--->>>",varclear);
        for(var i = 0; i < varclear.length; i++){
            console.log('thing-->', varclear[i]);
        }
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.ValorSearch", null );

        var varValorCampo = component.get("v.campoCaso");
        console.log("varValorCampo...",varValorCampo);
        var compEvent = component.getEvent("valorMenu");
        component.set("v.blnLanzoEvento",true);
        compEvent.setParams({"valorCampo" : varValorCampo});
        compEvent.fire();
        
    },

   
    tomarFiltro : function(component, event, helper){
        
        //alert('Invocacion desde mi abuelito');
        
        var params = event.getParam('arguments');
        console.log("params--->>>",params);
        var paramFiltro ;
        var blnDisabled ;
        var strTipoLupa ;
        if (params) {
            paramFiltro = params.paramFiltro;
            blnDisabled = params.blnDisabled2;
            //alert('Invocacion desde mi abuelito');
            
            console.log("blnDisabled--->>>",blnDisabled);
            component.set("v.valorObjeto",paramFiltro);
            component.set("v.blnDisabled",blnDisabled);
            console.log("valor v.valorObjeto---->>>>",component.get("v.valorObjeto"));
        }
        var valornuevo = component.get("v.valorObjeto");
        console.log("valornuevo-.--->>>",valornuevo.Id);
       
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");
        var lupaTipo 					= event.getParam("lupaTipo");
        // component.set("v.valorObjeto",selectedAccountGetFromEvent);
         var varLupa = component.get("v.valorObjeto");
        console.log('-valorObjeto-Papa->', lupaTipo)
        //  component.set("v.ValorLupa",varLupa.Id);
        component.set("v.selectedNegocio",selectedAccountGetFromEvent);
        var forcloseNeg = component.find("lookup-pill");
        $A.util.addClass(forcloseNeg, 'slds-show');
        $A.util.removeClass(forcloseNeg, 'slds-hide');
        
        
        forcloseNeg = component.find("searchRes");
        $A.util.addClass(forcloseNeg, 'slds-is-close');
        $A.util.removeClass(forcloseNeg, 'slds-is-open');
        
        var lookUpTargetNeg = component.find("lookupField");
        $A.util.addClass(lookUpTargetNeg, 'slds-hide');
        $A.util.removeClass(lookUpTargetNeg, 'slds-show');  

                
    },
    // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var tipoLupa = component.get("v.currentLupa");
			if(tipoLupa=='Negocio'){
				var spinner = component.find('spinner');
            }else if(tipoLupa=='Programa'){
               var spinner = component.find('spinnerProg');              
            }else if(tipoLupa=='Servicio'){
               	var spinner = component.find('spinnerServ');             
            }else if(tipoLupa=='Asunto'){
             	var spinner = component.find('spinnerAsunt');                
            }else if(tipoLupa=='GIE'){
          		var spinner = component.find('spinnerGIE');                    
            } 
        
         var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
    // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var tipoLupa = component.get("v.currentLupa");
			if(tipoLupa=='Negocio'){
				var spinner = component.find('spinner');
            }else if(tipoLupa=='Programa'){
               var spinner = component.find('spinnerProg');              
            }else if(tipoLupa=='Servicio'){
               	var spinner = component.find('spinnerServ');             
            }else if(tipoLupa=='Asunto'){
             	var spinner = component.find('spinnerAsunt');                
            }else if(tipoLupa=='GIE'){
          		var spinner = component.find('spinnerGIE');                    
            } 
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
})