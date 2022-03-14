//Evita el conflicto con las librerías de Salesforce
j$ = jQuery.noConflict();
var plantillas, preguntas, opciones;

function cargarJQuery() {
	j$( '#btnGuardarOpciones' ).addClass( 'slds-button--neutral' );
	j$( '#btnGuardarOpciones' ).removeClass( 'slds-button--brand' );

	j$(".numOnly").keydown(function(e) {
		if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57) && e.keyCode != 9) { //El 9 se incluye para que acepte TAB
			return false;
		}
		else if( e.keyCode != 9) { //El 9 se incluye para que acepte TAB
			activarBotonGuardar();
		}
	});

	j$(".doChange").keydown(function(e) {
		if( e.keyCode != 40 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 37 && e.keyCode != 9 ) //El 9 se incluye para que acepte TAB
			activarBotonGuardar();
	});
}

function cargarJQueryPreguntas() {
	j$( '#btnGuardarPreguntas' ).addClass( 'slds-button--neutral' );
	j$( '#btnGuardarPreguntas' ).removeClass( 'slds-button--brand' );

	j$(".doChangePregunta").keydown(function(e) {
		if( e.keyCode != 40 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 37 && e.keyCode != 9 ) //El 9 se incluye para que acepte TAB
			activarBotonGuardarPregunta();
	});
}

function cargarVariablesOpcionesRespuesta() {
	j$( "body" ).click( function(e) {
		if( e.target.id !== 'opcionPlantilla' && e.target.id !== 'txtPlantilla' && e.target.id !== 'imgPlantilla' && e.target.id !== 'btnPlantilla'){
			j$( '#menuPlantillas' ).removeClass( 'slds-is-open' );
		}
		if( e.target.id !== 'opcionPregunta' && e.target.id !== 'txtPregunta' && e.target.id !== 'imgPregunta' && e.target.id !== 'btnPregunta'){
			j$( '#menuPreguntas' ).removeClass( 'slds-is-open' );
		}
	});
}

function cargarOpcionesRespuesta( ) {
	var html = '<div aria-hidden="false" role="dialog" class="slds-modal slds-fade-in-open">';

	html += '<div class="slds-modal__container slds-modal--large" role="document" tabindex="0">'
	html += '<div class="slds-modal__header">'
	html += '<button class="slds-button slds-button--icon-inverse slds-modal__close" onclick="ocultarPopUp();">'
	html += iconoCerrar;
	html += '<span class="slds-assistive-text">Cerrar</span>'
	html += '</button>'
	html += '<span>';
	html += iconoCopiar;
	html += '<h2 class="slds-text-heading--medium">Copiar opciones de respuesta</h2>'
	html += '</span>';
	html += '</div>'
	html += '<div class="slds-modal__content slds-p-around--medium">';
	html += '<div>';

	
	html += '<div class="slds-grid">';
	html += '<div class="slds-col slds-size--1-of-2 slds-dropdown-trigger slds-dropdown-trigger--click menus" aria-expanded="true" id="menuPlantillas"><span class="slds-text-heading--label">Plantilla </span><br/>';
	html += '<button class="slds-button" aria-haspopup="true" onclick="controlarMenu( \'#menuPlantillas\' );" id="btnPlantilla">';
	html += '<h1 class="slds-page-header__title" id="txtPlantilla" title="Plantilla" />';
	html += iconoAbajoPlantilla
	html += '<span class="slds-assistive-text">Ver Plantillas</span>';
	html += '</button>';
	html += '<div class="slds-dropdown slds-dropdown--left" id="divListadoPlantillas">';
	html += '<ul class="dropdown__list" role="menu" id="listadoPlantillas" ></ul>';
	html += '</div>';
	html += '</div>';
	html += '<div class="slds-col slds-size--1-of-2 slds-dropdown-trigger slds-dropdown-trigger--click menus" aria-expanded="true" id="menuPreguntas"><span class="slds-text-heading--label">Pregunta </span><br/>';
	html += '<button class="slds-button" aria-haspopup="true" onclick="controlarMenu( \'#menuPreguntas\' );" id="btnPregunta">';
	html += '<h1 class="slds-page-header__title" id="txtPregunta" title="Pregunta" />';
	html += iconoAbajoPregunta
	html += '<span class="slds-assistive-text">Ver Preguntas</span>';
	html += '</button>';
	html += '<div class="slds-dropdown slds-dropdown--left" id="divListadoPreguntas">';
	html += '<ul class="dropdown__list" role="menu" id="listadoPreguntas" ></ul>';
	html += '</div>';
	html += '</div>';
	html += '</div>';


	html += '<br/><br/>';
	html += '<table class="slds-table slds-table--bordered slds-table--cell-buffer">';
	html += '<thead>';
	html += '<tr class="slds-text-heading--label">';
	html += '<th scope="col">';
	html += '<div class="slds-truncate" title="Opción">Opción</div>';
	html += '</th>';
	html += '<th scope="col">';
	html += '<div class="slds-truncate" title="Valor">Valor</div>';
	html += '</th>';
	html += '</tr>';
	html += '</thead>';
	html += '<tbody id="opcionesXPrgeunta">';
	html += '</tbody>';
	html += '</table>';


	html += '<br/><br/>';
	html += '</div>';
	html += '</div>';
	html += '<div class="slds-modal__footer">';
	html += '<button class="slds-button slds-button--neutral slds-button--brand" onclick="cargarOpcionesCerrar();">Cargar opciones</button>';
	html += '</div>';
	html += '</div>';
	html += '</div>';
	html += '<div class="slds-backdrop slds-backdrop--open"></div>';
	j$("#divPopUp").html(html);

	cargarListaPlantillas();

	return false;
}

