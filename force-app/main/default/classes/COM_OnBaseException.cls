/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase para identificar las excepciones en OnBase
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    23/08/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class COM_OnBaseException extends Exception{
     public String strprueba {get; set;}
}