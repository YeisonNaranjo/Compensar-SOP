/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Controlador de la página COM_PAF_CartaBienvenida_pag encargado de:
                    * Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.1     08/08/17             Cristian David Mejia (CM)                Modificación Clase.
    1.2     26/03/18             Stifen Panche (SP)                    	  La firma del asesor PAF del equipo de cuenta.
    2.0     25/10/18             Jordan Parra (JP)                   	  Se adicionan 4 cartas de bienvenida para pensionados e independientes.
	2.1     27/09/21			 Alvaro Gomez (alvaro.gomez@globant.com)  Se agrega tipo de documento y numero de documento a cartas de bienvenida - Ticket 28366 
************************************************************************************************/
public class COM_PAF_CartaBienvenida_ctr 
{
    public String   strElaboradoPor{get;set;}
    public String   strCodigoDoc{get;set;}
    public Boolean  blnPanel{get;set;}
    public String   strBody{get;set;}

    //Inicio NOLA-1791 - Se consulta la relacion cuenta-contacto del representatnte legal de la cuenta de la oportunidad y ya no la cuenta de la Oportunidad
    public Account  accCuenta;
    AccountContactRelation acrRepLegal;
    //Fin NOLA-1791

    public String   strGenero;
    public String   strTipoDoc;
    public String   strGeneroSr;
    public String   strIdProceso;
    public Opportunity objOpp;



    public COM_PAF_CartaBienvenida_ctr() 
    {
    }
    public COM_PAF_CartaBienvenida_ctr(ApexPages.Standardcontroller controller) 
    {
        objOpp = (Opportunity) controller.getRecord();
        strTipoDoc = ApexPages.currentpage().getparameters().get('tipoDoc');
        strIdProceso = 'PAF';//ApexPages.currentpage().getparameters().get('idProc');
        String strIdCuenta = objOpp.AccountId;
        //Inicio NOLA-1791 - Se deja de consultar la cuenta de la Oportunidad
        //Se consulta la relacion cuenta-contacto del representatnte legal de la cuenta de la oportunidad
        /*accCuenta = [SELECT 
                        Name,
                        COM_TipoIdentificacion__c,
                        COM_Numero_de_identificacion__c, 
                        COM_Genero__c,
                        COM_Bloque__c,
                        COM_Ciudad__r.Name,
                        COM_Nombre_completo_del_cliente__c,
                        Owner.Name,
                        (SELECT Contact.Name,Contact.Lastname FROM AccountContactRelations WHERE Roles INCLUDES ('Representante Legal') AND isActive = true Limit 1)
                    FROM 
                        Account 
                    WHERE 
                        Id =:strIdCuenta];*/

        accCuenta = [SELECT
                        Name,
                        toLabel(COM_TipoIdentificacion__c),
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
                            Contact.Account.COM_Ciudad__r.Name,
                            Contact.Account.COM_Nombre_completo_del_cliente__c,
                            Contact.Account.Owner.Name,
                            Contact.Name,
                            Contact.Lastname
                        FROM 
                            AccountContactRelation 
                        WHERE 
                            Roles INCLUDES ('Representante Legal') 
                            AND AccountId = :strIdCuenta Limit 1];   
        //Fin NOLA-1791
        
        blnPanel = false;
    }

