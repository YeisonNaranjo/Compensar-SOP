/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_BaseWrapperResponse
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    29/09/2017      William Aldana                      Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_BaseWrapperResponse_tst {
	public COM_BaseWrapperResponse_tst() {
		
	}

	@isTest static void pruebaBaseWrapperResponse(){
		Test.startTest();
			COM_BaseWrapperResponse_cls app = new COM_BaseWrapperResponse_cls();
			COM_BaseWrapperResponse_cls.Header head = new COM_BaseWrapperResponse_cls.Header(); 
			head.RequestDate = '';
	    	head.ResponseDate = '';
        	head.ResponseCode = '';
        	head.ResponseDesc = '';
        	head.TransactionID = '';
		Test.stopTest();
	}
}