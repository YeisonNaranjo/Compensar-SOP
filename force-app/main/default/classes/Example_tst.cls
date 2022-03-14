@isTest
private class Example_tst {
	
	@isTest static void test_method_one() {
		Example ex = new Example();
		ex.getResponse();
		ex.setResponse(null);
	}
	
	@isTest static void test_method_two() {
		Example.Response rs = new Example.Response();
		rs.getResult() ;
		rs.setResult(null);
		rs.getCode();
		rs.setCode('');

		Example.Result rl = new Example.Result(); 
		rl.getDocument();
		rl.setDocument(new List<Example.Document>());

		Example.Document d = new Example.Document();
		d.getDateStored();
		d.setDateStored('');
		d.getDocumentType();
		d.setDocumentType(null);
		d.getLatestRevision();
		d.setLatestRevision('');
		d.getDocument_x();
		d.setDocument(new List<Example.DocumentParentProperties>());

		Example.DocumentParentProperties dpp = new Example.DocumentParentProperties();
		dpp.getValue();
		dpp.setValue('');
		dpp.getAttributtes();
		dpp.setAttributtes(null);

		Example.Attributtes att = new Example.Attributtes();
		att.getName(); 
		att.setName('');
		att.getId();
		att.setId('');

		Example.DocumentType dt = new Example.DocumentType();
		dt.getValue();
		dt.setValue('');
		dt.getAttributtes();
		dt.setAttributtes(null);
	}

}