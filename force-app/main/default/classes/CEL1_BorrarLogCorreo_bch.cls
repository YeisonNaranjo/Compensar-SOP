/*******************************************************************************
Desarrollado por:  Avanxo Colombia 
Autor:   <Manuel Mendez> 
Proyecto:  <ETEK> 
Descripción:  Clase batch para el batch CEL1_BorrarLogCorreo_bch

Cambios (Versiones)     
-------------------------------------     
No.     Fecha        Autor                        Descripción     
------  ----------   --------------------------   -----------     
1.0     09-12-2019   Manuel Mendez                Create Class      
*******************************************************************************/
global class CEL1_BorrarLogCorreo_bch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('Entro a batch para ejecutar logica--->>>>');
        CEL1_ConfiguracionLogCorreos__mdt objMetadata = [SELECT CEL1_NumeroCorreosSalientes__c,
                                                        CEL1_RangoDiasBorrarLogsCorreo__c,
                                                        Id
                                                        FROM CEL1_ConfiguracionLogCorreos__mdt
                                                        limit 1];
        DateTime dtaFecha = System.now();
        DateTime dtaFechaBorrado = dtaFecha.addDays(-(Integer.valueOf(objMetadata.CEL1_RangoDiasBorrarLogsCorreo__c)));
        // DateTime dtaFechaBorrado = dtaFecha.addHours(-1);
        System.debug('dtaFechaBorrado--->>>'+dtaFechaBorrado);

        
        return Database.getQueryLocator([SELECT Id,
                                        Id_Padre__c 
                                        FROM Log_Correo_Electronico__c
                                        WHERE CreatedDate <=:dtaFechaBorrado
                                        AND CEL1_Candidato__c != null]);
    }

    global void execute(Database.BatchableContext BC, List<Log_Correo_Electronico__c> lstLogCorreo) 
    {
        System.debug('\n\n-=#=-\n>>>>>>>>>>   '+'CEL1_BorrarLogCorreo_bch - execute');
        System.debug('lstLogCorreo.....'+lstLogCorreo);
        if(!lstLogCorreo.isEmpty()){
            System.debug('ENTRO A IF.....');
            Delete lstLogCorreo;
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'CEL1_BorrarLogCorreo_bch - finish' + '   <<<<<<<<<<\n-=#=-\n');
    }
}