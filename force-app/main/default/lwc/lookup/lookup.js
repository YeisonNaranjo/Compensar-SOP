import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getRecord from '@salesforce/apex/RL2_LookUp_ctr.getRecord';
import searchRecords from '@salesforce/apex/RL2_LookUp_ctr.searchRecords';
import lookUp from '@salesforce/apex/RL2_LookUp_ctr.lookUp';
const NEW_ACTION_ID = 'NEW-RELATED-RECORD';

export default class Lookup extends LightningElement {
    @api label;
    @api iconName;
    @api allowCreateNew = false;
    @api recordApiName;
    @api fields = [];
    @api metaLabelField;
    @api searchFields;
    @api disabled;
    @api required;
    @api nameField;
    @api value = '';
    @api filter = '';
    @api isPoblacion = false;
    showCreateRecord = false;
    searchString = '';
    onFocus = false;
    selectedOption;
    delayTimeout;
    items = [];
    wiredData;

    searchTerm;
    
    /*@wire(searchRecords, {valSearch: '$searchString', valObjectApiName: '$recordApiName', valFields: '$searchFields', valDefault: '$value'})
    loadItems(valData) {
        this.wiredData = valData;
        const {error, data} = valData;
        if(data) {
            this.items = data.map(i => {
                return {
                    id: i.Id,
                    icon: this.iconName,
                    label: this.getNameField(i),
                    metaLabel: this.getMetaField(i),
                    value: i.Id
                }
            });
        } else if(error) {
            console.log(error);
        }
    }*/

    @wire(lookUp, {searchTerm : '$searchString', myObject : '$recordApiName', filter : '$filter'})
    wiredRecords(result) {
        this.wiredData = result;
        const {error, data} = result;
        if (data) {
            this.items = data.map(i => {
                return {
                    id: i.Id,
                    icon: this.iconName,
                    label: this.getNameField(i),
                    metaLabel: this.getMetaField(i),
                    value: i.Id
                }
            });
        } else if (error) {
            console.log(error);
        }
    }

    get Items() {
        if(this.allowCreateNew) {
            return [...this.items, {
                id: NEW_ACTION_ID,
                icon: 'utility:add',
                label: this.NewLabel,
                metaLabel: `Create and select a new ${this.label}`,
                value: 'create-new'
            }];
        }
        return this.items;
    }

    get NewLabel() {
        return `New ${this.label}`;
    }

    get AnyOptionSelected() {
        return this.selectedOption != undefined;
    }

    get ContainerClass() {
        return `slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ${this.selectedOption == undefined && this.onFocus ? 'slds-is-open' : ''}`;
    }

    renderedCallback() {
        if(this.value && this.items) {
            this.selectedOption = this.items.find(i => i.id == this.value);
        }
    }

    handleOnFocus(e) {
        this.onFocus = true;
    }

    handleSearch(e) {
        window.clearTimeout(this.delayTimeout);
		const vSearchTerm = e.target.value;
		this.delayTimeout = setTimeout(() => {
            this.searchString = vSearchTerm;
		}, 300);
    }

    handleOnBlur(e) {
        setTimeout(() => {
            this.onFocus = false;
        }, 200);
    }

    handleOptionClick(e) {
        const vId = e.currentTarget.dataset.id;
        if(vId == NEW_ACTION_ID) {
            this.showCreateRecord = true;
        } else {
            this.selectedOption = this.items.filter(i => i.id == vId)[0];
            this.fireOnChange(this.selectedOption);
        }
    }

    handleRecordCreated(e) {
        const vId = e.detail.id;
        getRecord({recordId: vId, fields: this.fields})
        .then(valResponse => {
            this.items.unshift({
                id: vId,
                icon: this.iconName,
                label: this.getNameField(valResponse),
                metaLabel: this.getMetaField(valResponse),
                value: vId
            });
            this.selectedOption = this.items[0];
            this.showCreateRecord = false;
            this.dispatchEvent(new ShowToastEvent({
                title: `${this.NewLabel} was created successfuly!`,
                message: this.selectedOption.label,
                variant: 'success',
            }));
            refreshApex(this.wiredData);
            this.fireOnChange(this.selectedOption);
        }).catch(valError => {
            console.log(valError);
        });
    }

    handleCancelCreation(e) {
        this.showCreateRecord = false;
    }

    handleRemoveSelected(e) {
        this.selectedOption = undefined;
        this.searchString = '';
        this.fireOnChange(undefined);
    }

    fireOnChange(valValue) {
        this.dispatchEvent(new CustomEvent('change', { detail:{ value: valValue }}));
    }

    stopPropagation(e) {
        e.stopPropagation();
    }

    getMetaField(valData) {
        let vResult = '';
        if(Array.isArray(this.metaLabelField)) {
            for(let i in this.metaLabelField) {
                vResult += valData[this.metaLabelField[i].fieldApiName] + ' ';
            }
        } else {
            vResult = valData[this.metaLabelField.fieldApiName];
        }
        return vResult.trim();
    }

    getNameField(valData) {
        let vResult = '';
        if(this.nameField) {
            if(Array.isArray(this.nameField)) {
                for(let i in this.nameField) {
                    vResult += valData[this.nameField[i].fieldApiName] + ' ';
                }
            } else {
                vResult = valData[this.nameField.fieldApiName];
            }
        } else {
            vResult = valData.Name;
        }
        return vResult.trim();
    }
}