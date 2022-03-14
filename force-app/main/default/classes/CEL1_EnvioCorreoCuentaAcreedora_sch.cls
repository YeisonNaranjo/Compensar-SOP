/*******************************************************************************
Desarrollado por:  Avanxo Colombia 
Autor:   <Paula Bohorquez> 
Proyecto:  <Compensar Celula> 
Descripción:  Clase Schedulable para el batch CEL1_EnvioCorreoCuentaAcreedora_sch

Cambios (Versiones)     
-------------------------------------     
No.     Fecha        Autor                        Descripción     
------  ----------   --------------------------   -----------     
1.0     10-12-2019   Paula Bohorquez              Creación de la clase      
*******************************************************************************/
global class CEL1_EnvioCorreoCuentaAcreedora_sch implements Schedulable {
    global void execute(SchedulableContext sc) {
        CEL1_EnvioCorreoCuentaAcreedora_bch batchCuentaAcreedora = new CEL1_EnvioCorreoCuentaAcreedora_bch();
        database.executebatch(batchCuentaAcreedora,100);
    }
}