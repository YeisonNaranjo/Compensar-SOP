/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Objeto Wrapper el cual contiene los datos de respuesta para la integracion de creacion de cliente en Gestion de Clientes
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-31      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public with sharing class COM_WrapperCrearClienteGCResponse_cls {
    public CustomerMng_CrearClienteResponse CustomerMng_CrearClienteResponse { get; set; }

    public class CustomerMng_CrearClienteResponse extends COM_BaseWrapperResponse_cls{
        public  Header      header                  {get;set;}
        public  Body        Body                    {get;set;}
        
    }

    public class Body{
        public  Cliente     Cliente                 {get;set;}
    }

    public class Cliente{
        public string       TipoIdentificacion      { get; set; }
        public string       NumeroIdentificacion    { get; set; }
        public string       IdCliente               { get; set; }
    }
}