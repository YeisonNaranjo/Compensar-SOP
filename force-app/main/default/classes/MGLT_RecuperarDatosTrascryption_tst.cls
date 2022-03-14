/**
* Avanxo
* @author 			<a href = "mailto:cmosquera@avanxo.com">Cristian Jose Mosquera Puello </a>
* Project:			Sodimac
* Description:		Clase encargada de ejecutar  las operaciones de 
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		24/03/20		Cristian Mosquera (CM)		Implementación inicial de la clase.
**/
@IsTest
public class MGLT_RecuperarDatosTrascryption_tst {


    private static void createData(Id idCuenta){
        List<RF2_ConfAudCasos__mdt> ojbLst = [SELECT DeveloperName,RF2_RecEnvioCalidadGIE__c,RF2_RecEnvioCalidadPCE__c,RF2_RecEnvioSondeoPCE__c FROM RF2_ConfAudCasos__mdt];

        RF2_ContAudCasos__c conf = new RF2_ContAudCasos__c();
        conf.Name = '1';
        conf.RF2_ConEnvioCasoCalidadGIE__c = ojbLst.get(0).RF2_RecEnvioCalidadGIE__c;
        conf.RF2_ConEnvioCasoCalidadPCE__c = ojbLst.get(0).RF2_RecEnvioCalidadPCE__c;
        conf.RF2_ConEnvioSondeoPCE__c = ojbLst.get(0).RF2_RecEnvioSondeoPCE__c;
        insert conf;

        //Account cuenta = COM_DataGenerator_cls.crearCuenta(true);

        Entitlement ent = new Entitlement();
        ent.AccountId = idCuenta;
        ent.Name = Label.RF2_NombreANSGenerico_lbl;
        ent.RF2_Canal__c = 'Call Center';
        ent.Rf2_GCN__c = 'Otros';
        ent.RF2_ObligatorioCalidad__c = false;
        insert ent;


        // crear mas entittlements para completar

        /*List<Entitlement> entitlementListGen = [SELECT Id, Name, RF2_Canal__c, Rf2_GCN__c, RF2_ObligatorioCalidad__c FROM Entitlement where Name =: Label.RF2_NombreANSGenerico_lbl];
if(entitlementListGen.isEmpty())
system.debug('no hay nada niño!! ');*/


    }

    @isTest
    static void testBatchRecuperar() {

        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact cont = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        DescribeFieldResult describe = Case.RF2_ProcesoDestinoMatrizResponsable__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        COM_DataGenerator_cls.crearMatrizREsponsablesCaso(true);
        createData(acc.Id);
        Case caso =  COM_DataGenerator_cls.crearCasox(true, acc.Id, cont.Id, 'Queja', 'CRM PCE', 'Alimentos', 'Aportes', 'Chat', false);

        LiveChatVisitor objLiveChatVisitor 					= New LiveChatVisitor();
        insert objLiveChatVisitor;

        LiveChatTranscript objLiveChatTrans;

        objLiveChatTrans 	= New LiveChatTranscript();

        objLiveChatTrans.AccountId 						= acc.Id;
        objLiveChatTrans.RF2_Apellidos__c				= 'Test';
        objLiveChatTrans.RF2_Nombres__c					= 'Test_name';
        objLiveChatTrans.RF2_CorreoElectronico__c		= 'test@test.com';
        objLiveChatTrans.RF2_NumeroContacto__c			= '3008004400';
        objLiveChatTrans.RF2_TipoIdentificacion__c		= '1';
        objLiveChatTrans.MGLT_Tipo_Identificacion__c	= '1';
        objLiveChatTrans.RF2_NumeroIdentificacion__c 	= '1014204900';
        objLiveChatTrans.LiveChatVisitorId				= objLiveChatVisitor.Id;
        objLiveChatTrans.Status = 'Completed';
        objLiveChatTrans.Caseid = caso.Id;
        insert objLiveChatTrans;

        //objLiveChatTrans.AccountId = acc.Id;
        objLiveChatTrans.Caseid = null;


        update objLiveChatTrans;

        Test.startTest();




        MGLT_RecuperarDatosTrascryption_bch batch = new MGLT_RecuperarDatosTrascryption_bch();


        String status = 'Completed';
        Datetime createdDate = Datetime.newInstance(2019,12,1,1,0,0);
        String query = ' Select id, Name, Status, CreatedDate, Account.Name, ' +
                'AccountId,Account.COM_TipoIdentificacion__c ,Account.COM_Numero_de_identificacion__c, ' +
                'Owner.Name from LiveChatTranscript where AccountId != null ' +
                'and CaseId = null  order by CreatedDate';

        String query2 = ' Select id from LiveChatTranscript where AccountId != null';

        List<LiveChatTranscript> lstQuery = Database.query(query);
        System.assert(!lstQuery.isEmpty());
        String sch = '0 0 1 * * ?';
        system.schedule('Test Exito', sch, batch);
        Test.stopTest();
    }
}