/****************************************************************************************************
    Información general
    -------------------
    author: Yeison Naranjo
    email: yeison.naranjo@globant.com
    company: Globant Colombia
    Description: Clase COM_ActualizarCodARL_sch para Actualización de Código ARL
        
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       05-Febrero-2020 Yeison Naranjo               Creación de la Clase
****************************************************************************************************/
global class COM_ActualizarCodARL_sch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
		COM_ActualizarCodARL_bch ActCodARL = new COM_ActualizarCodARL_bch();
		database.executeBatch(ActCodARL,10);
	}  
}