    //Inicio NOLA-1791 - Se deja de consultar la cuenta de la Oportunidad
    /*
    public PageReference getBody()
    {
        EmailTemplate template;
        //strTipoDoc = 'BienvenidaPrimerEmpleo';
        if(strTipoDoc == 'BienvenidaA_A1')
        {
            strTipoDoc = 'BienvenidaA_A1';
            strCodigoDoc = 'FOR-PAF- 002';
        }
        else if (strTipoDoc == 'BienvenidaB_C_D') 
        {
            strTipoDoc = 'BienvenidaB_C_D';         
            strCodigoDoc = 'FOR-PAF- 003';
        }
        else if (strTipoDoc == 'BienvenidaPensionados') 
        {
            strTipoDoc = 'BienvenidaPensionados';           
            strCodigoDoc = '';
        }
        else if (strTipoDoc == 'BienvenidaPrimerEmpleo') 
        {
            strTipoDoc = 'BienvenidaPrimerEmpleo';          
            strCodigoDoc = 'FOR-PAF- 009';
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
        if(accCuenta.COM_TipoIdentificacion__c != '2')
            strGenero =  accCuenta.COM_Genero__c == 'F'? 'a':accCuenta.COM_Genero__c == 'M'? 'o': ''; 
        else
            strGenero = 'o';
        strGeneroSr =  accCuenta.COM_Genero__c == 'F'? 'a': ''; 

        strBody = strBody.replace('{Fecha}', System.today().day() + ' de '+ COM_CambiarALetrasUtil_cls.getMesLetras(System.today().month()) +' '+ System.today().year());
        strBody = strBody.replace('{!strGenero}', strGenero);
        strBody = strBody.replace('{!strGeneroSr}', strGeneroSr);
        strBody = strBody.replace('{!accCuenta.Name}', accCuenta.Name);
        strBody = strBody.replace('{!accCuenta.COM_Numero_de_identificacion__c}', accCuenta.COM_Numero_de_identificacion__c);

        if(accCuenta.COM_Ciudad__r.Name != null)
            strBody = strBody.replace('{ciudad}', accCuenta.COM_Ciudad__r.Name);
        
        List<Opportunity> lstNombre = [SELECT Owner.Name FROM Opportunity WHERE Id = :objOpp.Id];
        strElaboradoPor = lstNombre.get(0).Owner.Name;
                
        if(!accCuenta.AccountContactRelations.isEmpty())
        {
            strBody = strBody.replace('{Nombre}', accCuenta.AccountContactRelations[0].Contact.Name);
            strBody = strBody.replace('{Apellido}', ' '+accCuenta.AccountContactRelations[0].Contact.Lastname);
        }

        if(strIdProceso != null)
            strBody = strBody.replace('{CodigoDoc}', COM_GenerarConsecutivo_cls.GenerarConsecutivo(strIdProceso));
        /*
         Esto nunca va a suceder el valor siempre esta lleno   
         else
            strBody = strBody.replace('{CodigoDoc}', '22');
            */
        /*
        return null;
    }*/

