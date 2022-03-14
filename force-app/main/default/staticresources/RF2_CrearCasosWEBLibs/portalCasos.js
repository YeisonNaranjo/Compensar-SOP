var WEB_PCE = 'WEB_PCE';
var WEB_GIE = 'WEB_GIE';
var NIT = '2';
var EXTENSIONES_VALIDAS = new Array('.csv', '.txt', '.tiff', '.tif', '.pdf', '.xls', '.xlsx', '.doc', '.docx', '.jpg', '.png', '.jpeg', '.gif', '.bmp ', '.rtf');

var RelacionadoCon = {
		'No Afiliado': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Anio de servicios','label': 'A&#241;o de servicios'},
			{ 'value': 'Estado de cuenta de aportes','label': 'Estado de pago de aportes'},
			{ 'value': 'Certificado Historico de afiliacion','label': 'Certificado Hist&#243;rico de afiliaci&#243;n'},
			{ 'value': 'Trámite subsidio al Desempleo','label': 'Tr&#225;mite subsidio al Desempleo'},
			{ 'value': 'Certificaciones de no afiliados','label': 'Certificaciones de no afiliados'},
			{ 'value': 'Informacion datos biograficos y de vinculacion','label': 'Informaci&#243;n datos biogr&#225;ficos y de vinculaci&#243;n'}
		],
		'Trabajador Dependiente': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			
			{ 'value': 'Generacion y distribucion Tarjeta Compensar', 'label': 'Novedades de estado y envio de tarjeta compensar'},
			{ 'value': 'Consultas de la Afiliacion', 'label': 'Aclaraci&#243;n Afiliaciones, retiros y grupo familiar'},
			{ 'value': 'Certificacion Historica de Afiliacion', 'label': 'Certificaci&#243;n Hist&#243;rica de Afiliaci&#243;n'},
			{ 'value': 'Solicitud Retiro de beneficiarios', 'label': 'Solicitud de retiro de Beneficiarios (hijos, hermanos, padres)'},
			{ 'value': 'Datos basicos y documento de identidad del beneficiario y/o trabajador', 'label': 'Datos b&#225;sicos y documento de identidad del beneficiario y/o trabajador'},
			{ 'value': 'Solicitud de retiro de Conyuges', 'label': 'Solicitud de retiro de Conyuges'},
			{ 'value': 'Afiliaciones por custodia', 'label': 'Afiliaciones por custodia'},
			{ 'value': 'Certificado de afiliacion extranjeros documentos diferente a CE', 'label': 'Certificado de afiliaci&#243;n extranjeros documentos diferente a CE'}
		],
		'Pensionado': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Mora en aportes caja', 'label': 'Mora en aportes caja'},
			{ 'value': 'Afiliacion Ley 1643 del 2014', 'label': 'Afiliaci&#243;n Ley 1643 del 2013'},
			{ 'value': 'Afiliacion Pensionado 25 a&#241;os', 'label': 'Afiliaci&#243;n Pensionado 25 a&#241;os'},
			{ 'value': 'Generacion y distribucion Tarjeta Compensar', 'label': 'Novedades de estado y envio de tarjeta compensar'},
			{ 'value': 'Solicitud de Retiro de Pensionado', 'label': 'Solicitud de Retiro de Pensionado'},
			{ 'value': 'Correccion de aportes', 'label': 'Correcci&#243;n de aportes'},
			{ 'value': 'Traslado de aportes a otras CCF', 'label': 'Traslado de aportes a otras CCF'},
			{ 'value': 'Consultas de la Afiliacion', 'label': 'Aclaraci&#243;n Afiliaciones, retiros y grupo familiar'},
			{ 'value': 'Certificacion Historica de Afiliacion', 'label': 'Certificaci&#243;n Hist&#243;rica de Afiliaci&#243;n'},
			{ 'value': 'Devolucion de Aportes', 'label': 'Devoluci&#243;n de Aportes'},
			{ 'value': 'Solicitud Paz y Salvo para traslado de Caja', 'label': 'Solicitud Paz y Salvo para traslado de Caja'},
			{ 'value': 'Solicitud Retiro de beneficiarios', 'label': 'Solicitud de retiro de Beneficiarios (hijos, hermanos, padres)'},
			{ 'value': 'Estado de cuenta de aportes', 'label': 'Estado de pago de aportes'},
			{ 'value': 'Datos basicos y documento de identidad del beneficiario y/o trabajador', 'label': 'Datos b&#225;sicos y documento de identidad del beneficiario y/o trabajador'},
			{ 'value': 'Solicitud de retiro de Conyuges', 'label': 'Solicitud de retiro de Conyuges'},
			{ 'value': 'Afiliaciones por custodia', 'label': 'Afiliaciones por custodia'},
			{ 'value': 'Afiliado a compensar que realiza aportes por error a otra caja', 'label': 'Afiliado a compensar que realiza aportes por error a otra caja'},
			{ 'value': 'Notificacion de mora realizada por caja de compensacion.', 'label': 'Aclaraci&#243;n por notificaci&#243;n de mora realizada por Caja de Compensaci&#243;n'},
			{ 'value': 'Desistimiento paz y salvo traslado caja', 'label': 'Desistimiento de solicitud de paz y salvo para traslado'}
		],
		'Independiente': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Mora en aportes caja', 'label': 'Mora en aportes caja'},
			{ 'value': 'Generacion y distribucion Tarjeta Compensar', 'label': 'Novedades de estado y envio de tarjeta compensar'},
			{ 'value': 'Correccion de aportes', 'label': 'Correcci&#243;n de aportes'},
			{ 'value': 'Traslado de aportes a otras CCF', 'label': 'Traslado de aportes a otras CCF'},
			{ 'value': 'Consultas de la Afiliacion', 'label': 'Aclaraci&#243;n Afiliaciones, retiros y grupo familiar'},
			{ 'value': 'Certificacion Historica de Afiliacion', 'label': 'Certificaci&#243;n Hist&#243;rica de Afiliaci&#243;n'},
			{ 'value': 'Devolucion de Aportes', 'label': 'Devoluci&#243;n de Aportes'},
			{ 'value': 'Solicitud Retiro de beneficiarios', 'label': 'Solicitud de retiro de Beneficiarios (hijos, hermanos, padres)'},
			{ 'value': 'Estado de cuenta de aportes', 'label': 'Estado de pago de aportes'},
			{ 'value': 'Datos basicos y documento de identidad del beneficiario y/o trabajador', 'label': 'Datos b&#225;sicos y documento de identidad del beneficiario y/o trabajador'},
			{ 'value': 'Solicitud Paz y Salvo para traslado de Caja', 'label': 'Solicitud Paz y Salvo para traslado de Caja'},
			{ 'value': 'Solicitud de retiro de Conyuges', 'label': 'Solicitud de retiro de Conyuges'},
			{ 'value': 'Afiliaciones por custodia', 'label': 'Afiliaciones por custodia'},
			{ 'value': 'Certificado de afiliacion extranjeros documentos diferente a CE', 'label': 'Certificado de afiliaci&#243;n extranjeros documentos diferente a CE'},
			{ 'value': 'Afiliado a compensar que realiza aportes por error a otra caja', 'label': 'Afiliado a compensar que realiza aportes por error a otra caja'},
			{ 'value': 'Notificacion de mora realizada por caja de compensacion.', 'label': 'Aclaraci&#243;n por notificaci&#243;n de mora realizada por Caja de Compensaci&#243;n'},
			{ 'value': 'Activacion de vinculacion independiente con aportes al dia', 'label': 'Activaci&#243;n de vinculaci&#243;n independiente con aportes al d&#237;a'},
			{ 'value': 'Desistimiento paz y salvo traslado caja', 'label': 'Desistimiento de solicitud de paz y salvo para traslado'}
		],
		'Empresarial': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Mora en aportes caja', 'label': 'Mora en aportes caja'},
			{ 'value': 'Actualizacion Datos Empresa', 'label': 'Datos de empresa (Representaci&#243;n legal, raz&#243;n social, Ciiu)'},
			{ 'value': 'Actualizacion Datos  Trabajador', 'label': 'Correcci&#243;n fecha de ingreso empresa'},
			{ 'value': 'Afiliado a compensar que realiza aportes por error a otra caja', 'label': 'Afiliado a compensar que realiza aportes por error a otra caja'},
			{ 'value': 'Asesoria presencial en aportes', 'label': 'Asesoria presencial en aportes'},
			{ 'value': 'Estado de cuenta de aportes', 'label': 'Estado de pago de aportes'},
			{ 'value': 'Generacion y distribucion Tarjeta Compensar', 'label': 'Novedades de estado y envio de tarjeta compensar'},

			{ 'value': 'Notificacion de mora realizada por caja de compensacion.', 'label': 'Aclaraci&#243;n por notificaci&#243;n de mora realizada por Caja de Compensaci&#243;n'},
			{ 'value': 'Reporte de empresa en liquidacion voluntaria', 'label': 'Reporte de empresa en liquidaci&#243;n voluntaria'},
			{ 'value': 'Retiro para empresa sin trabajadores a cargo', 'label': 'Retiro para empresa sin trabajadores a cargo'},
			{ 'value': 'Reafiliaciones empresariales', 'label': 'Reafiliaciones empresariales'},
			{ 'value': 'Retiro de trabajadores por cambio de ciudad', 'label': 'Retiro de trabajadores por cambio de ciudad'},
			{ 'value': 'Solicitud Paz y Salvo para traslado de Caja', 'label': 'Solicitud Paz y Salvo para traslado de Caja'},
			{ 'value': 'Solicitud para tramite de reafiliacion servicio domestico', 'label': 'Reafiliaciones servicio domestico'},
			{ 'value': 'Sustitucion Patronal Trabajadores', 'label': 'Sustituci&#243;n Patronal Parcial'},
			{ 'value': 'Actualizacion informacion trabajadores', 'label': 'Correcci&#243;n de cargo y/o  horas laboradas'},
			{ 'value': 'Correccion de aportes', 'label': 'Correcci&#243;n de aportes'},
			{ 'value': 'Reporte Novedades vinculacion', 'label': 'Informe de estado de vinculación de los trabajadores'},
			{ 'value': 'Traslado de aportes a otras CCF', 'label': 'Traslado de aportes a otras CCF'},
			{ 'value': 'Devolucion de Aportes', 'label': 'Devoluci&#243;n de Aportes'},
			{ 'value': 'Certificacion de aportes otras cajas', 'label': 'Certificaci&#243;n estado de afiliaci&#243;n empresa'},
			{ 'value': 'Desistimiento paz y salvo traslado caja', 'label': 'Desistimiento de solicitud de paz y salvo para traslado'},
			{ 'value': 'Notificacion de trabajadores sin afiliacion y con aporte', 'label': 'Notificaci&#243;n de trabajadores sin afiliaci&#243;n y con aporte'},
			{ 'value': 'Datos de empresa (direccion, celular y correo electronico)', 'label': 'Datos de empresa (direcci&#243;n, celular y correo electronico)'},
			{ 'value': 'Anulacion de afiliacion trabajadores y beneficiarios', 'label': 'Anulaci&#243;n de afiliaci&#243;n trabajadores y beneficiarios'}
		],
		'URL PCE': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Afiliaciones caja de compensacion', 'label': 'Afiliaciones caja de compensaci&#243;n'},
			{ 'value': 'Agencia de empleo', 'label': 'Agencia de empleo'},
			{ 'value': 'Alimentos', 'label': 'Alimentos'},
			{ 'value': 'Aportes', 'label': 'Aportes'},
			{ 'value': 'Atencion personalizada (PAI-Call Center-Pagina WEB)', 'label': 'Atenci&#243;n personalizada (PAI-Call Center-P&#225;gina WEB)'},
			{ 'value': 'Certificaciones', 'label': 'Certificaciones'},
			{ 'value': 'Convenios y Alianzas', 'label': 'Convenios y Alianzas'},
			{ 'value': 'Credito', 'label': 'Cr&#233;dito'},
			{ 'value': 'Cultura y Recreacion', 'label': 'Cultura y Recreaci&#243;n'},
			{ 'value': 'Deportes', 'label': 'Deportes'},
			{ 'value': 'Educacion', 'label': 'Educaci&#243;n'},
			{ 'value': 'Eventos', 'label': 'Eventos'},
			{ 'value': 'Eventos Sociales', 'label': 'Eventos Sociales'},
			{ 'value': 'Mi Planilla', 'label': 'Mi Planilla'},
			{ 'value': 'Otros', 'label': 'Otros'},
			{ 'value': 'Subsidio arrendamiento', 'label': 'Subsidio arrendamiento'},
			{ 'value': 'Subsidio monetario', 'label': 'Subsidio monetario'},
			{ 'value': 'Subsidio seguro desempleo', 'label': 'Subsidio seguro desempleo'},
			{ 'value': 'Subsidio vivienda', 'label': 'Subsidio vivienda'},
			{ 'value': 'Tarjeta Compensar', 'label': 'Tarjeta Compensar'},
			{ 'value': 'Transacciones en linea', 'label': 'Transacciones en l&#237;nea'},
			{ 'value': 'Turismo', 'label': 'Turismo'},
			{ 'value': 'Vivienda', 'label': 'Vivienda'}
		],
		'CRM GIE': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Aclaracion aportes empleadores, independientes y pensionados', 'label': 'Aclaraci&#243;n aportes empleadores, independientes y pensionados'},
			{ 'value': 'Aclaracion aportes en mora', 'label': 'Aclaraci&#243;n aportes en mora'},
			{ 'value': 'Aclaraciones empleadores', 'label': 'Aclaraciones empleadores'},
			{ 'value': 'Aclaracion vinculacion trabajadores, independientes y pensionados', 'label': 'Aclaraci&#243;n vinculaci&#243;n trabajadores, independientes y pensionados'},
			{ 'value': 'Asesoria presencial en aportes', 'label': 'Asesoria presencial en aportes'},
			{ 'value': 'Distribucion tarjeta Compensar', 'label': 'Distribuci&#243;n tarjeta Compensar'},
			{ 'value': 'Reafiliaciones empresariales', 'label': 'Reafiliaciones empresariales'},
			{ 'value': 'Rechazos Afiliaciones Gdoc', 'label': 'Rechazos Afiliaciones Gdoc'},
			{ 'value': 'Retiro de trabajadores por cambio de ciudad', 'label': 'Retiro de trabajadores por cambio de ciudad'},
			{ 'value': 'Solicitud Paz y Salvo para traslado de Caja', 'label': 'Solicitud Paz y Salvo para traslado de Caja'},
			{ 'value': 'Afiliaci&#243;n Virtual', 'label': 'Afiliaci&#243;n Virtual'},
			{ 'value': 'Generacion de Paz y Salvo para Traslado', 'label': 'Generaci&#243;n de Paz y Salvo para Traslado'}
		],
		'CRM PCE': [
			{ 'value': 'Seleccione &gt;','label': 'Seleccione &gt;'},
			{ 'value': 'Afiliaciones caja de compensacion', 'label': 'Afiliaciones caja de compensaci&#243;n'},
			{ 'value': 'Agencia de empleo', 'label': 'Agencia de empleo'},
			{ 'value': 'Alimentos', 'label': 'Alimentos'},
			{ 'value': 'Aportes', 'label': 'Aportes'},
			{ 'value': 'Atencion personalizada (PAI-Call Center-Pagina WEB)', 'label': 'Atenci&#243;n personalizada (PAI-Call Center-P&#225;gina WEB)'},
			{ 'value': 'Certificaciones', 'label': 'Certificaciones'},
			{ 'value': 'Convenios y Alianzas', 'label': 'Convenios y Alianzas'},
			{ 'value': 'Credito', 'label': 'Cr&#233;dito'},
			{ 'value': 'Cultura y Recreacion', 'label': 'Cultura y Recreaci&#243;n'},
			{ 'value': 'Deportes', 'label': 'Deportes'},
			{ 'value': 'Educacion', 'label': 'Educaci&#243;n'},
			{ 'value': 'Eventos', 'label': 'Eventos'},
			{ 'value': 'Eventos Sociales', 'label': 'Eventos Sociales'},
			{ 'value': 'Mi Planilla', 'label': 'Mi Planilla'},
			{ 'value': 'Otros', 'label': 'Otros'},
			{ 'value': 'Subsidio arrendamiento', 'label': 'Subsidio arrendamiento'},
			{ 'value': 'Subsidio monetario', 'label': 'Subsidio monetario'},
			{ 'value': 'Subsidio seguro desempleo', 'label': 'Subsidio seguro desempleo'},
			{ 'value': 'Subsidio vivienda', 'label': 'Subsidio vivienda'},
			{ 'value': 'Tarjeta Compensar', 'label': 'Tarjeta Compensar'},
			{ 'value': 'Transacciones en linea', 'label': 'Transacciones en l&#237;nea'},
			{ 'value': 'Turismo', 'label': 'Turismo'},
			{ 'value': 'Vivienda', 'label': 'Vivienda'},
			{ 'value': 'Venta', 'label': 'Venta'},
			{ 'value': 'Portal Corporativo', 'label': 'Portal Corporativo'},
			{ 'value': 'Gestor de Inconsistencias', 'label': 'Gestor de Inconsistencias'}
		]
	}
	
jQuery(function($) {
	
	$("#fechaSuceso").datepicker({
		dateFormat: 'yy-mm-dd'
	});
	
	$( "#fechaSuceso" ).datepicker( "option", "yearRange", "-99:+0" );

    $( "#fechaSuceso" ).datepicker( "option", "maxDate", "+0m +0d" );
	
	$("#chkAnonimo").click(function () {
		if ($(this).is(":checked")) {
			$("#ContentPlaceHolder1_divDatosIdentificacion").hide();
			$("#ContentPlaceHolder1_divDatosBasicos").hide();
			$("#ContentPlaceHolder1_divDatosAutorizacion").hide();
		} else {
			$("#ContentPlaceHolder1_divDatosIdentificacion").show();
			$("#ContentPlaceHolder1_divDatosBasicos").show();
			$("#ContentPlaceHolder1_divDatosAutorizacion").show();
		}
	});
	
	var $RelacionadoCon = $('#_RelacionadoCon');
	$('#_Programa').change(function () {
		var programa = $(this).val(), lcns = RelacionadoCon[programa] || [];
		
		var html = $.map(lcns, function(lcn){
			return '<option value="' + lcn.value + '">' + lcn.label + '</option>'
		}).join('');
		$RelacionadoCon.html(html)
	});
});