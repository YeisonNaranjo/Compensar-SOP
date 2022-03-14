/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Luis Rafael Peñaranda (LRP)
Proyecto:          Compensar
Descripción:       Clase controladora para el trigger del objeto LiveChatTranscript

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     10/11/19             Luis Rafael Peñaranda (LRP)             Creación Clase.
2.0     01/14/20             Juan David Vargas Alejo (JDVA)          Creación Metodo actualizarConsultaTranscripcion
************************************************************************************************/
public class MGLT_LiveChatTranscript_cls {
    
    public static void asociarClienteATranscripcion(list<LiveChatTranscript> lstNewLiveChatTranscript)
    {
        map<String,String> mapIdCOntactoXIdCuenta;
        set<String> setNumDocsContactos = new set<String>();
        Id idCuenta;
        String strLlave;
        //System.debug('lstNewLiveChatTranscript-->'+lstNewLiveChatTranscript);
        
        for(LiveChatTranscript objTransc : lstNewLiveChatTranscript) {
            setNumDocsContactos.add(objTransc.RF2_NumeroIdentificacion__c);
        } 
        System.debug('setNumDocsContactos-->'+setNumDocsContactos);
        mapIdCOntactoXIdCuenta = setClientesDeContacto(lstNewLiveChatTranscript,setNumDocsContactos);
        
        
        for(LiveChatTranscript objTransc : lstNewLiveChatTranscript) 
        {
            //System.debug('objTransc-->'+objTransc);
            strLlave = objTransc.MGLT_Tipo_Identificacion__c+objTransc.RF2_NumeroIdentificacion__c;
            idCuenta = mapIdCOntactoXIdCuenta.get(strLlave);
            objTransc.AccountId = idCuenta;
            //System.debug('objTransc-2->'+objTransc);                        
        }
        setTipoIdentificacion(lstNewLiveChatTranscript);
    }
    
    public static void setTipoIdentificacion(list<LiveChatTranscript> lstNewLiveChatTranscript) 
    {
        map<String,String> mapOptions = new map<String,String> ();        
        Schema.DescribeFieldResult fieldResult  =   contact.MGLT_Tipo_Identificacion_Chat__c.getDescribe();        
        List<Schema.PicklistEntry> ple          =   fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry elemento : ple)
        {
            mapOptions.put(elemento.getValue(), elemento.getLabel());
        }       
        
        for(LiveChatTranscript objTransc : lstNewLiveChatTranscript) {
            if(objTransc.MGLT_Tipo_Identificacion__c =='1' || 
               objTransc.MGLT_Tipo_Identificacion__c =='2' || 
               objTransc.MGLT_Tipo_Identificacion__c =='3' || 
               objTransc.MGLT_Tipo_Identificacion__c =='4' || 
               objTransc.MGLT_Tipo_Identificacion__c =='5' || 
               objTransc.MGLT_Tipo_Identificacion__c =='6' || 
               objTransc.MGLT_Tipo_Identificacion__c =='6' || 
               objTransc.MGLT_Tipo_Identificacion__c =='8' || 
               objTransc.MGLT_Tipo_Identificacion__c =='9' )
            {
                objTransc.MGLT_Tipo_Identificacion__c = mapOptions.get(objTransc.MGLT_Tipo_Identificacion__c);
            }
            
        }
        
