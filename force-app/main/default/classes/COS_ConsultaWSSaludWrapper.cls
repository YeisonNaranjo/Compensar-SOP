public class COS_ConsultaWSSaludWrapper {

	public class GrupoFamiliar {
		public String TipoIdentificacion;
		public String NumeroIdentificacion;
		public String Nombre;
		public Integer FechaNacimiento;
		public String Genero;
		public String Parentesco;
		public String Direccion;
		public String Correo;
		public String Plan;
        public String PlanVarios;
	}

	public class Empresa {
		public String NIT;
		public String RazonSocial;
		public String Contacto;
		public String Correo;
		public Long Telefono;
		public String Direccion;
		public Integer CantidadTrabajadoresPBS;
		public Integer CantidadTrabajadoresPCE;
		public Integer CantidadTrabajadoresPCV;
		public Integer CantidadTrabajadores;
	}

	public ConsultarDatosVinculacionOut ConsultarDatosVinculacionOut;

	public class ConsultarDatosVinculacionOut {
		public List<Vinculacion> Vinculacion;
		public List<GrupoFamiliar> GrupoFamiliar;
		public List<Empresa> Empresa;
        public List<Errores> Errores;
	}

	public class Vinculacion {
		public String ProgramaVinculacion;
		public String Estado;
		public Integer FechaInicio;
		public Integer Estrato;
		public String AUTENVEMAIL;
		public String AUTENVSMS;
	}

   	public class Errores {
		public String IdError;
        public String Error;

	}
	
	public static COS_ConsultaWSSaludWrapper parse(String json) {
		return (COS_ConsultaWSSaludWrapper) System.JSON.deserialize(json, COS_ConsultaWSSaludWrapper.class);
	}
}