/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             William Aldana (WA)
Proyecto:          Compensar
Descripción:       Clase Utilitaria encargada de:
				   * Obtener los datos necesarios para conectarse a SIAN

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     01/08/17         William Aldana  (WA)   Creación Clase.
************************************************************************************************/

global class COM_TraerDatosPerfilSIAN_cls {


	public COM_TraerDatosPerfilSIAN_cls() {
		
	}

	/**
	 * [obtenerURLSIAN description]
	 * @param  strIdentificacion [description]
	 * @return                   [description]
	 */
	webService static String obtenerURLSIAN(String numeroCuenta) {
		List<Account> lstCuentas = new List<Account>();
		lstCuentas = [Select COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, RecordTypeId from Account where Id =:numeroCuenta];    

		List<RecordType> lstRtype = [Select Name from RecordType where ID =:lstCuentas.get(0).RecordTypeId];
		String tipoSian = 'SIANEMPRESARIAL';
		if(lstRtype.get(0).Name.equals('Jurídico')){
			tipoSian = 'SIANEMPRESARIAL';
		}else{
        		// no hay configuracion para Natural
        	tipoSian = 'SIANPERSONAL';
       	}
			List<COM_ConfiguracionSianEmpresaM__mdt> sian = [SELECT COM_Url_SIAN_p1__c, COM_Url_SIAN_p2__c, COM_Url_SIAN_p3__c FROM COM_ConfiguracionSianEmpresaM__mdt where developerName =:tipoSian];
			if(!sian.isEmpty()){
        		COM_HabilitarRecursoSSO_WS ssoRequest = new COM_HabilitarRecursoSSO_WS();
        		String token = ssoRequest.getTokenSSO();
				String url = sian.get(0).COM_Url_SIAN_p1__c;//'https://pruebasreportessian.compensar.com/_layouts/15/compensar.sian/sso.aspx?token=';
				url += token;
				url += sian.get(0).COM_Url_SIAN_p2__c;//'&requesturl=%2F_layouts%2F15%2FReportServer%2FAdHocReportDesigner.aspx%3FRelativeReportUrl%3D%2FReportesSian%2FCRMPerfilEmpresarialNit.rdlx%26ViewMode%3DPresentation%26ReportSection%3DReportSection%26rf%3D%5BEMPRESA%5D.%5BNIT%5D%20eq%20%';
				url += lstCuentas.get(0).COM_Numero_de_identificacion__c + sian.get(0).COM_Url_SIAN_p3__c;//'%27';
				system.debug('url: ' + url);
        		return url; 
        	}else{
        		return '';
        	}
        
    }

}