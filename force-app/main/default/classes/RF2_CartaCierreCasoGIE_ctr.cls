/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce RF2_CartaCierreCasoGIE_pag
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-28      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/

public class RF2_CartaCierreCasoGIE_ctr {
    
    public RF2_CartaCierreCasoGIE__mdt contenidoCarta {get;set;}
    public RF2_InformacionCompensar__mdt contenidoCompensar {get;set;}
    public String fecha {get;set;}
    public String consecutivo {get;set;}
    public Case objCaso {get;set;}
    public User objUser {get;set;}
    public String asesorNombre {get;set;}
    public String asesorCargo {get;set;}
    public String asesorProceso {get;set;}
    public String casoRespuesta {get;set;}
    public String clienteNombre {get;set;}
    public String clienteDireccion {get;set;}
    public String clienteTelefono {get;set;}
    public String clienteCiudad {get;set;}
    public String tipoDoc {get;set;}
    public String elaboro {get;set;}
        
    public RF2_CartaCierreCasoGIE_ctr() {
        String idCaso = ApexPages.currentPage().getParameters().get('idCaso');
        tipoDoc = ApexPages.currentPage().getParameters().get('tipoDoc');
        objCaso = [SELECT CaseNumber, RF2_ComentarioCierre__c, OwnerId, ContactId, Contact.Name, RF2_NombreContactoHuerfano__c, Contact.COM_Direccion__c, RF2_DireccionHuerfano__c,
            Contact.COM_Telefono__c, RF2_TelefonoHuerfano__c, AccountId, Account.Name, Account.COM_Direccion__c, Account.Phone, Account.COM_Ciudad__r.Name, RF2_CiudadHuerfano__r.Name,
            RF2_EsPCA__c, RF2_EsPCE__c, RF2_EsGIE__c,RF2_NumeroRadicadoExterno__c 
          FROM Case WHERE Id =:idCaso];
        List<User> lstUser = [SELECT FirstName, LastName, Title, Department FROM User WHERE Id =:objCaso.OwnerId];  
        if(lstUser.isEmpty()){
            system.debug('--------> El propietario no es un usuario, no se puede generar el PDF.');
            return;
        } else {
            objUser = lstUser.get(0);
        }
    }

    public void cargarContenidoCarta(){
        String numero = objCaso.CaseNumber+(objCaso.RF2_NumeroRadicadoExterno__c!=null?'-'+objCaso.RF2_NumeroRadicadoExterno__c:'');
        system.debug('numero -> '+numero);
        consecutivo ='RESPUESTA A SOLICITUD No. ('+numero+')'; 
        //consecutivo = (objCaso.RF2_EsPCA__c?'PCA':(objCaso.RF2_EsPCE__c?'PCE':(objCaso.RF2_EsGIE__c?'GIE':'')))+'-'+numero;
        system.debug('consecutivo -> '+consecutivo);
        fecha = COM_Utilidades_cls.obtenerMes(Date.Today().month())+' '+String.valueOf(Date.Today().day())+' de '+String.valueOf(Date.Today().year());
        contenidoCarta = (RF2_CartaCierreCasoGIE__mdt) cargarContenidoMetadata('RF2_CartaCierreCasoGIE__mdt');
        contenidoCompensar = (RF2_InformacionCompensar__mdt) cargarContenidoMetadata('RF2_InformacionCompensar__mdt');
        casoRespuesta = '';
        if (objCaso.RF2_ComentarioCierre__c != null)   
            for(String r : objCaso.RF2_ComentarioCierre__c.split('\n')){
                casoRespuesta += '<p align="justify">'+r+'</p>';
            }
        
        if(objCaso.AccountId == null && objCaso.ContactId == null){
            clienteNombre = objCaso.RF2_NombreContactoHuerfano__c;
            clienteDireccion = objCaso.RF2_DireccionHuerfano__c;
            clienteTelefono = objCaso.RF2_TelefonoHuerfano__c;
            if(objCaso.RF2_CiudadHuerfano__r.Name!=null)
                clienteCiudad = objCaso.RF2_CiudadHuerfano__r.Name;
            else
                clienteCiudad = 'La Ciudad';
        } else if(objCaso.ContactId != null){
            clienteNombre = objCaso.Contact.Name;
            clienteDireccion = objCaso.Contact.COM_Direccion__c;
            clienteTelefono = objCaso.Contact.COM_Telefono__c;
            clienteCiudad = 'La Ciudad';
        } else if(objCaso.AccountId != null){   
            clienteNombre = objCaso.Account.Name;
            clienteDireccion = objCaso.Account.COM_Direccion__c;
            clienteTelefono = objCaso.Account.Phone;
            if(objCaso.Account.COM_Ciudad__r.Name!=null)
                clienteCiudad = objCaso.Account.COM_Ciudad__r.Name;
            else
                clienteCiudad = 'La Ciudad';
        }
        if(tipoDoc == Label.RF2_CartaConFirma){
            asesorNombre = contenidoCarta.RF2_NombreGestorGIE__c;
            asesorCargo = contenidoCarta.RF2_CargoGIEArea__c;
            asesorProceso = contenidoCarta.RF2_ProcesoGIEArea__c;
            elaboro = contenidoCarta.RF2_Elaboro__c.replace('{!nombreAsesor}',objUser.FirstName+' '+objUser.LastName);
        } else {
            asesorNombre = objUser.FirstName+' '+objUser.LastName;
            asesorCargo = objUser.Title;
            asesorProceso = objUser.Department;
        }   
        asesorNombre = asesorNombre.toUpperCase('es'); 
    }    

    private SObject cargarContenidoMetadata(String objetoMetadata){
        List<String> lstCampos = new List<String>();
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objetoMetadata).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){
                Schema.DescribeFieldResult fd = ft.getDescribe();
                lstCampos.add(String.valueOf(fd.getSobjectField()));
            }
        }
        String query = 'SELECT '+string.join(lstCampos,',')+' FROM '+objetoMetadata;
        List<Object> lstContenido = Database.query(query);
        if(objetoMetadata == 'RF2_InformacionCompensar__mdt')
            return (RF2_InformacionCompensar__mdt) lstContenido.get(0);
        else if(objetoMetadata == 'RF2_CartaCierreCasoGIE__mdt')
            return (RF2_CartaCierreCasoGIE__mdt) lstContenido.get(0);
        return null;       
    }

}