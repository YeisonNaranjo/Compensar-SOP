@isTest
private class COM_PVE_CrearActrOppSF_ws_tst {
	
	@isTest static void test_method_one() {
		COM_PVE_CrearActualizarOpportunidadSF_ws ppp = new COM_PVE_CrearActualizarOpportunidadSF_ws();
		COM_PVE_CrearActualizarOpportunidadSF_ws.ProcesarRequest(new COM_PVE_CrearActualizarOpportunidadSF_ws.WrapperRequestCliente());

		COM_PVE_CrearActualizarOpportunidadSF_ws.TipoDomicilio td = new COM_PVE_CrearActualizarOpportunidadSF_ws.TipoDomicilio();
		System.debug(td.id);
		System.debug(td.nombre);
		COM_PVE_CrearActualizarOpportunidadSF_ws.CorreosElectronicos ce = new COM_PVE_CrearActualizarOpportunidadSF_ws.CorreosElectronicos();
		System.debug(ce.correoElectronico);

		COM_PVE_CrearActualizarOpportunidadSF_ws.TipoContacto tc = new COM_PVE_CrearActualizarOpportunidadSF_ws.TipoContacto();
		System.debug(tc.id); 
		System.debug(tc.nombre);

		COM_PVE_CrearActualizarOpportunidadSF_ws.DatosPersonales dp = new COM_PVE_CrearActualizarOpportunidadSF_ws.DatosPersonales();
		System.debug(dp.nombrePrimero);
		System.debug(dp.nombreSegundo);
		System.debug(dp.apellidoPrimero);
		System.debug(dp.apellidoSegundo);
		System.debug(dp.nombre);

		COM_PVE_CrearActualizarOpportunidadSF_ws.Aplicacion ap = new COM_PVE_CrearActualizarOpportunidadSF_ws.Aplicacion();
		System.debug(ap.id);
		System.debug(ap.codigo);
		System.debug(ap.nombre);


		COM_PVE_CrearActualizarOpportunidadSF_ws.CanalVenta cv = new COM_PVE_CrearActualizarOpportunidadSF_ws.CanalVenta();
		System.debug(cv.id);
		System.debug(cv.nombre);


		COM_PVE_CrearActualizarOpportunidadSF_ws.TipoIdentificacion tid = new COM_PVE_CrearActualizarOpportunidadSF_ws.TipoIdentificacion();
		System.debug(tid.id);

		COM_PVE_CrearActualizarOpportunidadSF_ws.Cliente cl = new COM_PVE_CrearActualizarOpportunidadSF_ws.Cliente();
		System.debug(cl.legalID);
		System.debug(cl.id); 
		System.debug(cl.tipoIdentificacion);

		COM_PVE_CrearActualizarOpportunidadSF_ws.CotizacionCliente ccl = new COM_PVE_CrearActualizarOpportunidadSF_ws.CotizacionCliente();
		System.debug(ccl.Cliente);

		COM_PVE_CrearActualizarOpportunidadSF_ws.CotizacionClienteOportunidadVenta ccov = new COM_PVE_CrearActualizarOpportunidadSF_ws.CotizacionClienteOportunidadVenta();
		System.debug(ccov.cotizacionCliente);

		COM_PVE_CrearActualizarOpportunidadSF_ws.Clientes cls = new COM_PVE_CrearActualizarOpportunidadSF_ws.Clientes();
		System.debug(cls.cotizacionClienteOportunidadVenta);


		COM_PVE_CrearActualizarOpportunidadSF_ws.ProductoServicio ps = new COM_PVE_CrearActualizarOpportunidadSF_ws.ProductoServicio();
		System.debug(ps.id);
		System.debug(ps.nombre);


		COM_PVE_CrearActualizarOpportunidadSF_ws.ProductoServicioCotizado psc = new COM_PVE_CrearActualizarOpportunidadSF_ws.ProductoServicioCotizado();
		System.debug(psc.observaciones);
		System.debug(psc.productoServicio);


		COM_PVE_CrearActualizarOpportunidadSF_ws.ProductosServiciosCotizados pc = new COM_PVE_CrearActualizarOpportunidadSF_ws.ProductosServiciosCotizados();
		System.debug(pc.productoServicioCotizado);

		COM_PVE_CrearActualizarOpportunidadSF_ws.WrapperRequestCliente wrc = new COM_PVE_CrearActualizarOpportunidadSF_ws.WrapperRequestCliente();
		System.debug(wrc.id);
		System.debug(wrc.nombre);
		System.debug(wrc.numeroAdultos);
		System.debug(wrc.numeroNinos);
		System.debug(wrc.observaciones);
		System.debug(wrc.TipoDomicilio);
		System.debug(wrc.CorreosElectronicos);
		System.debug(wrc.TipoContacto);
		System.debug(wrc.DatosPersonales);
		System.debug(wrc.Aplicacion);
		System.debug(wrc.CanalVenta);
		System.debug(wrc.Clientes);
		System.debug(wrc.productosServiciosCotizados);


		COM_PVE_CrearActualizarOpportunidadSF_ws.RespuestaOportunidad ro = new COM_PVE_CrearActualizarOpportunidadSF_ws.RespuestaOportunidad();
		System.debug(ro.codOportunidad);
		System.debug(ro.codigoRespuesta);
		System.debug(ro.mensajeRespuesta);
		System.debug(ro.fecha);


		COM_PVE_CrearActualizarOpportunidadSF_ws.WrapperResponseCliente wrcx = new COM_PVE_CrearActualizarOpportunidadSF_ws.WrapperResponseCliente('a','b','c'); 

	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}