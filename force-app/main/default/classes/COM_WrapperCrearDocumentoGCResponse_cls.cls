/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Objeto Wrapper con el cual se parsea la respuesta de crecion de documentos en OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    24/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_WrapperCrearDocumentoGCResponse_cls {
	
	public Body Body { get; set; } 
	
	public class System_x
	{
	    public String RequestDate { get; set; }
	    public String ResponseDate { get; set; }
	    public String SystemInvokedService { get; set; }
	    public String TransactionID { get; set; }
	}
	
	public class Header
	{
	    public System_x System_x { get; set; }
	}
	
	public class Result
	{
	    public String DocumentHandle { get; set; }
	}
	
	public class Response
	{
	    public String Code { get; set; }
	    public String Description { get; set; }
	    public String ErrorCode { get; set; }
	    public Result Result { get; set; }
	}
	
	public class Xml
	{
	    public Response Response { get; set; }
	}
	
	public class ExecuteResult
	{
	    public Xml xml { get; set; }
	}
	
	public class ExecuteResponse
	{
	    public ExecuteResult ExecuteResult { get; set; }
	}
	
	public class OnBaseServExecuteRs
	{
	    public ExecuteResponse ExecuteResponse { get; set; }
	}
	
	public class WsDocServExecuteOnBaseRs
	{
	    public Header Header { get; set; }
	    public OnBaseServExecuteRs OnBaseServ_Execute_Rs { get; set; }
	}
	
	public class Body
	{
	    public WsDocServExecuteOnBaseRs WsDocServ_ExecuteOnBase_Rs { get; set; }
	}
	
	public class Envelope
	{
	    public String Header { get; set; }
	    public Body Body { get; set; }
	}
	
	public class RootObject
	{
	    public Envelope Envelope { get; set; }
	}
    
}