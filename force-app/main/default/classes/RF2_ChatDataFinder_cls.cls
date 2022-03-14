/***************************************************************************************************************
* Avanxo 
* @author           William Aldana
* Proyecto:         CRM Rhino
* Descripción:      Clase que obtiene la informacion del Chat dinamicamente
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    05/01/2018      William Aldana                      Creación de la clase
****************************************************************************************************************/
global class RF2_ChatDataFinder_cls {
    public String strOpciones {get;set;}
    public RF2_ChatDataFinder_cls() {
        strOpciones = '';
        List<RF2_ConfiguracionBotonesChat__mdt> configs = [Select RF2_IdBotonValue__c, RF2_EtiquetaNombreBoton__c From RF2_ConfiguracionBotonesChat__mdt order by RF2_EtiquetaNombreBoton__c asc];
        //return 'butId1|butLabel1;butId2|butLabel2;';
        for (RF2_ConfiguracionBotonesChat__mdt obj : configs)
        {
            //result = result + obj.RF2_IdBotonValue__c + '|' + obj.RF2_EtiquetaNombreBoton__c + ';';
            strOpciones = strOpciones + '<option value="' + obj.RF2_IdBotonValue__c + '">' + obj.RF2_EtiquetaNombreBoton__c + '</option>';
        }
    }
}