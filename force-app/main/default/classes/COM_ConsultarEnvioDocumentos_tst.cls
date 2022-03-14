/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase COM_ConsultarEnvioDocumentos_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/

@isTest
private class COM_ConsultarEnvioDocumentos_tst 
{
    public static void createDate()
    {
        /*COM_ConfiguracionEnvioDocs__c objConf   = new COM_ConfiguracionEnvioDocs__c();
        objConf.Name                            = 'Test';
        objConf.COM_EnvioEmail__c               = true;
        objConf.COM_EnvioOnBase__c              = true;
        objConf.COM_IdentificadorProceso__c     = 'TST';
        insert objConf;

        objConf                                 = new COM_ConfiguracionEnvioDocs__c();
        objConf.Name                            = 'Test2';
        objConf.COM_EnvioEmail__c               = false;
        objConf.COM_EnvioOnBase__c              = true;
        objConf.COM_IdentificadorProceso__c     = 'TST2';
        insert objConf;

        objConf                                 = new COM_ConfiguracionEnvioDocs__c();
        objConf.Name                            = 'Test3';
        objConf.COM_EnvioEmail__c               = true;
        objConf.COM_EnvioOnBase__c              = false;
        objConf.COM_IdentificadorProceso__c     = 'TST3';
        insert objConf;*/
    }

    static testMethod void test_method_sucess() 
    {
        createDate();
        Test.startTest();

            COM_ConsultarEnvioDocumentos_cls.TipoEnviosDocuemnto objTipoEnvioDoc = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos('ACT');
            System.assert(objTipoEnvioDoc.blnEmail);
            System.assert(objTipoEnvioDoc.blnOnBase);

            objTipoEnvioDoc = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos('APO');
            //System.assert(!objTipoEnvioDoc.blnEmail);
            System.assert(objTipoEnvioDoc.blnOnBase);

            objTipoEnvioDoc = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos('PAF');
            System.assert(objTipoEnvioDoc.blnEmail);
            //System.assert(!objTipoEnvioDoc.blnOnBase);

        Test.stopTest();
    }

    static testMethod void test_method_Errors() 
    {
        createDate();
        Test.startTest();

            COM_ConsultarEnvioDocumentos_cls.TipoEnviosDocuemnto objTipoEnvioDoc = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos(null);
            System.assertEquals(objTipoEnvioDoc.strError,Label.COM_SinIdentificadorProceso);

            objTipoEnvioDoc = COM_ConsultarEnvioDocumentos_cls.consultarEnvioDocumentos('Prueba');
            System.assertEquals(objTipoEnvioDoc.strError,Label.COM_NoEncontroConfiguracion);

        Test.stopTest();
    }

    static testMethod void test_method_one() {
        set<String> correos = new set<String>();
        correos.add('prueba@prueba.com');
        COM_ConsultarEnvioDocumentos_cls.enviarDocumentos('APO', correos, new set<Id>(), 'asunto', 'cuerpo', '', null, null);
    }

    static testMethod void test_method_two() {
        set<Id> addt = new set<Id>();
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Attachment att = COM_DataGenerator_cls.creaAdjunto(true, acc.Id);
        Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        //EmailTemplate et =  COM_DataGenerator_cls.crearEmailTemplate(true);
        addt.add(att.Id);
        COM_ConsultarEnvioDocumentos_cls.enviarDocumentos('APO', new set<String>(), addt, '', '', 'CotizacionConvencionLagoMar', con.Id, acc.Id);
    }

    static testMethod void test_method_three() {
        set<Id> addt = new set<Id>();
        set<String> correos = new set<String>();
        correos.add('prueba@prueba.com');
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Attachment att = COM_DataGenerator_cls.creaAdjunto(true, acc.Id);
        Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        //EmailTemplate et =  COM_DataGenerator_cls.crearEmailTemplate(true);
        addt.add(att.Id);
        COM_ConsultarEnvioDocumentos_cls.enviarDocumentos('APO', correos, addt, '', '', 'CotizacionConvencionLagoMar', con.Id, acc.Id);
    }
     
}