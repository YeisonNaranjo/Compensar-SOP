/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Rubén Suárez Forero (CM)
Proyecto:          Compensar
Descripción:       Batch para actualizar el nombre de los contactos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/10/17             Rubén Suárez Forero (RUSF)              Creación clase.
    2.0     07/12/17            Nicolas Laverde Pinzón (NLP)            Se modifica el Query y la lógica
                                                                        para actualizar otros valores al
                                                                        contacto desde la cuenta
************************************************************************************************/

global class COM_ActualizarNombreContactos_bch implements Database.Batchable<sObject> {

  global COM_ActualizarNombreContactos_bch() {
    system.debug('Entra actualizar nombre contacto');
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    String recordTypeId = String.valueOf(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Natural').getRecordTypeId());


        return Database.getQueryLocator([
            SELECT  Id, FirstName, LastName, Account.COM_Primernombre__c, Account.COM_Otrosnombres__c, Account.COM_Primerapellido__c, Account.COM_Segundoapellido__c,
            //Inicio - versión 2.0 - Agrego campos al Query para poder actualizar el contacto
                    Account.Phone, Account.COM_Movil__c, Account.COM_CorreoElectronico__c, Account.COM_Tratamientoprotecciondatos__c, Account.COM_Aceptaenviocorreoelectronico__c, Account.COM_AceptaenvioSMS__c, Account.COM_Estado_civil__c
            FROM    Contact
            WHERE   Account.RecordTypeId =:recordTypeId ]);
  }

     global void execute(Database.BatchableContext BC, List<sObject> scope) {
    List<Contact> lstCon = new List<Contact>();
        for (sObject s : scope) {
          Contact c = (Contact) s;
         /* c.FirstName = c.Account.COM_Primernombre__c;
            c.FirstName += c.Account.COM_Otrosnombres__c!=null?' '+c.Account.COM_Otrosnombres__c:'';
            c.MiddleName = null;
          c.LastName = c.Account.COM_Primerapellido__c;
            c.LastName += c.Account.COM_Segundoapellido__c!=null?' '+c.Account.COM_Segundoapellido__c:'';
           */
            //Agrego nuevos campos para actualizar (NLP)
            c.COM_Telefono__c = c.Account.Phone;
            c.MobilePhone = c.Account.COM_Movil__c;
            c.Email = c.Account.COM_CorreoElectronico__c;
            c.COM_Tratamientoprotecciondatos__c = c.Account.COM_Tratamientoprotecciondatos__c;
            c.COM_Aceptaenviocorreoelectronico__c = c.Account.COM_Aceptaenviocorreoelectronico__c;
            c.COM_AceptaenvioSMS__c = c.Account.COM_AceptaenvioSMS__c;
            c.COM_EstadoCivil__c = c.Account.COM_Estado_civil__c;
            //Fin - Versión 2.0 (NLP)
          lstCon.add(c);
    }
    update lstCon;
  }

  global void finish(Database.BatchableContext BC) {

  }

}