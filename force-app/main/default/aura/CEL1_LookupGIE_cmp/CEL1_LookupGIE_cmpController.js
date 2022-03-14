({
    buscarCampos : function(component, event, helper) {
        console.log("entro a buscarCampos---->>>>");
        var varIdCaso = component.get("v.recordId");
        var action = component.get("c.lupasTipificacionGIE");
        action.setParams({strIdCaso:varIdCaso});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state valor: " , state);
            if (state === "SUCCESS") 
            {
                console.log("response---->>> " , response.getReturnValue());
                console.log("response--lstTipificacionGIE-->>> " , response.getReturnValue().lstTipificacionGIE);
                console.log("response--objcase-->>> " , response.getReturnValue().objCaso);
                // component.set("v.ListCamposLupaGIE",response.getReturnValue().lstTipificacionGIE);
                component.set("v.ListCamposLupaGIE",response.getReturnValue().lstTipificacionGIE);
                component.set("v.ListCamposLupaBackup",response.getReturnValue().lstTipificacionGIE);
            }else{
                
            }
        });
        $A.enqueueAction(action);
    },
    handleCmpEvent : function(component, event, helper) {
        
        // get the selected Account record from the COMPONETN event
        console.log("ENTRO A LA FUNCION handleCmpEvent");	 
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");
        var lupaTipo 					= event.getParam("lupaTipo");
        var CampoCaso 					= event.getParam("CampoCaso");
        component.set("v.valorObjeto",selectedAccountGetFromEvent);
        var varLst = component.get("v.ListCamposLupaGIE");
        console.log('varLst-->',varLst);
        console.log('lupaTipo-->',lupaTipo);
        var varFind = component.find("idFiltro");
        
        // console.log("varId--Array-->>>",varFind);
        // console.log("varFind.length-->>>",varFind.length);
        var varListUpdate = [];
        for(var i = 0; i < varFind.length; i++){

            console.log('thing-->', varFind[i]);
            //console.log('thisEvent-->'+thisEvent);
            varFind[i].enviarFiltro(component.get("v.valorObjeto"),false);
        }

        var varLstBackup = component.get("v.ListCamposLupaBackup");
        varLstBackup.push(varLst);
        console.log("varLstBackup....",varLstBackup);
        for(var i = 0; i < varLst.length; i++)
        {
            console.log("varLst[i].strCampoCaso...",varLst[i].strCampoCaso);
            if(varLst[i].strCampoCaso == CampoCaso){
                console.log("ENTRO A IF CAMPO CASO...");
                varLst[i].strValorLupa = selectedAccountGetFromEvent.Id;
            }
        }
        console.log("v.ListCamposLupaBackup....DESPUES DE LLENAR",component.get("v.ListCamposLupaGIE"));
        // Console.log("varListUpdate....",varListUpdate);
        // component.set("v.ListCamposLupaGIE",varListUpdate);
        // var varArray = [CampoCaso,selectedAccountGetFromEvent.Id];
        // console.log("varArray.....",varArray);
        // component.set("v.ListCamposLupaBackup",varArray);
        // for(var cmp in varFind){
            //     cmp.enviarFiltro(component.get("v.valorObjeto"));
            // }
            // varFind.forEach(element => console.log("element.....",element));
        for(var i = 0; i < varLst.length; i++){
            console.log("lo varLst[i].Id....."+varLst[i].strId);
           var varId = component.find(varLst[i].strId);
            
            console.log("lo encontre.....",varId);
            //var objCompB = component.find(varLst[i].strNombre);
            //console.log("objCompB....",objCompB);
            // console.log("objFind....",objFind);
            // objCompB.enviarFiltro(component.get("v.valorObjeto"));
       }

        
    },

    ocultarMenu: function(component, event, helper){
        console.log("ENTRO A EVENTO MENU PAPA.....");
        var varLst = component.get("v.ListCamposLupaGIE");
        console.log('varLst-GIE->',varLst);
        var varValorCampo = event.getParam("valorCampo");
        console.log("llego al papa el campo....",varValorCampo);
        component.set("v.valorMenu",varValorCampo);
        for(var i = 0; i < varLst.length; i++){
            if(varLst[i].strCampoCaso == varValorCampo){
                console.log("ENTRO A IF CAMPO CASO...");
                varLst[i].strValorLupa = '';
            }
        }

        var varLst2 = component.get("v.ListCamposLupaGIE");
        console.log('varLst2-GIE->',varLst2);

    },
    

    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");
    },

    // handleEnventStrike: function(component,event,helper){
    //     var datoEvent = event.getParam("data");
    //     console.log("datoEvent---->>>>",datoEvent);
    // },

    cerrarVentana : function(component, event, helper) {
        var compEvent = component.getEvent("cerrarModal");  
       compEvent.fire();
       helper.fireRefresh(component, event, helper);
       var a = component.get("c.buscarCampos");
       $A.enqueueAction(a);
   },

   guardarCampos: function(component,event,helper){
        var varNombres = component.get("v.ListCamposLupaGIE");
        console.log("varNombres--->>>",varNombres);
        //console.log("varNombres.length--->>>",varNombres.length);
        var varRecord = component.get("v.recordId");
        console.log('varRecord---->>>>'+varRecord);



        var actionGuardar = component.get("c.guardarGIE");
        actionGuardar.setParams({lstValores:varNombres,strIdCaso:varRecord});
        actionGuardar.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state valor: " , state);
            if (state === "SUCCESS") 
            {
                console.log("response---->>> " , response.getReturnValue().blnRespuesta);
                console.log("response---->>> " , response.getReturnValue().strMensaje);
                var varRespuestaG = response.getReturnValue().blnRespuesta;
                var varMensaje = response.getReturnValue().strMensaje;
                if(varRespuestaG){

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "mode" : 'dismissible',
                    "title": 'Su registro se ha guardado exitosamente',
                    "message": varMensaje,
                    "key": 'info_alt',
                    "type": 'SUCCESS',
                    "duration":1000
                    });
                    toastEvent.fire();
                    var compEvent = component.getEvent("cerrarModal"); 
                    compEvent.fire();
                    $A.get('e.force:refreshView').fire(); 
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "mode" : 'dismissible',
                    "title": 'Error',
                    "message": varMensaje,
                    "key": 'info_alt',
                    "type": 'Error',
                    "duration":1000
                    });
                    toastEvent.fire();
                }
                // component.set("v.ListCamposLupa",response.getReturnValue().);
                
            }else{
                
            }
        });
        $A.enqueueAction(actionGuardar);

   }
})