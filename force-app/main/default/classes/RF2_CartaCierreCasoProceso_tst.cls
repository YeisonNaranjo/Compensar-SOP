/**
* Avanxo Colombia
* @author           Elkin Córdoba href=<ecordoba@avanxo.com>
* Project:          Compensar
* Description:      Clase de prueba de la clase RF2_CartaCierreCasoProceso_ctr
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2019-07-15      Elkin Córdoba (EC)              Creación clase.
****************************************************************************************************************/
@isTest
public class RF2_CartaCierreCasoProceso_tst  {

public static Case caso;
	public static void crearDatos(){
		caso = new Case();
		caso.Origin = 'Call Center';
		caso.Status = 'Abierto';
		caso.Subject = 'xxxxxxxxxxx';
		caso.RF2_TipoCierre__c = 'Exitoso';
		caso.RF2_ComentarioCierre__c = 'Este\nComentario';
		caso.RF2_GrupoCicloNegocio__c = 'Aportes';
		caso.RF2_TipoSolicitud__c = 'Queja';
		caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
		caso.RF2_RelacionadoCon__c = 'Agencia de empleo';
        caso.RF2_SolucionadoPrimerContacto__c = true;
		insert caso;
		
		caso.ownerId = UserInfo.getUserId();
		update caso;
	}

	@isTest static void test_method_one() {
		crearDatos();
		Contact contacto =  COM_DataGenerator_cls.crearContacto(true, null);
		Account cuenta = COM_DataGenerator_cls.crearCuenta(true);
		Test.startTest();
			PageReference pag = Page.RF2_CartaCierreCasoProceso_pag;
			Test.setCurrentPageReference(pag);
			System.currentPageReference().getParameters().put('idCaso', caso.Id);
			RF2_CartaCierreCasoProceso_ctr controlador = new RF2_CartaCierreCasoProceso_ctr();
			controlador.cargarContenidoCarta();
			
			caso.ContactId = contacto.Id;
			update caso;
			controlador = new RF2_CartaCierreCasoProceso_ctr();
			controlador.cargarContenidoCarta();
			
			caso.ContactId = null;
			caso.AccountId = cuenta.Id;
			update caso;
			controlador = new RF2_CartaCierreCasoProceso_ctr();
			controlador.cargarContenidoCarta();
		Test.stopTest();
	}
}