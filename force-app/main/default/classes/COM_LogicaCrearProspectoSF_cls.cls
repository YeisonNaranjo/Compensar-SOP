/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase que va a contener toda la logica para la creacion de prospecto
* 					y oportunidades de vinculación en SFDC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    01/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_LogicaCrearProspectoSF_cls {
	
	/* 
	* Nombre: crearProspecto
    * Descripcion: Metodo encargado procesar las transacciones para la creacion de prospectos y oportunidades de viculación
    * Fecha Creación: 01/08/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            01-Ago-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public COM_WrapperCrearProspectoResponse_cls crearProspecto(COM_WrapperCrearProspectoRequest_cls datosProspecto){
		COM_WrapperCrearProspectoResponse_cls objWrapperCrearProspectoResponse;
		
		objWrapperCrearProspectoResponse = new COM_WrapperCrearProspectoResponse_cls();
		
		objWrapperCrearProspectoResponse.RespuestaProspecto.codigoRespuesta = 200;
		objWrapperCrearProspectoResponse.RespuestaProspecto.mensajeRespuesta = 'Respuesta Mock';
		objWrapperCrearProspectoResponse.RespuestaProspecto.fecha = DateTime.now();
		objWrapperCrearProspectoResponse.RespuestaProspecto.idCliente = '0010q000005LI5Y';
		objWrapperCrearProspectoResponse.RespuestaProspecto.idOportunidad = '0060q000002ERSu';
		
		
		return objWrapperCrearProspectoResponse;
	}
    
}