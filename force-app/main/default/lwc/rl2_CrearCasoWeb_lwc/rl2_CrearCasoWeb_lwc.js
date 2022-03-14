import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';

import getTipoDocumentos from '@salesforce/apex/RL2_CasoWebPCE_ctr.getTipoDocumentos';
import getMediosRespuesta from '@salesforce/apex/RL2_CasoWebPCE_ctr.getMediosRespuesta';
import findPicklistOptions from '@salesforce/apex/RL2_CasoWebPCE_ctr.findPicklistOptions';
import getDependentMap from '@salesforce/apex/RL2_CasoWebPCE_ctr.getDependentMap';
import saveCaseFiles from '@salesforce/apex/RL2_CasoWebPCE_ctr.saveCaseFiles';
import Id from '@salesforce/user/Id';
import CASE_OBJECT from '@salesforce/schema/Case';
import ACTUA_FIELD_OBJECT from '@salesforce/schema/Case.RL2_ActuaSolicitante__c';
import RADICA_PROPIO_FIELD_OBJECT from '@salesforce/schema/Case.RL2_RadicaNombrePropio__c';
import TIPO_SOLICITUD_FIELD_OBJECT from '@salesforce/schema/Case.RF2_TipoSolicitud__c';
import RELACIONADO_FIELD_OBJECT from '@salesforce/schema/Case.RF2_RelacionadoCon__c';
import SEDE_FIELD_OBJECT from '@salesforce/schema/Case.RF2_SedeSuceso__c';

import POBLACION_OBJECT from '@salesforce/schema/RL2_Poblacion__c';
import POBLACION_NAME_FIELD_OBJECT from '@salesforce/schema/RL2_Poblacion__c.Name';

import getDefaultCountry from '@salesforce/apex/RL2_CasoWebPCE_ctr.getDefaultCountry';
import getDefaultState from '@salesforce/apex/RL2_CasoWebPCE_ctr.getDefaultState';
import getDefaultCity from '@salesforce/apex/RL2_CasoWebPCE_ctr.getDefaultCity';

//Custom Label
import tipoSolicitudExclude from '@salesforce/label/c.RL2_Solicitud_GIE_lbl';
import vSmallDevice from '@salesforce/label/c.RL2_SmallDevice';

//Get FormFactor
import FORM_FACTOR from '@salesforce/client/formFactor';

const TO_EXCLUDE = 'Solicitud GIE';
const PROCESO_MATRIZ = 'URL PCE';

const CASE = { 'sobjectType': 'Case' };

export default class Rl2_CrearCasoWeb_lwc extends LightningElement {

    @track lstTipoDocumentos = [];
    @track lstSolicitantes = [];
    @track lstRadicaPropio = [];
    @track lstSedes = [];
    @track lstMedios = [];
    @track checked = false;
    @track lstTipoSolicitud = [];

    @track lstRelacionado = [];
    @track upFiles = [];

    @track activo = false;
    @track temp = 0;
    @track filesUploaded = [];
    @track fileName = '';

    @track defaultPais;
    @track defaultDept;
    @track defaultCiudad;
    
    filterRelacionado = [];

    userId = Id;
    caseId;
    numeroCaso = '';

    //Fields

    /*** Cliente ***/
    tipoIdentificacion = '';
    solicitante = '';
    nIdentificacion = '';
    /*** End Cliente ***/

    /*** Representado ***/
    tipoIdentificacionRepresentado = '';
    nIdentificacionRepresentado = '';
    /*** End Representado ***/

    /*** Contacto ***/

    //Nit
    rSocial = '';
    tIdContact = '';
    nIdContact = '';
    //End Nit

    sedeSuceso = '';
    fechaSuceso
    nombreContacto = '';
    emailContacto = '';
    radicaNombre = '';
    direccion = '';
    telefono = '';
    celular = '';

    pais = '';
    departamento = '';
    ciudad = '';
    propio = '';
    
    //documentossoporte = [];
    
    

    /*** End Contacto ***/

