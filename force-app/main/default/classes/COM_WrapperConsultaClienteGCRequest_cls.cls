/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Objeto Wrapper el cual contiene los datos con la solicitud para la consulta de cliente en GC
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-28      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public with sharing class COM_WrapperConsultaClienteGCRequest_cls {
    public CustomerMng_ConsultaCliente_Request CustomerMng_ConsultaCliente_Request { get; set; }

    public class CustomerMng_ConsultaCliente_Request extends COM_BaseWrapper_cls{
        public  Header      Header                  {get;set;}
        public  Body        Body                    {get;set;}
    }

    public class Body{
        public  Cliente     Cliente                 {get;set;}
    }

    public class Cliente{
        public  Integer     TipoIdentificacion		{get; set;}
        public 	Long 		NumeroIdentificacion 	{get; set;}
        public 	Long		Id						{get; set;}
        public 	Integer 	TipoIdResponsable		{get; set;}
        public 	Long 	 	NumeroIdResponsable		{get; set;}
        public 	Integer 	OpcionConsulta          {get; set;}
    }
}