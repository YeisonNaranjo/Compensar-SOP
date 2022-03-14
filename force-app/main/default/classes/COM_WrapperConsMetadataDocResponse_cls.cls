/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Objeto Wrapper con el cual se parsea la respuesta de consulta de metadata de documentos en OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    24/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_WrapperConsMetadataDocResponse_cls {
	
	public Body Body { get; set; }
	
	public class Attributtes
	{
		public string name { get; set; }
		public string id { get; set; }
	}

	public class DocumentType_x
	{
		public string value { get; set; }
		public Attributtes attributtes { get; set; }
	}

	public class Document_x
	{
		public String value { get; set; }
		public Attributtes attributtes { get; set; }
	}

	public class Document
	{
		public string DateStored { get; set; }
		public DocumentType_x DocumentType_x { get; set; }
		public string LatestRevision { get; set; }
		public List<Document_x> Document_x { get; set; }
	}

	public class Result
	{
		public List<Document> Document { get; set; }
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

	public class System_x
	{
		public string TransactionID { get; set; }
		public string SystemInvokedService { get; set; }
		public DateTime ResponseDate { get; set; }
		public DateTime RequestDate { get; set; }
	}

	public class Header
	{
		public System_x System_x { get; set; }
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