import { LightningElement, wire, api, track } from 'lwc';
import { reduceErrors, validateFields, isURL, removeClasses } from 'c/rl2_Utilities';

import getSubsidios from '@salesforce/apex/RL2_Subsidio_ctr.getSubsidios';
import getServicioRelacionado from '@salesforce/apex/RL2_Subsidio_ctr.getServicioRelacionado';
import saveSubsidioFiles from '@salesforce/apex/RL2_Subsidio_ctr.saveSubsidioFiles';
import getRequisitos from '@salesforce/apex/RL2_Subsidio_ctr.getRequisitos';
import getPickListInfo from '@salesforce/apex/RL2_Subsidio_ctr.getPickListInfo';

import getCheckBoxInfo from '@salesforce/apex/RL2_Subsidio_ctr.getCheckBoxInfo';
import getTipoDocumentos from '@salesforce/apex/RL2_Subsidio_ctr.getTipoDocumentos';
import getMediosRespuesta from '@salesforce/apex/RL2_Subsidio_ctr.getMediosRespuesta';


import MATRIZ_SUBSIDIO_OBJECT from '@salesforce/schema/RL2_MatrizParametrizacionSubsidio__c';
import SUBSIDIOS_FIELD_OBJECT from '@salesforce/schema/RL2_MatrizParametrizacionSubsidio__c.RL2_Subsidios__c';

import CASE_OBJECT from '@salesforce/schema/Case';
import DECRETO_FIELD_OBJECT from '@salesforce/schema/Case.RL2_NormativaSubsidios__c';
import RESPUESTA_FIELD_OBJECT from '@salesforce/schema/Case.RF2_MedioRespuesta__c';

//Custom Label
import tipoSolicitud from '@salesforce/label/c.RL2_SolicitudPSB';
import vSmallDevice from '@salesforce/label/c.RL2_SmallDevice';
import vFormularioWeb from '@salesforce/label/c.RL2_FormularioWeb_lbl';
import vFormularioViabilidad from '@salesforce/label/c.RL2_FormularioSolicitudViabilidad_lbl';
import vFormularioRadicacion from '@salesforce/label/c.RL2_FormularioRadicacionDocumentos_lbl';
import vLabelVImposibilidad from '@salesforce/label/c.RL2_ImposibilidadSubsidio_lbl';
import vLabelImposibilidad from '@salesforce/label/c.RL2_LabelImposibilidad_lbl';

import vLabelEnvioEmail from '@salesforce/label/c.RL2_AutorizaEnvioCorreoElectronico_lbl';
import vLabelEnvioTexto from '@salesforce/label/c.RL2_AutorizaEnvioSMS_lbl';

//Get FormFactor
import FORM_FACTOR from '@salesforce/client/formFactor';

const CASE = { 'sobjectType': 'Case' };
const CONTAINER_HTML = `<b>Requisitos para la solicitud</b>`;

export default class Rl2_Subsidio_lwc extends LightningElement {

    @track lstTipoDocumentos = [];
    @track lstMedios = [];
    @track lstDecretos = [];
    @track lstRespuestas = [];

    @track lstSubsidios = [];
    @track lstServicios = [];
    @track lstRelacionadoCon = [];

    @track activo = false;
    @track temp = 0;
    @track filesUploaded = [];
    @track fileName = '';

    /*** Boolean ***/
    @track isParent = true;
    @track showDependencies = false;

    @track rSubsidio;
    @track vRelacionadoCon;
    @track vTipoServicio = '';

    @track vRow;
    @track vRSuperior;    

    vNoDisplayAttachments = true;

    showFormulario = false;
    isLoading = false;
    firstLoading = true;
    isFirstLoad = true;
    showSuccess = false;
    showAnonimo = true;

    showModalLimpiar = false;
    showModalEnviar = false;

    showModalViable = false;
    showModalRadicacion = false;

    showfooter = true;
    showHeader = true;

    showButtonPositive = true;
    showButtonNegative = true;

    showError = false;
    showDecreto = false;
    showImposibilidad = false;
    showDocumentos = true;
    showFechaIngreso = false;
    showArriendo = false;
    showViable = false;
    showRadicacion = false;

    vDisabled = false;
    caseId;
    numeroCaso = '';

    /*** Cliente ***/
    tipoIdentificacion = '';    
    nIdentificacion = '';
    /*** End Cliente ***/

    /*** Contacto ***/
    
    nombreContacto = '';
    emailContacto = '';
    
    telefono = '';
    celular = '';

    /*** End Contacto ***/


    /*** Solicitud ***/
    vDecreto = '';
    medioRespuesta = '';
    description = '';
    autoriza = false;
    aceptaPolitica = false;
    documentosSoporte = '';
    /*** End Cliente ***/

    //Files
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 3145728;
    errorMessage = '';
    errorMedio = '';
    //End Files

