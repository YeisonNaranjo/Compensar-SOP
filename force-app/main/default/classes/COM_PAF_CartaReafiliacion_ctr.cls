/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Elkin Cordoba (EC)
Proyecto:          Compensar
Descripción:       NOLA-3987 
Controlador de la página COM_PAF_CartaReafiliacion_pag 
Se imita la funcionalidad del controlador COM_PAF_CartaBienvenida_ctr 
encargado de:                    
* Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                       			          Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     27/05/18             Elkin Cordoba (EC)             			Creacion  de la Clase.
----------  -------------   ----------------------  ---------------------------------------------
2.0     17/09/20             Yeison Naranjo(YN)             			Cambio Template y campos NOLA 00020102.
2.1     29/11/21             Alvaro Gomez (alvaro.gomez@globbant.com)	Cambio valor Carta_de_reafiliacion cod. Nola 00029725
************************************************************************************************/
public class COM_PAF_CartaReafiliacion_ctr 
{
    public String   strElaboradoPor{get;set;}
    public String   strCodigoDoc{get;set;}
    public Boolean  blnPanel{get;set;}
    public String   strBody{get;set;}
    
    public Account  accCuenta;
    AccountContactRelation acrRepLegal;
    
    public String   strGenero;
    public String   strTipoDoc;
    public String   strGeneroSr;
    public String   strIdProceso;
    /* Inicio 2.0 */
    public String 	strSaludo;
    public String 	strInfoContacto;
    public String	strNombre;
    /* Fin 2.0 */
    public Case objOpp;
    
