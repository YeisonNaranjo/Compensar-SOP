/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene los datos para la respuesta de la integracion de Vinculación de Clientes en GC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    03/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_WrapperVinculacionClienteRespons_cls {
	
	public CustomerAdminProcesarVinculacionResponse CustomerAdmin_ProcesarVinculacion_Response { get; set; }

	public class ProcesarVinculacionResponse
	{
		public string resultadoOperacion { get; set; }
		public string resultadoMensaje { get; set; }
	}

	public class Body
	{
		public ProcesarVinculacionResponse ProcesarVinculacionResponse { get; set; }
	}

	public class CustomerAdminProcesarVinculacionResponse extends COM_BaseWrapperResponse_cls
	{
		public Header Header {get;set;}
		public Body Body { get; set; }
	}

    
}