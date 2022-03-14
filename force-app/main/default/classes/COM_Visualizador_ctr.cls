/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<jsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para visualizar PDFs
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-18      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.1     2017-08-03      Cristian David Mejia (CM)       Ajuste al método fnGuardarEnviar
* @version  1.2     2018-10-01      Stifen Panche (SP)              Envía Id padre.
* @version  1.3     2019-05-10      Sebastian Cubillos (SC)         Adjuntar nuevo PDF a categorias A,A1,B,C,D.
* @version  1.4     2019-09-23      Paula Bohórquez (PB)	        Migración Lightning - Se reemplazan Attachments por Content Documents.
* @version  2.0     2021-04-13      Yeison Naranjo (YN)	        	No enviar portafolio.
* @version	3.0		2021-10-08		Yeison Naranjo (YN)				No guardar y enviar Opp <> Autorizada
***************************************************************************************************************/

public without sharing class COM_Visualizador_ctr {

    public      String                          strIdCustomObject       {get;set;}
    public      String                          strTipoDocumento        {get;set;}
    public      String                          srtUrlPagina            {get;set;}
    /* Inicio 3.0 */
    public		String							stageOpp				{get;set;}
    /* Fin 3.0 */
    public      List<String>                    lstCorreo               {get;set;}
    private     COM_NavegacionVisualizadorM__mdt    confDoc;

    /** Las urls de la configuracion personalizada.**/
    @TestVisible  private String strTipoDoc;
    private List<COM_NavegacionVisualizadorM__mdt> lstUrls;
    private Map<String,Schema.SobjectType> mapSObjectType;

    private String strIdCotizacion;
    
    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}
    /**
* @author Rubén Suárez Forero (jsuarez@avanxo.com)
* @version 1.0
* @description Constructor
* @return 
**/
    public COM_Visualizador_ctr() {
        strIdCustomObject = ApexPages.currentpage().getparameters().get('customObjectId');
        strTipoDocumento = ApexPages.currentpage().getparameters().get('tipo');
        strTipoDoc = ApexPages.currentpage().getparameters().get('tipoDoc');
        strIdCotizacion = ApexPages.currentpage().getparameters().get('idCotizacion');
		/* Inicio 3.0 */
        stageOpp = ApexPages.currentpage().getparameters().get('stageOpp');
        /* Fin 3.0 */
        System.debug('***CM*** =====>>> strTipoDoc \n'+strTipoDoc);
        System.debug('***CM*** =====>>> strTipoDocumento \n'+strTipoDocumento);
        System.debug('***CM*** =====>>> strIdCustomObject \n'+strIdCustomObject);
        System.debug('***CM*** =====>>> strIdCotizacion \n'+strIdCotizacion);
        System.debug('***CM*** =====>>> stageOpp \n'+stageOpp);
        //lstUrls = COM_NavegacionVisualizador__c.getAll().values();
        srtUrlPagina = obtenerURL(strTipoDocumento);

        if (strTipoDoc != null) {
            srtUrlPagina += '&tipoDoc='+strTipoDoc;
        }

        if(strIdCotizacion != null){
            srtUrlPagina += '&idCotizacion='+strIdCotizacion;
        }

        mapSObjectType = new Map<String,Schema.SobjectType>();
        for (Schema.SobjectType objType: Schema.getGlobalDescribe().values())
        {
            mapSObjectType.put(objType.getDescribe().getKeyPrefix(),objType);
        }
    }

    /**
* @author Rubén Suárez Forero (jsuarez@avanxo.com)
* @version 1.0
* @description Calculo del superávit
* @return String Devuelve url del PDF a visualizar
**/
    public String obtenerURL(String tipo){
        confDoc = obtenerCustomSettingPorTipo(tipo);
        if(confDoc != null)
            return confDoc.COM_Url_PDF__c + '?' + confDoc.COM_QUERY_PARAMS__c + '='+ strIdCustomObject;
        else
                return '';
        //return 'COM_PAF_CartaBienvenida_pag?accountID='+strIdCustomObject;
    }

    /**
* @description Metodo encargado de obtener una configuracion personalizada por tipo.
* @param tipo el tipo de reporte que desea generar.
* @return la custom setting obtenida.
*/
    public COM_NavegacionVisualizadorM__mdt obtenerCustomSettingPorTipo(String tipo)
    {
        List<COM_NavegacionVisualizadorM__mdt> lstUrls = [Select COM_Url_PDF__c, COM_QUERY_PARAMS__c, COM_IdProceso__c, COM_Nombre_Adjunto_Email__c, COM_AsuntoEmail__c From COM_NavegacionVisualizadorM__mdt where developerName =: tipo];
        system.debug('lstUrls--'+lstUrls);
        if(!lstUrls.isEmpty()) return lstUrls.get(0);
        return null;
    }

    /**
* @version 1.1
* @description Metodo encargado de obtener el correo al cual se deben enviar el documento
* @String strAccountId => Id de la cuenta que se esta consultando
* @return set<String> => Set con los correo de los representantes legales
*/
    public set<String> getEmailsRepLegales(String strAccountId)
    {
        set<String> setEmails = new set<String>();
        List<AccountContactRelation> lstContactsRel = [SELECT Id, Account.RecordType.DeveloperName, Account.COM_CorreoElectronico__c, RF2_CorreoCorporativo__c FROM AccountContactRelation WHERE AccountId =: strAccountId AND Roles INCLUDES ('Representante Legal') AND isActive = true];
        for(AccountContactRelation objContactRel : lstContactsRel)
        {
            if(objContactRel.RF2_CorreoCorporativo__c != null)
                setEmails.add(objContactRel.RF2_CorreoCorporativo__c);
            if(objContactRel.Account.RecordType.DeveloperName == 'COM_Juridico'){
                if(objContactRel.Account.COM_CorreoElectronico__c != null && objContactRel.Account.COM_CorreoElectronico__c != objContactRel.RF2_CorreoCorporativo__c)
                    setEmails.add(objContactRel.Account.COM_CorreoElectronico__c);
            }
        }
        //Verificación si es empresa jurídica para enviar correo a esta dirección también. - NOLA-2086
        /*List<RecordType> idJuridico = [SELECT Id FROM RecordType where Name = 'Jurídico'];
List<Account> lstAccount = [SELECT COM_CorreoElectronico__c,RecordTypeId FROM Account WHERE Id =: strAccountId];
for(Account objAccount : lstAccount)
{
if(objAccount.RecordTypeId == idJuridico.get(0).Id){
if(objAccount.COM_CorreoElectronico__c != null){
setEmails.add(objAccount.COM_CorreoElectronico__c);
}
}
}*/
        //END

        return setEmails;
    }

    public set<String> getEmailsCuenta(String strAccountId)
    {
        set<String> setEmails = new set<String>();
        List<Account> lstAccount = [SELECT COM_CorreoElectronico__c FROM Account WHERE Id =: strAccountId];
        for(Account objAccount : lstAccount)
        {
            setEmails.add(objAccount.COM_CorreoElectronico__c);
        }
        return setEmails;
    }

    /**
* @author Rubén Suárez Forero (jsuarez@avanxo.com)
* @version 1.0
* @description Adjuntar PDF al registro y enviar el PDF por mail
* @return 
**/
    public void fnGuardarEnviar()
    {
        set<id> attachSet = new set<id>();
        //Crear PDF
        //PageReference prfPDF = Page.COM_PAF_CartaBienvenida_pag;
        PageReference prfPDF = new PageReference('/apex/'+srtUrlPagina);
        //obtenerURL(strTipoDocumento);
        prfPDF.getParameters().put(confDoc.COM_QUERY_PARAMS__c, strIdCustomObject);
        prfPDF.getParameters().put('idProc', confDoc.COM_IdProceso__c);
        System.debug('***CM*** =====>>> strTipoDoc \n'+strTipoDoc);
        System.debug('***CM*** =====>>> strIdCustomObject \n'+strIdCustomObject+'\n ---');
        if(strTipoDoc != null)
            prfPDF.getParameters().put('tipoDoc', strTipoDoc);
        //prfPDF.setRedirect(true);
        Blob blbPDF;
        if(!Test.isRunningTest()){
            blbPDF = prfPDF.getContent();
        }else{
            blbPDF = Blob.valueOf('EL PDF');
        }

        System.debug('---->>> PB >> BLOB PDF: '+blbPDF);

        //AVX PB 23-09-19 - Ajuste migración Lightning INICIO
        Attachment attach = new Attachment();
        list<Attachment> listAtach = new list<Attachment>();

        ContentVersion objContentVersion = new ContentVersion();
        List<ContentVersion> lstContentV = new List<ContentVersion>();
        String strObject = mapSObjectType.get(strIdCustomObject.left(3)).getDescribe().getName();
        
        //AVX PB 23-09-19 - Ajuste migración Lightning FIN
        //Inicio V1.3.
        if(strObject == 'Quote' || strTipoDoc == 'BienvenidaA_A1' || strTipoDoc == 'BienvenidaB_C_D' || strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_0_6' || strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_2' || strTipoDoc == 'FichaTecnica')
        {
            String docBienvenida;
            //AVX PB 23-09-19 - Ajuste migración Lightning INICIO
            /* attach.Body = blbPDF;
             attach.Name = confDoc.COM_Nombre_Adjunto_Email__c+'.pdf';
             attach.IsPrivate = false;
             attach.ParentId = strIdCustomObject;
             insert attach;

             objContentVersion.title = confDoc.COM_Nombre_Adjunto_Email__c;
             objContentVersion.PathOnClient = confDoc.COM_Nombre_Adjunto_Email__c;
             objContentVersion.versiondata = blbPDF;
             insert objContentVersion;
             ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :objContentVersion.Id];

             ContentDocumentLink contentlink=new ContentDocumentLink();
             contentlink.LinkedEntityId=strIdCustomObject;
             contentlink.ShareType= 'V';
             contentlink.ContentDocumentId=testContent.ContentDocumentId;
             contentlink.Visibility = 'AllUsers';
             insert contentlink; */
            objContentVersion = MGLT_CrearContentDocument_cls.saveContentDocument(strIdCustomObject, confDoc.COM_Nombre_Adjunto_Email__c, blbPDF,'.pdf');
            System.debug('---->>> PB >> ObjContentVersion : '+objContentVersion);

            //AVX PB 23-09-19 - Ajuste migración Lightning FIN

            if(strTipoDoc == 'BienvenidaA_A1' || strTipoDoc == 'BienvenidaB_C_D' ){
                /* Inicio 2.0 */
                //docBienvenida = System.Label.DocumentoBienvenidaCat;
                /* Fin 2.0 */
            }
            else{
                docBienvenida = System.Label.DocBienPenc062;
            }
            system.debug('docBienvenida-->'+docBienvenida);
            List<ContentVersion> listaConteo = [SELECT Id, Title,VersionData
            FROM ContentVersion
            WHERE Title = :docBienvenida limit 1];
            system.debug('listaConteo-->'+listaConteo);
            if(listaConteo.size() > 0 && strTipoDoc != 'FichaTecnica'){
                //AVX PB 23-09-19 - Ajuste migración Lightning INICIO
                ContentVersion sObjConteo = listaConteo[0];
                /*Attachment attach2 = new Attachment();
                attach2.Body = sObjConteo.VersionData;
                attach2.Name = sObjConteo.Title+'.pdf';
                attach2.IsPrivate = false;
                attach2.ParentId = strIdCustomObject;
                insert attach2;   */

                ContentVersion objContentVersion2 = MGLT_CrearContentDocument_cls.saveContentDocument(strIdCustomObject, sObjConteo.Title, sObjConteo.VersionData,'.pdf');

                //listAtach.add(attach);
                //listAtach.add(attach2);
                //insert listAtach;  

                //attachSet.add(attach.id);
                //attachSet.add(attach2.id);
                attachSet.add(objContentVersion.Id);
                attachSet.add(objContentVersion2.Id);
                System.debug('--->>>AVX - CONTENTVERSION SET:'+attachSet);

                //AVX PB 23-09-19 - Ajuste migración Lightning FIN
            }
        }
        else
        {
            //AVX PB 23-09-19 - Ajuste migración Lightning INICIO
            //Adjuntar PDF al registro
            /*
            attach.Body = blbPDF;
            attach.Name = confDoc.COM_Nombre_Adjunto_Email__c+'.pdf';
            attach.IsPrivate = false;
            attach.ParentId = strIdCustomObject;
            insert attach;*/

            //ContentVersion objContentVersion3 = MGLT_CrearContentDocument_cls.saveContentDocument(strIdCustomObject, confDoc.COM_Nombre_Adjunto_Email__c,blbPDF,'.pdf');
            //System.debug('--->>>AVX - CV SET:'+objContentVersion3);
            objContentVersion = MGLT_CrearContentDocument_cls.saveContentDocument(strIdCustomObject, confDoc.COM_Nombre_Adjunto_Email__c,blbPDF,'.pdf');
            System.debug('--->>>AVX - CV SET:'+objContentVersion);
            //AVX PB 23-09-19 - Ajuste migración Lightning FIN

        }
        //Fin V1.3 
        attachSet.add(objContentVersion.id);
        set<String> setEmails;
        strObject = mapSObjectType.get(strIdCustomObject.left(3)).getDescribe().getName();
        System.debug('***CM*** =====>>> strIdCustomObject \n'+strIdCustomObject);
        System.debug('***CM*** =====>>> strObject \n'+strObject);
        //System.debug('***CM*** =====>>> attach.Id \n'+attach.Id);
        System.debug('***CM*** =====>>> confDoc.COM_IdProceso__c \n'+confDoc.COM_IdProceso__c);



        if(strObject == 'Account'){
            Set<String> tipoPazYSalvo = new Set<String>{'ServicioDomestico', 'Independiente2', 'Independiente06', 'Empresas4', 'EmpresasLey590', 'EmpresasLey1429'};
            /* RUSF 1.2
setEmails = getEmailsCuenta(strIdCustomObject);
if(tipoPazYSalvo.contains(strTipoDoc)){
system.debug('entra a enviar paz y salvo ');
COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id}, '', '', 'CuerpoPazYSalvo', getContactosCuenta(strIdCustomObject), strIdCustomObject);
} else {                
COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id},confDoc.COM_AsuntoEmail__c,'','',null,null);
} 
*/
            if(tipoPazYSalvo.contains(strTipoDoc)){
                //PBA AVX 09-24-19 INICIO
                // COM_ConsultarEnvioDocumentos_cls.enviarDocumentoOnBase(confDoc.COM_IdProceso__c, new set<Id>{attach.id});
                COM_ConsultarEnvioDocumentos_cls.enviarDocumentoOnBase(confDoc.COM_IdProceso__c, new set<Id>{objContentVersion.id});
                //PBA AVX 09-24-19 FIN
            }
        }
        else if(strObject == 'Opportunity' && strTipoDoc == 'FichaTecnica'){
            system.debug('entra a enviar ficha tecnica '+strIdCustomObject);
            Opportunity objOpp = [SELECT AccountId FROM Opportunity WHERE Id = :strIdCustomObject];
            setEmails = getEmailsOperador(strIdCustomObject);
            //COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id},confDoc.COM_AsuntoEmail__c,'','','','');
            //PB AVX 09-24-19 INICIO
            COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{objContentVersion.id}, '', '', 'CuerpoFichaTecnica', getContactosCuenta(objOpp.AccountId), objOpp.AccountId);
            // COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id}, '', '', 'CuerpoFichaTecnica', getContactosCuenta(objOpp.AccountId), objOpp.AccountId);
            //PB AVX 09-24-19 FIN

        }
        else if(strObject == 'Opportunity' && strTipoDoc.startsWith('Bienvenida')){
            Opportunity objOpp = [SELECT AccountId FROM Opportunity WHERE Id =:strIdCustomObject];
            setEmails = getEmailsRepLegales(objOpp.AccountId);
            system.debug('template---'+'cuerpo'+strTipoDoc);
            //COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id}, '', '', 'cuerpo'+strTipoDoc, getContactosCuenta(objOpp.AccountId), null);
            /*Inicio 1.2*/
            //Inicio V1.3
            if(strTipoDoc == 'BienvenidaA_A1' || strTipoDoc == 'BienvenidaB_C_D' || strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_0_6' || strTipoDoc == 'Bienvenida_Carta_de_Aceptaci_n_Pensionados_2')
            {
                COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,attachSet, '', '', 'cuerpo'+strTipoDoc, getContactosCuenta(objOpp.AccountId), strIdCustomObject);
            }
            else{
                //PB AVX 09-24-19 INICIO
                //COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id}, '', '', 'cuerpo'+strTipoDoc, getContactosCuenta(objOpp.AccountId), strIdCustomObject);
                COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{objContentVersion.id}, '', '', 'cuerpo'+strTipoDoc, getContactosCuenta(objOpp.AccountId), strIdCustomObject);
                //PB AVX 09-24-19 FIN
            }
            //Fin V1.3
            /*Fin 1.2*/
        } else if(strObject == 'Quote'){
            System.debug('***WA*** =====>>> setEmails \n'+setEmails);
            Quote objOpp = [SELECT AccountId, Opportunity.Contacto__c, Opportunity.Contacto__r.Email FROM Quote WHERE Id =:strIdCustomObject];
            system.debug('correo---'+objOpp);
            system.debug('correo---'+objOpp.Opportunity);
            system.debug('correo---'+objOpp.Opportunity.Contacto__c);
            system.debug('correo---'+objOpp.Opportunity.Contacto__r.Email);
            setEmails = new Set<String>{objOpp.Opportunity.Contacto__r.Email};
            //setEmails = getEmailsRepLegales(objOpp.AccountId);
            System.debug('***WA*** =====>>> confDoc.COM_IdProceso__c \n'+confDoc.COM_IdProceso__c);
            System.debug('***WA*** =====>>> attach.id \n'+objContentVersion.id);
            System.debug('***WA*** =====>>> confDoc.COM_AsuntoEmail__c \n'+confDoc.COM_AsuntoEmail__c);
            //COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id},confDoc.COM_AsuntoEmail__c,'','',null,null);  
            //PB AVX 09-24-19 INICIO
            //COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{attach.id}, '', '', 'CuerpoCotizacion', objOpp.Opportunity.Contacto__c, objOpp.AccountId);
            COM_ConsultarEnvioDocumentos_cls.enviarDocumentos(confDoc.COM_IdProceso__c,setEmails,new set<Id>{objContentVersion.id}, '', '', 'CuerpoCotizacion', objOpp.Opportunity.Contacto__c, objOpp.AccountId);
            //PB AVX 09-24-19 FIN
        }   
    }

    /**
* [getEmailsOperador description]
* @param  strOpportunityId [description]
* @return                  [description]
*/
    public set<String> getEmailsOperador(String strOpportunityId)
    {
        /*
List<Opportunity> lstOportunidades = new List<Opportunity>([SELECT Id, Name, COM_Operador__c FROM Opportunity WHERE Id =:strOpportunityId]);
set<String> setEmails = new set<String>();
Map<Id, COM_Operador__c> mapOperadores = new Map<Id, COM_Operador__c>([SELECT Id, COM_CorreoElectronico__c FROM COM_Operador__c]);
setEmails.add(mapOperadores.get(lstOportunidades.get(0).COM_Operador__c).COM_CorreoElectronico__c);
*/
        set<String> setEmails = new set<String>();
        List<Opportunity> objOpps = [SELECT COM_Operador__r.COM_CorreoElectronico__c
        FROM Opportunity WHERE Id =:strOpportunityId];

        for(Opportunity opp : objOpps){
            for(String correo : opp.COM_Operador__r.COM_CorreoElectronico__c.split(','))
                setEmails.add(correo);
        }

        System.debug(setEmails);
        return setEmails;
    }

    /**
* @version 1.1
* @description Metodo encargado de obtener el correo al cual se deben enviar el documento
* @String strAccountId => Id de la cuenta que se esta consultando
* @return set<String> => Set con los correo de los representantes legales
*/
    public Id getContactosCuenta(Id strAccountId)
    {
        List<AccountContactRelation> lstContactsRel = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId =: strAccountId];
        if(lstContactsRel.size() > 0)
            return lstContactsRel[0].ContactId;
        else
                return null;
    }
}