    public COM_PAF_CartaReafiliacion_ctr() 
    {
    }
    public COM_PAF_CartaReafiliacion_ctr(ApexPages.Standardcontroller controller) 
    {
        objOpp = (Case) controller.getRecord();
        strTipoDoc = ApexPages.currentpage().getparameters().get('tipoDoc');
        strIdProceso = 'PAF';
        String strIdCuenta = objOpp.AccountId;
        
        accCuenta = [SELECT
                     Name,
                     COM_TipoIdentificacion__c,
                     COM_Numero_de_identificacion__c                     
                     FROM 
                     Account 
                     WHERE 
                     Id =:strIdCuenta];
        
        acrRepLegal = [SELECT
                       Contact.Account.Name,
                       Contact.Account.COM_TipoIdentificacion__c,
                       Contact.Account.COM_Numero_de_identificacion__c, 
                       Contact.Account.COM_Genero__c,
                       Contact.Account.COM_Bloque__c,
                       Contact.Account.COM_Ciudad__r.Name, /* Inicio 2.0 */
                       Contact.Account.COM_Direccion__c, 
                       Contact.Account.COM_CorreoElectronico__c, 
                       Contact.Account.Phone, /* Fin 2.0 */
                       Contact.Account.COM_Nombre_completo_del_cliente__c,
                       Contact.Account.Owner.Name,
                       Contact.Firstname,
                       Contact.MiddleName,
                       Contact.Lastname
                       FROM 
                       AccountContactRelation 
                       WHERE 
                       Roles INCLUDES ('Representante Legal') 
                       AND AccountId = :strIdCuenta Limit 1];   
        
        blnPanel = false;
    }
    
    
    public PageReference getBody()
    {
        EmailTemplate template;
        if(strTipoDoc == 'BienvenidaA_A1')
        {
            strTipoDoc = 'Carta_de_reafiliacion';
            //Se cambia FOR-GIE- 002 por FOR-PGIE- 062 NOLA 00029725
            strCodigoDoc = Label.COM_Carta_de_reafiliacion;
        }
        else if (strTipoDoc == 'BienvenidaB_C_D') 
        {
            strTipoDoc = 'Carta_de_reafiliacion';         
            strCodigoDoc = 'FOR-GIE- 003';
        }
        else if (strTipoDoc == 'BienvenidaPensionados') 
        {
            strTipoDoc = 'Carta_de_reafiliacion';           
            strCodigoDoc = '';
        }
        else if (strTipoDoc == 'BienvenidaPrimerEmpleo') 
        {
            strTipoDoc = 'Carta_de_reafiliacion';          
            strCodigoDoc = 'FOR-GIE- 009';
        }
        
        blnPanel = strTipoDoc == 'BienvenidaPrimerEmpleo';
        try {
            template = [select id, name, Body,HTMLValue from EmailTemplate where developername =: strTipoDoc];}
        catch (Exception e) 
        {
            System.debug(e.getMessage());
            return null;
        }
        strBody = template.HTMLValue;
        if(acrRepLegal.Contact.Account.COM_TipoIdentificacion__c != '2'){
            strGenero = acrRepLegal.Contact.Account.COM_Genero__c == 'F'? 'a':acrRepLegal.Contact.Account.COM_Genero__c == 'M'? 'o': 'o'; 
            /* Inicio 2.0 */
            strSaludo = acrRepLegal.Contact.Account.COM_Genero__c == 'F'? 'Apreciada señora ' + acrRepLegal.Contact.Firstname : 'Respetado señor ' + acrRepLegal.Contact.Lastname; 
            /* Inicio 2.0 */
        } else {
            strGenero = 'o';
            /* Inicio 2.0 */
            strSaludo = 'Respetado señor ' + acrRepLegal.Contact.Lastname; 
            /* Inicio 2.0 */
        }
        strGeneroSr =  acrRepLegal.Contact.Account.COM_Genero__c == 'F'? 'a': ''; 
        
        strBody = strBody.replace('{Fecha}', System.today().day() + ' de '+ COM_CambiarALetrasUtil_cls.getMesLetras(System.today().month()) +' '+ System.today().year());
        strBody = strBody.replace('{!strGenero}', strGenero);
        strBody = strBody.replace('{!strGeneroSr}', strGeneroSr);
        strBody = strBody.replace('{!accCuenta.Name}', accCuenta.Name);
        strBody = strBody.replace('{!accCuenta.COM_Numero_de_identificacion__c}', accCuenta.COM_Numero_de_identificacion__c);
        
        /* Inicio 2.0 */
        strInfoContacto = acrRepLegal.Contact.Account.COM_Direccion__c != Null ? acrRepLegal.Contact.Account.COM_Direccion__c + '<br/>' : ' ';
        strInfoContacto = acrRepLegal.Contact.Account.COM_CorreoElectronico__c != Null ? strInfoContacto + acrRepLegal.Contact.Account.COM_CorreoElectronico__c + '<br/>' : strInfoContacto + ' ';
		strInfoContacto = acrRepLegal.Contact.Account.Phone != Null ? strInfoContacto + 'Teléfono: ' + acrRepLegal.Contact.Account.Phone + '<br/>' : strInfoContacto + ' ';
		strBody = strBody.replace('{!InfoContacto}', strInfoContacto);
        strBody = strBody.replace('{!Saludation}', strSaludo);
        /* Fin 2.0 */
        
        if(acrRepLegal.Contact.Account.COM_Ciudad__r.Name != null){
            strBody = strBody.replace('{ciudad}', acrRepLegal.Contact.Account.COM_Ciudad__r.Name);
        } else{
            strBody = strBody.replace('{ciudad}', '');
        }
            
        
        List<AccountTeamMember> lstUser = [Select User.name FROM AccountTeamMember where TeamMemberRole = 'COM_AuxiliarAdministrativoPAF' and AccountId = :objOpp.AccountId];
        
        /*List<Case> lstNombre = [SELECT Owner.Name FROM Case WHERE Id = :objOpp.Id];
strElaboradoPor = lstNombre.get(0).Owner.Name;*/
        strElaboradoPor = UserInfo.getName();
        
        if(acrRepLegal.Contact != null)
        {
            strNombre = acrRepLegal.Contact.MiddleName != Null ? acrRepLegal.Contact.Firstname + ' ' + acrRepLegal.Contact.MiddleName : acrRepLegal.Contact.Firstname;
            strBody = strBody.replace('{Nombre}', strNombre);
            strBody = strBody.replace('{Apellido}', ' '+acrRepLegal.Contact.Lastname);
        }
        
        if(strIdProceso != null)
            strBody = strBody.replace('{CodigoDoc}', COM_GenerarConsecutivo_cls.GenerarConsecutivo(strIdProceso));
        
        return null;
    }
    
}