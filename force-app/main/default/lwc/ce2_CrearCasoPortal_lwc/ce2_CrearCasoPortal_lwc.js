import { LightningElement, wire, api, track } from 'lwc';
import { reduceErrors, validateFields, isURL, removeClasses } from 'c/rl2_Utilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getListasCiudades from '@salesforce/apex/ce2_crearcasolwc_ctr.obtenerListas';
import extraerRequisitosSol from '@salesforce/apex/ce2_crearcasolwc_ctr.extraeRequisitos';
import getListasMediosAtencion from '@salesforce/apex/ce2_crearcasolwc_ctr.getMediosAtencion';
import getListasTiposDoc from '@salesforce/apex/ce2_crearcasolwc_ctr.getTiposDoc';
import getContactList from '@salesforce/apex/ce2_crearcasolwc_ctr.getContactList';
import saveFiles from '@salesforce/apex/ce2_crearcasolwc_ctr.saveFiles';
//import releatedFiles from '@salesforce/apex/ce2_crearcasolwc_ctr.releatedFiles';
//import traerArchivos from '@salesforce/apex/ce2_crearcasolwc_ctr.traerArchivos';
import Id from '@salesforce/user/Id';
import { refreshApex } from '@salesforce/apex';
import getMatrizCases from '@salesforce/apex/ce2_crearcasolwc_ctr.searchMatrizCase';
import getSolicRelated from '@salesforce/apex/ce2_crearcasolwc_ctr.getSolicRelateCon';
import { NavigationMixin } from 'lightning/navigation';
import SVG_WIFI from '@salesforce/resourceUrl/CE2_LogoWifi';

const campos = [
    { campo: 'tipoDocu' }, { campo: 'numIdent' }, { campo: 'emailContac' }, { campo: 'dirContac' }, { campo: 'mediosRta' }, { campo: 'descSol' }, { campo: 'autorEnvio' }, { campo: 'acptPolitic' }
];
document.cookie = "third_party_var=value; SameSite=None; Secure";

// export function createCookie() {
//     document.cookie = "third_party_var=value; SameSite=None; Secure";
// }

export default class Ce2_CrearCasoPortal_lwc extends LightningElement {
    //plantillaPrueba = plantillaExcel;
    //@track columnsOtra = columnsOtra;
    @api recordId;
    @track listaCiudades = [];
    @track listaMediosAten = [];
    @track listaTipoDoc = [];
    @track listaCampos = [];
    @track validaCampos = campos;
    @track activo = false;
    @track numCaso = '';
    userId = Id;
    documentossoporte = '';
    tipoDoc = '';
    idCaso;
    numIdent = '';
    nomContac = '';
    emailContac = '';
    dirContac = '';
    ciudadCont = '';
    telCont;
    celCont;
    mediosRta = '';
    descSol = '';
    autorEnvio = false;
    acptPolitic = false;
    isEnlaceDescarga = false;
    vEnlaceDescarga = '';
    @track isModalOpen = false;
    @track isModalGuardarOpen = false;
    @track isModalLimpiarOpen = false;
    @track isRegistro = false;
    @track isPreRegistro = true;
    /* Inicio 1.0 */
    @track isModalOpenFile = false;
    @track countFileSize = 0;
    @track sizefilesUploaded = [];
    MAX_FILE_SIZE = 3000000;
    /* Fin 1.0 */
    
    //@track columns = columns;
    @track data;
    @track dataArchLst;
    @track fileName = '';
    @track UploadFile = 'Upload File';
    @track showLoadingSpinner = false;
    @track isTrue = false;
    @track relacionadoCon; //= 'Actualizacion Datos  Trabajador';
    @track tipoSolicMatriz; //= 'Aclaraciones';
    @track programaReg; //= 'Empresarial';
    @track tipoSolicform = 'Solicitud GIE';
    @track origenSol = 'Pagina Web';
    @track estadoSol = 'Abierto';
    selectedRecords;
    @track filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    //MAX_FILE_SIZE = 1500000;

    //Esta parte es de preregistro
    @track programasList = [];
    @track solicitudList = [];
    @track requisitosLst = [];
    @track mediosAtenLst = [];
    @track relacionadoLst = [];
    @track showDep = false;
    @track labelAccordion = [];
    @track showRequistos = false;
    @track showMedios = false;
    showRelacionado = false;
    firstLoading = true;
    isFirstLoad = true;
    errors = [];
    posToggle = 0;
    activeSectionMessage = '';
    clickUrl = 'www.google.com';
    svgURL = `${SVG_WIFI}#CE2_LogoWifi`;


