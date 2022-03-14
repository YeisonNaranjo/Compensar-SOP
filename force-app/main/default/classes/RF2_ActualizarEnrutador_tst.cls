@isTest
private class RF2_ActualizarEnrutador_tst {
    @isTest static void test_method_1() {
        Test.startTest();
            list<groupmember> lgm = [select groupid, UserOrGroupId from groupmember];
            list<rf2_enrutador__c> le = new list<rf2_enrutador__c>();
            set<string> ss = new set<string>();
            for(groupmember gm :lgm){
                rf2_enrutador__c e = new rf2_enrutador__c();
                e.rf2_cola__c = gm.groupid;
                e.rf2_usuario__c = gm.UserOrGroupId;
                e.RF2_Llave__c = (string)gm.groupid+(string)gm.UserOrGroupId;
                le.add(e);
                ss.add(e.RF2_Llave__c);
            }
            upsert le RF2_Llave__c;
            RF2_ActualizarEnrutador_ctr clase = new RF2_ActualizarEnrutador_ctr();
            clase.actualizarEnrutador();
        Test.stopTest();
    }
}