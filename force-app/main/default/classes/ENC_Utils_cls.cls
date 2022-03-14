/**********************************************************************************
Desarrollado por: Avanxo Colombia
Autor: Daniel Delgado
Descripción: Clase que expone diferentes métodos para ser consumidos de forma general
             desde los diferentes componenetes que conforman la aplicación. Esto con 
             el fin de tener una administración más sencilla del código y evitar re-escritura
             del mismo.
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha      Autor               Descripción
------ ---------- ---------------------------------------------------------------
1.0 09-07-2013  Daniel Delgado (DD) Creación de clase.
***********************************************************************************/
public with sharing class ENC_Utils_cls
{
    public static Apexpages.Severity FATAL = Apexpages.Severity.FATAL;
    public static Apexpages.Severity ERROR = Apexpages.Severity.ERROR;
    public static Apexpages.Severity WARNING = Apexpages.Severity.WARNING;
    public static Apexpages.Severity INFO = Apexpages.Severity.INFO;
    public static Apexpages.Severity CONFIRM = Apexpages.Severity.CONFIRM;
    public static Boolean blCatch = false;
    public static map<String, Schema.SObjectType> sobjToSobjDescribeMap = null;
    
    /* Crea y agrega un mensaje a una pagina visual force dado la severidad y el texto del mensaje
    * @severity: Severidad del mensaje que se va a crear
    * @message: Texto del mensaje a crear */
    public static void addMessage( Apexpages.Severity severity, String message )
    {
        Apexpages.Message pMessage = new Apexpages.Message( severity, message );
        Apexpages.addMessage( pMessage );
    }

    /* Crea una cadena en formato de lista para un query
    * @severity: Severidad del mensaje que se va a crear
    * @message: Texto del mensaje a crear */
    public static String createListWhere(set<String> setWhere )
    {
        String listaFormateada='';
        
        
        if( setWhere != null ){
             listaFormateada=null;
            for(String campo:setWhere){
                if(listaFormateada==null){
                    listaFormateada = '(\''+campo+'\'';
                } 
                else{
                    listaFormateada = listaFormateada + ',\''+campo+'\'';
                }
            }
            listaFormateada = listaFormateada + ')';
        }else{
            return null;
        }
                
        return listaFormateada;
    }
        
    /* Retorna la lista de campos configurados para el conjunto de campos solicitado que se encuentre asociado al objeto indicado.
    * En caso de no encontrar informacion para los parametros enviados se retornara un set con el valor 'Name'.
    * @sObjectName: Nombre API del objeto a consultar
    * @fieldSetName: Nombre del conjunto de campos a consultar la informacion */
    public static set<string> getFieldSetByObjectName( string sObjectName, string fieldSetName )
    {
        set<string> setResult = new set<string>();
        try
        {
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get( sObjectName );
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get( fieldSetName );
            system.debug(   '\n\n***** getFieldSetByObjectName *****\n\nsObjectName: ' + sObjectName + 
                            '\nfieldSetName: ' + fieldSetName + '\nSObjectTypeObj: ' + SObjectTypeObj + 
                            '\nDescribeSObjectResultObj: ' + DescribeSObjectResultObj +
                            '\nfieldSetObj: ' + fieldSetObj );
            //Verifica si existe configuración o si se hace por defecto con el campo name únicamente
            if( fieldSetObj != null )
            {
                for( Schema.FieldSetMember fsm : fieldSetObj.getFields() )
                {
                    setResult.add( fsm.getFieldPath() );
                }
            }
            else
            {
                //Por defecto solo carga el Name
                setResult.add( 'Name' );
            }
            fnCatch();
        }
        catch( system.exception e )
        {
            setResult = new set<string>();
            setResult.add( 'Name' );
        }
        
        return setResult;
    }
    
    /* Retorna el conjunto de campos solicitado que se encuentre asociado al objeto indicado.
    * En caso de no encontrar informacion para los parametros enviados se retornara null.
    * @sObjectName: Nombre API del objeto a consultar
    * @fieldSetName: Nombre del conjunto de campos a consultar la informacion */
    public static Schema.FieldSet getSchemaFieldSetByObjectName( string sObjectName, string fieldSetName )
    {
        try
        {
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get( sObjectName );
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            fnCatch();
            return DescribeSObjectResultObj.FieldSets.getMap().get( fieldSetName );
        }
        catch( system.exception e )
        {
            
        }
        
        return null;
    }
    
    /**
    * @description Funcion para Identificar el objeto del Registro
    */
    public static Boolean idIsOfSObj( String SObjName, ID theId )
    {
        //Llama el Schema de la organizacion
        if( sobjToSobjDescribeMap == null ) 
            sobjToSobjDescribeMap = Schema.getGlobalDescribe();
        //Valida que el Id no sea null y trar los primeros 3 digitos
        String idKeyPrefix = theId != null ? ( (String) theId ).substring( 0, 3 ) : null;
        //Con los primeros 3 digitos del ID valida si el KeyPrefix del objeto es el mismo
        if( sobjToSobjDescribeMap.get( SObjName ).getDescribe().getKeyPrefix() == idKeyPrefix )
            return true;
        return false;
    }
    
    /**
    * @Metodo para ejecutar el Catch en las clases de prueba
    */
    public static string fnCatch()
    {
        if( Test.isRunningTest() && blCatch )
            return new list<string>()[0];
        return '';
    }
    
    
    /* Retorna una lista de tipo SelectOption con la opción predeterminada*/
    public static list<Selectoption> nuevaListaSelectOption()
    {
        list<Selectoption> lst = new list<Selectoption>();
        lst.add( new Selectoption( '', '-- Seleccionar --' ) );
        return lst;
    }
    
    public static list<String> getPicklistValues( sObject obj, String fld, Boolean doSort )
    {
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = new list<Schema.PicklistEntry>();
        if(fieldMap != null && fieldMap.get(fld) != null && fieldMap.get(fld).getDescribe() != null && fieldMap.get(fld).getDescribe().getPickListValues() != null) 
            values = fieldMap.get(fld).getDescribe().getPickListValues();
        list<String> lstSort = new list<String>();
        // Add these values to the sort list.
        for (Schema.PicklistEntry a : values)
            lstSort.add( a.getLabel() );
        
        if( doSort )
            lstSort.sort();
        
        return lstSort;
    }
    
    public static list<SelectOption> getPicklistValuesOption( sObject obj, String fld, Boolean doSort )
    {
        list<SelectOption> options = ENC_Utils_cls.nuevaListaSelectOption();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = new list<Schema.PicklistEntry>(); 
        if(fieldMap != null && fieldMap.get(fld) != null && fieldMap.get(fld).getDescribe() != null && fieldMap.get(fld).getDescribe().getPickListValues() != null)
            values = fieldMap.get(fld).getDescribe().getPickListValues();
        list<String> lstSort = new list<String>();
        // Add these values to the sort list.
        for (Schema.PicklistEntry a : values)
            lstSort.add( a.getLabel() + 'Ã' + a.getValue() );
        
        if( doSort )
            lstSort.sort();
        
        // Add these values to the selectoption list.
        for ( String strTemp : lstSort )
        {
            list<String> lstTemp = strTemp.split( 'Ã' );
            options.add( new SelectOption( lstTemp.get( 0 ), lstTemp.get( 1 ) ) );
        }
        
        return options;
    }
    
    
    
 /* Dada la oportunidad que está asociada a una encuesta, encuentra el 
 */
 public static void consultarCliente(List<AVX_ENC_Encuesta__c> lstEncuestas)
  {
       //Se construye listado de con los identificadores de las oportunidades a consultar
        List<ID> lstIdOportunidades = new List<ID>();
        
        for(Integer i =0; i< lstEncuestas.size(); i++){
        
              AVX_ENC_Encuesta__c  objEncuesta = lstEncuestas.get(i);
              ID IdOportunidad = objEncuesta.COM_Oportunidad__c;
              lstIdOportunidades.add(IdOportunidad);
        
        }
        
         //Se traen los identificadores de las cuentas relacionadas con las oportunidades:
        List<Opportunity> listaOportunidades =  [SELECT id, AccountId  
                                     FROM Opportunity 
                                     WHERE id IN : lstIdOportunidades];
                                     
                                     
        //Se recorre el listado de encuestas y se actualiza el cliente con base en la lista de oportunidades
        //obtenida previamente.
        for(Integer i = 0; i < lstEncuestas.size(); i++){
        
              AVX_ENC_Encuesta__c  objEncuesta = lstEncuestas.get(i);
              ID IdOportunidad = objEncuesta.COM_Oportunidad__c;
                        
            ID idCuenta = obtenerIDCuentaOportunidad(listaOportunidades, IdOportunidad);
            System.debug('El identificador de la cuenta de la encuesta:'+idCuenta);
            if (idCuenta != null){
                System.debug('Realiza la asignación:'+idCuenta);
                objEncuesta.COM_Cliente__c= idCuenta;
                
            }
            
        }   
        
        
        
  } 
  
  
  private static ID obtenerIDCuentaOportunidad(List<Opportunity> listaOportunidades, ID IdOportunidad){
    
    //Se recorre la lista buscando el número de la cuenta
    System.debug('Inicia método de búsqueda');
    for(Integer j=0; j<listaOportunidades.size(); j++){
    
       
       Opportunity objOportunidad = listaOportunidades.get(j);
       System.debug('Busca'+objOportunidad.AccountId+' en'+IdOportunidad+' y la opp'+objOportunidad);
       if (objOportunidad.Id == IdOportunidad){
           
           return objOportunidad.AccountId;
       }
    
    
    }
    
    
    return null;
  }      
    
}