function ocultarPopUp() {
	j$("#divPopUp").html( '' );
}

function cargarListaPlantillas( numPlantilla ) {
	
	if( isNaN( numPlantilla ) ) {
		ENC_OpcionRespuesta_ctr.getListaPlantillas(
			function ( result, event ) {
				plantillas = result;
				generarListaPlantillas( 0 );
			}
		);
	}
	else
		generarListaPlantillas( numPlantilla );
}

function cargarListaPreguntas( numPregunta ) {
	var idPlantilla = j$( "#txtPlantilla" ).attr( 'data-plantilla' );
	
	if( isNaN( numPregunta ) ) {
		ENC_OpcionRespuesta_ctr.getListaPreguntas(
			idPlantilla, 
			function ( result, event ) {
				preguntas = result;
				generarListaPreguntas( 0 );
			}
		);
	}
	else
		generarListaPreguntas( numPregunta );
}

function cargarListaOpciones() {
	var idPregunta = j$( "#txtPregunta" ).attr( 'data-pregunta' );
	
	ENC_OpcionRespuesta_ctr.getListaOpciones(
		idPregunta, 
		function ( result, event ) {
			opciones = result;
			generarListaOpciones();
		}
	);
}

function generarListaPlantillas( plantillaSeleccionada ) {
	
	j$( "#txtPlantilla" ).text( plantillas[ plantillaSeleccionada ].split("Ã")[ 0 ] ).attr( 'data-plantilla', plantillas[ plantillaSeleccionada ].split("Ã")[ 1 ] );
	var htmlPlantillas = "";
	
	for ( i = 0; i < plantillas.length; i++ ) {
		var plantillaTemp = plantillas[i].split("Ã");
		htmlPlantillas += '<li class="slds-dropdown__item';
		if( i == plantillaSeleccionada )
			htmlPlantillas += ' slds-is-selected" aria-selected="true" ';
		else
			htmlPlantillas += '" ';
		htmlPlantillas += 'id="opcionPlantilla_' + i + '" data-codigoPlantilla="' + plantillaTemp[ 1 ] + '" onclick="seleccionarOpcion( \'menuPlantillas\', ' + i + ' )" >';
		htmlPlantillas += '<a href="javascript:void(0)" role="menuitemradio">';
		htmlPlantillas += '<p class="slds-truncate" id="opcionPlantilla">' + plantillaTemp[ 0 ];
		htmlPlantillas += '&nbsp;&nbsp;' + menuOK;
		htmlPlantillas += '</p></a></li>';
	}
	j$( '#listadoPlantillas' ).html( htmlPlantillas );
	cargarListaPreguntas();
}

