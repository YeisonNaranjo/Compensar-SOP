/****************************************************************************************************
    Información general
    -------------------
    author: Elkin Córdoba
    email: ecordoba@avanxo.com
    company: Avanxo Colombia
    Description: Clase encolable para actualizar los casos cuyo propetario es una Cola
    
    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       30-Jul-2018     Elkin Córdoba       Creación de la Clase
****************************************************************************************************/
global class COM_ActualizarCasosColas_queue implements Queueable {
          
    public void execute(QueueableContext context) {
        
        List<Case> lstCaseCola = [Select Id, owner.name From Case Where Owner.name like 'Cola%' LIMIT 9999];
       	database.update(lstCaseCola, false);
    }

}