/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase Schedule para programar el batch de envío de documentos a OnBase
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-21      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

global class RF2_EnviarDocumentosOnBase_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		RF2_EnviarDocumentosOnBase_bch bch = new RF2_EnviarDocumentosOnBase_bch();
		database.executeBatch(bch, 1);
	}
}