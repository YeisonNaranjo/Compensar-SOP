/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Objeto Wrapper con el cual se parsea la respuesta de consulta de bianrio de documentos en OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    30/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_WrapperConsBinarioDocResponse_cls {
	
	public Body Body { get; set; } 
	
	public class Page_x
	{
	    public string Page_x { get; set; }
	    public string extension { get; set; }
	}
	
	public class Pages
	{
	    public Page_x Page_x { get; set; }
	}
	
	public class DocumentType
	{
	    public string DocumentType { get; set; }
	    public string id { get; set; }
	}
	
	public class Document
	{
	    public string name { get; set; }
	    public string id { get; set; }
	    public Pages Pages { get; set; }
	    public string DateStored { get; set; }
	    public DocumentType DocumentType { get; set; }
	    public string LatestRevision { get; set; }
	    public string QueryError { get; set; }
	}
	
	public class Result
	{
	    public Document Document { get; set; }
	}
	
	public class Response
	{
	    public Result Result { get; set; }
	    public string Code { get; set; }
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
	
	public class SystemX
	{
	    public string TransactionID { get; set; }
	    public string SystemInvokedService { get; set; }
	    public string ResponseDate { get; set; }
	    public string RequestDate { get; set; }
	}
	
	public class Header
	{
	    public SystemX System_x { get; set; }
	}
	
	public class WsDocServExecuteOnBaseRs
	{
	    public OnBaseServExecuteRs OnBaseServ_Execute_Rs { get; set; }
	    public Header Header { get; set; }
	}
	
	public class Body
	{
	    public WsDocServExecuteOnBaseRs WsDocServ_ExecuteOnBase_Rs { get; set; }
	}
	
	public class RootObject
	{
	    public Body Body { get; set; }
	}
    
}