/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan Gabriel Duarte Pacheco (JGDP)
Proyecto:          LUMNI
Descripción:       Clase para controlar los eventos de los desencadenadores

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                  Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     10/02/16               JGDP                   Class creation.
************************************************************************************************/
public with sharing class COM_Banderas_cls 
{
	public COM_Banderas_cls() 
	{
		
	}
	private static set<String> stEjecutado = new set<String>();

	public static boolean ValidarEjecucion(String nombre)
	{
		return stEjecutado.contains(nombre);
	}

	public static void setEjecucion(string nombre)
	{
		stEjecutado.add(nombre);
	}

    public static void reiniciarEjecucion(string nombre) 
    {
        stEjecutado.remove(nombre);
    }
}