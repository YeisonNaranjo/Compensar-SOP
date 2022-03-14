/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase de utilidades referente al envio de correos electornicos
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    25/07/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   1.1    12/02/2019      Stifen Panche Gutierrez             Incluir Log cartas de cierre.
* @version   1.2    24/09/2019      Paula Bohórquez                     Migración Lightning - Se reemplazan Attachments por Content Documents.
****************************************************************************************************************/
public with sharing class COM_UtilidadCorreo_cls {

    /* 
    * Nombre: enviarCorreoSimple
    * Descripcion: Metodo encargado de enviar un correo electronico a uno o varios destinatarios, el 
    *              correo puede contener uno o varios adjuntos, NO usa template de correo electronico
    * Fecha Creación: 25/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    *   2            24-Sep-2019     Paula Bohórquez Alfonso.      Migración Lightning - Se reemplazan Attachments por Content Documents.   
    * --------------------------------------------------------------------------------------------------------------
    */
    public static void enviarCorreoSimple(set<String> setCorreos, set<Id> setIdAdjuntos, String strAsunto, String strCuerpoCorreo){
        //list<Attachment> lstAttachment;
       // lstAttachment = [SELECT Id, Name, ContentType, Body FROM Attachment WHERE Id IN :setIdAdjuntos];
       // enviarCorreo(setCorreos, lstAttachment, strAsunto, strCuerpoCorreo, null, null, null);

        List<ContentVersion> lstCV = [SELECT Id, Title,VersionData,ContentDocumentId,FileType, PathOnClient FROM ContentVersion WHERE Id IN: setIdAdjuntos];
        enviarCorreo(setCorreos, lstCV, strAsunto, strCuerpoCorreo, null, null, null);
    }

    /* 
    * Nombre: enviarCorreoTemplate
    * Descripcion: Metodo encargado de enviar un correo electronico a uno o varios destinatarios, el 
    *              correo puede contener uno o varios adjuntos, SI usa template de correo electronico
    * Fecha Creación: 25/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    *   2            24-Sep-2019     Paula Bohórquez Alfonso.      Migración Lightning - Se reemplazan Attachments por Content Documents.   
    * --------------------------------------------------------------------------------------------------------------
    */
    public static void enviarCorreoTemplate(set<String> setCorreos, set<Id> setIdAdjuntos, String strTemplate, Id targetObjId, Id whatId){
        //list<Attachment> lstAttachment;

       // lstAttachment = [SELECT Id, Name, ContentType, Body FROM Attachment WHERE Id IN :setIdAdjuntos];
      //  enviarCorreo(setCorreos, lstAttachment, ' ', ' ', strTemplate, targetObjId, whatId);
        
        List<ContentVersion> lstCV = [SELECT Id, Title,VersionData,ContentDocumentId,FileType, PathOnClient FROM ContentVersion WHERE Id IN: setIdAdjuntos];
        enviarCorreo(setCorreos,lstCV, ' ', ' ', strTemplate, targetObjId, whatId);

    }

    /* 
    * Nombre: enviarCorreoTemplate
    * Descripcion: Metodo encargado de enviar un correo electronico a uno o varios destinatarios, el 
    *              correo puede contener uno o varios adjuntos, SI usa template de correo electronico
    * Fecha Creación: 25/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    *   2            24-Sep-2019     Paula Bohórquez Alfonso.      Migración Lightning - Se reemplazan Attachments por Content Documents.   
    * --------------------------------------------------------------------------------------------------------------
    */
    /*public static void enviarCorreoTemplate(set<String> setCorreos, list<Attachment> lstAttachment, String strTemplate, Id targetObjId, Id whatId){
        enviarCorreo(setCorreos, lstAttachment, ' ', ' ', strTemplate, targetObjId, whatId);
    }*/
    public static void enviarCorreoTemplate(set<String> setCorreos, list<ContentVersion> lstAttachment, String strTemplate, Id targetObjId, Id whatId){
        enviarCorreo(setCorreos, lstAttachment, ' ', ' ', strTemplate, targetObjId, whatId);
    }

    /* 
    * Nombre: enviarCorreo
    * Descripcion: Metodo encargado de enviar un correo electronico a uno o varios destinatarios, el 
    *              correo puede contener uno o varios adjuntos y tambien puede usar o no un 
    *              template de correo electronico
    * Fecha Creación: 25/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    *   2            05-Sep-2018     Carlos A. Salamanca G.      NOLA 5887 Modificacion Query 'owa'   
    *   3            24-Sep-2019     Paula Bohórquez Alfonso.      Migración Lightning - Se reemplazan Attachments por Content Documents.   
    * --------------------------------------------------------------------------------------------------------------
    */
    private static void enviarCorreo(set<String> setCorreos, list<ContentVersion> lstContentVersion, String strAsunto, String strCuerpoCorreo, String strTemplate, Id targetObjId, Id whatId){
    //private static void enviarCorreo(set<String> setCorreos, list<Attachment> lstAttachment, String strAsunto, String strCuerpoCorreo, String strTemplate, Id targetObjId, Id whatId){
        System.debug('--->>> CONTENT VERSION ENVIARCORREO: '+lstContentVersion);
        list<Messaging.Emailfileattachment> lstEmailfileattachment;
        list<EmailTemplate> lstEmailTemplate;
        Messaging.Emailfileattachment objEmailfileattachment;
        Id templateId;  

        Integer used = Limits.getEmailInvocations();
        Integer emailLimit = Limits.getLimitEmailInvocations();
        system.debug('========== used: ' + used);
        system.debug('========== emailLimit: ' + emailLimit);
        
        if(used >= emailLimit){
            //print email text instead of email it.
        }
        else{
            //send email
        }
        
        lstEmailfileattachment = new List<Messaging.Emailfileattachment>();
        
        //Se agregan los archivos adjuntos consultados a la lista de Emailfileattachment
        if(lstContentVersion != null && lstContentVersion.size() > 0){
            for (Integer i = 0; i < lstContentVersion.size(); i++){
                system.debug(lstContentVersion[i].Title);
                //system.debug(lstAttachment[i].Name);
                objEmailfileattachment = new Messaging.Emailfileattachment();
                // objEmailfileattachment.setFileName(lstAttachment[i].Name);
                // objEmailfileattachment.setBody(lstAttachment[i].Body);
                // objEmailfileattachment.setContentType(lstAttachment[i].ContentType);

                if (!lstContentVersion[i].Title.contains('.') && String.isNotBlank(lstContentVersion[i].PathOnClient)) {
                    objEmailfileattachment.setFileName(lstContentVersion[i].PathOnClient);
                }
                else {
                    objEmailfileattachment.setFileName(lstContentVersion[i].Title);
                }
                objEmailfileattachment.setBody(lstContentVersion[i].VersionData);
                //objEmailfileattachment.setContentType(lstContentVersion[i].FileType);               
                objEmailfileattachment.setContentType(getContectType(lstContentVersion[i].FileType));
                lstEmailfileattachment.add( objEmailfileattachment );
            }
        }

        System.debug('strTemplate:::'+strTemplate);
        //Se consulta el EmailTemplate de acuerdo al nombre que llegó como parametro
        String subjectTemplate = '';
        if(!String.isEmpty(strTemplate)){
            System.debug('no entro strTemplate:::'+strTemplate);
            lstEmailTemplate = [SELECT Id, Subject, Name FROM EmailTemplate WHERE Developername = : strTemplate];
            if(!lstEmailTemplate.isEmpty()){
                templateId = lstEmailTemplate[0].Id;
                subjectTemplate = lstEmailTemplate[0].Subject;
            }
        }
        try{
            //String direccionGlobal = '';
            //if (orgWideEmailLst != null)
            //direccionGlobal= orgWideEmailLst.Address;*/
            Messaging.reserveSingleEmailCapacity(setCorreos.size());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new List<String>(setCorreos);

            mail.setToAddresses(toAddresses);

            //NOLA 5887
            //OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
            OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress where DisplayName =: Label.COM_Email];
            //NOLA 5887

            mail.setOrgWideEmailAddressId(owa.Id);  

            mail.setReplyTo('no-reply@compensar.com');
            mail.setBccSender(true);
            mail.setUseSignature(false);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(false);

            if(templateId != null){
                //mail.setReplyTo('no-replay@compensar.com');
                //mail.setOrgWideEmailAddressId(direccionGlobal);  
                ///mail.setSenderDisplayName(label.COM_SenderDisplayName);
                //System.debug(label.COM_SenderDisplayName);
                mail.setWhatId(whatId);
                mail.setTargetObjectId(targetObjId);
                System.debug('targetObjId:::'+targetObjId);
                mail.setTemplateId(templateId);
            } else{
                mail.setSubject(strAsunto);
                //mail.setPlainTextBody('Carta de bienvenida.');
                mail.setHtmlBody(strCuerpoCorreo);
            }
            
            if(!lstEmailfileattachment.isEmpty()){
                mail.setFileAttachments(lstEmailfileattachment );
            }
            system.debug('el mail---> '+mail);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


            // Guardar en Log de Email 
            Boolean saveLog = [Select Guardar_Log__c From Configuracion_Log_Correo_Electronico__mdt where MasterLabel = 'Conf1'][0].Guardar_Log__c;
            String strCorreosLog = '';

            for(String sr:toAddresses){
                strCorreosLog += sr;
            }
            Log_Correo_Electronico__c sObjLogCorreo = new Log_Correo_Electronico__c(
                                                                Lista_de_Correos_Electronicos__c = strCorreosLog,
                                                                Template__c = templateId,
                                                                Fecha_Envio__c = system.now(),
                                                                Asunto_Correo__c = strTemplate,
                                                                Id_Padre__c = whatId,
                                                                Clase_Metodo__c = targetObjId,
                                                                Estado__c = 'Enviado'
                                                            );
            //if([Select Guardar_Log__c From Configuracion_Log_Correo_Electronico__mdt where MasterLabel = 'Conf1'][0].Guardar_Log__c){


            /*Inicio 1.1*/
            //if(saveLog && (strTemplate.contains('Bienvenida'))){

            if(saveLog && (strTemplate.contains('Bienvenida') || strTemplate.contains('Cierrecaso'))){
            /*Fin 1.1*/
                insert sObjLogCorreo;
            }
            // Guardar en Log de Email

        }catch(Exception e){
            system.debug('Error enviando el email----> '+e.getMessage());

            /*Inicio 1.1*/
             Log_Correo_Electronico__c sObjLogCorreo = new Log_Correo_Electronico__c(
                                                                Fecha_Envio__c = system.now(),
                                                                Asunto_Correo__c = 'Error ' + e.getMessage(),
                                                                Estado__c = 'No enviado'
                                                            );
              insert sObjLogCorreo;
            /*Fin 1.1*/
        }
        
    }

    public static String  getContectType(String strFileType){
        System.debug('strFileType-->'+strFileType);
        if(!Test.isRunningTest()){ 
            if(strFileType.toLowerCase()=='pdf'){
                 return 'application/pdf';
             }else if(strFileType.toLowerCase()=='msexcel'){
                return 'application/vnd.ms-excel'; 
             }else if(strFileType.toLowerCase()=='msword'){
               return 'application/msword';  
             }else{
                return 'application/pdf'; 
             }
        }else{
            return 'application/pdf'; 
        }
     }
    
   /*
    * Nombre: enviarListCorreo
    * Descripcion: Metodo encargado de enviar varios correo electronico a uno o varios destinatarios, los
    *              correo puede contener uno o varios adjuntos y tambien puede usar o no un
    *              template de correo electronico
    * Fecha Creación: 11/08/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                   Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            11-Ago-2017     William Aldana              Creacion del metodo.
    *   2            05-Sep-2018     Carlos A. Salamanca G.      NOLA 5887 Modificacion Query 'owa'
    * --------------------------------------------------------------------------------------------------------------
    */
    public static void enviarListCorreo(List<CorreoSimple> correosEnviar){
        List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();
        Boolean entroATemplate = false;
        list<EmailTemplate> lstEmailTemplate;
        List<Contact> lstTempContact = new List<Contact>();
        Id templateId; 
        List<Log_Correo_Electronico__c> lstLogCorreo = new List<Log_Correo_Electronico__c>();
        for(CorreoSimple obj : correosEnviar)
        {
            list<Messaging.Emailfileattachment> lstEmailfileattachment;
            Messaging.Emailfileattachment objEmailfileattachment;
            Integer used = Limits.getEmailInvocations();
            Integer emailLimit = Limits.getLimitEmailInvocations();
            system.debug('========== used: ' + used);
            system.debug('========== emailLimit: ' + emailLimit);
            system.debug('========== obj: ' + obj);
            if(used >= emailLimit){
              //print email text instead of email it.
            }
            else{
              //send email
            }

            lstEmailfileattachment = new List<Messaging.Emailfileattachment>();

            //Se agregan los archivos adjuntos consultados a la lista de Emailfileattachment
            //if(obj.lstAttachment != null && obj.lstAttachment.size() > 0){
            if(obj.lstContentVersion != null && obj.lstContentVersion.size() > 0){
                for (Integer i = 0; i < obj.lstContentVersion.size(); i++){
                    system.debug(obj.lstContentVersion[i].Title);
                    objEmailfileattachment = new Messaging.Emailfileattachment();
                    /*
                    objEmailfileattachment.setFileName(obj.lstAttachment[i].Name);
                    objEmailfileattachment.setBody(obj.lstAttachment[i].Body);
                    objEmailfileattachment.setContentType(obj.lstAttachment[i].ContentType);*/

                     objEmailfileattachment.setFileName(obj.lstContentVersion[i].Title);
                    objEmailfileattachment.setBody(obj.lstContentVersion[i].VersionData);
                    //objEmailfileattachment.setContentType(obj.lstContentVersion[i].FileType);
          objEmailfileattachment.setContentType(getContectType(obj.lstContentVersion[i].FileType));
                    lstEmailfileattachment.add( objEmailfileattachment );
                }
            }

        //Se consulta el EmailTemplate de acuerdo al nombre que llegó como parametro
        String subjectTemplate2 = '';
        if(!entroATemplate){
            if(!String.isEmpty(obj.strTemplate)){
                
                lstEmailTemplate = [SELECT Id,Subject, Name FROM EmailTemplate WHERE Developername =: obj.strTemplate];
                if(!lstEmailTemplate.isEmpty()){
                    templateId = lstEmailTemplate[0].Id;
                    subjectTemplate2 = lstEmailTemplate[0].Subject;
                    system.debug('========== templateId: ' + templateId);
                }else{
                    system.debug('========== no tengo templateId');
                }
            }
            entroATemplate = true;
        }
        Integer intEmailCapacity = 0;
        String[] toAddresses = new List<String>();
        toAddresses = new List<String>(obj.setCorreos);
            if(templateId != null && obj.targetObjId != null){
                intEmailCapacity = 1;
            }else{              
                intEmailCapacity = obj.setCorreos.size();   
            }
            try{
            Messaging.reserveSingleEmailCapacity(intEmailCapacity);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //if(templateId != null && obj.targetObjId != null){OrgWideEmailAddress 
            mail.setToAddresses(toAddresses);
            //}
            mail.setReplyTo('no-reply@compensar.com');
            
            //NOLA 5887
            //OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
            OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress where DisplayName =: Label.COM_Email];
            //NOLA 5887

            mail.setOrgWideEmailAddressId(owa.Id);  

            mail.setReplyTo('no-reply@compensar.com');
            mail.setBccSender(true);
            mail.setUseSignature(false);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(false);


            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false); 
            //List<User> lstuser = [select Id, email, firstName, lastName from User where id =: obj.whatId];
           /* Set<String> correos = new set<String>();
            if(!lstuser.isEmpty())  
             correos.add(lstuser.get(0).email);
            String[] toAddresses2 = new List<String>(correos);*/
            if(templateId != null){
                /*Contact tempContact = new Contact(email = user.email, firstName = user.firstName, lastName = user.lastName);
                try {
                    insert tempContact;
                }
                catch (Exception e) {
                   tempContact 
                }*/
                //lstTempContact.add(tempContact);

                //mail.setTargetObjectId(tempContact.Id);
                    //if(!lstuser.isEmpty())
                    //mail.setTargetObjectId(lstuser.get(0).Id);
                    mail.setTargetObjectId(obj.targetObjId);
                    mail.setToAddresses(toAddresses);
                    mail.setWhatId(obj.whatId);
                    mail.setTemplateId(templateId); 
            } else{
                    mail.setSubject(obj.strAsunto);
                    mail.setHtmlBody(obj.strCuerpoCorreo);
                    mail.setToAddresses(toAddresses);
            }
            
            if(!lstEmailfileattachment.isEmpty()){
                    mail.setFileAttachments(lstEmailfileattachment);
            }
                myEmails.add(mail);

            // Guardar en Log de Email masivo
            String strCorreosLog = '';

            for(String sr:toAddresses){
                strCorreosLog += sr;
            }
            Log_Correo_Electronico__c sObjLogCorreo = new Log_Correo_Electronico__c(
                                                                Lista_de_Correos_Electronicos__c = strCorreosLog,
                                                                Template__c = templateId,
                                                                Fecha_Envio__c = System.now(),
                                                                Id_Padre__c = obj.whatId
                                                            );
                                                            
            lstLogCorreo.add(sObjLogCorreo);
            // Guardar en Log de Email masivo

            } catch(Exception e){
                system.debug('Error enviando el email----> '+e.getMessage());
            }
            }
            Messaging.sendEmail(myEmails);
            /*if(!lstTempContact.isEmpty()){
                delete lstTempContact;
            }*/

            // Guardar en Log de Email masivo
            /*try{
                if([Select Guardar_Log__c From Configuracion_Log_Correo_Electronico__mdt where MasterLabel = 'Conf1'][0].Guardar_Log__c){
                    insert lstLogCorreo;
                }
            }
            catch(Exception e){
                system.debug('Error guardando el email log----> '+e.getMessage());
            }*/
            // Guardar en Log de Email masivo

        }


        public Class CorreoSimple 
        {
            public set<String> setCorreos {get;set;} 
            //public list<Attachment> lstAttachment {get;set;} 
            public list<ContentVersion> lstContentVersion {get;set;} 
            public String strAsunto {get;set;} 
            public String strCuerpoCorreo {get;set;} 
            public String strTemplate {get;set;} 
            public Id targetObjId {get;set;} 
            public Id whatId {get;set;}

            //public CorreoSimple(set<String> setCorreos, list<Attachment> lstAttachment, String strAsunto, String strCuerpoCorreo, String strTemplate, Id targetObjId, Id whatId)
            public CorreoSimple(set<String> setCorreos, list<ContentVersion> lstContentVersion, String strAsunto, String strCuerpoCorreo, String strTemplate, Id targetObjId, Id whatId)
            {
                System.debug('setCorreos:::'+setCorreos);
                this.setCorreos     = setCorreos;
                this.lstContentVersion  = lstContentVersion;
                this.strAsunto           = strAsunto;
                this.strCuerpoCorreo     = strCuerpoCorreo;
                this.strTemplate         = strTemplate;
                this.targetObjId         = targetObjId;
                this.whatId              = whatId;
            }
        }




    }