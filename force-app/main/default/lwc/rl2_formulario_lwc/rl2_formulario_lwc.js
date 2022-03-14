import { LightningElement, api, wire, track  } from 'lwc';
import { validateFields, filterMap, removeClasses } from 'c/rl2_Utilities';

import vResource from '@salesforce/resourceUrl/RL2Resources';
import getArriendoDocumentos from '@salesforce/apex/RL2_Subsidio_ctr.getArriendoDocumentos';
import getDependentFields from '@salesforce/apex/RL2_Subsidio_ctr.getDependentFields';
import getPickListInfo from '@salesforce/apex/RL2_Subsidio_ctr.getPickListInfo';
import saveSubsidioFiles from '@salesforce/apex/RL2_Subsidio_ctr.saveSubsidioFiles';
import getTipoDocumentosArriendo from '@salesforce/apex/RL2_Subsidio_ctr.getTipoDocumentosArriendo';

import CASE_OBJECT from '@salesforce/schema/Case';
import INMUEBLE_ARRENDAR_FIELD_OBJECT from '@salesforce/schema/Case.RL2_ElInmuebleAArrendarSeVaAHacerCon_del__c';
import TIPO_CONTRATO_FIELD_OBJECT from '@salesforce/schema/Case.RL2_TipoContratoArrendamiento__c';
import DURACION_CONTRATO_FIELD_OBJECT from '@salesforce/schema/Case.RL2_DuracionDelContratoArrendamiento__c';
import BANCOS_CONTRATO_FIELD_OBJECT from '@salesforce/schema/Case.RL2_EntidadBancaria__c';
import TIPO_CUENTA_FIELD_OBJECT from '@salesforce/schema/Case.RL2_TipoDeCuenta__c';
import TIPO_ID_ARRENDADOR_FIELD_OBJECT from '@salesforce/schema/Case.RL2_TipoDeIdentificacionArrendador__c';

import POBLACION_OBJECT from '@salesforce/schema/RL2_Poblacion__c';
import POBLACION_NAME_FIELD_OBJECT from '@salesforce/schema/RL2_Poblacion__c.Name';
import getCityByName from '@salesforce/apex/RL2_Subsidio_ctr.getCityByName';

//Custom Label
import vFilter from '@salesforce/label/c.RL2_FilterMunicipio';
import vDefaultCity from '@salesforce/label/c.RL2_DefaultCity_lbl';
import vPersonaNatural from '@salesforce/label/c.RL2_PersonaNatural_lbl';
import vLabelPolitica from '@salesforce/label/c.RL2_Politica_lbl';
import vSmallDevice from '@salesforce/label/c.RL2_SmallDevice';

//Get FormFactor
import FORM_FACTOR from '@salesforce/client/formFactor';

const CASE = { 'sobjectType': 'Case' };

export default class Rl2_formulario_lwc extends LightningElement {
    @api showviabilidad;
    @api showradicacion;
    @api optionsChild = [];
    @api vcasodata;
    @track filesUploaded = [];
    @track vImpuestoPredial = [];
    @track vMunicipio;
    @track lstTipoIdentificacion = [];

    @track lstInmuebleArrendar = [];
    @track lstTipoIdArrendador = [];

    @track lstTipoContrato = [];
    @track lstDuracionContrato;
    @track lstEvaluacion = [];
    @track lstRadicacion = [];
    @track lstBancos = [];
    @track lstTipoCuenta = [];

    vPolitica = vLabelPolitica;

    filterDuracion = [];
    filterTipoIdArrendar = [];

    loading = false;
    showAdjunto = true;
    showTamanio = true;
    showMessage = true;
    
    vIsRequired = true;

    showModalEnviar = false;
    showModalLimpiar = false;
    showSuccess = false;
    showError = false;

    showfooter = true;
    showHeader = true;

    showButtonPositive = true;
    showButtonNegative = true;

    showNumeroPropietario = false;

    vDisabled = false;
    caseId;
    numeroCaso = '';
    errorMedio = '';
    isMultiple = true;

    viabilidadImage = vResource + '/formulario2.jpg';
    radicacionImage = vResource + '/formulario1.jpg';

    /*** Cliente ***/

    tipoIdentificacion = '';    
    nIdentificacion = '';

    /*** End Cliente ***/

    /*** Beneficiario ***/
    
    nombreBeneficiario = '';
    emailBeneficiario = '';
    telefonoBeneficiario = '';

