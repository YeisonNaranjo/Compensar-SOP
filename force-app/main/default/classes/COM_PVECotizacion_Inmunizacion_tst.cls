/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			ProjectName
* Description:		Clase encargada de ejecutar  las pruebas unitarias de la clase COM_PVECotizacion_Inmunizacion_ctr
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial la clase.
**/
@istest
public class COM_PVECotizacion_Inmunizacion_tst {

     /**
     * Instancia del controlador.
     */
    private static COM_PVE_Cotizacion_Inmunizacion_ctr controller =
            new COM_PVE_Cotizacion_Inmunizacion_ctr();

    /**
     * Metodo encargado probal el metodo de cargar los datos.
     */
    @istest
    public static void testCargarDatos() {
        controller.cargarDatos();
    }

}