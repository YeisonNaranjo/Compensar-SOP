@isTest
private class COM_EmailMessage_cls_tst {
	
	@isTest static void test_method_one() {
		
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.Origin = 'Correo Electrónico';
        caso.Status = 'Abierto';
        caso.Subject = 'el subject';
        caso.RF2_GrupoCicloNegocio__c = 'Aportes';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones Empleadores';
        caso.RF2_SolucionadoPrimerContacto__c = false;
        insert caso;


        List<Entitlement> lstEntitlement = new List<Entitlement>();
        Entitlement ent = new Entitlement();
        ent.AccountId = caso.AccountId;
        ent.Name = 'ans 80 horas';
        ent.RF2_Canal__c = 'Correo Electrónico';
        ent.Rf2_GCN__c = 'Vacios';
        lstEntitlement.add(ent);
        insert lstEntitlement;

         
        List<EmailMessage> lstEmailMessage = new List<EmailMessage>();

		EmailMessage em = new EmailMessage();

		System.debug(caso.Id);
		em.ParentId=caso.Id;
		em.FromAddress='manuel.mendez@globant.com';
		em.FromName='Brisleydi Calderon Seijas';
		em.ToAddress='usuariowebcrm@gmail.com';

		System.debug(em);

		Test.startTest();
		lstEmailMessage.add(em);
		
		System.debug(lstEmailMessage);
		insert lstEmailMessage;
				
		
		Test.stopTest();


	}
}