/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase donde se generarn los documentos de paz y salvo 
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     01/11/2017      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/


public class COM_GenerarPazYSalvo_ctr {

    public Account objCuenta {get; set;}
    public String mensajeError  {get; set;}
    public String mensajeTransaccion  {get; set;}
    public Boolean error  {get; set;}
    public Boolean blnTransaccion  {get; set;}
    public List<SelectOption> lstValores {get; set;}
    public String valorTipoDoc  {get; set;}
    public Boolean lightning {get; set;}    
    public Boolean salesforce1 {get; set;}      

    public COM_GenerarPazYSalvo_ctr(Apexpages.Standardcontroller objStandardController) {
        String strId = (String) objStandardController.getRecord().Id;
        objCuenta = [SELECT COM_FechaAportePazSalvo__c, COM_FechaAfiliacion__c, COM_FechaRetiro__c, COM_CorreoElectronico__c, RecordType.DeveloperName
            FROM Account 
            WHERE Id = :strId
            LIMIT 1];
        /*if(UserInfo.getUiTheme() == 'Theme4d'){
            lightning = true;
        } else if(UserInfo.getUiTheme() == 'Theme4t'){
            salesforce1 = true;
        }*/
        lstValores = new List<SelectOption>();
        lstValores.add(new SelectOption('Empresas4','Empresa 4%'));
        lstValores.add(new SelectOption('EmpresasLey1429','Empresas Ley 1429'));
        lstValores.add(new SelectOption('EmpresasLey590','Empresas Ley 590'));
        if(objCuenta.RecordType.DeveloperName=='COM_Natural'){
            lstValores.add(new SelectOption('Independiente2','Independiente 2%'));
            lstValores.add(new SelectOption('Independiente06','Independiente 0.6%'));
            lstValores.add(new SelectOption('ServicioDomestico','Servicio Domestico'));
            lstValores.add(new SelectOption('Pensionado2','Pensionado 2%'));
            lstValores.add(new SelectOption('Pensionado06','Pensionado 0.6%'));
        }
        
    
        if(objCuenta.COM_FechaAportePazSalvo__c == null || objCuenta.COM_FechaAfiliacion__c == null || 
            objCuenta.COM_FechaRetiro__c == null || objCuenta.COM_CorreoElectronico__c == null){
            error = true;
            mensajeError ='<div class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_warning" role="alert">'+
          '<span class="slds-assistive-text">warning</span>'+
          '<span class="slds-icon_container slds-icon-utility-warning slds-m-right_x-small" title="Advertencia">'+
           ' <svg class="slds-icon slds-icon_x-small" aria-hidden="true">'+
            '  <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/apexpages/slds/latest/assets/icons/utility-sprite/svg/symbols.svg#warning" />'+
            '</svg>'+
          '</span>'+
          '<h2>Para generar un paz y salvo los campos "Correo Electrónico, Fecha de afiliación", "Fecha de Retiro" y "Fecha ultimo aporte paz y salvo" deben de estar diligenciados.</h2>'+
          '<button class="slds-button slds-button_icon slds-notify__close slds-button_icon-inverse" title="Close">'+
           ' <svg class="slds-button__icon" aria-hidden="true">'+
            '  <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#close" />'+
            '</svg>'+
            '<span class="slds-assistive-text">Cerrar</span>'+
          '</button>'+
        '</div>';
        } else {
            error = false;
        }
    }
    public PageReference redireccionar(){
        PageReference pageRef = new PageReference('/apex/COM_Visualizador_pag?customObjectId='+objCuenta.Id+'&tipo=PazySalvo&tipoDoc=' + valorTipoDoc);
        return pageRef;
    }
    /*
    public void fnGuardarEnviar(){
        try{
            //Crear PDF
            PageReference prfPDF = new PageReference('/apex/COM_PazySalvo_pag');
            prfPDF.getParameters().put('id', objCuenta.Id);
            prfPDF.getParameters().put('idProc', 'APO');
            prfPDF.getParameters().put('tipoDoc', valorTipoDoc);
            
            Blob blbPDF = prfPDF.getContent();
            //Adjuntar PDF al registro
            Attachment attach = new Attachment();
            attach.Body = blbPDF;
            attach.Name = 'Carta Paz y Salvo.pdf';
            attach.IsPrivate = false;
            attach.ParentId = objCuenta.Id;
            insert attach;

            set<String> setEmails;
            COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(
                'APO', 
                new set<String>{objCuenta.COM_CorreoElectronico__c}, 
                new set<Id>{attach.id}, 
                '', 
                '', 
                'CuerpoPazYSalvo', 
                getContactosCuenta(objCuenta.Id), 
                objCuenta.Id
            );  
            mensajeTransaccion = 'Documento creado correctamente';
        } catch(Exception e)        {
            mensajeTransaccion = 'Error creando el documento. '+e.getMessage();
        }
        blnTransaccion = true;
    }
    public Id getContactosCuenta(Id strAccountId)
    {
        List<AccountContactRelation> lstContactsRel = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId =: strAccountId];
        if(lstContactsRel.size() > 0)
            return lstContactsRel[0].ContactId;
        else
            return null;
    }
    */
}