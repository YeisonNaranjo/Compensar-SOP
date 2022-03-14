public class RL2_CartaCierreCasoPSB_ctr {
    protected String idCase;
    private Case objCaso;
    private List<User> objPropietario;
    //Variables contenido carta
    public String titulo {get;set;} 
    public String saludo {get;set;}  
    public String fecha {get;set;}
    public String clienteNombre {get;set;}
    public String clienteDireccion {get;set;}
    public String clienteEmail {get;set;}
    public String clienteTelefono {get;set;}
    public String clienteCiudad {get;set;}
    public String responsableCaso {get;set;}
    public String responsableCargo {get;set;}
    public String responsableArea {get;set;}
//Inicio v2.1
    public String relacionadoCon {get;set;}
//Final v2.1
    //Variables contenido Metadata    
    public RL2_CartaCierreCaso_PSB__mdt contenido {get;set;}
    public String respuestaParrafo {get;set;}
    public list<String> lstComentarioCierre {get;set;}
    public String comentariosCierre {get;set;} 
    public String cabecera {get;set;} 

    public RL2_CartaCierreCasoPSB_ctr() {
        idCase = ApexPages.currentPage().getParameters().get('idCase');
        cargarContenidoCarta();     
    }

    public static String obtenerMesPCE(Integer intMes){
        if(intMes == 1){
            return 'enero';
        } else if(intMes == 2){
            return 'febrero';
        } else if(intMes == 3){
            return 'marzo';
        } else if(intMes == 4){
            return 'abril';
        } else if(intMes == 5){
            return 'mayo';
        } else if(intMes == 6){
            return 'junio';
        } else if(intMes == 7){
            return 'julio';
        } else if(intMes == 8){
            return 'agosto';
        } else if(intMes == 9){
            return 'septiembre';
        } else if(intMes == 10){
            return 'octubre';
        } else if(intMes == 11){
            return 'noviembre';
        } else if(intMes == 12){
            return 'diciembre';
        } else{
            return null;
        }
    } 

    public void cargarContenidoCarta(){

          objCaso = [SELECT Id, RF2_TipoSolicitud__c,RF2_RelacionadoCon__c, RF2_ComentarioCierre__c, ContactId, Contact.Name, Contact.COM_Direccion__c, Contact.COM_Telefono__c, OwnerId,
            RF2_NombreContactoHuerfano__c, RF2_DireccionHuerfano__c, RF2_CorreoelectronicoHuerfano__c,RF2_TelefonoHuerfano__c, CaseNumber, AccountId, RF2_CiudadHuerfano__r.Name, Account.Name, 
            Account.COM_Direccion__c, Account.Phone, Account.COM_Ciudad__r.Name,RF2_NumeroRadicadoExterno__c, Contact.COM_Genero__c, Contact.COM_Correo_electronico_personal__c, Account.COM_CorreoElectronico__c
            FROM Case    
            WHERE Id =: idCase];

        if(objCaso.AccountId == null && objCaso.ContactId == null){
            clienteNombre = objCaso.RF2_NombreContactoHuerfano__c;
            clienteDireccion = objCaso.RF2_DireccionHuerfano__c;
            clienteEmail = objCaso.RF2_CorreoelectronicoHuerfano__c;
            clienteTelefono = objCaso.RF2_TelefonoHuerfano__c;
            if(objCaso.RF2_CiudadHuerfano__r.Name!=null){ clienteCiudad = objCaso.RF2_CiudadHuerfano__r.Name; }
            else{ clienteCiudad = 'La Ciudad'; }
        } else if(objCaso.AccountId != null){   
            clienteNombre = objCaso.Account.Name;
            clienteDireccion = objCaso.Account.COM_Direccion__c;
            clienteEmail = objCaso.Account.COM_CorreoElectronico__c;
            clienteTelefono = objCaso.Account.Phone;
            if(objCaso.Account.COM_Ciudad__r.Name!=null){ clienteCiudad = objCaso.Account.COM_Ciudad__r.Name; }
            else{ clienteCiudad = 'La Ciudad'; }
        }  else if(objCaso.ContactId != null){
            clienteNombre = objCaso.Contact.Name;
            clienteDireccion = objCaso.Contact.COM_Direccion__c;
            clienteEmail = objCaso.Contact.COM_Correo_electronico_personal__c;
            clienteTelefono = objCaso.Contact.COM_Telefono__c;
            clienteCiudad = 'La Ciudad';
        }
        
        objPropietario = [SELECT FirstName, LastName, Title, Department
                            FROM User    
                            WHERE Id =: objCaso.OwnerId WITH SECURITY_ENFORCED LIMIT 1];
        
        if(objPropietario != null && !objPropietario.isEmpty()){
            if(objCaso.RF2_RelacionadoCon__c != null){
                responsableCaso = objPropietario.get(0).FirstName+' '+objPropietario.get(0).LastName;
                responsableCargo = objPropietario.get(0).Title;
                responsableArea = objPropietario.get(0).Department;
            }else{
                responsableCaso = objPropietario.get(0).FirstName+' '+objPropietario.get(0).LastName;
                responsableCargo = objPropietario.get(0).Title;
                responsableArea = objPropietario.get(0).Department;
            }
        }else{
            responsableCaso = '';
            responsableCargo = '';
            responsableArea = '';
        }
        comentariosCierre = '';
        lstComentarioCierre = new list<String>();
        if(objCaso.RF2_ComentarioCierre__c != null){
           for(String r : objCaso.RF2_ComentarioCierre__c.split('\n')){
                lstComentarioCierre.add(r);
            }
        }

        if(objCaso.Contact != null && objCaso.Contact.COM_Genero__c != null){
           if(objCaso.Contact.COM_Genero__c == 'M'){
                titulo = 'Señor';
            }else if (objCaso.Contact.COM_Genero__c == 'F'){
                titulo = 'Señora';
            }
        }else{
            titulo = 'Señores';
        }
        //Valida el formato en el que va a mostrar la fecha según el día que se genera la carta
        if(Date.Today().day() == 01){
            fecha = 'Primero de ' + obtenerMesPCE(Date.Today().month())+' de '+String.valueOf(Date.Today().year());
        } else if(Date.Today().day() < 10){
            fecha = String.valueOf(Date.Today().day()).substring(0,1)+ ' de ' + obtenerMesPCE(Date.Today().month())+' de '+String.valueOf(Date.Today().year());
        } else{
            fecha = String.valueOf(Date.Today().day())+ ' de ' + obtenerMesPCE(Date.Today().month())+' de '+String.valueOf(Date.Today().year());
        }
        //Fin Versión 2.0
        contenido = [SELECT RL2_Ciudad__c, RL2_Titulo__c, RL2_Saludo__c, RL2_Cabecera__c, RL2_ParrafoUno__c, RL2_RespuestaParrafo__c, RL2_ParrafoTres__c, 
                    RL2_ParrafoCuatro__c, RL2_Despedida__c, RL2_DatosFirma__c, RL2_LaCiudad__c
                    FROM RL2_CartaCierreCaso_PSB__mdt];

        String numero = objCaso.CaseNumber+(objCaso.RF2_NumeroRadicadoExterno__c!=null?'-'+objCaso.RF2_NumeroRadicadoExterno__c:'');
        cabecera = contenido.RL2_Cabecera__c.replace('{CaseNumber}', numero);
    }
}