/**
* Avanxo Colombia
* @author           Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada de ejecutar  las pruebas unitarias de la clase
*                   COM_ConsultarHistVinculaciones_cls
*                   
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     10/08/2017      Cristian Mosquera (CM)      Implementacion inicial de la clase.
**/
@isTest
public class COM_ConsultarHistVinculaciones_tst {

    /** Instancia encargada de realizar el consumo del webservice**/
    private static COM_ConsultarClienteGC_ws consumer = new COM_ConsultarClienteGC_ws();

    /** Instancia de la claase historial de vinculaciones**/
    private static COM_ConsultarHistVinculaciones_cls consultarHistVinculaciones_cls = new
            COM_ConsultarHistVinculaciones_cls();

    /** La respuesta exitosa del servicio con todos los atributos. **/
    private static String responseSuccess = '{ "CustomerMng_ConsultaCliente_Response" : { "Header" : { "RequestDate" : "2017-08-09T15:48:36.497-05:00", "ResponseDate" : "2017-08-09T15:48:36.594-05:00", "ResponseCode" : "0", "ResponseDesc" : "OK", "TransactionID" : "99910072100" }, "Body" : { "Vinculacion" : { "AfiliadoCaja" : "false", "AfiliacionConResponsable" : "false", "AfiliadoSalud" : "false", "AfiliadoPLC" : "false" }, "Cliente" : { "TipoIdentificacion" : "1", "NumeroIdentificacion" : "28868463", "Id" : "9999803457925823", "datosPersona" : { "nombrePrimero" : "NORFIDIA", "nombreSegundo" : "", "apellidoPrimero" : "SANCHEZ", "apellidoSegundo" : "SANCHEZ", "nombre" : "NORFIDIA SANCHEZ SANCHEZ", "foneticoID" : "19771215SANSESSANORFIDIA", "nuip" : "", "Familia" : { "familia" :[{ "tipoParentesco" : "HI", "familiar" : { "legalID" : "1000115711", "tipoIdentificacion" : "3", "id" : "9999803457925821", "datosPersona" : { "nombrePrimero" : "YEFER", "nombreSegundo" : "ESTEBAN", "apellidoPrimero" : "RICO", "apellidoSegundo" : "SANCHEZ", "nombre" : "YEFER ESTEBAN RICO SANCHEZ", "nuip" : " ", "demografia" : { "nacimientoFecha" : "1997-02-25T00:00:00", "genero" : "M", "estadoCivil" : "SO" }, "motivoInactivacion" : { "id" : "0" } }, "Sucursal" : "", "comunicacionesCliente" : "", "Contacto" : "", "Afiliacion" : { "afiliacion" :[{ "cantidadVinculacion" : "0", "categoriaAfiliacion" : "A", "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2010-12-26T00:00:00", "inicioFecha" : "2010-11-10T00:00:00", "retiroFecha" : "2010-12-26T00:00:00", "valorVinculacion" : "0", "variableRetiro" : "CRETHIJ", "Programa" : { "programa" :[{ "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "0", "programaPadre" : "1021", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "20", "nombre" : "Desvinculación laboral" }, "clientePropietarioID" : "0", "tipoParentesco" : "HI", "sigla" : "CJ", "nombrePrograma" : "Hijos de Trabajador Dependiente", "diasParaReactivacion" : "0" }] }, "id" : "6692318", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "-" }] }, "Radicacion" : "" } },{ "tipoParentesco" : "HI", "familiar" : { "legalID" : "1000128774", "tipoIdentificacion" : "3", "id" : "9999803457925822", "datosPersona" : { "nombrePrimero" : "JHON", "nombreSegundo" : "JAIRO", "apellidoPrimero" : "RICO", "apellidoSegundo" : "SANCHEZ", "nombre" : "JHON JAIRO RICO SANCHEZ", "nuip" : " ", "demografia" : { "nacimientoFecha" : "2002-11-12T00:00:00", "genero" : "M", "estadoCivil" : "SO" }, "motivoInactivacion" : { "id" : "0" } }, "Sucursal" : "", "comunicacionesCliente" : "", "Contacto" : "", "Afiliacion" : { "afiliacion" :[{ "cantidadVinculacion" : "1", "categoriaAfiliacion" : "A", "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2010-12-26T00:00:00", "inicioFecha" : "2010-08-06T00:00:00", "retiroFecha" : "2010-12-26T00:00:00", "valorVinculacion" : "0", "variableRetiro" : "CRETHIJ", "Programa" : { "programa" :[{ "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "0", "programaPadre" : "1021", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "20", "nombre" : "Desvinculación laboral" }, "clientePropietarioID" : "0", "tipoParentesco" : "HI", "sigla" : "CJ", "nombrePrograma" : "Hijos de Trabajador Dependiente", "diasParaReactivacion" : "0" }] }, "id" : "6692321", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "-" }] }, "Radicacion" : "" } }] }, "demografia" : { "nacimientoFecha" : "1977-12-15T00:00:00", "nacimientoLugar" : "", "genero" : "F", "estadoCivil" : "UL", "gradoEscolaridad" : "", "TitulosObtenidos" : "", "OficiosProfesiones" : "", "OtrosEstudios" : "" }, "categoriaAfiliacion" : "", "estadoAfiliacion" : "A", "motivoInactivacion" : { "id" : "0" } }, "Sucursal" : { "sucursal" :[{ "id" : "", "sucursalID" : "0", "nivelAdicional" : "N", "razonSocial" : "", "mantenimiento" : "" }] }, "comunicacionesCliente" : { "comunicacionCliente" :[{ "telefonos" : { "telefonoComunicacion" :[{ "tipoTelefono" : "1", "telefono" : "7191761", "extensionTelefono" : "0" }] }, "domicilios" : { "domicilioComunicacion" :[{ "barrio" : "PRIMAVERA", "tipoDomicilio" : "", "domicilio" : "TV 77A # 58A - 03 SUR", "codigoPostal" : "-", "localidad" : { "id" : "11001", "municipio" : { "id" : "-1", "nombre" : "", "departamento" : { "id" : "-" } }, "nombre" : "BOGOTA" }, "tipoAreaGeografica" : "U" }] }, "correosElectronicos" : "", "celulares" : "", "redesSociales" : "", "adicionalesContacto" : { "borradoEstado" : "A", "creacionFecha" : "2010-08-17T00:00:00", "ultimaNovedadFecha" : "2010-08-17T00:00:00", "identificador" : "2750692", "orden" : "1", "zonaBogota" : "19" } }] }, "Contacto" : "", "Afiliacion" : { "afiliacion" :[{ "beneficiarios" : "", "cantidadVinculacion" : "0", "categoriaAfiliacion" : "A", "motivoRetiro" : { "id" : "0", "nombre" : "-" }, "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1", "id" : "9999803427861117", "nombre" : "HUVER ANTONIO RICO SANCHEZ", "legalID" : "5972948", "tipoIdentificacion" : "1" },{ "tipoResponsable" : "2", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "3", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "4", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2008-05-05T00:00:00", "inicioFecha" : "2006-11-16T00:00:00", "retiroFecha" : "2008-05-05T00:00:00", "soloServicio" : "0", "textoVinculacion" : "", "valorVinculacion" : "0", "variableRetiro" : "CRETCOY", "Programa" : { "programa" :[{ "condicion" : "3", "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "10311", "programaPadre" : "1021", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "0", "nombre" : "-" }, "clientePropietarioID" : "0", "tipoParentesco" : "CY", "sigla" : "CJ", "tipoIdClientePropietario" : "0", "nombrePrograma" : "Cónyuge de Trabajador Dependiente", "nombreProgramaPadre" : "", "diasParaReactivacion" : "0" }] }, "id" : "6692322", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "1", "clienteID" : "" },{ "beneficiarios" : "", "cantidadVinculacion" : "0", "categoriaAfiliacion" : "", "motivoRetiro" : { "id" : "1", "nombre" : "-" }, "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1", "id" : "9999803427861117", "nombre" : "HUVER ANTONIO RICO SANCHEZ", "legalID" : "5972948", "tipoIdentificacion" : "1" },{ "tipoResponsable" : "2", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "3", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "4", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2008-05-05T00:00:00", "ingresoEmpresaFecha" : "2006-11-16T00:00:00", "inicioFecha" : "2006-11-16T00:00:00", "retiroFecha" : "2008-05-05T00:00:00", "soloServicio" : "0", "textoVinculacion" : "", "valorVinculacion" : "0", "variableRetiro" : "CRETCOY", "Programa" : { "programa" :[{ "condicion" : "3", "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "10311", "programaPadre" : "1021", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "1", "nombre" : "Voluntario por traslado de Caja" }, "clientePropietarioID" : "0", "tipoParentesco" : "CY", "sigla" : "CJ", "tipoIdClientePropietario" : "0", "nombrePrograma" : "Cónyuge de Trabajador Dependiente", "nombreProgramaPadre" : "", "diasParaReactivacion" : "0" }] }, "id" : "6692323", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "1", "clienteID" : "" },{ "beneficiarios" : "", "cantidadVinculacion" : "0", "categoriaAfiliacion" : "A", "motivoRetiro" : { "id" : "20", "nombre" : "-" }, "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1", "id" : "9999803427861117", "nombre" : "HUVER ANTONIO RICO SANCHEZ", "legalID" : "5972948", "tipoIdentificacion" : "1" },{ "tipoResponsable" : "2", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "3", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "4", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2013-05-29T00:00:00", "inicioFecha" : "2013-05-10T00:00:00", "retiroFecha" : "2013-05-29T00:00:00", "soloServicio" : "0", "textoVinculacion" : "", "valorVinculacion" : "0", "variableRetiro" : "CRETCOY", "Programa" : { "programa" :[{ "condicion" : "3", "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "10311", "programaPadre" : "1021", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "20", "nombre" : "Desvinculación laboral" }, "clientePropietarioID" : "0", "tipoParentesco" : "CY", "sigla" : "CJ", "tipoIdClientePropietario" : "0", "nombrePrograma" : "Cónyuge de Trabajador Dependiente", "nombreProgramaPadre" : "", "diasParaReactivacion" : "0" }] }, "id" : "11851719", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "1", "clienteID" : "" },{ "beneficiarios" : "", "cantidadVinculacion" : "240", "categoriaAfiliacion" : "A", "motivoRetiro" : { "id" : "20", "nombre" : "-" }, "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1", "id" : "9999803457925823", "nombre" : "NORFIDIA SANCHEZ SANCHEZ", "legalID" : "28868463", "tipoIdentificacion" : "1" },{ "tipoResponsable" : "2", "id" : "9999803423514845", "nombre" : " QUALITY DE COLOMBIA COOPERATIVA DE TRABAJO ASOCIADO ", "legalID" : "900099185", "tipoIdentificacion" : "2" },{ "tipoResponsable" : "3", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "4", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2010-12-26T00:00:00", "ingresoEmpresaFecha" : "2010-07-30T00:00:00", "inicioFecha" : "2010-08-06T00:00:00", "retiroFecha" : "2010-12-26T00:00:00", "soloServicio" : "0", "textoVinculacion" : "AUX ALMACEN", "valorVinculacion" : "520000", "variableRetiro" : "CRETRDP", "Programa" : { "programa" :[{ "condicion" : "2", "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "1021", "programaPadre" : "1011", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "20", "nombre" : "Desvinculación laboral" }, "clientePropietarioID" : "0", "tipoParentesco" : "TD", "sigla" : "CJ", "tipoIdClientePropietario" : "0", "nombrePrograma" : "Trabajador Dependiente", "nombreProgramaPadre" : "", "diasParaReactivacion" : "0" }] }, "id" : "6692324", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "1", "clienteID" : "" }] }, "Radicacion" : "" }, "atributosComunes" : { "beneficiarioEstado" : "false", "empresaEstado" : "false", "saltarFoneticoEstado" : "false", "indice" : "0", "edadMayor" : "false" } } }}';

