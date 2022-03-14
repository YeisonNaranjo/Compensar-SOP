/**
* Avanxo Colombia
* @author           William Aldana href=<waldana@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce COM_BotonConsultarPerfilSian_ctr
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-12-05      William Aldana (WAC)            Creación clase.
*************************************************************************************************************/

public with sharing class COM_BotonConsultarPerfilSian_ctr {
	public String ieValue {get; set;} 
	public Account objcuenta {get; set;} 
	public COM_BotonConsultarPerfilSian_ctr(ApexPages.StandardController controller) {
		ieValue = '';
		objcuenta = (Account) controller.getRecord();  
	}

	public PageReference redireccionar(){
		System.debug('ieValue: ' + ieValue);
		if(ieValue.equals('true')){
			PageReference pageRef = new PageReference(COM_TraerDatosPerfilSIAN_cls.obtenerURLSIAN(objcuenta.Id));
			return pageRef;
		}else{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Esta funcionalidad solo esta disponible para Internet Explorer.'));
			return null;
		}
		
	}
}