@isTest
private class COM_WrapperCrearActualizarClienteSF_tst {
	
	@isTest static void test_method_1() {
		COM_WrapperCrearActualizarClienteSF_cls pp = new COM_WrapperCrearActualizarClienteSF_cls();
		system.debug(pp.tipoIdentificacion);
		system.debug(pp.numeroIdentificacion); 
		system.debug(pp.id);                    
		system.debug(pp.datosEmpresa);           
		system.debug(pp.datosPersona);           
		system.debug(pp.comunicaciones);       
		system.debug(pp.datosRepresentanteLegal); 
		system.debug(pp.requisitos);            
		system.debug(pp.ds);                      
		system.debug(pp.sucursal);
	}
	
	@isTest static void test_method_2() {
		COM_WrapperCrearActualizarClienteSF_cls.Sucursal suc = new  COM_WrapperCrearActualizarClienteSF_cls.Sucursal(); 
		System.debug(suc.sucursalID);
		System.debug(suc.centrocostoID);
	}

	@isTest static void test_method_3() {
		COM_WrapperCrearActualizarClienteSF_cls.DatosEmpresa de = new  COM_WrapperCrearActualizarClienteSF_cls.DatosEmpresa(); 
		System.debug(de.digitoVerificadorLegal);      
		System.debug(de.razonSocial);            
		System.debug(de.tipoEmpresa);              
		System.debug(de.nombreComercial);         
		System.debug(de.constitucionFecha);     
		System.debug(de.tipoActividadEconomica);  
		System.debug(de.sectorEconomico);             
		System.debug(de.grupoEmpresarial);            
		System.debug(de.agremiacion); 
	}

	@isTest static void test_method_4() {
		COM_WrapperCrearActualizarClienteSF_cls.DatosPersona dp = new COM_WrapperCrearActualizarClienteSF_cls.DatosPersona();
		System.debug(dp.primerNombre);   
		System.debug(dp.segundoNombre);   
		System.debug(dp.primerApellido);  
		System.debug(dp.segundoApellido); 
		System.debug(dp.genero);          
		System.debug(dp.estadoCivil);     
		System.debug(dp.nacimientoFecha); 
		System.debug(dp.nacimientoLugar); 
		System.debug(dp.orientacionSexual); 
		System.debug(dp.nivelEscolar); 
		System.debug(dp.factorVulnerabilidad); 
		System.debug(dp.pertenenciaEtnica); 
		System.debug(dp.profesion); 
	}
	
	@isTest static void test_method_5() {
		COM_WrapperCrearActualizarClienteSF_cls.Comunicaciones cms = new COM_WrapperCrearActualizarClienteSF_cls.Comunicaciones();
		System.debug(cms.comunicacion);
	}

	@isTest static void test_method_6() {
		COM_WrapperCrearActualizarClienteSF_cls.Comunicacion cm = new COM_WrapperCrearActualizarClienteSF_cls.Comunicacion();
		System.debug(cm.domicilios);         
		System.debug(cm.telefonos);          
		System.debug(cm.correosElectronicos);
		System.debug(cm.celulares);          
		System.debug(cm.redesSociales);    
	}

	@isTest static void test_method_7() {
		COM_WrapperCrearActualizarClienteSF_cls.Domicilios dms = new COM_WrapperCrearActualizarClienteSF_cls.Domicilios();
		System.debug(dms.domicilio);
	}  

	@isTest static void test_method_8() {
		COM_WrapperCrearActualizarClienteSF_cls.Domicilio dm = new COM_WrapperCrearActualizarClienteSF_cls.Domicilio();
		System.debug(dm.domicilio);         
		System.debug(dm.tipoDomicilio);     
		System.debug(dm.codigoPostal);      
		System.debug(dm.tipoAreaGeografica);
		System.debug(dm.codigoMunicipio);   
		System.debug(dm.nombreMunicipio);   
		System.debug(dm.barrio);  
	}    


	@isTest static void test_method_9() {
		COM_WrapperCrearActualizarClienteSF_cls.Telefonos tls = new COM_WrapperCrearActualizarClienteSF_cls.Telefonos();
		System.debug(tls.telefono);
	}

	@isTest static void test_method_10() {
		COM_WrapperCrearActualizarClienteSF_cls.Telefono tl = new COM_WrapperCrearActualizarClienteSF_cls.Telefono();
		System.debug(tl.tipoTelefono);      
		System.debug(tl.telefono);          
		System.debug(tl.extensionTelefono);
	} 

	@isTest static void test_method_11() {
		COM_WrapperCrearActualizarClienteSF_cls.CorreosElectronicos crs = new COM_WrapperCrearActualizarClienteSF_cls.CorreosElectronicos();
		System.debug(crs.correoElectronico);
	}

	@isTest static void test_method_12() {
		COM_WrapperCrearActualizarClienteSF_cls.CorreoElectronico cr = new COM_WrapperCrearActualizarClienteSF_cls.CorreoElectronico();
		System.debug(cr.correoElectronico);
		System.debug(cr.optInEmail);
	}

	@isTest static void test_method_13() {
		COM_WrapperCrearActualizarClienteSF_cls.Celulares cls =  new COM_WrapperCrearActualizarClienteSF_cls.Celulares();
		System.debug(cls.celular);
	}

	@isTest static void test_method_14() {
		COM_WrapperCrearActualizarClienteSF_cls.Celular cl = new COM_WrapperCrearActualizarClienteSF_cls.Celular();
		System.debug(cl.celular); 
		System.debug(cl.optInSMS);
	}

	@isTest static void test_method_15() {
		COM_WrapperCrearActualizarClienteSF_cls.RedesSociales rs = new COM_WrapperCrearActualizarClienteSF_cls.RedesSociales();
		System.debug(rs.redesSociales);
	}

	@isTest static void test_method_16() {
		COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal drl = new COM_WrapperCrearActualizarClienteSF_cls.DatosRepresentanteLegal();
		System.debug(drl.numeroIdentificacion);
		System.debug(drl.id);
		System.debug(drl.tipoIdentificacion);  
		System.debug(drl.nombrePrimero);       
		System.debug(drl.nombreSegundo);       
		System.debug(drl.apellidoPrimero);     
		System.debug(drl.apellidoSegundo);     
		System.debug(drl.estadoCivil);         
		System.debug(drl.nacimientoFecha);     
		System.debug(drl.nacimientoLugar);     
		System.debug(drl.genero);    
	}          

	@isTest static void test_method_17() {
		COM_WrapperCrearActualizarClienteSF_cls.Requisitos rqs = new COM_WrapperCrearActualizarClienteSF_cls.Requisitos();
		System.debug(rqs.requisito);
	}

	@isTest static void test_method_18() {
		COM_WrapperCrearActualizarClienteSF_cls.Requisito rq = new COM_WrapperCrearActualizarClienteSF_cls.Requisito();
		System.debug(rq.nemotecnico);     
		System.debug(rq.valorString);     
		System.debug(rq.valorNumerico);   
		System.debug(rq.valorBooleano);   
		System.debug(rq.valorStringo);    
		System.debug(rq.valorFechaInicio);
		System.debug(rq.valorFechaFin);
	} 
}