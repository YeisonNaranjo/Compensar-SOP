/**
* Avanxo Colombia
* @author 			Stifen Panche Gutierrez (SP)
* Project:			Compensar
* Description:		Clase encargada de ejecutar  un batch para borrar y asociar oportunidades a metas.
*                  COM_BorrarOptyMetas_sch
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		14/04/2018		Stifen Panche (SP)		Implementacion inicial de la clase.
**/
global class COM_BorrarOptyMetas_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		COM_BorrarOptyMetas_bch b = new COM_BorrarOptyMetas_bch();
		database.executebatch(b, 100);
	}
}