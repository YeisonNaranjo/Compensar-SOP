/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase de Banderas
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/09/2017      William Aldana                      Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_Banderas_tst {
	
	@isTest static void pruebaBanderas(){
		Test.startTest();
			COM_Banderas_cls p = new COM_Banderas_cls();
			COM_Banderas_cls.ValidarEjecucion('prueba');
			COM_Banderas_cls.setEjecucion('prueba');
			COM_Banderas_cls.reiniciarEjecucion('prueba');
		Test.stopTest();	
	}
}