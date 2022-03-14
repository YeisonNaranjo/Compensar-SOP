/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_BaseWrapper
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/09/2017      William Aldana                      Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_BaseWrapper_tst {
	public COM_BaseWrapper_tst() {
		
	}

	@isTest static void pruebaWrapper(){
		Test.startTest();
			COM_BaseWrapper_cls wpClass = new COM_BaseWrapper_cls();
			COM_BaseWrapper_cls.SecurityHeader shClass  = new COM_BaseWrapper_cls.SecurityHeader();
			shClass.User ='';
			shClass.Password ='';
			COM_BaseWrapper_cls.System_x systemWP = new COM_BaseWrapper_cls.System_x();
			systemWP.InputSystem = '';
			systemWP.ApplicationID = '';
			systemWP.TransactionID = '';
			systemWP.IPAddress = '';

			COM_BaseWrapper_cls.Header headerWP = new COM_BaseWrapper_cls.Header();
			headerWP.SecurityHeader = shClass;
			headerWP.System_x =	systemWP;		

		Test.stopTest();
	}
}