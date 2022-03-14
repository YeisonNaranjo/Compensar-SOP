/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase Utilitaria encargada de:
					* Recibir un número y retornar su valor en letras
					* Recibir el número de mes y renotar su valor en letras

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     01/08/17             Cristian David Mejia (CM)             Creación Clase.
************************************************************************************************/
public with sharing class COM_CambiarALetrasUtil_cls 
{
	/**
	 * @version 1.0
	 * @description Metodo Encargado de recibir un número y retornar su valor en letras
	 * @param Integer intNumero => Valor a convertir
	 * @return String => Numero en letras
	 **/	
	public static String getNumLetras(Integer intNumero)
	{
		if(String.valueOf(intNumero).length() <= 2 && intNumero < 20)
		{
			if(intNumero == 0)
				return '';
			else if(intNumero == 1)
				return 'uno';
			else if(intNumero == 2)
				return 'dos';
			else if(intNumero == 3)
				return 'tres';
			else if(intNumero == 4)
				return 'cuatro';
			else if(intNumero == 5)
				return 'cinco';
			else if(intNumero == 6)
				return 'seis';
			else if(intNumero == 7)
				return 'siete';
			else if(intNumero == 8)
				return 'ocho';
			else if(intNumero == 9)
				return 'nueve';
			else if(intNumero == 10)
				return 'diez';
			else if(intNumero == 11)
				return 'once';
			else if(intNumero == 12)
				return 'doce';
			else if(intNumero == 13)
				return 'trece';
			else if(intNumero == 14)
				return 'catorce';
			else if(intNumero == 15)
				return 'quince';
			else if(intNumero >= 16 && intNumero < 19)
				return 'dieci'+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(1)));
		}
		else if(String.valueOf(intNumero).length() == 2)
		{
			String str;
			if(String.valueOf(intNumero).left(1) == '2' && String.valueOf(intNumero).right(1) == '0')			
				str = 'veinte';
			else if(String.valueOf(intNumero).left(1) == '2' && String.valueOf(intNumero).right(1) != '0')
				str = 'veinti';			
			else if(String.valueOf(intNumero).left(1) == '3')
				str = 'treinta';
			else if(String.valueOf(intNumero).left(1) == '4')
				str = 'cuarenta';
			else if(String.valueOf(intNumero).left(1) == '5')
				str = 'cincuenta';
			else if(String.valueOf(intNumero).left(1) == '6')
				str = 'sesenta';
			else if(String.valueOf(intNumero).left(1) == '7')
				str = 'setenta';
			else if(String.valueOf(intNumero).left(1) == '8')
				str = 'ochenta';
			else if(String.valueOf(intNumero).left(1) == '9')
				str = 'noventa';

			if(String.valueOf(intNumero).right(1) != '0' && String.valueOf(intNumero).left(1) != '2')
				str += ' y '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(1)));
			else if(String.valueOf(intNumero).right(1) != '0' && String.valueOf(intNumero).left(1) == '2')
				str += getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(1)));

			return str;
		}
		else if(String.valueOf(intNumero).length() == 3)
		{
			if(intNumero == 100)
				return 'cien';
			else if(intNumero > 100 && intNumero < 200)
				return 'ciento '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 200 && intNumero < 300)
				return 'doscientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 300 && intNumero < 400)
				return 'trescientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 400 && intNumero < 500)
				return 'cuatrocientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 500 && intNumero < 600)
				return 'quinientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 600 && intNumero < 700)
				return 'seiscienos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 700 && intNumero < 800)
				return 'setecientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 800 && intNumero < 900)
				return 'ochocientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
			else if(intNumero >= 900 && intNumero < 1000)
				return 'novecientos '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(2)));
		}
		else if(String.valueOf(intNumero).length() >= 4 && String.valueOf(intNumero).length() <= 6)
		{
			if(intNumero >= 1000 && intNumero < 2000)
				return 'mil '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right((String.valueOf(intNumero).length()-1))));
			else if (intNumero >= 2000 && intNumero < 1000000) 
				return getNumLetras(Integer.valueOf(String.valueOf(intNumero).left((String.valueOf(intNumero).length()-3))))+' mil '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(3)));
		}
		else if(String.valueOf(intNumero).length() >= 7 && String.valueOf(intNumero).length() <= 12)
		{
			if(intNumero >= 1000000 && intNumero < 2000000)
				return 'un millon '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(6)));
			else if (intNumero > 1000000)
				return getNumLetras(Integer.valueOf(String.valueOf(intNumero).left((String.valueOf(intNumero).length()-6))))+' millones '+getNumLetras(Integer.valueOf(String.valueOf(intNumero).right(6)));
		}
		return '';
	}

	/**
	 * @version 1.0
	 * @description Metodo Encargado de recibir el número de mes y renotar su valor en letras
	 * @param Integer intNumero => Mes a convertir
	 * @return String => Mes en letras
	 **/
	public static String getMesLetras(Integer intMes)
	{
		if(intMes == 1)
			return 'Enero';
		else if(intMes == 2)
			return 'Febrero';
		else if(intMes == 3)
			return 'Marzo';
		else if(intMes == 4)
			return 'Abril';
		else if(intMes == 5)
			return 'Mayo';
		else if(intMes == 6)
			return 'Junio';
		else if(intMes == 7)
			return 'Julio';
		else if(intMes == 8)
			return 'Agosto';
		else if(intMes == 9)
			return 'Septiembre';
		else if(intMes == 10)
			return 'Octubre';
		else if(intMes == 11)
			return 'Noviembre';
		else if(intMes == 12)
			return 'Diciembre';
		return '';
	}
}