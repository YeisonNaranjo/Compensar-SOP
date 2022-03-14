/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para consultar cliente en SF, GC
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-18      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public class COM_ConsultarCliente_ctr {

    public  List<SelectOption>          lstTipo                     {get;set;}
    public  String                      strIdentificacion           {get;set;}
    public  Boolean                     blnCrearCliente             {get;set;}
    public  Boolean                     blnResultadosSF             {get;set;}
    public  Boolean                     blnResultadosGC             {get;set;}
    public  Boolean                     blnMensaje                  {get;set;}
    public  List<Account>               lstCuentasSF                {get;set;}
    public  Account                     accCuentasGC                {get;set;}
    public  AccounGCWrapper             accAccounGCWrapper          {get;set;}
    public  Account                     objAcc                      {get;set;}
    public  String                      strIdCuenta                 {get;set;}
    public  String                      strTipoSeleccionado         {get;set;}
    public  COM_ConsultarClienteGC_ws   clientesGC                  {get;set;}
    private  map<String, String>         mapTipDocumentos;
    private  map<String, String>         mapEstadoAfiliacion;
    
    
    private list<COM_LogTransacciones__c> lstLogs;
    //private COM_LogTransacciones__c objLog;

    public COM_ConsultarCliente_ctr() {
        strIdentificacion       = '';
        blnCrearCliente         = false;
        blnMensaje              = false;
        strIdCuenta             = '';
        strTipoSeleccionado     = '';
        lstTipo                 = new List<SelectOption>();
        objAcc  = new Account();
        accAccounGCWrapper = new AccounGCWrapper();
        //objAcc.COM_TipoIdentificacion__c = '1';
        List<COM_TiposDeDocumento__mdt> lstTipoDoc = [SELECT Valor__c, MasterLabel FROM COM_TiposDeDocumento__mdt ORDER BY Valor__c];
        mapTipDocumentos = new map<String, String>();
        for(COM_TiposDeDocumento__mdt tipDoc : lstTipoDoc){
            lstTipo.add(new SelectOption(tipDoc.Valor__c, tipDoc.MasterLabel));
            mapTipDocumentos.put(tipDoc.Valor__c, tipDoc.MasterLabel);
        }
        DescribeFieldResult schTipo = Account.COM_Estadoafiliacion__c.getDescribe();
        List<Schema.PicklistEntry> lstSchTipo = schTipo.getPicklistValues();
        mapEstadoAfiliacion = new map<String, String>();
        for( Schema.PicklistEntry valor : lstSchTipo){
            mapEstadoAfiliacion.put(valor.getValue(), valor.getLabel());
        }
        /*Schema.DescribeFieldResult schTipo = Account.COM_TipoIdentificacion__c.getDescribe();
        List<Schema.PicklistEntry> lstSchTipo = schTipo.getPicklistValues();
        for( Schema.PicklistEntry valor : lstSchTipo){
            lstTipo.add(new SelectOption(valor.getValue(), valor.getLabel()));
            mapTipDocumentos.put(valor.getValue(), valor.getLabel());
        }*/
        //lstTipo.sort();
    }
    
    public void fnConsultar() {
        blnMensaje = false;
        //strTipoSeleccionado = objAcc.COM_TipoIdentificacion__c;
        strIdentificacion = objAcc.COM_Numero_de_identificacion__c;
        
        //if(strTipoSeleccionado == '' || strIdentificacion == '') {
        if(String.isBlank(strTipoSeleccionado) || String.isBlank(strIdentificacion)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Ingrese un valor válido'));
            blnMensaje = true;
        } else {
            blnResultadosSF     = false;
            blnResultadosGC     = false;
            blnCrearCliente     = false;
            lstCuentasSF                = [SELECT
                                            Id,
                                            Name,
                                            toLabel(COM_TipoIdentificacion__c),
                                            COM_Numero_de_identificacion__c,
                                            COM_Direccion__c,
                                            Phone,
                                            toLabel(COM_Estadoafiliacion__c),
                                            COM_CausalRetiro__c,
                                            COM_FechaRetiro__c,
                                            IsPersonAccount
                                        FROM
                                            Account
                                        WHERE
                                            COM_TipoIdentificacion__c = :strTipoSeleccionado AND
                                            COM_Numero_de_identificacion__c= :strIdentificacion.trim() AND
                                            (RecordType.DeveloperName = 'COM_Juridico' OR RecordType.DeveloperName = 'COM_Natural') 
                                            //AND COM_Sucursal__c = 0 AND COM_CentroCosto__c = 0
                                    ];
            if(lstCuentasSF.isEmpty()) {
                clientesGC = new COM_ConsultarClienteGC_ws();
                try {
                    clientesGC.wprCliente = clientesGC.mapCamposCuenta(clientesGC.Consultar(Integer.valueOf(strTipoSeleccionado), Long.valueOf(strIdentificacion.trim())));
                } catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error consultando el cliente'));
                    blnMensaje = true;
                    System.debug('Error consultado los datos - >' + e.getMessage());
                }

                if (clientesGC.wprCliente != null && clientesGC.wprCliente.cuenta.COM_NAUTCLI__c != '0') {
                    accCuentasGC = clientesGC.wprCliente.cuenta;
                    accAccounGCWrapper.objCuenta = clientesGC.wprCliente.cuenta;
                    accAccounGCWrapper.strTipoDocumento = mapTipDocumentos.get(accAccounGCWrapper.objCuenta.COM_TipoIdentificacion__c);
                    accAccounGCWrapper.strEstadoAfiliacion = mapEstadoAfiliacion.get(accAccounGCWrapper.objCuenta.COM_Estadoafiliacion__c);
                    blnResultadosGC = true;
                } else {
                    blnCrearCliente = true;
                }
                
                try{
                    lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
                    if(lstLogs != null && !lstLogs.isEmpty()){
                        insert lstLogs;
                    }
                    lstLogs = new list<COM_LogTransacciones__c>();
					Cache.Org.put('local.partition1.logs', lstLogs);
                } catch(Exception e){
                    system.debug('NO SE PUDO GUARDAR EL LOG.');
                    System.Debug('====================== EXCEPCION [log COM_ConsultarCliente_ctr] ======================');
                    System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                    System.Debug('========================================================================================');
                }
            } else {
                blnResultadosSF = true;

            }
            
        }
    }

    public PageReference fnCrearCliente() {
        PageReference pagURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Account&retURL=%2F001%2Fo&save_new_url=%2F001%2Fe%3FretURL%3D%252F001%252Fo');
        pagURL.setRedirect(true);
        return pagURL;
    }
    public PageReference fnAbrir() {
        PageReference pagURL = new PageReference('/'+strIdCuenta);
        pagURL.setRedirect(true);
        return pagURL;
    }

    public PageReference fnTraerDeGC() {
        blnMensaje = false;
        String idCuenta = clientesGC.CrearCliente(clientesGC.wprCliente);
        if(idCuenta != null) {
            system.debug(idCuenta);
            PageReference pagURL = new PageReference('/' + idCuenta);
            pagURL.setRedirect(true);
            return pagURL;
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No se pudo crear el cliente'));
            blnMensaje = true;
            return null;
        }
    }
    
    public class AccounGCWrapper{
    	
    	public Account objCuenta {get; set;}
    	public String strTipoDocumento {get; set;}
    	public String strEstadoAfiliacion {get; set;}
    	
    }
}