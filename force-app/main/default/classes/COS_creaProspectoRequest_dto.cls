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
global class COS_creaProspectoRequest_dto {
    
    public string TipoID					{get; set;}
	public string NumID						{get; set;}
    public string Nombre					{get; set;}
    public string TelefonoContactoFijo		{get; set;}
	public string TelefonoContactoCelular	{get; set;}
    public string Email						{get; set;}
    public string NumeroEmpresa				{get; set;}
    public string Genero					{get; set;}
    public string Fecha						{get; set;}
    public string Asesor					{get; set;}
    public string IDAsesor					{get; set;}
    public string EmailAsesor				{get; set;}
    public string CategoriaCaja				{get; set;}
    public string Fuentes					{get; set;}
    public string DiaContacto				{get; set;}
    public string HorarioIdealContacto		{get; set;}
    public string Asegurabilidad			{get; set;}
    
}