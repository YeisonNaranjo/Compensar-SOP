/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene los datos para la integracion de Crear Prospecto
* 					y Oportunidades de Vinculación en SFDC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    01/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
global class COM_WrapperCrearProspectoRequest_cls {
	
	public DatosProspecto DatosProspecto { get; set; }
	
	public class DatosSolicitud
	{
		public long idSolicitud { get; set; }
		public String tipoVinculacion { get; set; }
		public String tipoSolicitud { get; set; }
		public String estado { get; set; }
		public DateTime fechaCreacion { get; set; }
		public DateTime fechaUltimaMod { get; set; }
		public DateTime fechaVigencia { get; set; }
		public String emailSolicitud { get; set; }
		public Integer pasoSolicitud { get; set; }
	}
	
	public class DatosBasicos
	{
		public String tipoIdentificacion { get; set; }
		public String numeroIdentificacion { get; set; }
		public String primerNombre { get; set; }
		public String otrosNombres { get; set; }
		public String primerApellido { get; set; }
		public String segundoApellido { get; set; }
		public String razonSocial { get; set; }
		public String digitoVerificacion { get; set; }
		public Integer edad { get; set; }
		public DateTime fechaNacimiento { get; set; }
		public DateTime fechaMatricula { get; set; }
		public String genero { get; set; }
		public String estadoCivil { get; set; }
		public String lugarNacimiento { get; set; }
		public DateTime fechaExpedicionDoc { get; set; }
		public String lugarExpedicionDoc { get; set; }
		public boolean cabezaFamilia { get; set; }
		public boolean cotizante { get; set; }
		public String cajaCompensacion { get; set; }
		public String tipoIdentificacionTr { get; set; }
		public String numeroIdentificacionTr { get; set; }
		public String nombreTr { get; set; }
		public String parentescoTr { get; set; }
		public String claseParentescoTr { get; set; }
		public String valorMensualidad { get; set; }
		public String numeroResolucion { get; set; }
		public DateTime fechaResolucion { get; set; }
	}
	
	public class DatosContacto
	{
		public String direccion { get; set; }
		public String tipoDireccion { get; set; }
		public String localidad { get; set; }
		public String barrio { get; set; }
		public String ciudad { get; set; }
		public String telefonoPrincipal { get; set; }
		public String celular { get; set; }
		public String email { get; set; }
		public String fax { get; set; }
	}
	
	public class DatosEmpresa
	{
		public String actividadEconomica { get; set; }
		public String arl { get; set; }
		public boolean afiliadoCajaAnterior { get; set; }
		public String emailEmpresa { get; set; }
		public String valorNomina { get; set; }
		public String ciudadCausacionSalarios { get; set; }
		public Integer numeroEmpleados { get; set; }
		public Integer numeroHijosSubsidio { get; set; }
		public Integer numeroTrabajadoresHombres { get; set; }
		public Integer numeroTrabajadoresMujeres { get; set; }
		public Integer numeroTrabajadoresSubsidio { get; set; }
		public Integer numeroHijosDescapacitados { get; set; }
		public String actividadSENA { get; set; }
		public String claseEmpresa { get; set; }
		public String sectorEconomico { get; set; }
		public String relacionEmpresas { get; set; }
		public String ciiu { get; set; }
	}
	
	public class DatosEntidadPagadora
	{
		public String razonSocialEP { get; set; }
		public String tipoIdentificacionEP { get; set; }
		public String numeroIdentificacionEP { get; set; }
		public String direccionEP { get; set; }
		public String localidadEP { get; set; }
		public String barrioEP { get; set; }
		public String ciudadEP { get; set; }
		public String telefonoEP { get; set; }
		public String celularEP { get; set; }
		public String emailEP { get; set; }
	}
	
	public class DatosRepresentanteLegal
	{
		public String primerNombreRL { get; set; }
		public String otrosNombresRL { get; set; }
		public String primerApellidoRL { get; set; }
		public String segundoApellidoRL { get; set; }
		public String cargoRL { get; set; }
		public String celularRL { get; set; }
		public String tipoIdentificacionRL { get; set; }
		public String numeroIdentificacionRL { get; set; }
		public DateTime fechaNacimientoRL { get; set; }
		public String generoRL { get; set; }
		public String nombreContacto { get; set; }
		public String tipoIdentificacionContacto { get; set; }
		public String numeroIdentificacionContacto { get; set; }
		public String generoContacto { get; set; }
		public String celularContacto { get; set; }
		public String cargoContacto { get; set; }
	}
	
	public class InformacionLaboral
	{
		public String tipoIdentificacionEmp { get; set; }
		public String numeroIdentificacionEmp { get; set; }
		public String nombreEmp { get; set; }
		public String telefonoEmp { get; set; }
		public DateTime fechaIngresoEmp { get; set; }
		public String ciudadEmp { get; set; }
		public Integer horaLaborMesEmp { get; set; }
		public String cargoEmp { get; set; }
		public String dependenciaEmp { get; set; }
		public String centroCostoEmp { get; set; }
		public String empresaSimultanea { get; set; }
		public String salarioEmp { get; set; }
		public boolean trabajadorDomestico { get; set; }
	}
	
	public class DatosProspecto
	{
		public DatosSolicitud DatosSolicitud { get; set; }
		public DatosBasicos DatosBasicos { get; set; }
		public DatosContacto DatosContacto { get; set; }
		public DatosEmpresa DatosEmpresa { get; set; }
		public DatosEntidadPagadora DatosEntidadPagadora { get; set; }
		public DatosRepresentanteLegal DatosRepresentanteLegal { get; set; }
		public InformacionLaboral InformacionLaboral { get; set; }
	}
    
}