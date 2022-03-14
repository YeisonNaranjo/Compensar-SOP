/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase de pruebas para la clase RF2_EncuestasCasos_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/20      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
@isTest
public with sharing class RF2_EncuestasCasos_tst {
    
    @istest
    public static void pruebaEncuestaCaso() {
        
        list<QueueSobject> lstQueueSobject = [SELECT Id,QueueId FROM QueueSobject WHERE SobjectType = 'RF2_EncuestasCasos__c'];
        set<Id> setQueueId = new set<Id>();
        for(QueueSobject objQueueSobject : lstQueueSobject){
            setQueueId.add(objQueueSobject.QueueId);
        }
        list<GroupMember> lgm = [select groupid, UserOrGroupId from GroupMember WHERE GroupId IN :setQueueId];
        list<rf2_enrutador__c> le = new list<rf2_enrutador__c>();
        set<string> ss = new set<string>();
        system.debug('>>>>>>>>>> lgm: ' + lgm);
        if(!lgm.isEmpty()){
            for(groupmember gm :lgm){
                rf2_enrutador__c e = new rf2_enrutador__c();
                e.rf2_cola__c = gm.groupid;
                e.rf2_usuario__c = gm.UserOrGroupId;
                datetime d = Datetime.now();
                e.RF2_AsignacionCasos__c = String.valueOf(d.year()) + String.valueOf(d.month()) + String.valueOf(d.day()) + String.valueOf(d.hour()) + String.valueOf(d.minute()) + String.valueOf(d.second()) + String.valueOf(d.millisecond());
                e.RF2_Llave__c = (string)gm.groupid+(string)gm.UserOrGroupId;
                le.add(e);
                ss.add(e.RF2_Llave__c);
            }
            upsert le RF2_Llave__c;
            
            le = new list<rf2_enrutador__c>();
            list<rf2_enrutador__c> leOld = new list<rf2_enrutador__c>([select Id, RF2_Llave__c from rf2_enrutador__c]);
            for(rf2_enrutador__c e : leOld){
                if(!ss.contains(e.RF2_Llave__c)){
                    le.add(e);
                }
            }
            delete le;
            list<RecordType> lstRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'RF2_EncuestaChat' AND SObjectType = 'RF2_EncuestasCasos__c'];
            if(!lstRecordType.isEmpty()){
                Test.startTest();
                    RF2_EncuestasCasos__c objEncuestasCasos;
                
                    objEncuestasCasos = new RF2_EncuestasCasos__c();
                    objEncuestasCasos.RecordTypeId = lstRecordType.get(0).Id;
                    objEncuestasCasos.OwnerId = lgm.get(0).groupid;
                    objEncuestasCasos.RF2_ChatKey__c = 'xxxxxxxxxxxxxxxxxxx';
                    objEncuestasCasos.RF2_CalificacionSoporteChat__c = '3';
                    objEncuestasCasos.RF2_ResolucionInquietudes__c = true;
                    objEncuestasCasos.RF2_CalificacionRecomendacionChat__c = '7';
                    objEncuestasCasos.RF2_RazonCalificacion__c = 'xxxxxxxxxxxxx';
                    objEncuestasCasos.RF2_Estado__c = 'Cerrada';
                    
                    insert objEncuestasCasos;
                
                Test.stopTest();
            }
        }
    }
    
}