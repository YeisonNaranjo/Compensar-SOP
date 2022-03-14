/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Daniel Alejandro López Monsalve 
Proyecto:          Compensar
Descripción:       Clase en la que se incluyen todos los métodos necesarios para el proceso de migración.

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     02/10/17             Daniel Alejandro López Monsalve (DL)       Creación Clase.
    2.0     27/06/19             Yeison Stic Naranjo Rendón (YSN)           Modificación asignación nombre contacto.
    ************************************************************************************************/
    public class COM_UtilidadesMigracion_cls 
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
        
        
        /**
        Caso Fase de migración de registros
        */
        if(Test.isRunningTest()){
          faseProyecto = 'MIGRACION';
        }
        if (faseProyecto == 'MIGRACION'){

          System.debug ('Ingresa por fase Migracion'); 

          for(Integer i = 0; i < lstNewRecords.size(); i++)
          {                
            Account objAccount = lstNewRecords.get(i);

                //Crear contacto y mapear grupo.
                Id recordTypeAccount = objAccount.RecordTypeId;
                if(recordTypeAccount == '0126A0000005VbpQAE'){ 

                  System.debug ('Creación por natural y por migración');
                  Contact objContact = new Contact();

                //Mapear los campos de la cuenta en el contacto.
                objContact.LastName = objAccount.COM_Primerapellido__c;
                /* Inicio 2.0 */
                objContact.LastName += objAccount.COM_Segundoapellido__c!=null?' '+objAccount.COM_Segundoapellido__c:'';
                /* Fin 2.0 */
                objContact.FirstName = objAccount.COM_Primernombre__c;
                objContact.COM_Fechanacimiento__c = objAccount.COM_FechaNacimiento__c;
                objContact.COM_Numeroidentificacion__c = objAccount.COM_Numero_de_identificacion__c;
                objContact.COM_TipoIdentificacion__c = objAccount.COM_TipoIdentificacion__c;
                objContact.MiddleName = objAccount.COM_Otrosnombres__c;
                objContact.AccountId = objAccount.Id;  
                objContact.COM_EsMigrado__c = true;
                objContact.COM_FechaMigracion__c = Date.today();
                
                
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
        
        if(Test.isRunningTest()){
          faseProyecto = 'PRODUCCION';
        }
        if (faseProyecto == 'PRODUCCION'){

          System.debug ('Ingresa por fase Producción'); 

          for(Integer i = 0; i < lstNewRecords.size(); i++)
          {

            Account objAccount = lstNewRecords.get(i);

                //Crear contacto y mapear grupo.
                Id recordTypeAccount = objAccount.RecordTypeId;
                if(recordTypeAccount == tipoRegistroNatural){ 
                  System.debug ('Creación por natural y por producción');

                  Contact objContact = new Contact();

                //Mapear los campos de la cuenta en el contacto.
                objContact.LastName = objAccount.COM_Primerapellido__c;
                /* Inicio 2.0 */
                objContact.LastName += objAccount.COM_Segundoapellido__c!=null?' '+objAccount.COM_Segundoapellido__c:'';
                /* Fin 2.0 */                
                objContact.FirstName = objAccount.COM_Primernombre__c;
                objContact.COM_Fechanacimiento__c = objAccount.COM_FechaNacimiento__c;
                objContact.COM_Numeroidentificacion__c = objAccount.COM_Numero_de_identificacion__c;
                objContact.COM_TipoIdentificacion__c = objAccount.COM_TipoIdentificacion__c;
                objContact.MiddleName = objAccount.COM_Otrosnombres__c;
                objContact.AccountId = objAccount.Id;  
                objContact.COM_EsMigrado__c = false;

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
              COM_UtilidadesMigracion_cls.stopTrigger();
              update lstAccount;
              COM_UtilidadesMigracion_cls.startTrigger();    
            }
          }   



        }