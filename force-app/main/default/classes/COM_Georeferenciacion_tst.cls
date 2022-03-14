/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_Georeferenciacion_ws
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    31/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_Georeferenciacion_tst {
    
    @isTest static void consultarGeoreferenciacion(){
    	
    	list<COM_ConfiguracionWebServiceM__mdt> lstConfiguracionWebService = COM_DataGenerator_cls.crearConfiguracionWebService(true);
    	list<COM_ConfiguracionHeaderWSM__mdt> lstConfiguracionHeaderWS = COM_DataGenerator_cls.crearConfiguracionHeaderWS(true);
    	
    	Test.startTest();
    		COM_Georeferenciacion_ws ojbGeo = new COM_Georeferenciacion_ws();
			COM_Georeferenciacion_ws.GeoreferenciacionWrapper objGW;
			Account objCuenta = new Account();
			objCuenta.COM_Direccion__c = 'Calle';
			Test.setMock(HttpCalloutMock.class, new COM_CalloutMockGeoreferenciacion_tst());
			try{
				objGW = ojbGeo.consultarGeoreferenciacion(objCuenta, 11001);
				system.debug('-------------> ' + objGW);
			} catch(COM_GeoreferenciacionException e){
				system.debug('-------> ERROR: ' + e.GetMessage());
			}
			
			COM_Utilidades_cls.stringToDatetime('xxx');
			COM_Utilidades_cls.stringToDatetime('2017-07-12T14:00:02.334-05:00');
			COM_Utilidades_cls.generarRandom(4);
    	Test.stopTest();
    	
    }
    
}