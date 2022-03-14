/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Test Class para sumisnitrar campos lupa a componente LookupGIE
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     30/10/19         Manuel Mendez  (MM)                    Creación Clase.
*************************************************************************************************/ 
@istest
public with sharing class CEL1_LookupCustom_tst {
    @istest public static void unit_Test1(){
        System.debug('PRUEBA---->>');
        Account account = COM_DataGenerator_cls.crearCuenta(true);
        Case objCase = COM_DataGenerator_cls.crearCasoAnonimo(true, account.Id);
        System.debug('objCase....'+objCase);
        CEL1_LookupCustom_ctr.WrapperTipificacionGIE objWrapperList = new CEL1_LookupCustom_ctr.WrapperTipificacionGIE();

        Test.startTest();
            CEL1_LookupCustom_ctr.WrapperLookup objWrapperGIE = new CEL1_LookupCustom_ctr.WrapperLookup();
            CEL1_LookupCustom_ctr.WrapperLookup objWrapperPCA = new CEL1_LookupCustom_ctr.WrapperLookup();
            CEL1_LookupCustom_ctr.WrapperLookup objWrapperGE = new CEL1_LookupCustom_ctr.WrapperLookup();
            objWrapperGIE = CEL1_LookupCustom_ctr.lupasTipificacionGIE(objCase.Id);
            System.debug('ENTRO A objWrapperGIE TEST CLASS....'+objWrapperGIE);
            objWrapperPCA = CEL1_LookupCustom_ctr.lupasTipificacionPCA(objCase.Id);
            objWrapperGE = CEL1_LookupCustom_ctr.lupasTipificacionGC(objCase.Id);
            CEL1_LookupCustom_ctr.guardarGIE(objWrapperGIE.lstTipificacionGIE,objCase.Id);
            CEL1_LookupCustom_ctr.guardarPCA(objWrapperPCA.lstTipificacionGIE,objCase.Id);
            CEL1_LookupCustom_ctr.guardarGE(objWrapperGE.lstTipificacionGIE,objCase.Id);
        Test.stopTest();
    }
}