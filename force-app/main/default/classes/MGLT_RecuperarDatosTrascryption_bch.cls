/**
* Avanxo
* @author 			<a href = "mailto:cmosquera@avanxo.com">Cristian Jose Mosquera Puello </a>
* Project:			Compensar
* Description:		Clase encargada de ejecutar  las operaciones de batch para recuperar los datos.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		24/03/20		Cristian Mosquera (CM)		Implementación inicial de la clase.
**/
global class MGLT_RecuperarDatosTrascryption_bch implements Schedulable,
        Database.Batchable<SObject>   {

    global Database.QueryLocator start(Database.BatchableContext context)
    {
        System.debug('Ejecutando QUery;');
        String status = 'Completed';
        Datetime createdDate = Datetime.newInstance(2019,12,1,1,0,0);
        String query = ' Select id, Name, StartTime, Status, CreatedDate, Account.Name, ' +
                'AccountId,Account.COM_TipoIdentificacion__c ,Account.Phone,' +
                'Account.COM_Primernombre__c, Account.COM_Primerapellido__c, Account.COM_Numero_de_identificacion__c,' +
                'Account.COM_CorreoElectronico__c, MGLT_Tipo_Identificacion__c, RF2_NumeroIdentificacion__c, ' +
                'RF2_Telefono__c, RF2_Nombres__c, RF2_Apellidos__c, RF2_CorreoElectronico__c,' +
                'Owner.Name, Case.MGLT_Consulta__c,RF2_Consulta__c, RF2_NumeroContacto__c  from LiveChatTranscript where AccountId != null ' +
                'and CaseId = null and Status = :status ' +
                'and CreatedDate > :createdDate  order by CreatedDate';

        System.debug('Tamano -->' + Database.query(query).size());
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<LiveChatTranscript> scope)
    {


        System.debug('Ejecutando batch');

        List<String> accountIdByTranscript = new List<String>();

        for (LiveChatTranscript valueIt : scope) {
            accountIdByTranscript.add(valueIt.AccountId);
        }
        Map<String, Case> mapCasesByKeyDateAndAccountId = new Map<String, Case>();

        List<Case> casesChatByAccount = [SELECT Id, ContactId, AccountId, CreatedDate, MGLT_Consulta__c
                from Case where AccountId in :accountIdByTranscript and Origin = 'Chat'];

        for (Case valueIt : casesChatByAccount) {
            System.debug('Account Id Case-->' + valueIt.AccountId);
            if (valueIt.AccountId == null) {
                continue;
            }
            String key = generateKey(valueIt.CreatedDate, valueIt.AccountId, null);
            System.debug('keyCase-->' + key);
            mapCasesByKeyDateAndAccountId.put(key, valueIt);
        }
        map<String,String> ConsultLabel = new map<String,String>();
        Schema.DescribeFieldResult fieldResult =
                Case.MGLT_Consulta__c.getDescribe();
        system.debug('saber-->'+fieldResult );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple---->'+ ple);
        for( Schema.PicklistEntry f : ple)
        {
            ConsultLabel.put(f.getValue(),f.getLabel());
        }
        for (LiveChatTranscript valueIt : scope) {
            String key = generateKey(valueIt.CreatedDate, valueIt.AccountId, null);
            String key2 = generateKey(valueIt.CreatedDate, valueIt.AccountId, 1);
            String key3 = generateKey(valueIt.StartTime, valueIt.AccountId, null);
            String key4 = generateKey(valueIt.StartTime, valueIt.AccountId, 1);
            System.debug('keyTranscript-->' + key);
            System.debug('ContainsKey-->' + mapCasesByKeyDateAndAccountId.containsKey(key));
            if (!mapCasesByKeyDateAndAccountId.containsKey(key)) {
                if(mapCasesByKeyDateAndAccountId.containsKey(key2)) {
                    key = key2;
                }
                else if (valueIt.StartTime != null && mapCasesByKeyDateAndAccountId.containsKey(key3)) {
                    key = key3;
                }
                else if (valueIt.StartTime != null && mapCasesByKeyDateAndAccountId.containsKey(key4)) {
                    key = key4;
                }
                else {
                    continue;
                }

            }
            Case caseFound =  mapCasesByKeyDateAndAccountId.get(key);
            valueIt.CaseId = caseFound.Id;
            valueIt.ContactId = caseFound.ContactId;
            valueIt.MGLT_Tipo_Identificacion__c = String.isBlank(valueIt.MGLT_Tipo_Identificacion__c) ? valueIt.Account.COM_TipoIdentificacion__c :valueIt.MGLT_Tipo_Identificacion__c ;
            valueIt.RF2_NumeroIdentificacion__c = String.isBlank(valueIt.RF2_NumeroIdentificacion__c) ? valueIt.Account.COM_Numero_de_identificacion__c :valueIt.RF2_NumeroIdentificacion__c;
            valueIt.RF2_Telefono__c = String.isBlank(valueIt.RF2_Telefono__c) ? valueIt.Account.Phone :valueIt.RF2_Telefono__c;
            valueIt.RF2_Nombres__c =  String.isBlank(valueIt.RF2_Nombres__c) ? valueIt.Account.COM_Primernombre__c :valueIt.RF2_Nombres__c;
            valueIt.RF2_Apellidos__c = String.isBlank(valueIt.RF2_Apellidos__c) ? valueIt.Account.COM_Primerapellido__c :valueIt.RF2_Apellidos__c;
            valueIt.RF2_CorreoElectronico__c =  String.isBlank(valueIt.RF2_CorreoElectronico__c) ? valueIt.Account.COM_CorreoElectronico__c :valueIt.RF2_CorreoElectronico__c;

            valueIt.RF2_NumeroContacto__c = String.isBlank(valueIt.RF2_NumeroContacto__c) ? valueIt.Account.Phone :valueIt.RF2_NumeroContacto__c;
            valueIt.RF2_Consulta__c = String.isBlank(valueIt.RF2_Consulta__c) ? ConsultLabel.get(caseFound.MGLT_Consulta__c) :valueIt.RF2_Consulta__c;



        }

        MGLT_LiveChatTranscript_cls.setTipoIdentificacion(scope);

        Database.update(scope, false);

    }

    global void finish( Database.BatchableContext BC )
    {


    }


    public String generateKey (Datetime dt, String accountId, Integer menosMinuto) {
        if (dt == null) {
            return '';
        }
        Integer minuto = dt.minute();
        if (menosMinuto != null) {
            minuto +=  menosMinuto;
        }
        String key = dt.year() + ''
                + dt.month() + '' +
                dt.day() + '' + dt.hour() + ''
                + minuto + accountId;
        return key;
    }

    // Metodo para ejecucion del batch
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new MGLT_RecuperarDatosTrascryption_bch());
    }
}