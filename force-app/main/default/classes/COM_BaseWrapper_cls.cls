/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene la informacion del Header que es usado en todas las 
* 					integraciones, por lo tanto los demas Wrapper deben extender (heredar) esta clase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    26/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public virtual class COM_BaseWrapper_cls {
	
	public class SecurityHeader{
	    public string User { get; set; }
	    public string Password { get; set; }
	}
	
	public class System_x{
	    public string InputSystem { get; set; }
	    public string ApplicationID { get; set; }
	    public string TransactionID { get; set; }
	    public string IPAddress { get; set; } 
	}
	
	public class Header{
	    public SecurityHeader SecurityHeader { get; set; }
	    public System_x System_x { get; set; }
	}
    
}