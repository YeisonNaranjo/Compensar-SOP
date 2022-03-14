/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase del Trigger COM_AccountContactRelation_tgr donde se realizan los siguientes operaciones
                    - Calcular el total de Representantes Legales por cuenta

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     27/07/17             Cristian David Mejia (CM)             Creación Clase.
    2.0     15/09/17             Daniel Alejandro López Monsalve (DL)  Método para crear contactos en PersNat
    3.0     15/09/17             William Aldana (WA)                   SE agrega cuenta de Rep leg por contactos
    4.0     31/10/17             Rubén Suárez Forero (RUSF)            Se cambia el mapeo del nombre y el apellido del contacto
    5.0     22/11/17             Nicolas Laverde Pinzon (NLP)          Se modifica el metodo crearContactoCuentaNatural para
                                                                       mapear nuevos campos al contacto desde la cuenta Natural Caso NOLA-1625
    5.1     27/07/18             Stifen Panche Gutierrez (SPG)         Se coloca mapa de contactos relacionados.
    5.2     06/05/19             Jordan Steven Parra (JP)              Se coloca un control para los errores de creación de contactos. 
    5.3     27/06/19             Yeison Stic Naranjo (YSN)             Ajuste para el mapeo del nombre de contacto a crear.
    5.4     18/08/20             Yeison Stic Naranjo (YSN)             Ajuste cambio correo electronico NOLA 00019361.
    ************************************************************************************************/
    public class COM_AccountContactRelation_cls
    {

      public static Boolean allow = true;

      public static void stopTrigger(){
        allow = false;
      }

      public static boolean canIRun(){
        return allow;
      }

      public static void startTrigger(){
        allow = false;
      }

       public static void startTrigger2(){
        allow = true;
      }


    /**
     * [contadorRepLegales description]
     * @param lstNewRecords [description]
     */
     public void contadorRepLegales(List<AccountContactRelation> lstNewRecords)
     {
      if(lstNewRecords != null && !lstNewRecords.isEmpty()){
        Set<String> setIdCuenta = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++)
        {
          setIdCuenta.add(lstNewRecords[i].AccountId);
        }
        User u = [SELECT COM_PermisosEscrituraGC__c FROM User WHERE Id =: userinfo.getUserId()];
            //System.debug('WA - voy a actualizar '+setIdCuenta.size()+ ' '+lstNewRecords.size());
            List<Account> lstAccount = [SELECT Id, COM_CantidadLegales__c, (SELECT id FROM AccountContactRelations WHERE IsActive = true AND Roles INCLUDES ('Representante Legal')) FROM Account WHERE Id IN: setIdCuenta];
            for(Account objAcc : lstAccount)
            {
              objAcc.COM_CantidadLegales__c = objAcc.AccountContactRelations.size();
                //System.debug('WA ' + objAcc.Id + ' Actualiza dato rl ' + objAcc.COM_CantidadLegales__c);
              }
              if(u.COM_PermisosEscrituraGC__c){
                COM_AccountContactRelation_cls.stopTrigger();
                update lstAccount;
                COM_AccountContactRelation_cls.startTrigger();
                } else {
                  u.COM_PermisosEscrituraGC__c = true;
                  update u;
                  COM_AccountContactRelation_cls.stopTrigger();
                  update lstAccount;
                  COM_AccountContactRelation_cls.startTrigger();
                  u.COM_PermisosEscrituraGC__c = false;
                  update u;
                }
              }
            }

    /**
     * [contadorRepLegales description]
     * @param lstNewRecords [description]
     */
     public void contadorRepLegales(List<Contact> lstNewRecords)
     {
      if(lstNewRecords != null && !lstNewRecords.isEmpty()){
        Set<String> setIdCuenta = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++)
        {
          setIdCuenta.add(lstNewRecords[i].AccountId);
        }
        User u = [SELECT COM_PermisosEscrituraGC__c FROM User WHERE Id =: userinfo.getUserId()];
            //System.debug('WA - voy a actualizar '+setIdCuenta.size()+ ' '+lstNewRecords.size());
            List<Account> lstAccount = [SELECT Id, COM_CantidadLegales__c, (SELECT id FROM AccountContactRelations WHERE IsActive = true AND Roles INCLUDES ('Representante Legal')) FROM Account WHERE Id IN: setIdCuenta];
            for(Account objAcc : lstAccount)
            {
              objAcc.COM_CantidadLegales__c = objAcc.AccountContactRelations.size();
                //System.debug('WA ' + objAcc.Id + ' Actualiza dato rl ' + objAcc.COM_CantidadLegales__c);
              }
              if(u.COM_PermisosEscrituraGC__c){
                COM_AccountContactRelation_cls.stopTrigger();
                update lstAccount;
                COM_AccountContactRelation_cls.startTrigger();
                } else {
                  u.COM_PermisosEscrituraGC__c = true;
                  update u;
                  COM_AccountContactRelation_cls.stopTrigger();
                  update lstAccount;
                  COM_AccountContactRelation_cls.startTrigger();
                  u.COM_PermisosEscrituraGC__c = false;
                  update u;
                }
              }
            }

            /**
        * @Method:      actualizaContactoCuentasNatural
        * @param:       List<Account> Trigger.New
        * @param:       List<Account> Trigger.old
        * @Description: Actualiza algunos datos del contacto cuando se modifica la cuenta
        * @author       Nicolas Laverde Pinzón - 22 de Noviembre 2017 v5.0
        */

        public void actualizaContactoCuentasNatural(List<Account> lstNewRecords){
        

            List<Contact> lstContacts = new List<Contact>();
            Map<String, Contact> mapContactsRelatedAcc = new Map<String, Contact>();
            Set<String> setIdAccount = new Set<String>();
            for(Account objAccount : lstNewRecords)
            {
                setIdAccount.add(objAccount.Id);
            }
            lstContacts = [SELECT Id, AccountId FROM Contact Where AccountId IN:(setIdAccount)];
            for(Contact objContact : lstContacts)
            {
                mapContactsRelatedAcc.put(objContact.AccountId, objContact);

            }
            system.debug('::::::>>>>>> Tamaño mapContactsRelatedAcc: ' + mapContactsRelatedAcc.size());

            system.debug('::::::>>>>>> Tamaño mapContactsRelatedAcc: ' + mapContactsRelatedAcc);
            
            if(mapContactsRelatedAcc.size()>0){
                for(Account objAccount : lstNewRecords)
                {
                    if(objAccount.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Natural').getRecordTypeId() /*Inicio 5.1*/&& mapContactsRelatedAcc.containsKey(objAccount.Id) /*Fin 5.1*/)
                    {
                  
                   mapContactsRelatedAcc.get(objAccount.Id).LastName = objAccount.COM_Primerapellido__c;
                   mapContactsRelatedAcc.get(objAccount.Id).LastName += objAccount.COM_Segundoapellido__c!=null?' '+objAccount.COM_Segundoapellido__c:'';
                    mapContactsRelatedAcc.get(objAccount.Id).FirstName = objAccount.COM_Primernombre__c;
                    /* Inicio 5.3*/
                    //mapContactsRelatedAcc.get(objAccount.Id).FirstName += objAccount.COM_Otrosnombres__c!=null?' '+objAccount.COM_Otrosnombres__c:'';
                    mapContactsRelatedAcc.get(objAccount.Id).MiddleName = objAccount.COM_Otrosnombres__c!=null?' '+objAccount.COM_Otrosnombres__c:'';
                    /* Fin 5.3*/
                    /* Inicio 5.4 */
                    mapContactsRelatedAcc.get(objAccount.Id).COM_Correo_electronico_personal__c = objAccount.COM_CorreoElectronico__c != null ? objAccount.COM_CorreoElectronico__c : Null;
                    /* Fin 5.4 */
                   mapContactsRelatedAcc.get(objAccount.Id).COM_Numeroidentificacion__c = objAccount.COM_Numero_de_identificacion__c;
                    mapContactsRelatedAcc.get(objAccount.Id).COM_TipoIdentificacion__c = objAccount.COM_TipoIdentificacion__c;
                    mapContactsRelatedAcc.get(objAccount.Id).COM_Direccion__c = objAccount.COM_Direccion__c;
                    
                    }
    
                    
                }
    
                update mapContactsRelatedAcc.values();
            }

        }

    /**
    Método que se encarga de la creación de contactos para las cuentas de personas naturales.
    Tiene en cuenta la fase del proyecto MIGRACION/PRODUCCION para aplicar la lógica relacionada.
    Es invocado de forma masiva desde el trigger de Account
    @dlopez  Septiembre 15 2017
    */
    public void crearContactoCuentaNatural (List<Account> lstNewRecords)
    {

      System.debug ('Inicia crearContactoCuentaNatural');

        //Determinar si el sistema se encuentra en migración o en producción.
        //Se guarda la etapa en un label para ahorrar una consulta.
        String faseProyecto = System.Label.COM_FaseProyecto;
        String tipoRegistroNatural = System.Label.COM_TipoRegistroPersonaNaturalMigracion;
        System.debug ('El tipo de registro natural es:'+tipoRegistroNatural);

        List<Contact> lstContactos = new List<Contact>();

  //Inicio v5.2
        list<COM_LogTransacciones__c> lstLogs = new list<COM_LogTransacciones__c>();
        COM_LogTransacciones__c objLog;
        String strRequestAux = '';
  //Final v5.2


        /**
        Caso Fase de migración de registros
        */
        if (faseProyecto == 'MIGRACION'){

          System.debug ('Ingresa por fase Migracion');

          for(Integer i = 0; i < lstNewRecords.size(); i++)
          {
            Account objAccount = lstNewRecords.get(i);

                //Crear contacto y mapear grupo.
                Id recordTypeAccount = objAccount.RecordTypeId;
                if(recordTypeAccount == tipoRegistroNatural){

                  System.debug ('Creación por natural y por migración');
                  Contact objContact = new Contact();

                //Mapear los campos de la cuenta en el contacto.
                //INICIO RUSF-1
                //objContact.FirstName = objAccount.COM_Primerapellido__c;
                //objContact.LastName += objAccount.COM_Segundoapellido__c;
                //objContact.MiddleName = objAccount.COM_Otrosnombres__c;
                objContact.LastName = objAccount.COM_Primerapellido__c;
                objContact.LastName += objAccount.COM_Segundoapellido__c!=null?' '+objAccount.COM_Segundoapellido__c:'';
                objContact.FirstName = objAccount.COM_Primernombre__c;
                /* Inicio 5.3 */
                //objContact.FirstName += objAccount.COM_Otrosnombres__c!=null?' '+objAccount.COM_Otrosnombres__c:'';
                objContact.MiddleName = objAccount.COM_Otrosnombres__c!=null?' '+objAccount.COM_Otrosnombres__c:'';
                /* Fin 5.3 */
                //FIN RUSF-1
                objContact.COM_Fechanacimiento__c = objAccount.COM_FechaNacimiento__c;
                objContact.COM_Numeroidentificacion__c = objAccount.COM_Numero_de_identificacion__c;
                objContact.COM_TipoIdentificacion__c = objAccount.COM_TipoIdentificacion__c;
                objContact.AccountId = objAccount.Id;
                objContact.COM_EsMigrado__c = true;
                objContact.COM_FechaMigracion__c = Date.today();
                //Inicio Versión 5.0 (NLP) NOLA - 1625
                objContact.COM_Telefono__c = objAccount.Phone;
                objContact.MobilePhone = objAccount.COM_Movil__c;
                /* Inicio 5.4 */
                //objContact.Email = objAccount.COM_CorreoElectronico__c;
                objContact.COM_Correo_electronico_personal__c = objAccount.COM_CorreoElectronico__c;
                /* Fin 5.4 */  
                objContact.COM_Tratamientoprotecciondatos__c = objAccount.COM_Tratamientoprotecciondatos__c;
                objContact.COM_Aceptaenviocorreoelectronico__c = objAccount.COM_Aceptaenviocorreoelectronico__c;
                objContact.COM_AceptaenvioSMS__c = objAccount.COM_AceptaenvioSMS__c;
                objContact.COM_EstadoCivil__c = objAccount.COM_Estado_civil__c;
                //Fin - Versión 5.0 (NLP)



                lstContactos.add(objContact);
              }
            }


            System.debug ('Va a ingresar los contactos');
            System.debug ('Lista de los contactos'+lstContactos);
            System.debug ('Tamano de la lista'+lstContactos.size());
            try{
             if (!lstContactos.isEmpty()){
               System.debug ('Va a insertar lista '+lstContactos);
               insert lstContactos;
               System.debug ('Termina inserción lista');
             }
             else {
              System.debug ('Lista vacía no entra al if');
            }
          }
          catch(Exception e){
            System.debug ('Excepción'+e);


          }
        }


        /**
        Caso Ambiente de Producción
        */
        else if (faseProyecto == 'PRODUCCION'){

          System.debug ('Ingresa por fase Producción');

          for(Integer i = 0; i < lstNewRecords.size(); i++)
          {

            Account objAccount = lstNewRecords.get(i);

                //Crear contacto y mapear grupo.
                Id recordTypeAccount = objAccount.RecordTypeId;
                system.debug('recordTypeAccount-- '+recordTypeAccount);
                if(recordTypeAccount == tipoRegistroNatural){
                  System.debug ('Creación por natural y por producción');

                  Contact objContact = new Contact();

                //Mapear los campos de la cuenta en el contacto.
                //INICIO RUSF-1
                //objContact.FirstName = objAccount.COM_Primerapellido__c;
                //objContact.LastName += objAccount.COM_Segundoapellido__c;
                //objContact.MiddleName = objAccount.COM_Otrosnombres__c;
                objContact.LastName = objAccount.COM_Primerapellido__c;
                objContact.LastName += objAccount.COM_Segundoapellido__c!=null?' '+objAccount.COM_Segundoapellido__c:'';
                objContact.FirstName = objAccount.COM_Primernombre__c;
                /* Inicio 5.3 */
                //objContact.FirstName += objAccount.COM_Otrosnombres__c!=null?' '+objAccount.COM_Otrosnombres__c:'';
                objContact.MiddleName = objAccount.COM_Otrosnombres__c!=null?' '+objAccount.COM_Otrosnombres__c:'';
                /* Fin 5.3 */                
                //FIN RUSF-1
                objContact.COM_Fechanacimiento__c = objAccount.COM_FechaNacimiento__c;
                objContact.COM_Numeroidentificacion__c = objAccount.COM_Numero_de_identificacion__c;
                objContact.COM_TipoIdentificacion__c = objAccount.COM_TipoIdentificacion__c;
                objContact.AccountId = objAccount.Id;
                objContact.COM_EsMigrado__c = false;

                //Inicio Versión 5.0 (NLP) NOLA - 1625
                objContact.COM_Telefono__c = objAccount.Phone;
                objContact.MobilePhone = objAccount.COM_Movil__c;
                /* Inicio 5.4 */
                //objContact.Email = objAccount.COM_CorreoElectronico__c;
                objContact.COM_Correo_electronico_personal__c = objAccount.COM_CorreoElectronico__c;
                /* Fin 5.4 */  
                objContact.COM_Tratamientoprotecciondatos__c = objAccount.COM_Tratamientoprotecciondatos__c;
                objContact.COM_Aceptaenviocorreoelectronico__c = objAccount.COM_Aceptaenviocorreoelectronico__c;
                objContact.COM_AceptaenvioSMS__c = objAccount.COM_AceptaenvioSMS__c;
                objContact.COM_EstadoCivil__c = objAccount.COM_Estado_civil__c;
                //Fin - Versión 5.0 (NLP)


                lstContactos.add(objContact);
              }
            }


            System.debug ('Va a ingresar los contactos');
            System.debug ('Lista de los contactos'+lstContactos);
            System.debug ('Tamano de la lista'+lstContactos.size());
            try{
             if (lstContactos.size()>0){
               System.debug ('Va a insertar lista '+lstContactos);
               insert lstContactos;
               System.debug ('Termina inserción lista');
             }
             else {
              System.debug ('Lista vacía no entra al if');
            }
          }
          catch(Exception e){
    //Inicio 5.2
          for (Contact objContact: lstContactos){
             strRequestAux = 'COM_TipoIdentificacion__c: ' + objContact.COM_TipoIdentificacion__c;
             strRequestAux += '; COM_Numeroidentificacion__c: ' + objContact.COM_Numeroidentificacion__c;
            objLog = COM_Utilidades_cls.generarLog(objContact.AccountId, strRequestAux, null, Label.COM_AccountContact_error,  e.getMessage() + ' ' + e.getStackTraceString());
            lstLogs.add(objLog);
          }
          insert lstLogs;
    //Final 5.2*/
            System.debug ('Excepción'+e);
          }
        }

      }




    /**
    Método que se encarga de asociar a la relación cuenta contacto el rol de representante
    legal.  Se utiliza solamente en producción, ya que en la migración se ejecuta mediante un batch.
    @dlopez  Septiembre 25 2017
    */
    public void asociarRepresentanteLegal (List<Account> lstNewRecords)
    {

      Id idrecordTypeNatural = Schema.SObjectType.Account.getRecordTypeInfosByName().get(label.COM_LabelPersonaNatural).getRecordTypeId();

      List<Id> listIdCuentas = new List<Id>();
      for(Integer i = 0; i < lstNewRecords.size(); i++)
      {
       Account objAccount =   lstNewRecords.get(i);
       Id idAccount = objAccount.Id;
       Id idRecordType = objAccount.recordTypeId;

       if(idrecordTypeNatural == idRecordType){
         listIdCuentas.add(idAccount);
       }
     }

     List<AccountContactRelation> lstAcr = [SELECT Roles FROM AccountContactRelation WHERE AccountId IN: listIdCuentas];
     for(Integer j = 0; j < lstAcr.size(); j++)
     {
       AccountContactRelation objAccountRel =   lstAcr.get(j);
       objAccountRel.Roles  = 'Representante Legal';
     }

     update lstAcr;



   }


    /**
     * Calcula el número de representantes legales para un listado de cuentas.
     * Se utiliza solamente para el proceso batch.
     * @param lstNewRecords [description]
     */
     public void contadorRepLegalesBatch(List<Account> lstNewRecords)
     {
      if(lstNewRecords != null && !lstNewRecords.isEmpty()){
        Set<String> setIdCuenta = new Set<String>();
        for(Integer i = 0; i < lstNewRecords.size(); i++)
        {
          setIdCuenta.add(lstNewRecords[i].Id);
        }

            //System.debug('WA - voy a actualizar '+setIdCuenta.size()+ ' '+lstNewRecords.size());
            List<Account> lstAccount = [SELECT Id, COM_CantidadLegales__c, (SELECT id FROM AccountContactRelations WHERE IsActive = true AND Roles INCLUDES ('Representante Legal')) FROM Account WHERE Id IN: setIdCuenta];
            for(Account objAcc : lstAccount)
            {
              objAcc.COM_CantidadLegales__c = objAcc.AccountContactRelations.size();
                //System.debug('WA ' + objAcc.Id + ' Actualiza dato rl ' + objAcc.COM_CantidadLegales__c);
              }
              COM_AccountContactRelation_cls.stopTrigger();
              update lstAccount;
              COM_AccountContactRelation_cls.startTrigger();
            }
          }

        }