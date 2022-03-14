@isTest
private class RF2_JSON2Apex_cls_tst {
	
	@isTest static void test_method_one() {
String attachedRecords = '{"CaseId":"el patron del mal", "ContactId":"todo bien"}';
String caseId = RF2_JSON2Apex_cls.parse(attachedRecords).Case_Z;
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}