    /** La respuesta exitosa del servicio sin beneficios. **/
    private static String responseSinBeneficiarios = '{ "CustomerMng_ConsultaCliente_Response" : { "Header" : { "RequestDate" : "2017-08-10T15:05:57.339-05:00", "ResponseDate" : "2017-08-10T15:05:57.686-05:00", "ResponseCode" : "0", "ResponseDesc" : "OK", "TransactionID" : "99910072100" }, "Body" : { "Vinculacion" : { "AfiliadoCaja" : "true", "AfiliacionConResponsable" : "false", "AfiliadoSalud" : "false", "AfiliadoPLC" : "false" }, "Cliente" : { "TipoIdentificacion" : "1", "NumeroIdentificacion" : "1050945086", "Id" : "9999805063497600", "datosPersona" : { "nombrePrimero" : "STIVEN", "nombreSegundo" : "JOSE", "apellidoPrimero" : "MOSQUERA", "apellidoSegundo" : "PUELLO", "nombre" : "STIVEN JOSE MOSQUERA PUELLO", "foneticoID" : "19860212NOSQUERAPUSTIVEN", "nuip" : "", "Familia" : "", "demografia" : { "nacimientoFecha" : "1986-02-12T00:00:00", "nacimientoLugar" : "", "genero" : "M", "estadoCivil" : "SO", "gradoEscolaridad" : "", "TitulosObtenidos" : "", "OficiosProfesiones" : "", "OtrosEstudios" : "" }, "categoriaAfiliacion" : "", "estadoAfiliacion" : "A", "motivoInactivacion" : { "id" : "0" } }, "Sucursal" : { "sucursal" :[{ "id" : "", "sucursalID" : "0", "nivelAdicional" : "N", "razonSocial" : "", "mantenimiento" : "" }] }, "comunicacionesCliente" : { "comunicacionCliente" :[{ "telefonos" : { "telefonoComunicacion" :[{ "tipoTelefono" : "1", "telefono" : "8118263", "extensionTelefono" : "0" }] }, "domicilios" : { "domicilioComunicacion" :[{ "barrio" : "PRADO PINZON", "tipoDomicilio" : "", "domicilio" : "KR 52 A # 139 A - 22", "codigoPostal" : "-", "localidad" : { "id" : "11001", "municipio" : { "id" : "-1", "nombre" : "", "departamento" : { "id" : "-" } }, "nombre" : "BOGOTA D.C." }, "tipoAreaGeografica" : "U" }] }, "correosElectronicos" : { "correoElectronico" :["ING0.STIVEN6X@XHOTMAIL0.COM"] }, "celulares" : { "celular" :["7167316771"] }, "redesSociales" : "", "opTinEmail" : "true", "opTinSMS" : "false", "adicionalesContacto" : { "borradoEstado" : "A", "creacionFecha" : "2014-02-08T00:00:00", "ultimaNovedadFecha" : "2014-02-08T00:00:00", "identificador" : "3065501", "orden" : "1", "zonaBogota" : "11" } }] }, "Contacto" : "", "Afiliacion" : { "afiliacion" :[{ "beneficiarios" : "", "cantidadVinculacion" : "240", "categoriaAfiliacion" : "B", "motivoRetiro" : { "id" : "20", "nombre" : "-" }, "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1", "id" : "9999805063497600", "nombre" : "STIVEN JOSE MOSQUERA PUELLO", "legalID" : "1050945086", "tipoIdentificacion" : "1" },{ "tipoResponsable" : "2", "id" : "6281102643350911", "nombre" : " EMPAQUES INDUSTRIALES DE COLOMBIA S A S ", "legalID" : "900406158", "tipoIdentificacion" : "2" },{ "tipoResponsable" : "3", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "4", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" }] }, "cmnt" : "H", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "1", "finFecha" : "2012-09-22T00:00:00", "ingresoEmpresaFecha" : "2012-07-03T00:00:00", "inicioFecha" : "2012-07-05T00:00:00", "retiroFecha" : "2012-09-22T00:00:00", "soloServicio" : "0", "textoVinculacion" : "COORDINADOR", "valorVinculacion" : "2200000", "variableRetiro" : "CRETRDP", "Programa" : { "programa" :[{ "condicion" : "2", "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "1021", "programaPadre" : "1011", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "20", "nombre" : "Desvinculación laboral" }, "clientePropietarioID" : "0", "tipoParentesco" : "TD", "sigla" : "CJ", "tipoIdClientePropietario" : "0", "nombrePrograma" : "Trabajador Dependiente", "nombreProgramaPadre" : "", "diasParaReactivacion" : "0" }] }, "id" : "10700167", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "1", "clienteID" : "" },{ "beneficiarios" : "", "cantidadVinculacion" : "240", "categoriaAfiliacion" : "B", "motivoRetiro" : { "id" : "0", "nombre" : "-" }, "ClienteResponsable" : { "clienteResponsable" :[{ "tipoResponsable" : "1", "id" : "9999805063497600", "nombre" : "STIVEN JOSE MOSQUERA PUELLO", "legalID" : "1050945086", "tipoIdentificacion" : "1" },{ "tipoResponsable" : "2", "id" : "9999803423241018", "nombre" : " PAYU COLOMBIA SAS ", "legalID" : "830109723", "tipoIdentificacion" : "2" },{ "tipoResponsable" : "3", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" },{ "tipoResponsable" : "4", "id" : "0", "nombre" : "", "legalID" : "0", "tipoIdentificacion" : "0" }] }, "cmnt" : "A", "actualizadoEstado" : "false", "nuevoEstado" : "false", "estado" : "0", "ingresoEmpresaFecha" : "2014-02-03T00:00:00", "inicioFecha" : "2014-02-04T00:00:00", "soloServicio" : "0", "textoVinculacion" : "ING PRUEBAS", "valorVinculacion" : "2720000", "variableRetiro" : "CRETRDP", "Programa" : { "programa" :[{ "condicion" : "2", "diasPaHisto" : "0", "tipoRadicacion" : "0", "edadReAuto" : "0", "genNuevoRadicadoEstado" : "false", "grupo" : "0", "id" : "1021", "programaPadre" : "1011", "indicadorProgramaEstado" : "0", "indicadorVinculacionEstado" : "0", "manejaResponsable1PersonaEstado" : "false", "manejaResponsable2EmpresaEstado" : "false", "motivoRetiroOpcional" : { "id" : "0", "nombre" : "-" }, "clientePropietarioID" : "0", "tipoParentesco" : "TD", "sigla" : "CJ", "tipoIdClientePropietario" : "0", "nombrePrograma" : "Trabajador Dependiente", "nombreProgramaPadre" : "", "diasParaReactivacion" : "0" }] }, "id" : "12918839", "motivoInactivacion" : { "id" : "0" }, "estadoAfiliacion" : "0", "clienteID" : "" }] }, "Radicacion" : "" }, "atributosComunes" : { "fidelizacionFecha" : "2014-12-19T00:00:00", "beneficiarioEstado" : "false", "empresaEstado" : "false", "saltarFoneticoEstado" : "false", "indice" : "0", "edadMayor" : "false" } } }}';

