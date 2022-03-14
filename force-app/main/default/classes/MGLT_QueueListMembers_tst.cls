/**
* Avanxo
* @author 			<a href = "mailto:cmosquera@avanxo.com">Cristian Jose Mosquera Puello </a>
* Project:			Compensar
* Description:		Clase encargada de ejecutar  las pruebas unitarias sobre la clase
*                   MGLT_QueueListMembers_ctr
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		4/02/20		Cristian Mosquera (CM)		Implementación inicial de la clase.
**/
@isTest
public class MGLT_QueueListMembers_tst {

    /**
     * Metodo responsable de probal el metodo getQueues.
     */
    @isTest
    private static void testGetQueues () {
        MGLT_QueueListMembers_ctr.QueueResponseDTO responseDTO = MGLT_QueueListMembers_ctr.getQueues();
    }
}