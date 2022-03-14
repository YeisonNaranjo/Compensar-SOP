@isTest private class RF2_Enrutador_tst {
	
	@isTest static void test_method_1(){
		list<groupmember> lgm = [select groupid, UserOrGroupId from groupmember];
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
		/*le = new list<rf2_enrutador__c>();
		list<rf2_enrutador__c> leOld = new list<rf2_enrutador__c>([select Id, RF2_Llave__c from rf2_enrutador__c]);
		for(rf2_enrutador__c e : leOld){
		if(!ss.contains(e.RF2_Llave__c)){
		le.add(e);
		}
		}
		delete le;*/

		COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);


		Case caso1 = COM_DataGenerator_cls.crearCaso(false, null, null);
		COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
			caso1.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
			caso1.RF2_NombreContactoHuerfano__c = 'j rubencho';
			caso1.RF2_CiudadHuerfano__c = pob.Id;
			caso1.RF2_CompanyaHuerfano__c = 'company';
			caso1.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
			caso1.RF2_NombreContactoHuerfano__c = 'huerfanito';
			caso1.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
			caso1.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
			caso1.RF2_TelefonoHuerfano__c = '323333232';
			caso1.RF2_TelefonoMovilHuerfano__c = '2132132132';
			caso1.RF2_TipoIdentificacionHuerfano__c = '1';
			caso1.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
   			caso1.RF2_RelacionadoCon__c = 'Alimentos';
   			caso1.RF2_TipoSolicitud__c = 'Queja';
   			caso1.Origin = 'Atención Presencial';


		Case caso2 = COM_DataGenerator_cls.crearCaso(false, null, null);
			caso2.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
			caso2.RF2_NombreContactoHuerfano__c = 'j rubencho';
			caso2.RF2_CiudadHuerfano__c = pob.Id;
			caso2.RF2_CompanyaHuerfano__c = 'company';
			caso2.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
			caso2.RF2_NombreContactoHuerfano__c = 'huerfanito';
			caso2.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
			caso2.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
			caso2.RF2_TelefonoHuerfano__c = '323333232';
			caso2.RF2_TelefonoMovilHuerfano__c = '2132132132';
			caso2.RF2_TipoIdentificacionHuerfano__c = '1';
			caso2.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
   			caso2.RF2_RelacionadoCon__c = 'Alimentos';
   			caso2.RF2_TipoSolicitud__c = 'Queja';
   			caso2.Origin = 'Atención Presencial';
		Case caso3 = COM_DataGenerator_cls.crearCaso(false, null, null);
			caso3.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
			caso3.RF2_NombreContactoHuerfano__c = 'j rubencho';
			caso3.RF2_CiudadHuerfano__c = pob.Id;
			caso3.RF2_CompanyaHuerfano__c = 'company';
			caso3.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
			caso3.RF2_NombreContactoHuerfano__c = 'huerfanito';
			caso3.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
			caso3.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
			caso3.RF2_TelefonoHuerfano__c = '323333232';
			caso3.RF2_TelefonoMovilHuerfano__c = '2132132132';
			caso3.RF2_TipoIdentificacionHuerfano__c = '1';
			caso3.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
   			caso3.RF2_RelacionadoCon__c = 'Subsidio vivienda';
   			caso3.RF2_TipoSolicitud__c = 'Queja';
   			caso3.Origin = 'Atención Presencial';
		Case caso4 = COM_DataGenerator_cls.crearCaso(false, null, null);
					caso4.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
			caso4.RF2_NombreContactoHuerfano__c = 'j rubencho';
			caso4.RF2_CiudadHuerfano__c = pob.Id;
			caso4.RF2_CompanyaHuerfano__c = 'company';
			caso4.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
			caso4.RF2_NombreContactoHuerfano__c = 'huerfanito';
			caso4.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
			caso4.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
			caso4.RF2_TelefonoHuerfano__c = '323333232';
			caso4.RF2_TelefonoMovilHuerfano__c = '2132132132';
			caso4.RF2_TipoIdentificacionHuerfano__c = '1';
			caso4.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
   			caso4.RF2_RelacionadoCon__c = 'Subsidio vivienda';
   			caso4.RF2_TipoSolicitud__c = 'Queja';
   			caso4.Origin = 'Atención Presencial';
			Test.startTest();
			insert caso1;
			insert caso2;
			insert caso3;
			insert caso4;
		/*Set<String> idses = new Set<String>();
		idses.add(caso1.Id);
		idses.add(caso2.Id);
		idses.add(caso3.Id);
		idses.add(caso4.Id);
		
			RF2_Enrutador_cls.asignarPropetario(idses);*/
			RF2_Enrutador_cls.fechaAsignacion();
		Test.stopTest();
	}



	@isTest static void test_method_2(){


	

		Case caso1 = COM_DataGenerator_cls.crearCaso(false, null, null);
		COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
			caso1.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
			caso1.RF2_NombreContactoHuerfano__c = 'j rubencho';
			caso1.RF2_CiudadHuerfano__c = pob.Id;
			caso1.RF2_CompanyaHuerfano__c = 'company';
			caso1.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
			caso1.RF2_NombreContactoHuerfano__c = 'huerfanito';
			caso1.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
			caso1.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
			caso1.RF2_TelefonoHuerfano__c = '323333232';
			caso1.RF2_TelefonoMovilHuerfano__c = '2132132132';
			caso1.RF2_TipoIdentificacionHuerfano__c = '1';
			caso1.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM PCE';
   			caso1.RF2_RelacionadoCon__c = 'Alimentos';
   			caso1.RF2_TipoSolicitud__c = 'Queja';
   			caso1.Origin = 'Atención Presencial';


			insert caso1;

	}
    
}