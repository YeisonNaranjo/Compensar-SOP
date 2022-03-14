/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase para copiar y enviar correo de los registros del objeto SetupAuditTrail

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     19/07/21        Jorge Pozo (JPA)		Creación Clase.
**************************************************************************************************/
public without sharing class RL2_CopiarSetupAuditTrail_cls {
    
    /**
    * @Method:      copiarRegistrosAuditoria
    * @param:       null
    * @Description: Guarda un backup en el objeto personalizado RL2_SeguimientoDeAuditoria__c
    * @author       Jorge Pozo (JPA) - 19/07/21
    */
    public static void copiarRegistrosAuditoria() {
        List<RL2_SeguimientoDeAuditoria__c> listSeg = new List<RL2_SeguimientoDeAuditoria__c>();
        RL2_SeguimientoDeAuditoria__c segAud;
        
        List<SetupAuditTrail> listSetup = getObtenerRegistrosAuditoriaDiaria();
        
        for(SetupAuditTrail setAudTra: listSetup) {
            segAud = new RL2_SeguimientoDeAuditoria__c(RL2_Id__c = setAudTra.Id, RL2_Accion__c = setAudTra.Action, RL2_Seccion__c = setAudTra.Section, RL2_Fecha__c = setAudTra.CreatedDate, RL2_CreadoPorId__c = setAudTra.CreatedById, RL2_CreadoPorUsuario__c = setAudTra.CreatedBy.Username, RL2_CreadoPorNombre__c = setAudTra.CreatedBy.Name, RL2_Visualizacion__c = setAudTra.Display, RL2_UsuarioDelegado__c = setAudTra.DelegateUser, RL2_PrefijoEspacioNombresOrigen__c = setAudTra.ResponsibleNamespacePrefix, RL2_CreadoPorContexto__c = setAudTra.CreatedByContext, RL2_CradoPorElEmisor__c = setAudTra.CreatedByIssuer);
            listSeg.add(segAud);
        }
        
        Database.SaveResult [] insertResult = Database.insert(listSeg, false);
        
        for (Database.SaveResult r : insertResult) {
            if (!r.isSuccess()){
                for (Database.Error e : r.getErrors()){
                    System.debug('==> RL2_CopiarSetupAuditTrail_bch: Ocurrió el siguiente error: '+ r.getId() + e);
                }     
            }        
        }
        
        System.debug('==> RL2_CopiarSetupAuditTrail_cls: Registros copiado');
    }
    
    /**
    * @Method:      enviarCorreo
    * @param:       null
    * @Description: Genera un archivo PDF y adjunta en el correo a enviar
    * @author       Jorge Pozo (JPA) - 19/07/21
    */
    public static void enviarCorreo() {
        
        String customSubject = 'Cambios realizados en configuración últimos 30 dias';
        String messageBody = 'A continuación encontrará adjunto el reporte de los cambios realizados a nivel de configuración en Salesforce últimos 30 dias.';
        
        String emailStr = Label.RL2_CorreosControlRiesgo;
        List<String> emailList = new List<String>();
        emailList = emailStr.split(',');
        
        PageReference pref = page.RL2_SetupAuditTrailPDF_vfp;
        pref.setRedirect(true);
        Blob b;
        if(Test.isRunningTest()) { 
            b = blob.valueOf('Test.pdf');
        } else {
            b = pref.getContent();
        }
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Reporte Salesforce - Últimos 30 dias.pdf');
        attachment.setBody(b);
        
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = emailList;
		message.subject = customSubject;
		message.plainTextBody = messageBody;
        message.setFileAttachments( new Messaging.EmailFileAttachment[]{ attachment } );

		try {
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            System.debug('==> RL2_CopiarSetupAuditTrail_cls: Correo enviado');
		} catch(System.CalloutException e) {
			System.debug('==> RL2_CopiarSetupAuditTrail_cls: Error al enviar el correo ' + e);
		}
	}
    
    /**
    * @Method:      getObtenerRegistrosAuditoriaDiaria
    * @param:       null
    * @Description: Consulta al objeto SetupAuditTrail para obtener los registros creados ayer
    * @author       Jorge Pozo (JPA) - 19/07/21
    */
    public static List<SetupAuditTrail> getObtenerRegistrosAuditoriaDiaria() {
        
        List<SetupAuditTrail> listSetupAuditTrail = [SELECT Id, Action, Section, CreatedDate, CreatedById, CreatedBy.Username, CreatedBy.Name, Display, DelegateUser, ResponsibleNamespacePrefix, CreatedByContext, CreatedByIssuer
                                                     FROM SetupAuditTrail
                                                     WHERE CreatedDate = YESTERDAY
                                                     ORDER BY CreatedDate];
        System.debug('==> ' +  listSetupAuditTrail.size());
        
        return listSetupAuditTrail;
    }
    
    /**
    * @Method:      getObtenerRegistrosAuditoriaDiaria
    * @param:       null
    * @Description: Consulta al objeto SetupAuditTrail para obtener los registros creados hace 30dias
    * @author       Jorge Pozo (JPA) - 19/07/21
    */
    public static List<SetupAuditTrail> getObtenerRegistrosAuditoria() {
        
        List<SetupAuditTrail> listSetupAuditTrail = [SELECT Id, Action, Section, CreatedDate, CreatedById, CreatedBy.Username, CreatedBy.Name, Display, DelegateUser, ResponsibleNamespacePrefix, CreatedByContext, CreatedByIssuer
                                                     FROM SetupAuditTrail
                                                     WHERE CreatedDate = LAST_N_DAYS:30
                                                     ORDER BY CreatedDate];
        System.debug('==> ' +  listSetupAuditTrail.size());
        
        return listSetupAuditTrail;
    }
}