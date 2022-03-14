/*******************************************************************************
Desarrollado por:  Avanxo Colombia 
Autor:   <Manuel Mendez> 
Proyecto:  <Compensar Celula> 
Descripción:  Clase Schedulable para el batch CEL1_ActualizarLogCorreo_bch

Cambios (Versiones)     
-------------------------------------     
No.     Fecha        Autor                        Descripción     
------  ----------   ---------------------   -----------     
1.0     09-12-2019   Manuel Mendez           Create Class      
2.0     27-03-2020   Andrea Conttreras       Modified class to change the field CEL1_PostChatter__c that saves more than one id
3.0     13-07-2020   Juan Buitrago           Redesign of deletion of records of Documents and Notices and changes in filter
*******************************************************************************/
global class CEL1_BorradoMuro_bch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC)
	{
        System.debug('Entro a batch start....');
        return Database.getQueryLocator([SELECT Id, CEL1_NoticiaConfirmada__c
                                        FROM CEL1_BorradoMuro__mdt
                                        Limit 1]);
    }

    global void execute(Database.BatchableContext BC, List<CEL1_BorradoMuro__mdt> lstBorradoMuro) 
   	{
        if (!lstBorradoMuro.isEmpty()) {
            Datetime dtaFechaBorradoConf    = System.now();
            Datetime newdtaFechaBorradoConf = dtaFechaBorradoConf.addDays(-(Integer.valueOf(lstBorradoMuro.get(0).CEL1_NoticiaConfirmada__c)));
            Date newDateBorrado = Date.newinstance(newdtaFechaBorradoConf.year(), newdtaFechaBorradoConf.month(), newdtaFechaBorradoConf.day());
            System.debug('****dtaFechaBorradoConf....'+dtaFechaBorradoConf);
            System.debug('****newdtaFechaBorradoConf....'+newdtaFechaBorradoConf);
            System.debug('****newDateBorrado....'+newDateBorrado);

            List<CEL1_NoticiasConocimientoMercado__c> lstNoticiasConfirmadas = [SELECT Id,
                                                                                CEL1_PostChatter__c
                                                                                FROM CEL1_NoticiasConocimientoMercado__c
                                                                                WHERE CEL1_FechaPublicacion__c < : newDateBorrado
                                                                                AND CEL1_Estado__c = 'Confirmada'];
            System.debug('lstNoticiasConfirmadas.....'+lstNoticiasConfirmadas);

            Set<Id> setIdNoticias = new Set<Id>();
            Set<Id> setIdFeed = new Set<Id>();
            if (!lstNoticiasConfirmadas.isEmpty()) {
                for (CEL1_NoticiasConocimientoMercado__c objNoticias: lstNoticiasConfirmadas) {
                    setIdNoticias.add(objNoticias.Id);
                    if(objNoticias.CEL1_PostChatter__c != null && objNoticias.CEL1_PostChatter__c.contains(';')){
                        String[] arregloPostChatter=objNoticias.CEL1_PostChatter__c.split(';');
                        System.debug('arregloPostChatter  :::' +arregloPostChatter);
                        System.debug('arregloPostChatter size  :::' +arregloPostChatter.size());
                        for(integer i=0;i<arregloPostChatter.size();i++){
                            setIdFeed.add(arregloPostChatter[i]);
                        }
                    } else if(objNoticias.CEL1_PostChatter__c != null ){
                        setIdFeed.add(objNoticias.CEL1_PostChatter__c);
                    }
                }
                System.debug('setIdFeed...'+setIdFeed);
                List<FeedItem> lstFeed = [SELECT Id 
                                        FROM FeedItem
                                        WHERE Id IN: setIdFeed];
                System.debug('lstFeed....'+lstFeed);
                if (!lstFeed.isEmpty()) {
                    System.debug('lstFeed delete...'+lstFeed);
                    delete lstFeed;
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
		System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'CEL1_ActualizarLogCorreo_bch - finish' + '   <<<<<<<<<<\n-=#=-\n');
	}    
}