        //System.debug('mapOptions-->'+mapOptions);
        
    }
    
    public static map<String,String> setClientesDeCOntacto(list<LiveChatTranscript> lstNewLiveChatTranscript,set<String> setNumDocsContactos) 
    {
        map<String,String> mapIdCOntactoXIdCuenta = new map<String,String>();
        String strLlave;
        List<Contact> lstContact = [Select id,AccountId,COM_TipoIdentificacion__c,COM_Numeroidentificacion__c 
                                    from Contact where COM_Numeroidentificacion__c in:setNumDocsContactos];
        //System.debug('lstContact-->'+lstContact);
        if(!lstContact.isEmpty())
        {
            for (Contact objCon:lstContact){
                strLlave = objCon.COM_TipoIdentificacion__c+objCon.COM_Numeroidentificacion__c;
                mapIdCOntactoXIdCuenta.put(strLlave,objCon.AccountId);
            }
            //System.debug('mapIdCOntactoXIdCuenta-->'+mapIdCOntactoXIdCuenta);
        }
        return mapIdCOntactoXIdCuenta;
    }   
    
    public static void cambiarPropietarioCaso(list<LiveChatTranscript> lstNewLiveChatTrans, map<Id,LiveChatTranscript> mapAnterior)
    {
        List<LiveChatTranscript> lstNewLiveChatTranscript = new List<LiveChatTranscript>();

        for(LiveChatTranscript objTransc : lstNewLiveChatTrans) {
            if (objTransc.Status != 'Completed') {
                lstNewLiveChatTranscript.add(objTransc);
            }
        }

        if (lstNewLiveChatTranscript.isEmpty()) {
            return;
        }
        set<ID> setCasosId = new  set<ID>();
        case casoActivo;
        LiveChatTranscript objLiveChatTranscriptAnterior;

        for(LiveChatTranscript objTransc : lstNewLiveChatTranscript) {
            setCasosId.add(objTransc.CaseId);
        }   
        
        Map<ID, Case> mapCasos = getCasosDeTranscripcion(setCasosId);
        System.debug('mapCasos-->'+mapCasos);
        for(LiveChatTranscript objTransc : lstNewLiveChatTranscript) 
        {
            objLiveChatTranscriptAnterior = mapAnterior.get(objTransc.Id);
            System.debug('objLiveChatTranscriptAnterior-->'+objLiveChatTranscriptAnterior);    
            
            
            if(!mapCasos.isEmpty())
            {    
                casoActivo          = mapCasos.get(objTransc.CaseId);
                if(casoActivo!=null){
                    System.debug('casoActivo-->'+casoActivo); 
                    casoActivo.OwnerId  = objTransc.OwnerId;
                } 
            }
            
        } 
        //update mapCasos.values();
        
        if(casoActivo!=null){
            update casoActivo;
        }
    }
    public static map<ID,Case> getCasosDeTranscripcion(set<Id> setCasosId) 
    {
        Map<ID, Case> mapCasos = new Map<ID, Case>([Select id,ownerId,MGLT_Consulta__c from Case where id in:setCasosId]);
        return mapCasos;
    }
    
    public static void actualizarConsultaTranscripcion(list<LiveChatTranscript> lstNewConsultaTranscript){
        System.debug('lstNewConsultaTranscript-->'+lstNewConsultaTranscript);
        map<String,String> ConsultLabel = new map<String,String>();
        Schema.DescribeFieldResult fieldResult =
        Case.MGLT_Consulta__c.getDescribe();
        system.debug('saber-->'+fieldResult );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple---->'+ ple);
        for( Schema.PicklistEntry f : ple)
        {
            ConsultLabel.put(f.getValue(),f.getLabel());
        }
        system.debug('mapa'+ConsultLabel);
        set<ID> setCasosIdCT = new  set<ID>();
        
        for(LiveChatTranscript objTransc : lstNewConsultaTranscript) {
            setCasosIdCT.add(objTransc.CaseId);
        }   
        System.debug('setCasosIdCT-->'+setCasosIdCT);
        
        Map<ID, Case> mapCasos = getCasosDeTranscripcion(setCasosIdCT);
        System.debug('mapCasosCT-->'+mapCasos);
        for(LiveChatTranscript objTransc : lstNewConsultaTranscript) 
        {
            if(!mapCasos.isEmpty())
            {
                if (objTransc.CaseId != null && mapCasos.containsKey(objTransc.CaseId) && mapCasos.get(objTransc.CaseId).MGLT_Consulta__c != null) {
                    objTransc.RF2_Consulta__c = ConsultLabel.get(mapCasos.get(objTransc.CaseId).MGLT_Consulta__c);
                }

            }        
                System.debug('RF2_Consulta__c-->'+objTransc.RF2_Consulta__c);           
        } 
    }
}