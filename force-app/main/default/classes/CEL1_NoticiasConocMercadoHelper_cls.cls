/************************************************************************************************
Desarrollado por:  Globant
Autor:             Paula Bohórquez (PB)
Proyecto:          Compensar
Descripción:       Helper del objeto Noticias Conocimiento Mercadeo

Cambios (Versiones)
-----------------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                               Descripción
----------  -------------   -------------------------  ----------------------------------------------------
    1.0     12/03/20         Paula Bohórquez  (PB)                   Creación Clase.
    2.0     27/03/20         Andrea Contreras  (PB)      Modificación para agregar multipicklist
    3.0     13/07/20         Juan Buitrago (JB)       Asignación de FeedItems por Noticia y Fecha publicación
*************************************************************************************************************/

public class CEL1_NoticiasConocMercadoHelper_cls {

    /**
    * @Method:      crearPublicacionChatter
    * @param:       List<CEL1_NoticiasConocimientoMercado__c> lstProspectos
    * @Description: Crea una publicación en chatter con base en la información del objeto
    * 				Noticias Conocimiento Mercadeo y la comparte con el grupo privado cuyo npmbre
    * 				corresponda con el del campo 'Grupo de interés'
    * @author       Paula Bohórquez Alfonso- 05 de Noviembre 2019 
    */
    //public static void crearPublicacionChatter(List<CEL1_NoticiasConocimientoMercado__c> lstNewNoticias,Map<Id,CEL1_NoticiasConocimientoMercado__c> mapOldNoticias){
    public static void crearPublicacionChatter(Map<Id,CEL1_NoticiasConocimientoMercado__c> mapNewNoticias,Map<Id,CEL1_NoticiasConocimientoMercado__c> mapOldNoticias){
        
       	Set<Id> setIdNoticiasConfirm = new Set<Id>();
        Set<String> setGrupoInteres = new Set<String>();
        List<CEL1_NoticiasConocimientoMercado__c> lstNotUpdate = new List<CEL1_NoticiasConocimientoMercado__c>(); 
        for(CEL1_NoticiasConocimientoMercado__c objNoticias : mapNewNoticias.values()){
            if(objNoticias.CEL1_Estado__c != mapOldNoticias.get(objNoticias.Id).CEL1_Estado__c && objNoticias.CEL1_Estado__c=='Confirmada'){
                setIdNoticiasConfirm.add(objNoticias.Id);
                if(objNoticias.CEL1_GrupoInteres__c!=null && objNoticias.CEL1_GrupoInteres__c.contains(';')){
                    System.debug('Entro if ::'+objNoticias.CEL1_GrupoInteres__c);
                    String[] arreglo=objNoticias.CEL1_GrupoInteres__c.split(';');
                    System.debug('arreglo  :::' +arreglo);
                    System.debug('arreglo size  :::' +arreglo.size());
                    for(integer i=0;i<arreglo.size();i++){
                         setGrupoInteres.add(arreglo[i]);
                    }
                } else if (objNoticias.CEL1_GrupoInteres__c!=null) {
                    System.debug('Entro else  '+objNoticias.CEL1_GrupoInteres__c);
                    setGrupoInteres.add(objNoticias.CEL1_GrupoInteres__c);
                }
            }
        }
        
        Map<Id,Id> mapIdFeedxIdNot = new Map<Id,Id>();
        Map<Id,List<Id>> mapIdNotxLstCD = new Map<Id,List<Id>>();        
        //Obtener adjuntos del mensaje
        if(!setIdNoticiasConfirm.isEmpty()){
            for(ContentDocumentLink cdl : [SELECT ContentDocument.LatestPublishedVersionId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: setIdNoticiasConfirm]){
                if(mapIdNotxLstCD.containsKey(cdl.LinkedEntityId)){
                    mapIdNotxLstCD.get(cdl.LinkedEntityId).add(cdl.ContentDocument.LatestPublishedVersionId);
                }   
                else{
                    List<Id> lstCV = new List<Id>();
                    lstCV.add(cdl.ContentDocument.LatestPublishedVersionId);
                    mapIdNotxLstCD.put(cdl.LinkedEntityId,lstCV);
                }           
            }  
        }
        
        List<FeedItem> lstFI = new List<FeedItem>();
        Map<Integer,Id> mapIndexxIdNot = new Map<Integer,Id>();
        Map<String,Id> mapGrupoxId = new Map<String,Id>();
        
        //Obtener grupos privados
        for(CollaborationGroup objCG : [SELECT Id,Name FROM CollaborationGroup WHERE Name IN: setGrupoInteres]){
            mapGrupoxId.put(objCG.Name,objCG.Id);
        }
        Integer index = 0;
        String strBody;
        String tmp;
        for(Id idNoticia : setIdNoticiasConfirm){
            System.debug('-->>idNoticia : '+setIdNoticiasConfirm);
            System.debug('-->>mapGrupoxId : '+mapGrupoxId);
            System.debug('-->>mapNewNoticias.get(idNoticia).CEL1_GrupoInteres__c : '+mapNewNoticias.get(idNoticia).CEL1_GrupoInteres__c);             
            if(mapNewNoticias.get(idNoticia).CEL1_GrupoInteres__c.contains(';')){
                System.debug('mapNewNoticias entro iff ::: ');
                String[] arregloGrupos=mapNewNoticias.get(idNoticia).CEL1_GrupoInteres__c.split(';');
                for(integer j=0;j<arregloGrupos.size();j++){
                    if(mapGrupoxId.containsKey(arregloGrupos[j])){
                        System.debug('entro a contains mapgrupoid');
                        strBody =  mapNewNoticias.get(idNoticia).CEL1_DescripcionFinal__c;
                        if(!String.isBlank(mapNewNoticias.get(idNoticia).CEL1_Categoria__c)){
                            tmp = ' #'+mapNewNoticias.get(idNoticia).CEL1_Categoria__c;
                            if(tmp.contains(';')){
                                tmp = tmp.replaceAll(';', ' #');
                            }                    
                            strBody = strBody + ' '+tmp;
                        }
                        
                        lstFI.add(new FeedItem(
                                    Body=strBody,
                                    ParentId=mapGrupoxId.get(arregloGrupos[j])
                        )); 
                           mapIndexxIdNot.put(index,idNoticia);
                            index ++;     
                    }
               }
            } else {
                System.debug('mapNewNoticias entro else  ::: ');
                if(mapGrupoxId.containsKey(mapNewNoticias.get(idNoticia).CEL1_GrupoInteres__c)){
                    System.debug('entro a contains mapgrupoid');
                    strBody =  mapNewNoticias.get(idNoticia).CEL1_DescripcionFinal__c;
                    if(!String.isBlank(mapNewNoticias.get(idNoticia).CEL1_Categoria__c)){
                        tmp = ' #'+mapNewNoticias.get(idNoticia).CEL1_Categoria__c;
                        if(tmp.contains(';')){
                            tmp = tmp.replaceAll(';', ' #');
                        }                    
                        strBody = strBody + ' '+tmp;
                    }
                    
                    lstFI.add(new FeedItem(
                                Body=strBody,
                                ParentId=mapGrupoxId.get(mapNewNoticias.get(idNoticia).CEL1_GrupoInteres__c)
                    )); 
                    mapIndexxIdNot.put(index,idNoticia);
                    index ++;     
                   
                }
            }
                
        }
        System.debug('mapIndexxIdNot ::: '+mapIndexxIdNot + ' index :::'+index);
        //Insertar attachments del feed
        List<FeedAttachment> lstFAtt = new List<FeedAttachment>();
        //List 
        
        if(!lstFI.isEmpty()){
            System.debug('-->>>crearPublicacionChatter : lstFI 1: '+lstFI);            
            // DML statement
            Database.SaveResult[] srList = Database.insert(lstFI, false);
            System.debug('srList '+srList);
            Id idNoticia;
            String strPostChatter = '';
            Map<Id,Set<Id>> mapSetFeedsIdxIdNoticia = new Map<Id,Set<Id>>();
            for(Integer i=0;i<srList.size();i++){
                if (srList.get(i).isSuccess()){
                    System.debug('entro isSuccess');
                    idNoticia = mapIndexxIdNot.get(i); //ID NOTICIA
                    if(!mapSetFeedsIdxIdNoticia.containsKey(idNoticia))
                        mapSetFeedsIdxIdNoticia.put(idNoticia, new Set<Id>{srList.get(i).Id});
                    else
                        mapSetFeedsIdxIdNoticia.get(idNoticia).add(srList.get(i).Id);
                    
                    // strPostChatter+=srList.get(i).Id+';';   
                    if(mapIdNotxLstCD.containsKey(idNoticia)){
                        for(Id idCV : mapIdNotxLstCD.get(idNoticia)){
                            lstFAtt.add(new FeedAttachment(
                            	FeedEntityId = srList.get(i).Id,
                            	RecordId = idCV, 
                            	Type = 'CONTENT' 
                            ));
                        }    
                    }  
                }else if (!srList.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = srList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    System.debug('**failedDML: '+failedDML);
                    srList.get(i);//failed record from the list
                    system.debug('Failed ID'+srList.get(i).Id);
                 }            
            }
            map<Id,String> mapStrFeedsxIdNoticia = new map<Id,String>();
            for(Id idNotice  : mapSetFeedsIdxIdNoticia.keySet()){
                for(Id idFeed : mapSetFeedsIdxIdNoticia.get(idNotice)){
                    strPostChatter += idFeed + ';';
                }
                mapStrFeedsxIdNoticia.put(idNotice, strPostChatter);
                strPostChatter = '';
            }
            System.debug('****mapStrFeedsxIdNoticia es: ' + mapStrFeedsxIdNoticia);
            for(Id idNotice : mapStrFeedsxIdNoticia.keySet()){
                lstNotUpdate.add(new CEL1_NoticiasConocimientoMercado__c(
                    Id = idNotice,
                    CEL1_PostChatter__c = mapStrFeedsxIdNoticia.get(idNotice),
                    CEL1_FechaPublicacion__c = Date.today()
                    ));             
                }
            }        
            if(!lstFAtt.isEmpty()){
                System.debug('-->>>crearPublicacionChatter : lstFAtt 2: '+lstFAtt);
                insert lstFAtt; 
            }
            
        System.debug('****lstNotUpdate es: ' + lstNotUpdate);
        if(!lstNotUpdate.isEmpty()){
            System.debug('-->>>crearPublicacionChatter : lstNotUpdate 3: '+lstNotUpdate);
            update lstNotUpdate;
        }
    }
    
}