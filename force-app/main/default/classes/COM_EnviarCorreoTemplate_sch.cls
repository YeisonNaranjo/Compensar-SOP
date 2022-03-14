/****************************************************************************************************
    Información general
    -------------------
    author: Jordan Parra
    email: jsparra@avanxo.com
    company: Avanxo Colombia
    Description: Clase COM_EnviarCorreoTemplate_sch para envío de encuesta
        
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       10-Octubre-2019     Jordan Parra              Creación de la Clase
****************************************************************************************************/
global class COM_EnviarCorreoTemplate_sch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
		COM_EnviarCorreoTemplate_bch be = new COM_EnviarCorreoTemplate_bch();
		database.executeBatch(be,10);
	}  
}