    //NOLA-1791
    //Se consulta la relacion cuenta-contacto del representatnte legal de la cuenta de la oportunidad
    public PageReference getBody()
    {
        EmailTemplate template;
        //strTipoDoc = 'BienvenidaPrimerEmpleo';
        if(strTipoDoc == 'BienvenidaA_A1')
        {
            strTipoDoc = 'BienvenidaA_A1';
            strCodigoDoc = 'FOR-PAF- 002';
        }
        else if (strTipoDoc == 'BienvenidaB_C_D') 
        {
            strTipoDoc = 'BienvenidaB_C_D';         
            strCodigoDoc = 'FOR-PAF- 003';
        }
        else if (strTipoDoc == 'BienvenidaPensionados') 
        {
            strTipoDoc = 'BienvenidaPensionados';           
            strCodigoDoc = '';
        }
        else if (strTipoDoc == 'BienvenidaPrimerEmpleo') 
        {
            strTipoDoc = 'BienvenidaPrimerEmpleo';          
            strCodigoDoc = 'FOR-PAF- 009';
        }
//Inicio V2.0
        else if (strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Independientes_0_6') 
        {
            strTipoDoc = 'Bienvenida_Carta_de_Aceptaci_n_Independientes_0_6';         
            strCodigoDoc = 'FOR-PAF- 017';
        }
        else if (strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Independientes_2_004') 
        {
            strTipoDoc = 'Bienvenida_Carta_de_Aceptaci_n_Independientes_2_004';         
            strCodigoDoc = 'FOR-PAF- 016';
        }
        else if (strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_0_6') 
        {
            strTipoDoc = 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_0_6';         
            strCodigoDoc = 'FOR-PAF- 019';
        }
        else if (strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_2') 
        {
            strTipoDoc = 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_2';         
            strCodigoDoc = 'FOR-PAF- 018';
        }
//Fin V2.0

        //blnPanel = strTipoDoc == 'BienvenidaPrimerEmpleo';
        blnPanel = strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_2';
        try {
            template = [select id, name, Body,HTMLValue from EmailTemplate where developername =: strTipoDoc];
            System.debug('Stif ' + template);
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
            return null;
        }
        strBody = template.HTMLValue;
        System.debug('Stif 3 ' + strBody);
        if(acrRepLegal.Contact.Account.COM_TipoIdentificacion__c != '2')
            strGenero =  acrRepLegal.Contact.Account.COM_Genero__c == 'F'? 'a':acrRepLegal.Contact.Account.COM_Genero__c == 'M'? 'o': ''; 
        else
            strGenero = 'o';
        strGeneroSr =  acrRepLegal.Contact.Account.COM_Genero__c == 'F'? 'a': ''; 

        strBody = strBody.replace('{Fecha}', System.today().day() + ' de '+ COM_CambiarALetrasUtil_cls.getMesLetras(System.today().month()) +' '+ System.today().year());
        strBody = strBody.replace('{!strGenero}', strGenero);
        strBody = strBody.replace('{!strGeneroSr}', strGeneroSr);
        strBody = strBody.replace('{!accCuenta.Name}', accCuenta.Name);
        strBody = strBody.replace('{!accCuenta.COM_Numero_de_identificacion__c}', accCuenta.COM_Numero_de_identificacion__c);
        /*Inicio 2.1*/
        String tipoID_raw= accCuenta.COM_TipoIdentificacion__c;
        String procesado =  tipoID_raw.replace('-', ' ');
        String []id_type_pro = procesado.split('\\s');
        strBody = strBody.replace('{TipoIdentificacion}', id_type_pro[0]);
        strBody = strBody.replace('{NumeroIdentificacion}', accCuenta.COM_Numero_de_identificacion__c);
        /*Fin 2.1*/

        if(acrRepLegal.Contact.Account.COM_Ciudad__r.Name != null)
            strBody = strBody.replace('{ciudad}', acrRepLegal.Contact.Account.COM_Ciudad__r.Name);
        
        /*Inicio 1.1*/
       /* List<Opportunity> lstNombre = [SELECT Owner.Name FROM Opportunity WHERE Id = :objOpp.Id];
         strElaboradoPor = lstNombre.get(0).Owner.Name;*/
          
          List<AccountTeamMember> lstUser = [Select User.name FROM AccountTeamMember where TeamMemberRole = 'COM_AuxiliarAdministrativoPAF' and AccountId = :objOpp.AccountId];
         
          if(!lstUser.isEmpty() && lstUser != null)
          {
             strElaboradoPor = lstUser.get(0).User.Name;
          }
          else
          {
           List<Opportunity> lstNombre = [SELECT Owner.Name FROM Opportunity WHERE Id = :objOpp.Id];
            strElaboradoPor = lstNombre.get(0).Owner.Name;
          }
        
        /*Fin 1.1*/
                
        if(acrRepLegal.Contact != null)
        {
            strBody = strBody.replace('{Nombre}', acrRepLegal.Contact.Name);
            strBody = strBody.replace('{Apellido}', ' '+acrRepLegal.Contact.Lastname);
        }

        if(strIdProceso != null)
            strBody = strBody.replace('{CodigoDoc}', COM_GenerarConsecutivo_cls.GenerarConsecutivo(strIdProceso));
        /*
         Esto nunca va a suceder el valor siempre esta lleno   
         else
            strBody = strBody.replace('{CodigoDoc}', '22');
            */

        return null;
    }
    //Fin NOLA-1791
}