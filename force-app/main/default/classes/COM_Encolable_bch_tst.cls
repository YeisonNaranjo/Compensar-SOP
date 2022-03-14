/**
* Avanxo Colombia
* @author       Stifen Panche Gutierrez (SP)
* Project:      Compensar
* Description:    Clase encargada de ejecutar  un batch para sumar metas individuales, debería enviarse todas las noches.
*                  COM_SumarMetas_sch
*         
* Changes (Version)
* -------------------------------------
* No.                 Date            Author              Description
*  ----- ----------    ------------------------------     ---------------
* @version  1.0       25/10/2018    Stifen Panche (SP)    Clase de prueba para Encolable_cls y AsignarPropietarioColas_sch
**/


@isTest
private class COM_Encolable_bch_tst
{
    
    @testSetup static void createDataTest(){
        
        DescribeFieldResult describe = Case.RF2_ProcesoDestinoMatrizResponsable__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();

		list<groupmember> lgm = [select groupid, UserOrGroupId from groupmember where UserOrGroupId IN (SELECT Id FROM User where isactive=true)];
		list<rf2_enrutador__c> le = new list<rf2_enrutador__c>();
		set<string> ss = new set<string>();
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


        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        
        System.debug('crearCuenta: ' + acc);//<--Anexo por validación de fallo Lionner Moque
        
        //Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        Test.startTest();
       // createData(acc.Id);
       RF2_Case_cls.stopTrigger();
                RF2_EncuestasCasos_cls.stopTrigger();

          User aUser = new User(
        	Username = 'Cola@gmail.com',
            LastName = 'Cola', 
            Email = 'test@test.com', 
            Alias = 'test', 
            CommunityNickname = 'test', 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8',
            ProfileId =   [SELECT Id FROM Profile where name = 'Gestor Servicio al Cliente GIE'].Id, //<--Anexo por validación de fallo Lionner Moque
            //ProfileId = [SELECT Id FROM Profile Limit 1].Id, 
            LanguageLocaleKey = 'en_US',
            Department = 'Gestión información empresarial - GIE',
            Division = 'Gestión documental',
        	isActive = true);
        Insert aUser;
        System.debug('aUser: '+ aUser);//<--Anexo por validación de fallo Lionner Moque
        //Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, null, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, null, 'Solicitud GIE', 'Pensionado', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', false);      
		//Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Solicitud GIE', 'Pensionado', 'Traslado de aportes a otras CCF', 'Aportes', 'Pagina Web', true);
        System.debug('lgm[0].groupId: ' + lgm[0].groupId);//<--Anexo por validación de fallo Lionner Moque
        //caso.ownerId =  lgm[0].groupId;
		//update caso;
        System.debug('caso: '+ caso);//<--Anexo por validación de fallo Lionner Moque
		Case caso2 =  COM_DataGenerator_cls.crearCasox(true, acc.Id, null, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Call Center', false);      
		caso2.ownerId =  aUser.Id;
		update caso2;
        System.debug('caso2: '+ caso2);
		RF2_Case_cls.startTrigger();
        RF2_EncuestasCasos_cls.startTrigger();

        COM_Encolable_cls.fechaAsignacion();
        Test.stopTest();
    }

  static testmethod void testAsignarCasos() {
        Test.startTest();
        List<Case> lstCases = [Select Id From Case];


        Set<String> setCaseIds = new Set<String>();

   		System.debug('setCaseIds  ' + setCaseIds);

   		for(Case c : lstCases)
   		{
   			setCaseIds.add(c.Id);
   		}

   		COM_Encolable_cls.asignarPropetarioColas(setCaseIds, 'Case', 'RF2_AsignacionCasos__c');


        Test.stopTest();
    }

           
    static testmethod void sendBatch() {
        Test.startTest();
        COM_AsignarPropietarioColas_sch sch = new COM_AsignarPropietarioColas_sch();
        String strSch = '0 0 23 * * ?'; 
        system.schedule('Programar', strSch, sch);
        Test.stopTest();
    }
}