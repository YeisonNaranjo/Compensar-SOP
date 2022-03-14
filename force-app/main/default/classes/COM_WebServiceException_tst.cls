@isTest
public with sharing class COM_WebServiceException_tst {
	public COM_WebServiceException_tst() {
		
	}

	@isTest static void test_method_one() {
		Test.startTest();
		COM_WebServiceException ex = new COM_WebServiceException();
		ex.strprueba = 'value';
		Test.stopTest();
	}
}