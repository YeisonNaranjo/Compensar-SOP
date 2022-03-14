({
    /**
	 * Map of pre-chat field label to pre-chat field name (can be found in Setup)
	 */
     fieldLabelToName: {
        "Nombre": "FirstName",
        "Apellidos": "LastName",         
        "Consulta": "MGLT_Consulta__c",
        "Nombre completo": "Name",
        "Tipo Identificación" : "MGLT_Tipo_Identificacion_Chat__c",
        "Número de identificación" : "COM_Numeroidentificacion__c",
        "Teléfono": "Phone",
        "Correo electrónico": "Email",
        "Autorizo envío de campañas publicitarias": "MGLT_AutorizacionCampanas__c",
    },
    
    /**
	 * Event which fires the function to start a chat request (by accessing the chat API component)
	 *
	 * @param cmp - The component for this state.
	 */
    onStartButtonClick: function(cmp) {
        /*var lc = new Date();
        var isbhour = this.isBusinessHour2(lc);
        console.log('browserDatehlp: '+lc);
        console.log('isBusinessHourhlp: '+this.isBusinessHour(lc));
        console.log('isBusinessHourhlp: '+isBusinessHour(lc));
        console.log('isBusinessHourhlp: '+isbhour);
        if(isbhour){*/
            var prechatFieldComponents = cmp.find("prechatField");
            
            console.log("prechatFieldComponents ==> "+prechatFieldComponents);
            var fields;
            
            // Make an array of field objects for the library
            fields = this.createFieldsArray(prechatFieldComponents);
            console.log("fields ==> "+fields);

            // If the pre-chat fields pass validation, start a chat and
            if(cmp.find("prechatAPI").validateFields(fields).valid) {
                cmp.find("prechatAPI").startChat(fields);
            } else {
                console.warn("Prechat fields did not pass validation!");
            }
       /* }
        else
        {
            cmp.set("v.errorMessage", "Se encuentra fuera del horario de atención");
            cmp.set("v.validationSuccessful", false);
            console.warn("It is not business Hour");
            console.log("It is not business Hour");
        }*/
            
    },
    /**
	 * Validates Business hours when user opens chat
	 * Case:
	 * @param Browser Date.
	 * @returns True if it is between business hours, otherwise returns false.
	 */
    //"Nuestro horario de atención es:\A Lunes a viernes: 7:00 am - 6:00 pm,\A Sábados 8:00 am - 5:00 pm,\A Domingos y Festivos 10:00 am - 6:00 pm."; it works in UTC TimeZone
    isBusinessHour2: function(localdate) {
        console.log('isentered: localdate '+ localdate.getUTCDay());
        console.log('isentered: localdate.Hours '+ localdate.getUTCHours());
        switch(localdate.getUTCDay()){
            case 0 : //domingo
                if(localdate.getUTCHours() < 15 || localdate.getUTCHours() >23)
                {
                    console.log('IBH false');
                    return false;
                }
                break;
            case 1 : //Lunes
                if(localdate.getUTCHours() < 12 || localdate.getUTCHours() >23)
                {
                    console.log('IBH false');
                    return false;
                }
                break;
            case 2 : //Martes
                if(localdate.getUTCHours() < 12 || localdate.getUTCHours() >23)
                {
                    console.log('IBH false');
                    return false;
                }
                break;
            case 3 : //Miercoles
                if(localdate.getUTCHours() < 12 || localdate.getUTCHours() >23)
                {
                    console.log('IBH false');
                    return false;
                }
                break;
            case 4 : //Jueves
                if(localdate.getUTCHours() < 12  || localdate.getUTCHours() >23)
                {
                    console.log(' IBH false');
                    return false;
                }
                break;
            case 5 : //Viernes
                if(localdate.getUTCHours() < 12 || localdate.getUTCHours() >23)
                {
                    console.log('IBH false');
                    return false;
                }
                break;
            case 6 ://Sábado
                if(( localdate.getUTCHours() <13)|| localdate.getUTCHours() > 22)
                {
                    console.log('IBH false');
                    return false;
                }
                break;
            default:
                console.log('IBH True');
                return true;
                break;
        }
        console.log('IBH True');
        return true;
    },
    
    /**
	 * Create an array of field objects to start a chat from an array of pre-chat fields
	 * 
	 * @param fields - Array of pre-chat field Objects.
	 * @returns An array of field objects.
	 */
    createFieldsArray: function(fields) {
        if(fields.length) {
            return fields.map(function(fieldCmp) {
                console.log("fieldCmp ==> " +fieldCmp);
                return {
                    label: fieldCmp.get("v.label"),
                    value: fieldCmp.get("v.value"),
                    name: this.fieldLabelToName[fieldCmp.get("v.label")]
                };
            }.bind(this));
        } else {
            return [];
        }
    },
    
    
    /**
     * Create an array in the format $A.createComponents expects
     * 
     * Example:
     * [["componentType", {attributeName: "attributeValue", ...}]]
     * 
	 * @param prechatFields - Array of pre-chat field Objects.
	 * @returns Array that can be passed to $A.createComponents
     */
    getPrechatFieldAttributesArray1: function(prechatFields) {
        // $A.createComponents first parameter is an array of arrays. Each array contains the type of component being created, and an Object defining the attributes.
        var prechatFieldsInfoArray = [];
        
        // For each field, prepare the type and attributes to pass to $A.createComponents.
        prechatFields.forEach(function(field) {
            
            if(field.required){
                console.log("Type: "+field.type);
                console.log("Value: "+field.value);
                console.log("Label: "+field.label);
                var componentName;
                var strType=""; 
                if(field.type === "inputPhone"){
                    componentName = "input";
                    strType = "tel";
                }
                else if(field.type === "inputEmail"){
                    componentName = "input";
                    strType = "email";
                }
                else if(field.type === "inputSelect"){
                        componentName = "combobox";
                }else{
                            componentName = "input";
                            strType = "text";
                }
                console.log("componentName: "+componentName);
                console.log("strType: "+strType);
                var componentInfoArray = ["lightning:" + componentName];
                var attributes = {
                    "aura:id": "prechatField",
                    "required": field.required,
                    "label": field.label,
                    "maxlength": field.maxLength,
                    "disabled": field.readOnly,
                    "class": field.required ? field.className : "slds-hidden",
                    "value": field.value
                };
                
                // Special handling for options for an input:select (picklist) component.
                if(field.type === "inputSelect" && field.picklistOptions) attributes.options = field.picklistOptions;
                if(strType != "") attributes.type = strType; 
                // Append the attributes Object containing the required attributes to render this prechat field.
                componentInfoArray.push(attributes);
                console.log("componentInfoArray: "+componentInfoArray);
                // Append this componentInfoArray to the fieldAttributesArray.
                prechatFieldsInfoArray.push(componentInfoArray);
            }
        });
        
        
        var element = prechatFieldsInfoArray[7]; 
        prechatFieldsInfoArray.splice(7, 1); 
        prechatFieldsInfoArray.splice(0, 0, element);
        
        return prechatFieldsInfoArray;
    },
    
    /**
     * Check that First Name and Last Name are populated
     * 
     * @param @param cmp - The component for this state.
     */
    validateFields: function(component,event) {
        var MIG_CamposObligatorios = ' Por favor llene todos los campos.';
        var MIG_Terminos = 'Es necesario que autorice el uso de datos para continuar.';
        //Boolean variable to decide if all fields are populated or not
        var validationSuccessful = true;
        component.set("v.validationSuccessful", validationSuccessful);
        
        //Get all fields on the prechat form
        var prechatFieldComponents = component.find("prechatField");
        // Get value checkbox
        //var check = component.find("checkBox").get("v.value");
        var check = document.getElementById("checkBox").checked;
        console.log("checkvalidation2 ----- " + check);

        var nombreContactoField = '';
        var nombreField;
        var apellidosField;
        var telefonoField;
        
        //Loop through each field. Leave the email field.
        for(var i=0; i<prechatFieldComponents.length; i++){
            var pcField = prechatFieldComponents[i];
            
            if(pcField.get("v.label") === "Nombre")
                nombreField = pcField;
            if(pcField.get("v.label") === "Apellidos")
                apellidosField = pcField;
            if(pcField.get("v.label") === "Teléfono")
                telefonoField = pcField;
            
            if(pcField.get("v.required")===true){
                if(pcField.get("v.value")===null || pcField.get("v.value")==="" ){
                    validationSuccessful = false;
                }
            }
        }
        
        console.log('Nom2 : '+nombreField.get("v.value"));
        console.log('Nom 3: '+apellidosField.get("v.value"));
        console.log('Nom 4: '+telefonoField.get("v.value"));
        
       // nombreContactoField.set("v.value", nombreField.get("v.value")+ " " +apellidosField.get("v.value"));
        nombreContactoField = nombreField.get("v.value")+ " " +apellidosField.get("v.value");
        //console.log('nombreContactoField = '+nombreContactoField.get("v.value"));
        //If validation fails set the error message, else clear it.
        if(!validationSuccessful){
            
            component.set("v.errorMessage",  MIG_CamposObligatorios);
            //Set the validation attribute. This is used for showing the UI:Message
            component.set("v.validationSuccessful", validationSuccessful);
            return;
        }
        else{
            //Validate format fields
            //regex = /^[a-zA-Z ]+$/;
            regex = /^[ñA-Za-záéíóú _]*[ñA-Za-záéíóú][ñA-Za-záéíóú _]*$/;
            if(regex.test(nombreContactoField) == false){
                validationSuccessful = false;
                component.set("v.errorMessage", "Debe ingresar un nombre válido");
                component.set("v.validationSuccessful", validationSuccessful);
                return;
            }            
            var regex = /^\d+$/;
            console.log(regex.test(telefonoField.get("v.value")));
            if(regex.test(telefonoField.get("v.value")) == false){
                validationSuccessful = false;
                component.set("v.errorMessage", "Debe ingresar un teléfono válido");
                component.set("v.validationSuccessful", validationSuccessful);
                return;
            }
            //Validate Términos y condiciones
            if(check == false){
                validationSuccessful = false;
                component.set("v.errorMessage", MIG_Terminos);
                component.set("v.validationSuccessful", validationSuccessful);
                return;
            }
        }  
    }
});