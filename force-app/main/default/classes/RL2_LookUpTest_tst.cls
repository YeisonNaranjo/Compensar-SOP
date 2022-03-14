@isTest
private class RL2_LookUpTest_tst {

    private static final List<Map<Object,Object>> FIELDS = new List<Map<Object,Object>>{
        new Map<Object,Object>{ 'fieldApiName' => Schema.SObjectType.RL2_Poblacion__c.fields.Name.getSObjectField().getDescribe().getName()}
    };

    @TestSetup
    static void setup() {
        List<RL2_Poblacion__c> vNewPoblaciones = new List<RL2_Poblacion__c>{
            new RL2_Poblacion__c(Name = 'Colombia',RL2_EsPais__c = true),
            new RL2_Poblacion__c(Name = 'Santander'),
            new RL2_Poblacion__c(Name = 'Zapatoca')
        };
        insert vNewPoblaciones;
    }

    @IsTest
    static void getRecordTest() {
        RL2_Poblacion__c vObject = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c LIMIT 1];
        RL2_Poblacion__c vNewPoblacion = (RL2_Poblacion__c)RL2_LookUp_ctr.getRecord(vObject.Id, FIELDS);
        System.assert(vNewPoblacion != null, '');
        System.assertEquals(vObject.Name, vNewPoblacion.Name, '');
    }

    @IsTest
    static void searchRecordsTest() {
        List<RL2_Poblacion__c> vPoblaciones = (List<RL2_Poblacion__c>)RL2_LookUp_ctr.searchRecords('', new Map<Object, Object>{'objectApiName' => RL2_Poblacion__c.SObjectType}, FIELDS);
        System.assertEquals(3, vPoblaciones.size(),'');

        vPoblaciones = (List<RL2_Poblacion__c>)RL2_LookUp_ctr.searchRecords('Colombia', new Map<Object, Object>{'objectApiName' => RL2_Poblacion__c.SObjectType}, FIELDS);
        System.assertEquals(1, vPoblaciones.size(),'');
        System.assertEquals('Colombia', vPoblaciones[0].Name, '');

        vPoblaciones = (List<RL2_Poblacion__c>)RL2_LookUp_ctr.searchRecords('Colombia', new Map<Object, Object>{'objectApiName' => RL2_Poblacion__c.SObjectType}, FIELDS);
        System.assertEquals(1, vPoblaciones.size(), '');
    }

    @isTest
    static void fetchDefaultRecordTest() {
        RL2_Poblacion__c vPoblacion = [SELECT Id, Name, RL2_EsPais__c FROM RL2_Poblacion__c LIMIT 1];
        vPoblacion = (RL2_Poblacion__c) RL2_LookUp_ctr.fetchDefaultRecord(vPoblacion.Id, String.valueOf(RL2_Poblacion__c.SObjectType));
        
        System.assert(vPoblacion != null, '');
        System.assertEquals('Colombia', vPoblacion.Name, '');

        vPoblacion = (RL2_Poblacion__c) RL2_LookUp_ctr.fetchDefaultRecord('', String.valueOf(RL2_Poblacion__c.SObjectType));
        System.assert(vPoblacion == null, '');
    }

    @isTest
    static void lookUpTest(){
        String filter = 'RL2_EsPais__c = true';
        List<RL2_Poblacion__c> vPoblaciones = (List<RL2_Poblacion__c>)RL2_LookUp_ctr.lookUp('Colombia', String.valueOf(RL2_Poblacion__c.SObjectType), filter);
        System.assertEquals(1, vPoblaciones.size(),'');

        vPoblaciones = (List<RL2_Poblacion__c>)RL2_LookUp_ctr.lookUp('', String.valueOf(RL2_Poblacion__c.SObjectType), '');
        System.assertEquals(3, vPoblaciones.size(),'');

        vPoblaciones = (List<RL2_Poblacion__c>)RL2_LookUp_ctr.lookUp('Colombia', String.valueOf(RL2_Poblacion__c.SObjectType), '');
        System.assertEquals(1, vPoblaciones.size(),'');
        System.assertEquals('Colombia', vPoblaciones[0].Name, '');
    }
    
}