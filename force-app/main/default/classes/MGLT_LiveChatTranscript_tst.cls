/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Lionner Steven Moque (LSM)
Proyecto:          Compensar
Descripción:       Clase de prueba objeto LiveChatTranscript

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   --------------------------  ---------------------------------------------
    1.0     13/12/19        Lionner Steven Moque (LSM)             Clase de prueba.
************************************************************************************************/
@isTest



private class MGLT_LiveChatTranscript_tst {


    /*static User objUser;

   static {
       String strProfileName = UserInfo.getLanguage().startsWith('es') ? 'Administrador del sistema' : 'System Administrator';

       List<Profile> lstProfiles = [SELECT Id
                                      FROM Profile
                                     WHERE Name =: strProfileName
                                     LIMIT 1];

       if(!lstProfiles.isEmpty()) {
           String strRandom 								= EncodingUtil.base64encode(Crypto.generateAesKey(192)).substring(0, 8);

           User objUser = new User();
           objUser.ProfileId           						= lstProfiles[0].Id;
           objUser.LastName            						= 'Last Name';
           objUser.Alias               						= strRandom;
           objUser.Email               						= strRandom + '@testemail.com';
           objUser.UserName            						= strRandom + '@testemail.com';
           objUser.EmailEncodingKey    						= 'UTF-8';
           objUser.LocaleSidKey        						= 'en_US';
           objUser.LanguageLocaleKey   						= 'en_US';
           objUser.TimeZoneSidKey      						= 'America/Los_Angeles';
           objUser.Department								= 'Tecnología';
           objUser.Division									= 'Tecnología';
		   insert objUser;
       }
   }*/
    
	//Metodo: asociarClienteATranscripcion
	
    @isTest static void asociarClienteATranscripcion(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '1';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;			
		Test.stopTest();
		 
		LiveChatTranscript objLiveChatTransQuery	 		= [	SELECT  Id, AccountId
																  FROM  LiveChatTranscript
																 WHERE  Id =: objLiveChatTrans.Id];
		System.assertEquals(objCuenta.Id, objLiveChatTransQuery.AccountId, 'No se asignó la cuenta a la transcripción de chat');
	}
    
    
    
    @isTest static void setTipoIdentificacionTst1(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '1';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}

    @isTest static void setTipoIdentificacionTst2(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '2';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}
        
    @isTest static void setTipoIdentificacionTst3(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '3';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}
		
    @isTest static void setTipoIdentificacionTst4(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '4';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}
		
    @isTest static void setTipoIdentificacionTst5(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '5';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}

    @isTest static void setTipoIdentificacionTst6(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '6';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}

    @isTest static void setTipoIdentificacionTst7(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '7';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}
    @isTest static void setTipoIdentificacionTst8(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '8';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}

    @isTest static void setTipoIdentificacionTst9(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		Test.startTest();
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '9';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
		Test.stopTest();
		}
		
	@isTest static void cambiarPropietarioCaso(){
		Account objCuenta 									= COM_DataGenerator_cls.crearCuenta(false);
		objCuenta.COM_Numero_de_identificacion__c 			= '1014204900';
		insert objCuenta;
			
		Contact objContacto									= COM_DataGenerator_cls.crearContacto(false, objCuenta.Id);
		objContacto.COM_Numeroidentificacion__c				= '1014204900';
		insert objContacto;
		
		Case objCaso										= COM_DataGenerator_cls.crearCaso(true, objCuenta.Id, objContacto.Id);
        
        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
		insert objLiveChatVisitor;
		
		LiveChatTranscript objLiveChatTrans;
		
			
			objLiveChatTrans 	= New LiveChatTranscript();
			
			objLiveChatTrans.AccountId 						= objCuenta.Id;
			objLiveChatTrans.ContactId						= objContacto.Id;
			objLiveChatTrans.CaseId							= objCaso.Id;
			objLiveChatTrans.RF2_Apellidos__c				= 'Test';
			objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
			objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
			objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
			objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        	objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '1';
			objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        	objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
			
			insert objLiveChatTrans;
        User objUser = new User(
        	Username = 'Cola@gmail.com',
            LastName = 'Cola', 
            Email = 'test@test.com', 
            Alias = 'test', 
            CommunityNickname = 'test', 
            TimeZoneSidKey = 'America/Bogota', 
            LocaleSidKey = 'es_CO', 
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId =   [SELECT Id FROM Profile where name = 'Analista Servicio Cliente PCA'].Id, //<--Anexo por validación de fallo Lionner Moque
            RF2_Canal__c = 'Atención Presencial',
            //ProfileId = [SELECT Id FROM Profile Limit 1].Id, 
            LanguageLocaleKey = 'es',
            Department = 'Proceso centro de experiencia - PCE',
            Division = 'Canales de atención',
        	isActive = true);
        Insert objUser;
		Test.startTest();
			objLiveChatTrans.OwnerId						= objUser.Id;
			update objLiveChatTrans;
		Test.stopTest();		
		
		/* case objCaseQuery	 		= [	SELECT  Id, OwnerId
										  FROM  Case
										 WHERE  Id =: objCaso.Id];
		System.assertEquals(objUser.Id, objCaseQuery.OwnerId, 'No se asignó el nuevo propietario al caso'); */
	}
	
	
}