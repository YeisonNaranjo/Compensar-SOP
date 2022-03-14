/**
* Avanxo Colombia
* @author       Stifen Panche Gutierrez (SP)
* Project:      Compensar
* Description:  Clase encargada de ejecutar un batch para asignar propietario a casos en colas.
* Changes (Version)
* -------------------------------------
* No.                 Date            Author              Description
*  ----- ----------    ------------------------------     ---------------
* @version  1.0       25/10/2018    Stifen Panche (SP)    Clase de prueba para Encolable_cls y AsignarPropietarioColas_sch
**/


global class COM_AsignarPropietarioColas_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		COM_AsignarPropietarioColas_bch bch = new COM_AsignarPropietarioColas_bch();
        database.executeBatch(bch, 1);
	}
}