    /*** Solicitud ***/
    programa = '';
    relacionado = '';
    medioRespuesta = '';
    description = '';
    autoriza = false;
    aceptaPolitica = false;
    /*** End Cliente ***/



    //End Fields

    showModal = false;
    showModalLimpiar = false;
    showModalEnviar = false;

    showfooter = true;
    showHeader = true;

    showButtonPositive = true;
    showButtonNegative = true;

    showError = false;

    showComponent = false;
    isLoading = true;
    isFirstLoad = true;
    isFirstRender = true;
    loading = true;

    showPropio = false;
    showAnonimo = true;

    isChecked = false;
    showNit = false;

    showSuccess = false;
    vDisabled = false;

    //Files
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 3145728;
    errorMessage = '';
    errorMedio = '';
    //End Files

    depFilter = '';
    ciudadFilter = '';

    @wire(getDefaultCountry)
    defaultCountry({ error, data }) {
        if(data) {
            this.defaultPais = data;
        }else if (error) {
            this.error = error;
        }
    }

    @wire(getDefaultState, {parentId : '$defaultPais.val'})
    defaultState({ error, data }) {
        if(data) {
            this.defaultDept = data;
        }else if (error) {
            this.error = error;
        }
    }

    @wire(getDefaultCity, {parentId : '$defaultDept.val'})
    defaultCity({ error, data }) {
        if(data) {
            this.defaultCiudad = data;
        }else if (error) {
            this.error = error;
        }
    }