    /** La respuesta exitosa del servicio sin vinculaciones. **/
    private static String responseSinVinculaciones = '{ "CustomerMng_ConsultaCliente_Response" : { "Header" : { "RequestDate" : "2017-08-10T15:23:26.186-05:00", "ResponseDate" : "2017-08-10T15:23:26.465-05:00", "ResponseCode" : "1", "ResponseDesc" : "El cliente persona no existe", "TransactionID" : "99910072100" }, "Body" : { "Vinculacion" : { "AfiliadoCaja" : "false", "AfiliacionConResponsable" : "false", "AfiliadoSalud" : "false", "AfiliadoPLC" : "false" }, "Cliente" : { "TipoIdentificacion" : "-1", "NumeroIdentificacion" : "-1", "Id" : "-1", "datosPersona" : { "nombrePrimero" : "-", "nombreSegundo" : "", "apellidoPrimero" : "-", "apellidoSegundo" : "", "nombre" : "", "foneticoID" : "", "nuip" : "", "Familia" : "", "demografia" : { "nacimientoLugar" : "", "genero" : "", "estadoCivil" : "", "gradoEscolaridad" : "", "TitulosObtenidos" : "", "OficiosProfesiones" : "", "OtrosEstudios" : "" }, "categoriaAfiliacion" : "", "estadoAfiliacion" : "" }, "Sucursal" : { "sucursal" :[{ "id" : "", "nivelAdicional" : "", "razonSocial" : "", "mantenimiento" : "" }] }, "comunicacionesCliente" : { "comunicacionCliente" :[{ "correosElectronicos" : "", "celulares" : "" }] }, "Contacto" : "", "Afiliacion" : "", "Radicacion" : "" }, "atributosComunes" : "" } }}';



