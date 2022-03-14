/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase CEL1_ActualizarLogCorreo_tst

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/12/19         Manuel Mendez (MM)      Creación Clase.
************************************************************************************************/
@isTest
public class CEL1_ActualizarLogCorreo_tst {
    @istest
    public static void unitTets1() 
	{
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '8800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
        insert objCandidato;

        Task objTarea   = new Task();
        objTarea.Subject    =   'Correo electrónico: Bienvenido candidato';
        objTarea.WhoId      =   objCandidato.Id;
        objTarea.Description    =   'Prueba';
        insert objTarea;

        List<EmailMessage> lstEmailMessage = new List<EmailMessage>();
		EmailMessage em = new EmailMessage();
        // em.ActivityId   =   objTarea.Id;
		em.FromAddress='mmendez@avanxo.com';
		em.FromName='Brisleydi Calderon Seijas';
		em.ToAddress='manuel.mendez@globant.com';
        // em.setTargetObjectId();
        lstEmailMessage.add(em);
		System.debug(lstEmailMessage);
		insert lstEmailMessage;
        Datetime yesterday = Datetime.now().addHours(-1);
        Test.setCreatedDate(em.Id, yesterday);

        em.FirstOpenedDate  =   System.now();
        update em;

        Log_Correo_Electronico__c objLogCorreo = new Log_Correo_Electronico__c();
        objLogCorreo.CEL1_Candidato__c      =   objCandidato.Id;
        objLogCorreo.CEL1_FechaAbierto__c   =   System.now();
        objLogCorreo.Estado__c              =   'Enviado';
        objLogCorreo.CEL1_FechaAbierto__c   =   null;
        insert objLogCorreo;

        Test.startTest();
            CEL1_ActualizarLogCorreo_sch clsSCH = new CEL1_ActualizarLogCorreo_sch();
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, clsSCH);
        Test.stopTest();
    }
}