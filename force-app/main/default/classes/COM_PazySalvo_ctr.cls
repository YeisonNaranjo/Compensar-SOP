/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Controlador de la página COM_PazySalvo_ctr encargado de:
                    * Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     01/08/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
public with sharing class COM_PazySalvo_ctr 
{

    public String   strIdProceso{get;set;}  
    public String   strBody{get;set;}
    public Boolean  blnPensionado;
    public Map<String,String> mapTipoIdent;
    public String   strTipoDoc;
    public Account  objAcc;

    public COM_PazySalvo_ctr(ApexPages.Standardcontroller controller) 
    {
        objAcc = (Account) controller.getRecord();
        strTipoDoc = ApexPages.currentpage().getparameters().get('tipoDoc');
        if(strTipoDoc == 'Pensionado2'){
            strTipoDoc = 'Independiente2';
            blnPensionado = true;
        } else if(strTipoDoc == 'Pensionado06'){
            strTipoDoc = 'Independiente06';
            blnPensionado = true;
        } else {
            blnPensionado = false;
        }
        strIdProceso = 'APO';//'PAF';//ApexPages.currentpage().getparameters().get('idProc');
        System.debug('***CM*** =====>>> strTipoDoc \n'+strTipoDoc);

        List<Schema.PicklistEntry> lstTipoIdent = Account.COM_TipoIdentificacion__c.getDescribe().getPicklistValues();
        mapTipoIdent = new Map<String,String>();

        for( Schema.PicklistEntry tipoIdent : lstTipoIdent)
            mapTipoIdent.put(tipoIdent.getValue(), tipoIdent.getLabel());
    }

    public PageReference getBody()
    {
        EmailTemplate template;
        try {
            template = [select id, name, Body,HTMLValue from EmailTemplate where developername =: strTipoDoc];}
        catch (Exception e) 
        {
            System.debug(e.getMessage());
            return null;
        }
        strBody = template.HTMLValue;

        strBody = strBody.replace('{nombreEmpresa}', objAcc.Name);
        strBody = strBody.replace('{tipoDocEmpresa}', mapTipoIdent.get(objAcc.COM_TipoIdentificacion__c).split(' ',2)[1]);
        strBody = strBody.replace('{numDocEmpresa}', objAcc.COM_Numero_de_identificacion__c);
        
        if(objAcc.COM_Genero__c != null && objAcc.COM_Genero__c == 'M')
            strBody = strBody.replace('{titulo}', 'El señor');
        else if(objAcc.COM_Genero__c != null && objAcc.COM_Genero__c == 'F')
            strBody = strBody.replace('{titulo}', 'La señora');

        if(objAcc.COM_FechaAportePazSalvo__c != null)
        {
            strBody = strBody.replace('{mesCanceladoLetras}', COM_CambiarALetrasUtil_cls.getMesLetras(objAcc.COM_FechaAportePazSalvo__c.month()));
            strBody = strBody.replace('{anoCanceladoNumeros}', String.valueOf(objAcc.COM_FechaAportePazSalvo__c.year()));
        }

        if(objAcc.COM_FechaAfiliacion__c != null)
        {
            strBody = strBody.replace('{diaAfiliacionNum}', String.valueOf(objAcc.COM_FechaAfiliacion__c.day()));
            strBody = strBody.replace('{mesAfiliacionLetras}', COM_CambiarALetrasUtil_cls.getMesLetras(objAcc.COM_FechaAfiliacion__c.month()));
            strBody = strBody.replace('{anoAfiliacionNumero}', String.valueOf(objAcc.COM_FechaAfiliacion__c.year()));
        }

        if(objAcc.COM_FechaRetiro__c != null)
        {
            strBody = strBody.replace('{diaRetiroNum}', String.valueOf(objAcc.COM_FechaRetiro__c.day()));
            strBody = strBody.replace('{mesRetiroLetras}', COM_CambiarALetrasUtil_cls.getMesLetras(objAcc.COM_FechaRetiro__c.month()));
            strBody = strBody.replace('{anoRetiroNum}', String.valueOf(objAcc.COM_FechaRetiro__c.year()));
        }
        
        if(System.today().day() != 1)
            strBody = strBody.replace('{diasLetras}', COM_CambiarALetrasUtil_cls.getNumLetras(System.today().day()));
        else
            strBody = strBody.replace('a los {diasLetras} ({diasNumeros}) días', 'al primer ({diasNumeros}) día');

        strBody = strBody.replace('{diasNumeros}', String.valueOf(System.today().day()));
        strBody = strBody.replace('{mesSolicitud}', COM_CambiarALetrasUtil_cls.getMesLetras(System.today().month()));
        strBody = strBody.replace('{anoSolicitudLetras}', COM_CambiarALetrasUtil_cls.getNumLetras(System.today().year()));
        strBody = strBody.replace('{anoSolicitudNumero}', String.valueOf(System.today().year()));
        strBody = strBody.replace('{nombreResponsable}', Label.COM_ResponsablePazySalvo);
        strBody = strBody.replace('{cargoResponsable}', Label.COM_CargoRespPazySalvo);
        strBody = strBody.replace('{tipoAfiliacion}', blnPensionado?'Pensionado':'Independiente');

        if(strIdProceso != null)
            strBody = strBody.replace('{consecutivo}', COM_GenerarConsecutivo_cls.GenerarConsecutivo(strIdProceso));
        else
            strBody = strBody.replace('{consecutivo}', '');

       return null;
    }
}