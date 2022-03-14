@RestResource(urlMapping='/Prospecto/*')
global class COM_PAF_CrearProspectoSF_ws {
	
	
	public COM_PAF_CrearProspectoSF_ws() {
	}

	/* 
	* Nombre: crearProspecto
    * Descripcion: Metodo encargado de exponer el servicio POST para recibir las transacciones de 
    * 			   creación de prospectos y oportunidades de vinculación
    * Fecha Creación: 01/08/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            01-Ago-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	@HttpPost
	global static COM_WrapperCrearProspectoResponse_cls crearProspecto(COM_WrapperCrearProspectoRequest_cls datosProspecto) {
		COM_WrapperCrearProspectoResponse_cls wprResponse;
		COM_LogicaCrearProspectoSF_cls objLogicaCrearProspectoSF;
		
		system.debug('========>>>>>> ' + datosProspecto);
		
		try{
			objLogicaCrearProspectoSF = new COM_LogicaCrearProspectoSF_cls();
			wprResponse = objLogicaCrearProspectoSF.crearProspecto(datosProspecto);
		} catch(Exception e){
			wprResponse = new COM_WrapperCrearProspectoResponse_cls();
			wprResponse.RespuestaProspecto.codigoRespuesta = 400;
			wprResponse.RespuestaProspecto.mensajeRespuesta = label.COM_Msj_Error_Generico_Crear_Prospecto + ', ' + e.getMessage();
			wprResponse.RespuestaProspecto.fecha = DateTime.now();
			wprResponse.RespuestaProspecto.idCliente = null;
			wprResponse.RespuestaProspecto.idOportunidad = null;
		}
		
		return wprResponse;
	}

}