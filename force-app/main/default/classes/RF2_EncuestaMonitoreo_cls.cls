/************************************************************************************************
Desarrollado por:  Globant
Autor:             Stifen Panche (SP)
Proyecto:          Compensar
Descripción:       Trigger del objeto Encuestas de Monitoreo

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     02/04/2020         Stifen Panche  (SP)     					Creación Trigger.
	2.0     22/10/2021         Alvaro Gomez (alvaro.gomez@globant.com) 	Ajuste para nuevo formato de encuestas 
**************************************************************************************************/
public class RF2_EncuestaMonitoreo_cls {
    
    public static void calcularNotasFinales(List<Encuestas_de_Monitoreo__c> lstNew)
    {
        String ID_new_enc = [Select id from recordType where DeveloperName = 'Encuestas_de_Monitoreo_New'].id;
            for(Encuestas_de_Monitoreo__c encuesta : lstNew )
        {   
            if (encuesta.RecordTypeId ==ID_new_enc){
                encuesta.Nota_Final__c = (encuesta.Nota_Final_Critico_new__c*0.6) + (encuesta.RF2_Nota_Final_No_Critico_new__c*0.4);    
            }else {
            	encuesta.Nota_Final__c = (encuesta.RF2_Nota_Final_Cr_tico__c*0.6) + (encuesta.RF2_Nota_Final_No_Cr_tico__c*0.4);    
            }
            
        }
        
    }

}