    /*** End Beneficiario ***/

    /*** Arrendador ***/

    tipoIdentArrendador = '';
    nIdentArrendador = '';
    emailArrendador = '';
    telefonoArrendador = '';
    vArrendarCon = '';
    numeroPropietario = '';
    nombreArrendador = '';

    /*** End Arrendador ***/

    /*** Inmueble ***/
    
    direccionInmueble = '';
    barrio = '';
    ciudad = '';
    currency = '';
    subsidioCurrency = '';
    numeroMatricula = '';
    get poblacionApiName() { return POBLACION_OBJECT.objectApiName; }
    get metaLabelField() { return POBLACION_NAME_FIELD_OBJECT; }
    
    get filter(){ 
        return vFilter; 
    }

    /*** End Inmueble ***/

    /** Contrato ***/
    tipoContrato = '';
    duracionContrato = '';
    fechaFirmaContrato;
    fechaInicioContrato;
    telefonoPropietario = '';
    aporte = '';
    entidadBancaria = '';
    tipoCuenta = '';
    nCuenta = '';
    /** End Contrato ***/

    autoriza = false;
    aceptaPolitica = false;

    @wire(getTipoDocumentosArriendo)
    getTipoClienteRadicacion({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstTipoIdentificacion = [...this.lstTipoIdentificacion, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPickListInfo, {vObject : CASE_OBJECT.objectApiName, vField : INMUEBLE_ARRENDAR_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getInmuebleArrendar({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstInmuebleArrendar = [...this.lstInmuebleArrendar, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPickListInfo, {vObject : CASE_OBJECT.objectApiName, vField : TIPO_CONTRATO_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getTipoContrato({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstTipoContrato = [...this.lstTipoContrato, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPickListInfo, {vObject : CASE_OBJECT.objectApiName, vField : BANCOS_CONTRATO_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getBancos({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstBancos = [...this.lstBancos, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPickListInfo, {vObject : CASE_OBJECT.objectApiName, vField : TIPO_CUENTA_FIELD_OBJECT.fieldApiName, vExclude : ''})
    getTipoCuenta({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.lstTipoCuenta = [...this.lstTipoCuenta, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getDependentFields, {obj : CASE, vField : DURACION_CONTRATO_FIELD_OBJECT.fieldApiName})
    getDependencies({ error, data }) {
        if (data) {
            this.lstDuracionContrato = data.mapVal;
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getDependentFields, {obj : CASE, vField : TIPO_ID_ARRENDADOR_FIELD_OBJECT.fieldApiName})
    getTipoIdArrendar({ error, data }) {
        if (data) {
            this.lstTipoIdArrendador = data.mapVal;
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getCityByName, {vCity : vDefaultCity})
    getCity({ error, data }) {
        if(data) {
            this.ciudad = (data.text == vDefaultCity) ? data.val : '';
        }else if (error) {
            this.error = error;
        }
    }

    @wire(getArriendoDocumentos)
    getListaDocumentos({ error, data }) {
        if (data) {
            for (let i = 0; i < data.length; i++) {
                if(data[i].name == 'viabilidad'){
                    this.lstEvaluacion = [...this.lstEvaluacion, { 
                            name: data[i].name, 
                            required: ( data[i].val == 'required' ) ? true : false, 
                            label: data[i].text
                        }
                    ];
                }else{
                    this.lstRadicacion = [...this.lstRadicacion, { 
                            name: data[i].name, 
                            required: ( data[i].val == 'required' ) ? true : false, 
                            label: data[i].text,
                            clase: ( data[i].val != 'required' ) ? 'alinear' : ''
                        }
                    ];
                }
            }
        } else if (error) {
            this.error = error;
        }
    }

    get options(){
        return this.lstTipoIdentificacion;
    }

    get optionsArrendar(){
        return this.lstInmuebleArrendar;
    }

    get optionsTipoIdArrendador(){
        return this.filterTipoIdArrendar;
    }

    get optionsContrato() {
        return this.lstTipoContrato;
    }

    get optionsDuracion(){
        return this.filterDuracion;
    }

    get optionsBanco(){
        return this.lstBancos;
    }

    get optionsCuenta(){
        return this.lstTipoCuenta;
    }
    

    /*** Cliente ***/
    handleChange(event){
        this.tipoIdentificacion = event.detail.value;
        this.validarNit();
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

    validateLength(event){
        let element = event.target;
        if(element.value != ''){
            if(element.classList.contains('moneda') && element.value.length < 6){
                element.setCustomValidity('No puede ingresar un valor menor de 6 caracteres');
            }else if(element.classList.contains('mes-moneda') && element.value.length < 5){
                element.setCustomValidity('No puede ingresar un valor menor de 5 caracteres');
            }else{ element.setCustomValidity(''); }
            element.reportValidity();
        }
    }

    handleNumIdent(event){
        this.nIdentificacion = event.detail.value;
    }
    /*** End Cliente ***/

    /*** Beneficiario ***/    
    handleNomBeneficiario(event){
        this.nombreBeneficiario = event.detail.value;
    }
    handleEmailBeneficiario(event){
        this.emailBeneficiario = event.detail.value;
    }
    handleTelefonBeneficiario(event){
        this.telefonoBeneficiario = event.detail.value;
    }
    /*** End Beneficiario ***/

    /*** Arrendador ***/
    handleArrendarCon(event){
        this.vArrendarCon = event.detail.value;
        this.showNumeroPropietario = (this.vArrendarCon == vPersonaNatural) ? true : false;
        this.filterTipoIdArrendar = filterMap(this.lstTipoIdArrendador, this.vArrendarCon);        
        this.tipoIdentArrendador = '';
    }
    handleChangeArrendador(event){
        this.tipoIdentArrendador = event.detail.value;
    }
    handleNumIdentArrendador(event){
        this.nIdentArrendador = event.detail.value;
    }
    handleEmailArrendador(event){
        this.emailArrendador = event.detail.value;
    }
    handleTelefonoArrendador(event){
        this.telefonoArrendador = event.detail.value;
    }

    handleNumPropietario(event){
        this.numeroPropietario = event.detail.value;
    }

    handleNomArrendador(event){
        this.nombreArrendador = event.detail.value;
    }

    /*** End Arrendador ***/

    /*** Inmueble ***/
    handleDirInmueble(event){
        this.direccionInmueble = event.detail.value;
    }
    handleBarrio(event){
        this.barrio = event.detail.value;
    }
    handleChangeCiudad(event){
        this.ciudad = event.detail.value ? event.detail.value.id : '';
    }
    handleCurrency(event){
        this.currency = event.detail.value;
        this.validateLength(event);
    }
    handleSubsidioCurrency(event){
        this.subsidioCurrency = event.detail.value;
        this.validateLength(event);
    }
    handleNumMatricula(event){
        this.numeroMatricula = event.detail.value;
    }

    /*** End Inmueble ***/

    /*** Contrato ***/

    handleTipoContrato(event){
        this.tipoContrato = event.detail.value;
        this.filterDuracion = filterMap(this.lstDuracionContrato, this.tipoContrato);        
        this.duracionContrato = '';
    }

    handleDuracion(event){
        this.duracionContrato = event.detail.value;
    }

    handleFechaFirmaContrato(event){
        this.fechaFirmaContrato = event.detail.value;
    }

    handleFechaInicioContrato(event){
        this.fechaInicioContrato = event.detail.value;
    }

    handleTelefonoPropietario(event){
        this.telefonoPropietario = event.detail.value;
    }

    handleAporteMensual(event){
        this.aporte = event.detail.value;
        this.validateLength(event);
    }

    handleChangeBanco(event){
        this.entidadBancaria = event.detail.value;
    }

    handleChangeCuenta(event){
        this.tipoCuenta = event.detail.value;
    }

    handleNumCuenta(event){
        this.nCuenta = event.detail.value;
    }

    /*** End Contrato ***/

    handleAutoriza(event){
        event.preventDefault();
        this.autoriza = !this.autoriza;
    }

    handleHabeas(event){
        event.preventDefault();
        this.aceptaPolitica = !this.aceptaPolitica;
    }
    
    passToParent(event){
        this.filesUploaded = event.detail.value;
        this.vIsRequired = (this.filesUploaded.length > 0) ? false : true;
    }

    getFromChild(event){
        this.vImpuestoPredial = event.detail.value;
    }

    handleEnviar(){
        
        this.vDisabled = true;
        let vFiles = (this.filesUploaded.length > 0) ? true : false;
        let vCiudad = (this.ciudad != '') ? true : false;
        let validate = false;
        if(validateFields(this.template) && vFiles && vCiudad){
            validate = true;
        }
        if(!validate){
            this.showModalEnviar = true;
            this.vDisabled = false;
            return;
        }
        
        this.handleSave();
    }

    handleCloseEnviar(){
        this.showModalEnviar = false;
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

    handleCloseSuccess(){
        this.showSuccess = false;
        window.location.reload();
    }

    handleError(){
        this.showError = false;
    }

    handleSave(){
        this.loading = true;
        let vCaso = CASE;
        
        
        vCaso.RF2_TipoIdentificacionHuerfano__c = this.tipoIdentificacion;
        vCaso.RF2_NumeroIdentificacionHuerfano__c = this.nIdentificacion;
        
        vCaso.RF2_NombreContactoHuerfano__c = this.nombreBeneficiario;
        vCaso.RF2_CorreoelectronicoHuerfano__c = this.emailBeneficiario;
        vCaso.RF2_TelefonoHuerfano__c = this.telefonoBeneficiario;

        vCaso.RL2_ElInmuebleAArrendarSeVaAHacerCon_del__c = this.vArrendarCon;
        vCaso.RL2_TipoDeIdentificacionArrendador__c = this.tipoIdentArrendador;
        vCaso.RL2_NMeroIdentificacionArrendador__c = this.nIdentArrendador;
        vCaso.RL2_CorreoElectrNicoBeneficiario__c = this.emailArrendador;
        vCaso.RL2NombreArrendador__c = this.nombreArrendador;

        if(this.showviabilidad){
            if(this.showNumeroPropietario){ vCaso.RL2_NMeroDePropietariosDelInmueble__c = this.numeroPropietario; }
            vCaso.RL2_Barrio__c = this.barrio;
        }

        if(this.showradicacion){
            vCaso.RL2_TipoContratoArrendamiento__c = this.tipoContrato;
            vCaso.RL2_DuracionDelContratoArrendamiento__c = this.duracionContrato;
            vCaso.RL2_FechaFirmaContrato__c = this.fechaFirmaContrato;
            vCaso.RL2_FechaInicioContrato__c = this.fechaInicioContrato;
            vCaso.RL2_SubsidioMensualDeArrendamiento__c = this.subsidioCurrency;
            vCaso.RL2_AporteMensualCanonArrendamiento__c = this.aporte;
            vCaso.RL2_EntidadBancaria__c = this.entidadBancaria;
            vCaso.RL2_TipoDeCuenta__c = this.tipoCuenta;
            vCaso.RL2_NumeroDeCuenta__c = this.nCuenta;
        }
        
        vCaso.RL2_TelefonoArrendador__c = this.telefonoArrendador;
        vCaso.RL2_DireccionInmueble__c = this.direccionInmueble;
        vCaso.RL2_MunicipioArrendamiento__c = this.ciudad;
        vCaso.RL2_CanonDeArrendamiento__c = this.currency;
        vCaso.RL2_NumeroMatriculaInmobiliaria__c = this.numeroMatricula;
        
        vCaso.RF2_TipoSolicitud__c = this.vcasodata.solicitud;
        vCaso.RF2_ProcesoDestinoMatrizResponsable__c = this.vcasodata.subsidio;
        vCaso.RF2_RelacionadoCon__c = this.vcasodata.relacionado;
        vCaso.RL2_TipoServicio__c = this.vcasodata.servicio;

        vCaso.RF2_Autorizaenviorespuestaemail__c = this.autoriza;
        vCaso.RF2_AutorizacionHabeasData__c = this.aceptaPolitica;
        vCaso.RF2_Anonimo__c = false;

        saveSubsidioFiles({ vCaso: vCaso, filesToInsert: this.filesUploaded })
            .then(data => {
                this.loading = false;
                this.caseId = data.Id;
                this.numeroCaso = data.CaseNumber;
                this.showSuccess = true;
                this.vDisabled = false;
            })
            .catch(error => {
                this.loading = false;
                let vError = JSON.parse(JSON.stringify(error));
                this.showError = true;
                this.vDisabled = false;
                this.errorMedio = vError.body.message;
            });


    }

    renderedCallback(){
        if(this.template.querySelectorAll('lightning-layout').length > 0){
            if(FORM_FACTOR == vSmallDevice){
                var elements = this.template.querySelectorAll('lightning-layout');
                removeClasses(elements);
            }
        }
    }

    /*handleChangeChild(e) {
        this.tipoIdentificacion = e.detail.value;
        this.dispatchEvent(new CustomEvent('changeidentificacion', { detail: this.tipoIdentificacion }));
    }*/
}