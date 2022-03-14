/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Objeto Wrapper el cual contiene los datos de respuesta para la integracion que expone Salesforce para crear o actualizar clientes
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-08-08      Rubén Suárez Forero (RUSF)      Creación clase.
*           -----   ----------      --------------------            ---------------
* @version  2.0     2020-08-13      Yeison Naranjo Rendon (YNR)     Inclusión nuevos campos cliente NOLA 00019237.
*************************************************************************************************************/

global class COM_WrapperCrearActualizarClienteSF_cls {

    public 	String 					          tipoIdentificacion			  {get; set;}
    public 	String 					          numeroIdentificacion 		  {get; set;}
    public 	String						      id							          {get; set;}
    public 	DatosEmpresa 				      datosEmpresa				      {get; set;}
    public  String                            estadoAfiliacion            {get; set;}
    public 	DatosPersona 				      datosPersona				      {get; set;}
    public 	Comunicaciones 		              comunicaciones		        {get; set;}
    public 	DatosRepresentanteLegal           datosRepresentanteLegal		{get; set;}
    public 	Requisitos					      requisitos					      {get; set;}
    public  String                            ds                        {get; set;}
    public  Sucursal                          sucursal     {get; set;}
    
    public class Sucursal{
        public  String                        sucursalID                     {get; set;}
        public  String                        centrocostoID                  {get; set;}
    }

    public class DatosEmpresa{
        public 	String 					        digitoVerificadorLegal		{get; set;}
        public 	String 						        razonSocial					      {get; set;}
        public 	String 					          tipoEmpresa					      {get; set;}
        public 	String 						        nombreComercial				    {get; set;}
        public 	String 						          constitucionFecha			    {get; set;}
        public 	String 						        tipoActividadEconomica		{get; set;}
        public 	String 					        sectorEconomico				    {get; set;}
        public 	String 					        grupoEmpresarial			    {get; set;}
        public 	String 						        agremiacion					      {get; set;}
    }

    public class DatosPersona{
        public 	String 						        primerNombre				      {get; set;}
        public 	String 						        segundoNombre				      {get; set;}
        public 	String 						        primerApellido			    	{get; set;}
        public 	String 						        segundoApellido				    {get; set;}
        public 	String 						        genero						        {get; set;}
        public 	String 						        estadoCivil					      {get; set;}
        public 	String 					            nacimientoFecha				    {get; set;}
        public 	String 						        nacimientoLugar				    {get; set;}
   		/* Inicio 2.0 */
    	public  String 							  	orientacionSexual	{get; set;}		
		public  String 							  	nivelEscolar	{get; set;}		
		public  String 							  	factorVulnerabilidad	{get; set;}	
    	public  String 							  	pertenenciaEtnica	{get; set;}		
    	public  String 							  	profesion	{get; set;}		
    	/* Inicio 2.0 */
    }

    public class Comunicaciones{
        public 	List<Comunicacion> 	      comunicacion	         		{get; set;}
    }

    public class Comunicacion{
        public 	Domicilios		 			      domicilios				      	{get; set;}
        public 	Telefonos 					      telefonos  					      {get; set;}
        public 	CorreosElectronicos 		  correosElectronicos 		  {get; set;}
        public 	Celulares 					      celulares					        {get; set;}
        public 	RedesSociales 		        redesSociales 				    {get; set;}
    }

    public class Domicilios{
        public 	List<Domicilio> 	     		domicilio 				      	{get; set;}
    }

    public class Domicilio{
        public 	String 					        	domicilio					        {get; set;}
        public 	String 					        	tipoDomicilio			       	{get; set;}
        public 	String 				       	   	codigoPostal			      	{get; set;}
        public 	String 			        			tipoAreaGeografica	  		{get; set;}
        public 	String 		        			codigoMunicipio			     	{get; set;}
        public 	String 			        			nombreMunicipio			     	{get; set;}
        public 	String 			        			barrio					        	{get; set;}
    }

    public class Telefonos{
        public 	List<Telefono>	 		    	telefono   				      	{get; set;}
    }

    public class Telefono{
        public 	String 					        	tipoTelefono		       		{get; set;}
        public 	String 					          	telefono				         	{get; set;}
        public 	String 					          	extensionTelefono		    	{get; set;}
    }

    public class CorreosElectronicos{
        public 	List<CorreoElectronico> 	correoElectronico 		   	{get; set;}
    }

    public class CorreoElectronico{
        public 	String 					        	correoElectronico		    	{get; set;}
        public 	String 			         		optInEmail				      	{get; set;}
    }

    public class Celulares{
        public	List<Celular> 			     	celular					        	{get; set;}
    }

    public class Celular{
        public 	String 					          	celular			         			{get; set;}
        public 	String 		        			optInSMS			        		{get; set;}
    }

    public class RedesSociales{
        public 	List<String> 					  	redesSociales			       	{get; set;}
    }

    public class DatosRepresentanteLegal{
        public 	String 				           		numeroIdentificacion	   	{get; set;}
        public 	String 				           		id	   	{get; set;} //nuevo
        public 	String 		        			tipoIdentificacion	   		{get; set;}
        public 	String 			  	       		nombrePrimero			      	{get; set;}
        public	String 			         			nombreSegundo			       	{get; set;}
        public	String 		         				apellidoPrimero		     		{get; set;}
        public	String 		        				apellidoSegundo		     		{get; set;}
        public 	String 		         				estadoCivil			      		{get; set;}
        public 	String 		         			nacimientoFecha	     			{get; set;}
        public 	String 		         				nacimientoLugar		     		{get; set;}
        public 	String 			         			genero					         	{get; set;}
    }

    public class Requisitos{
        public 	List<Requisito> 		          	requisito		        			{get; set;}
    }

    public class Requisito{
        public 	String 				         		nemotecnico		       			{get; set;}
        public 	String 			        			valorString			       		{get; set;}
        public 	String 	 		           			valorNumerico			       	{get; set;}
        public  String                              valorBooleano                   {get; set;}
        public 	String 		        			valorStringo  			     	{get; set;}
        public 	String 				       	  valorFechaInicio	    		{get; set;}
        public 	String 			        		valorFechaFin		       		{get; set;}
    }

}