    vLoad = false;
    vNoAplica = 'No aplica';
    fechaIngreso;
    vTitleRequisito = '';   

    @wire(getSubsidios, {vObj : MATRIZ_SUBSIDIO_OBJECT.objectApiName, vField : SUBSIDIOS_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getListaSubsidios({ error, data }) {
        if (data) {
            this.lstSubsidios = data.lstSubsidios;
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPickListInfo, {vObject : CASE_OBJECT.objectApiName, vField : DECRETO_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getDecretos({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstDecretos = [...this.lstDecretos, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPickListInfo, {vObject : CASE_OBJECT.objectApiName, vField : RESPUESTA_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getListRespuestas({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                if(data[i].val == vLabelVImposibilidad){
                    this.lstRespuestas = [...this.lstRespuestas, { value: data[i].val, label: vLabelImposibilidad }];
                }
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getTipoDocumentos)
    getListaTipoDocumentos({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstTipoDocumentos = [...this.lstTipoDocumentos, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getMediosRespuesta)
    getMedios({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstMedios = [...this.lstMedios, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    get options() {
        return this.lstTipoDocumentos;
    }


    get optionsMedio(){
        return (this.showImposibilidad) ? this.lstRespuestas : this.lstMedios;
    }

    get optionsDecreto(){
        return this.lstDecretos;
    }

    get todaysDate() {
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0');
        let yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        return today;
    }

    get vCasoObject(){
        return {
            solicitud : tipoSolicitud, 
            subsidio: this.rSubsidio, 
            relacionado: this.vRelacionadoCon, 
            servicio: this.vTipoServicio
        };
    }

    get envioRespuesta(){
        return (this.showImposibilidad) ? vLabelEnvioTexto : vLabelEnvioEmail;
    }

    /*** Button Modals ***/

    handleCloseLimpiar(){
        this.showModalLimpiar = false;
    }

    handleLimpiar(){
        this.showModalLimpiar = true;
    }

    handleOKLimpiar() {
        window.location.reload();
    }

    handleCloseEnviar(){
        this.showModalEnviar = false;
    }

    handleCloseSuccess(){
        this.showSuccess = false;
        window.location.reload();
    }

    handleError(){
        this.showError = false;
    }

    /*** End Button Modals ***/


    handleServicio(event) {
        this.lstServicios = [];
        this.lstRelacionadoCon = [];
        let vSub = event.target.dataset.buttonId;
        this.rSubsidio = vSub;
        
        let vClasses = event.target.classList;
        let strClasses = event.target.className;
        strClasses = strClasses.replaceAll(' ', '.');
        
        [].forEach.call(this.template.querySelectorAll(".menulaterarl ." + strClasses), function (value, index, array) {
            value.classList.remove("selected");
        });
        
        vClasses.add("selected");
        getServicioRelacionado({ vSubsidio: vSub })
            .then(data => {
                if (data.lstServicioRelacionadoWrapper != undefined) {
                    data.lstServicioRelacionadoWrapper.forEach(vServicioRelacionadoW => {
                        this.lstServicios.push({
                            id: vServicioRelacionadoW.vServicio.Id,
                            name: vServicioRelacionadoW.vServicio.RL2_Texto__c,
                            relacionado: vServicioRelacionadoW.lstRelacionadoConWrapper,
                            tooltip: vServicioRelacionadoW.vServicio.RL2_Tooltip__c
                        });
                    });
                }
            })
            .catch(error => {
                console.log('Error -->' +error);
            })

        this.showDependencies = true;
    }

    handleSectionToggle(event){
        const openSections = event.detail.openSections;
    }

    handleToggleRelacionado(event) {
        const openSections = event.detail.openSections;
        if(openSections.length > 0){
            let vTempRelacionado = JSON.stringify(openSections);
            let vRelacionadoLength = vTempRelacionado.length;
            let vSalida = vTempRelacionado.substring(2, vRelacionadoLength - 2);
            
            this.vRelacionadoCon = vSalida;
            getRequisitos({vSubsidio:this.rSubsidio,vRelacionado:this.vRelacionadoCon})
                .then(data => {
                    let requisitos = '';
                    if (data) {
                        for (let i = 0; i < data.length; i++) {
                            requisitos = requisitos + data[i].RL2_NombreRequisito__c;
                            this.vRow = data[i].Id;
                            this.vTitleRequisito = data[i].RL2_NivelSuperior__c;
                        }
                        let vElement = this.template.querySelector('[data-id="'+this.vRow+'"]');
                        let vTitleElement = this.template.querySelector('[data-id="'+this.vTitleRequisito+'"]');
                        this.documentosSoporte = (requisitos != 'undefined') ? requisitos : '';
                        if(this.documentosSoporte != ''){
                            vTitleElement.classList.add("bottom-space");
                            vTitleElement.innerHTML = CONTAINER_HTML;
                        }else{
                            vElement.classList.add("show-element");
                        }
                    } else if (error) {
                        this.error = error;
                    }
                })
                .catch(error => {
                    this.isLoading = false;
                    this.error = error;
                    //console.log('Error -->' +JSON.stringify(error));
                });
        }
        
        
    }

    handleUrl(event) {        
        let butonUrl = event.target.value;
        if(!isURL(butonUrl)){
            this.handleFormulario(event);
            event.preventDefault();  
        }     
    }    

    /*** Cliente ***/
    handleChange(event) {
        this.tipoIdentificacion = event.detail.value;
        this.validarNit();
    }

    handleNumIdent(event){
        this.nIdentificacion = event.detail.value;
    }

    validarNit( ){
        let inputNumberId = this.template.querySelector('[data-id="numIdent"]');
        let numberId = inputNumberId.value;
        let tipoDocu = this.tipoIdentificacion;
        
        if(numberId != ''){
            if( tipoDocu == 2 && numberId.length > 9) {
                inputNumberId.setCustomValidity('Para el tipo de identificación NIT solo puede ingresar 9 caracteres');
            }
            else {
                inputNumberId.setCustomValidity('');
            }
            inputNumberId.reportValidity();
        }
    }
    /*** End Cliente ***/

    /*** Contacto ***/

    handleNomContact(event){
        this.nombreContacto = event.detail.value;
    }

    handleEmailContact(event){
        this.emailContacto = event.detail.value;
    }

    handleTelefono(event){
        this.telefono = event.detail.value;
    }

    handleCelular(event){
        this.celular = event.detail.value;
    }

    /*** End Contacto ***/

    /*** Solicitud ***/

    handleChangeDecreto(event){
        this.vDecreto = event.detail.value;
    }

    handleChangeMedio(event){
        this.medioRespuesta = event.detail.value;
    }

    handleChangeDescrip(event){
        this.description = event.detail.value;
    }

    handleAutoriza(event){
        event.preventDefault();
        this.autoriza = !this.autoriza;
    }

    handleHabeas(event){
        event.preventDefault();
        this.aceptaPolitica = !this.aceptaPolitica;
    }

    handleFechaIngreso(event){
        this.fechaIngreso = event.detail.value;
    }

    /*** End Solicitud ***/

    handleSaveSubsidio(){
        this.isLoading = true;
        let vCaso = CASE;
        
        
        
        vCaso.RF2_TipoIdentificacionHuerfano__c = this.tipoIdentificacion;
        vCaso.RF2_NumeroIdentificacionHuerfano__c = this.nIdentificacion;
        
        vCaso.RF2_NombreContactoHuerfano__c = this.nombreContacto;
        vCaso.RF2_CorreoelectronicoHuerfano__c = this.emailContacto;
        vCaso.RF2_TelefonoHuerfano__c = this.telefono;
        vCaso.RF2_TelefonoMovilHuerfano__c = this.celular;

        
        vCaso.RF2_TipoSolicitud__c = tipoSolicitud;
        vCaso.RF2_ProcesoDestinoMatrizResponsable__c = this.rSubsidio;
        vCaso.RF2_RelacionadoCon__c = this.vRelacionadoCon;
        vCaso.RL2_TipoServicio__c = this.vTipoServicio;
        if(this.showFechaIngreso){
            vCaso.RL2_FechaIngresoNuevoTrabajo__c = this.fechaIngreso;
        }

        if(this.showDecreto){
            vCaso.RL2_NormativaSubsidios__c = this.vDecreto;
        }

        vCaso.RF2_MedioRespuesta__c = this.medioRespuesta;
        vCaso.Description = this.description;

        vCaso.RF2_Autorizaenviorespuestaemail__c = this.autoriza;
        vCaso.RF2_AutorizacionHabeasData__c = this.aceptaPolitica;
        vCaso.RF2_Anonimo__c = false;

        saveSubsidioFiles({ vCaso: vCaso, filesToInsert: this.filesUploaded })
            .then(data => {
                this.isLoading = false;
                this.caseId = data.Id;
                this.numeroCaso = data.CaseNumber;
                this.showSuccess = true;
                this.vDisabled = false;
                this.fileName = undefined;
            })
            .catch(error => {
                this.isLoading = false;
                let vError = JSON.parse(JSON.stringify(error));
                this.showError = true;
                this.vDisabled = false;
                this.errorMedio = vError.body.message;
            });


    }

    handleEnviar(){
        this.vDisabled = true;
        if(!validateFields(this.template)){
            this.showModalEnviar = true;
            this.vDisabled = false;
            return;
        }

        this.handleSaveSubsidio();
    }

    connectedCallback(){
        /*this.bindEvent(window,'message',function(e){
            console.log(e.data);
        });*/
        if(this.isFirstLoad){
            setTimeout(() =>{
                this.firstLoading = false;
                this.isFirstLoad = false;                
            }, 1000);
        }
    }

    renderedCallback(){
        if(this.template.querySelectorAll('.title-menu').length > 0 && !this.vLoad){
            this.vLoad = true;
            if(this.template.querySelectorAll('.title-menu')[0]){
                this.template.querySelectorAll('.title-menu')[0].click();
            }
        }
        if(this.template.querySelectorAll('lightning-layout').length > 0){
            if(FORM_FACTOR == vSmallDevice){
                var elements = this.template.querySelectorAll('lightning-layout');
                removeClasses(elements);
            }
        }
    }

    removeRow(event) {
        if(this.errorMessage != '') { this.errorMessage = ''; } 
        const indexPos = event.currentTarget.name;
        this.temp = this.temp - this.filesUploaded[indexPos].Size;
        this.filesUploaded.splice(indexPos, 1);        
        if(this.filesUploaded.length == 0) this.activo = false;
    }

    handleMultipleFileChanges(event) {
        let files = event.target.files;
        this.temp = this.temp + this.getFilesSize(files);
        let vSize = this.getFilesSize(files);
        if(this.temp > this.MAX_FILE_SIZE){
            this.temp = this.temp - vSize;
            this.errorMessage = 'No se puede exceder el tamaño máximo permitido';
            return reduceErrors(this.errorMessage);
        }
        this.errorMessage = '';
        if (files.length > 0) {
            this.activo = true;
            let filesName = '';

            for (let i = 0; i < files.length; i++) {
                let file = files[i];

                filesName = filesName + file.name + ',';

                let freader = new FileReader();
                freader.onload = f => {
                    let base64 = 'base64,';
                    let content = freader.result.indexOf(base64) + base64.length;
                    let fileContents = freader.result.substring(content);
                    this.filesUploaded.push({
                        Title: file.name,
                        VersionData: fileContents,
                        Size: file.size
                    });
                };
                freader.readAsDataURL(file);
            }

            this.fileName = filesName.slice(0, -1);            
        }
        
    }

    getFilesSize(files){
        let vSize = 0;
        let temporalSize = 0;
        if (files.length > 1) {
            for (let i = 0; i < files.length; i++) {
                vSize = vSize + files[i].size;
            }
            temporalSize = vSize;
        }else{
            vSize = temporalSize + files[0].size;
        }
        return vSize;
    }

    htmlDecode(input) {
        var doc = new DOMParser().parseFromString(input, "text/html");
        return doc.documentElement.textContent;
    }

    handleConditions(vServicio){
        getCheckBoxInfo({vRelacionadoId: vServicio})
            .then(data => {
                if (data) {
                    this.showFechaIngreso = data.RL2_FechaIngreso__c;
                    this.vNoDisplayAttachments = data.RL2_NoDocumentos__c;
                    this.showDecreto = data.RL2_Normatividad__c;
                    this.showImposibilidad = data.RL2_TieneImposibilidad__c;
                    if(data.RL2_DocumentoObligatorio__c){ 
                        this.template.querySelector('[data-id="inputFile"]').required = "true"; 
                        this.template.querySelector('[data-id="inputFile"]').messageWhenValueMissing = "Debe adjuntar documentos de soporte";
                    }
                } 
            })
            .catch(error => {
                console.log('Error -->' +JSON.stringify(error));
            });
    }

    bindEvent(element, eventName, eventHandler) {
        if (element.addEventListener){
            element.addEventListener(eventName, eventHandler, false);
        } else if (element.attachEvent) {
            element.attachEvent('on' + eventName, eventHandler);
        }
    }

    handleModalViable(){
        this.showModalViable = false;
        this.showViable = true;
    }

    handleModalRadicacion(){
        this.showModalRadicacion = false;
        this.showRadicacion = true;
    }

    handleFormulario(event){
        let vFormulario = event.target.value;
        this.isParent = false;
        this.vTipoServicio = event.target.tabIndex;
        
        switch(vFormulario){
            case vFormularioWeb:
                this.showFormulario = true;                
                this.handleConditions(this.vRelacionadoCon);
                if(this.documentosSoporte == '' || this.documentosSoporte == 'undefined'){ this.showDocumentos = false; }
            break;
            
            case vFormularioViabilidad:
                this.showArriendo = true;
                this.showModalViable = true;
            break;
            case vFormularioRadicacion:
                this.showArriendo = true;
                this.showModalRadicacion = true;
            break;
        }
    }

    getFromChild(event){
        console.log('Get From Child');
        console.log(event.detail);
    }

    /*removeClasses(elements) {  
        for (var i = 0; i < elements.length; i++) {
            elements[i].removeAttribute('class');
        }
    }*/
        
}