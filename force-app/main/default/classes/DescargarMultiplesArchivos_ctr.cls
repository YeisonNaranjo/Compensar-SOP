/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase para descargar archivos
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2018-02-28      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.1     2018-04-26      Brisleydi Calderón (BC)         Ajuste para que descargue todos los archivos en Chrome y IE.
* @version  2.0     2018-11-23      William Aldana (WA)             creacion metodo getAttachments2 para obtener adjuntos en base64
* @version  2.1     2019-09-09      Paula Bohórquez (PB)            Creación del método getURL y la clase WrapperResponse para migración a Lightning.
* @version  2.2     2019-09-25      Paula Bohórquez (PB)            Migración Lightning -  Se reemplazan Attachments por Content Documents.
*************************************************************************************************************/
global class DescargarMultiplesArchivos_ctr {

	private final Id id;
    public List<ContentDocument> lstContentDocument {get; set;}
    public Boolean blnDescargar {get; set;}
    public String urlBase {get; set;}
    
    public DescargarMultiplesArchivos_ctr() {
        id = apexpages.currentpage().getparameters().get('Id');
        blnDescargar = false;
        lstContentDocument = new List<ContentDocument>();
        Set<Id> setIdCD = new Set<Id>();        
        
        for(ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId  =: id]){
            setIdCD.add(cdl.ContentDocumentId);
        }
        
        if(!setIdCD.isEmpty()){
            lstContentDocument = [SELECT Id, FileType, Title FROM ContentDocument WHERE Id IN: setIdCD];
        }
        
        urlBase = System.Url.getSalesforceBaseURL().toExternalForm();
    }

    /**
     * Gets the attachments.
     *
     * @return     The attachments.
     */
    public String getAttachments() {
        String strArchivos = '';
        if(!lstContentDocument.isEmpty()){
            blnDescargar = false;
            for(ContentDocument cd : lstContentDocument){
                strArchivos += '[\''+cd.Title;
                strArchivos += '\',\'';
                strArchivos += ''+cd.Id;
                strArchivos += '\'],';
 
            }

        }
        return strArchivos;
    }

    /**
     * Metodo para obtener los Attachment de un caso en Base64
     * @param      idCaso  The identifier caso
     * @return     The attachments 2.
     */
    webService static String getAttachments2(String idCaso) {
        String strArchivos = '';
        List<ContentDocument> lstContentDocument = new List<ContentDocument>();
        Set<Id> setIdCD = new Set<Id>();        
        
        for(ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId  =: idCaso]){
            setIdCD.add(cdl.ContentDocumentId);
        }
        
        if(!setIdCD.isEmpty()){
            lstContentDocument = [SELECT Id, FileType, Title FROM ContentDocument WHERE Id IN: setIdCD];
        }

        Integer intSize = lstContentDocument.size();
        if(!lstContentDocument.isEmpty()){
            Integer cont = 0;
            while(cont<intSize){
             strArchivos += '["'+lstContentDocument[cont].Title;
             strArchivos += '","';
             strArchivos += ''+lstContentDocument[cont].Id;
             strArchivos += '"]';
             //System.debug(att2[cont].Body);
             cont++;
             if(cont < intSize) strArchivos += ',';
            }
        }
        return strArchivos;
    }

    /**
     * Gets the body base 64.
     *
     * @param      idFile  The identifier file
     *
     * @return     The body base 64.
     */
    webService static String getBodyBase64(String idFile) {
        List<ContentVersion> lstContentVersion = [SELECT VersionData FROM ContentVersion WHERE Id =: idFile limit 1];
        if(lstContentVersion.isEmpty()) return '';
        return Encodingutil.base64Encode(lstContentVersion[0].VersionData);
    }


    
    /**
    * @method       getURL
    * @description  Método que se permite obtener la URL para descarga de documetos relacionados a un registro.
    * @author       Paula Bohórquez - 09-09-2019
    */
    @AuraEnabled
    public static WrapperResponse getURL(String strRecordId){
       
       WrapperResponse wrpResponse = new WrapperResponse();
       List<ContentDocumentLink> lstContentDocumentLink = [SELECT ContentDocument.FileExtension,ContentDocument.Title,ContentDocument.LatestPublishedVersionId
                                            FROM ContentDocumentLink
                                           WHERE LinkedEntityId =: strRecordId];
        
        if(!lstContentDocumentLink.isEmpty()){
            String strURL = '/sfc/servlet.shepherd/version/download/';
            for(ContentDocumentLink cdl : lstContentDocumentLink){
                strURL = strURL + cdl.ContentDocument.LatestPublishedVersionId +'/';              
            }
            strURL = strURL.removeEnd('/');
            strURL = strURL + '?operationContext=S1';
            wrpResponse.strMensaje = 'Completado';
            wrpResponse.strURLDownload = strURL;
            
        }
        else{
            wrpResponse.strMensaje = 'No se han encontrado archivos asociados al registro.';
        }

        return wrpResponse;

    }


    public class WrapperResponse {
        
        @AuraEnabled
        public String strMensaje                {get;set;}
        @AuraEnabled
        public String strURLDownload             {get;set;}
    }
}