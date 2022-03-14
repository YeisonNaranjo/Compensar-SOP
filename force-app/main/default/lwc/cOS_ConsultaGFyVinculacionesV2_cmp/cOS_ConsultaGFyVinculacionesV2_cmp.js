import { LightningElement, track, api, wire } from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';
import obtenerGrupoFamiliar from "@salesforce/apex/COS_ConsultaGFyVinculacionesV2_ctr.obtenerGrupoFamiliar";

export default class COS_ConsultaGFyVinculacionesV2_cmp extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api numidentificacion;
    @track result = [];
    @track resultV = [];
    @track resultE = [];
    @track mostrarGF;
    @track mostrarVinculacion;
    @track data;
    @track dataParentesco;
    @track homologacionTipoDoc;
    

    mostrarInfo = false;
    showError = false;
    showTipoDoc;
    showParentesco = '';
    
        
   
    connectedCallback(){
        this.fetchGrupoFamiliar();
        //this.verificarError();
    }

    verificarError(){
     
        obtenerGrupoFamiliar({registroId : this.recordId}).then(response=>{
           
        this.formatError(response.ConsultarDatosVinculacionOut.Errores);
        
      
        
    }).catch(error=>{
        console.error(error);
   })
}

    fetchGrupoFamiliar(){
            
            obtenerGrupoFamiliar({registroId : this.recordId}).then(response=>{
            console.log('INGRESO FETCHGRUPO FAMILIAR Y VINCULACION -->  ', response);
            
            if (response.ConsultarDatosVinculacionOut.Errores != null){
                this.formatError(response.ConsultarDatosVinculacionOut.Errores);
            }
            this.formatGrupoFamiliar(response.ConsultarDatosVinculacionOut.GrupoFamiliar);
            this.formatVinculacion(response.ConsultarDatosVinculacionOut.Vinculacion);
            
            
            

            
        }).catch(error=>{
            console.error(error);
       })
    }
    
    formatGrupoFamiliar(res){
      
        
        this.result = res.map((item, index)=>{
            let id = `new_${index+1}`;
            let NumeroIdentificacion = item.NumeroIdentificacion;
            let diaNacimiento = new String (item.FechaNacimiento).substring(6,8);
            let mesNacimiento = new String (item.FechaNacimiento).substring(4,6);
            let FechaNacimiento = new String (item.FechaNacimiento).substring(0,4);
            let TipoIdentificacion = item.TipoIdentificacion;
            let Genero = item.Genero;
            let Parentesco = item.Parentesco;
            
            return { ...item, id:id, NumeroIdentificacion: NumeroIdentificacion, FechaNacimiento: FechaNacimiento, mesNacimiento: mesNacimiento, 
                diaNacimiento: diaNacimiento, Genero: Genero, Parentesco:Parentesco, TipoIdentificacion:TipoIdentificacion}
        })

    }


    formatVinculacion(res){

        this.resultV = res.map((itemV, index)=>{
            let id = `new_${index+1}`;
            let diaIni = new String (itemV.FechaInicio).substring(6,8);
            let mesIni = new String (itemV.FechaInicio).substring(4,6);
            let FechaInicio = new String (itemV.FechaInicio).substring(0,4);

            let Estado = itemV.Estado;
            let Estrato = itemV.Estrato;
            return { ...itemV, id:id, Estado: Estado, Estrato: Estrato, FechaInicio:FechaInicio, diaIni:diaIni, mesIni:mesIni }
        })

    }

    formatError(res){
        
        this.resultE = res.map((itemE, index)=>{
            let id = `new_${index+1}`;
            let IdError = itemE.IdError;
            let ErrorShow = itemE.Error;      
            return { ...itemE,id:id, IdError: IdError,  ErrorShow:ErrorShow }
        })

    }


}