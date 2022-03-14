//filtro por rol del contacto relacionado

public with sharing class COM_OportunidadesMercadeo_ctr {

    //public List<AccountContactRelation> accClientes {get;set;}
    public List<sObject> accClientes {get;set;}
    public String lstCampos {get;set;}
    public String lstOperadores {get;set;}
    public String lstValores {get;set;}
    public Boolean blnResultados {get;set;} 
    public Boolean blnSinResultados {get;set;} 
    public Boolean blnMensaje {get;set;} 
    public Map<Id, Boolean> seleccion {get; set;} 
    public Boolean forAll {get; set;}  
    public List <SelectOption> opciones = new List <SelectOption>();
    public List <SelectOption> opciones2 = new List <SelectOption>();
    public Map<String,String> mapIdRegistro = new Map<String,String>();
    public List<FiltroAccount> lstFiltrosAcc {get; set;} 
    public Integer cantidadRegistros {get; set;}
    public String tipoRegistro {get; set;}
    public String nombreOportunidad {get; set;}
    public String returl {get; set;}
    public String idCampana {get; set;}
    public Map<Id, String> fila {get; set;} 

    /**
     * [COM_OportunidadesMercadeo_ctr description]
     * @param  objStandardController [description]
     * @return                       [description]
     */
    public COM_OportunidadesMercadeo_ctr() {
        //accClientes = new List<AccountContactRelation>();
        accClientes = new List<sObject>();
        blnResultados = false;
        blnSinResultados = false;
        blnMensaje = false;
        forAll = false;
        lstFiltrosAcc = new List<FiltroAccount>();
        seleccion = new  Map<Id, Boolean>();
        fila = new  Map<Id, String>();
        lstFiltrosAcc.add(new FiltroAccount(getCampos(), '', '', ''));
        returl = ApexPages.currentPage().getParameters().get('url');
        idCampana = ApexPages.currentPage().getParameters().get('idCam');
    }

    public String castDato(String campo){
        String tipoDato = String.valueOf(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(campo).getDescribe().getSoapType());
        Set<String> setTipoDato = new Set<String>{'ID','STRING'};
        System.debug(tipoDato);
        if(setTipoDato.contains(tipoDato.toUpperCase()))
            return '\'';
        else 
            return '';
    }

    public String operadorLike(String operador){
        if(operador == 'LIKE')
            return '%';
        else 
            return '';
    }

    /**
     * [filtrarClientes description]
     */
    public void filtrarClientes() {
        blnMensaje = false;
        forAll = false;
        accClientes.clear();
        blnResultados = false;
        blnSinResultados = false;

        /*String consulta = 'SELECT AccountId,ContactId,Roles '+
                        'FROM AccountContactRelation WHERE IsActive = true';*/
        String consulta = 'SELECT Id, Name, (SELECT Id, AccountId, Account.Name, ContactId, Contact.Name, Roles FROM AccountContactRelations WHERE IsActive = true)'+
                        'FROM Account WHERE ';
        String parametros = '';
        List<FiltroAccount> lstFiltrosAcc2 = new List<FiltroAccount>();
        for(Integer j = 0; j < lstFiltrosAcc.size(); j++){
           if(String.isNotBlank(lstFiltrosAcc.get(j).idCampoSeleccionado) && String.isNotBlank(lstFiltrosAcc.get(j).operador)){
                lstFiltrosAcc2.add(lstFiltrosAcc.get(j));
           }
        }
        lstFiltrosAcc = lstFiltrosAcc2;
        for(FiltroAccount filtro : lstFiltrosAcc){
            system.debug(filtro.idCampoSeleccionado+'-'+filtro.operador);
            if(String.isNotBlank(filtro.idCampoSeleccionado) && String.isNotBlank(filtro.operador)){
                //parametros += ' AND Account.'+filtro.idCampoSeleccionado+' '+filtro.operador+' '+castDato(filtro.idCampoSeleccionado)+operadorLike(filtro.operador)+''+filtro.valor+operadorLike(filtro.operador)+castDato(filtro.idCampoSeleccionado);
                parametros += ' AND '+filtro.idCampoSeleccionado+' '+filtro.operador+' '+castDato(filtro.idCampoSeleccionado)+operadorLike(filtro.operador)+''+filtro.valor+operadorLike(filtro.operador)+castDato(filtro.idCampoSeleccionado);
            }
            System.debug('parámetros-'+parametros+'-');
        }

        if(parametros != ''){
            
            consulta += parametros.substring(5);
            system.debug('consulta - '+consulta);
            try{ 
                List<Account> accClientesAux = new List<Account>();
                accClientesAux = Database.query(consulta);
                for(Account acc : accClientesAux){
                    accClientes.add((Account)acc);
                    for(AccountContactRelation acr : acc.AccountContactRelations){
                        accClientes.add((AccountContactRelation)acr);
                    }
                }
                
                if(accClientes.size() > 0){
                    blnResultados = true;
                    cantidadRegistros = accClientes.size();
                    //for(AccountContactRelation relacion :accClientes) 
                    for(sObject relacion :accClientes){ 
                        seleccion.Put(relacion.Id, false);
                        if(relacion instanceof Account){
                            Account accAux = (Account) relacion;
                            fila.Put(relacion.Id, accAux.Name);
                        } else {
                            AccountContactRelation acrAux = (AccountContactRelation) relacion;
                            fila.Put(relacion.Id, acrAux.Account.Name +' - '+acrAux.Contact.Name+' - '+(acrAux.Roles!=null?acrAux.Roles:''));
                        }
                    }
                        
                } else {
                    blnSinResultados = true;
                }
            } catch (Exception e) {
                blnMensaje = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error ejecuntado la consulta. '+e.getMessage()));
            }
        } else {
            blnMensaje = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Ingrese criterios de búsqueda.'));
        }
    }

    /**
     * [toggleSeleccionar description]
     */
    public void toggleSeleccionar(){ 
        for(Id idRelacion : seleccion.keySet()){ 
            seleccion.Put(idRelacion, forAll); 
        } 
    }

    /**
     * [crearOportunidades description]
     */
    public void crearOportunidades(){
        system.debug(seleccion);
        if(tipoRegistro != ' ' && nombreOportunidad != ''){
            Set<Id> idSeleccionadosCuentas = new Set<Id>();
            Set<Id> idSeleccionadosRelaciones = new Set<Id>();
            for(Id idSeleccion :seleccion.keySet()){
                if(seleccion.get(idSeleccion) == true){
                    if(String.valueOf(idSeleccion.getsobjecttype()) == 'Account'){
                        idSeleccionadosCuentas.add(idSeleccion);
                    } else {
                        idSeleccionadosRelaciones.add(idSeleccion);
                    }
                }
            }
            if(!idSeleccionadosCuentas.isEmpty() || !idSeleccionadosRelaciones.isEmpty()){
                List<AccountContactRelation> lstRelaciones = [SELECT AccountId,ContactId FROM AccountContactRelation WHERE Id IN :idSeleccionadosRelaciones];
                List<Account> lstCuentas = [SELECT Id FROM Account WHERE Id IN :idSeleccionadosCuentas];
                List<Opportunity> lstOportunidades = new List<Opportunity>();
                List<CampaignMember> lstNewMiembrosCamp = new List<CampaignMember>();
                List<CampaignMember> lstOldMiembrosCamp = new List<CampaignMember>();
                Set<Id> setIdOldContactos = new Set<Id>();
                Set<Id> setIdContactos = new Set<Id>();
                Set<Id> setIdCuentas = new Set<Id>();
                List<sObject> lstObjetos = new List<sObject>();
                for(AccountContactRelation acr : lstRelaciones) 
                    lstObjetos.add(acr);
                for(Account acc : lstCuentas) 
                    lstObjetos.add(acc);
                //for(AccountContactRelation relacion : objRelacion){
                for(sObject relacion : lstObjetos){
                    Opportunity opp = new Opportunity();
                    opp.RecordTypeId = tipoRegistro;
                    if(relacion instanceof Account){
                        Account accAux = (Account) relacion;
                        setIdCuentas.add(accAux.Id);
                        opp.AccountId = accAux.Id;
                    } else {
                        AccountContactRelation acrAux = (AccountContactRelation) relacion;
                        setIdCuentas.add(acrAux.AccountId);
                        setIdContactos.add(acrAux.ContactId);
                        opp.AccountId = acrAux.AccountId;
                        opp.Contacto__c = acrAux.ContactId;
                    }
                    opp.Name = nombreOportunidad;
                    opp.StageName = 'Registrado';
                    opp.CloseDate = System.now().date().addDays(2);
                    opp.CampaignId = idCampana;
                    //opp.COM_Canalventas__c = 'Campaña';
                    opp.COM_CicloNegocio__c = mapIdRegistro.get(tipoRegistro);
                    lstOportunidades.add(opp);  
                }                
                lstOldMiembrosCamp = [SELECT ContactId FROM CampaignMember WHERE CampaignId =:idCampana AND ContactId IN :setIdContactos];
                for(CampaignMember miembroCamp : lstOldMiembrosCamp)
                    setIdOldContactos.add(miembroCamp.ContactId);
                /*
                for(Id idCuenta : setIdCuentas){
                    Opportunity opp = new Opportunity();
                    opp.RecordTypeId = tipoRegistro;
                    opp.AccountId = idCuenta;
                    opp.Name = nombreOportunidad;
                    opp.StageName = 'Registrado';
                    opp.CloseDate = System.now().date().addDays(2);
                    opp.CampaignId = idCampana;
                    lstOportunidades.add(opp);        
                }
                */
                for(Id idContacto : setIdContactos){
                    CampaignMember camp = new CampaignMember();
                    camp.CampaignId = idCampana;
                    camp.ContactId = idContacto;
                    if(!setIdOldContactos.contains(idContacto))
                        lstNewMiembrosCamp.add(camp);
                }
                try{
                    if(!lstOportunidades.isEmpty()){
                        insert lstOportunidades;
                        insert lstNewMiembrosCamp;
                        blnMensaje = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Campaña actualizada correctamente'));
                    } else {
                        blnMensaje = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Campos Obligatorios. Seleccione un contacto.'));
                    }
                } catch(Exception e){
                    blnMensaje = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error actualizando la campaña. '+e.getMessage()));
                }
            } else {
                blnMensaje = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Campos Obligatorios. Seleccione un contacto.'));
            }
        } else {
            blnMensaje = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Campos Obligatorios. Tipo de Oportunidad y Nombre de Oportunidad.'));
        }

    }

    /**
     * [getCampos description]
     * @return [description]
     */
    public List<SelectOption> getCampos() { 
        if(opciones.isEmpty()){
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Account').getDescribe().fields.getMap();
            Set<String> setTipoDato = new Set<String>{'ID','REFERENCE'};
            for(Schema.SObjectField sfield : fieldMap.Values()){
                schema.describefieldresult dfield = sfield.getDescribe();
                if(!setTipoDato.contains(String.valueOf(dfield.getType()).toUpperCase()) && String.valueOf(dfield.getName()).right(2).toUpperCase() != 'PC' )
                    opciones.add(new SelectOption(dfield.getName(),dfield.getLabel()));
            }
            opciones.sort();
        }
        return sortSelectOptionList(opciones);  
    }

    public List<SelectOption> getTipoRegistroOpp() { 
        if(opciones2.isEmpty()){
            List<RecordType> lstRecordType = [SELECT Id, Name FROM RecordType where SobjectType = 'Opportunity' ORDER BY Name];
            for(RecordType rt : lstRecordType){
                opciones2.add(new SelectOption(rt.Id,rt.Name));
                mapIdRegistro.put(rt.Id,rt.Name);
            }
            opciones2.sort();
        }
        return sortSelectOptionList(opciones2);  
    }

        public static List<SelectOption> sortSelectOptionList(List<SelectOption> source)
    {
        List<string> sortable = new  LIst<string>();
        for(SelectOption so: source){
            sortable.Add((string.isblank(so.getLabel())?'_!':so.getLabel()) + '@!@' + (string.isblank(so.getValue())?'_!':so.getValue()));
        }
        sortable.sort();
        List<SelectOption> targetList = new  List<SelectOption>();
        for(string s: sortable){
                targetList.Add(new  SelectOption(s.split('@!@')[1].replace('_!',''), s.split('@!@')[0].replace('_!','')));
        }
        return targetList;
    }
   
   /**
    * 
    */
   public class FiltroAccount{
        public List<SelectOption> campos {get;set;}
        public String idCampoSeleccionado {get;set;}
        public String operador {get;set;}
        public String valor {get;set;} 

        public FiltroAccount(List<SelectOption> campos, String idCampoSeleccionado, String operador, String valor){
            this.campos = campos;
            this.idCampoSeleccionado = idCampoSeleccionado;                
            this.operador = operador;  
            this.valor = valor;  
        }
   }

   /**
    * [adicionarFiltro description]
    */
   public void adicionarFiltro(){
        blnMensaje = false;
        lstFiltrosAcc.add(new FiltroAccount(getCampos(), '', '', ''));
   }

   public string getObjType(Id strId){
        Schema.SObjectType objType = strId.getSobjectType();
        return String.valueOf(objType);
   }
}