function generarListaPreguntas( preguntaSeleccionada ) {
	j$( "#txtPregunta" ).text( preguntas[ preguntaSeleccionada ].split("Ã")[ 0 ] ).attr( 'data-pregunta', preguntas[ preguntaSeleccionada ].split("Ã")[ 1 ] );
	var htmlPreguntas = "";
	
	for ( i = 0; i < preguntas.length; i++ ) {
		var preguntaTemp = preguntas[i].split("Ã");
		htmlPreguntas += '<li class="slds-dropdown__item';
		if( i == preguntaSeleccionada )
			htmlPreguntas += ' slds-is-selected" aria-selected="true" ';
		else
			htmlPreguntas += '" ';
		htmlPreguntas += 'id="opcionPregunta_' + i + '" data-codigoPregunta="' + preguntaTemp[ 1 ] + '" onclick="seleccionarOpcion( \'menuPreguntas\', ' + i + ' )" >';
		htmlPreguntas += '<a href="javascript:void(0)" role="menuitemradio">';
		htmlPreguntas += '<p class="slds-truncate" id="opcionPregunta">' + preguntaTemp[ 0 ];
		htmlPreguntas += '&nbsp;&nbsp;' + menuOK;
		htmlPreguntas += '</p></a></li>';
	}
	j$( '#listadoPreguntas' ).html( htmlPreguntas );
	cargarListaOpciones();
}

function generarListaOpciones() {

	var htmlOpciones = "";
	
	for ( i = 0; i < opciones.length; i++ ) {
		var opcionTemp = opciones[i].split("Ã");
			htmlOpciones += '<tr>';
			htmlOpciones += '<th scope="row" data-label="Opción">';
			htmlOpciones += '<div class="slds-truncate" title="' + opcionTemp[ 0 ] + '">' + opcionTemp[ 0 ] + '</div>';
			htmlOpciones += '</th>';
			htmlOpciones += '<td data-label="Valor">';
			htmlOpciones += '<div class="slds-truncate" title="' + opcionTemp[ 1 ] + '">' + opcionTemp[ 1 ] + '</div>';
			htmlOpciones += '</td>';
			htmlOpciones += '</tr>';
	}
	j$( '#opcionesXPrgeunta' ).html( htmlOpciones );
	cargarVariablesOpcionesRespuesta();
}

function controlarMenu( idMenu ) {
	j$( idMenu ).toggleClass( 'slds-is-open' );
}

function seleccionarOpcion( idMenu, numOpcion ) {
	var numMenu;
	
	if( idMenu == 'menuPlantillas' )
		cargarListaPlantillas( numOpcion );
	else if( idMenu == 'menuPreguntas' )
		cargarListaPreguntas( numOpcion );
	
	j$( '#' + idMenu ).removeClass( 'slds-is-open' );
}

function cargarOpcionesCerrar(){
	var idPregunta = j$( "#txtPregunta" ).attr( 'data-pregunta' );
	fnCargarOpciones( idPregunta );
	ocultarPopUp();
}

function subirOpcionRepsuesta( numOpcion, blnModoEdicion, strPreguntaId ){
	var opciones = buscarOpcionesRespuesta();
	var strOpciones = '';

	for( i = 0; i < opciones.length; i++ ){
		
		strOpciones += strOpciones == '' ? '' : 'Õ';
		if( i == ( numOpcion - 1 ) )
			strOpciones += opciones[ i + 1 ];
		else if( i == numOpcion )
			strOpciones += opciones[ i - 1 ];
		else 
			strOpciones += opciones[ i ];
	}

	mostrarTablaOpcionesRespuesta( blnModoEdicion, strOpciones, strPreguntaId );
	activarBotonGuardar();

}

function bajarOpcionRepsuesta( numOpcion, blnModoEdicion, strPreguntaId ){
	var opciones = buscarOpcionesRespuesta();
	var strOpciones = '';

	for( i = 0; i < opciones.length; i++ ){
		
		strOpciones += strOpciones == '' ? '' : 'Õ';
		if( i == ( numOpcion + 1 ) )
			strOpciones += opciones[ i - 1 ];
		else if( i == numOpcion )
			strOpciones += opciones[ i + 1 ];
		else 
			strOpciones += opciones[ i ];
	}

	mostrarTablaOpcionesRespuesta( blnModoEdicion, strOpciones, strPreguntaId );
	activarBotonGuardar();

}

function eliminarOpcionRepsuesta( numOpcion, blnModoEdicion, strPreguntaId ){
	var opciones = buscarOpcionesRespuesta();
	var strOpciones = '';

	for( i = 0; i < opciones.length; i++ ){
		
		
		if( i != numOpcion ){
			strOpciones += strOpciones == '' ? '' : 'Õ'; 
			strOpciones += opciones[ i ];
		}
	}

	mostrarTablaOpcionesRespuesta( blnModoEdicion, strOpciones, strPreguntaId );
	activarBotonGuardar();

}

