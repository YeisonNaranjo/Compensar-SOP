/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase del Trigger COM_Opportunity_tgr donde se realizan los siguientes operaciones
- Validar y crear Cliente en GC

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     23/04/19            Stifen Panche (SP)                      Reset nombre único.
1.1     12/06/19            Yeison Naranjo (YN)                     Asign Autonumber RecordType Vinculación.
1.2     14/08/20            Yeison Naranjo (YN)                     NOLA 00019291.
1.3		12/07/21			Yeison Naranjo (YN)						NOLA 00026939.
2.0	    06/09/21			Yeison Naranjo (YN)						NOLA 00027871.
************************************************************************************************/

public class COM_OpportunityHandler_cls {
    
    /**
* @Method:      resetNombreUnicoDup
* @param:       List<Opportunity>   : lstNew
* @Description: Actualiza valores de nombre único para evitar duplicidad
* @author       Stifen Panche - 20190404
*/
    
    public static void resetNombreUnicoDupInsert(List<Opportunity> lstNew)
    {
        
        system.debug('Opportunity resetNombreUnicoDupInsert');
        List<DuplicidadOportunidad__mdt> DuplicidadOpty = [Select Record_Type_Id__c from DuplicidadOportunidad__mdt];
        List<String> lstRecordIds = new List<String>();
        
        /* Inicio 1.2 */
        Integer maxOpp = integer.valueof(Label.Maximo_Opp_Duplicadas);
        Set<String> setNomOpp = New Set<String>();
        Set<Id> setPrgVinc = New Set<Id>();
        Integer varAnio = System.today().year();
        Map<String, Integer> mapCount = New Map<String, Integer>();
        // Inicio 1.3
        Map<String, Integer> mapCountEnTramite = New Map<String, Integer>();
        // Fin 1.3 
        List<String> lstPrg_PermiteDup = new List<String>();
        
        For(Opportunity objopty : lstNew){
            setNomOpp.add(objopty.COM_TipoDocumento__c + objopty.COM_NumeroIdentificacion__c + objopty.COM_ProgramaVinculacion1__c + String.valueOf(objopty.RecordTypeId).substring(0,15) + varAnio);
            setPrgVinc.add(objopty.COM_ProgramaVinculacion1__c);
        }           
        system.debug('setNomOpp: ' + setNomOpp);
        
        List<COM_ProgramaVinculacion__c> lstProgramaVinculacion = [Select Id, COM_Permite_Multiples_Oportunidades__c from COM_ProgramaVinculacion__c where Id IN: setPrgVinc And COM_Permite_Multiples_Oportunidades__c = True];
        
        for(COM_ProgramaVinculacion__c objProgramaVinculacion : lstProgramaVinculacion)
        {
            lstPrg_PermiteDup.add(String.valueOf(objProgramaVinculacion.Id).substring(0, 15));
        }
        system.debug('lstPrg_PermiteDup: ' + lstPrg_PermiteDup);
        
        // Inicio 1.3
        //List<AggregateResult> lstOppCount = [Select Nombre_Unico_Oportunidad__c, Count(Id) Conteo from Opportunity where Nombre_Unico_Oportunidad__c IN: setNomOpp And Id Not IN: lstNew And CALENDAR_YEAR(CreatedDate) =: varAnio Group by Nombre_Unico_Oportunidad__c];
        List<AggregateResult> lstOppCount = [Select Nombre_Unico_Oportunidad__c, StageName, Count(Id) Conteo from Opportunity where Nombre_Unico_Oportunidad__c IN: setNomOpp And Id Not IN: lstNew And CALENDAR_YEAR(CreatedDate) =: varAnio Group by Nombre_Unico_Oportunidad__c, StageName];
        // Fin 1.3 
        System.debug('lstOppCount: '+ lstOppCount.size());
        For(AggregateResult objAggr : lstOppCount){
            // Inicio 1.3
            If((String) objAggr.get('StageName') == Label.Etapa_Oportunidad){
                mapCountEnTramite.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo'));
            } Else{
                If(mapCount.containsKey((String) objAggr.get('Nombre_Unico_Oportunidad__c'))){
                    Integer intCountOpp = mapCount.get((String) objAggr.get('Nombre_Unico_Oportunidad__c'));
                    mapCount.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo') + intCountOpp);
                } Else{
                    // Fin 1.3
                    mapCount.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo'));   
                    // Inicio 1.3
                }
            }  
            // Fin 1.3            
        }
        system.debug('mapCount: ' + mapCount);       
        system.debug('mapCountEnTramite: ' + mapCountEnTramite);       
        /* Fin 1.2 */
        
        for(DuplicidadOportunidad__mdt dupOpty : DuplicidadOpty)
        {
            lstRecordIds.add(dupOpty.Record_Type_Id__c);
        }
        
        for(Opportunity opty : lstNew)
        {
            /* Inicio 1.2 */
            String nombreUnico = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + varAnio;
            
            // Inicio 1.3
            If(mapCountEnTramite.containskey(nombreUnico)){
                opty.addError(label.Oportunidad_Duplicadad_msg1); 
            }
            // Fin 1.3
            
            if(opty.COM_ProgramaVinculacion1__c != Null && lstPrg_PermiteDup.contains(String.valueOf(opty.COM_ProgramaVinculacion1__c).substring(0, 15))){
                System.debug('mapCount.get(nombreUnico):' + mapCount.get(nombreUnico));
                System.debug('maxOpp:' + maxOpp);
                If((!mapCount.containskey(nombreUnico) ) || (mapCount.containskey(nombreUnico) && mapCount.get(nombreUnico) < maxOpp)){
                    opty.Nombre_Unico_Oportunidad__c = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + varAnio;                    
                } Else {
                    opty.addError(label.Oportunidad_Duplicadad_msg1); 
                }                
            } else{  
                /* Inicio 1.2 */
                
                /*Inicio 1.1*/
                System.Debug('RecordType: ' + String.valueOf(opty.RecordTypeId).substring(0, 15));
                
                if(lstRecordIds.contains(String.valueOf(opty.RecordTypeId).substring(0, 15)) && mapCount.containskey(nombreUnico)){
                    opty.addError(label.Oportunidad_Duplicadad_msg2); 
                } else{
                    /*Fin 1.1*/ 
                    opty.Nombre_Unico_Oportunidad__c = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + varAnio;
                    
                    //opty.COM_Seq_Vinculacion__c;
                    /*Inicio 1.1*/
                }
                /*Fin 1.1*/
                /* Inicio 1.2 */
            } 
            
            system.debug('opty.Nombre_Unico_Oportunidad__c: ' + opty.Nombre_Unico_Oportunidad__c);
            /* Inicio 1.2 */
        }
        
    }
    
