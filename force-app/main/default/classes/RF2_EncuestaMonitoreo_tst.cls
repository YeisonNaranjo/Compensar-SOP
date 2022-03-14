/************************************************************************************************
Desarrollado por:  Globant
Autor:             Stifen Panche (SP)
Proyecto:          Compensar
Descripción:       Clase test de Encuesta Monitoreo

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     05/04/2020         Stifen Panche  (SP)     Test de trigger Encuesta Monitoreo.
**************************************************************************************************/
@isTest
public class RF2_EncuestaMonitoreo_tst {

    @istest
    public static void pruebaEncuestaMonitoreo() {
        
        Encuestas_de_Monitoreo__c encuesta = new Encuestas_de_Monitoreo__c();
        
        encuesta.RF2_AcompanamientoInoportuno__c = 'Si';
        encuesta.RF2_AcomOporInter__c = 'Si';
        
        Insert encuesta;
        
    }
    
    

}