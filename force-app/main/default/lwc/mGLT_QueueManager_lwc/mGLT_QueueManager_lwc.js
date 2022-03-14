import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { refreshApex } from '@salesforce/apex';
// Apex
import getActiveAgents from '@salesforce/apex/MGLT_QueueManager_ctr.getActiveAgents';
import getGroups from '@salesforce/apex/MGLT_QueueManager_ctr.getGroups';
import upsertGroupMembers from '@salesforce/apex/MGLT_QueueManager_ctr.upsertGroupMembers';
// Labels
import noActiveAgentsLabel from '@salesforce/label/c.MGLT_GestorColasMensajeSinAgentesActivos';
import userNotAuthorizedLabel from '@salesforce/label/c.MGLT_GestorColasMensajeUsuarioNoAutorizado';
import noActiveQueuesLabel from '@salesforce/label/c.MGLT_GestorColasMensajeSinColasActivas';
import noSelectedAgentMessageLabel from '@salesforce/label/c.MGLT_GestorColasMensajeSinAgentesSeleccionados';
import successUpdateMessageLabel from '@salesforce/label/c.MGLT_GestorColasMensajeActualizacionSatisfactoria';
import expandAllOptionNameLabel from '@salesforce/label/c.MGLT_GestorColasNombreOpcionExpandirTodo';
import collapseAllOptionNameLabel from '@salesforce/label/c.MGLT_GestorColasNombreOpcionContraerTodo';

export default class mGLT_QueueManager_lwc extends LightningElement {
    @track isLoading                = true;
    @track noSelectedAgentMessage   = noSelectedAgentMessageLabel;
    @track successUpdateMessage     = successUpdateMessageLabel;
    @track expandAllOptionName      = expandAllOptionNameLabel;
    @track collapseAllOptionName    = collapseAllOptionNameLabel;

    // Agent attributes
    @track agentColumns = [
        {
            label: 'AGENTE',
            fieldName: 'strAgentName',
            type: 'text',
            sortable: true
        }
    ];
    @track activeAgents;
    @track activeAgentsResult;
    @track hasActiveAgents          = false;
    @track hasNoActiveAgents        = false;
    @track noActiveAgentsMessage    = noActiveAgentsLabel;
    @track isAuthorized             = false;
    @track isNotAuthorized          = false;
    @track userNotAuthorizedMessage = userNotAuthorizedLabel;
    @track agentSelectedRows;

    // Modal attributes
    @track openModal                = false;
    @track isLoadingModal           = true;
    @track queueColumns             = [
        {
            label: 'NOMBRE DE LA COLA',
            fieldName: 'strGroupName',
            type: 'text',
            sortable: true
        },
        {
            label: 'NOMBRE DEL AGENTE',
            fieldName: 'strAgentName',
            type: 'text',
            sortable: true
        }
    ];
    @track activeQueues;
    @track hasActiveQueues          = false;
    @track hasNoActiveQueues        = false;
    //@track selectedAgentRowsAux     = [];
    @track queueSelectedRows        = [''];
    @track queueExpandedRows        = [''];
    @track noActiveQueuesMessage    = noActiveQueuesLabel;

    get changeQueueInfoText() {
        let selectedRowCount = Array.isArray(this.agentSelectedRows) ? this.agentSelectedRows.length : 0;
        if (selectedRowCount === 1) {
            return "Cambiar asignaciones para " + selectedRowCount + " agente seleccionado";
        } else if (selectedRowCount > 1) {
            return "Cambiar asignaciones para " + selectedRowCount + " agentes seleccionados";
        }
        return '';
    }

    @wire(getActiveAgents, {})
    wiredContent(result) {
        this.activeAgentsResult = result;
        // console.log("activeAgentsResult" + JSON.stringify(this.activeAgentsResult));

        if (result.error) {
            this.isLoading = false;
            console.log("error: " + JSON.stringify(result.error));
            this.showToast('Error al consultar los agentes activos', result.error.body.message, 'error', 'dismissable');
        } else if (result.data) {
            this.isLoading = false;
            // console.log("data: " + JSON.stringify(result.data));
            this.isAuthorized       = result.data.blnIsAuthorized;
            this.isNotAuthorized    = !result.data.blnIsAuthorized;
            if (this.isAuthorized === true) {
                this.activeAgents   = result.data.lstAgentWrapper;
                if (this.activeAgents.length > 0) {
                    this.hasActiveAgents    = true;
                    this.hasNoActiveAgents  = false;
                } else {
                    this.hasActiveAgents    = false;
                    this.hasNoActiveAgents  = true;
                }
            }
        }
    }

    changeQueues() {
        // console.log("changeQueues");

        [...this.template.querySelectorAll('lightning-datatable')].forEach(eachDataTable => {
            this.agentSelectedRows = eachDataTable.getSelectedRows();
        });
        // console.log("agentSelectedRows: " + JSON.stringify(this.agentSelectedRows));
        //console.log("selectedAgentRowsAux: " + JSON.stringify(this.selectedAgentRowsAux));

        if (this.agentSelectedRows === undefined || this.agentSelectedRows === null || (Array.isArray(this.agentSelectedRows) && this.agentSelectedRows.length === 0)) {
            this.showToast('', this.noSelectedAgentMessage, 'error', 'dismissable');
        } else {
            this.openModal = true;
            this.queryGroups();
        }
    }

