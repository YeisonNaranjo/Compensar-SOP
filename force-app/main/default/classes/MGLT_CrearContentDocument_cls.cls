/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Luis Rafael Peñaranda (LP)
Proyecto:          Compensar
Descripción:       Clase para crear un ContentDocument
                    * Seleccionar una plantilla y mostrarla como PDF

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     20/09/17             Luis Rafael Peñaranda (CM)             Creación Clase.
************************************************************************************************/
public class MGLT_CrearContentDocument_cls 
{
    
    @AuraEnabled
    public static ContentVersion saveTheFile(Id parentId, String fileName, Blob base64Data, String contentType, Id contentDocumentId) { 
        System.debug('--->>BASE 64 BEFORE : '+base64Data);
      // base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        System.debug('--->>BASE 64 AFTER : '+base64Data);
        String cType = contentType.remove('.');
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = base64Data;
        // cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        cv.PathOnClient = filename + contentType;
        System.debug('--->> PB >> PathOnClient: '+cv.PathOnClient);
        insert cv;
        
        list<ContentVersion> lstContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id];
        System.debug('contentDocumentId='+lstContentVersion.get(0).ContentDocumentId);               
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = lstContentVersion.get(0).ContentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'I';
        
        insert cdl;
        
        return cv;
    }

    @AuraEnabled
    public static ContentVersion saveContentDocument(Id parentId, String fileName, Blob base64Data, String contentType) {         
        return saveTheFile(parentId, fileName, base64Data, contentType, NULL);
    }
}