@istest (SeeAllData=true)
public with sharing class COS_AsignacionCasosSalud_tst {
    @istest (SeeAllData=true)
    public static void unit_Test1(){
        
	    string idRecordType = [select id, name from RecordType where DeveloperName ='COS_RetencionRenovacionSalud' limit 1].id;
	   
	    List<Case> lstInsert = new  List<Case>();
	    List<Account> lstInsertAcc = new  List<Account>();
        Account objAcc = new account();
        objAcc.COM_TipoIdentificacion__c    = '1';
        objAcc.COM_Numero_de_identificacion__c = '834837321';
        objAcc.Name = 'Empresa';
        ObjAcc.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        ObjAcc.Phone = '4314234';
	    COM_AccountContactRelation_cls.stopTrigger();
        insert objAcc;
		
        user regUser = [select id, name from user where isActive=TRUE AND Profile.Name = 'Asesor Comercial Salud' limit 1];
        
        AccountTeamMember ATM = new AccountTeamMember();
        ATM.UserId = regUser.Id;
        ATM.AccountId = objAcc.Id;  
        insert ATM;
        
        
        Case objCase = New Case();
        objCase.RecordTypeId = idRecordType;
        objCase.AccountId = objAcc.id;
        objCase.Origin = 'Sistemas Legados';
        objCase.Status = 'Nueva Renovación';
        objCase.COS_TipoCaso__c = 'Renovación';
        objCase.COS_TipoDocumento__c = '1';
        objCase.COS_NumeroDocumento__c = '834837321';
        objCase.Subject = 'case subject';
        objCase.Description = 'Case Description';
        objCase.Origin = 'Sistemas Legados';
        objCase.COS_TipoCaso__c = 'Renovación';
        lstInsert.add(objCase);
        
        Case objCase2 = New Case();
        objCase2.RecordTypeId = idRecordType;
        objCase2.AccountId = objAcc.id;
        objCase2.Origin = 'Sistemas Legados';
        objCase2.Status = 'Nueva Renovación';
        objCase2.COS_TipoCaso__c = 'Renovación';
        objCase2.COS_TipoDocumento__c = '2';
        objCase2.COS_NumeroDocumento__c = '901286901';
        objCase2.Subject = 'case subject';
        objCase2.Description = 'Case Description';
        objCase2.Origin = 'Sistemas Legados';
        objCase2.COS_TipoCaso__c = 'Renovación';
        lstInsert.add(objCase2);
        
        Case objCase3 = New Case();
        objCase3.RecordTypeId = idRecordType;
        objCase3.AccountId = objAcc.id;
        objCase3.Origin = 'Sistemas Legados';
        objCase3.Status = 'Nueva Renovación';
        objCase3.COS_TipoCaso__c = 'Fidelización';
        objCase3.COS_TipoDocumento__c = '1';
        objCase3.COS_NumeroDocumento__c = '901286902';
        objCase3.COS_EmailOwner__c = 'usuarioprueba@compensar.com';
        objCase3.Subject = 'case subject';
        objCase3.Description = 'Case Description';
        objCase3.Origin = 'Sistemas Legados';
        objCase3.COS_TipoCaso__c = 'Fidelización';
        lstInsert.add(objCase3);
        
        Case objCase5 = New Case();
        objCase5.RecordTypeId = idRecordType;
        objCase5.AccountId = objAcc.id;
        objCase5.Origin = 'Sistemas Legados';
        objCase5.Status = 'Nueva Renovación';
        objCase5.COS_TipoCaso__c = 'Fidelización';
        objCase5.COS_TipoDocumento__c = '1';
        objCase5.COS_NumeroDocumento__c = '901286903';
        objCase5.COS_EmailOwner__c = 'asesorsalud@compensar.test';
        objCase5.Subject = 'case subject';
        objCase5.Description = 'Case Description';
        objCase5.Origin = 'Sistemas Legados';
        objCase5.COS_TipoCaso__c = 'Fidelización';
        lstInsert.add(objCase5);
        
        Case objCase4 = New Case();
        objCase4.RecordTypeId = idRecordType;
        objCase4.AccountId = objAcc.id;
        objCase4.Origin = 'Sistemas Legados';
        objCase4.Status = 'Nueva Renovación';
        objCase4.COS_TipoCaso__c = 'Retención';
        objCase4.COS_TipoDocumento__c = '1';
        objCase4.COS_NumeroDocumento__c = '901279021';
        objCase4.COS_EmailOwner__c = 'usua@compensartest.com';
        objCase4.Subject = 'case subject';
        objCase4.Description = 'Case Description';
        objCase4.Origin = 'Sistemas Legados';
        objCase4.COS_TipoCaso__c = 'Retención';
        lstInsert.add(objCase4);
        
        for (Integer i=0; i< 5; i++) {
            
        Case objCaseF = New Case();
        objCaseF.RecordTypeId = idRecordType;
        objCaseF.AccountId = objAcc.id;
        objCaseF.Origin = 'Sistemas Legados';
        objCaseF.Status = 'Nueva Renovación';
        objCaseF.COS_TipoCaso__c = 'Retención';
        objCaseF.COS_TipoDocumento__c = '1';
        objCaseF.COS_NumeroDocumento__c = '901279000' + string.valueof(i);
        objCaseF.Subject = 'case subject';
        objCaseF.Description = 'Case Description';
        objCaseF.Origin = 'Sistemas Legados';
        objCaseF.COS_TipoCaso__c = 'Retención';    
        lstInsert.add(objCaseF);
            
        }
        

        Test.startTest();
        	//insert lstInsert;
        	COS_AsignacionCasosSalud_cls.asignacionCasos(lstInsert);
        Test.stopTest();
    
    
    }

}