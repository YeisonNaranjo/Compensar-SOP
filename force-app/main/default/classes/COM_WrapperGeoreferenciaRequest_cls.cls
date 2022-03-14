/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene los datos para la integracion con Georeferenciacion
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    26/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_WrapperGeoreferenciaRequest_cls {
	
	public Georeferencia_Request Georeferencia_Request { get; set; }
	
	public class Georeferencia_Request extends COM_BaseWrapper_cls{
		public Header Header { get; set; }
	    public Body Body { get; set; }
	}
	
	public class Body{ 
		public String Direccion { get; set; }
		public Integer Municipio { get; set; }
	}
    
}