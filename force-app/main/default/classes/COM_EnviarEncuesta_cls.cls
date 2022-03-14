public class COM_EnviarEncuesta_cls {
    
    /**
* Funcion para la creacion de encuestas para casos pce que cumplan con criterios - Waldana
* @param      newCases  The new cases
*/ 
    
    public static String crearEncuesta(Case objCase){
        System.debug('Entrar a enviar encuestas PCE');
        //Lista de encuentas crear
        list<RecordType> lstRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'AVX_ENC_Encuesta__c' AND DeveloperName = 'Sin_contestar'];
        List<AVX_ENC_Encuesta__c> listaEncuestas = new List<AVX_ENC_Encuesta__c>();
        
        list<AVX_ENC_PlantillaEncuesta__c> lstPlantillasEncuestas = [SELECT Id, Name FROM AVX_ENC_PlantillaEncuesta__c WHERE Activo__c = true and Name =: Label.COM_NombreEncuestaSondeoPCE_lbl limit 1];
        list<AVX_ENC_PlantillaEncuesta__c> lstPlantillasEncuestasGIE = [SELECT Id, Name FROM AVX_ENC_PlantillaEncuesta__c WHERE Activo__c = true and Name =: Label.COM_NombreEncuestaSondeoGIE_lbl  limit 1];
        
        String servicio = label.COM_ServicioEncuestaGIE_lbl; 
        List<String> servicioGIE = servicio.split(','); 
        Integer indexx = 0;
        
        if(objCase.RF2_TipoSolicitud__c == 'Queja' || objCase.RF2_TipoSolicitud__c == 'Solicitud PCE'){
            // crear encuestas
            AVX_ENC_Encuesta__c objEncuesta = new AVX_ENC_Encuesta__c();
            
            if(!lstPlantillasEncuestas.isempty() && !lstRecordType.isempty())
            {
                objEncuesta.RecordTypeId = lstRecordType.get(0).Id;
                objEncuesta.Plantilla_encuesta__c = lstPlantillasEncuestas.get(0).Id;
                system.debug('Entró PCE');
            }
            //Inicio v14.1
            if(objCase.ParentId==null){
                Id recordTypexId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
                
                if (objCase.AccountId != null && objCase.RF2_CorreoElectronicoRespuesta__c != null){
                    Account objAcc = [Select id, RecordTypeId from Account where id =: objCase.AccountId];
                    
                    if (objCase.ContactId != null || objAcc.recordtypeId == recordTypexId){
                        objEncuesta.COM_Cliente__c = objCase.AccountId;
                        objEncuesta.COM_Caso__c = objCase.Id;
                        objEncuesta.RF2_CorreoElectronicoRespuesta__c = objCase.RF2_CorreoElectronicoRespuesta__c;
                        
                        if (objCase.ContactId != null){
                            objEncuesta.COM_Contacto__c = objCase.ContactId;
                        }
                        listaEncuestas.add(objEncuesta); 
                    }
                }
            }           
        }
        else if (objCase.RF2_TipoSolicitud__c == 'Solicitud GIE' && !servicioGIE.contains(objCase.RF2_ServicioGIE__c)){
            system.debug('SERVICIO'+servicioGIE.contains(objCase.RF2_ServicioGIE__c));
            system.debug('Entró GIE PRIMER IF');
            AVX_ENC_Encuesta__c objEncuesta = new AVX_ENC_Encuesta__c();
            if(!lstPlantillasEncuestasGIE.isempty() && !lstRecordType.isempty())
            {
                objEncuesta.RecordTypeId = lstRecordType.get(0).Id;
                objEncuesta.Plantilla_encuesta__c = lstPlantillasEncuestasGIE.get(0).Id;
                system.debug('Entró GIE');
            }
            
            if (objCase.parentId==null){
                Id recordTypexId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Jurídico').getRecordTypeId();
                System.debug('objCase.AccountId: ' + objCase.AccountId);
                System.debug('objCase.RF2_CorreoElectronicoRespuesta__c: ' + objCase.RF2_CorreoElectronicoRespuesta__c);
                if (objCase.AccountId != null && objCase.RF2_CorreoElectronicoRespuesta__c != null){
                    Account objAcc = [Select id, RecordTypeId from Account where id =: objCase.AccountId];
                    if (objCase.ContactId != null || objAcc.recordtypeId == recordTypexId)
                    {
                        objEncuesta.COM_Cliente__c = objCase.AccountId;
                        objEncuesta.COM_Caso__c = objCase.Id;
                        objEncuesta.RF2_CorreoElectronicoRespuesta__c = objCase.RF2_CorreoElectronicoRespuesta__c;
                        if (objCase.ContactId != null){
                            objEncuesta.COM_Contacto__c = objCase.ContactId;    
                        }
                        listaEncuestas.add(objEncuesta); 
                    }
                }
            }     
        }
        
        System.debug('lsEncuestas ' + listaEncuestas);
                
        String idEncuesta = '';
        if(listaEncuestas!= null && !listaEncuestas.isEmpty()){
            insert listaEncuestas;
            idEncuesta = listaEncuestas[0].id;
        }     
        return idEncuesta;        
    }
}