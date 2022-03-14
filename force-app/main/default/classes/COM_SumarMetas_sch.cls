/**
* Avanxo Colombia
* @author 			Stifen Panche Gutierrez (SP)
* Project:			Compensar
* Description:		Clase encargada de ejecutar  un batch para sumar metas individuales, debería enviarse todas las noches.
*                  COM_SumarMetas_sch
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		14/04/2018		Stifen Panche (SP)		Implementacion inicial de la clase.
**/
global class COM_SumarMetas_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		COM_SumarMetas_bch b = new COM_SumarMetas_bch();
		database.executebatch(b, 200);
	}
}