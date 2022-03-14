/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */
 export function reduceErrors(errors) {
    return (
        // ensure errors is an array
        []
            .concat(errors)
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API read errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // UI API DML, Apex and network errors
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                // JS errors
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr) => prev.concat(curr), [])
            // Remove empty strings
            .filter((message) => !!message)
    );
}

export function validateFields(element){
    let validate = false;
    const isInputsCorrect = [...element.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

    const isCombobox = [...element.querySelectorAll('lightning-combobox')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

    const isTextArea = [...element.querySelectorAll('lightning-textarea')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

    if(isInputsCorrect && isCombobox && isTextArea){
        validate = true;
    }

    return validate;
}

export function filterList(obj, str){
    let newObj = [];
    for (var i = 0; i < obj.length; i++) {
        if(obj[i].lista.includes(str)){
            newObj = [...newObj, { value: obj[i].value, label: obj[i].label }];
        }
    }
    return newObj;
}

export function filterMap(obj, str){
    let newObj = [];
    if(obj[str]){
        for (var i = 0; i < obj[str].length; i++) {
            newObj = [...newObj, { value: obj[str][i].value, label: obj[str][i].label }]
        }
    }
    return newObj;
}

export function isURL(str) {
    const pattern = new RegExp('^(https?:\\/\\/)?'+ 
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ 
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ 
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ 
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ 
        '(\\#[-a-z\\d_]*)?$','i'); 
    return !!pattern.test(str);
}

export function removeClasses(elements) {  
    for (var i = 0; i < elements.length; i++) {
        elements[i].removeAttribute('class');
    }
}