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
public with sharing class COM_CambiarALetrasUtil_tst {
	public COM_CambiarALetrasUtil_tst() {
		
	}

	@isTest static void pruebaGetNumLetras1(){
		Test.startTest();
		COM_CambiarALetrasUtil_cls.getNumLetras(19);
		Test.stopTest();
	}

	@isTest static void pruebaGetNumLetras2(){
		Test.startTest();
		COM_CambiarALetrasUtil_cls.getNumLetras(0);
		COM_CambiarALetrasUtil_cls.getNumLetras(1);
		COM_CambiarALetrasUtil_cls.getNumLetras(2);
		COM_CambiarALetrasUtil_cls.getNumLetras(3);
		COM_CambiarALetrasUtil_cls.getNumLetras(4);
		COM_CambiarALetrasUtil_cls.getNumLetras(5);
		COM_CambiarALetrasUtil_cls.getNumLetras(6);
		COM_CambiarALetrasUtil_cls.getNumLetras(7);
		COM_CambiarALetrasUtil_cls.getNumLetras(8);
		COM_CambiarALetrasUtil_cls.getNumLetras(9);
		COM_CambiarALetrasUtil_cls.getNumLetras(10);
		COM_CambiarALetrasUtil_cls.getNumLetras(11);
		COM_CambiarALetrasUtil_cls.getNumLetras(12);
		COM_CambiarALetrasUtil_cls.getNumLetras(13);
		COM_CambiarALetrasUtil_cls.getNumLetras(14);
		COM_CambiarALetrasUtil_cls.getNumLetras(15);
		COM_CambiarALetrasUtil_cls.getNumLetras(16);
		Test.stopTest();
	}

		@isTest static void pruebaGetNumLetras3(){
		Test.startTest();
		COM_CambiarALetrasUtil_cls.getNumLetras(20);
		COM_CambiarALetrasUtil_cls.getNumLetras(21);
		COM_CambiarALetrasUtil_cls.getNumLetras(32);
		COM_CambiarALetrasUtil_cls.getNumLetras(41);
		COM_CambiarALetrasUtil_cls.getNumLetras(53);
		COM_CambiarALetrasUtil_cls.getNumLetras(65);
		COM_CambiarALetrasUtil_cls.getNumLetras(77);
		COM_CambiarALetrasUtil_cls.getNumLetras(88);
		COM_CambiarALetrasUtil_cls.getNumLetras(91);
		Test.stopTest();
	}

	@isTest static void pruebaGetNumLetras4(){
		Test.startTest();
		COM_CambiarALetrasUtil_cls.getNumLetras(100);
		COM_CambiarALetrasUtil_cls.getNumLetras(102);
		COM_CambiarALetrasUtil_cls.getNumLetras(202);
		COM_CambiarALetrasUtil_cls.getNumLetras(303);
		COM_CambiarALetrasUtil_cls.getNumLetras(404);
		COM_CambiarALetrasUtil_cls.getNumLetras(505);
		COM_CambiarALetrasUtil_cls.getNumLetras(606);
		COM_CambiarALetrasUtil_cls.getNumLetras(707);
		COM_CambiarALetrasUtil_cls.getNumLetras(808);
		COM_CambiarALetrasUtil_cls.getNumLetras(909);
		Test.stopTest();
	}

	@isTest static void pruebaGetNumLetras5(){
		Test.startTest();
		COM_CambiarALetrasUtil_cls.getNumLetras(1001);
		COM_CambiarALetrasUtil_cls.getNumLetras(3001);
		Test.stopTest();
	}

	@isTest static void pruebaGetNumLetras6(){
		Test.startTest();
		COM_CambiarALetrasUtil_cls.getNumLetras(1000002);
		COM_CambiarALetrasUtil_cls.getNumLetras(2000003);
		Test.stopTest();
	}

	@isTest static void pruebaGetMesLetras(){
		Test.startTest();
		String mes =  COM_CambiarALetrasUtil_cls.getMesLetras(1);
		System.assertEquals(mes, 'Enero');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(2);
		System.assertEquals(mes, 'Febrero');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(3);
		System.assertEquals(mes, 'Marzo');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(4);
		System.assertEquals(mes, 'Abril');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(5);
		System.assertEquals(mes, 'Mayo');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(6);
		System.assertEquals(mes, 'Junio');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(7);
		System.assertEquals(mes, 'Julio');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(8);
		System.assertEquals(mes, 'Agosto');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(9);
		System.assertEquals(mes, 'Septiembre');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(10);
		System.assertEquals(mes, 'Octubre');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(11);
		System.assertEquals(mes, 'Noviembre');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(12);
		System.assertEquals(mes, 'Diciembre');
		mes =  COM_CambiarALetrasUtil_cls.getMesLetras(13);
		System.assertEquals(mes, '');
		Test.stopTest();
	}
}