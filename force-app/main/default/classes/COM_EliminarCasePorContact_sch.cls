/**
* Avanxo Colombia
* @author 			Stifen Panche Gutierrez (SP)
* Project:			Compensar
* Description:		Clase encargada de ejecutar  un batch para desasociar casos a contactos temporales
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		14/04/2018		Stifen Panche (SP)		Implementacion inicial de la clase.
* @version  2.0     09/02/2021      Gonzalo Rivas (GR)      Se modifica el tamaño del batch
**/
global class COM_EliminarCasePorContact_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		COM_EliminarCasePorContact_bch b = new COM_EliminarCasePorContact_bch();
		database.executebatch(b, 50);
	}
}