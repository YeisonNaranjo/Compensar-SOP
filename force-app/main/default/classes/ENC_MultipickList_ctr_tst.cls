@isTest
private class ENC_MultipickList_ctr_tst {
	
	@isTest static void test_method_one() {
		ENC_MultipickList_ctr ppp = new ENC_MultipickList_ctr();
		System.debug(ppp.leftOptions);
		System.debug(ppp.rightOptions);
		System.debug(ppp.leftOptionsHidden);
		System.debug(ppp.rightOptionsHidden);
		ppp.leftOptions = new SelectOption[]{};
	    ppp.rightOptions = new SelectOption[]{};
		ppp.leftOptionsHidden = '1&2&3';
		ppp.rightOptionsHidden = '1&2&3';
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}