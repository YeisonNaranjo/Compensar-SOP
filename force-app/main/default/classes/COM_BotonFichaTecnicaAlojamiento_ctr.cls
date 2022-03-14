/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Controlador para la pagina encargada de redireccionar hacia el visualizador de PDF's

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/01      Juan David Uribe Ruiz   Creación Clase.
************************************************************************************************/
public with sharing class COM_BotonFichaTecnicaAlojamiento_ctr {
	
	public Opportunity objOpportunity {get; set;} 
	
	public COM_BotonFichaTecnicaAlojamiento_ctr(ApexPages.StandardController controller) {
			objOpportunity = (Opportunity) controller.getRecord();  
	}
	
	public PageReference redireccionar(){
		PageReference pageRef = new PageReference('/apex/COM_Visualizador_pag?customObjectId='+objOpportunity.Id+'&tipo=COM_PVE_CotizacionFichaTecnicaLago_pag&tipoDoc=FichaTecnica');
		return pageRef;
	}
    
}