    queryGroups() {
        // console.log("queryGroups");
        this.isLoadingModal = true;
        this.queueSelectedRows = new Array();
        this.queueExpandedRows = new Array();

        getGroups({ lstAgentWrapper: this.agentSelectedRows })
        .then(result => {
            this.isLoadingModal = false;
            // console.log("getGroups result: " + JSON.stringify(result));

            let tempJSON = JSON.parse(JSON.stringify(result.lstGroupWrapper).split('lstGroupWrapper').join('_children'));
            //console.log("tempJSON: " + JSON.stringify(tempJSON));
            this.activeQueues = tempJSON;

            if (this.activeQueues.length > 0) {
                this.hasActiveQueues    = true;
                this.hasNoActiveQueues  = false;
                this.queueSelectedRows  = JSON.parse(JSON.stringify(result.lstSelectedRows));
                this.queueExpandedRows  = JSON.parse(JSON.stringify(result.lstSelectedRows));
                //console.log("queueSelectedRows: " + JSON.stringify(this.queueSelectedRows));
            } else {
                this.hasActiveQueues    = false;
                this.hasNoActiveQueues  = true;
            }
        })
        .catch(error => {
            this.isLoadingModal = false;
            console.log("error: " + JSON.stringify(error));
            this.showToast('Error al consultar las colas', error.body.message, 'error', 'dismissable');
        });
    }

    handleExpandAll(event) {
        const treeGrid = this.template.querySelector('lightning-tree-grid');
        treeGrid.expandAll();
    }

    handleCollapseAll(event) {
        const treeGrid = this.template.querySelector('lightning-tree-grid');
        treeGrid.collapseAll();
    }

    handleOnRowSelection(event) {
        console.log("handleOnRowSelection");
        let selectedRows = event.detail.selectedRows;
        // console.log("selectedRows: " + JSON.stringify(event.detail.selectedRows));

        let mapSelectedGroups = new Map();
        selectedRows.forEach(function(selectedRow) {
            // console.log("selectedRow: " + JSON.stringify(selectedRow));
            if (!mapSelectedGroups.has(selectedRow.strGroupId)) {
                mapSelectedGroups.set(selectedRow.strGroupId, new Set());
            }
            if (selectedRow.level === 2) {
                mapSelectedGroups.get(selectedRow.strGroupId).add(selectedRow.strUniqueId);
            }
        });

        // console.log("activeQueues: " + JSON.stringify(this.activeQueues));
        let selectedAgentCount;
        this.activeQueues.forEach(function(activeQueue) {
            // console.log("activeQueue: " + JSON.stringify(activeQueue));
            selectedAgentCount = mapSelectedGroups.has(activeQueue.strGroupId) ? mapSelectedGroups.get(activeQueue.strGroupId).size : 0;
            activeQueue.intSelectedAgentCount = selectedAgentCount;
            activeQueue.strAgentName = selectedAgentCount + " de " + activeQueue.intTotalAgentCount + " agentes seleccionados";
            // console.log("activeQueue updated: " + JSON.stringify(activeQueue));
        });

        this.activeQueues = JSON.parse(JSON.stringify(this.activeQueues));
        // console.log("activeQueues updated: " + JSON.stringify(this.activeQueues));

        let queueSelectedRows = new Array();
        mapSelectedGroups.forEach((group, groupId, map) => {
            // console.log("groupId: " + groupId);
            if (group.size > 0) {
                // console.log("tiene agentes: " + group.size);
                queueSelectedRows.push(groupId);
                group.forEach((uniqueId, uniqueIdAganin, set) => {
                    queueSelectedRows.push(uniqueId);
                });
            }
        });

        this.queueSelectedRows = JSON.parse(JSON.stringify(queueSelectedRows));
        // console.log("queueSelectedRows updated: " + JSON.stringify(this.queueSelectedRows));
    }

    confirmChanges() {
        // console.log("confirmChanges");
        this.isLoadingModal = true;

        let selectedRows = this.template.querySelector('lightning-tree-grid').getSelectedRows();
        // console.log("selectedRows: " + JSON.stringify(selectedRows));

        upsertGroupMembers({ lstGroupWrapper: JSON.parse(JSON.stringify(this.activeQueues).split('_children').join('lstGroupWrapper')), lstGroupWrapperSelected: selectedRows })
        .then(result => {
            this.closeModal();
            this.cancel();
            this.showToast('', this.successUpdateMessage, 'success', 'dismissable');
        })
        .catch(error => {
            this.isLoadingModal = false;
            console.log("error: " + JSON.stringify(error));
            this.showToast('Error al actualizar las colas', error.body.message, 'error', 'dismissable');
        });
    }

    cancel() {
        const cancelEvent = new CustomEvent('cancel', {
            detail: {},
        });
        /*console.log("selectedAgentRowsAux: " + JSON.stringify(this.selectedAgentRowsAux));
        console.log(this.selectedAgentRowsAux);
        console.log('.... va a buscar datatable');
        [...this.template.querySelectorAll('lightning-datatable')].forEach(eachDataTable => {
            console.log('.... va a deseleccionar');
            console.log(eachDataTable);
            try {
                if (eachDataTable.getSelectedRows() === undefined || eachDataTable.getSelectedRows() === null || (Array.isArray(eachDataTable.getSelectedRows()) && eachDataTable.getSelectedRows().length === 0)) {
                    this.showToast('', 'ooooooooooooooooooo', 'error', 'dismissable');
                } else{
                    console.log('===============');
                    eachDataTable.getSelectedRows().splice(0,eachDataTable.getSelectedRows().length)
                }
            } catch(err) {
                console.error('ERROR: ', err);
                console.log("ERR: " + JSON.stringify(err));
            }
            console.log('.... deselecciono');
        });*/

        this.dispatchEvent(cancelEvent);
        this.openModal = false;
    }

    closeModal() {
        this.openModal      = false;
        this.isLoadingModal = false;
    }

    showToast(title, message, variant, mode) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: mode
            })
        );
    }

    @api
    refreshAgentList() {
        // console.log("refreshAgentList");
        refreshApex(this.activeAgentsResult);
    }
}