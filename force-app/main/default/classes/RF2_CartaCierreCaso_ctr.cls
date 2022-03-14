/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce RF2_CartaCierreCaso_pag
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-09      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  2.0     2019-02-05      David Yepes                     Modificación de validaciones según
                                                                    especificaciones del caso "00260650" creado
                                                                    en salesforce.
  @version  2.1     2019-04-26      Jordan Parra                    Se realiza condicional para el campo rela-
                                                                    cionado con.
  @version  2.2     2019-05-21      Stifen Panche                   Se omite el campo RF2_RespuestaParrafo__c (00263587).
  @version  2.3     2021-10-07      Alvaro Gomez                    Quitar firma del gestor para casos de subsidio (28886)

****************************************************************************************************************/

public class RF2_CartaCierreCaso_ctr {
    protected String idCase;
    private Case objCaso;
    private List<User> objPropietario;
    //Variables contenido carta
    public String titulo {get;set;} 
    public String saludo {get;set;}  
    public String fecha {get;set;}
    public String clienteNombre {get;set;}
    public String clienteDireccion {get;set;}
    public String clienteTelefono {get;set;}
    public String clienteCiudad {get;set;}
    public String responsableCaso {get;set;}
    public String responsableCargo {get;set;}
    public String responsableArea {get;set;}
//Inicio v2.1
    public String relacionadoCon {get;set;}
//Final v2.1
    //Variables contenido Metadata    
    public CartaCierreCaso__mdt contenido {get;set;}
    public String respuestaParrafo {get;set;}
    public list<String> lstComentarioCierre {get;set;}
    public String comentariosCierre {get;set;} 
    public String cabecera {get;set;} 

