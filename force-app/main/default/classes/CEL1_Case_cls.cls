/************************************************************************************************
Desarrollado por:  Globant
Autor:             Andrea Contreras(AC)
Proyecto:          Compensar
Descripción:      Handler of case to asign ANS 

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/12/19         Andrea Contreras  (AC)    Creación Clase.   
**************************************************************************************************/
public with sharing class CEL1_Case_cls {
    public CEL1_Case_cls() {

    }
     List<Entitlement> entitlementList = [SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c, RF2_AnsEscalamiento__c FROM Entitlement where Name like '%ASIG%'];
     List<Entitlement> entitlementListGen =[SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSGenerico_lbl];
    //** CEL1_: 10-12-19 : Metodo que captura el cambio de Origen del caso y GCN para recalculo de ANS */
     public void buscarANSCaso(List<Case> oldToAssing, List<Case> newToAssing){
         System.debug(' CEL1_Case_cls ::: buscarANSCaso ::: ');
        for(Integer i = 0; i< newToAssing.size(); i++){
            if(oldToAssing != null && !oldToAssing.isEmpty()){
                 System.debug(' CEL1_Case_cls ::: Es una modificacion :: ');
                 System.debug(' CEL1_Case_cls ::: oldToAssing[i].Status  :: '+oldToAssing[i].Status );
                 System.debug(' CEL1_Case_cls ::: oldToAssing[i].Origin :: '+oldToAssing[i].Origin);
                 System.debug(' CEL1_Case_cls ::: newToAssing[i].Origin :: '+newToAssing[i].Origin);
                 System.debug(' CEL1_Case_cls ::: oldToAssing[i].RF2_GCN__c :: '+oldToAssing[i].RF2_GCN__c);
                 System.debug(' CEL1_Case_cls ::: newToAssing[i].RF2_GCN__c :: '+newToAssing[i].RF2_GCN__c);
                if(oldToAssing[i].Status != Label.RF2_EstadoCerradoCaso_lbl
                && (oldToAssing[i].Origin != newToAssing[i].Origin
                || oldToAssing[i].RF2_GCN__c != newToAssing[i].RF2_GCN__c)){
                     asignarANSCaso(newToAssing[i]);
                    
                }
             }
        }
     }

  /**
    * Asignar ANS 
    * @param caseToAssing [description]
    */
    private void asignarANSCaso(Case caseToAssing){
        System.debug('::: CEL1_Case_cls ::: asignarANSCaso :: caseToAssing :: '+caseToAssing);
        // se validan los datos del caso
            if(caseToAssing.Origin != null && caseToAssing.RF2_GCN__c != null){
                caseToAssing.Entitlement = obtenerEntitlement(caseToAssing.Origin, caseToAssing.RF2_GCN__c);
                System.debug('::: CEL1_Case_cls ::: asignarANSCaso ::  caseToAssing.Entitlement :: '+ caseToAssing.Entitlement);
                if(caseToAssing.Entitlement == null){
                    asignarANSGenerico(caseToAssing);
                }else{
                    caseToAssing.RF2_ObligatorioCalidad__c = caseToAssing.Entitlement.RF2_ObligatorioCalidad__c;
                    caseToAssing.EntitlementId = caseToAssing.Entitlement.Id;
                }
            }else{
                asignarANSGenerico(caseToAssing);
            }
    }
    
        /**
* Se asigna al caso el ANS Generico al no encontrar la informacion requerida
*/
    private void asignarANSGenerico(Case toAssingGen){
        System.debug('>>>>>>>>> WA - el caso no tiene los datos necesarios para Asignarle ANS');
        System.debug('>>>>>>>>> WA - nombre caso ' + toAssingGen.Subject);
        System.debug('>>>>>>>>> WA - Origin '+ toAssingGen.Origin);
        System.debug('>>>>>>>>> WA - RF2_GCN__c '+ toAssingGen.RF2_GCN__c);
        // en este punto se debe asignar un ANS Generico
        if(!entitlementListGen.isEmpty()){
            System.debug('>>>>>>>>> Se Asigna ANS Generico');
            toAssingGen.RF2_ObligatorioCalidad__c = entitlementListGen.get(0).RF2_ObligatorioCalidad__c;
            toAssingGen.EntitlementId = entitlementListGen.get(0).Id;
        }else{
            System.debug('>>>>>>>>> No se encuentra ANS Genérico');
        }
    }

     /**
* Dado un canal y un GCN se obtiene el entitlement para asignar al caso
* @param  strCanal [description]
* @param  strGCN   [description]
* @return          [description]
*/
    private Entitlement obtenerEntitlement(String strCanal, String strGCN){
        for(Entitlement obj : entitlementList)
        {
            if(obj.RF2_Canal__c == strCanal && obj.Rf2_GCN__c == strGCN){
                return obj;
            }
        }
        return null;
    }
 
}