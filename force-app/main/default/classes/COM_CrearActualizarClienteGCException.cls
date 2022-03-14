/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase de Excepcion para los procesos de creacion y actualizacion de clientes en GC                  
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     12/09/2017      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/
                
public with sharing class COM_CrearActualizarClienteGCException extends Exception {
    public String strprueba {get; set;}
}