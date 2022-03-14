/*
 * Created by AVX_RSuarez on 09/11/2017.
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  2.0     2019-02-06      David Yepes                     Modificación de validaciones según
                                                                    especificaciones del caso "00260650" creado
                                                                    en salesforce.
****************************************************************************************************************/


@isTest
private class RF2_CartaCierreCaso_tst {
	public static Case caso;
	public static void crearDatos(){
		caso = new Case();
		//Contact contacto =  COM_DataGenerator_cls.crearContacto(true, null);
		//caso.ContactId = contacto.Id;
		caso.Origin = 'Call Center';
		caso.Status = 'Abierto';
		caso.Subject = 'xxxxxxxxxxx';
		caso.RF2_TipoCierre__c = 'Exitoso';
		caso.RF2_ComentarioCierre__c = 'Este\nComentario';
		caso.RF2_GrupoCicloNegocio__c = 'Aportes';
		caso.RF2_TipoSolicitud__c = 'Queja';
		caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
		caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
		insert caso;
	}


	@isTest static void test_method_one() {
		crearDatos();
		Contact contacto =  COM_DataGenerator_cls.crearContacto(true, null);
		Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
		Test.startTest();
			PageReference pag = Page.RF2_CartaCierreCaso_pag;
			Test.setCurrentPageReference(pag);
			System.currentPageReference().getParameters().put('idCase', caso.Id);
			RF2_CartaCierreCaso_ctr controlador = new RF2_CartaCierreCaso_ctr();
			caso.ContactId = contacto.Id;
			update caso;
			System.currentPageReference().getParameters().put('idCase', caso.Id);
			controlador = new RF2_CartaCierreCaso_ctr();
			caso.ContactId = null;
			caso.AccountId = cuenta.Id;
			update caso;
			System.currentPageReference().getParameters().put('idCase', caso.Id);
			controlador = new RF2_CartaCierreCaso_ctr();
		Test.stopTest();
	}

//Version 2.0

	@isTest static void test_method_two() {

		RF2_CartaCierreCaso_ctr.obtenerMesPCE(1);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(2);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(3);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(4);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(5);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(6);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(7);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(8);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(9);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(10);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(11);
		RF2_CartaCierreCaso_ctr.obtenerMesPCE(12);
 }

//Fin version 2.0

}