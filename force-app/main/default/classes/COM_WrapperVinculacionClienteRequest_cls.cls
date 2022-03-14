/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase Wrapper que contiene los datos para la integracion de Vinculación de Clientes en GC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    03/08/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   2.0    06/01/2022      Yeison Naranjo		                Inclusión nuevo campo NOLA 00030781
****************************************************************************************************************/
public with sharing class COM_WrapperVinculacionClienteRequest_cls {
    
    public CustomerAdminProcesarVinculacionRequest CustomerAdmin_ProcesarVinculacion_Request { get; set; }
    
    public COM_WrapperVinculacionClienteRequest_cls(){
        CustomerAdmin_ProcesarVinculacion_Request = new CustomerAdminProcesarVinculacionRequest();
    }
    
    public class Demografia
    {
        public String nacimientoFecha { get; set; }
        public String nacimientoLugar { get; set; }
        public String genero { get; set; }
        public String estadoCivil { get; set; }
        public boolean cabezaFamiliaEstado { get; set; }
        public String gradoEscolaridad { get; set; }
        public String titulosObtenidos { get; set; }
        public String oficiosProfesiones { get; set; }
        public String otrosEstudios { get; set; }
        public boolean hijosEstado { get; set; }
        public Integer hijosCantidad { get; set; }
        public Integer personasACargoCantidad { get; set; }
        public boolean discapacidadEstado { get; set; }
    }
    
    public class MotivoInactivacion
    {
        public Integer id { get; set; }
    }
    
      public class Familia
      {
          public String tipoParentesco { get; set; }
          public String familiar { get; set; }
      }
    
    public class DatosPersona
    {
        public String nombrePrimero { get; set; }
        public String nombreSegundo { get; set; }
        public String apellidoPrimero { get; set; }
        public String apellidoSegundo { get; set; }
        public String nombre { get; set; }
        public String foneticoID { get; set; }
        public String nuip { get; set; }
        public Familia familia { get; set; }
        public Demografia demografia { get; set; }
        public long tipoVinculacion { get; set; }
        public String categoriaAfiliacion { get; set; }
        public String estadoAfiliacion { get; set; }
        public MotivoInactivacion motivoInactivacion { get; set; }
    }
    
    public class DatosEmpresa
    {
        public Integer tipoEmpresa { get; set; }
        public String tipoActividadEconomica { get; set; }
        public Integer sectorEconomico { get; set; }
        public String razonSocial { get; set; }
        public String nombreComercial { get; set; }
        public String estadoAfiliacion { get; set; }
        /* Inicio 2.0 */
        public Integer Responsabilidades_Fiscales { get; set; }
        /* Fin 2.0 */
        public Integer digitoVerificadorLegal { get; set; }
        public Date constitucionFecha { get; set; }
        public String grupoEmpresarial { get; set; }
        public String agremiacion { get; set; }
        public MotivoInactivacion motivoInactivacion { get; set; }
    }
    
    public class Sucursal
    {
        public long id { get; set; }
        public long sucursalID { get; set; }
        public long centroCostosID { get; set; }
        public String nivelAdicional { get; set; }
        public String razonSocial { get; set; }
        public String mantenimiento { get; set; }
    }
     
    public class Sucursales
    {
        public List<Sucursal> sucursal { get; set; }
    }
    
    public class TelefonoComunicacion
    {
        public String tipoTelefono { get; set; }
        public long telefono { get; set; }
        public long extensionTelefono { get; set; }
    }
    
    public class Telefonos 
    {
        public List<TelefonoComunicacion> telefonoComunicacion { get; set; }
    }
    
    public class Departamento
    {
        public String id { get; set; }
        public String nombre { get; set; }
    }
    
    public class Municipio
    {
        public Integer id { get; set; }
        public String nombre { get; set; }
        public Departamento departamento { get; set; }
    }
    
    public class Localidad
    {
        public Integer id { get; set; }
        public Municipio municipio { get; set; }
        public String nombre { get; set; }
    }
    
    public class DomicilioComunicacion
    {
        public String barrio { get; set; }
        public String casillaCorreo { get; set; }
        public String tipoDomicilio { get; set; }
        public String domicilio { get; set; }
        public String codigoPostal { get; set; }
        public Localidad localidad { get; set; }
        public String tipoAreaGeografica { get; set; }
    }
    
    public class Domicilios
    {
        public List<DomicilioComunicacion> domicilioComunicacion { get; set; }
    }
    
    public class AdicionalesContacto
    {
        public String borradoEstado { get; set; }
        public String creacionFecha { get; set; }
        public String ultimaNovedadFecha { get; set; }
        public String identificador { get; set; }
        public Integer orden { get; set; }
        public Integer zonaBogota { get; set; }
    }

    public class RedesSociales 
    {
        public List<String> redesSociales { get; set; }
    }

    public class CorreosElectronicos 
    {
        public List<String> correoElectronico { get; set; }
    }
    
    public class ComunicacionCliente
    {
        public Telefonos telefonos { get; set; }
        public Domicilios domicilios { get; set; }
        public AdicionalesContacto adicionalesContacto { get; set; }
        public CorreosElectronicos correosElectronicos { get; set; }
        public RedesSociales redesSociales { get; set; }
    }
    
    public class ComunicacionesCliente
    {
        public List<ComunicacionCliente> comunicacionCliente { get; set; }
    }
    
    public class ClienteResponsable
    {
        public String tipoResponsable { get; set; }
        public long centroCostosID { get; set; }
        public long sucursalID { get; set; }
        public String id { get; set; }
        public String nombre { get; set; }
        public String legalID { get; set; }
        public String tipoIdentificacion { get; set; }
    }
    
    public class ClientesResponsables
    {
        public List<ClienteResponsable> clienteResponsable { get; set; }
    }
    
    public class MotivoRetiroOpcional
    {
        public Integer id { get; set; }
        public String nombre { get; set; }
    }
    
    public class Programa
    {
        public Integer condicion { get; set; }
        public Integer diasPaHisto { get; set; }
        public Integer diasPaReAuto { get; set; }
        public Integer tipoRadicacion { get; set; }
        public Integer edadReAuto { get; set; }
        public Date creacionFecha { get; set; }
        public boolean genNuevoRadicadoEstado { get; set; }
        public Integer grupo { get; set; }
        public long id { get; set; }
        public long programaPadre { get; set; }
        public Integer indicadorProgramaEstado { get; set; }
        public Integer indicadorVinculacionEstado { get; set; }
        public boolean manejaResponsable1PersonaEstado { get; set; }
        public boolean manejaResponsable2EmpresaEstado { get; set; }
        public MotivoRetiroOpcional motivoRetiroOpcional { get; set; }
        public Integer nivelAnterior { get; set; }
        public long clientePropietarioID { get; set; }
        public String tipoParentesco { get; set; }
        public String sigla { get; set; }
        public String tipoIdClientePropietario { get; set; }
        public String nombrePrograma { get; set; }
        public String nombreProgramaPadre { get; set; }
        public Integer diasParaReactivacion { get; set; }
        public boolean esPersona { get; set; }
        public Requisitos requisitos { get; set; }
        public MotivoInactivacion motivoInactivacion { get; set; }
        public String estadoAfiliacion { get; set; }
        public long clienteID { get; set; }
    }
    
    public class Programas
    {
        public List<Programa> programa { get; set; }
    }
    
    public class Afiliacion
    {
        public String beneficiarios { get; set; }
        public Integer cantidadVinculacion { get; set; }
        public String categoriaAfiliacion { get; set; }
        public MotivoRetiro motivoRetiro { get; set; }
        public ClientesResponsables ClientesResponsables { get; set; }
        public String cmnt { get; set; }
        public boolean actualizadoEstado { get; set; }
        public boolean nuevoEstado { get; set; }
        public Integer estado { get; set; }
        public DateTime finFecha { get; set; }
        public DateTime ingresoEmpresaFecha { get; set; }
        public DateTime inicioFecha { get; set; }
        public DateTime modificacionFecha { get; set; }
        public DateTime registroFecha { get; set; }
        public DateTime retiroFecha { get; set; }
        public Integer soloServicio { get; set; }
        public String textoVinculacion { get; set; }
        public Integer valorVinculacion { get; set; }
        public String variableRetiro { get; set; }
        public String clienteID { get; set; }       
        public Programas Programas { get; set; }
    }
    
    public class MotivoRetiro
    {
        public Integer id { get; set; }
        public String nombre { get; set; }
    }
    
    public class Afiliaciones
    {
        public List<Afiliacion> afiliacion { get; set; }
    }
    
    public class Requisito
    {
        public String accGrupo { get; set; }
        public String campoAlfa { get; set; }
        //public boolean campoBooleano { get; set; }
        public String campoBooleano { get; set; }
        public String campoFecha1 { get; set; }
        public String campoFecha2 { get; set; }
        //public long campoNumerico { get; set; }
        public String campoNumerico { get; set; }
        public String decCampoFecha1 { get; set; }
        public String decCampoFecha2 { get; set; }
        public Integer estadoDato { get; set; }
        public Integer grupoDato { get; set; }
        public boolean guardarTramite { get; set; }
        public Integer idCampoNumerico { get; set; }
        public Integer idRequisito { get; set; }
        public String nombre { get; set; }
        public Integer numeroRadicado { get; set; }
        public String sigla { get; set; }
        public Integer subGrupoDato { get; set; }
        public Integer tipoAccion { get; set; }
    }
    
    public class Requisitos
    {
        public List<Requisito> requisito { get; set; }
    }
    
    public class Cliente
    {
        public Integer TipoIdentificacion { get; set; }
        public String NumeroIdentificacion { get; set; }
        public Integer legalID { get; set; }
        public Decimal Id { get; set; }
        public DatosPersona datosPersona { get; set; }
        public DatosEmpresa datosEmpresa { get; set; }
        public Sucursales Sucursales { get; set; }
        public ComunicacionesCliente comunicacionesCliente { get; set; }
        public Contacto Contacto { get; set; }
        public Afiliaciones Afiliaciones { get; set; }
        public Radicacion Radicacion { get; set; }
        public Programa Programa { get; set; }
    }
    
    public class Contacto
    {
        public String tipoContacto { get; set; }
        public Integer orden { get; set; }
    }
    
    public class Radicacion
    {
        public String accGrupo { get; set; }
        public String compRequisitos { get; set; }
        public String comportamientoRequisito { get; set; }
        public String configuracionRequisito { get; set; }
        public String configuracionRequisito1 { get; set; }
        public String datosConfiguracionRequisito { get; set; }
        public String decCampoFecha1 { get; set; }
        public String decCampoFecha2 { get; set; }
        public String descripcion { get; set; }
        public Integer estadoDato { get; set; }
        public Integer grupoDato { get; set; }
        public boolean guardarTramite { get; set; }
        public Integer idCampoNumerico { get; set; }
        public long id { get; set; }
        public String indicadorEstadoRequisito { get; set; }
        public long numeroRadicado { get; set; }
        public String sigla { get; set; }
        public Integer subGrupoDato { get; set; }
        public Integer tipoAccion { get; set; }
        public Requisito requisito { get; set; }
    }
    
    public class AtributosComunes
    {
        public String comunEntrePE { get; set; }
        public DateTime fidelizacionFecha { get; set; }
        public String ubicaciones { get; set; }
        public boolean beneficiarioEstado { get; set; }
        public boolean empresaEstado { get; set; }
        public boolean saltarFoneticoEstado { get; set; }
        public Integer indice { get; set; }
        
    }
    
    public class Body
    {
        public Cliente Cliente { get; set; }
        public AtributosComunes atributosComunes { get; set; }
        public Integer flagVinculacion { get; set; }
    }
    
    public class CustomerAdminProcesarVinculacionRequest extends COM_BaseWrapper_cls 
    {
        public Header Header { get; set; }
        public Body Body { get; set; }
    }
}