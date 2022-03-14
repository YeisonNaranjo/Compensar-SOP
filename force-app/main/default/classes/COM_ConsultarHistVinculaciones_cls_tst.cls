/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de ejecutar  las pruebas unitarias de la clase
*                   COM_ConsultarHistVinculaciones_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		10/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@isTest
public class COM_ConsultarHistVinculaciones_cls_tst {
	/*
	public COM_ConsultarHistVinculaciones_cls_tst() {
		
	}

	private static Account crearCuenta(){
		COM_AccountContactRelation_cls.stopTrigger();
		Account arl = new Account();
		arl.Name ='Prueba';
		arl.COM_TipoIdentificacion__c = '2';
		arl.COM_Numero_de_identificacion__c = '123456789';
		insert arl;
		COM_AccountContactRelation_cls.startTrigger();
		return arl;
	}

	public static testMethod void test_method_one() {
		Account acc = crearCuenta();
		Test.startTest();
		COM_ConsultarHistVinculaciones_cls app = new COM_ConsultarHistVinculaciones_cls();
		list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
		lstLogs.add(COM_Utilidades_cls.generarLog(acc.Id, 'xxx', 'xxxx', 'xxxxx', label.COM_WS_ConsultarBiarioDocumentoOnBase, 'xxxxxxx'));
		Cache.Org.put('local.partition1.logs', lstLogs);
		app.encontrarHistorialVinculaciones(1, 80230418);
		Test.stopTest();
	}

	public static testMethod void test_method_two() {
		Account acc = crearCuenta();
		Test.startTest();
		COM_ConsultarClienteGC_ws consumer = new COM_ConsultarClienteGC_ws();
	    COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar
                (1, 80230418);
                system.debug('response '+response);
		COM_ConsultarHistVinculaciones_cls app = new COM_ConsultarHistVinculaciones_cls();
		list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
		lstLogs.add(COM_Utilidades_cls.generarLog(acc.Id, 'xxx', 'xxxx', 'xxxxx', label.COM_WS_ConsultarBiarioDocumentoOnBase, 'xxxxxxx'));
		Cache.Org.put('local.partition1.logs', lstLogs);
		app.encontrarGrupoFamiliarPorAfiliado(response);
		Test.stopTest();
	}*/

	 
}