function buscarOpcionesRespuesta(){
	var inputs = j$('#bodyTablaOpciones').find('.infoTemp');
	var opciones = [];
	var txtTemp = '';

	for( i = 1; i <= inputs.length; i++ ){
		txtTemp += (i % 2) != 0 ? '' : 'Ã';
		txtTemp += inputs[i - 1].value;
		
		if( (i % 2) == 0 ){
			opciones.push( txtTemp );
			txtTemp = '';
		}
	}

	return opciones;
}

function activarBotonGuardar(){
	j$( '#btnGuardarOpciones' ).removeClass( 'slds-button--neutral' );
	j$( '#btnGuardarOpciones' ).addClass( 'slds-button--brand' );
}

function activarBotonGuardarPregunta(){
	j$( '#btnGuardarPreguntas' ).removeClass( 'slds-button--neutral' );
	j$( '#btnGuardarPreguntas' ).addClass( 'slds-button--brand' );
}

function mostrarTablaOpcionesRespuesta( blnModoEdicion, strOpciones, strPreguntaId ) {

	var lstOpciones = strOpciones != null && strOpciones != '' ? strOpciones.split( 'Õ' ) : [];
	var html = '';

	for ( i = 0; i < lstOpciones.length; i++ ) {
		var opcionesTemp = lstOpciones[i].split( 'Ã' );

		html += '<tr>';
		html += '<td scope="row" data-label="Acción" style="width:20%; vertical-align: middle;">';
		html += i == 0 || !blnModoEdicion ? iconoFlechaArribaGris : '<a href="" onclick="subirOpcionRepsuesta( ' + i + ', ' + blnModoEdicion + ', \'' + strPreguntaId + '\' ); return false;" title="Subir opción" style="">' + iconoFlechaArriba + '</a>';
		html += i == ( lstOpciones.length - 1 ) || !blnModoEdicion ? iconoFlechaAbajoGris : '<a href="" onclick="bajarOpcionRepsuesta( ' + i + ', ' + blnModoEdicion + ', \'' + strPreguntaId + '\' ); return false;" title="Bajar opción">' + iconoFlechaAbajo + '</a>';
		html += !blnModoEdicion ? iconoEliminarGris : '<a href="" onclick="eliminarOpcionRepsuesta( ' + i + ', ' + blnModoEdicion + ', \'' + strPreguntaId + '\' ); return false;" title="Eliminar opción">' + iconoEliminar + '</a>';
		html += '<span class="changeWarning_' + i + '" title="Cambios sin guardar"/>';
		html += '</td>';
		html += '<td data-label="Opción">';
		html += blnModoEdicion ? '<input class="slds-input doChange infoTemp" data-numFila="' + i + '" type="text" placeholder="Texto de la opción" value="' + opcionesTemp[0] + '"/>' : '';
		html += !blnModoEdicion ? '<div class="slds-truncate">' + opcionesTemp[0] + '</div>' : '';
		html += '</td>';
		html += '<td data-label="Valor" style="width:20%">';
		html += blnModoEdicion ? '<input class="slds-input numOnly infoTemp" data-numFila="' + i + '" type="text" placeholder="Texto de la opción" value="' + opcionesTemp[1] + '"/>' : '';
		html += !blnModoEdicion ? '<div class="slds-truncate" >' + opcionesTemp[1] + '</div>' : '';
		html += '</td>';
		html += '</tr>';
	}

	j$("#bodyTablaOpciones").html(html);
	cargarJQuery();

	return false;
}

function agregarOpcionTemp( blnModoEdicion, strPreguntaId ) {
	var opciones = buscarOpcionesRespuesta();
	var strOpciones = '';

	for( i = 0; i < opciones.length; i++ ){
		strOpciones += strOpciones == '' ? '' : 'Õ'; 
		strOpciones += opciones[ i ];
	}

	strOpciones += strOpciones == '' ? '' : 'Õ';
	strOpciones += 'Opción ' + ( opciones.length + 1 ) + 'Ã' + '0';

	mostrarTablaOpcionesRespuesta( blnModoEdicion, strOpciones, strPreguntaId );
	activarBotonGuardar();
}

function fnCargarOpciones( idPregunta ){
	ENC_OpcionRespuesta_ctr.getListaOpciones(
		idPregunta, 
		function ( result, event ) {
			
			var opciones = buscarOpcionesRespuesta();
			var strOpciones = '';

			for( i = 0; i < opciones.length; i++ ){
				strOpciones += strOpciones == '' ? '' : 'Õ'; 
				strOpciones += opciones[ i ];
			}

			for( i = 0; i < result.length; i++ ){
				strOpciones += strOpciones == '' ? '' : 'Õ'; 
				strOpciones += result[ i ];
			}

			mostrarTablaOpcionesRespuesta( true, strOpciones, '' );
			activarBotonGuardar();
		}
	);
}

