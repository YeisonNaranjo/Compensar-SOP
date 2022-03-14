/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Brisleydi Calderon (BC) 
Proyecto:          Compensar
Descripción:       Trigger del objeto EmailMessage

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     24/05/18             Brisleydi Calderon (BC)             Creación Clase.
*/
trigger COM_EmailMessage_trg on EmailMessage (After insert) {

  if(trigger.isAfter) {
    for(EmailMessage objmessage : trigger.new){
      if(objmessage.ParentId != null){

        RF2_Case_cls  rf2Case = new RF2_Case_cls ();
    
        List <String> idCasos = new List<String>();
    
        for(EmailMessage message : trigger.new)
        {
          if(message.ToAddress == label.ValorEmailtoCaseSandbox_lbl || message.ToAddress == label.ValorEmailtoCaseProduccion_lbl) {
            idCasos.add(message.ParentId);
          }
    
        }
    
        List<Case> casos;
        System.debug('idCasos....'+idCasos);
        if(idCasos != null){
          System.debug('ENTRO A IF DE IDCASOS....');
          casos = [Select Id, RF2_ProcesoDestinoMatrizResponsable__c, RF2_RelacionadoCon__c, RF2_TipoSolicitud__c  from Case where id In :idCasos ];
          System.debug('casos....'+casos);
        }
        System.debug('casos222....'+casos);
    
        List<SlaProcess> procesoAns = [select Id,Name from SlaProcess  where Name =: Label.ValorAns80Horas];
    
        
            List<Entitlement> ansEntitlement = [SELECT Name, Id, Rf2_GCN__c, RF2_Canal__c FROM Entitlement where RF2_Canal__c =: Label.ValorCorreoElectronico_lbl and Rf2_GCN__c =: Label.RF2_GCNVacio_lbl];
            List<Entitlement> entitlementListGen =[SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSGenerico_lbl];
            String idString; 
            Entitlement prueba;
            String idAns = '';
            String ansName = '';
            String origen = '';
    
            for (SlaProcess procesoSLA: procesoAns){
              for (Entitlement e: ansEntitlement){
                idString=procesoSLA.Name;
                 if (idString == Label.ValorAns80Horas)
                 idAns = e.Id;
                 ansName = e.Rf2_GCN__c;
                 origen = e.RF2_Canal__c;
              }
            }
            for(Case c : casos){
                 c.RF2_ProcesoDestinoMatrizResponsable__c = Label.ValorCRMGIE_lbl;
                 c.RF2_RelacionadoCon__c = label.ValorAclaracionesEmpleadores_lbl;
                 c.RF2_TipoSolicitud__c = label.ValorSolicitudGIE_lbl;
                 c.RF2_EsPCE__c=true;
                 c.RF2_GCN__c=Label.RF2_GCNVacio_lbl;
                 if (origen == Label.ValorCorreoElectronico_lbl && ansName == Label.RF2_GCNVacio_lbl)
                 c.EntitlementId = idAns; else {
                    c.RF2_ObligatorioCalidad__c = entitlementListGen.get(0).RF2_ObligatorioCalidad__c;
                    c.EntitlementId = entitlementListGen.get(0).Id;
                }
            }
    
            update casos;
       
        //rf2Case.crearCasoTipificado(casos);
           
        }  
      }
    }
}