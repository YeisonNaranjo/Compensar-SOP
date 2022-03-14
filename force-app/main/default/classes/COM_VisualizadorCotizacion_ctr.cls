/**
* Avanxo Colombia
* @author           Stifen Panche Gutierrez href=<stifen.panche@globant.com>
* Project:          Compensar
* Description:      Clase para visualizar Cotizaciones PDF
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-07-18      Stifen Panche Gutierrez (SPG)   Creación clase, se realiza esta nueva clase debido a que se necesita mostrar como recursos estáticos algunos pdf,
																	porque el diseño cambia y puede tomar mucho tiempo realizar ésta funcionalidad cada vez que éste cambie.
***************************************************************************************************************/
public class COM_VisualizadorCotizacion_ctr  
{
	public      String                          strIdCustomObject       {get;set;}
    public      String                          strTipoDocumento        {get;set;}
    public      String                          srtUrlPagina            {get;set;}
    public      List<String>                    lstCorreo               {get;set;}
    private     COM_NavegacionVisualizadorM__mdt    confDoc;

    /** Las urls de la configuracion personalizada.**/
    @TestVisible  private String strTipoDoc;
    private List<COM_NavegacionVisualizadorM__mdt> lstUrls;
    private Map<String,Schema.SobjectType> mapSObjectType;

    private String strIdCotizacion;


    /**
* @author Rubén Suárez Forero (jsuarez@avanxo.com)
* @version 1.0
* @description Constructor
* @return 
**/
    public COM_VisualizadorCotizacion_ctr() {
        strIdCustomObject = ApexPages.currentpage().getparameters().get('customObjectId');
        strTipoDocumento = ApexPages.currentpage().getparameters().get('tipo');
        /*strTipoDoc = ApexPages.currentpage().getparameters().get('tipoDoc');
        strIdCotizacion = ApexPages.currentpage().getparameters().get('idCotizacion');*/

      
        System.debug('***CM*** =====>>> strTipoDocumento \n'+strTipoDocumento);
        //lstUrls = COM_NavegacionVisualizador__c.getAll().values();
       //srtUrlPagina = obtenerURL(strTipoDocumento);
       //
       
        
        srtUrlPagina = strTipoDocumento; 
        System.debug('Stif ' + srtUrlPagina);
        mapSObjectType = new Map<String,Schema.SobjectType>();
        for (Schema.SobjectType objType: Schema.getGlobalDescribe().values())
        {
            mapSObjectType.put(objType.getDescribe().getKeyPrefix(),objType);
        }
    }

/**
* @author Stifen Panche Gutierrez (stifen.panche@globant.com)
* @version 1.0
* @description Adjuntar recurso estático al registro y enviar el PDF por mail
* @return 
**/
    public void fnGuardarEnviar()
    {
        set<id> attachSet = new set<id>();
        //Crear PDF
        PageReference prfPDF = new PageReference('/resource/' + srtUrlPagina);
        
        Blob blbPDF;
        if(!Test.isRunningTest()){
            blbPDF = prfPDF.getContent();
        }else{
            blbPDF = Blob.valueOf('EL PDF');
        }
        
          Attachment attach = new Attachment();
        list<Attachment> listAtach = new list<Attachment>();

        ContentVersion objContentVersion = new ContentVersion();
        List<ContentVersion> lstContentV = new List<ContentVersion>();
        String strObject = mapSObjectType.get(strIdCustomObject.left(3)).getDescribe().getName();
         objContentVersion = MGLT_CrearContentDocument_cls.saveContentDocument(strIdCustomObject, 'cotizacion',blbPDF,'.pdf');
        
        System.debug(objContentVersion);

        
         set<String> setEmails;
       if(strObject == 'Quote'){
            System.debug('***WA*** =====>>> setEmails \n'+setEmails);
            Quote objOpp = [SELECT AccountId, Opportunity.Contacto__c, Opportunity.Contacto__r.Email FROM Quote WHERE Id =:strIdCustomObject];
            system.debug('correo---'+objOpp);
            system.debug('correo---'+objOpp.Opportunity);
            system.debug('correo---'+objOpp.Opportunity.Contacto__c);
            system.debug('correo---'+objOpp.Opportunity.Contacto__r.Email);
            setEmails = new Set<String>{objOpp.Opportunity.Contacto__r.Email};
           
           /*Inicio 1.1*/
          COM_ConsultarEnvioDocumentos_cls.enviarDocumentos('COT',setEmails,new set<Id>{objContentVersion.id}, '', '', 'CuerpoCotizacion', objOpp.Opportunity.Contacto__c, objOpp.AccountId);
            //PB AVX 09-24-19 FIN



    }
    }
}