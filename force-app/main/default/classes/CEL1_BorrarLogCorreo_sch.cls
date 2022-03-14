/*******************************************************************************
Desarrollado por:  Avanxo Colombia 
Autor:   <Manuel Mendez> 
Proyecto:  <Compensar Celula> 
Descripción:  Clase Schedulable para el batch CEL1_BorrarLogCorreo_bch

Cambios (Versiones)     
-------------------------------------     
No.     Fecha        Autor                        Descripción     
------  ----------   --------------------------   -----------     
1.0     09-12-2019   Manuel Mendez                Create Class      
*******************************************************************************/
global class CEL1_BorrarLogCorreo_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
		CEL1_BorrarLogCorreo_bch clsBatch = new CEL1_BorrarLogCorreo_bch();
		database.executebatch(clsBatch,200);
	}
}