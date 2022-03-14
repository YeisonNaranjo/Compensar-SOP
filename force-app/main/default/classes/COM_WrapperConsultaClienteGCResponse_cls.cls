/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Objeto Wrapper el cual contiene los datos con la respuesta para la consulta de cliente en GC
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-31      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public with sharing class COM_WrapperConsultaClienteGCResponse_cls {

    public CustomerMng_ConsultaCliente_Response CustomerMng_ConsultaCliente_Response { get; set; }

    public class CustomerMng_ConsultaCliente_Response extends COM_BaseWrapperResponse_cls{
        public  Header                      Header                  {get;set;}
        public  Body                        Body                    {get;set;}
    }

    public class Body{
        public 	Cliente 					cliente 					{get; set;}
        public 	AtributosComunes			atributosComunes			{get; set;}
        public 	Vinculacion					vinculacion					{get; set;}
    }

    public class Vinculacion
    {
        public string AfiliadoCaja { get; set; }
        public string AfiliacionConResponsable { get; set; }
        public string AfiliadoSalud { get; set; }
        public string AfiliadoPLC { get; set; }
    }

    public class Demografia
    {
        public string nacimientoFecha { get; set; }
        public string genero { get; set; }
        public string estadoCivil { get; set; }
    }

    public class MotivoInactivacion
    {
        public string id { get; set; }
    }

    public class DatosPersona2
    {
        public string nombrePrimero { get; set; }
        public string nombreSegundo { get; set; }
        public string apellidoPrimero { get; set; }
        public string apellidoSegundo { get; set; }
        public string nombre { get; set; }
        public string nuip { get; set; }
        public Demografia demografia { get; set; }
        public MotivoInactivacion motivoInactivacion { get; set; }
    }

    public class ClienteResponsable2
    {
        public string tipoResponsable { get; set; }
        public string legalID { get; set; }
        public string nombre { get; set; }


    }

    public class ClienteResponsable
    {
        public List<ClienteResponsable2> clienteResponsable { get; set; }
    }

    public class MotivoRetiroOpcional
    {
        public string id { get; set; }
        public string nombre { get; set; }
    }

    public class Programa2
    {
        public string diasPaHisto { get; set; }
        public string tipoRadicacion { get; set; }
        public string edadReAuto { get; set; }
        public string genNuevoRadicadoEstado { get; set; }
        public string grupo { get; set; }
        public string id { get; set; }
        public string programaPadre { get; set; }
        public string indicadorProgramaEstado { get; set; }
        public string indicadorVinculacionEstado { get; set; }
        public string manejaResponsable1PersonaEstado { get; set; }
        public string manejaResponsable2EmpresaEstado { get; set; }
        public MotivoRetiroOpcional motivoRetiroOpcional { get; set; }
        public string clientePropietarioID { get; set; }
        public string tipoParentesco { get; set; }
        public string sigla { get; set; }
        public string nombrePrograma { get; set; }
        public string diasParaReactivacion { get; set; }
    }

    public class Programa
    {
        public List<Programa2> programa { get; set; }
    }

    public class MotivoInactivacion2
    {
        public string id { get; set; }
    }

    public class Afiliacion2
    {
        public string cantidadVinculacion { get; set; }
        public string categoriaAfiliacion { get; set; }
        public ClienteResponsable ClienteResponsable { get; set; }
        public string cmnt { get; set; }
        public string actualizadoEstado { get; set; }
        public string nuevoEstado { get; set; }
        public string estado { get; set; }
        public string finFecha { get; set; }
        public string inicioFecha { get; set; }
        public string ingresoEmpresaFecha { get; set; }
        public string retiroFecha { get; set; }
        public string valorVinculacion { get; set; }
        public string variableRetiro { get; set; }
        public Programa Programa { get; set; }
        public string id { get; set; }
        public MotivoInactivacion2 motivoInactivacion { get; set; }
        public string estadoAfiliacion { get; set; }
    }

    public class Afiliacion
    {
        public List<Afiliacion2> afiliacion { get; set; }
    }

    public class Familiar
    {
        public string legalID { get; set; }
        public string tipoIdentificacion { get; set; }
        public string id { get; set; }
        public DatosPersona2 datosPersona { get; set; }
        public string Sucursal { get; set; }
        public string comunicacionesCliente { get; set; }
        public string Contacto { get; set; }
        public Afiliacion Afiliacion { get; set; }
        public string Radicacion { get; set; }
    }

    public class Familia2
    {
        public string tipoParentesco { get; set; }
        public Familiar familiar { get; set; }
    }

    public class Familia
    {
        public List<Familia2> familia { get; set; }
    }

    public class Demografia2
    {
        public string nacimientoFecha { get; set; }
        public string nacimientoLugar { get; set; }
        public string genero { get; set; }
        public string estadoCivil { get; set; }
        public string gradoEscolaridad { get; set; }
        public string TitulosObtenidos { get; set; }
        public string OficiosProfesiones { get; set; }
        public string OtrosEstudios { get; set; }
    }

    public class MotivoInactivacion3
    {
        public string id { get; set; }
    }

    public class DatosPersona
    {
        public string nombrePrimero { get; set; }
        public string nombreSegundo { get; set; }
        public string apellidoPrimero { get; set; }
        public string apellidoSegundo { get; set; }
        public string nombre { get; set; }
        public string foneticoID { get; set; }
        public string nuip { get; set; }
        public Familia Familia { get; set; }
        public Demografia2 demografia { get; set; }
        public string categoriaAfiliacion { get; set; }
        public string estadoAfiliacion { get; set; }
        public MotivoInactivacion3 motivoInactivacion { get; set; }
    }

    public class Sucursal2
    {
        public string id { get; set; }
        public string sucursalID { get; set; }
        public string nivelAdicional { get; set; }
        public string razonSocial { get; set; }
        public string mantenimiento { get; set; }
        public string centroCostosID { get; set; }
    }

    public class Sucursal
    {
        public List<Sucursal2> sucursal { get; set; }
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

    public class AdicionalesContacto
    {
        public string borradoEstado { get; set; }
        public string creacionFecha { get; set; }
        public string ultimaNovedadFecha { get; set; }
        public string identificador { get; set; }
        public string orden { get; set; }
        public string zonaBogota { get; set; }
    }

    public class ComunicacionCliente
    {
        public Telefonos telefonos { get; set; }
        public Domicilios domicilios { get; set; }
        public CorreosElectronicos correosElectronicos { get; set; }
        public Celulares celulares { get; set; }
        public string redesSociales { get; set; }
        public string opTinEmail { get; set; }
        public string opTinSMS { get; set; }
        public AdicionalesContacto adicionalesContacto { get; set; }
    }

    public class ComunicacionesCliente
    {
        public List<ComunicacionCliente> comunicacionCliente { get; set; }
    }

    public class MotivoRetiro
    {
        public string id { get; set; }
        public string nombre { get; set; }
    }

    public class ClienteResponsable4
    {
        public string tipoResponsable { get; set; }
        public string id { get; set; }
        public string nombre { get; set; }
        public string legalID { get; set; }
        public string tipoIdentificacion { get; set; }
        public string centroCostosID { get; set; }
        public string sucursalID { get; set; }
    }

    public class ClienteResponsable3
    {
        public List<ClienteResponsable4> clienteResponsable { get; set; }
    }

    public class MotivoRetiroOpcional2
    {
        public string id { get; set; }
        public string nombre { get; set; }
    }

    public class Programa4
    {
        public string condicion { get; set; }
        public string diasPaHisto { get; set; }
        public string tipoRadicacion { get; set; }
        public string edadReAuto { get; set; }
        public string genNuevoRadicadoEstado { get; set; }
        public string grupo { get; set; }
        public string id { get; set; }
        public string programaPadre { get; set; }
        public string indicadorProgramaEstado { get; set; }
        public string indicadorVinculacionEstado { get; set; }
        public string manejaResponsable1PersonaEstado { get; set; }
        public string manejaResponsable2EmpresaEstado { get; set; }
        public MotivoRetiroOpcional2 motivoRetiroOpcional { get; set; }
        public string clientePropietarioID { get; set; }
        public string tipoParentesco { get; set; }
        public string sigla { get; set; }
        public string tipoIdClientePropietario { get; set; }
        public string nombrePrograma { get; set; }
        public string nombreProgramaPadre { get; set; }
        public string diasParaReactivacion { get; set; }
    }

    public class Programa3
    {
        public List<Programa4> programa { get; set; }
    }

    public class MotivoInactivacion4
    {
        public string id { get; set; }
    }

    public class Afiliacion4
    {
        public string beneficiarios { get; set; }
        public string cantidadVinculacion { get; set; }
        public string categoriaAfiliacion { get; set; }
        public MotivoRetiro motivoRetiro { get; set; }
        public ClienteResponsable3 ClienteResponsable { get; set; }
        public string cmnt { get; set; }
        public string actualizadoEstado { get; set; }
        public string nuevoEstado { get; set; }
        public string estado { get; set; }
        public string finFecha { get; set; }
        public string ingresoEmpresaFecha { get; set; }
        public string inicioFecha { get; set; }
        public string retiroFecha { get; set; }
        public string soloServicio { get; set; }
        public string textoVinculacion { get; set; }
        public string valorVinculacion { get; set; }
        public string variableRetiro { get; set; }
        public Programa3 Programa { get; set; }
        public string id { get; set; }
        public MotivoInactivacion4 motivoInactivacion { get; set; }
        public string estadoAfiliacion { get; set; }
        public string clienteID { get; set; }
    }

    public class Afiliacion3
    {
        public List<Afiliacion4> afiliacion { get; set; }
    }


    public class DatosEmpresa
    {
        public string digitoVerificadorLegal { get; set; }
        public string razonSocial { get; set; }
        public string nombreComercial { get; set; }
        public string estadoAfiliacion { get; set; }
        public MotivoInactivacion motivoInactivacion { get; set; }
    }

    public class DatosRepresentanteLegal
    {
        public string TipoIdentificacion { get; set; }
        public string NumeroIdentificacion { get; set; }
        public string Id { get; set; }
        public string nombrePrimero { get; set; }
        public string nombreSegundo { get; set; }
        public string apellidoPrimero { get; set; }
        public string apellidoSegundo { get; set; }
        public string nombre { get; set; }
        public string foneticoID { get; set; }
        public string nuip { get; set; }
        public Demografia3 demografia { get; set; }
    }
    public class Demografia3
    {
        public string nacimientoFecha { get; set; }
        public string genero { get; set; }
        public string estadoCivil { get; set; }
        public string TitulosObtenidos { get; set; }
        public string OficiosProfesiones { get; set; }
        public string OtrosEstudios { get; set; }
    }

    public class Cliente
    {
        public string TipoIdentificacion { get; set; }
        public string NumeroIdentificacion { get; set; }
        public string Id { get; set; }
        public DatosPersona datosPersona { get; set; }
        public Sucursal Sucursal { get; set; }
        public ComunicacionesCliente comunicacionesCliente { get; set; }
        public string Contacto { get; set; }
        public Afiliacion3 Afiliacion { get; set; }
        public string Radicacion { get; set; }
        public DatosEmpresa datosEmpresa { get; set; }
        public DatosRepresentanteLegal datosRepresentanteLegal { get; set; }
    }

    public class AtributosComunes
    {
        public string fidelizacionFecha { get; set; }
        public string beneficiarioEstado { get; set; }
        public string empresaEstado { get; set; }
        public string saltarFoneticoEstado { get; set; }
        public string indice { get; set; }
        public string edadMayor { get; set; }
    }
}