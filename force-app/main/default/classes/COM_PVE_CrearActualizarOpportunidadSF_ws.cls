@RestResource(urlMapping='/Oportunidad/*')
global class COM_PVE_CrearActualizarOpportunidadSF_ws {
	public COM_PVE_CrearActualizarOpportunidadSF_ws() {
		
	}

	@HttpPut
	global static WrapperResponseCliente crearOportunidad(WrapperRequestCliente datosOportunidad) {
		WrapperResponseCliente wprResponse;
		System.debug(datosOportunidad);
		String respuesta = ProcesarRequest(datosOportunidad);
		if(respuesta == 'Created'){ 
		    wprResponse = new WrapperResponseCliente('ID', '201', respuesta);
		} else {
		    wprResponse = new WrapperResponseCliente('ID', '400', respuesta);
		}
		return wprResponse;
	}

	public static String ProcesarRequest(WrapperRequestCliente opportunidad){
	    Opportunity oppRequest                   = new Opportunity();
	    //oppRequest.Id                          = opportunidad.id;
	    oppRequest.Name						     = opportunidad.nombre;
	    oppRequest.StageName  					 = 'Respondida';      
	    oppRequest.CloseDate                 	 = Date.newInstance(2017, 12, 12);     
	    //oppRequest.observaciones        	     = opportunidad.observaciones; 
   
	  
		try{
			upsert oppRequest;
			return 'Created';
		}
			catch(Exception e) {
			System.debug('Salesforce Exception: ' + e.getMessage());
			return e.getMessage();
		} 
	}


//WRAPPER REQUEST
	public class TipoDomicilio
	{
	    public string id { get; set; }
	    public string nombre { get; set; }
	}

	public class CorreosElectronicos
	{
	    public string correoElectronico { get; set; }
	}

	public class TipoContacto
	{
	    public string id { get; set; }
	    public string nombre { get; set; }
	}

	public class DatosPersonales
	{
	    public string nombrePrimero { get; set; }
	    public string nombreSegundo { get; set; }
	    public string apellidoPrimero { get; set; }
	    public string apellidoSegundo { get; set; }
	    public string nombre { get; set; }
	}

	public class Aplicacion
	{
	    public string id { get; set; }
	    public string codigo { get; set; }
	    public string nombre { get; set; }
	}

	public class CanalVenta
	{
	    public string id { get; set; }
	    public string nombre { get; set; }
	}

	public class TipoIdentificacion
	{
	    public string id { get; set; }
	}

	public class Cliente
	{
	    public string legalID { get; set; }
	    public string id { get; set; }
	    public TipoIdentificacion tipoIdentificacion { get; set; }
	}

	public class CotizacionCliente
	{
	    public Cliente Cliente { get; set; }
	}

	public class CotizacionClienteOportunidadVenta
	{
	    public CotizacionCliente cotizacionCliente { get; set; }
	}

	public class Clientes
	{
	    public CotizacionClienteOportunidadVenta cotizacionClienteOportunidadVenta { get; set; }
	}

	public class ProductoServicio
	{
	    public string id { get; set; }
	    public string nombre { get; set; }
	}

	public class ProductoServicioCotizado
	{
	    public string observaciones { get; set; }
	    public ProductoServicio productoServicio { get; set; }
	}

	public class ProductosServiciosCotizados
	{
	    public ProductoServicioCotizado productoServicioCotizado { get; set; }
	}

	global class WrapperRequestCliente
	{
	    public string id { get; set; }
	    public string nombre { get; set; }
	    public string numeroAdultos { get; set; }
	    public string numeroNinos { get; set; }
	    public string observaciones { get; set; }
	    public TipoDomicilio TipoDomicilio { get; set; }
	    public CorreosElectronicos CorreosElectronicos { get; set; }
	    public TipoContacto TipoContacto { get; set; }
	    public DatosPersonales DatosPersonales { get; set; }
	    public Aplicacion Aplicacion { get; set; }
	    public CanalVenta CanalVenta { get; set; }
	    public Clientes Clientes { get; set; }
	    public ProductosServiciosCotizados productosServiciosCotizados { get; set; }
	}
//WRAPPER RESPONSE
	public class RespuestaOportunidad
	{
	    public string codOportunidad { get; set; }
	    public string codigoRespuesta { get; set; }
	    public string mensajeRespuesta { get; set; }
	    public string fecha { get; set; }
	}
	global class WrapperResponseCliente
	{
	    public RespuestaOportunidad respuestaOportunidad { get; set; }

	    public WrapperResponseCliente(String codOportunidad, String codigoRespuesta, String mensajeRespuesta){
			respuestaOportunidad 				  = New respuestaOportunidad();
			respuestaOportunidad.codOportunidad   = codigoRespuesta;
			respuestaOportunidad.codigoRespuesta  = codigoRespuesta;
			respuestaOportunidad.mensajeRespuesta = mensajeRespuesta;  
			respuestaOportunidad.fecha            = String.valueOf(System.now()); 
	    }
	}
}