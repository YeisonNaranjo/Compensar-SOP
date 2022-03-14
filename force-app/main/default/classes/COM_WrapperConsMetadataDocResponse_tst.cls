@isTest
private class COM_WrapperConsMetadataDocResponse_tst {
	@isTest static void test_method_one() {
		COM_WrapperConsMetadataDocResponse_cls.Attributtes attributtes = new COM_WrapperConsMetadataDocResponse_cls.Attributtes();
		attributtes.name = '';
		attributtes.id = '';
		COM_WrapperConsMetadataDocResponse_cls.Document_x document_x = new COM_WrapperConsMetadataDocResponse_cls.Document_x();
		document_x.attributtes = attributtes;
		document_x.value = '';
		COM_WrapperConsMetadataDocResponse_cls.DocumentType_x documentType_x = new COM_WrapperConsMetadataDocResponse_cls.DocumentType_x();
		documentType_x.attributtes = attributtes;
		documentType_x.value = '';
		COM_WrapperConsMetadataDocResponse_cls.Document document = new COM_WrapperConsMetadataDocResponse_cls.Document();
		document.DateStored = '';
		document.DocumentType_x = documentType_x;
		document.LatestRevision = '';
			List<COM_WrapperConsMetadataDocResponse_cls.Document_x> lstDocument_x = new List<COM_WrapperConsMetadataDocResponse_cls.Document_x>();
			lstDocument_x.add(document_x);
		document.Document_x = lstDocument_x;
		COM_WrapperConsMetadataDocResponse_cls.Result result = new COM_WrapperConsMetadataDocResponse_cls.Result();
			List<COM_WrapperConsMetadataDocResponse_cls.Document> lstDocument = new List<COM_WrapperConsMetadataDocResponse_cls.Document>();
			lstDocument.add(document);
		result.Document = lstDocument;
		COM_WrapperConsMetadataDocResponse_cls.Response response = new COM_WrapperConsMetadataDocResponse_cls.Response();
		response.Result = result;
		response.Code = '';
		COM_WrapperConsMetadataDocResponse_cls.Xml xml = new COM_WrapperConsMetadataDocResponse_cls.Xml();
		xml.Response = response;
		COM_WrapperConsMetadataDocResponse_cls.ExecuteResult executeResult = new COM_WrapperConsMetadataDocResponse_cls.ExecuteResult();
		executeResult.xml = xml;
		COM_WrapperConsMetadataDocResponse_cls.ExecuteResponse executeResponse = new COM_WrapperConsMetadataDocResponse_cls.ExecuteResponse();
		executeResponse.ExecuteResult = executeResult;
		COM_WrapperConsMetadataDocResponse_cls.OnBaseServExecuteRs onBaseServExecuteRs = new COM_WrapperConsMetadataDocResponse_cls.OnBaseServExecuteRs();
		onBaseServExecuteRs.ExecuteResponse = executeResponse;
		COM_WrapperConsMetadataDocResponse_cls.System_x system_X = new COM_WrapperConsMetadataDocResponse_cls.System_x();
		system_X.TransactionID = '';
		system_X.SystemInvokedService = '';
		system_X.ResponseDate = Datetime.newInstance(2017,10,1);
		system_X.RequestDate = Datetime.newInstance(2017,10,1);
		COM_WrapperConsMetadataDocResponse_cls.Header header = new COM_WrapperConsMetadataDocResponse_cls.Header();
		header.System_x = system_X;
		COM_WrapperConsMetadataDocResponse_cls.WsDocServExecuteOnBaseRs wsDocServExecuteOnBaseRs = new COM_WrapperConsMetadataDocResponse_cls.WsDocServExecuteOnBaseRs();
		wsDocServExecuteOnBaseRs.OnBaseServ_Execute_Rs = onBaseServExecuteRs;
		wsDocServExecuteOnBaseRs.Header = header;
		COM_WrapperConsMetadataDocResponse_cls.Body body = new COM_WrapperConsMetadataDocResponse_cls.Body();
		body.WsDocServ_ExecuteOnBase_Rs = wsDocServExecuteOnBaseRs;
		COM_WrapperConsMetadataDocResponse_cls.RootObject rootObject = new COM_WrapperConsMetadataDocResponse_cls.RootObject();
		rootObject.Body = body;
		COM_WrapperConsMetadataDocResponse_cls wpr = new COM_WrapperConsMetadataDocResponse_cls();
		wpr.Body = body;
	}
}