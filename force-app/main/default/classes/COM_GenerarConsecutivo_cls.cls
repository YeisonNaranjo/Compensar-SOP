/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase donde se realizan los siguientes procesos:
					- Generar el consecutivo para un proceso solicitado

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/07/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
public with sharing class COM_GenerarConsecutivo_cls 
{

	/**
	 * @version 1.1
	 * @description Metodo donde se recibe el indicativo de un proceso y se genera el consecutivo en el formato configurado
	 * @String idProceso => Identificador con el cual fue configurado el proceso
	 * @return String => Consecutivo solicitado con el formato configurado para el proceso
	 **/
	
	public static String GenerarConsecutivo(String idProceso)
	{
		//Se Valida que se reciba un valor de entrada
		if(String.isBlank(idProceso))
			return Label.COM_SinIdentificadorProceso;

		List<COM_ConfiguracionConsecutivos__c> lstConfig = [SELECT COM_Consecutivo__c, COM_Formato__c FROM COM_ConfiguracionConsecutivos__c WHERE COM_IdentificadorProceso__c =: idProceso];
		
		//Se valida que se halla encontrado una configuración con el identificador ingresado
		if(lstConfig.isEmpty())
			return Label.COM_NoEncontroConfiguracion;

        String strConsecutivo           = lstConfig[0].COM_Formato__c;
        Integer intCantNumFormato       = strConsecutivo.countMatches('#');
        Integer intCantNumConsecutivo   = String.valueOf(lstConfig[0].COM_Consecutivo__c).length();

		//Ingresa la cantidad de 0's necesarios para llenar la cantidad de numeros solicitados
		while(intCantNumFormato > intCantNumConsecutivo) 
		{
			strConsecutivo = strConsecutivo.replaceFirst('#', '0');
			intCantNumFormato--;
		}
		
		strConsecutivo = strConsecutivo.replaceFirst('#', String.valueOf(lstConfig[0].COM_Consecutivo__c));
		strConsecutivo = strConsecutivo.replaceAll('#', '');

		//Cambia los valores de fecha con los datos del día
		if(strConsecutivo.contains('dd'))
			strConsecutivo = strConsecutivo.replace('dd', Datetime.now().format('dd'));

		if(strConsecutivo.contains('mm'))
			strConsecutivo = strConsecutivo.replace('mm', Datetime.now().format('MM'));

		if(strConsecutivo.contains('AAAA'))
			strConsecutivo = strConsecutivo.replace('AAAA', Datetime.now().format('yyyy'));
		else if(strConsecutivo.contains('AA'))
			strConsecutivo = strConsecutivo.replace('AA', Datetime.now().format('yy'));

		//Actualiza el nuevo consecutivo
		lstConfig[0].COM_Consecutivo__c++;
		update lstConfig[0];
		
		//Retorna el consecutivo formateado
		return strConsecutivo;
	}
}