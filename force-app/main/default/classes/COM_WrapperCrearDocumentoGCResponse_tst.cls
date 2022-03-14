@isTest
private class COM_WrapperCrearDocumentoGCResponse_tst {
	
	@isTest static void test_method_one() {
		COM_WrapperCrearDocumentoGCResponse_cls.System_x system_x = new COM_WrapperCrearDocumentoGCResponse_cls.System_x();
		system_x.RequestDate = '';
		system_x.ResponseDate = '';
		system_x.SystemInvokedService = '';
		system_x.TransactionID = '';
		COM_WrapperCrearDocumentoGCResponse_cls.Header header = new COM_WrapperCrearDocumentoGCResponse_cls.Header();
		header.System_x = system_x;
		COM_WrapperCrearDocumentoGCResponse_cls.Result result = new COM_WrapperCrearDocumentoGCResponse_cls.Result();
		result.DocumentHandle = '';
		COM_WrapperCrearDocumentoGCResponse_cls.Response response = new COM_WrapperCrearDocumentoGCResponse_cls.Response();
		response.Code = '';
		response.Description = '';
		response.ErrorCode = '';
		response.Result = result;
		COM_WrapperCrearDocumentoGCResponse_cls.Xml xml = new COM_WrapperCrearDocumentoGCResponse_cls.Xml();
		xml.Response = response;
		COM_WrapperCrearDocumentoGCResponse_cls.ExecuteResult executeResult = new COM_WrapperCrearDocumentoGCResponse_cls.ExecuteResult();
		executeResult.xml = xml;
		COM_WrapperCrearDocumentoGCResponse_cls.ExecuteResponse executeResponse = new COM_WrapperCrearDocumentoGCResponse_cls.ExecuteResponse();
		executeResponse.ExecuteResult = executeResult;
		COM_WrapperCrearDocumentoGCResponse_cls.OnBaseServExecuteRs onBaseServExecuteRs = new COM_WrapperCrearDocumentoGCResponse_cls.OnBaseServExecuteRs();
		onBaseServExecuteRs.ExecuteResponse = executeResponse;
		COM_WrapperCrearDocumentoGCResponse_cls.WsDocServExecuteOnBaseRs wsDocServExecuteOnBaseRs = new COM_WrapperCrearDocumentoGCResponse_cls.WsDocServExecuteOnBaseRs();
		wsDocServExecuteOnBaseRs.OnBaseServ_Execute_Rs = onBaseServExecuteRs;
		wsDocServExecuteOnBaseRs.Header = header;
		COM_WrapperCrearDocumentoGCResponse_cls.Body body = new COM_WrapperCrearDocumentoGCResponse_cls.Body();
		body.WsDocServ_ExecuteOnBase_Rs = wsDocServExecuteOnBaseRs;
		COM_WrapperCrearDocumentoGCResponse_cls.Envelope envelope = new COM_WrapperCrearDocumentoGCResponse_cls.Envelope();
		envelope.Header = '';
		envelope.Body = body;
		COM_WrapperCrearDocumentoGCResponse_cls.RootObject rootObject = new COM_WrapperCrearDocumentoGCResponse_cls.RootObject();
		rootObject.Envelope = envelope;
		COM_WrapperCrearDocumentoGCResponse_cls wpr = new COM_WrapperCrearDocumentoGCResponse_cls();
		wpr.Body = body;
	}	

}