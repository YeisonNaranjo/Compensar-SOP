/**
**************************************************************************************************************
* @company          Globant
* @author           milton.romeor@globant.com>
* @project          Compensar - Consorcio Salud
* @description      Data transfer object  
* @dependencies     None
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------------
* @version   1.0   30-10-2020   Milton Romero                 Initial version.
**************************************************************************************************************
**/
global class COS_creaProspectoResponse_dto {
	public class responseLead{
        public string TipoID		{get; set;}
        public string NumID			{get; set;}
        public string EstadoTransaccion {get; set;}
        public string Comentario	{get; set;}
        public string IdProspecto	{get; set;}
    }
    
    public class Prospecto{
        public list<responseLead> Prospecto	{get; set;}
    }
}