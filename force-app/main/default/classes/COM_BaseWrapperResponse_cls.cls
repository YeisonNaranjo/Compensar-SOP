/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase Wrapper que contiene la informacion del Header que es usado en todas las  integraciones, 
*                   por lo tanto los demas Wrapper deben extender (heredar) esta clase
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     28/07/2017      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public virtual class COM_BaseWrapperResponse_cls {

    public class Header{
        public  String      RequestDate         { get; set; }
        public  String      ResponseDate        { get; set; }
        public  String      ResponseCode        { get; set; }
        public  String      ResponseDesc        { get; set; }
        public  String      TransactionID       { get; set; }
    }

}