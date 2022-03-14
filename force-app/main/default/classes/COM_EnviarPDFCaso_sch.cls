/** Globant Colombia
* 	@author 			Yeison Naranjo (YN)
* 	Project:			Compensar
* 	Description:		Clase ejecutora del batch para enviar PDF no generados
*					
* 	Changes (Version)
* 	-------------------------------------
*	No.		Date			Author					Description
*	-----	----------		--------------------	---------------
* 	1.0		03/11/2021		Yeison Naranjo (YN)		Clase para enviar PDFs no generados **/

global class COM_EnviarPDFCaso_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		COM_EnviarPDFCaso_bch b = new COM_EnviarPDFCaso_bch();
		database.executebatch(b, 10);
	}
}