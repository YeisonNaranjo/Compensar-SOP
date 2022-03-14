/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase CEL1_ActualizarLogCorreo_tst

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     13/12/19         Manuel Mendez (MM)      Creación Clase.
    2.0     13/07/20         Juan Buitrago (JB)      Aggregating the second method to cover the filter
                                                     into CEL1_NoticiasConocimientoMercado__c' query.  
************************************************************************************************/
@isTest
public class CEL1_BorradoMuro_tst {
    @isTest
    public static void unitTets1() {
        
        CEL1_NoticiasConocimientoMercado__c objNoticias =COM_DataGenerator_cls.crearNoticiasMuro(false);
        objNoticias.CEL1_GrupoInteres__c = 'Todo Compensar;Noticias Conocimiento Venta';
        insert objNoticias; 
        
        CEL1_NoticiasConocimientoMercado__c objNoticias2 =COM_DataGenerator_cls.crearNoticiasMuro2(false);
        objNoticias2.CEL1_GrupoInteres__c = 'Todo Compensar;Noticias Conocimiento Venta';
        insert objNoticias2; 

        CollaborationGroup objGroup = COM_DataGenerator_cls.crearGrupoChatter(true);
        CollaborationGroup objGroup2 = COM_DataGenerator_cls.crearGrupoChatter2(true);
        
        objNoticias.CEL1_PostChatter__c        =  objGroup2.id;
        update objNoticias;

         objNoticias2.CEL1_PostChatter__c        =  objGroup2.id+';'+objGroup.id;
        update objNoticias2;
        Test.startTest();
            objNoticias.CEL1_Estado__c                   =   'Confirmada';
            update objNoticias;           
            objNoticias2.CEL1_Estado__c                  =   'Confirmada';
            update objNoticias2;
            CEL1_BorradoMuro_sch clsSCH = new CEL1_BorradoMuro_sch();
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, clsSCH);
        Test.stopTest();
    }
    @isTest
    public static void unitTets2() {
        CollaborationGroup objGroup = COM_DataGenerator_cls.crearGrupoChatter(true);
        FeedItem objFeedItem = new FeedItem( Body = 'Test', ParentId=objGroup.Id);
        insert objFeedItem;
        
        CEL1_NoticiasConocimientoMercado__c objNoticias =COM_DataGenerator_cls.crearNoticiasMuro(false);       
        objNoticias.CEL1_PostChatter__c =  objFeedItem.Id + ';';
        objNoticias.CEL1_Estado__c = 'Confirmada';
        objNoticias.CEL1_FechaPublicacion__c = Date.today().addDays(-35);
        objNoticias.CEL1_GrupoInteres__c = 'Todo Compensar;Noticias Conocimiento Venta';
        insert objNoticias;

        Test.startTest();
            CEL1_BorradoMuro_bch clsBatch = new CEL1_BorradoMuro_bch();
            database.executebatch(clsBatch,200);
        Test.stopTest();
    }
}