    /**
     * @description Metodo encargado de cargar la data inicial util par atodos los test.
     */
    @TestSetup
    private static void loadInitialData() {

        /*CON_TABLAS_DOMINIO__c tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_TIPO_ID_GRP_FAMILIAR, '3','CC',
                        Label.COM_NAME_TIPO_ID_GRP_FAMILIAR);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                ('COM_NAME_TIPO_ID_GRP_FAMILIAR2', '1','TI',
                        Label.COM_NAME_TIPO_ID_GRP_FAMILIAR);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_CIVIL_GRP_FAMILIAR, 'SO','Soltero',
                        Label.COM_NAME_ESTADO_CIVIL_GRP_FAMILIAR);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_GRP_FAMILIAR, 'HI','Hijo',
                        Label.COM_NAME_ESTADO_GRP_FAMILIAR);
        insert tablasDominio;


        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_GRP_FAMILIAR, '1','Activo',
                        Label.COM_NAME_ESTADO_GRP_FAMILIAR);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_PARENTEZCO_GRP_FAMILIAR, 'HI','Hijo',
                        Label.COM_NAME_PARENTEZCO_GRP_FAMILIAR);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_EMPRESA, '1','Activo',
                        Label.COM_NAME_ESTADO_EMPRESA);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_BENEFICIARIO, '1','Activo',
                        Label.COM_NAME_ESTADO_BENEFICIARIO);
        insert tablasDominio;


        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_VINCULACION, '1','Activo',
                        Label.COM_NAME_ESTADO_VINCULACION);
        insert tablasDominio;

        tablasDominio = COM_DataGenerator_cls.generateTableDominio
                (Label.COM_NAME_ESTADO_VINCULACION, '1','Activo',
                        Label.COM_NAME_ESTADO_VINCULACION);
        insert tablasDominio;

        COM_ConfiguracionHeaderWS__c configuracionHeaderWS = new COM_ConfiguracionHeaderWS__c();
        configuracionHeaderWS.name = Label.COM_WS_ConsultarClienteGC;
        configuracionHeaderWS.COM_Usuario__c = 'cmp';
        configuracionHeaderWS.COM_Password__c = '12345';
        configuracionHeaderWS.COM_InputSystem__c = '12345';
        configuracionHeaderWS.COM_DireccionIp__c = '12345';

        insert configuracionHeaderWS;

        COM_ConfiguracionWebService__c configuracionWebService = new COM_ConfiguracionWebService__c();
        configuracionWebService.COM_Metodo__c = 'GET';
        configuracionWebService.COM_Puerto__c = 80;
        configuracionWebService.COM_DireccionIp__c = 'aasa';
        configuracionWebService.COM_Recurso__c='ssasa';
        configuracionWebService.name = Label.COM_WS_ConsultarClienteGC;

        insert configuracionWebService;
        */
        //no es necesario crear configuraciones personalizada
    }

