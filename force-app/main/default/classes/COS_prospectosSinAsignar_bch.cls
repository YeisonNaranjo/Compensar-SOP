global class COS_prospectosSinAsignar_bch implements database.Batchable<sObject>, database.stateful, database.allowsCallouts{
    
    global Integer RegistrosProcesados = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        return Database.getQueryLocator(
            'Select Id, Name, Status, OwnerId, COS_Asignado_salud__c, COS_Nit_empresa__c, CEL1_NumeroDocumento__c, CEL1_TipoDocumento__c, LeadSource, RecordTypeId FROM Lead WHERE COS_Asignado_salud__c = FALSE AND Status =\'Validado\' AND RecordTypeId =:strRecordTypeLeadSalud '
        );
    }
    
    //EXECUTE
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
        Map<String, Object> consultaWS = New Map<String, Object>();
        List<Lead> leadListUpd = new List<Lead>();
        List<Lead> leadDistribucionCarga = New List<Lead>();
        Map <Id, String> resultadolistaLeadxNit = New Map <Id, String>();
        Map<String,String> mapCuentaxTM = new Map <String,String>();
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        
        
        for (Lead Objlead : scope) {
            
            //verifico si el Lead contiene tipo y numero de documento
            if(Objlead.CEL1_TipoDocumento__c != null && Objlead.CEL1_NumeroDocumento__c != null){
                consultaWS = COS_ConsultaGFyVinculacionesV2_ctr.obtenerGrupoFamiliar(Objlead.id);
            }
            else {
                System.debug('---------- PASO LEAD POR DISTRIBUCION DE CARGAS... check');
                    leadDistribucionCarga.add(Objlead);  //PASO a ASIGNACION POR DISTRIBUCION DE CARGA
                	continue;
            }
            
               
            String JSONserializede = JSON.serialize(consultaWS);
            COS_ConsultaWSSaludWrapper responseWrapper = COS_ConsultaWSSaludWrapper.parse(JSONserializede);
            
            System.debug('---------- ConsultarDatosVinculacionOut.Empresa ---->  ....' + responseWrapper.ConsultarDatosVinculacionOut.Empresa);
            if (responseWrapper.ConsultarDatosVinculacionOut.Empresa != null){
                for(Integer i=0; i<responseWrapper.ConsultarDatosVinculacionOut.Empresa.size(); i++) {
                    //Agrupo en un MAP el Lead id con su correspondiente NIT traido desde el WS
                    COS_ConsultaWSSaludWrapper.Empresa empresaOk = responseWrapper.ConsultarDatosVinculacionOut.Empresa.get(i);
                    //Pregunto si el WS trae un numero de NIT
                    if (empresaOk.NIT <> null){
                        resultadolistaLeadxNit.put(Objlead.id,empresaOk.NIT);
                    }
                }
            } else {
                resultadolistaLeadxNit.put(Objlead.id,'');
                //break;
            }
            
            //Verifiar si ese NIT existe en Salesforce
            String setNit = '';
            for (Id r : resultadolistaLeadxNit.keyset() ){
                setNit = resultadolistaLeadxNit.get(r);
            }
            
            System.debug('---------- setNIT ....' + setNit);
            
            List<AccountTeamMember> lstAccTM = [SELECT Id,
                                                Account.COM_TipoIdentificacion__c,
                                                Account.COM_Numero_de_identificacion__c,
                                                UserId,
                                                User.ManagerId,
                                                User.COS_Usuario_no_disponible__c
                                                FROM AccountTeamMember
                                                WHERE User.Profile.Name = 'Asesor Comercial Salud' AND Account.COM_Numero_de_identificacion__c = :setNit AND Account.COM_TipoIdentificacion__c = '2'
                                                ORDER BY CreatedDate ASC];
            
            
            for(AccountTeamMember objAccTM : lstAccTM){
                if (objAccTM.User.COS_Usuario_no_disponible__c){
                    mapCuentaxTM.put(objAccTM.Account.COM_TipoIdentificacion__c+objAccTM.Account.COM_Numero_de_identificacion__c,objAccTM.User.ManagerId);
                } else {
                    mapCuentaxTM.put(objAccTM.Account.COM_TipoIdentificacion__c+objAccTM.Account.COM_Numero_de_identificacion__c,objAccTM.UserId);
                }
                
            }
            
            //Asigno el TM Account segun la cuenta y el numero de NIT
            if (objLead.RecordTypeId == strRecordTypeLeadSalud && objLead.Status == 'Validado' ){
                System.debug('---------- ENTRO POR EL IF ASIGNACION...');
                if (!mapCuentaxTM.isEmpty()){ //PREGUNTO SI EXISTE UN USUARIO EN EL TM
                    
                        objLead.OwnerId = mapCuentaxTM.get('2'+setNit);
                        objLead.COS_Asignado_salud__c = TRUE;
                        objLead.COS_Nit_empresa__c = setNit;
                        leadListUpd.add(Objlead);
                    
                    
                } else {
                    System.debug('---------- PASO LEAD POR DISTRIBUCION DE CARGAS...');
                    leadDistribucionCarga.add(Objlead);  //PASO a ASIGNACION POR DISTRIBUCION DE CARGA
                }
                
            }
            
            RegistrosProcesados = RegistrosProcesados + 1;
        }
        
        if(!leadDistribucionCarga.isEmpty()){
            COS_AsignacionProspectos_cls.asignacionProspectosDistCarga(leadDistribucionCarga);
        }
        
        if (!leadListUpd.isEmpty()){
            update leadListUpd;
        }
        
    }
    
    
    //Finish
    global void finish(database.BatchableContext BC){
        //System.debug('Lista de prospectos --> ' + scope);
        System.debug(RegistrosProcesados + ' Registros Procesados.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    }
    
}