/***************************************************************************************************************
* Avanxo 
* @author           Daniel Alejandro López
* Proyecto:         CRM Compensar
* Descripción:      Clase de prueba para el servicio de Consultar Requisitos en el sistema Aldea de Compensar.
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    22/08/2017      Daniel Alejandro López Monsalve     Creación de la clase
****************************************************************************************************************/
	
@isTest
private class  COM_ConsultarRequisitosAldea_tst {
	
	static COM_WrapperConsultaRequisitoResponse_cls response;
    static List <String> listRequisitos;
	static String tipoIdAfiliado;
	static String numeroIdAfiliado;
	static Account objCuenta;
	
	@testSetup 
	static void crearData(){		
		tipoIdAfiliado ='1';
		numeroIdAfiliado ='53139587';
		objCuenta = new Account();
		objCuenta.COM_TipoIdentificacion__c = tipoIdAfiliado;
		objCuenta.COM_Numero_de_identificacion__c = numeroIdAfiliado;
		List <String> listRequisitos = new List <String>();
        listRequisitos.add('CORELE');
        
        //Insertar los dos registros de la configuración personalizada (Para que sean visibles en modo test)
        /*COM_ConfiguracionWebService__c configServicio = new COM_ConfiguracionWebService__c();
        configServicio.Name = 'ConsultarRequisitosAldea';
        configServicio.COM_Recurso__c = '/Compensar/Services/RequirementMgm';
        configServicio.COM_Puerto__c = 443;
        configServicio.COM_Protocolo__c ='https';
        configServicio.COM_DireccionIp__c ='devesb.compensar.com';
        configServicio.COM_Metodo__c ='GET';
        insert configServicio;*/
        
        /*COM_ConfiguracionHeaderWS__c configHeader = new COM_ConfiguracionHeaderWS__c();
        configHeader.Name   = 'ConsultarRequisitosAldea';
        configHeader.COM_ApplicationId__c   = 'SWPR140';
        configHeader.COM_Password__c   = 'PasswdPortal';
        configHeader.COM_DireccionIp__c   = '192.168.0.1';
        configHeader.COM_InputSystem__c   = 'Portal';
        configHeader.COM_Usuario__c   = 'UsrPortal';
        insert configHeader;*/

        // no es necesario crear las configuraciones
       
    }
	
	
	 @isTest static void testCrearClienteOK(){
	 	List <String> listRequisitos;
	 	crearData();
	 	Test.startTest();
		 	listRequisitos =  new List <String>();
		 	listRequisitos.add('CORELE');
		 	//response= COM_ConsultarRequisitosAldea_ws.consultarRequisitos(tipoIdAfiliado,numeroIdAfiliado, listRequisitos);
		 	response= COM_ConsultarRequisitosAldea_ws.consultarRequisitos(objCuenta, listRequisitos);
	 	Test.stopTest();
        
    }
    
    @isTest static void testCrearClienteError() {
    	List <String> listRequisitos;
		crearData();
		Test.startTest();
			listRequisitos = new list<String>();
			//COM_ConsultarRequisitosAldea_ws.consultarRequisitos(tipoIdAfiliado,numeroIdAfiliado, null);
			COM_ConsultarRequisitosAldea_ws.consultarRequisitos(objCuenta, listRequisitos);
		Test.stopTest();
    }
    
}