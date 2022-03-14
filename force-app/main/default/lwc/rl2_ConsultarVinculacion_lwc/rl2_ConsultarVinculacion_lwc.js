import { LightningElement, api, wire, track } from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';

import getHistorialVinculaciones from "@salesforce/apex/RL2_ConsultarVinculacion_ctr.getHistorialVinculaciones";
import TIPO_DOCUMENTO_FIELD from '@salesforce/schema/Lead.CEL1_TipoDocumento__c';
import NUMERO_DOCUMENTO_FIELD from '@salesforce/schema/Lead.CEL1_NumeroDocumento__c';

export default class Rl2_ConsultarVinculacion_lwc extends LightningElement {
    @api recordId;
    @track lstVinculaciones = [];

    tipoIdentificacion = '';
    numeroIdentificacion = '';
    loading = false;
    errorMessage = '';
    showError = false;
    showVinculaciones = false;

    @wire(getRecord, { recordId: '$recordId', fields: [TIPO_DOCUMENTO_FIELD, NUMERO_DOCUMENTO_FIELD] })
    getInfoLead({ error, data }){
        if(data){
            var result = JSON.parse(JSON.stringify(data));
            this.tipoIdentificacion = result.fields.CEL1_TipoDocumento__c.value;
            this.numeroIdentificacion = result.fields.CEL1_NumeroDocumento__c.value;
            this.loading = true;
            getHistorialVinculaciones({vTipoIdentificacion:this.tipoIdentificacion,vNumeroIdentificacion:this.numeroIdentificacion})
                .then(data => {
                    if (data) {
                        if(data.length > 0){
                            this.showVinculaciones = true;
                            for (let i = 0; i < data.length; i++) {
                                this.lstVinculaciones = [...this.lstVinculaciones, { vinculacion: data[i] } ];
                            }
                            this.loading = false;
                        }else {
                            this.loading = false;
                            this.errorMessage = 'No existe información de vinculación';
                            this.showError = true;
                        }
                    } else if(error){ 
                        this.loading = false;
                        this.error = error;
                    }   
                })
                .catch(error => {
                    this.loading = false;
                    this.error = error;
                    console.log('Error -->' +JSON.stringify(error));
                });
            
        }else if(error) {
            var result = JSON.parse(JSON.stringify(error));
            console.log('Error: '+ result);
        }
    };

    handleSectionToggle(event) {
        console.log(event.detail.openSections);
        const openSections = event.detail.openSections;
    }
    
}