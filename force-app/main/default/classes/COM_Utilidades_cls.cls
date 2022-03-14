/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase de utilidades
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    27/07/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   2.0    25/09/2019      Paula Bohórquez Alfonso             Migración Lightning - Se reemplazan Attachments por Content Documents.
****************************************************************************************************************/
public with sharing class COM_Utilidades_cls {
    
    /* 
    * Nombre: obtenerFechaActualFormateadaStr
    * Descripcion: Metodo encargado de retornar la fecha actual del sistema en un formato dado
    * Fecha Creación: 27/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            27-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public static String obtenerFechaActualFormateadaStr(String strFormato){
        DateTime dt = DateTime.now();
        return dt.format(strFormato);
    }
    
    /* 
    * Nombre: stringToDatetime
    * Descripcion: Metodo encargado convertir una fecha String en un Datetime, la fecha 
    *              debe de venir en formato yyyy-MM-dd HH:mm:ss
    * Fecha Creación: 27/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            27-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public static Datetime stringToDatetime(String strDatetime){
        try {
            strDatetime = strDatetime.trim().replace('T', ' ');
            return datetime.valueOf(strDatetime);
        } catch (Exception e) {
            return null;
        }
    }
    
    /* 
    * Nombre: generarRandom
    * Descripcion: Metodo encargado de generar numero aleatorio del tamaño recibido en el parametro
    * Fecha Creación: 27/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            27-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public static String generarRandom(Integer intLen){
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        return str.substring(0, intLen);
    }

    /**
     * @description Metodo encargado de calcular los años emtre 2 fechas.
     * @param date1 fecha final (la mas actual).
     * @param fecha inicial (la mas antigua).
     * @return el numero de anos transcurridos.
     */
    public static integer calculateYearsBetweenFechas (Datetime endDate, Datetime startDate) {
        /*long ageMils  = date1.getTime() - date2.getTime();
        Datetime age = Datetime.newInstance(ageMils);
        return date1.year() - age.year();*/

        Date uno1 = startDate.date();
        Date dos2 = endDate.date();
        return uno1.monthsBetween(dos2)/12;
    }


    /**
     * @description Metodo encargado de calcular los años emtre 2 fechas.
     * @param date1 fecha final (la mas actual).
     * @param fecha inicial (la mas antigua).
     * @return el numero de anos transcurridos.
     */
    public static integer calculateDaysBetweenFechas (Datetime endDate, Datetime startDate) {
        /*long ageMils  = date1.getTime() - date2.getTime();
        Datetime age = Datetime.newInstance(ageMils);
        return date1.year() - age.year();*/

        Date uno1 = startDate.date();
        Date dos2 = endDate.date();
        return uno1.daysBetween(dos2);  
    }
    /* 
    * Nombre: calcularFechaDiasHabiles
    * Descripcion: Metodo encargado de contar días habiles a partir de una fecha 
    * Fecha Creación: 24/08/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            24-Ago-2017     Rubén Suárez Forero         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
   
    public static DateTime calcularFechaDiasHabiles(String idHorario, Datetime fechaIni, Integer diasHabiles){
        try{
            Long intervalo = diasHabiles*24*60*60*1000L;
            Datetime fechaFin = BusinessHours.addGmt(idHorario, fechaIni, intervalo);
            system.debug('\n');
            system.debug(fechaIni);
            system.debug(fechafin);
            system.debug(fechafin.hourGMT());
            
            if(fechaFin.hourGMT() == 5){
                return fechaFin+3;
            } else if (fechaFIN.format('u') == '5'){
                return BusinessHours.addGmt(idHorario, fechaFin, 12*60*60*1000L);
            } else if (fechaFIN.format('u') == '6'){
                return BusinessHours.addGmt(idHorario, fechaFin, 12*60*60*1000L);
            }else{
                return fechaFin;
            }
        } catch(Exception e){
            System.debug('Error: '+e.getMessage());
            return null;
        }
    }

    /* 
    * Nombre: calcularNumeroDiasHabiles
    * Descripcion: Metodo encargado de contar días habiles a partir de una fecha 
    * Fecha Creación: 24/08/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            24-Ago-2017     Rubén Suárez Forero         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */

    public static Integer calcularNumeroDiasHabiles(String idHorario, Datetime fechaIni){
        try{
            Datetime fechaHoy = Datetime.newInstanceGmt(datetime.now().year(), datetime.now().month(), datetime.now().day(), 0, 0, 1);
            Integer dias = Integer.valueOf(BusinessHours.diff(idHorario, fechaHoy, fechaini)/60/60/24/1000);
            return dias;
        } catch(Exception e){
            System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    /* 
    * Nombre: calcularNumeroDiasHabilesDecimal
    * Descripcion: Metodo encargado de contar días habiles a partir de una fecha y la cantidad de horas del día 
    * Fecha Creación: 15/12/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-Dic-2017     Rubén Suárez Forero         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public static Decimal calcularNumeroDiasHabilesDecimal(String idHorario, Datetime fechaIni, Decimal horas){
        try{
            Datetime fechaHoy = Datetime.newInstance(datetime.now().year(), datetime.now().month(), datetime.now().day(), datetime.now().hour(), datetime.now().minute(), datetime.now().second());
            Decimal dias = BusinessHours.diff(idHorario, fechaini, fechaHoy)/60.0/60.0/horas/1000.0;
            system.debug('fechaini -> '+fechaini);
            system.debug('fechaHoy -> '+fechaHoy);
            return dias;
        } catch(Exception e){
            System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    /**
     * @autor Juan David Uribe Ruiz
     * @description Convierte un item de un map en una lista en caso que dicho item no sea una lista
     * @param map<Object, Object> mapProcesar: map con la informacion a procesar
     * @param String strCampoBuscar: Etiqueta del campo a buscar dentro del map para que sea convertido en lista
     * @return void
     **/
    public static void convertItemToList(map<Object, Object> mapProcesar, String strCampoBuscar){
        object objNodo;
        //Se recorre el map  que llego
        for (object fieldName : mapProcesar.keySet()){
            //Se obtiene un elemento del map en el ciclo actual
            objNodo = mapProcesar.get(fieldName);
            //Si el objeto obtenido es de tipo map y si coincide con la etiqueta
            //que se esta buscando se procede a agregarlo dentro de una lista, de lo
            //contrario se invoca recursivamente el metodo
            if(objNodo instanceof map<Object, Object>){
                if((String)fieldName == strCampoBuscar){
                    mapProcesar.put(strCampoBuscar, new list<Object>{objNodo});
                } else{
                    convertItemToList((map<Object, Object>)objNodo, strCampoBuscar);
                }
            } else{
                //Si no es de tipo map y si coincide con la etiqueta buscada se valida si 
                //ya es una lista, si lo es no se hace nada, de lo contrario se procede a 
                //agregarlo dentro de una lista
                if((String)fieldName == strCampoBuscar){
                    if(objNodo instanceof list<object>){
                        system.debug('Es lista ' + objNodo);
                    } else{
                        mapProcesar.put(strCampoBuscar, new list<Object>{objNodo});
                    }
                } else{
                    //Si no es el campo buscado, pero es de tipo lista, se procede a recorrer dicha
                    //lista y a invocar recursivamente el metodo para que procese los elementos de la lista
                    if(objNodo instanceof list<object>){
                        for(object objNodoAux : (list<object>)objNodo){
                            if(objNodoAux instanceof map<Object, Object>){
                                convertItemToList((map<Object, Object>)objNodoAux, strCampoBuscar);
                            } else{
                                system.debug('     .' + fieldName + ' Nodo Lista NO Es map'); 
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static COM_LogTransacciones__c generarLog(Id IdObjeto, String StrCodigoRespuesta, Object objRequest, 
                                Object ObjResponse, String strTipoTransaccion, String strDescripcion){
        String strRequest;
        String strResponse;
        
        if(objRequest != null){
            strRequest = system.JSON.serializePretty(objRequest, true);
        } else{
            strRequest = null;
        }
        
        if(ObjResponse != null){
            strResponse = system.JSON.serializePretty(ObjResponse, true);
        } else{
            strResponse = null;
        }
        
        return generarLog(IdObjeto, StrCodigoRespuesta, strRequest, strResponse, strTipoTransaccion, strDescripcion);
    }
    
    public static COM_LogTransacciones__c generarLog(Id IdObjeto, String strRequest, 
                                Object ObjResponse, String strTipoTransaccion, String strDescripcion){
        String strResponse;
        
        if(ObjResponse != null){
            strResponse = system.JSON.serializePretty(ObjResponse, true);
        } else{
            strResponse = null;
        }
        
        return generarLog(IdObjeto, null, strRequest, strResponse, strTipoTransaccion, strDescripcion);
    }
    
    public static COM_LogTransacciones__c generarLog(Id IdObjeto, String StrCodigoRespuesta, String strRequest, 
                                String strResponse, String strTipoTransaccion, String strDescripcion){
        COM_LogTransacciones__c objLog = new COM_LogTransacciones__c();
        
        system.debug('..... IdObjeto: ' + IdObjeto);
        if(IdObjeto == null){
            system.debug('IdObjeto Nulo');
        } else if(IdObjeto.getSObjectType() == Account.SobjectType){
            objLog.COM_Cuenta__c = IdObjeto;
        } else if(IdObjeto.getSObjectType() == Opportunity.SobjectType){
            objLog.COM_Oportunidad__c = IdObjeto;
        } else if(IdObjeto.getSObjectType() == ContentDocument.SobjectType){
            objLog.COM_AttachmentId__c = IdObjeto;
        } else{
            system.debug('Ninguno');
        }
        
        if(strRequest != null && strRequest.length() > 131000){
            strRequest = strRequest.subString(0, 130999);
        }
        
        if(strResponse != null && strResponse.length() > 131000){
            strResponse = strResponse.subString(0, 130999);
        }
        
        objLog.COM_CodigoRespuesta__c = StrCodigoRespuesta;
        objLog.COM_Descripcion__c = strDescripcion;
        objLog.COM_FechaTransaccion__c = Datetime.now();
        objLog.COM_Request__c = strRequest;
        objLog.COM_Response__c = strResponse;
        objLog.COM_TipoTransaccion__c = strTipoTransaccion;
        
        //insert objLog;
        return objLog;
    }
    
    public static String obtenerMes(Integer intMes){
        if(intMes == 1){
            return 'Enero';
        } else if(intMes == 2){
            return 'Febrero';
        } else if(intMes == 3){
            return 'Marzo';
        } else if(intMes == 4){
            return 'Abril';
        } else if(intMes == 5){
            return 'Mayo';
        } else if(intMes == 6){
            return 'Junio';
        } else if(intMes == 7){
            return 'Julio';
        } else if(intMes == 8){
            return 'Agosto';
        } else if(intMes == 9){
            return 'Septiembre';
        } else if(intMes == 10){
            return 'Octubre';
        } else if(intMes == 11){
            return 'Noviembre';
        } else if(intMes == 12){
            return 'Diciembre';
        } else{
            return null;
        }
    }
    
    public static void threadSleep(integer milliseconds) 
    {
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do{timeDiff = System.now().getTime() - firstTime.getTime();}
        while(timeDiff <= milliseconds);      
    }
    /**
     * @autor Andrea Contreras
     * @description Consulta metadata para parametrizar valores OPTIN
     * @param String valor: Valor 1
     * @param String strCampoBuscar: Etiqueta del campo a buscar dentro del map para que sea convertido en lista
     * @return Map<CEL1_PersonalizacionOptin__mdt,String>
     **/
    //Esta clase no se pasa a UAT porque OPTIN no ha sido aprobado aún para el 3-03-2020
    //
    //
    /* public static Map<String,CEL1_PersonalizacionOptin__mdt> consultarMetadataOptin(){
        Map<String,CEL1_PersonalizacionOptin__mdt> mapLlaveMetadata = new Map<String,CEL1_PersonalizacionOptin__mdt>();
        List<CEL1_PersonalizacionOptin__mdt> lstMetadataOptin=[SELECT CEL1_NombreApiCampo__c,CEL1_Objeto__c,CEL1_ValorCampo__c,CEL1_ValorEnviar__c
                                                        FROM CEL1_PersonalizacionOptin__mdt];

        for(CEL1_PersonalizacionOptin__mdt objMeta :lstMetadataOptin){
            mapLlaveMetadata.put(objMeta.CEL1_NombreApiCampo__c+objMeta.CEL1_ValorCampo__c,objMeta);
        }
        return mapLlaveMetadata;

     }

     public static String compararValorObjetoConMetadata(Account objAccount,String strApiCampo){
        Map<String,CEL1_PersonalizacionOptin__mdt> mapLlaveMetadata =consultarMetadataOptin();
        System.debug('objAccount *********'+objAccount.get(strApiCampo));
        String strValorEnviar = mapLlaveMetadata.containsKey(strApiCampo+objAccount.get(strApiCampo)) ? mapLlaveMetadata.get(strApiCampo+objAccount.get(strApiCampo)).CEL1_ValorEnviar__c:'';
        System.debug(' return compararValorObjetoConMetadata strValorEnviar ****** '+strValorEnviar );
        return strValorEnviar;
     }*/

    public static void enviarCorreosCuentaAcreedora(Set<Id> setIdCandidatos,String idPlantilla){

        System.debug('enviarCorreosCuentaAcreedora....');
        System.debug('setIdCandidatos....'+setIdCandidatos);
        System.debug('idPlantilla....'+idPlantilla);
        if(String.isNotEmpty(idPlantilla)){
            Set<Id> setIdLeadEnviados = new Set<Id>();
            // Se reserva cantidad de emails para enviar en esta transacción para que no se excedan los límites de
            //caja de toda la organización
            Messaging.reserveSingleEmailCapacity(setIdCandidatos.size());
            List<Lead> lstLead = [SELECT Id, Email,CEL1_EmailFueEnviado__c FROM Lead WHERE Id IN: setIdCandidatos];
            System.debug('lstLead.size().....'+lstLead.size());
            System.debug('lstLead.....'+lstLead);
            OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress where DisplayName =: Label.COM_Email];
            // OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress where DisplayName = 'prueba'];
            List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
            // for(String idObjCandidato : setIdCandidatos){
            List<Lead> lstUpdate = new List<Lead>();
            for(Lead objCandidato : lstLead){
                if(String.isNotBlank(idPlantilla)){
                    String[] toAddresses = new String[] {objCandidato.Email};
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setReplyTo('no-reply@compensar.com');
                    // mail.setSenderDisplayName('Compensar');
                    mail.setOrgWideEmailAddressId(owa.Id);
                    mail.setUseSignature(false);
                    mail.setToAddresses(toAddresses);
                    mail.setTargetObjectId(objCandidato.Id);
                    mail.setTemplateId(idPlantilla);
                    lstEmails.add(mail);
                    // objCandidato.CEL1_EmailFueEnviado__c = true;
                    // lstUpdate.add(objCandidato);
                }
            }
            // if(!lstUpdate.isEmpty())
            //     update lstUpdate;

            if(!lstEmails.isEmpty()){
                // Enviar todos los mensajes
                Messaging.SendEmailResult[] mensajeEnviado=  Messaging.sendEmail(lstEmails,false);
                System.debug('**** mensajeEnviado :'+mensajeEnviado);
                System.debug('**** enviarCorreosCuentaAcreedoraFuture : lstEmails :'+lstEmails);
            }
        }
        else{
            System.debug('**** enviarCorreosCuentaAcreedoraFuture : No existe el cuerpo de la plantilla');
        }
    }
}