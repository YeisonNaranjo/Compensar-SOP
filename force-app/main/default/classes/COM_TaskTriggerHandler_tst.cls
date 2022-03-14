/****************************************************************************************************
    -------------------
    Developer:        Avanxo Colombia
    Autor:            Jordan Steven Parra Torres
    Project:          Compensar
    Description:      
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     2018-06-13  Jordan Parra                Clase de prueba para eliminar una tarea.
 ****************************************************************************************************/
@isTest
private class COM_TaskTriggerHandler_tst {
	
	@isTest static void test_method_one() {

		ID_Admin_Casos__c setting = new ID_Admin_Casos__c(); 
		setting.Name = 'Test Setting'; 
		setting.ID__c = (userinfo.getProfileId()).subString(0,15);      
		insert setting;

		Case caseTest=new Case();
		insert caseTest;

		Task tsk =new Task(); 
		tsk.WhatId = caseTest.Id;  
		insert tsk;

		test.startTest();
		delete tsk;
		test.stopTest();
	}
}