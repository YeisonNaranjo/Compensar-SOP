/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Objeto Wrapper el cual contiene los datos de solicitud (Request) para la integracion de creacion de cliente en Gestion de Clientes
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-31      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  2.0     06/01/2022      Yeison Naranjo (YSN)            Inclusión nuevo campo NOLA 00030781
*************************************************************************************************************/


public with sharing class COM_WrapperCrearClienteGCRequest_cls {
    public CustomerMng_CrearCliente_Request CustomerMng_CrearCliente_Request { get; set; }

    public class CustomerMng_CrearCliente_Request extends COM_BaseWrapper_cls{
        public  Header      Header                  {get;set;}
        public  Body        Body                    {get;set;}
    }

    public class Body{
        public  Cliente     Cliente                 {get;set;}
        
    }

    public class Demografia
    {
        public string nacimientoFecha { get; set; }
        public string nacimientoLugar { get; set; }
        public string genero { get; set; }
        public string estadoCivil { get; set; }
    }

    public class Variables
    {
        public string CreacionPrimerNombre { get; set; }
        public string CreacionSegundoNombre { get; set; }
        public string CreacionPrimerApellido { get; set; }
        public string CreacionSegundoApellido { get; set; }
    }

    public class DatosPersona
    {
        public string nombrePrimero { get; set; }
        public string nombreSegundo { get; set; }
        public string apellidoSegundo { get; set; }
        public string apellidoPrimero { get; set; }
        public Demografia demografia { get; set; }
        public Variables Variables { get; set; }
    }

    public class MotivoInactivacion
    {
        public string id { get; set; }
    }

    public class DatosEmpresa
    {
        public string tipoEmpresa { get; set; }
        public string tipoActividadEconomica { get; set; }
        public string sectorEconomico { get; set; }
        public string razonSocial { get; set; }
        public string nombreComercial { get; set; }
        public string estadoAfiliacion { get; set; }
        /* Inicio 2.0 */
        public Integer Responsabilidades_Fiscales { get; set; }
        /* Fin 2.0 */
        public string digitoVerificadorLegal { get; set; }
        public string constitucionFecha { get; set; }
        public string grupoEmpresarial { get; set; }
        public string agremiacion { get; set; }
        public MotivoInactivacion motivoInactivacion { get; set; }
    }

    public class DatosRepresentanteLegal
    {
        public string TipoIdentificacion { get; set; }
        public string NumeroIdentificacion { get; set; }
        public string nombrePrimero { get; set; }
        public string nombreSegundo { get; set; }
        public string apellidoSegundo { get; set; }
        public string apellidoPrimero { get; set; }
        public Demografia demografia { get; set; }
    }

    public class TelefonoComunicacion
    {
        public string tipoTelefono { get; set; }
        public string telefono { get; set; }
        public string extensionTelefono { get; set; }
    }

    public class Telefonos
    {
        public List<TelefonoComunicacion> telefonoComunicacion { get; set; }
    }

    public class Departamento
    {
        public string id { get; set; }
        public string nombre { get; set; }
    }

    public class Municipio
    {
        public string id { get; set; }
        public string nombre { get; set; }
        public Departamento departamento { get; set; }
    }

    public class Localidad
    {
        public string id { get; set; }
        public Municipio municipio { get; set; }
        public string nombre { get; set; }
    }

    public class DomicilioComunicacion
    {
        public string barrio { get; set; }
        public string casillaCorreo { get; set; }
        public string tipoDomicilio { get; set; }
        public string domicilio { get; set; }
        public string codigoPostal { get; set; }
        public Localidad localidad { get; set; }
        public string tipoAreaGeografica { get; set; }
    }

    public class Domicilios
    {
        public List<DomicilioComunicacion> domicilioComunicacion { get; set; }
    }

    public class CorreosElectronicos
    {
        public List<string> correoElectronico { get; set; }
    }

    public class Celulares
    {
        public List<string> celular { get; set; }
    }

    public class RedesSociales
    {
        public List<string> redesSociales { get; set; }
    }

    public class AdicionalesContacto
    {
        public String orden { get; set; }
        public String borradoEstado { get; set; }
        public String creacionFecha { get; set; }
        public String ultimaNovedadFecha { get; set; }
        public String identificador { get; set; }
        public String zonaBogota { get; set; }
    }

    public class ComunicacionCliente
    {
        public Telefonos telefonos { get; set; }
        public Domicilios domicilios { get; set; }
        public CorreosElectronicos correosElectronicos { get; set; }
        public string opTinEmail { get; set; }
        public Celulares celulares { get; set; }
        public string opTinSMS { get; set; }
        public RedesSociales redesSociales { get; set; }
        public AdicionalesContacto adicionalesContacto { get; set; }
    }

    public class ComunicacionesCliente
    {
        public List<ComunicacionCliente> comunicacionCliente { get; set; }
    }

    public class Requisitos{
        public List<Requisito> Requisito { get; set; }
    }

    public class Requisito{
        public String accGrupo { get; set; }
        public String campoAlfa { get; set; }
        public String campoBooleano { get; set; }
        public String campoFecha1 { get; set; }
        public String campoFecha2 { get; set; }
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

    public class Cliente
    {
        public string TipoIdentificacion { get; set; }
        public string NumeroIdentificacion { get; set; }
        public string Id { get; set; }
        public DatosPersona datosPersona { get; set; }
        public DatosEmpresa datosEmpresa { get; set; }
        public DatosRepresentanteLegal datosRepresentanteLegal { get; set; }
        public ComunicacionesCliente comunicacionesCliente { get; set; }
        public Requisitos Requisitos { get; set; }
        public  AtributosComunes     atributosComunes                 {get;set;}
    }

    public class AtributosComunes
    {
        public String consultaCliente { get; set; }
        public String fechaModificacion { get; set; }
    }
}