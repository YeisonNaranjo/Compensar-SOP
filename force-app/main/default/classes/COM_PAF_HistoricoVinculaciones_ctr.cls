/**
* Avanxo Colombia
* @author 			Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:			Compensar
* Description:		Clase para consultar el histórico de vinculaciones de las cuentas
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					     	Description
*			-----	----------		--------------------	     	---------------
* @version	1.0		2017-07-18		Rubén Suárez Forero (RUSF)		Creación clase.
*************************************************************************************************************/

public class COM_PAF_HistoricoVinculaciones_ctr {

	public 	Boolean   			blnEmpleado					{get;set;} 
	public 	Boolean   			blnEmpresa					{get;set;} 
	public 	Boolean   			blnBeneficiario				{get;set;} 
	public  String				strResultados				{get;set;} 

	public COM_PAF_HistoricoVinculaciones_ctr() {
		strResultados 		= '';
		blnEmpleado 		= false;
		blnEmpresa 			= false;
		blnBeneficiario 	= false;
	}
		
}