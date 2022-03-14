@isTest
private class COM_WrapperConsultaClienteGCResponse_tst {
	
	@isTest static void test_method_one() {
		// Implement test code
		COM_WrapperConsultaClienteGCResponse_cls pp = new COM_WrapperConsultaClienteGCResponse_cls();
		system.debug(pp.CustomerMng_ConsultaCliente_Response);
		COM_WrapperConsultaClienteGCResponse_cls.CustomerMng_ConsultaCliente_Response rs = new COM_WrapperConsultaClienteGCResponse_cls.CustomerMng_ConsultaCliente_Response();
		system.debug(rs.Header);
		system.debug(rs.Body);
		system.debug(rs.Header);

		COM_WrapperConsultaClienteGCResponse_cls.Body bd = new COM_WrapperConsultaClienteGCResponse_cls.Body();
		//COM_WrapperConsultaClienteGCResponse_cls.CustomerMng_ConsultaCliente_Response.Header he = new COM_WrapperConsultaClienteGCResponse_cls.CustomerMng_ConsultaCliente_Response.Header();
		system.debug(bd.cliente);
		system.debug(bd.atributosComunes);
		system.debug(bd.vinculacion);

		COM_WrapperConsultaClienteGCResponse_cls.Vinculacion vinculacion = new COM_WrapperConsultaClienteGCResponse_cls.Vinculacion();
		system.debug(vinculacion.AfiliadoCaja);
		system.debug(vinculacion.AfiliacionConResponsable);
		system.debug(vinculacion.AfiliadoSalud);
		system.debug(vinculacion.AfiliadoPLC);

		COM_WrapperConsultaClienteGCResponse_cls.Demografia demografia = new COM_WrapperConsultaClienteGCResponse_cls.Demografia();
		system.debug(demografia.nacimientoFecha);
		system.debug(demografia.genero);
		system.debug(demografia.estadoCivil);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion mi = new COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion();
		system.debug(mi.id);

		COM_WrapperConsultaClienteGCResponse_cls.DatosPersona2 dp2 = new COM_WrapperConsultaClienteGCResponse_cls.DatosPersona2();
		system.debug(dp2.nombrePrimero);
		system.debug(dp2.nombreSegundo);
		system.debug(dp2.apellidoPrimero);
		system.debug(dp2.apellidoSegundo);
		system.debug(dp2.nombre);
		system.debug(dp2.nuip);
		system.debug(dp2.demografia);
		system.debug(dp2.motivoInactivacion);

		COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable2 cr2 = new COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable2();
		system.debug(cr2.tipoResponsable);
		system.debug(cr2.legalID);
		system.debug(cr2.nombre);

		COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable cr = new COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable();
		system.debug(cr.clienteResponsable);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoRetiroOpcional mro = new COM_WrapperConsultaClienteGCResponse_cls.MotivoRetiroOpcional();
		system.debug(mro.id);
		system.debug(mro.nombre);

		COM_WrapperConsultaClienteGCResponse_cls.Programa2 p2 = new COM_WrapperConsultaClienteGCResponse_cls.Programa2(); 	
		system.debug(p2.diasPaHisto);
		system.debug(p2.tipoRadicacion);
		system.debug(p2.edadReAuto);
		system.debug(p2.genNuevoRadicadoEstado);
		system.debug(p2.grupo);
		system.debug(p2.id);
		system.debug(p2.programaPadre);
		system.debug(p2.indicadorProgramaEstado);
		system.debug(p2.indicadorVinculacionEstado);
		system.debug(p2.manejaResponsable1PersonaEstado);
		system.debug(p2.manejaResponsable2EmpresaEstado);
		system.debug(p2.motivoRetiroOpcional);
		system.debug(p2.clientePropietarioID);
		system.debug(p2.tipoParentesco);
		system.debug(p2.sigla);
		system.debug(p2.nombrePrograma);
		system.debug(p2.diasParaReactivacion);

		COM_WrapperConsultaClienteGCResponse_cls.Programa p = new COM_WrapperConsultaClienteGCResponse_cls.Programa();
		system.debug(p.programa);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion2 mi2 = new COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion2();
		system.debug(mi2.id);


		COM_WrapperConsultaClienteGCResponse_cls.Afiliacion2 a2 = new COM_WrapperConsultaClienteGCResponse_cls.Afiliacion2();
		system.debug(a2.cantidadVinculacion);
		system.debug(a2.categoriaAfiliacion);
		system.debug(a2.ClienteResponsable);
		system.debug(a2.cmnt);
		system.debug(a2.actualizadoEstado);
		system.debug(a2.nuevoEstado);
		system.debug(a2.estado);
		system.debug(a2.finFecha);
		system.debug(a2.inicioFecha);
		system.debug(a2.ingresoEmpresaFecha);
		system.debug(a2.retiroFecha);
		system.debug(a2.valorVinculacion);
		system.debug(a2.variableRetiro);
		system.debug(a2.Programa);
		system.debug(a2.id);
		system.debug(a2.motivoInactivacion);
		system.debug(a2.estadoAfiliacion);

		COM_WrapperConsultaClienteGCResponse_cls.Afiliacion af = new COM_WrapperConsultaClienteGCResponse_cls.Afiliacion();
		system.debug(af.afiliacion);

		COM_WrapperConsultaClienteGCResponse_cls.Familiar fr = new COM_WrapperConsultaClienteGCResponse_cls.Familiar();
		system.debug(fr.legalID);
		system.debug(fr.tipoIdentificacion);
		system.debug(fr.id);
		system.debug(fr.datosPersona);
		system.debug(fr.Sucursal);
		system.debug(fr.comunicacionesCliente);
		system.debug(fr.Contacto);
		system.debug(fr.Afiliacion);
		system.debug(fr.Radicacion);

		COM_WrapperConsultaClienteGCResponse_cls.Familia2 f2 = new COM_WrapperConsultaClienteGCResponse_cls.Familia2();
		system.debug(f2.tipoParentesco);
		system.debug(f2.familiar);

		COM_WrapperConsultaClienteGCResponse_cls.Familia f = new COM_WrapperConsultaClienteGCResponse_cls.Familia();
		system.debug(f.familia);

		COM_WrapperConsultaClienteGCResponse_cls.Demografia2 d2 = new COM_WrapperConsultaClienteGCResponse_cls.Demografia2();
		system.debug(d2.nacimientoFecha);
		system.debug(d2.nacimientoLugar);
		system.debug(d2.genero);
		system.debug(d2.estadoCivil);
		system.debug(d2.gradoEscolaridad);
		system.debug(d2.TitulosObtenidos);
		system.debug(d2.OficiosProfesiones);
		system.debug(d2.OtrosEstudios);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion3 mi3 = new COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion3();
		system.debug(mi3.id);


		COM_WrapperConsultaClienteGCResponse_cls.DatosPersona dp = new COM_WrapperConsultaClienteGCResponse_cls.DatosPersona();
		system.debug(dp.nombrePrimero);
		system.debug(dp.nombreSegundo);
		system.debug(dp.apellidoPrimero);
		system.debug(dp.apellidoSegundo);
		system.debug(dp.nombre);
		system.debug(dp.foneticoID);
		system.debug(dp.nuip);
		system.debug(dp.Familia);
		system.debug(dp.demografia);
		system.debug(dp.categoriaAfiliacion);
		system.debug(dp.estadoAfiliacion);
		system.debug(dp.motivoInactivacion);

		COM_WrapperConsultaClienteGCResponse_cls.Sucursal2 s2 = new COM_WrapperConsultaClienteGCResponse_cls.Sucursal2();
		system.debug(s2.id);
		system.debug(s2.sucursalID);
		system.debug(s2.nivelAdicional);
		system.debug(s2.razonSocial);
		system.debug(s2.mantenimiento);
		system.debug(s2.centroCostosID);

		COM_WrapperConsultaClienteGCResponse_cls.Sucursal sc = new COM_WrapperConsultaClienteGCResponse_cls.Sucursal();
		system.debug(sc.sucursal);

		COM_WrapperConsultaClienteGCResponse_cls.TelefonoComunicacion tc = new COM_WrapperConsultaClienteGCResponse_cls.TelefonoComunicacion();
		system.debug(tc.tipoTelefono);
		system.debug(tc.telefono);
		system.debug(tc.extensionTelefono);		

		COM_WrapperConsultaClienteGCResponse_cls.Telefonos tfls = new COM_WrapperConsultaClienteGCResponse_cls.Telefonos();
		system.debug(tfls.telefonoComunicacion);

		COM_WrapperConsultaClienteGCResponse_cls.Departamento dpx = new COM_WrapperConsultaClienteGCResponse_cls.Departamento();
		system.debug(dpx.id);

		COM_WrapperConsultaClienteGCResponse_cls.Municipio mun = new COM_WrapperConsultaClienteGCResponse_cls.Municipio();
		system.debug(mun.id);
		system.debug(mun.nombre);
		system.debug(mun.departamento);		

		COM_WrapperConsultaClienteGCResponse_cls.Localidad lc = new COM_WrapperConsultaClienteGCResponse_cls.Localidad();
		system.debug(lc.id);
		system.debug(lc.municipio);
		system.debug(lc.nombre);		

		COM_WrapperConsultaClienteGCResponse_cls.DomicilioComunicacion dm = new COM_WrapperConsultaClienteGCResponse_cls.DomicilioComunicacion();
		system.debug(dm.barrio);
		system.debug(dm.tipoDomicilio);
		system.debug(dm.domicilio);
		system.debug(dm.codigoPostal);
		system.debug(dm.localidad);
		system.debug(dm.tipoAreaGeografica);

		COM_WrapperConsultaClienteGCResponse_cls.Domicilios dms = new COM_WrapperConsultaClienteGCResponse_cls.Domicilios();
		system.debug(dms.domicilioComunicacion);

		COM_WrapperConsultaClienteGCResponse_cls.CorreosElectronicos ces = new COM_WrapperConsultaClienteGCResponse_cls.CorreosElectronicos();
		system.debug(ces.correoElectronico);


		COM_WrapperConsultaClienteGCResponse_cls.Celulares clrs = new COM_WrapperConsultaClienteGCResponse_cls.Celulares();
		system.debug(clrs.celular);

		COM_WrapperConsultaClienteGCResponse_cls.AdicionalesContacto adc = new COM_WrapperConsultaClienteGCResponse_cls.AdicionalesContacto();
		system.debug(adc.borradoEstado);
		system.debug(adc.creacionFecha);
		system.debug(adc.ultimaNovedadFecha);
		system.debug(adc.identificador);
		system.debug(adc.orden);
		system.debug(adc.zonaBogota);

		COM_WrapperConsultaClienteGCResponse_cls.ComunicacionCliente ccs = new COM_WrapperConsultaClienteGCResponse_cls.ComunicacionCliente();
		system.debug(ccs.telefonos);
		system.debug(ccs.domicilios);
		system.debug(ccs.correosElectronicos);
		system.debug(ccs.celulares);
		system.debug(ccs.redesSociales);
		system.debug(ccs.opTinEmail);
		system.debug(ccs.opTinSMS);
		system.debug(ccs.adicionalesContacto);

		COM_WrapperConsultaClienteGCResponse_cls.ComunicacionesCliente cccs = new COM_WrapperConsultaClienteGCResponse_cls.ComunicacionesCliente();
		system.debug(cccs.comunicacionCliente);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoRetiro mr = new COM_WrapperConsultaClienteGCResponse_cls.MotivoRetiro();
		system.debug(mr.id);
		system.debug(mr.nombre);

		COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable4 cr4 = new COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable4();
		system.debug(cr4.tipoResponsable);
		system.debug(cr4.id);
		system.debug(cr4.nombre);
		system.debug(cr4.legalID);
		system.debug(cr4.tipoIdentificacion);
		system.debug(cr4.centroCostosID);
		system.debug(cr4.sucursalID);

		COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable3 cr3 = new COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable3();
		system.debug(cr3.clienteResponsable);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoRetiroOpcional2 mrp2 = new COM_WrapperConsultaClienteGCResponse_cls.MotivoRetiroOpcional2();
		system.debug(mrp2.id);
		system.debug(mrp2.nombre);


		COM_WrapperConsultaClienteGCResponse_cls.Programa4 pgr4 = new COM_WrapperConsultaClienteGCResponse_cls.Programa4();
		system.debug(pgr4.condicion);
		system.debug(pgr4.diasPaHisto);
		system.debug(pgr4.tipoRadicacion);
		system.debug(pgr4.edadReAuto);
		system.debug(pgr4.genNuevoRadicadoEstado);
		system.debug(pgr4.grupo);
		system.debug(pgr4.id);
		system.debug(pgr4.programaPadre);
		system.debug(pgr4.indicadorProgramaEstado);
		system.debug(pgr4.indicadorVinculacionEstado);
		system.debug(pgr4.manejaResponsable1PersonaEstado);
		system.debug(pgr4.manejaResponsable2EmpresaEstado);
		system.debug(pgr4.motivoRetiroOpcional);
		system.debug(pgr4.clientePropietarioID);
		system.debug(pgr4.tipoParentesco);
		system.debug(pgr4.sigla);
		system.debug(pgr4.tipoIdClientePropietario);
		system.debug(pgr4.nombrePrograma);
		system.debug(pgr4.nombreProgramaPadre);
		system.debug(pgr4.diasParaReactivacion);

		COM_WrapperConsultaClienteGCResponse_cls.Programa3 pgr3 = new COM_WrapperConsultaClienteGCResponse_cls.Programa3();
		system.debug(pgr3.programa);

		COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion4 mi4 = new COM_WrapperConsultaClienteGCResponse_cls.MotivoInactivacion4();
		system.debug(mi4.id);


		COM_WrapperConsultaClienteGCResponse_cls.Afiliacion4 af4 = new COM_WrapperConsultaClienteGCResponse_cls.Afiliacion4();
		system.debug(af4.beneficiarios);
		system.debug(af4.cantidadVinculacion);
		system.debug(af4.categoriaAfiliacion);
		system.debug(af4.motivoRetiro);
		system.debug(af4.ClienteResponsable);
		system.debug(af4.cmnt);
		system.debug(af4.actualizadoEstado);
		system.debug(af4.nuevoEstado);
		system.debug(af4.estado);
		system.debug(af4.finFecha);
		system.debug(af4.ingresoEmpresaFecha);
		system.debug(af4.inicioFecha);
		system.debug(af4.retiroFecha);
		system.debug(af4.soloServicio);
		system.debug(af4.textoVinculacion);
		system.debug(af4.valorVinculacion);
		system.debug(af4.variableRetiro);
		system.debug(af4.Programa);
		system.debug(af4.id);
		system.debug(af4.motivoInactivacion);
		system.debug(af4.estadoAfiliacion);
		system.debug(af4.clienteID);

		COM_WrapperConsultaClienteGCResponse_cls.Afiliacion3 af3 = new COM_WrapperConsultaClienteGCResponse_cls.Afiliacion3();
		system.debug(af3.afiliacion);

		COM_WrapperConsultaClienteGCResponse_cls.DatosEmpresa de = new COM_WrapperConsultaClienteGCResponse_cls.DatosEmpresa();
		system.debug(de.digitoVerificadorLegal);
		system.debug(de.razonSocial);
		system.debug(de.nombreComercial);
		system.debug(de.estadoAfiliacion);
		system.debug(de.motivoInactivacion);


		COM_WrapperConsultaClienteGCResponse_cls.DatosRepresentanteLegal drl = new COM_WrapperConsultaClienteGCResponse_cls.DatosRepresentanteLegal();
		system.debug(drl.TipoIdentificacion);
		system.debug(drl.NumeroIdentificacion);
		system.debug(drl.Id);
		system.debug(drl.nombrePrimero);
		system.debug(drl.nombreSegundo);
		system.debug(drl.apellidoPrimero);
		system.debug(drl.apellidoSegundo);
		system.debug(drl.nombre);
		system.debug(drl.foneticoID);
		system.debug(drl.nuip);
		system.debug(drl.demografia);	
		

		COM_WrapperConsultaClienteGCResponse_cls.Demografia3 dm3 = new COM_WrapperConsultaClienteGCResponse_cls.Demografia3();
		system.debug(dm3.nacimientoFecha);
		system.debug(dm3.genero);
		system.debug(dm3.estadoCivil);
		system.debug(dm3.TitulosObtenidos);
		system.debug(dm3.OficiosProfesiones);
		system.debug(dm3.OtrosEstudios);		


		COM_WrapperConsultaClienteGCResponse_cls.Cliente cl = new COM_WrapperConsultaClienteGCResponse_cls.Cliente();
		system.debug(cl.TipoIdentificacion);
		system.debug(cl.NumeroIdentificacion);
		system.debug(cl.Id);
		system.debug(cl.datosPersona);
		system.debug(cl.Sucursal);
		system.debug(cl.comunicacionesCliente);
		system.debug(cl.Contacto);
		system.debug(cl.Afiliacion);
		system.debug(cl.Radicacion);
		system.debug(cl.datosEmpresa);
		system.debug(cl.datosRepresentanteLegal);			


		COM_WrapperConsultaClienteGCResponse_cls.AtributosComunes atc = new COM_WrapperConsultaClienteGCResponse_cls.AtributosComunes();
		system.debug(atc.fidelizacionFecha);
		system.debug(atc.beneficiarioEstado);
		system.debug(atc.empresaEstado);
		system.debug(atc.saltarFoneticoEstado);
		system.debug(atc.indice);
		system.debug(atc.edadMayor);		
	}

	@isTest static void test_method_two() {
		// Implement test code
	}
	
}