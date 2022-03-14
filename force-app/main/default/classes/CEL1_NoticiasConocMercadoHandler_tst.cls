/************************************************************************************************
Desarrollado por:  Globant
Autor:             Paula Bohórquez (PB)
Proyecto:          Compensar
Descripción:       Clase de prueba del handler del objeto Noticias Conocimiento Mercadeo

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     17/03/20         Paula Bohórquez  (PB)                    Creación Clase.
**************************************************************************************************/
@isTest(SeeAllData=true) 
public class CEL1_NoticiasConocMercadoHandler_tst {
    
    @istest
    public static void crearPublicacionChatter_tst(){
        
        CEL1_NoticiasConocimientoMercado__c objNoticias =COM_DataGenerator_cls.crearNoticiasMuro(false);
        objNoticias.CEL1_GrupoInteres__c = 'Todo Compensar;Noticias Conocimiento Venta';
        insert objNoticias;
        
        CEL1_NoticiasConocimientoMercado__c objNoticias2 =COM_DataGenerator_cls.crearNoticiasMuro2(false);
        objNoticias2.CEL1_GrupoInteres__c = 'Todo Compensar;Noticias Conocimiento Venta';
        insert objNoticias2;
        
       	List<ContentVersion> lstCV = new List<ContentVersion>(); 
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.Title = 'Título';
        cv.PathOnClient ='test';
		lstCV.add(cv);
        
        ContentVersion cv2 = new ContentVersion();
        cv2.ContentLocation = 'S';
        cv2.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv2.Title = 'Título2';
        cv2.PathOnClient ='test';
		lstCV.add(cv2);
        insert lstCV;
        Set<Id> temp = new Set<Id>();
        temp.add(lstCV[0].Id);
        temp.add(lstCV[1].Id);
        
        List<ContentVersion> lstContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: temp];
        System.debug('contentDocumentId='+lstContentVersion.get(0).ContentDocumentId);               
		List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>();         
        for(ContentVersion cvs : lstContentVersion){
        ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cvs.ContentDocumentId;
            cdl.LinkedEntityId = objNoticias.Id;
            cdl.ShareType = 'I';        
            lstCDL.add(cdl);
        }
        insert lstCDL;
        
        objNoticias.CEL1_Estado__c = 'Confirmada';
        update objNoticias;
        objNoticias2.CEL1_Estado__c = 'Confirmada';
        update objNoticias2;
    }
}