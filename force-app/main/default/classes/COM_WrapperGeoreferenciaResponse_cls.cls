/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene los datos para la respuesta de la integracion con Georeferenciacion
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_WrapperGeoreferenciaResponse_cls {
	
	public GeoreferenciaResponse Georeferencia_Response { get; set; }
	
	public class System_x
	{
	    public String RequestDate { get; set; }
	    public String ResponseDate { get; set; }
	    public String ResponseCode { get; set; }
	    public String ResponseDesc { get; set; }
	    public String TransactionID { get; set; }
	}
	
	public class Header
	{
	    public System_x System_x { get; set; }
	}
	
	public class Body
	{
	    public String DireccionEstandarizada { get; set; }
	    public String Barrio { get; set; }
	    public String Localidad { get; set; }
	}
	
	public class GeoreferenciaResponse
	{
	    public Header Header { get; set; }
	    public Body Body { get; set; }
	}
	
    
}