function guardarOpciones( strIdPregunta ){
	j$("#divMensajesDetalle").html( "" ).show();
	var opciones = buscarOpcionesRespuesta();
	var strOpciones = '';

	for( i = 0; i < opciones.length; i++ ){
		strOpciones += strOpciones == '' ? '' : 'Õ'; 
		strOpciones += opciones[ i ];
	}

	ENC_OpcionRespuesta_ctr.guardarOpciones(
		strIdPregunta, strOpciones, 
		function ( result, event ) {
			if (event.status) {
				j$("#divMensajesDetalle").html(notificarResultado("INFORMACIÓN GUARDADA EXITOSAMENTE", 'OK')).fadeOut( 3000 );
				mostrarTablaOpcionesRespuesta( true, strOpciones, strIdPregunta );
			} else if (event.type === 'exception') {
				j$("#divMensajesDetalle").html(notificarResultado( event.message, 'ERROR' ));
			} else {
				console.log(event.message);
			}
		}
	);
}

function notificarResultado( nombreAccion, tipoTitulo ){
	var html = '';	
	html += '<div class="slds-notify_container">';
	html += '<div class="slds-notify slds-notify--alert slds-theme--';
	html += tipoTitulo == 'OK' ? 'success' : 'error';
	html += ' slds-theme--alert-texture" role="alert">';
	html += '<span class="slds-assistive-text">';
	html += tipoTitulo == 'OK' ? 'Success' : 'Error';
	html += '</span>';
	html += '<h2>' + nombreAccion + '</h2>';
	html += '</div>';
	html += '</div>';

	return html;
}

/* FUNCIONALIDAD DE OPCIONES DE PREGUNTA */


function mostrarTablaListaPreguntas( blnModoEdicion, strPreguntas, strPreguntaId ) {

	var lstPreguntas = strPreguntas != null && strPreguntas != '' ? strPreguntas.split( '{!Õ}' ) : [];
	var html = '';

	for ( i = 0; i < lstPreguntas.length; i++ ) {

		html += '<tr>';
		html += '<td scope="row" data-label="Acción" style="width:20%; vertical-align: middle;">';
		html += i == 0 || !blnModoEdicion ? iconoFlechaArribaGris : '<a href="" onclick="subirPregunta( ' + i + ', ' + blnModoEdicion + ', \'' + strPreguntaId + '\' ); return false;" title="Subir pregunta" style="">' + iconoFlechaArriba + '</a>';
		html += i == ( lstPreguntas.length - 1 ) || !blnModoEdicion ? iconoFlechaAbajoGris : '<a href="" onclick="bajarPregunta( ' + i + ', ' + blnModoEdicion + ', \'' + strPreguntaId + '\' ); return false;" title="Bajar pregunta">' + iconoFlechaAbajo + '</a>';
		html += !blnModoEdicion ? iconoEliminarGris : '<a href="" onclick="eliminarPregunta( ' + i + ', ' + blnModoEdicion + ', \'' + strPreguntaId + '\' ); return false;" title="Eliminar pregunta">' + iconoEliminar + '</a>';
		html += '<span class="changeWarning_' + i + '" title="Cambios sin guardar"/>';
		html += '</td>';
		html += '<td data-label="Pregunta">';
		html += blnModoEdicion ? '<input class="slds-input doChangePregunta infoTemp" data-numFila="' + i + '" type="text" placeholder="Texto de la pregunta" value="' + lstPreguntas[i] + '"/>' : '';
		html += !blnModoEdicion ? '<div class="slds-truncate">' + lstPreguntas[i] + '</div>' : '';
		html += '</td>';
		html += '</tr>';
	}

	j$("#bodyTablaPreguntas").html(html);
	cargarJQueryPreguntas();

	return false;
}

