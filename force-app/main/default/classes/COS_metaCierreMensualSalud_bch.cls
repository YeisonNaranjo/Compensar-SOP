global class COS_metaCierreMensualSalud_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
    global Database.QueryLocator start(database.BatchableContext DC){
        date dfCierreMeta = system.today().addMonths(-2);
        date firstDayOfMonth = System.today().toStartOfMonth();
        date dtToday = system.today();
        
        map<string, string> mapRecordTypeMeta = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='COM_MetasMensual__c']){
            mapRecordTypeMeta.put(rt.DeveloperName, rt.Id);
        }
        system.debug('mapRecordTypeMeta --->'+mapRecordTypeMeta);
        map<integer,string> monthMap = new map<integer,string>();
        monthMap.put(1,'Enero');
        monthMap.put(2,'Febrero');
        monthMap.put(3,'Marzo');
        monthMap.put(4,'Abril');
        monthMap.put(5,'Mayo');
        monthMap.put(6,'Junio');
        monthMap.put(7,'Julio');
        monthMap.put(8,'Agosto');
        monthMap.put(9,'Septiembre');
        monthMap.put(10,'Octubre');
        monthMap.put(11,'Noviembre');
        monthMap.put(12,'Diciembre');
        
        system.debug('monthMap --->'+monthMap);
        system.debug('dfCierreMeta --->'+dfCierreMeta);
        
        integer yearCierre = dfCierreMeta.year();
        integer monthCierre = dfCierreMeta.month();
        string strMonth;
        system.debug('yearCierre --->'+yearCierre);
        system.debug('monthCierre --->'+monthCierre);
        system.debug('nombre monthCierre --->'+monthMap.get(monthCierre));
        
        return database.getQueryLocator([select COS_CerradaMes__c, COS_Asesor__c, COM_Mes__c, COM_MetaAnual__c, COS_MetaMes__c, COM_CantidadMeta__c, COS_MetaForecast__c, RecordTypeId, COS_TipoPlan__c 
                                         from COM_MetasMensual__c
                                         where COS_CerradaMes__c = false 
                                           and RecordTypeId =: mapRecordTypeMeta.get('COS_MetaMensualSalud')
                                           and COM_Mes__c =: monthMap.get(monthCierre)
                                           and COM_Anio__c =: string.valueof(yearCierre)]);
            
        
    }
    
    global void execute(database.BatchableContext BC, list<COM_MetasMensual__c> scope){
        system.debug('scope --->'+scope);
        system.debug('scope SIZE --->'+scope.size());
        integer contPlanilladoActual = 0;
        integer contGanado = 0;
        integer contFinalizado = 0;
        integer contPerdido = 0;  
        boolean blnEjecutarCierre = false;
        string strTipoPlan = 'CE';
        string sql = '';
        string fltr = '';
        string query = '';
        string stageCierre = 'Finalizada';
        boolean blnKey = false;
        list<opportunity> lstOppCierre = new list<Opportunity>();
        list<opportunity> lstOppUp = new list<Opportunity>();
        
        // busca cantidad de meses hacia atras validos para pago de comisiones
        COS_meses_atras_pago_comision_salud__mdt mesAnt = [select id, meses_anteriores__c from COS_meses_atras_pago_comision_salud__mdt limit 1];
        
		// 1er Día hábil del mes
		date dtHoy = system.today();
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
		datetime targetTime1 = Datetime.newInstance(system.today().year(), system.today().month(), 1, 0, 0, 0);
		datetime nextStart1 = BusinessHours.nextStartDate(bh.id, targetTime1);
        date diaHabil1 = date.newInstance(nextStart1.year(), nextStart1.month(), nextStart1.day());
                
        // 2do. día hábil del mes
        datetime targetTime2 = nextStart1.addDays(1);
		datetime nextStart2 = BusinessHours.nextStartDate(bh.id, targetTime2);
        date diaHabil2 = date.newInstance(nextStart2.year(), nextStart2.month(), nextStart2.day());
        
        if(dtHoy==diaHabil1 || dtHoy == diaHabil2){
            blnEjecutarCierre = true;
        }
        
        // Rangos de fecha de finalización en la oportunidad a buscar
        date dtFechaCierre = System.today().toStartOfMonth().addMonths(-2);
        system.debug('fechaCierre --->'+dtFechaCierre);
        date dtFechaFinalizacionIni = date.newInstance(dtFechaCierre.year(), dtFechaCierre.month(), 1);
        dtFechaFinalizacionIni = dtFechaFinalizacionIni.addDays(-1);
        string mesFechaFinalizacionIni = '';
        if(dtFechaFinalizacionIni.month()<10){
            mesFechaFinalizacionIni = '0'+string.valueof(dtFechaFinalizacionIni.month());}
        else{mesFechaFinalizacionIni = string.valueOf(dtFechaFinalizacionIni.month());}
        string strFechaFinalizacionIni = string.valueof(dtFechaFinalizacionIni.year())+'-'+mesFechaFinalizacionIni+'-'+string.valueOf(dtFechaFinalizacionIni.day());
//        system.debug('dtFechaFinalizacionIni FORMAT--->'+dtFechaFinalizacionIni.format('yyyy-mm-dd'));
        system.debug('dtFechaFinalizacionIni --->'+dtFechaFinalizacionIni);
        date dtFechaFinalizacionFin = date.newInstance(dtFechaCierre.year(), dtFechaCierre.month()+1, 1);
        string mesFechaFinalizacionFin = '';
        if(dtFechaFinalizacionFin.month()<10){
            mesFechaFinalizacionFin = '0'+string.valueof(dtFechaFinalizacionFin.month());}
        else{mesFechaFinalizacionFin = string.valueof(dtFechaFinalizacionFin.month());}
        string strFechaFinalizacionFin = string.valueof(dtFechaFinalizacionFin.year())+'-'+mesFechaFinalizacionFin+'-01';
        system.debug('dtFechaFinalizacionFin --->'+dtFechaFinalizacionFin);
        
        // Rangos de fecha Confirmada Salud en la oportunidad a buscar
        date dtFechaConfirmadaIni = date.newInstance(dtFechaCierre.year(), dtFechaCierre.month()-integer.valueof(mesAnt.meses_anteriores__c), 1);
        dtFechaConfirmadaIni = dtFechaConfirmadaIni.addDays(-1);
        string mesFechaConfirmadaIni = '';
        if(dtFechaConfirmadaIni.month()<10){
            mesFechaConfirmadaIni = '0'+string.valueof(dtFechaConfirmadaIni.month());}
        else{mesFechaConfirmadaIni = string.valueof(dtFechaConfirmadaIni.month());}
        
        string strFechaConfirmadaIni = string.valueof(dtFechaConfirmadaIni.year())+'-'+mesFechaConfirmadaIni+'-'+string.valueOf(dtFechaConfirmadaIni.day());
        system.debug('dtFechaConfirmadaIni --->'+dtFechaConfirmadaIni);
        date dtFechaConfirmadaFin = date.newInstance(dtFechaCierre.year(), dtFechaCierre.month()+1, 1);
        string mesFechaConfirmadaFin = '';
        if(dtFechaConfirmadaFin.month()<10){
            mesFechaConfirmadaFin = '0'+string.valueof(dtFechaConfirmadaFin.month());}
        else{mesFechaConfirmadaFin = string.valueof(dtFechaConfirmadaFin.month());}
        string strFechaConfirmadaFin = string.valueof(dtFechaConfirmadaFin.year())+'-'+mesFechaConfirmadaFin+'-01';
        system.debug('dtFechaConfirmadaFin --->'+dtFechaConfirmadaFin);
        
        map<string, string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        map<string, COS_Estado_vinculacion_salud__mdt> mapEstadoVinculacion = new map<string, COS_Estado_vinculacion_salud__mdt>();
        for(COS_Estado_vinculacion_salud__mdt ev:[select COS_Codigo_estado__c, Etapa_Oportunidad__c from COS_Estado_vinculacion_salud__mdt where COS_Codigo_estado__c<>null]){
            mapEstadoVinculacion.put(ev.COS_Codigo_estado__c, ev);
        }
        
        map<string, string> mapNovedadVinculacion = new map<string, string>();
        for(COS_Estado_vinculacion_salud__mdt evs:[select COS_Plan__c, COS_Tipo_novedad__c from COS_Estado_vinculacion_salud__mdt where COS_Plan__c<>null]){
            mapNovedadVinculacion.put(evs.COS_Plan__c+evs.COS_Tipo_novedad__c, evs.COS_Tipo_novedad__c);
        }
        
        list<COM_MetasMensual__c> lstMetaInactiva = new list<COM_MetasMensual__c>();
        for(COM_MetasMensual__c mm: scope){
            system.debug('meta a procesar --->'+mm);
            
            sql='select id, name, ownerId, COS_TipoPlan__c, StageName, RecordTypeId, COS_Fecha_confirmada_salud__c, COS_Fecha_finalizada_salud__c, COS_CodigoEstadoSalud__c, COS_TipoNovedad__c '+
                'from opportunity ';
            sql=sql+'where StageName =\'Finalizada\' ';
            sql=sql+'and RecordTypeId =\''+mapRecordType.get('COS_ConsorcioSalud')+'\' ';
            if(dtHoy==diaHabil1){
				sql=sql+'and COS_TipoPlan__c =\'CE\' ';}
            if(dtHoy==diaHabil2){
				sql=sql+'and COS_TipoPlan__c <>\'CE\' ';}
            sql=sql+'and OwnerId =\''+ mm.COS_Asesor__c+'\' ';
            sql=sql+'and COS_Fecha_finalizada_salud__c >'+ strFechaFinalizacionIni+' and COS_Fecha_finalizada_salud__c <'+ strFechaFinalizacionFin+' ';
			sql=sql+'and COS_Fecha_confirmada_salud__c >'+ strFechaConfirmadaIni+' and COS_Fecha_confirmada_salud__c <'+strFechaConfirmadaFin;
            
            system.debug('query --->'+sql);
            lstOppCierre = Database.query(sql);
            system.debug('lstOppCierre --->'+lstOppCierre);
 
            contGanado = 0;
        	contFinalizado = 0;
        	contPerdido = 0; 
            system.debug('mapEstadoVinculacion --->'+mapEstadoVinculacion);
            //blnEjecutarCierre = true;
            system.debug('lstOppCierre --->'+lstOppCierre);
            system.debug('lstOppCierre SIZE--->'+lstOppCierre.size());
            for(opportunity op:lstOppCierre){
                blnKey = false;
                contFinalizado = contFinalizado + 1;
                system.debug('Opportunity --->'+op);
                system.debug('mapEstadoVinculacion --->'+mapEstadoVinculacion);
                system.debug('op.COS_CodigoEstadoSalud__c --->'+op.COS_CodigoEstadoSalud__c);
                system.debug('mapNovedadVinculacion line_168 --->'+mapNovedadVinculacion);
                system.debug('op.COS_TipoPlan__c --->'+op.COS_TipoPlan__c);
                system.debug('op.COS_TipoNovedad__c --->'+op.COS_TipoNovedad__c);
                blnKey = mapNovedadVinculacion.containsKey(op.COS_TipoPlan__c+op.COS_TipoNovedad__c);
                system.debug('blnKey --->'+blnKey);    
                if(mapEstadoVinculacion.get(op.COS_CodigoEstadoSalud__c).Etapa_Oportunidad__c == 'Ganada'){
                    if(blnEjecutarCierre==true){
                        op.StageName = 'Cerrada Ganada';
                        if(blnKey == true){contGanado = contGanado + 1;}
                    	lstOppUp.add(op);
                    }
                }
                
                if(mapEstadoVinculacion.get(op.COS_CodigoEstadoSalud__c).Etapa_Oportunidad__c == 'Perdida'){
                    if(blnEjecutarCierre==true){
                        op.StageName = 'Cerrada Perdida';
                        contPerdido = contPerdido + 1;
                        lstOppUp.add(op);
                    }
                }
            }
            system.debug('contGanado --->'+contGanado);
            system.debug('contPerdido --->'+contPerdido);
            if(contGanado>0 || contPerdido>0){
                mm.COS_CantidadRealCerradas__c = contGanado;
            	mm.COS_Inactiva__c = true;
                lstMetaInactiva.add(mm);
            }
        }
        system.debug('lstMetaInactiva --->'+lstMetaInactiva);
        system.debug('lstOppUp --->'+lstOppUp);
        update lstMetaInactiva;
        update lstOppUp;
    }
    
    global void finish(database.BatchableContext BC){
        
    }
}