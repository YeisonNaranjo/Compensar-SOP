/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase de pruebas para la clase COM_ConsultarMetaDataDocumentoOnBase__ctr
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    29/09/2017      William Aldana                      Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class COM_ConsultarMetaDataDocumentoOnBase_tst {
    public COM_ConsultarMetaDataDocumentoOnBase_tst() {
        
    }

    private static Account crearCuenta2(boolean crear){

        Account arl = new Account();
        arl.Name ='Prueba';
        arl.COM_TipoIdentificacion__c = '2';
        arl.COM_Numero_de_identificacion__c = '80069100';
        if(crear){
            COM_AccountContactRelation_cls.stopTrigger();
            insert arl;
            COM_AccountContactRelation_cls.startTrigger();
        }
        return arl;
    }

    private static Account crearCuenta1(boolean crear){
        Account arl = new Account();
        arl.Name ='Prueba 1';
        arl.COM_TipoIdentificacion__c = '2';
        arl.COM_Numero_de_identificacion__c = '79390031';
        if(crear) {
            COM_AccountContactRelation_cls.stopTrigger();
            insert arl;
            COM_AccountContactRelation_cls.startTrigger();
        }
        return arl;
    }

    @isTest static void pruebaConsultarDocOnBase(){
        Account account = crearCuenta1(true);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
        List<COM_ConsultarMetaDataDocumentoOnBase_ws.MetaDataDocumentoWrapper> laLista = COM_ConsultarMetaDataDocumentoOnBase_ws.consultarMetaDataDocumentoOnBase(account, '15', '15', 'AFN-Contrato de Trabajo Aprendiz SENA', 'Document Type Name');
        Test.stopTest();
    }


    @isTest static void pruebaConsultarDocOnBase2(){
        Account account = crearCuenta2(false);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
        List<COM_ConsultarMetaDataDocumentoOnBase_ws.MetaDataDocumentoWrapper> laLista = COM_ConsultarMetaDataDocumentoOnBase_ws.consultarMetaDataDocumentoOnBase(account, '15', '15', 'AFN-Documento de Identificacion Afiliado', 'Agrupacion Familias');
        Test.stopTest();
    }

    @isTest static void pruebaMetadataDocWrapper(){
        //Account account = crearCuenta();
        Test.startTest();
        COM_ConsultarMetaDataDocumentoOnBase_ws.MetaDataDocumentoWrapper mt = new COM_ConsultarMetaDataDocumentoOnBase_ws.MetaDataDocumentoWrapper();
         mt.strIdDocumento = '';
         mt.strNombreDocumento = '';
         mt.strDocumentType = '';
         mt.strDateStored = '';
        Test.stopTest();
    }
}