/****************************************************************************************************
    Información general
    -------------------
    author: Elkin Córdoba
    email: ecordoba@avanxo.com
    company: Avanxo Colombia
    Description: Clase Schedule para programar la clase encolable COM_ActualizarCasosColas_queue
        
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       30-Jul-2018     Elkin Córdoba       Creación de la Clase
****************************************************************************************************/
global class COM_ActualizarCasosColas_sch implements Schedulable {
  global void execute(SchedulableContext sc) {
    ID jobID = System.enqueueJob(new COM_ActualizarCasosColas_queue());
  }
}