/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Wrapper del response para la creación de casos en SF desde OnBase
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-07      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

global class RF2_WrapperCrearCasosSFResponse_cls{
        public  Integer         codigoRespuesta             {get; set;}
        public  String          mensajeRespuesta            {get; set;}
        public  Datetime        fechaTransaccion            {get; set;}
        public  String          numeroConsecutivoCRM         {get; set;}
}