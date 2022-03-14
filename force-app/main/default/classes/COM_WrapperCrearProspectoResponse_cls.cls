/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene los datos para la respuesta de la integracion de Crear Prospecto
* 					y Oportunidades de Vinculación en SFDC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    01/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
global class COM_WrapperCrearProspectoResponse_cls {
	
	public RespuestaProspecto RespuestaProspecto { get; set; }

	public class RespuestaProspecto
	{
	    public Integer codigoRespuesta { get; set; }
	    public String mensajeRespuesta { get; set; }
	    public DateTime fecha { get; set; }
	    public String idCliente { get; set; }
	    public String idOportunidad { get; set; }
	}
    
}