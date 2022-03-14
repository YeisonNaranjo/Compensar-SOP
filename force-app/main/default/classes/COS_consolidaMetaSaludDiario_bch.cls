/************************************************************************************************
Desarrollado por:  Globant
Proyecto:          Compensar
Descripción:       COS_consolidaMetaSaludDiario_bch

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
	No.		Fecha			Autor					Descripción
----------  -------------   ----------------------  ---------------------------------------------
	2.0		06/09/21		Yeison Naranjo (YSN)	Ajuste calculo Cantidad planilla.
************************************************************************/

global class COS_consolidaMetaSaludDiario_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
    global Database.QueryLocator start(database.BatchableContext DC){
        
        date dtToday = system.today();
        integer year = dtToday.year();
        integer month = dtToday.month();
		string strMonth;
        map<string, string> mapRecordTypeMeta = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='COM_MetasMensual__c']){
            mapRecordTypeMeta.put(rt.DeveloperName, rt.Id);
        }
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
        
        return database.getQueryLocator([select id, name, COS_Asesor__c, COM_Anio__c, COS_CantidadGrabados__c, COS_CantidadPlanillados__c, COS_CantidadRealCerradas__c, COS_MetaForecast__c, COM_Mes__c, 
                                         		COS_TipoAsesor__c, COS_TipoPlan__c, RecordTypeId, COS_CantidadGrabadosMesAnterior__c/* Inicio 2.0 */, COS_TipoPC__c /* Fin 2.0 */
                                         from COM_MetasMensual__c
                                         where COS_Inactiva__c = false
                                          and RecordTypeId =: mapRecordTypeMeta.get('COS_MetaMensualSalud')
                                          and COM_Anio__c =: string.valueof(year)
                                          and COM_Mes__c =: monthMap.get(month)
                                        ]);
    }
    
    global void execute(database.BatchableContext BC, list<COM_MetasMensual__c> scope){
        integer contPlanilladoActual = 0;
        integer contGrabadoActual = 0;
        integer contGrabadoAnterior = 0;
        
        COS_meses_atras_pago_comision_salud__mdt mesAnt = [select id, meses_anteriores__c from COS_meses_atras_pago_comision_salud__mdt limit 1];
        map<string, string> mapRecordType = new map<string, string>();
        for(recordtype rt:[select id, DeveloperName from recordtype where SobjectType='Opportunity']){
            mapRecordType.put(rt.DeveloperName, rt.Id);
        }
        
        date fechaInicioActual = date.newInstance(system.today().year(), system.today().month(), 1);
        fechaInicioActual = fechaInicioActual.addDays(-1);
        date fechaFinActual = date.newInstance(system.today().year(), system.today().month()+1, 1);
        
        date fechaInicioAnterior = date.newInstance(system.today().year(), system.today().month()-integer.valueof(mesAnt.meses_anteriores__c), 1);
        fechaInicioAnterior = fechaInicioAnterior.addDays(-1);
        date fechaFinAnterior = date.newInstance(system.today().year(), system.today().month(), 1);
        
        map<string, string> mapNovedadVinculacion = new map<string, string>();
        for(COS_Estado_vinculacion_salud__mdt evs:[select COS_Plan__c, COS_Tipo_novedad__c from COS_Estado_vinculacion_salud__mdt where COS_Plan__c<>null]){
            mapNovedadVinculacion.put(evs.COS_Plan__c+evs.COS_Tipo_novedad__c, evs.COS_Tipo_novedad__c);
        }
        set<string> setNovedad = new set<string>();
        string strKey = '';
        system.debug('mapNovedadVinculacion --->'+mapNovedadVinculacion);
        for(COM_MetasMensual__c mm:scope){
            /* Inicio 2.0 */
            setNovedad.clear();
            /* Fin 2.0 */
            system.debug('mm.COS_TipoPlan__c --->'+mm.COS_TipoPlan__c);
            for(string key:mapNovedadVinculacion.keySet()){
                strKey = string.valueOf(key);
                system.debug('strKey --->'+strKey);
                if(strKey.indexOf(mm.COS_TipoPlan__c) != -1){
                    setNovedad.add(mapNovedadVinculacion.get(key));
                }
            }
            system.debug('setNovedad --->'+setNovedad);
            system.debug('fechaInicioActual --->'+fechaInicioActual);
            system.debug('fechaFinActual --->'+fechaFinActual);
            
            contPlanilladoActual = [select count() from opportunity 
                              /* Inicio 2.0 */
                                    //where ownerId=:mm.COS_Asesor__c and COS_TipoPlan__c=:mm.COS_TipoPlan__c and StageName='Confirmada Salud' and RecordTypeId=:mapRecordType.get('COS_ConsorcioSalud') and COS_TipoNovedad__c in:setNovedad
                                    where ownerId=:mm.COS_Asesor__c and COS_TipoPlan__c=:mm.COS_TipoPlan__c and COS_TipoPC__c=:mm.COS_TipoPC__c and COS_TipoGestion__c =: Label.COM_TipoGestionOpp and StageName='Confirmada Salud' and RecordTypeId=:mapRecordType.get('COS_ConsorcioSalud') and COS_TipoNovedad__c in:setNovedad
                              /* Fin 2.0 */
                                and COS_Fecha_confirmada_salud__c >: fechaInicioActual and COS_Fecha_confirmada_salud__c <: fechaFinActual];
            
            contGrabadoActual = [select count() from opportunity 
                                 /* Inicio 2.0 */
                                 //where ownerId=:mm.COS_Asesor__c and COS_TipoPlan__c=:mm.COS_TipoPlan__c and StageName='Finalizada' and RecordTypeId=:mapRecordType.get('COS_ConsorcioSalud') and COS_TipoNovedad__c in:setNovedad
                                 where ownerId=:mm.COS_Asesor__c and COS_TipoPlan__c=:mm.COS_TipoPlan__c and COS_TipoPC__c=:mm.COS_TipoPC__c and COS_TipoGestion__c =: Label.COM_TipoGestionOpp and StageName='Finalizada' and RecordTypeId=:mapRecordType.get('COS_ConsorcioSalud') and COS_TipoNovedad__c in:setNovedad
                                 /* Fin 2.0 */
                                 and COS_Fecha_confirmada_salud__c >: fechaInicioActual and COS_Fecha_confirmada_salud__c <: fechaFinActual
                              and COS_Fecha_finalizada_salud__c >: fechaInicioActual and COS_Fecha_finalizada_salud__c <: fechaFinActual];
            
            contGrabadoAnterior = [select count() from opportunity 
                                   /* Inicio 2.0 */
                                   //where ownerId=:mm.COS_Asesor__c and COS_TipoPlan__c=:mm.COS_TipoPlan__c and StageName='Finalizada' and RecordTypeId=:mapRecordType.get('COS_ConsorcioSalud') and COS_TipoNovedad__c in:setNovedad
                                   where ownerId=:mm.COS_Asesor__c and COS_TipoPlan__c=:mm.COS_TipoPlan__c and COS_TipoPC__c=:mm.COS_TipoPC__c and COS_TipoGestion__c =: Label.COM_TipoGestionOpp and StageName='Finalizada' and RecordTypeId=:mapRecordType.get('COS_ConsorcioSalud') and COS_TipoNovedad__c in:setNovedad
                                   /* Fin 2.0 */
                                   and COS_Fecha_confirmada_salud__c >: fechaInicioAnterior and COS_Fecha_confirmada_salud__c <: fechaFinAnterior
                              		 and COS_Fecha_finalizada_salud__c >: fechaInicioActual and COS_Fecha_finalizada_salud__c <: fechaFinActual];
            
            mm.COS_CantidadPlanillados__c = contPlanilladoActual;
            mm.COS_CantidadGrabados__c = contGrabadoActual;
            mm.COS_CantidadGrabadosMesAnterior__c = contGrabadoAnterior;
            if(fechaFinActual.addDays(-1) == system.today()){
                mm.COS_Inactiva__c = true;
            }
        }
        update scope;
    }
    
    global void finish(database.BatchableContext BC){
        
    }
}