    /**
     * @description metodo encargado de probar la funcionalidad del controlador de historial.
     */
    @IsTest
    private static void testHistorialVinculacionesController() {
        Account account = new Account();
        account.COM_TipoIdentificacion__c = '3';
        account.COM_Numero_de_identificacion__c = '28868463';
        account.Name = 'hola';
        insert account;
        ApexPages.StandardController controller = new ApexPages.StandardController(account);

        Test.startTest();
        COM_CalloutGenericRestMock_tst tstMock = new
                COM_CalloutGenericRestMock_tst(responseSuccess, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_ConsultarHistVinculaciones_ctr consultarHistVinculacionesCtr = new
                COM_ConsultarHistVinculaciones_ctr(controller);
        COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO historial =
                consultarHistVinculacionesCtr.getHistorialVinculaciones();

        List<COM_ConsultarHistVinculaciones_cls.GrupoFamiliarDTO> grupoFamiliar = historial.getGrupoFamiliar();
        System.assertEquals(0, grupoFamiliar.size());
        if(!grupoFamiliar.isEmpty()){
            compareGrupo(grupoFamiliar.get(0),'1000115711', 'CC', 'YEFER ESTEBAN RICO SANCHEZ',
                    '25/02/1997', 'Hijos de Trabajador Dependiente', 'Activo','A','10/11/2010',
                    '26/12/2010','26/12/2010', null,'Hijo');

            compareGrupo(grupoFamiliar.get(1),'1000128774', 'CC', 'JHON JAIRO RICO SANCHEZ',
                    '12/11/2002', 'Hijos de Trabajador Dependiente', 'Activo','A','06/08/2010',
                    '26/12/2010','26/12/2010', null,'Hijo');
        }
        List<COM_ConsultarHistVinculaciones_cls.EmpresasDTO> empresas =
                historial.getEmpresas();

        System.assertEquals(0, empresas.size());
        if(!empresas.isEmpty()){
            compareEmpresa(empresas.get(0), null, '16/11/2006', null, '05/05/2008',
                    '05/05/2008', 'Activo','A');

            compareEmpresa(empresas.get(1), null, '16/11/2006', '16/11/2006', '05/05/2008',
                    '05/05/2008', 'Activo',null);

            compareEmpresa(empresas.get(2), null, '10/05/2013', null, '29/05/2013',
                    '29/05/2013', 'Activo','A');

            compareEmpresa(empresas.get(3), null, '06/08/2010', '30/07/2010', '26/12/2010',
                    '26/12/2010', 'Activo','A');
        }
        List<COM_ConsultarHistVinculaciones_cls.BeneficiarioDTO> beneficiarios =
                historial.getBeneficiarios();

        System.assertEquals(0, beneficiarios.size());
        if(!beneficiarios.isEmpty()){
            compareBeneficiacio(beneficiarios.get(0), null, '10/11/2010', null, '26/12/2010',
                    '26/12/2010', 'Activo',null, null, 'A', 'CC 1000115711', null, null);

            compareBeneficiacio(beneficiarios.get(1), null, '06/08/2010', null, '26/12/2010',
                    '26/12/2010', 'Activo', null, null, 'A','CC 1000128774', null, null);
        }

        List<COM_ConsultarHistVinculaciones_cls.VinculacionDTO> vinculaciones =
                historial.getVinculaciones();

        System.assertEquals(0, vinculaciones.size());
        if(!vinculaciones.isEmpty()){
            compareVinculacion(vinculaciones.get(0), null, null, '05/05/2008',
                    'Activo',null, 'A', '5972948', null, null);

            compareVinculacion(vinculaciones.get(1), null, '16/11/2006', '05/05/2008',
                    'Activo',null, null, '5972948', null, null);

            compareVinculacion(vinculaciones.get(2), null, null, '29/05/2013',
                    'Activo',null, 'A', '5972948', null, null);

            compareVinculacion(vinculaciones.get(3), null, '30/07/2010', '26/12/2010',
                    'Activo',null, 'A', '28868463',
                    'QUALITY DE COLOMBIA COOPERATIVA DE TRABAJO ASOCIADO', null);
        }


        consultarHistVinculacionesCtr.consultarVinculaciones();
        Test.stopTest();

    }

    /**
     * @description Metodo responsable de probar la funcionalidad del metodo encontrarHistorialVinculaciones.
     */
    @isTest
    private static void testEncontrarHistorialVinculaciones() {
        Test.startTest();
        COM_CalloutGenericRestMock_tst tstMock = new
                COM_CalloutGenericRestMock_tst(responseSuccess, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);

        COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO historial =
                consultarHistVinculaciones_cls.encontrarHistorialVinculaciones(3, 28868463);

        List<COM_ConsultarHistVinculaciones_cls.GrupoFamiliarDTO> grupoFamiliar = historial.getGrupoFamiliar();
        System.assertEquals(2, grupoFamiliar.size());
        compareGrupo(grupoFamiliar.get(0),'1000115711', '', 'YEFER ESTEBAN RICO SANCHEZ',
                '25/02/1997', 'Hijos de Trabajador Dependiente', 'Retirado','A','10/11/2010',
                '26/12/2010','26/12/2010', null,'HI');

        compareGrupo(grupoFamiliar.get(1),'1000128774', '', 'JHON JAIRO RICO SANCHEZ',
                '12/11/2002', 'Hijos de Trabajador Dependiente', 'Inactivo','A','06/08/2010',
                '26/12/2010','26/12/2010', null,'HI');

        List<COM_ConsultarHistVinculaciones_cls.EmpresasDTO> empresas =
                historial.getEmpresas();

        System.assertEquals(4, empresas.size());

        compareEmpresa(empresas.get(0), null, '16/11/2006', null, '05/05/2008',
                '05/05/2008', '','A');

        compareEmpresa(empresas.get(1), null, '16/11/2006', '16/11/2006', '05/05/2008',
                '05/05/2008', '',null);

        compareEmpresa(empresas.get(2), null, '10/05/2013', null, '29/05/2013',
                '29/05/2013', '','A');

        compareEmpresa(empresas.get(3), null, '06/08/2010', '30/07/2010', '26/12/2010',
                '26/12/2010', '','A');

        List<COM_ConsultarHistVinculaciones_cls.BeneficiarioDTO> beneficiarios =
                historial.getBeneficiarios();

        System.assertEquals(2, beneficiarios.size());

        compareBeneficiacio(beneficiarios.get(0), null, '10/11/2010', null, '26/12/2010',
                '26/12/2010', '',null, null, 'A', '1000115711', null, null);

        compareBeneficiacio(beneficiarios.get(1), null, '06/08/2010', null, '26/12/2010',
                '26/12/2010', '', null, null, 'A','1000128774', null, null);


        List<COM_ConsultarHistVinculaciones_cls.VinculacionDTO> vinculaciones =
                historial.getVinculaciones();

        System.assertEquals(4, vinculaciones.size());

        compareVinculacion(vinculaciones.get(0), 'Cónyuge de Trabajador Dependiente', null, '05/05/2008',
               'Inactivo',null, 'A', '5972948', null, null);

        compareVinculacion(vinculaciones.get(1), 'Cónyuge de Trabajador Dependiente', '16/11/2006', '05/05/2008',
                'Inactivo',null, null, '5972948', null, null);

        compareVinculacion(vinculaciones.get(2), 'Cónyuge de Trabajador Dependiente', null, '29/05/2013',
                'Inactivo',null, 'A', '5972948', null, null);

        compareVinculacion(vinculaciones.get(3), 'Trabajador Dependiente', '30/07/2010', '26/12/2010',
                'Inactivo',null, 'A', '28868463',
                'QUALITY DE COLOMBIA COOPERATIVA DE TRABAJO ASOCIADO', null);

        Test.stopTest();
    }


    /**
     * @description Metodo responsable de probar la funcionalidad del metodo encontrarGrupoFamiliarPorAfiliado.
     */
    @isTest
    private static void testEncontrarGrupoFamiliarPorAfiliado() {
        Test.startTest();
        COM_CalloutGenericRestMock_tst tstMock = new
                COM_CalloutGenericRestMock_tst(responseSuccess, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar
                (3, 28868463);
        List<COM_ConsultarHistVinculaciones_cls.GrupoFamiliarDTO> grupoFamiliar =
                consultarHistVinculaciones_cls.encontrarGrupoFamiliarPorAfiliado(response);
        System.assertEquals(2, grupoFamiliar.size());
        compareGrupo(grupoFamiliar.get(0),'1000115711', '', 'YEFER ESTEBAN RICO SANCHEZ',
                '25/02/1997', 'Hijos de Trabajador Dependiente', 'Retirado','A','10/11/2010',
                '26/12/2010','26/12/2010', null,'HI');

        compareGrupo(grupoFamiliar.get(1),'1000128774', '', 'JHON JAIRO RICO SANCHEZ',
                '12/11/2002', 'Hijos de Trabajador Dependiente', 'Inactivo','A','06/08/2010',
                '26/12/2010','26/12/2010', null,'HI');
        /* Buscar con grupo familiar vacio. */
        tstMock = new
                COM_CalloutGenericRestMock_tst(responseSinBeneficiarios, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        response = consumer.Consultar
                (3, 28868463);
        grupoFamiliar =
                consultarHistVinculaciones_cls.encontrarGrupoFamiliarPorAfiliado(response);
        System.assert(grupoFamiliar.isEmpty());
        Test.stopTest();
    }




    /**
     * @description metodo encargado de comparar grupo.
     */
    private static void compareGrupo
            (COM_ConsultarHistVinculaciones_cls.GrupoFamiliarDTO grupo, String identification,
                    String tipoId, String nombre, String fechaNacimiento, String programa, String estado,
                    String categoria, String fechaVinculacion, String fechaFinVinculacion,
                    String fechaRetiro, String idSubsidio,
                    String parentesco) {
        System.assertEquals(identification, grupo.getIdentificacion());
        System.assertEquals(tipoId, grupo.getTipoIdentificacion());
        System.assertEquals(nombre, grupo.getNombre());
        System.assertEquals(fechaNacimiento, grupo.getNacimientoFecha());
        System.assertEquals(programa, grupo.getNombrePrograma());
        
        System.assertEquals(categoria, grupo.getCategoriaAfiliacion());
        System.assertEquals(fechaVinculacion, grupo.getFechaVinculacion());
        System.assertEquals(fechaFinVinculacion, grupo.getFechaFinVinculacion());
        System.assertEquals(fechaRetiro, grupo.getFechaRetiro());
        //System.assertEquals(idSubsidio, grupo.getIdentificadorSubsidio());
        System.assertEquals(parentesco, grupo.getTipoParentesco());
    }


    /**
     * @description Metodo responsable de probar la funcionalidad del metodo encontrarEmpresasPorAfiliado.
     */
    @isTest
    private static void testEncontrarEmpresasPorAfiliado() {
        Test.startTest();
        COM_CalloutGenericRestMock_tst tstMock = new
                COM_CalloutGenericRestMock_tst(responseSuccess, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar
                (3, 28868463);

        List<COM_ConsultarHistVinculaciones_cls.EmpresasDTO> empresas =
                consultarHistVinculaciones_cls.encontrarEmpresasPorAfiliado(response);

        System.assertEquals(4, empresas.size());

        compareEmpresa(empresas.get(0), null, '16/11/2006', null, '05/05/2008',
                '05/05/2008', '','A');

        compareEmpresa(empresas.get(1), null, '16/11/2006', '16/11/2006', '05/05/2008',
                '05/05/2008', '',null);

        compareEmpresa(empresas.get(2), null, '10/05/2013', null, '29/05/2013',
                '29/05/2013', '','A');

        compareEmpresa(empresas.get(3), null, '06/08/2010', '30/07/2010', '26/12/2010',
                '26/12/2010', '','A');


        /* Buscar con empresas  vacio. */
        tstMock = new
                COM_CalloutGenericRestMock_tst(responseSinVinculaciones, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        response = consumer.Consultar
                (3, 28868463);
        empresas =
                consultarHistVinculaciones_cls.encontrarEmpresasPorAfiliado(response);
        System.assert(empresas.isEmpty());
        Test.stopTest();
    }


    /**
     * @description metodo encargado de comparar empresa.
     */
    private static void compareEmpresa
            (COM_ConsultarHistVinculaciones_cls.EmpresasDTO empresa, String tipoVinculacion,
                    String fechaVinculacion,
                    String fechaIngresoEmpresa, String fechaFinVinculacion,
                    String fechaRetiro, String estado,
                    String categoria) {

        System.assertEquals(tipoVinculacion, empresa.getTipoVinculacion());
        System.assertEquals(fechaVinculacion, empresa.getFechaVinculacion());
        System.assertEquals(fechaIngresoEmpresa, empresa.getFechaIngresoEmpresa());
        System.assertEquals(fechaFinVinculacion, empresa.getFechaFinVinculacion());
        System.assertEquals(fechaRetiro, empresa.getFechaRetiro());
        System.assertEquals(estado, empresa.getEstadoAfiliacion());
        System.assertEquals(categoria, empresa.getCategoriaAfiliacion());
    }



    /**
     * @description Metodo responsable de probar la funcionalidad del metodo
     * encontrarBeneficiariosPorAfiliado.
     */
    @isTest
    private static void testEncontrarBeneficiariosPorAfiliado() {
        Test.startTest();
        COM_CalloutGenericRestMock_tst tstMock = new
                COM_CalloutGenericRestMock_tst(responseSuccess, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar
                (3, 28868463);

                System.debug('testEncontrarBeneficiariosPorAfiliado' + response);

        List<COM_ConsultarHistVinculaciones_cls.BeneficiarioDTO> beneficiarios =
                consultarHistVinculaciones_cls.encontrarBeneficiariosPorAfiliado(response, null);

        System.assertEquals(2, beneficiarios.size());

        compareBeneficiacio(beneficiarios.get(0), null, '10/11/2010', null, '26/12/2010',
                '26/12/2010', '', null, null, 'A', '1000115711', null, null);

        compareBeneficiacio(beneficiarios.get(1), null, '06/08/2010', null, '26/12/2010',
                '26/12/2010', '', null, null, 'A','1000128774', null, null);



        /* Buscar con empresas  vacio. */
        tstMock = new
                COM_CalloutGenericRestMock_tst(responseSinBeneficiarios, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        response = consumer.Consultar
                (3, 28868463);
        beneficiarios =
                consultarHistVinculaciones_cls.encontrarBeneficiariosPorAfiliado(response, null);
        System.assert(beneficiarios.isEmpty());
        Test.stopTest();
    }


    /**
     * @description metodo encargado de comparar beneficiario.
     */
    private static void compareBeneficiacio
            (COM_ConsultarHistVinculaciones_cls.BeneficiarioDTO beneficiario,
                    String tipoVinculacion,
                    String fechaVinculacion,
                    String fechaIngresoEmpresa, String fechaFinVinculacion,
                    String fechaRetiro, String estado, String salario, String horas,
                    String categoria, String trabajador, String empleador,
                                                                String actualizar) {

        System.assertEquals(tipoVinculacion, beneficiario.getTipoVinculacion());
        System.assertEquals(fechaVinculacion, beneficiario.getFechaVinculacion());
        System.assertEquals(fechaIngresoEmpresa, beneficiario.getFechaIngresoEmpresa());
        System.assertEquals(fechaFinVinculacion, beneficiario.getFechaFinVinculacion());
        System.assertEquals(fechaRetiro, beneficiario.getFechaRetiro());
        System.assertEquals(estado, beneficiario.getEstadoAfiliacion());
        System.assertEquals(salario, beneficiario.getSalario());
        System.assertEquals(horas, beneficiario.getHorasLab());
        System.assertEquals(categoria, beneficiario.getCategoriaAfiliacion());

        System.debug(trabajador == beneficiario.getTrabajador() + ' >==< ' +beneficiario.getTrabajador());
        System.assertEquals(trabajador.trim(), beneficiario.getTrabajador().trim());
        System.assertEquals(empleador, beneficiario.getEmpleador());
        System.assertEquals(actualizar, beneficiario.getActualizar());
    }

    /**
     * @description Metodo responsable de probar la funcionalidad del metodo
     * encontrarVinculacionesPorAfiliado.
     */
    @isTest
    private static void testEncontrarVinculacionesPorAfiliado() {
        Test.startTest();
        COM_CalloutGenericRestMock_tst tstMock = new
                COM_CalloutGenericRestMock_tst(responseSuccess, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar(3, 28868463);

        List<COM_ConsultarHistVinculaciones_cls.VinculacionDTO> vinculaciones =
                consultarHistVinculaciones_cls.encontrarVinculacionesPorAfiliado(response);

        System.assertEquals(4, vinculaciones.size());

        compareVinculacion(vinculaciones.get(0), 'Cónyuge de Trabajador Dependiente', null, '05/05/2008',
                 'Retirado',null, 'A', '5972948', null, null);

        compareVinculacion(vinculaciones.get(1), 'Cónyuge de Trabajador Dependiente', '16/11/2006', '05/05/2008',
                'Inactivo',null, null, '5972948', null, null);

        compareVinculacion(vinculaciones.get(2), 'Cónyuge de Trabajador Dependiente', null, '29/05/2013',
                'Inactivo',null, 'A', '5972948', null, null);

        compareVinculacion(vinculaciones.get(3), 'Trabajador Dependiente', '30/07/2010', '26/12/2010',
                'Inactivo',null, 'A', '28868463',
                'QUALITY DE COLOMBIA COOPERATIVA DE TRABAJO ASOCIADO', null);



        /* Buscar con empresas  vacio. */
        tstMock = new
                COM_CalloutGenericRestMock_tst(responseSinVinculaciones, 200, 'OK');
        Test.setMock(HttpCalloutMock.class, tstMock);
        response = consumer.Consultar
                (3, 28868463);
        vinculaciones =
                consultarHistVinculaciones_cls.encontrarVinculacionesPorAfiliado(response);
        System.assert(vinculaciones.isEmpty());
        Test.stopTest();
    }


    /**
     * @description metodo encargado de comparar beneficiario.
     */
    private static void compareVinculacion
            (COM_ConsultarHistVinculaciones_cls.VinculacionDTO vinculacion,
                    String tipoVinculacion,
                    String fechaIngresoEmpresa, String fechaFinVinculacion,
                    String estado, String salario,
                    String categoria, String trabajador, String empleador,
                    String actualizar) {

        System.assertEquals(tipoVinculacion.trim(), vinculacion.getTipoVinculacion().trim());
        System.assertEquals(fechaIngresoEmpresa, vinculacion.getFechaIngresoEmpresa());
        System.assertEquals(fechaFinVinculacion, vinculacion.getFechaFin());
        
        System.assertEquals(salario, vinculacion.getSalario());
        System.assertEquals(categoria, vinculacion.getCategoriaAfiliacion());
        System.assertEquals(trabajador.trim(), vinculacion.getTrabajador().trim());
        System.assertEquals(empleador, vinculacion.getEmpleador());
        System.assertEquals(actualizar, vinculacion.getActualizar());
    }
}