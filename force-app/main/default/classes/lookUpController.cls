/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Crontoller para crear consultas dinamicas para componente de lookup
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     30/10/19         Manuel Mendez  (MM)                    Creación Clase.
*************************************************************************************************/ 
public class lookUpController 
{
    
    @AuraEnabled
    public static List<SObject> obtenerQuery(String strObjeto,String strFiltro, String strSearchKeyWord) {
        System.debug('ENTRO A obtenerQuery---->>>>');
        System.debug('strObjeto---->>>>'+strObjeto);
        // System.debug('lstValores---->>>>'+lstValores);
        System.debug('strFiltro---->>>>'+strFiltro);
        System.debug('strSearchKeyWord---->>>>'+strSearchKeyWord);
        String  strQuery    =   'SELECT Id, Name ';
                strQuery    +=  'FROM ' + strObjeto;

        if (!String.isBlank(strFiltro) && !String.isBlank(strSearchKeyWord)) {

            strQuery    +=  ' WHERE '+strFiltro + ' AND';
            strQuery    += ' Name LIKE'+ '\'' + '%' + strSearchKeyWord + '%' + '\'';
        }

       if (String.isBlank(strFiltro) && !String.isBlank(strSearchKeyWord)) {
            strQuery += ' WHERE Name LIKE'+ '\'' + '%' + strSearchKeyWord + '%' + '\'';
        }

        if ((!String.isBlank(strFiltro) && strFiltro !='undefined=undefined') && String.isBlank(strSearchKeyWord)) {
            strQuery    +=  ' WHERE '+strFiltro;
            
        }
        
        System.debug('strQuery8--->>>'+strQuery);

        List<SObject> lstLupas = Database.query(strQuery);
        System.debug('lstLupas--->>>'+lstLupas);

        return lstLupas;
    }

}