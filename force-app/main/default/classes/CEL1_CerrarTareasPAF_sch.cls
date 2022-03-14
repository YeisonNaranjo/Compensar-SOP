/**
* Avanxo Colombia
* @author           Paula Bohórquez href=<paula.bohorquez@globant.com>
* Project:          Compensar
* Description:      Clase scheduleable que ejecuta batch que cierra las tareas creadas para notificar a los asesores PAF cuando un candidato
*					fue convertido automáticamente desde una cuenta que tengan una antiguedad mayor a 7 días.
*
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2020-02-18      Paula Bohórquez (PB)            Creación de la clase
*************************************************************************************************************/
global class CEL1_CerrarTareasPAF_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		CEL1_CerrarTareasPAF_bch clsBatch = new CEL1_CerrarTareasPAF_bch();
		database.executebatch(clsBatch,200);
	}
}