    public RF2_CartaCierreCaso_ctr() {
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
       
//Inicio v2.1
    /*    objCaso = [SELECT Id, RF2_TipoSolicitud__c, RF2_ComentarioCierre__c, ContactId, Contact.Name, Contact.COM_Direccion__c, Contact.COM_Telefono__c, OwnerId,
            RF2_NombreContactoHuerfano__c, RF2_DireccionHuerfano__c, RF2_TelefonoHuerfano__c, CaseNumber, AccountId, RF2_CiudadHuerfano__r.Name, Account.Name, 
            Account.COM_Direccion__c, Account.Phone, Account.COM_Ciudad__r.Name,RF2_NumeroRadicadoExterno__c, Contact.COM_Genero__c
            FROM Case    
            WHERE Id =: idCase];
    */

          objCaso = [SELECT Id, RF2_TipoSolicitud__c,RF2_RelacionadoCon__c, RF2_ComentarioCierre__c, ContactId, Contact.Name, Contact.COM_Direccion__c, Contact.COM_Telefono__c, OwnerId,
            RF2_NombreContactoHuerfano__c, RF2_DireccionHuerfano__c, RF2_TelefonoHuerfano__c, CaseNumber, AccountId, RF2_CiudadHuerfano__r.Name, Account.Name, 
            Account.COM_Direccion__c, Account.Phone, Account.COM_Ciudad__r.Name,RF2_NumeroRadicadoExterno__c, Contact.COM_Genero__c
            FROM Case    
            WHERE Id =: idCase];

//Final v2.1

        //clienteNombre = objCaso.ContactId!=null?objCaso.Contact.Name:objCaso.RF2_NombreContactoHuerfano__c;
        //clienteDireccion = objCaso.ContactId!=null?objCaso.Contact.COM_Direccion__c:objCaso.RF2_DireccionHuerfano__c;
        //clienteTelefono = objCaso.ContactId!=null?objCaso.Contact.COM_Telefono__c:objCaso.RF2_TelefonoHuerfano__c;
        if(objCaso.AccountId == null && objCaso.ContactId == null){
            clienteNombre = objCaso.RF2_NombreContactoHuerfano__c;
            clienteDireccion = objCaso.RF2_DireccionHuerfano__c;
            clienteTelefono = objCaso.RF2_TelefonoHuerfano__c;
            if(objCaso.RF2_CiudadHuerfano__r.Name!=null)
                clienteCiudad = objCaso.RF2_CiudadHuerfano__r.Name;
            else
                clienteCiudad = 'La Ciudad';
        } else if(objCaso.AccountId != null){   
            clienteNombre = objCaso.Account.Name;
            clienteDireccion = objCaso.Account.COM_Direccion__c;
            clienteTelefono = objCaso.Account.Phone;
            if(objCaso.Account.COM_Ciudad__r.Name!=null)
                clienteCiudad = objCaso.Account.COM_Ciudad__r.Name;
            else
                clienteCiudad = 'La Ciudad';
        }  else if(objCaso.ContactId != null){
            clienteNombre = objCaso.Contact.Name;
            clienteDireccion = objCaso.Contact.COM_Direccion__c;
            clienteTelefono = objCaso.Contact.COM_Telefono__c;
            clienteCiudad = 'La Ciudad';
        }
        System.debug('>> 43 - objCaso.OwnerId: '+objCaso.OwnerId);  
        objPropietario = [SELECT FirstName, LastName, Title, Department
            FROM User    
            WHERE Id =: objCaso.OwnerId limit 1];


        // verifica si se obtuvo un usario propietario    
        if(objPropietario != null && !objPropietario.isEmpty()){
        //Inicio 2.1
        if(objCaso.RF2_RelacionadoCon__c != null)
        {
            /*Inicio 2.3
            if(objCaso.RF2_RelacionadoCon__c.contains('Subsidio')){
               responsableCaso = System.Label.NombreAsesor;
               responsableCargo = System.Label.Cargo_asesor;
            }
            else
			Fin 2.3
			*/{
        //Final 2.1    
            responsableCaso = objPropietario.get(0).FirstName+' '+objPropietario.get(0).LastName;
            responsableCargo = objPropietario.get(0).Title;
            responsableArea = objPropietario.get(0).Department;
            } 
        }
        else{
        //Final 2.1    
            responsableCaso = objPropietario.get(0).FirstName+' '+objPropietario.get(0).LastName;
            responsableCargo = objPropietario.get(0).Title;
            responsableArea = objPropietario.get(0).Department;
            } //Llave final 2.1
        }else{
            // definir como responder en caso de que no responde un usuario
            // el ownerid corresponde a una cola
            responsableCaso = '';
            responsableCargo = '';
            responsableArea = '';
        }
        comentariosCierre = '';
        lstComentarioCierre = new list<String>();
        if(objCaso.RF2_ComentarioCierre__c != null){
           for(String r : objCaso.RF2_ComentarioCierre__c.split('\n')){
                //for(String r : objCaso.RF2_ComentarioCierre__c)){
                    lstComentarioCierre.add(r);
             //   comentariosCierre += r;
                //comentariosCierre = objCaso.RF2_ComentarioCierre__c;
                //comentariosCierre = objCaso.RF2_ComentarioCierre__c.replace('\\n', '<br\\>');
            }
        }

//Inicio Versión 2.0

        //Validación de Saludo según el genero del contacto
        if(objCaso.Contact != null && objCaso.Contact.COM_Genero__c != null){

           if(objCaso.Contact.COM_Genero__c == 'M'){

                titulo = 'Señor';
                //saludo = 'Respetado Señor';
            }else if (objCaso.Contact.COM_Genero__c == 'F'){

                titulo = 'Señora';
                //saludo = 'Respetada Señora';
            }
        }else{

                titulo = 'Señores';
                //saludo = 'Respetados Señores';
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
        contenido = [SELECT RF2_Ciudad__c, RF2_Titulo__c, RF2_Saludo__c, RF2_Cabecera__c, RF2_ParrafoUno__c, RF2_RespuestaParrafo__c, RF2_ParrafoTres__c, 
            RF2_ParrafoCuatro__c, RF2_Despedida__c, RF2_DatosFirma__c, RF2_LaCiudad__c
            FROM CartaCierreCaso__mdt];

       /*inicio 2.2*/
       /* if(objCaso.RF2_TipoSolicitud__c != null){            
            respuestaParrafo = contenido.RF2_RespuestaParrafo__c.replace('{RF2_TipoSolicitud__c}', objCaso.RF2_TipoSolicitud__c);
        }else{
            respuestaParrafo = contenido.RF2_RespuestaParrafo__c.replace('{RF2_TipoSolicitud__c}', 'solicitud ');    
        }*/
        /*Fin 2.2*/

        String numero = objCaso.CaseNumber+(objCaso.RF2_NumeroRadicadoExterno__c!=null?'-'+objCaso.RF2_NumeroRadicadoExterno__c:'');
        cabecera = contenido.RF2_Cabecera__c.replace('{CaseNumber}', numero);
    }

}