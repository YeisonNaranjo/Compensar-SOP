/**
* Avanxo Colombia
* @author 			Rubén Suárez Forero href=<jsuarez@avanxo.com>
* Project:			Compensar
* Description:		Clase para calcular el superávit de las empresas
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					     	Description
*			-----	----------		--------------------	     	---------------
* @version	1.0		2017-07-18		Rubén Suárez Forero (RUSF)		Creación clase.
*************************************************************************************************************/

public class COM_PAF_Calculadora_ctr {
	
	public  Decimal 							decAporte					{get;set;}  
	public  Decimal								decDS						{get;set;} 	
	public  Decimal								decValorNomina				{get;set;} 	
	public  Decimal								decTotalTrabajadores		{get;set;} 	
	public  Decimal								decHijosSubsidio			{get;set;} 	
	public  COM_CalculadoraSuperavit2M__mdt		cnfValoresCalculadora;
	
	/**
	* @author Rubén Suárez Forero (jsuarez@avanxo.com)
	* @version 1.0
	* @description Constructor
	* @return 
	**/
	public COM_PAF_Calculadora_ctr() {
		decAporte				= 0;
		decDS					= 0;
		decValorNomina			= 0;
		decTotalTrabajadores	= 0;
		decHijosSubsidio		= 0;
		List<COM_CalculadoraSuperavit2M__mdt> sObjectList = [select COM_PorcentajeAporte__c, COM_PorcentajeApropiacion__c, COM_CalcValorPagarSubsidio__c, COM_PorcentajeFactor__c from COM_CalculadoraSuperavit2M__mdt where DeveloperName = 'Calculadora_SuperHabit_Empresas'];
		cnfValoresCalculadora = sObjectList.get(0);
		system.debug(cnfValoresCalculadora);
	}
	
	/**
	* @author Rubén Suárez Forero (jsuarez@avanxo.com)
	* @version 1.0
	* @description Calculo del superávit
	* @return 
	**/
	public void fnCalcular()
	{
		decAporte				= decValorNomina * cnfValoresCalculadora.COM_PorcentajeAporte__c;
		decDS 					= ((decAporte*cnfValoresCalculadora.COM_PorcentajeApropiacion__c) - (cnfValoresCalculadora.COM_CalcValorPagarSubsidio__c*decHijosSubsidio)) * cnfValoresCalculadora.COM_PorcentajeFactor__c;
	}    
}