function agregarPreguntaTemp( blnModoEdicion, strPreguntaId ) {
	var preguntas = buscarListaPreguntas();
	//console.log( 'Preguntas encontradas: ' + preguntas );
	var strPreguntas = '';

	for( i = 0; i < preguntas.length; i++ ){
		strPreguntas += strPreguntas == '' ? '' : '{!Õ}'; 
		strPreguntas += preguntas[ i ];
	}

	strPreguntas += strPreguntas == '' ? '' : '{!Õ}';
	strPreguntas += 'Nueva Pregunta ' + ( preguntas.length + 1 );

	mostrarTablaListaPreguntas( blnModoEdicion, strPreguntas, strPreguntaId );
	activarBotonGuardarPregunta();
}

function subirPregunta( numPregunta, blnModoEdicion, strPreguntaId ){
	var preguntas = buscarListaPreguntas();
	var strPreguntas = '';

	for( i = 0; i < preguntas.length; i++ ){
		
		strPreguntas += strPreguntas == '' ? '' : '{!Õ}';
		if( i == ( numPregunta - 1 ) )
			strPreguntas += preguntas[ i + 1 ];
		else if( i == numPregunta )
			strPreguntas += preguntas[ i - 1 ];
		else 
			strPreguntas += preguntas[ i ];
	}

	mostrarTablaListaPreguntas( blnModoEdicion, strPreguntas, strPreguntaId );
	activarBotonGuardarPregunta();

}

function bajarPregunta( numPregunta, blnModoEdicion, strPreguntaId ){
	var preguntas = buscarListaPreguntas();
	var strPreguntas = '';

	for( i = 0; i < preguntas.length; i++ ){
		
		strPreguntas += strPreguntas == '' ? '' : '{!Õ}';
		if( i == ( numPregunta + 1 ) )
			strPreguntas += preguntas[ i - 1 ];
		else if( i == numPregunta )
			strPreguntas += preguntas[ i + 1 ];
		else 
			strPreguntas += preguntas[ i ];
	}

	mostrarTablaListaPreguntas( blnModoEdicion, strPreguntas, strPreguntaId );
	activarBotonGuardarPregunta();

}

function eliminarPregunta( numPregunta, blnModoEdicion, strPreguntaId ){
	var preguntas = buscarListaPreguntas();
	var strPreguntas = '';

	for( i = 0; i < preguntas.length; i++ ){
		
		if( i != numPregunta ){
			strPreguntas += strPreguntas == '' ? '' : '{!Õ}'; 
			strPreguntas += preguntas[ i ];
		}
	}

	mostrarTablaListaPreguntas( blnModoEdicion, strPreguntas, strPreguntaId );
	activarBotonGuardarPregunta();

}

function buscarListaPreguntas(){
	var inputs = j$('#bodyTablaPreguntas').find('.infoTemp');
	var preguntas = [];
	var txtTemp = '';

	for( i = 0; i < inputs.length; i++ ){
		preguntas.push( inputs[i].value );
	}

	return preguntas;
}

function guardarPreguntas( strIdPregunta ){
	j$("#divMensajesDetallePregunta").html( "" ).show();
	var preguntas = buscarListaPreguntas();
	var strPreguntas = '';

	for( i = 0; i < preguntas.length; i++ ){
		strPreguntas += strPreguntas == '' ? '' : '{!Õ}'; 
		strPreguntas += preguntas[ i ];
	}

	ENC_OpcionRespuesta_ctr.guardarPreguntas(
		strIdPregunta, strPreguntas, 
		function ( result, event ) {
			if (event.status) {
				j$("#divMensajesDetallePregunta").html(notificarResultado("INFORMACIÓN GUARDADA EXITOSAMENTE", 'OK')).fadeOut( 3000 );
				mostrarTablaListaPreguntas( true, strPreguntas, strIdPregunta );
			} else if (event.type === 'exception') {
				j$("#divMensajesDetallePregunta").html(notificarResultado( event.message, 'ERROR' ));
			} else {
				console.log(event.message);
			}
		}
	);
}

function capturarSeleccion( idHidden, idPregunta, respuesta ){
	console.log( 'Hidden ID: ' + idHidden + '\nPregunta ID: ' + idPregunta + '\nOpcion ID: ' + respuesta );
	var myHidden = document.getElementById( idHidden );
	console.log( 'OLD Hidden: ' + myHidden.value );
	var respuestas = myHidden.value.split( '|Õ|' );
	console.log( 'respuestas: ' + respuestas );
	respuestas[idPregunta] = respuesta;
	myHidden.value = '';
	for( i = 0; i < respuestas.length; i++ ){
		myHidden.value += myHidden.value == '' ? '' : '|Õ|';
		myHidden.value += respuestas[i];
	}

	console.log( 'NEW Hidden: ' + myHidden.value );
}