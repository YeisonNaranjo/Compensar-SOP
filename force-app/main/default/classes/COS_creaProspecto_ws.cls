@RestResource(urlMapping='/COS_creaProspecto/*')
global class COS_creaProspecto_ws {
	@HttpPost
    global static string doPost(COS_creaProspectoRequest_dto Prospecto){
        system.debug('Prospecto --->'+Prospecto);
        string strNombres = '';
        string strApellidos = '';
        list<string> lstNombre = new list<string>();
        lstNombre = Prospecto.Nombre.split(' ');
        system.debug('lstNombre --->'+lstNombre);
        integer intSize = lstNombre.size();
        
        if(lstNombre.size() >= 4){
            strNombres = lstNombre[0]+' '+lstNombre[1];
            strApellidos = lstNombre[2]+' '+lstNombre[3];
        }
        if(lstNombre.size() == 3){
            strNombres = lstNombre[0];
            strApellidos = lstNombre[1]+' '+lstNombre[2];
        }
        if(lstNombre.size() == 2){
            strNombres = lstNombre[0];
            strApellidos = lstNombre[1];
        }
        
        if(lstNombre.size() == 1){
            strNombres = lstNombre[0];
            strApellidos = lstNombre[0];
        }
        
        system.debug('strNombres --->'+strNombres);
        system.debug('strApellidos --->'+strApellidos);
        map<string,string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Lead']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        map<string,string> mapUser = new map<string, string>();
        for(user us:[select Name, IsActive, Username, Email, COM_Identificacion__c from user where IsActive=true]){		 
            mapUser.put(us.Username, us.Id);
        }
        
        COM_LogTransacciones__c objLog = new COM_LogTransacciones__c();
        objLog.COM_FechaTransaccion__c = system.now();
        objLog.COM_Request__c = string.valueof(JSON.serialize(Prospecto));
        objLog.COM_TipoTransaccion__c = 'COS_creacionProspecto';
        
        COS_creaProspectoResponse_dto.responseLead objResponse;
        objResponse = new COS_creaProspectoResponse_dto.responseLead();
        objResponse.TipoID = Prospecto.TipoID;
        objResponse.NumID = Prospecto.NumID;
        list<COS_creaProspectoResponse_dto.responseLead> lstResponse = new list<COS_creaProspectoResponse_dto.responseLead>();
        COS_creaProspectoResponse_dto.Prospecto objProspecto = new COS_creaProspectoResponse_dto.Prospecto();
        
        lead nlead = new lead();
            nlead.CEL1_TipoDocumento__c = Prospecto.TipoID;
            nlead.CEL1_NumeroDocumento__c = Prospecto.NumID;
            nlead.FirstName = strNombres;
            nlead.LastName = strApellidos;
            nlead.Phone = Prospecto.TelefonoContactoFijo;
            nlead.MobilePhone = Prospecto.TelefonoContactoCelular;
            nlead.Email = Prospecto.Email;
            nlead.COS_Nit_empresa__c = Prospecto.NumeroEmpresa;
            nlead.COS_Genero__c = Prospecto.Genero;
            nlead.COS_FechaIngresoSolicitud__c = datetime.valueof(Prospecto.Fecha);
            nlead.LeadSource = Prospecto.Fuentes;
            nlead.COS_Categoria_Caja__c = Prospecto.CategoriaCaja;
//            if(mapUser.get(Prospecto.EmailAsesor)!=null && Prospecto.Fuentes=='VVP'){
            if(mapUser.get(Prospecto.EmailAsesor)!=null){
            	nlead.OwnerId = mapUser.get(Prospecto.EmailAsesor);
                nlead.COS_Asignado_salud__c = true;
            }
            nlead.RecordTypeId = mapRecordType.get('COS_ProspectoSalud');		
			nlead.Status = 'Validado';
        	nlead.COS_Dia_de_contacto__c = Prospecto.DiaContacto;
            nlead.COS_Horario_ideal_contacto__c = Prospecto.HorarioIdealContacto;
            nlead.COS_Asegurabilidad__c = Prospecto.Asegurabilidad;
        	nlead.COS_Asignacion_gestion_prioritaria__c = true;
		try{
            insert nlead; 
            objResponse.EstadoTransaccion = 'Exitoso';
            objResponse.Comentario = 'NA';
            objResponse.IdProspecto = nlead.id;
            lstResponse.add(objResponse);
        }catch(Exception e){
            system.debug('ERROR --->'+e.getStackTraceString()+'--'+e.getMessage());
            objResponse.Comentario = e.getMessage();
            objResponse.EstadoTransaccion = 'Fallido';
            lstResponse.add(objResponse);
        }
        objProspecto.Prospecto = lstResponse;
        string jsonResponse = Json.serialize(objProspecto);
        system.debug('jsonResponse --->'+jsonResponse);
        objLog.COM_Response__c = jsonResponse;
        insert objLog;
        
        return string.valueof(jsonResponse);
    }
}




/*
		string jsonLead;
        jsonLead ='{\n' +
        '"Prospecto":[\n' +
        '	{\n' +
        '		"TipoID":"1",\n' +
        '		"NumID":"79937971",\n' +
        '		"Nombre":"Milton Orlando Romero Agatón",\n' +
        '		"TelefonoContactoFijo":"2917720",\n' +
        '		"TelefonoContactoCelular":"3107593969",\n' +
        '		"Email":"milton.romero@globant.com",\n' +
        '		"NumeroEmpresa":"9006547893",\n' +
        '		"Genero":"Masculino",\n' +
        '		"Fecha":"2020-10-10 10:10:10",\n' +
        '		"Asesor":"Angela Escobar León",\n' +
        '		"IDAsesor":"52961003",\n' +
        '		"EmailAsesor":"angela.escobar@globant.com",\n' +
        '		"CategoriaCaja":"Categoria caja",\n' +
        '		"Fuentes":"BD Call Center"\n' +
        '	}\n' +
        '	]\n' +
        '}';
*/