    //Esta parte es de preregistro///////////////////////////////////////////////////////777777
    @wire(getMatrizCases, {})
    getoptions({ error, data }) {
        if (data) {
            this.programasList = data.listProgramas;
        } else if (error) {
            this.error = error;
        }
    }
    /*
  Description: al seleccionar el programa, consulta todo el wrapper relacionado para la opcion tomada
  Params: void
  */
    selectProgram(event) {
        this.solicitudList = [];
        this.relacionadoLst = [];
        let programa = event.target.dataset.buttonId;
        this.programaReg = programa;
        //alert('programaReg::'+this.programaReg);
        let clases = event.target.classList;
        let clasesStr = event.target.className;
        clasesStr = clasesStr.replaceAll(' ', '.');
        console.log('clasesStr ' + clasesStr);
        [].forEach.call(this.template.querySelectorAll(".menulaterarl ." + clasesStr), function (value, index, array) {
            value.classList.remove("selected")
            console.log('value ' + value);

        })
        clases.add("selected");
        getSolicRelated({ program: programa })
            .then(data => {
                if (data.solicitudRelateWprLst != undefined) {
                    data.solicitudRelateWprLst.forEach(soliciWpr => {
                        this.solicitudList.push({
                            id: soliciWpr.solicitud.Id,
                            name: soliciWpr.solicitud.CE2_textoOpcion__c,
                            relacionado: soliciWpr.relacionadoConLst
                        });
                    });
                }
                console.log('this.solicitudList ' + JSON.stringify(this.solicitudList));

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error,
                        variant: 'error',
                    }),
                )
            })

        this.showDep = true;
    }

    /*
     Description: accordion padre para tipo de solicitud
     Params: void
     */
    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        //alert('openSections::'+openSections)
    }
    /*
   Description: accordion hijo para tipo de registro relacionado con
   Params: void
   */
    handleToggleRelated(event) {
        const openSections = event.detail.openSections;
        if(openSections.length>0)
        {
            let auxRelCon = JSON.stringify(openSections);
            let largorel = auxRelCon.length;
            let salida = auxRelCon.substring(2, largorel-2);
            //alert('openSectionsRelated::'+auxRelCon+' largorel::'+largorel+' salida::'+salida+' programaReg::'+this.programaReg);
            this.relacionadoCon = salida;
                extraerRequisitosSol({programaMatriz:this.programaReg,relacionadoMatriz:this.relacionadoCon,tipoSolMat:''})
                .then(data => {
                    //alert('Entro a extraerRequisitosSol');
                    let requisitos = '';
                    if (data) {
                        if(data[0].CE2_EnlaceDescarga__c){
                            this.isEnlaceDescarga = true;
                            this.vEnlaceDescarga = data[0].CE2_textoOpcion__c;
                        }
                        for (let i = 0; i < data.length; i++) {
                            requisitos = requisitos + data[i].CE2_NombreRequisito__c;
                        }
                        this.documentossoporte = requisitos;
                    } else if (error) {
                        this.error = error;
            
                    }
                })
                .catch(error => {
                    this.showLoadingSpinner = false;
                    //alert('Hubo un error extrayendo los requisitos.' + openSections + largorel);
                    const showError = new ShowToastEvent({
                        title: 'Error!!',
                        message: 'An Error occur while uploading the file.',
                        variant: 'error',
                    });
                    this.dispatchEvent(showError);
                });
        }
        
        
    }


    selectUrl(event) {
        //alert('Entro al evento');
        let butonUrl = event.target.value;
        //alert('butonUrl::'+butonUrl);
        let butonUrltarget = event.target.target;
        if(butonUrl == 'Formulario Web')
        {
            this.isPreRegistro = false;
            this.isRegistro = true;
            event.preventDefault();
        }
        //alert('butonUrl::'+butonUrl+' butonUrltarget::'+butonUrltarget);
        console.log(JSON.stringify(butonUrl));
    }
    //Esta parte es de preregistro

    //Registro starts
    @wire(getContactList)
    wiredContacts({ error, data }) {
        //alert(JSON.stringify(data));
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }
    // @wire(extraerRequisitosSol, { programaMatriz: '$programaReg', relacionadoMatriz: '$relacionadoCon', tipoSolMat: '$tipoSolicMatriz' })
    // procesarRequisitos({ error, data }) {
    //     alert('Entro a extraerRequisitosSol');
    //     let requisitos = '';
    //     if (data) {
    //         for (let i = 0; i < data.length; i++) {
    //             requisitos = requisitos + ' - ' + data[i].CE2_NombreRequisito__c;
    //         }
    //         this.documentossoporte = requisitos;
    //     } else if (error) {
    //         this.error = error;

    //     }
    // }

    @wire(getListasCiudades)
    getoptionsciudades({ error, data }) {
        //alert(JSON.stringify(data));
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.listaCiudades = [...this.listaCiudades, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;

        }
        //alert(JSON.stringify(this.listaCiudades));
    }

    @wire(getListasMediosAtencion)
    getoptionsmediosaten({ error, data }) {
        //alert(JSON.stringify(data));
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.listaMediosAten = [...this.listaMediosAten, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;

        }
        //alert(JSON.stringify(this.listaMediosAten));
    }

    @wire(getListasTiposDoc)
    getoptionstipodoc({ error, data }) {
        //alert(JSON.stringify(data));
        if (data) {
            for (let i = 0; i < data.length; i++) {
                this.listaTipoDoc = [...this.listaTipoDoc, { value: data[i].val, label: data[i].text }];
            }
        } else if (error) {
            this.error = error;

        }
        //alert(JSON.stringify(this.listaTipoDoc));
    }

    get optionsCiudades() {
        return this.listaCiudades;
    }

    get optionsTipoDoc() {
        return this.listaTipoDoc;
    }

    get optionsMediosAten() {
        return this.listaMediosAten;
    }

    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.jpeg'];
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }    
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    /* Inicio 1.0 */
    openModalFile() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpenFile = true;
    }
    closeModalFile() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpenFile = false;
    }
    /* Fin 1.0 */

    openRegistro() {
        // to open modal set isModalOpen tarck value as true
        this.isRegistro = true;
        this.isPreRegistro = false;
    }

    openModalGuarda() {
        // to open modal set isModalOpen tarck value as true
        this.isModalGuardarOpen = true;
    }
    closeModalGuardar() {
        // to close modal set isModalOpen tarck value as false
        this.isModalGuardarOpen = false;
        window.location.reload();
    }

    okModalLimpiar() {
        // to open modal set isModalOpen tarck value as true
        window.location.reload();
    }

    cancelModalLimpiar() {
        // to close modal set isModalOpen tarck value as false
        //this.isModalGuardarOpen = false;        
        this.isModalLimpiarOpen = false;
    }

    handleChangeTipoIdentif(event) {
        this.tipoDoc = event.target.value;
        let tipoDocu = '';
        tipoDocu = this.tipoDoc;
        //alert('tipoDocu'+tipoDocu);
        if (tipoDocu != '' && tipoDocu != undefined) {
            //alert('Es diferente de vacio indefinido');
            
            this.validarNumeroNit();
            
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'tipoDocu');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'tipoDocu',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'tipoDocu') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'tipoDocu',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+tipoDocu);
                this.listaCampos.push({
                    campo: 'tipoDocu',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleChangeNumIdentif(event) {
        //alert('Num ident'+event.target.value);
        this.numIdent = event.target.value;
        const numeroIdentif = this.template.querySelector('[data-id="numIdent"]');
        numeroIdentif.setCustomValidity("");
        let numIdentif = '';
        numIdentif = this.numIdent;
        //alert('numIdentif'+numIdentif);
        if (numIdentif != '' && numIdentif != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'numIdent');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'numIdent',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'numIdent') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'numIdent',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+numIdentif);
                this.listaCampos.push({
                    campo: 'numIdent',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    validarNumeroNit( ){
        let inputNumberId = this.template.querySelector('[data-id="numIdent"]');
        let numberId = inputNumberId.value;
        let tipoDocu = this.tipoDoc;
        
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

    handleChangeNomCont(event) {
        this.nomContac = event.target.value;
        let numeroCont = '';
        numeroCont = this.nomContac;
        //alert('numeroCont'+numeroCont);
        if (numeroCont != '' && numeroCont != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'nomCont');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'nomCont',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'nomCont') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'nomCont',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+numeroCont);
                this.listaCampos.push({
                    campo: 'nomCont',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleChangeEmail(event) {
        this.emailContac = event.target.value;
        let correoCont = '';
        correoCont = this.emailContac;
        //alert('correoCont'+correoCont);
        if (correoCont != '' && correoCont != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'emailContac');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'emailContac',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'emailContac') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'emailContac',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+correoCont);
                this.listaCampos.push({
                    campo: 'emailContac',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleChangeDir(event) {
        this.dirContac = event.target.value;
        let direContac = '';
        direContac = this.dirContac;
        //alert('direContac'+direContac);
        if (direContac != '' && direContac != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'dirContac');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'dirContac',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'dirContac') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'dirContac',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+direContac);
                this.listaCampos.push({
                    campo: 'dirContac',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleChangeCiudad(event) {
        this.ciudadCont = event.target.value;
        let ciudadContact = '';
        ciudadContact = this.ciudadCont;
        //alert('ciudadContact' + ciudadContact);
        if (ciudadContact != '' && ciudadContact != undefined) {
            //alert('Es diferente de vacio indefinido');
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'ciudadCont');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'ciudadCont',
                        value: event.target.value
                    });
                    //alert('Result crear::' + JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::' + ' resultado::' + resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'ciudadCont') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'ciudadCont',
                        value: event.target.value
                    });
                    //alert('Result modif::' + JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista' + ciudadContact);
                this.listaCampos.push({
                    campo: 'ciudadCont',
                    value: event.target.value
                });
                //alert('Lista creada::' + JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
    }

    handleChangeMediosAten(event) {
        this.mediosRta = event.target.value;
        let mediosAten = '';
        mediosAten = this.mediosRta;
        //alert('mediosAten'+mediosAten);
        if (mediosAten != '' && mediosAten != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'mediosRta');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'mediosRta',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'mediosRta') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'mediosRta',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+mediosAten);
                this.listaCampos.push({
                    campo: 'mediosRta',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleChangeTel(event) {
        this.telCont = event.target.value;
    }

    handleChangeCel(event) {
        this.celCont = event.target.value;
    }

    handleChangeDescrip(event) {
        //alert('inicia Descrip');
        this.descSol = event.target.value;
        let descripSol = '';
        descripSol = this.descSol;
        //alert('descripSol'+descripSol);
        if (descripSol != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'descSol');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'descSol',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'descSol') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'descSol',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+descripSol);
                this.listaCampos.push({
                    campo: 'descSol',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleHabeas(event) {
        let aux;
        aux = this.acptPolitic;
        if (aux == true) {
            this.acptPolitic = false;
        }
        else {
            this.acptPolitic = true;
        }
        let checkfinal = this.acptPolitic;
        //alert('mediosAten'+mediosAten);
        if (checkfinal != false && checkfinal != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'acptPolitic');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'acptPolitic',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'acptPolitic') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'acptPolitic',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+mediosAten);
                this.listaCampos.push({
                    campo: 'acptPolitic',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleAutoriza(event) {
        let aux;
        aux = this.autorEnvio;
        if (aux == true) {
            this.autorEnvio = false;
        }
        else {
            this.autorEnvio = true;
        }
        let checkfinal = this.autorEnvio;
        //alert('mediosAten'+mediosAten);
        if (checkfinal != false && checkfinal != undefined) {
            //alert('Es diferente de vacio indefinido');           
            if (this.listaCampos.length > 0) {
                //alert('Lista campos > 0');  
                const resultado = this.listaCampos.find(nombrecampo => nombrecampo.campo === 'autorEnvio');
                if (resultado == undefined) {
                    //alert('Entro a crear registro::');
                    this.listaCampos.push({
                        campo: 'autorEnvio',
                        value: event.target.value
                    });
                    //alert('Result crear::'+JSON.stringify(this.listaCampos));
                }
                else {
                    //alert('Entro a modificar registro::'+' resultado::'+resultado);
                    const rows = this.listaCampos;
                    for (let i = 0; i < rows.length; i++) {
                        if (rows[i].campo == 'autorEnvio') {
                            this.listaCampos.splice(i, 1);
                        }

                    }
                    this.listaCampos.push({
                        campo: 'autorEnvio',
                        value: event.target.value
                    });
                    //alert('Result modif::'+JSON.stringify(this.listaCampos));
                }

            }
            else {
                //alert('Entro a crear lista'+mediosAten);
                this.listaCampos.push({
                    campo: 'autorEnvio',
                    value: event.target.value
                });
                //alert('Lista creada::'+JSON.stringify(this.listaCampos));
            }
        }
        else {
            //alert('Entro al else');
        }
        this.handleCamposCompletos();
    }

    handleEnviar(event) {
        let inputs = true;
        let combos = true;
        let textarea = true;
        let email = this.emailContac;
        let largoNIT = this.numIdent.length;
        let tipoDoc = this.tipoDoc;
        const numeroIdentif = this.template.querySelector('[data-id="numIdent"]');
        /*if (tipoDoc == 2 && largoNIT > 9) {
            numeroIdentif.setCustomValidity("Para el tipo de identificación NIT solo puede ingresar 9 caracteres");
        }*/

        this.template.querySelectorAll('lightning-input').forEach(element => {
            //alert('element.reportValidity()::'+element);
            element.reportValidity();
            let aux = element.reportValidity()
            if (aux == false) {
                inputs = aux;
            };
        });
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.reportValidity();
            let aux = element.reportValidity()
            if (aux == false) {
                combos = aux;
            };
        });
        this.template.querySelectorAll('lightning-textarea').forEach(element => {
            element.reportValidity();
            let aux = element.reportValidity()
            if (aux == false) {
                textarea = aux;
            };
        });
        this.handleCamposCompletos();
        //alert('Entro al enviar');
        let camposcompletos = this.activo;
        if (camposcompletos == false || textarea == false || combos == false || inputs == false) {
            this.openModal();
        }
        else {
            //alert('Va a lanzar handleSaveFiles');
            this.handleSaveFiles();
        }
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

    handleLimpiar() {
        this.isModalLimpiarOpen = true;
    }

    handleMultipleFileChanges(event) {
        let files = event.target.files;
        
        if (files.length > 0) {
            window.console.log()
                let filesName = '';

                for (let i = 0; i < files.length; i++) {
                    let file = files[i];
                    
                    /* Inicio 1.0 */
                    console.log('Tamaño del archivo: ', file.size);
                    console.log('countSize 1: ', this.countFileSize);
                    this.countFileSize = this.countFileSize + file.size;
                    console.log('countSize 2: ', this.countFileSize);
                    
                    if(this.countFileSize > this.MAX_FILE_SIZE){
                        this.countFileSize = this.countFileSize - file.size;
                        console.log('countSize 3: ', this.countFileSize);
                        this.openModalFile();
                        return;
                    }

                    this.sizefilesUploaded.push({
                        Title: file.name,
                        Size: file.size
                    });
                    /* Fin 1.0 */

                    filesName = filesName + file.name + ',';
    
                    let freader = new FileReader();
                    freader.onload = f => {
                        let base64 = 'base64,';
                        let content = freader.result.indexOf(base64) + base64.length;
                        let fileContents = freader.result.substring(content);
                        this.filesUploaded.push({
                            Title: file.name,
                            VersionData: fileContents
                        });
                    };
                    freader.readAsDataURL(file);
                }
                //alert('FilesUploaded::'+JSON.stringify(this.filesUploaded));
    
                this.fileName = filesName.slice(0, -1);
        }
    }

    handleSaveFiles() {
        //alert('Entro handleSaveFiles');
        this.showLoadingSpinner = true;
        let caso = { 'sobjectType': 'Case' };
        caso.RF2_TipoIdentificacionHuerfano__c = this.tipoDoc;
        caso.RF2_NumeroIdentificacionHuerfano__c = this.numIdent;
        caso.RF2_NombreContactoHuerfano__c = this.nomContac;
        caso.RF2_CorreoelectronicoHuerfano__c = this.emailContac;
        caso.RF2_DireccionHuerfano__c = this.dirContac;
        caso.RF2_TipoSolicitud__c = this.tipoSolicform;
        caso.RF2_ProcesoDestinoMatrizResponsable__c = this.programaReg;
        caso.RF2_RelacionadoCon__c = this.relacionadoCon;
        caso.RF2_CiudadHuerfano__c = this.ciudadCont;
        caso.RF2_TelefonoHuerfano__c = this.telCont;
        caso.RF2_TelefonoMovilHuerfano__c = this.celCont;
        caso.RF2_MedioRespuesta__c = this.mediosRta;
        caso.Description = this.descSol;
        caso.RF2_Anonimo__c = false;
        caso.Origin = this.origenSol;
        caso.Status = this.estadoSol;
        caso.RF2_Autorizaenviorespuestaemail__c = this.autorEnvio;
        caso.RF2_AutorizacionHabeasData__c = this.acptPolitic;
        //alert('Previo invocar saveFiles');
        saveFiles({ idParent: this.userId, objCaso: caso, filesToInsert: this.filesUploaded })
            .then(data => {
                this.showLoadingSpinner = false;
                this.idCaso = data.Id;
                //alert('this.idCaso::' + this.idCaso);
                this.numCaso = data.CaseNumber;
                const showSuccess = new ShowToastEvent({
                    title: 'Success!!',
                    message: this.fileName + ' files uploaded successfully.',
                    variant: 'Success',
                });
                this.isModalGuardarOpen = true;
                this.dispatchEvent(showSuccess);
                //this.getFilesData(this.idCaso);
                this.fileName = undefined;
            })
            .catch(error => {
                this.showLoadingSpinner = false;
                //alert('Hubo un error creando el caso.');
                const showError = new ShowToastEvent({
                    title: 'Error!!',
                    message: 'An Error occur while uploading the file.',
                    variant: 'error',
                });
                this.dispatchEvent(showError);
            });
    }
    
    // getFilesData(caso) {
    //     traerArchivos({ idCaso: caso })
    //         .then(data => {
    //             data.forEach((record) => {
    //                 record.FileName = '/' + record.Id;
    //             });

    //             this.dataArchLst = data;
    //         })
    //         .catch(error => {
    //             window.console.log('error ====> ' + error);
    //         })
    // }

    // // Getting releated files of the current record
    // getRelatedFiles() {
    //     releatedFiles({ idParent: this.userId })
    //         .then(data => {
    //             this.data = data;
    //         })
    //         .catch(error => {
    //             this.dispatchEvent(
    //                 new ShowToastEvent({
    //                     title: 'Error!!',
    //                     message: error.message,
    //                     variant: 'error',
    //                 }),
    //             );
    //         });
    // }

    // Getting selected rows to perform any action
    getSelectedRecords(event) {
        let conDocIds;
        const selectedRows = event.detail.selectedRows;
        conDocIds = new Set();
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++) {
            conDocIds.add(selectedRows[i].ContentDocumentId);
        }

        this.selectedRecords = Array.from(conDocIds).join(',');

        window.console.log('selectedRecords =====> ' + this.selectedRecords);
    }

    handleCamposCompletos() {
        //alert('Entro a campos compeltos');
        let validacion = this.listaCampos;
        let valores = this.validaCampos;
        this.activo = true;
        let continuar = 'si';
        let centinela = 0;
        //alert('valores::' + JSON.stringify(valores));
        //alert('validacion::' + JSON.stringify(validacion));
        while (continuar == 'si' && centinela < valores.length) {
            //alert('Entro al while' + JSON.stringify(valores[centinela].campo));
            const resultado = validacion.find(nombrecampo => nombrecampo.campo == valores[centinela].campo);
            //alert('resultado::' + JSON.stringify(resultado));
            if (resultado == undefined) {
                //alert('Entro al if');
                this.activo = false;
                continuar = 'no';
                //alert('salida del if::' + this.activo + ' continuar::' + continuar);
            }
            centinela++;
            //alert('centinela++'+centinela+' valores.length::'+valores.length + ' continuar::'+continuar);
        }
        //alert('Termino el while');
    }

    removeRow(event) {
        const indexPos = event.currentTarget.name;
        //let remList = JSON.parse(JSON.stringify(this.marcaRecords));
        /* Inicio 1.0 */
        console.log('upload size: ' + this.sizefilesUploaded[indexPos].Size);
        this.countFileSize = this.countFileSize - this.sizefilesUploaded[indexPos].Size;
        this.sizefilesUploaded.splice(indexPos, 1);
        /* Fin 1.0 */
        this.filesUploaded.splice(indexPos, 1);
    }



}