    public static void resetNombreUnicoDupUpdate(List<Opportunity> lstNew)
    {
        
        system.debug('Opportunity resetNombreUnicoDup');
        List<DuplicidadOportunidad__mdt> DuplicidadOpty = [Select Record_Type_Id__c from DuplicidadOportunidad__mdt];
        List<String> lstRecordIds = new List<String>();
        
        /* Inicio 1.2 */
        Integer maxOpp = integer.valueof(Label.Maximo_Opp_Duplicadas);
        Set<String> setNomOpp = New Set<String>();
        Set<Id> setPrgVinc = New Set<Id>();
        Integer varAnio = System.today().year();
        Set<Integer> setAnio = New Set<Integer>();
        Map<String, Integer> mapCount = New Map<String, Integer>();
        // Inicio 1.3
        Map<String, Integer> mapCountEnTramite = New Map<String, Integer>();
        // Fin 1.3 
        List<String> lstPrg_PermiteDup = new List<String>();
        
        For(Opportunity objopty : lstNew){
            setNomOpp.add(objopty.COM_TipoDocumento__c + objopty.COM_NumeroIdentificacion__c + objopty.COM_ProgramaVinculacion1__c + String.valueOf(objopty.RecordTypeId).substring(0,15) + objopty.CreatedDate.year());
            setPrgVinc.add(objopty.COM_ProgramaVinculacion1__c);
            setAnio.add(objopty.CreatedDate.year());
        }           
        system.debug('setNomOpp: ' + setNomOpp);
        
        List<COM_ProgramaVinculacion__c> lstProgramaVinculacion = [Select Id, COM_Permite_Multiples_Oportunidades__c from COM_ProgramaVinculacion__c where Id IN: setPrgVinc And COM_Permite_Multiples_Oportunidades__c = True];
        
        for(COM_ProgramaVinculacion__c objProgramaVinculacion : lstProgramaVinculacion)
        {
            lstPrg_PermiteDup.add(String.valueOf(objProgramaVinculacion.Id).substring(0, 15));
        }
        system.debug('lstPrg_PermiteDup: ' + lstPrg_PermiteDup);
        
        // Inicio 1.3
        //List<AggregateResult> lstOppCount = [Select Nombre_Unico_Oportunidad__c, Count(Id) Conteo from Opportunity where Nombre_Unico_Oportunidad__c IN: setNomOpp And Id Not IN: lstNew And CALENDAR_YEAR(CreatedDate) =: varAnio Group by Nombre_Unico_Oportunidad__c];
        List<AggregateResult> lstOppCount = [Select Nombre_Unico_Oportunidad__c, StageName, Count(Id) Conteo from Opportunity where Nombre_Unico_Oportunidad__c IN: setNomOpp And Id Not IN: lstNew And CALENDAR_YEAR(CreatedDate) =: varAnio Group by Nombre_Unico_Oportunidad__c, StageName];
        // Fin 1.3 
        
        For(AggregateResult objAggr : lstOppCount){
            // Inicio 1.3
            If((String) objAggr.get('StageName') == Label.Etapa_Oportunidad){
                If(mapCount.containsKey((String) objAggr.get('Nombre_Unico_Oportunidad__c'))){
                    Integer intCountOpp = mapCount.get((String) objAggr.get('Nombre_Unico_Oportunidad__c'));
                    mapCount.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo') + intCountOpp);
                }                
                mapCountEnTramite.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo'));
            } Else{
                If(mapCount.containsKey((String) objAggr.get('Nombre_Unico_Oportunidad__c'))){
                    Integer intCountOpp = mapCount.get((String) objAggr.get('Nombre_Unico_Oportunidad__c'));
                    mapCount.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo') + intCountOpp);
                } Else{
                    // Fin 1.3
                    mapCount.put((String) objAggr.get('Nombre_Unico_Oportunidad__c'),(Integer) objAggr.get('Conteo'));   
                    // Inicio 1.3
                }
            }  
            // Fin 1.3            
        }
        
        system.debug('mapCount: ' + mapCount);       
        system.debug('mapCountEnTramite: ' + mapCount);       
        /* Fin 1.2 */
        
        for(DuplicidadOportunidad__mdt dupOpty : DuplicidadOpty)
        {
            lstRecordIds.add(dupOpty.Record_Type_Id__c);
        }
        
        for(Opportunity opty : lstNew)
        {
            /* Inicio 1.2 */
            String nombreUnico = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + opty.CreatedDate.year();
            
            // Inicio 1.3
            If(mapCountEnTramite.containskey(nombreUnico)){
                opty.addError(label.Oportunidad_Duplicadad_msg1); 
            }
            // Fin 1.3
            
            if(opty.CreatedDate.year() == varAnio){
                if(opty.COM_ProgramaVinculacion1__c != Null && lstPrg_PermiteDup.contains(String.valueOf(opty.COM_ProgramaVinculacion1__c).substring(0, 15))){
                    System.debug('mapCount.get(nombreUnico):' + mapCount.get(nombreUnico));
                    System.debug('maxOpp:' + maxOpp);
                    If((!mapCount.containskey(nombreUnico) ) || (mapCount.containskey(nombreUnico) && mapCount.get(nombreUnico) < maxOpp)){
                        opty.Nombre_Unico_Oportunidad__c = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + opty.CreatedDate.year();                        
                    } Else {
                        opty.addError(label.Oportunidad_Duplicadad_msg1); 
                    }                
                } else{  
                    /* Inicio 1.2 */
                    
                    /*Inicio 1.1*/
                    System.Debug('RecordType: ' + String.valueOf(opty.RecordTypeId).substring(0, 15));
                    
                    if(lstRecordIds.contains(String.valueOf(opty.RecordTypeId).substring(0, 15)) && mapCount.containskey(nombreUnico)){
                        opty.addError(label.Oportunidad_Duplicadad_msg2); 
                    } else{
                        /*Fin 1.1*/ 
                        opty.Nombre_Unico_Oportunidad__c = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + opty.CreatedDate.year();
                        /*Inicio 1.1*/
                    }
                    /*Fin 1.1*/
                    /* Inicio 1.2 */
                } 
            } else{
                opty.Nombre_Unico_Oportunidad__c = opty.COM_TipoDocumento__c + opty.COM_NumeroIdentificacion__c + opty.COM_ProgramaVinculacion1__c + String.valueOf(opty.RecordTypeId).substring(0,15) + opty.CreatedDate.year();
            }
            
            system.debug('opty.Nombre_Unico_Oportunidad__c: ' + opty.Nombre_Unico_Oportunidad__c);
            /* Inicio 1.2 */
        }
        
    }
    /* Inicio 2.0 */
    public static void updateHeadquarters(List<Opportunity> lstNew, Map<Id, Opportunity> mapOldOpp)
    {
        System.debug('Begin method updateHeadquarters');
        Set<Id> setOwners = New Set<Id>();
        Set<String> setHeadquarters = New Set<String>();
        Map<String, Id> mapHeadquartersByOwner = New Map<String, Id>();
        Map<String, Id> mapHeadquartersIdByOwner = New Map<String, Id>();
        
        For(Opportunity objOpp : lstNew){
            setOwners.add(objOpp.OwnerId);
            System.debug('setOwners: ' + setOwners);
        }
        
        For(User objOwners : [Select Id, Codigo_Sede__c from User where Id IN: setOwners]){
            setHeadquarters.add(objOwners.Codigo_Sede__c);
            mapHeadquartersByOwner.Put(objOwners.Codigo_Sede__c, objOwners.Id);
            System.debug('setHeadquarters: ' + setHeadquarters);
            System.debug('mapHeadquartersByOwner: ' + mapHeadquartersByOwner);
        }
        
        For(COS_SedesSalud__c objSedeSalud : [Select Id, COS_Codigo__c from COS_SedesSalud__c where COS_Codigo__c IN: setHeadquarters]){
            System.debug('mapHeadquartersByOwner.containskey(objSedeSalud.COS_Codigo__c): ' + mapHeadquartersByOwner.containskey(objSedeSalud.COS_Codigo__c));
            If(mapHeadquartersByOwner.containskey(objSedeSalud.COS_Codigo__c)){
                mapHeadquartersIdByOwner.put(mapHeadquartersByOwner.get(objSedeSalud.COS_Codigo__c), objSedeSalud.Id);
            }            
        }
        
        For(Opportunity objOpp : lstNew){
            System.debug('mapHeadquartersIdByOwner.containsKey(objOpp.OwnerId): ' + mapHeadquartersIdByOwner.containsKey(objOpp.OwnerId));
            If(mapHeadquartersIdByOwner.containsKey(objOpp.OwnerId)){
                System.debug('mapHeadquartersIdByOwner.get(objOpp.OwnerId): ' + mapHeadquartersIdByOwner.get(objOpp.OwnerId));
            	objOpp.COS_Sede__c = mapHeadquartersIdByOwner.get(objOpp.OwnerId);
            }   
            
            If((mapOldOpp == Null || mapOldOpp.get(objOpp.Id) == Null || (mapOldOpp.get(objOpp.Id) != Null && objOpp.StageName != mapOldOpp.get(objOpp.Id).StageName)) && objOpp.StageName == 'Confirmada Salud'){
                objOpp.COS_Fecha_confirmada_salud__c = System.today();
            }
            
            If((mapOldOpp == Null || mapOldOpp.get(objOpp.Id) == Null || (mapOldOpp.get(objOpp.Id) != Null && objOpp.StageName != mapOldOpp.get(objOpp.Id).StageName)) && objOpp.StageName == 'Finalizada'){
                objOpp.COS_Fecha_finalizada_salud__c = System.today();
            }
        }
    }
    /* Fin 2.0 */
}