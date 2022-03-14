@isTest
private class COM_TriggerExecutionControl_cls_tst {
	
	@isTest static void test_method_one() {
		COM_TriggerExecutionControl_cls.setAlreadyDone('1','2');
		 COM_TriggerExecutionControl_cls.hasAlreadyDone('1', '2'); 
	}
	
	@isTest static void test_method_two() {
		 COM_TriggerExecutionControl_cls.hasAlreadyDone('3', '4'); 
	}
	
}