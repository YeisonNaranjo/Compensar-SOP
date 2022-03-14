@isTest
private class COM_WrapperConsBinarioDocResponse_tst {
	@isTest static void test_method_one() {
		COM_WrapperConsBinarioDocResponse_cls.Page_x page_x = new COM_WrapperConsBinarioDocResponse_cls.Page_x();
		page_x.Page_x = '';
		page_x.extension = '';
		COM_WrapperConsBinarioDocResponse_cls.Pages pages = new COM_WrapperConsBinarioDocResponse_cls.Pages();
		pages.Page_x = page_x;
		COM_WrapperConsBinarioDocResponse_cls.DocumentType documentType = new COM_WrapperConsBinarioDocResponse_cls.DocumentType();
		documentType.DocumentType = '';
		documentType.id = '';
		COM_WrapperConsBinarioDocResponse_cls.Document document = new COM_WrapperConsBinarioDocResponse_cls.Document();
		document.name = '';
		document.id = '';
		document.DateStored = '';
		document.LatestRevision = '';
		document.QueryError = '';
		document.DocumentType = documentType;
		document.Pages = pages;
		COM_WrapperConsBinarioDocResponse_cls.Result result = new COM_WrapperConsBinarioDocResponse_cls.Result();
		result.Document = document;
		COM_WrapperConsBinarioDocResponse_cls.Response response = new COM_WrapperConsBinarioDocResponse_cls.Response();
		response.Result = result;
		response.Code = '';
		COM_WrapperConsBinarioDocResponse_cls.Xml xml = new COM_WrapperConsBinarioDocResponse_cls.Xml();
		xml.Response = response;
		COM_WrapperConsBinarioDocResponse_cls.ExecuteResult executeResult = new COM_WrapperConsBinarioDocResponse_cls.ExecuteResult();
		executeResult.xml = xml;
		COM_WrapperConsBinarioDocResponse_cls.ExecuteResponse executeResponse = new COM_WrapperConsBinarioDocResponse_cls.ExecuteResponse();
		executeResponse.ExecuteResult = executeResult;
		COM_WrapperConsBinarioDocResponse_cls.OnBaseServExecuteRs onBaseServExecuteRs = new COM_WrapperConsBinarioDocResponse_cls.OnBaseServExecuteRs();
		onBaseServExecuteRs.ExecuteResponse = executeResponse;
		COM_WrapperConsBinarioDocResponse_cls.SystemX systemX = new COM_WrapperConsBinarioDocResponse_cls.SystemX();
		systemX.TransactionID = '';
		systemX.SystemInvokedService = '';
		systemX.ResponseDate = '';
		systemX.RequestDate = '';
		COM_WrapperConsBinarioDocResponse_cls.Header header = new COM_WrapperConsBinarioDocResponse_cls.Header();
		header.System_x = systemX;
		COM_WrapperConsBinarioDocResponse_cls.WsDocServExecuteOnBaseRs wsDocServExecuteOnBaseRs = new COM_WrapperConsBinarioDocResponse_cls.WsDocServExecuteOnBaseRs();
		wsDocServExecuteOnBaseRs.OnBaseServ_Execute_Rs = onBaseServExecuteRs;
		wsDocServExecuteOnBaseRs.Header = header;
		COM_WrapperConsBinarioDocResponse_cls.Body body = new COM_WrapperConsBinarioDocResponse_cls.Body();
		body.WsDocServ_ExecuteOnBase_Rs = wsDocServExecuteOnBaseRs;
		COM_WrapperConsBinarioDocResponse_cls.RootObject rootObject = new COM_WrapperConsBinarioDocResponse_cls.RootObject();
		rootObject.Body = body;
		COM_WrapperConsBinarioDocResponse_cls wpr = new COM_WrapperConsBinarioDocResponse_cls();
		wpr.Body = body;
	}	
}