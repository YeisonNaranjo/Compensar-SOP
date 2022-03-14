global class COS_estadoOportunidadSalud_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
    global Database.QueryLocator start(database.BatchableContext DC){
        return database.getQueryLocator([select id, name, COS_CausalNovedad__c, COS_ProgramaActual__c, COS_TipoPlan__c, COS_CodigoEstadoAfiliacion__c, COS_FechaVinculacion__c, COS_NitEmpresa__c, COS_NumeroDocumento__c,
                                         		COM_TipoIdentificacion__c, COS_No_procesado__c
                                         from COS_EstadosOportunidadesTemp__c]);
    }
    
    global void execute(database.BatchableContext BC, list<COS_EstadosOportunidadesTemp__c> scope){
        system.debug('scope --->'+scope);
        system.debug('scope SIZE --->'+scope.size());
        string strTipoIdentificacion = '';
        list<opportunity> lstOppUp = new list<opportunity>();
        list<COS_EstadosOportunidadesTemp__c> lstEOTProcesado = new list<COS_EstadosOportunidadesTemp__c>();
        list<COS_EstadosOportunidadesTemp__c> lstEOTNoProcesado = new list<COS_EstadosOportunidadesTemp__c>();
        
        map<string,string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        map<string, string> mapTipoDoc = new map<string, string>(); 
        map<string, string> mapTipoDocumento = new map<string, string>();
        for(COS_Homologacion_tipo_documento__mdt td:[select COS_Codigo_consorcio__c, DeveloperName, MasterLabel, COS_Codigo_Salesforce__c from COS_Homologacion_tipo_documento__mdt]){
            mapTipoDocumento.put(td.COS_Codigo_consorcio__c, td.MasterLabel);
            mapTipoDoc.put(td.COS_Codigo_consorcio__c, td.COS_Codigo_Salesforce__c);
        }
        
        for(COS_EstadosOportunidadesTemp__c eot: scope){
            //stage opp --> Finalizada
//            
            strTipoIdentificacion = mapTipoDocumento.get(eot.COM_TipoIdentificacion__c);
            
            system.debug('strTipoIdentificacion --->'+strTipoIdentificacion);
            system.debug('eot.COS_NumeroDocumento__c --->'+eot.COS_NumeroDocumento__c);
            system.debug('eot.COS_TipoPlan__c --->'+eot.COS_TipoPlan__c);
            system.debug('COS_TipoVinculacionSalud__c --->'+eot.COS_ProgramaActual__c);
            system.debug('eot.COS_NitEmpresa__c --->'+eot.COS_NitEmpresa__c);
            system.debug('mapRecordType.get(COS_ConsorcioSalud) --->'+mapRecordType.get('COS_ConsorcioSalud'));
            system.debug('mapTipoDoc.get(eot.COM_TipoIdentificacion__c) --->'+mapTipoDoc.get(eot.COM_TipoIdentificacion__c));
            list<opportunity> lstOpp = [select id, name, COS_CodigoEstadoSalud__c, StageName from opportunity 
                                		where COM_TipoDocumento__c =: mapTipoDoc.get(eot.COM_TipoIdentificacion__c)	//	Tipo documento
                                  		  and COM_NumeroIdentificacion__c =: eot.COS_NumeroDocumento__c					// 	numero documento
            					  		  and COS_TipoPlan__c =: eot.COS_TipoPlan__c									//	código tipo plan
            					  		  and COS_TipoVinculacionSalud__c =: eot.COS_ProgramaActual__c					//	código tipo vinculación
            					  		  and COS_Nit_empresa__c =:	decimal.valueof(eot.COS_NitEmpresa__c)				//	Nit Empresa
//            					  		  and COS_FechaVinculacion__c =: eot.COS_FechaVinculacion__c 					//	Fecha vinculación
                				  		  and RecordTypeId =: mapRecordType.get('COS_ConsorcioSalud')
                                         // and date.valueof(CreatedDate) <: eot.COS_FechaVinculacion__c
                                          and StageName in ('Confirmada Salud')
                                          order by CreatedDate desc
                                        limit 1];
                
			system.debug('lstOpp --->'+lstOpp);
            system.debug('lstOpp SIZE--->'+lstOpp.size());
            system.debug('eot.COS_CodigoEstadoAfiliacion__c --->'+eot.COS_CodigoEstadoAfiliacion__c);
            if(lstOpp.size()>0){
                lstOpp[0].StageName = 'Finalizada';
                lstOpp[0].COS_Fecha_finalizada_salud__c = system.today();
                lstOpp[0].COS_CodigoEstadoSalud__c = eot.COS_CodigoEstadoAfiliacion__c;
                lstOpp[0].COS_FechaVinculacion__c = eot.COS_FechaVinculacion__c;
                if(eot.COS_CausalNovedad__c != null){
                	lstOpp[0].COS_CausalNovedad__c = eot.COS_CausalNovedad__c;
                }
                lstOppUp.add(lstOpp[0]);
                lstEOTProcesado.add(eot);
            }else{
                eot.COS_No_procesado__c = true;
                lstEOTNoProcesado.add(eot);
            }
        }
        
        system.debug('lstOppUp --->'+lstOppUp);
        system.debug('lstEOTNoProcesado --->'+lstEOTNoProcesado);
        system.debug('lstEOTProcesado --->'+lstEOTProcesado);
        update lstOppUp;
        if(lstEOTNoProcesado.size()>0){
        	update lstEOTNoProcesado;}
        
        delete lstEOTProcesado;
    }
    
    global void finish(database.BatchableContext BC){
        
    }
}