/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de implementar los metodos de interfaz de usuarios para el
 *                  Historial de vinculaciones
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		9/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
public class COM_ConsultarHistVinculaciones_ctr {

    /** Instancia de logica de negocio de las consltas de vinculaciones.**/
    private COM_ConsultarHistVinculaciones_cls logicaConsultarVinculaciones =
            new COM_ConsultarHistVinculaciones_cls();

    /** Instancia que almacena la respuetsa del historial de vinculaciones.**/
    private COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO
            historialVinculaciones = new
                    COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO();

	public  Account account {get; set;}
    /**
     * El constructor de la clase
     */
    public  COM_ConsultarHistVinculaciones_ctr (ApexPages.StandardController controller) {
        Account cuenta = (Account) controller.getRecord();
        account = [Select COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, Name
            FROM Account WHERE Id =:cuenta.Id];
        /*historialVinculaciones =
                logicaConsultarVinculaciones.encontrarHistorialVinculaciones
                        (Integer.valueOf(account.COM_TipoIdentificacion__c),
                                Long.valueOf(account.COM_Numero_de_identificacion__c));*/
    }
    
    public void consultarVinculaciones(){
        //account = (Account) controller.getRecord();
    	setHistorialVinculaciones(logicaConsultarVinculaciones.encontrarHistorialVinculaciones
                        (Integer.valueOf(account.COM_TipoIdentificacion__c),
                                Long.valueOf(account.COM_Numero_de_identificacion__c)));
    }


    /**
	 * Getter del atributo historialVinculaciones.
	 *
	 * @return el atributo historialVinculaciones.
	 */
    public COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO getHistorialVinculaciones() {
        return historialVinculaciones;
    }

	/**
	 * Setter del atributo historialVinculaciones.
	 *
	 * @param historialVinculaciones el atributo historialVinculaciones a establecer.
	 */
    public void setHistorialVinculaciones(
            COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO historialVinculaciones) {
        this.historialVinculaciones = historialVinculaciones;
    }



}