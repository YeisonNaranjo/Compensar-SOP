@isTest
private class COM_ObtenerBinarioDocumentoOnBase_ws_tst {
	
	@isTest static void test_method_one() {
		COM_ObtenerBinarioDocumentoOnBase_ws.BinarioDocumentoWrapper objBinarioDocumentoWrapper;
		objBinarioDocumentoWrapper = COM_ObtenerBinarioDocumentoOnBase_ws.obtenerBinarioDocumentoOnBase('79390031');
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		COM_ObtenerBinarioDocumentoOnBase_ws.BinarioDocumentoWrapper wp = new COM_ObtenerBinarioDocumentoOnBase_ws.BinarioDocumentoWrapper();
		system.debug(wp.strBinario);
		system.debug(wp.strExtension);
		system.debug(wp.strNombre);
	}
    
    @isTest static void test_method_three(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new COM_OnBaseMockService_tst());
        COM_ObtenerBinarioDocumentoOnBase_ws.BinarioDocumentoWrapper objBinarioDocumentoWrapper;
		objBinarioDocumentoWrapper = COM_ObtenerBinarioDocumentoOnBase_ws.obtenerBinarioDocumentoOnBase('79390031');
        Test.stopTest();
    }
	
}