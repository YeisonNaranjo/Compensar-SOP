/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Wrapper del request para la creación de casos en SF desde OnBase
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-07      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

global class RF2_WrapperCrearCasosSFRequest_cls {
	
	public String documentHandler { get; set; }
	public String noID { get; set; }
	public String idCaso { get; set; }
	public String fechaTransaccion { get; set; }
	public String fechaRecepcion { get; set; }
	public String tipoDocumento { get; set; }
	public String numeroDocumento { get; set; }
	public String sede { get; set; }
	public String primerNombre { get; set; }
	public String segundoNombre { get; set; }
	public String primerApellido { get; set; }
	public String segundoApellido { get; set; }
	public String razonSocial { get; set; }
	public String direccion { get; set; }
	public String ciudad { get; set; }
	public String correoElectronico { get; set; }
	public String telefono { get; set; }
	public String observacion { get; set; }
	public String procesoDestino { get; set; }
	public String tipo { get; set; }
	public String asunto { get; set; }
	public String genero { get; set; }
	public String estadoCivil { get; set; }

}