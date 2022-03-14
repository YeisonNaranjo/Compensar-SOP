/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Rubén Suárez Forero (RUSF)
Proyecto:          Compensar
Descripción:       Batch para actualizar el propietario de las cuentas

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     23/01/18             Rubén Suárez Forero (RUSF)              Creación clase.
************************************************************************************************/

global class COM_ActualizarPropietario_bch implements Database.Batchable<sObject> {
	
	global COM_ActualizarPropietario_bch() {
		system.debug('Entra actualizar propietario cuentas');
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		List<User> administrador = [SELECT Id FROM User WHERE Name =: Label.COM_Administrador_CRM]; 
		if(!administrador.isEmpty()){
			return Database.getQueryLocator([ 
	            SELECT  Id, OwnerId
	            FROM    Account
	            WHERE   OwnerId != :administrador[0].Id]);
		} else {
			return null;
		}
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<User> administrador = [SELECT Id FROM User WHERE Name =: Label.COM_Administrador_CRM]; 
		if(!administrador.isEmpty()){
			List<Account> lstUpdate = new List<Account>();
			for (sObject s : scope) {
				Account a = (Account) s;
				a.OwnerId = administrador[0].Id;
				lstUpdate.add(a);
			}
			COM_AccountContactRelation_cls.stopTrigger();
			List<Database.SaveResult> results = Database.update(lstUpdate , false);
			for(Database.SaveResult result : results){
				if(!result.isSuccess()){
					for(Database.Error err : result.getErrors()){
						System.debug('Error: '+err.getStatusCode()+' '+err.getMessage());
					}
				}
			}
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}