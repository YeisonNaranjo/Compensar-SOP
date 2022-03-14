/****************************************************************************************************
    Información general
    -------------------
    author: Elkin Córdoba
    email: ecordoba@avanxo.com
    company: Avanxo Colombia
    Description: Clase de prueba de la clase COM_ActualizarCasosColas_sch
        
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       30-Jul-2018     Elkin Córdoba       Creación de la Clase
****************************************************************************************************/
@istest
class COM_ActualizarCasosColas_sch_tst {
    
    static testmethod void scheduleJobTest() {
        
        Test.startTest();        
        COM_ActualizarCasosColas_sch p = new COM_ActualizarCasosColas_sch();
        String sch = '0 0 * * * ?';
        system.schedule('Test COM_ActualizarCasosColas_queue SCH', sch, p);        
        Test.stopTest();
    }
}