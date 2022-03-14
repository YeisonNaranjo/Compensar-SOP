import { LightningElement, api, track } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
export default class AttachmentsLWC extends LightningElement {
    @api vrequired;
    @api showbox;
    @api showtamanio;
    @api vmultiple;
    @api showmessage;
    @api message;
    @track activo = false;
    @track temp = 0;
    @track filesUploaded = [];

    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 3145728;
    errorMessage = '';
    isRender = false;

    get acceptedFormats() {
        return ['.xlsx', '.xls', '.png', '.pdf', '.doc', '.docx', '.jpg', '.jpeg'];
    }

    renderedCallback(){
        if(this.isRender && this.filesUploaded.length > 0){
            let vFiles = this.filesUploaded;
            this.dispatchEvent(new CustomEvent('callpasstoparent', { detail: { value: vFiles }})); 
            this.isRender = false;
        }
    }    

    removeRow(event) {
        if(this.errorMessage != '') { this.errorMessage = ''; } 
        const indexPos = event.currentTarget.name;
        this.temp = this.temp - this.filesUploaded[indexPos].Size;
        this.filesUploaded.splice(indexPos, 1);
        let vFiles = this.filesUploaded;
        this.dispatchEvent(new CustomEvent('callpasstoparent', { detail: { value: vFiles }}));      
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
                    this.isRender = true;
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
    
}