    @wire(findPicklistOptions, {objAPIName : CASE_OBJECT.objectApiName, fieldAPIname : ACTUA_FIELD_OBJECT.fieldApiName, toExclude : ''})
    getListaSolicitantes({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstSolicitantes = [...this.lstSolicitantes, { value: data[i].val, label: data[i].text }];
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

    @wire(findPicklistOptions, {objAPIName : CASE_OBJECT.objectApiName, fieldAPIname : RADICA_PROPIO_FIELD_OBJECT.fieldApiName, toExclude : ''})
    getRadicaPropio({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstRadicaPropio = [...this.lstRadicaPropio, { value: data[i].val, label: data[i].text }];
            }
            Object.keys(this.lstRadicaPropio).forEach((key) => {
                if(this.lstRadicaPropio[key].value == 'Si'){
                    this.propio = this.lstRadicaPropio[key].value;
                }
            });
        } else if (error) {
            this.error = error;
        }
    }

    @wire(findPicklistOptions, {objAPIName : CASE_OBJECT.objectApiName, fieldAPIname : TIPO_SOLICITUD_FIELD_OBJECT.fieldApiName, toExclude : tipoSolicitudExclude})
    getListaTipoSolicitud({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                let vText = data[i].text;
                if(vText.includes('PCE')){vText = vText.replace(/\sPCE/g,'');}
                this.lstTipoSolicitud = [...this.lstTipoSolicitud, { value: data[i].val, label: vText }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getDependentMap, {obj : CASE, ctrl : RELACIONADO_FIELD_OBJECT.fieldApiName, dep : TIPO_SOLICITUD_FIELD_OBJECT.fieldApiName})
    getDependencies({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstRelacionado = [...this.lstRelacionado, { value: data[i].val, label: data[i].text, lista: data[i].lstVal }];
            }
            
        } else if (error) {
            this.error = error;
        }
    }

    @wire(findPicklistOptions, {objAPIName : CASE_OBJECT.objectApiName, fieldAPIname : SEDE_FIELD_OBJECT.fieldApiName, toExclude : ''})
    getSedes({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstSedes = [...this.lstSedes, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    changeToggle(event){
        this.checked = !this.checked;
        this.showAnonimo= (this.checked) ? false : true;
    }

    

    get options() {
        return this.lstTipoDocumentos;
    }

    get optionsTipoIdenContact() {
        return this.lstTipoDocumentos;
    }

    get solicitantes() {
        return this.lstSolicitantes;
    }

    get optionsPropio(){
        return this.lstRadicaPropio; 
    }

    /*get departamento(){
        if(this.pais == 'Colombia') this.departamento = 'Bogotá D.C.';
    }

    get ciudad(){
        if(this.departamento == 'CU') this.ciudad = 'BG';
    }*/

    get optionsPrograma() {
        return this.lstTipoSolicitud;
    }

    get optionsRelacionado() {        
        return this.filterRelacionado;
    }

    get optionsMedio(){
        return this.lstMedios;
    }

    get optionsSuceso(){
        return this.lstSedes;
    }

    get poblacionApiName() { return POBLACION_OBJECT.objectApiName; }
    get metaLabelField() { return POBLACION_NAME_FIELD_OBJECT; }
    
    get filter(){ 
        return 'RL2_EsPais__c = true'; 
    }

    get todaysDate() {
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0');
        let yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        return today;
    }

    get acceptedFormats() {
        return ['.xlsx', '.xls', '.png', '.pdf', '.doc', '.docx', '.jpg', '.jpeg'];
    }

    /*** Button Modals ***/
    handleCloseModal(){
        this.showModal = false;
    }

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

    /*** Cliente ***/
    handleChange(event) {
        this.tipoIdentificacion = event.detail.value;
        this.showNit = (this.tipoIdentificacion == 2) ? true : false;
    }

    /*** Representado ***/
    handleChangeRepresentado(event){
        this.tipoIdentificacionRepresentado = event.detail.value;
    }

    handleNumIdentRepresentado(event){
        this.nIdentificacionRepresentado = event.detail.value;
    }
    /*** End Representado ***/

    handleSolicitante(event) {
        this.solicitante = event.detail.value;
    }

    handleNumIdent(event){
        this.nIdentificacion = event.detail.value;
    }
    /*** End Cliente ***/


    /*** Contacto ***/

    handleChangeSuceso(event){
        this.sedeSuceso = event.detail.value;
    }

    handleFechaSuceso(event){
        this.fechaSuceso = event.detail.value;
    }

    //Nit
    handleRSocial(event){
        this.rSocial = event.detail.value;
    }
    handleChangeIdentContact(event){
        this.tIdContact = event.detail.value;
    }
    handleNIdentContact(event){
        this.nIdContact = event.detail.value;
    }
    //End Nit

    handleNomContact(event){
        this.nombreContacto = event.detail.value;
    }

    handleEmailContact(event){
        this.emailContacto = event.detail.value;
    }

    handleChangePropio(event){
        this.propio = event.detail.value;
        this.showPropio = (this.propio == 'No') ? true : false;
    }

    handleRadicaNombre(event){
        this.radicaNombre = event.detail.value;
    }

    handleDirContact(event){
        this.direccion = event.detail.value;
    }

    handleChangePais(e){
        this.pais = e.detail.value ? e.detail.value.id : '';

        if(this.pais != ''){
            if(this.pais == this.defaultPais.val){
                let text = '\''+this.pais+'\''; 
                this.depFilter = 'RL2_EsDepartamento__c = true AND RL2_PoblacionPadre__c = '+text;
                this.departamento = this.defaultDept.val;
                let dept = '\''+this.departamento+'\'';
                this.ciudadFilter = 'RL2_EsMunicipio__c  = true AND RL2_PoblacionPadre__c = '+dept;
                this.ciudad = this.defaultCiudad.val;
            }else{
                this.depFilter = this.filter;
                this.ciudadFilter = this.filter;
                this.departamento = this.pais;
                this.ciudad = this.pais;
            }
        }else{
            this.depFilter = '';
            this.departamento = '';
            this.ciudadFilter = '';
            this.ciudad = '';
        }
    }

    handleChangeDepartamento(e){
        this.departamento = e.detail.value ? e.detail.value.id : '';
        if(this.pais == this.defaultPais.val){
            if(this.departamento != this.defaultDept.val){
                if(this.departamento != ''){
                    let text = '\''+this.departamento+'\''; 
                    this.ciudadFilter = 'RL2_EsMunicipio__c  = true AND RL2_PoblacionPadre__c = '+text;
                }
            }else{
                let text = '\''+this.departamento+'\''; 
                this.ciudadFilter = 'RL2_EsMunicipio__c  = true AND RL2_PoblacionPadre__c = '+text;
                this.ciudad = this.defaultCiudad.val;
            }
        }else if(this.departamento != ''){
            this.ciudadFilter = this.filter;
            this.ciudad = this.pais;
        }else{
            if(this.pais != ''){
                this.departamento = this.pais;
            }
        }
        
    }

    handleChangeCiudad(e){
        this.ciudad = e.detail.value ? e.detail.value.id : '';
        if(this.ciudad == ''){
            if( this.pais != this.defaultPais.val && this.departamento != ''){
                console.log('Entro');
                this.ciudad = this.pais;
            }
        }
    }

    handleTelefono(event){
        this.telefono = event.detail.value;
    }

    handleCelular(event){
        this.celular = event.detail.value;
    }


    /*** End Contacto ***/

    /*** Solicitud ***/
    handleChangeProgram(event){
        this.programa = event.detail.value;
        this.filterRelacionado = this.filterList(this.lstRelacionado, this.programa);
        this.relacionado = (this.relacionado != '') ?? '';
    }

    handleChangeRelacionado(event){
        this.relacionado = event.detail.value;
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

    /*** End Solicitud ***/

    
    handleSaveOys(){
        this.isLoading = true;
        let vCaso = CASE;
        vCaso.RF2_Anonimo__c = this.checked;
        if(!vCaso.RF2_Anonimo__c){
            vCaso.RL2_ActuaSolicitante__c = this.solicitante;
            vCaso.RF2_TipoIdentificacionHuerfano__c = this.tipoIdentificacion;
            vCaso.RF2_NumeroIdentificacionHuerfano__c = this.nIdentificacion;
            
            vCaso.RF2_NombreContactoHuerfano__c = this.nombreContacto;
            vCaso.RF2_CorreoelectronicoHuerfano__c = this.emailContacto;
            vCaso.RF2_DireccionHuerfano__c = this.direccion;
            vCaso.RF2_TelefonoHuerfano__c = this.telefono;
            vCaso.RF2_TelefonoMovilHuerfano__c = this.celular;

            vCaso.RL2_Pais__c = this.pais;
            vCaso.RL2_Departamento__c = this.departamento;
            vCaso.RL2_Municipio__c = this.ciudad;

            vCaso.RF2_MedioRespuesta__c = this.medioRespuesta;
        }

        if(this.showPropio){
            vCaso.RL2_RadicaNombreDe__c = this.radicaNombre;
            vCaso.RL2_RadicaNombrePropio__c = this.propio;
            /*** Representado ***/
            vCaso.RF2_Identificacion_de_a_quien_representa__c = this.tipoIdentificacionRepresentado;
            vCaso.RF2_Numero_de_a_quien_representa__c = this.nIdentificacionRepresentado;
            /*** End Representado ***/
        }
        

        if(this.showNit){
            vCaso.RF2_CompanyaHuerfano__c = this.rSocial;
            vCaso.RF2_TipoIdentificacionContactoHuerfano__c = this.tIdContact
            vCaso.RF2_NumeroIdentificacionContactoHuerfano__c = this.nIdContact;
        }

        vCaso.RF2_SedeSuceso__c = this.sedeSuceso;
        vCaso.RF2_FechaSuceso__c = this.fechaSuceso;
        vCaso.RF2_TipoSolicitud__c = this.programa;
        vCaso.RF2_ProcesoDestinoMatrizResponsable__c = PROCESO_MATRIZ;
        vCaso.RF2_RelacionadoCon__c = this.relacionado;
        
        //vCaso.RF2_MedioRespuesta__c = this.medioRespuesta;
        vCaso.Description = this.description;

        vCaso.RF2_Autorizaenviorespuestaemail__c = this.autoriza;
        vCaso.RF2_AutorizacionHabeasData__c = this.aceptaPolitica;

        saveCaseFiles({ parentId: this.userId, vCaso: vCaso, filesToInsert: this.filesUploaded })
            .then(data => {
                this.isLoading = false;
                this.caseId = data.Id;
                this.numeroCaso = data.CaseNumber;

                const showSuccess = new ShowToastEvent({
                    title: 'Success!!',
                    message: this.fileName + ' files uploaded successfully.',
                    variant: 'Success',
                });
                this.showSuccess = true;
                this.vDisabled = false;
                this.dispatchEvent(showSuccess);
                this.fileName = undefined;
            })
            .catch(error => {
                this.isLoading = false;
                let vError = JSON.parse(JSON.stringify(error));
                this.showError = true;
                this.vDisabled = false;
                if(vError.body.message.includes('RV-CASO-010')){
                    this.errorMedio = 'Debe elegir un medio de Respuesta diferente a Correo Electrónico';
                }else{
                    this.errorMedio = vError.body.message;
                }
                
               
                const showError = new ShowToastEvent({
                    title: 'Error!!',
                    message: 'An Error occur while uploading the file.',
                    variant: 'error',
                });
                this.dispatchEvent(showError);
            });


    }
    

    handleModal( ) {
        this.showModal = false;
        this.showComponent = true;
        this.loading = false;
    }

    handleEnviar(){
        this.vDisabled = true;
        if(!this.validateFields()){
            this.showModalEnviar = true;
            this.vDisabled = false;
            return;
        }

        this.handleSaveOys();
    }

    

    validateFields(){
        let validate = false;
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);

        const isCombobox = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);

        const isTextArea = [...this.template.querySelectorAll('lightning-textarea')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);

        if(isInputsCorrect && isCombobox && isTextArea){
            validate = true;
        }

        return validate;
    }

    getInfoByKey(obj, key){
        let newObj = [];
        if(obj.hasOwnProperty(key)){
            newObj = obj[key];
        }
        return newObj;
    }

    connectedCallback(){
        if(this.isFirstLoad){
            setTimeout(() =>{
                this.isLoading = false;
                this.showModal = true;
                this.isFirstLoad = false;                
            }, 1000);
        }
    }

    renderedCallback(){
        if(this.defaultPais && this.isFirstRender){
            this.pais = this.defaultPais.val;
            setTimeout(() =>{
                let tPais = '\''+this.pais+'\''; 
                this.depFilter = 'RL2_EsDepartamento__c = true AND RL2_PoblacionPadre__c = '+tPais;
                this.departamento = this.defaultDept.val;
                let tDept = '\''+this.departamento+'\'';
                this.ciudadFilter = 'RL2_EsMunicipio__c  = true AND RL2_PoblacionPadre__c = '+tDept;
                this.ciudad = this.defaultCiudad.val;
            }, 1000);
            this.isFirstRender = false;
        }
        if(this.template.querySelectorAll('lightning-layout').length > 0){
            if(FORM_FACTOR == vSmallDevice){
                var elements = this.template.querySelectorAll('lightning-layout');
                this.removeClasses(elements);
            }
        }
    }

    filterList(obj, str){
        let newObj = [];
        for (var i = 0; i < obj.length; i++) {
            if(obj[i].lista.includes(str)){
                newObj = [...newObj, { value: obj[i].value, label: obj[i].label }];
            }
        }
        return newObj;
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
                let extension = file.name.split('.').pop();
                if(!this.acceptedFormats.includes('.'+extension.toLowerCase())){
                    if(this.temp > 0){ this.temp = this.temp - vSize; }
                    this.errorMessage = 'Archivo no permitido';
                    return reduceErrors(this.errorMessage);
                }
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
        this.temporalSize = 0;
        if (files.length > 1) {
            for (let i = 0; i < files.length; i++) {
                vSize = vSize + files[i].size;
            }
            this.temporalSize = vSize;
        }else{
            vSize = this.temporalSize + files[0].size;
        }
        return vSize;
    }

    removeClasses(elements) {  
        for (var i = 0; i < elements.length; i++) {
            elements[i].removeAttribute('class');
        }
    }
    
}