/**
 * Avanxo Colombia
 * @author           Elkin Córdoba href=<ecordoba@avanxo.com>
 * Project:          Compensar
 * Description:      Controlador de la visualforce RF2_CartaCierreCasoProceso_pag
 *
 * Changes (Version)
 * -------------------------------------
 *           No.     Date            Author                          Description
 *           -----   ----------      --------------------            ---------------
 * @version  1.0     2019-07-15      Elkin Córdoba (EC)              Creación clase.
 ****************************************************************************************************************/

public class RF2_CartaCierreCasoProceso_ctr {

    public RF2_CartaCierreCasoProceso__mdt contenidoCarta { get; set; }
    public RF2_InformacionCompensar__mdt contenidoCompensar { get; set; }
    public String fecha { get; set; }
    public String consecutivo { get; set; }
    public Case objCaso { get; set; }
    public User objUser { get; set; }
    public String asesorNombre { get; set; }
    public String asesorCargo { get; set; }
    public String asesorProceso { get; set; }
    public String casoRespuesta { get; set; }
    public String clienteNombre { get; set; }
    public String clienteDireccion { get; set; }
    public String clienteTelefono { get; set; }
    public String clienteCiudad { get; set; }
    public String elaboro { get; set; }
    public String tituloCliente { get; set; }
    public String tituloRespetado { get; set; }
    public String saludoCompensarMiPlanilla {get; set;}

    public RF2_CartaCierreCasoProceso_ctr() {
        String idCaso = ApexPages.currentPage().getParameters().get('idCaso');
        objCaso = [SELECT CaseNumber, RF2_ComentarioCierre__c, OwnerId, ContactId, Contact.Name, RF2_NombreContactoHuerfano__c, Contact.COM_Direccion__c, RF2_DireccionHuerfano__c,
                   Contact.COM_Telefono__c, RF2_TelefonoHuerfano__c, AccountId, Account.Name, Account.COM_Direccion__c, Account.Phone, Account.COM_Ciudad__r.Name, RF2_CiudadHuerfano__r.Name,
                   RF2_EsPCA__c, RF2_EsPCE__c, RF2_EsGIE__c, RF2_NumeroRadicadoExterno__c, Contact.COM_Genero__c
                   FROM Case WHERE Id = :idCaso];
        List<User> lstUser = [SELECT FirstName, LastName, Title, Department FROM User WHERE Id = :objCaso.OwnerId];
        if (lstUser.isEmpty()) {
            system.debug('--------> El propietario no es un usuario, no se puede generar el PDF.');
            return;
        } else {
            objUser = lstUser.get(0);
        }
    }

    public void cargarContenidoCarta() {
        String numero = objCaso.CaseNumber + (objCaso.RF2_NumeroRadicadoExterno__c != null ? '-' + objCaso.RF2_NumeroRadicadoExterno__c : '');
        consecutivo = 'RESPUESTA A SOLICITUD No. (' + numero + ')';
        fecha = COM_Utilidades_cls.obtenerMes(Date.Today().month()) + ' ' + String.valueOf(Date.Today().day()) + ' de ' + String.valueOf(Date.Today().year());
        contenidoCarta = (RF2_CartaCierreCasoProceso__mdt) cargarContenidoMetadata('RF2_CartaCierreCasoProceso__mdt');
        contenidoCompensar = (RF2_InformacionCompensar__mdt) cargarContenidoMetadata('RF2_InformacionCompensar__mdt');
        casoRespuesta = '';
        if (objCaso.RF2_ComentarioCierre__c != null)
        for (String r : objCaso.RF2_ComentarioCierre__c.split('\n')) {
            casoRespuesta += '<p align="justify">' + r + '</p>';
        }

        if (objCaso.AccountId == null && objCaso.ContactId == null) {
            clienteNombre = objCaso.RF2_NombreContactoHuerfano__c;
            clienteDireccion = objCaso.RF2_DireccionHuerfano__c;
            clienteTelefono = objCaso.RF2_TelefonoHuerfano__c;
            tituloRespetado = 'Respetados';
            tituloCliente = 'Señores';
            saludoCompensarMiPlanilla = 'Reciban';
            if (objCaso.RF2_CiudadHuerfano__r.Name != null)
            clienteCiudad = objCaso.RF2_CiudadHuerfano__r.Name;
            else
            clienteCiudad = 'La Ciudad';
        } else if (objCaso.ContactId != null) {
            clienteNombre = objCaso.Contact.Name;
            clienteDireccion = objCaso.Contact.COM_Direccion__c;
            clienteTelefono = objCaso.Contact.COM_Telefono__c;
            if (objCaso.Contact.COM_Genero__c != null && objCaso.Contact.COM_Genero__c == 'M') {
                tituloRespetado = 'Respetado';
                tituloCliente = 'Señor';
                saludoCompensarMiPlanilla = 'Reciba';
            } else if (objCaso.Contact.COM_Genero__c != null && objCaso.Contact.COM_Genero__c == 'F') {
                tituloRespetado = 'Respetada';
                tituloCliente = 'Señora';
                saludoCompensarMiPlanilla = 'Reciba';
            } else {
                tituloRespetado = 'Respetados';
                tituloCliente = 'Señores';
                saludoCompensarMiPlanilla = 'Reciban';
            }
            if (objCaso.Account.COM_Ciudad__r.Name != null)
            clienteCiudad = objCaso.Account.COM_Ciudad__r.Name;
            else
            clienteCiudad = 'La Ciudad';
        } else if (objCaso.AccountId != null) {
            clienteNombre = objCaso.Account.Name;
            clienteDireccion = objCaso.Account.COM_Direccion__c;
            clienteTelefono = objCaso.Account.Phone;
            tituloRespetado = 'Respetados';
            tituloCliente = 'Señores';
            saludoCompensarMiPlanilla = 'Reciban';
            if (objCaso.Account.COM_Ciudad__r.Name != null)
            clienteCiudad = objCaso.Account.COM_Ciudad__r.Name;
            else
            clienteCiudad = 'La Ciudad';
        }

        asesorNombre = objUser.FirstName + ' ' + objUser.LastName;
        asesorCargo = objUser.Title;
        asesorProceso = objUser.Department;
        asesorNombre = asesorNombre.toUpperCase('es');
    }

    private SObject cargarContenidoMetadata(String objetoMetadata) {
        List<String> lstCampos = new List<String> ();
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objetoMetadata).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string> ();
        if (fMap != null) {
            for (Schema.SObjectField ft : fMap.values()) {
                Schema.DescribeFieldResult fd = ft.getDescribe();
                lstCampos.add(String.valueOf(fd.getSobjectField()));
            }
        }
        String query = 'SELECT ' + string.join(lstCampos, ',') + ' FROM ' + objetoMetadata;
        List<Object> lstContenido = Database.query(query);
        if (objetoMetadata == 'RF2_InformacionCompensar__mdt')
        return(RF2_InformacionCompensar__mdt) lstContenido.get(0);
        else if (objetoMetadata == 'RF2_CartaCierreCasoProceso__mdt')
        return(RF2_CartaCierreCasoProceso__mdt) lstContenido.get(0);
        return null;
    }
}