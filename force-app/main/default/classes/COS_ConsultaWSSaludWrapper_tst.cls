@IsTest
public class COS_ConsultaWSSaludWrapper_tst {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"ConsultarDatosVinculacionOut\": {'+
		'        \"Vinculacion\": ['+
		'            {'+
		'                \"ProgramaVinculacion\": \"CE 050121 Cónyuge\",'+
		'                \"Estado\": \"0\",'+
		'                \"FechaInicio\": 20200201,'+
		'                \"Estrato\": 1,'+
		'                \"AUTENVEMAIL\": \"SI\",'+
		'                \"AUTENVSMS\": \"SI\"'+
		'            },'+
		'            {'+
		'                \"ProgramaVinculacion\": \"EP 021311 Cónyuge\",'+
		'                \"Estado\": 0,'+
		'                \"FechaInicio\": 20190812,'+
		'                \"Estrato\": 1,'+
		'                \"AUTENVEMAIL\": \"SI\",'+
		'                \"AUTENVSMS\": \"SI\"'+
		'            }'+
		'        ],'+
		'        \"GrupoFamiliar\": ['+
		'            {'+
		'                \"TipoIdentificacion\": 1,'+
		'                \"NumeroIdentificacion\": \"1018466460\",'+
		'                \"Nombre\": \"MIRELLA ZAIDA ARANDA BOZA\",'+
		'                \"FechaNacimiento\": 19940419,'+
		'                \"Genero\": \"F\",'+
		'                \"Parentesco\": \"CY\",'+
		'                \"Direccion\": \"CL 238 356 A 19\",'+
		'                \"Correo\": \"Consprb0385619270@davivienda.c\",'+
		'                \"Plan\": \"CE\"'+
		'            },'+
		'            {'+
		'                \"TipoIdentificacion\": 1,'+
		'                \"NumeroIdentificacion\": \"1018466460\",'+
		'                \"Nombre\": \"MIRELLA ZAIDA ARANDA BOZA\",'+
		'                \"FechaNacimiento\": 19940419,'+
		'                \"Genero\": \"F\",'+
		'                \"Parentesco\": \"CY\",'+
		'                \"Direccion\": \"CL 238 356 A 19\",'+
		'                \"Correo\": \"Consprb0385619270@davivienda.c\",'+
		'                \"Plan\": \"EP\"'+
		'            }'+
		'        ],'+
		'        \"Empresa\": ['+
		'            {'+
		'                \"NIT\": 901275320,'+
		'                \"RazonSocial\": \"COLOR ADS SAS\",'+
		'                \"Contacto\": \"keren gissela gomez castro\",'+
		'                \"Correo\": \"Consprb0385619270@davivienda.c\",'+
		'                \"Telefono\": 0,'+
		'                \"Direccion\": \"AC 385 261 C 92\",'+
		'                \"CantidadTrabajadoresPBS\": 3,'+
		'                \"CantidadTrabajadoresPCE\": 0,'+
		'                \"CantidadTrabajadoresPCV\": 0,'+
		'                \"CantidadTrabajadores\": 3'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		COS_ConsultaWSSaludWrapper obj = COS_ConsultaWSSaludWrapper.parse(json);
		System.assert(obj != null);
	}
}