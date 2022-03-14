public with sharing class COM_EncuentroConDirectivos_ctr {


    public String strSegmento{get;set;}
    public COM_Actas__c objActa{get;set;}
    public list<Opportunity> lstOppotunidades {get;set;}
    public Decimal valorTotal {get;set;}
    public Integer ano{get;set;}
    public Integer mes{get;set;}
    public Integer dia {get;set;}

    /**
     * [COM_EncuentroConDirectivos_ctr description]
     * @param  controller [description]
     * @return            [description]
     */
    public COM_EncuentroConDirectivos_ctr(ApexPages.Standardcontroller controller) 
    {
        String strId = Apexpages.currentPage().getParameters().get( 'id' );
        valorTotal = 0;
        objActa = [Select Id, COM_Cuenta__c,
                COM_Cuenta__r.COM_Segmento__c,
                COM_Cuenta__r.Name,
                COM_NIT__c,
                COM_Listadirectivoscargos__c,
                COM_ObjetoSocial__c,
                COM_FechaRealizacion__c,
                COM_TemasaTratar__c,
                COM_SituacionesRelevantes__c,
                COM_AfiliadosCaja__c,
                COM_AfiliadosPOS__c,
                COM_AfiliadosPC__c,
                COM_Aporte4__c,
                COM_Subsidio__c,
                COM_Superavit__c,
                COM_SPBAnio__c,
                COM_SPBANIOVALOR__c,
                COM_SPBPresupuestado__c,
                COM_SPBEJECUTADO__c,
                COM_Facturacionanio__c,
                COM_PresupuestadoFacturacion__C,
                COM_EjecutadoFacturacion__c,
                COM_Perfiltrabajadores__c,
                COM_Salud__c,
                COM_Pensiones__c,
                COM_ARL1__r.Name,
                COM_Relaciondirectivos__c,
                COM_ContactoTrabajadores__c,
                COM_ConveniosFiliacionesContratos__c,
                COM_CanalesComunicacion__c,
                COM_ObjetivosLogros__c
        from  COM_Actas__c 
        where id =: strId  limit 1];

        if ( objActa != null   ){
            if(objActa.COM_FechaRealizacion__c!= null){
              ano = objActa.COM_FechaRealizacion__c.year(); 
              mes = objActa.COM_FechaRealizacion__c.month();
              dia = objActa.COM_FechaRealizacion__c.day();
            }
            system.debug('objActa'+objActa);
            String idCuenta  = objActa.COM_Cuenta__r.Id;
            lstOppotunidades = new List<Opportunity>(); 
            lstOppotunidades = getOportunidades(idCuenta);
        }
                
    }

    /**
     * [getOportunidades description]
     * @param  idCuenta [description]
     * @return          [description]
     */
    public List<Opportunity> getOportunidades(String idCuenta){
            List<Opportunity> lstOppotunidades = new List<Opportunity>();
            Set<String> setRecordType = new Set<String>();
            for(RecordType r : [SELECT Id, Name FROM RecordType where SobjectType = 'Opportunity' and BusinessProcessId not in (SELECT Id FROM BusinessProcess where Name =: Label.COM_PAF_nameProcess)]){
                setRecordType.add(r.Id);
            }
            lstOppotunidades = [Select Name, Amount, COM_Numeroasistentes__c, COM_Fechahorainicio__c, StageName, COM_Fechahorafinalizacion__c, RecordType.Name from Opportunity where AccountId =: idCuenta AND RecordTypeId in : setRecordType];
            if (!lstOppotunidades.isEmpty()){
                for ( Opportunity opp : lstOppotunidades){
                        if (opp.amount != null)
                        valorTotal += opp.amount;   
                }
            }
            return lstOppotunidades;
    }
    
}