/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Clase Helper para clase Handler CEL1_LeadHandler_cls
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     30/10/19        Manuel Mendez  (MM)     Creación Clase.
    1.1     01/11/19        Paula Bohórquez (PB)    Se crea método que consulta WS 
                                                    de Gestión de Clientes.
    1.2     05/11/19        Paula Bohórquez (PB)    Se crean métodos que actualizan cuentas 
                                                    y contactos de prospectos. 
    1.3     12/02/20      	Andrea Contreras (AC)   Se agrega modificación para el envío de 
                                                    correos según el tipo de aportante   
	1.4  	12/02/20		Andrea Tellez (AT)
	
	1.5		06/11/20		Milton Romero (MR)		Estas reglas de prospecto no aplican para
													Prospectos salud [COS_ProspectoSalud], se ajusta
													para que no apliquen a éste tipo de registro
	1.6		18/06/21		Jorge Pozo (JPA)		validarCuentas() - Se agrego el filtro para que 
													no aplique a los Leads (Prospecto Afiliación Caja)
													actualizarTipoCuenta() - Se agrego el filtro para que 
													no aplique a los Leads (Prospecto Afiliación Caja)
													validarPerfil() - Se agrego el filtro para que 
													no aplique a los Leads (Prospecto Afiliación Caja)
													convertirCandidatoBefore() - Se agrego el filtro para que 
													no aplique a los Leads (Prospecto Afiliación Caja)
**************************************************************************************************/
public without sharing class CEL1_LeadHelper_cls {
    public static void validarCuentas(List<Lead> lstLeadNew)
    {
        Set<String> setIdentificacion = new Set<String>();
        Set<String> setNumDocumento = new Set<String>();
        Set<String> setTipoDocumento = new Set<String>();
        Map<String,Lead> mapLeadLlave = new Map<String,Lead>();
        List<RecordType> lstRecordType = [SELECT DeveloperName, Id FROM RecordType WHERE SobjectType = 'Lead'];
        Map<String,Id> mapRecordType = new Map<String,Id>();
        System.debug('------>mapRecordType'+mapRecordType);
        for (RecordType objRecord: lstRecordType) {
            mapRecordType.put(objRecord.DeveloperName, objRecord.Id);
        }
        for (Lead objLead: lstLeadNew) {
            
            //objLead.CEL1_IdentificacionCandidato__c = objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c+objLead.RecordTypeId;
            //Adicion del tipo de aportante (Andrea tellez)
 //           objLead.CEL1_IdentificacionCandidato__c = objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c+objLead.CEL1_TipoCandidato__c+objLead.CEL1_TipoAportante__c;
            objLead.CEL1_PrimerNombre__c = objLead.FirstName;
            objLead.CEL1_PrimeroApellido__c = objLead.LastName;
            objLead.CEL1_SegundoNombre__c   =    objLead.MiddleName;
            
			if(String.isBlank(objLead.Company)){
				if(objLead.FirstName != null){
					objLead.Company = objLead.FirstName+' '+objLead.LastName;
				}else{
					objLead.Company = objLead.LastName;
				}
			}
            
            if(objLead.RecordTypeId != mapRecordType.get('COS_ProspectoSalud') && objLead.RecordTypeId != mapRecordType.get('RL2_ProspectoAfiliacionCaja')){
				objLead.CEL1_IdentificacionCandidato__c = objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c+objLead.CEL1_TipoCandidato__c+objLead.CEL1_TipoAportante__c;
                objLead.RecordTypeId = mapRecordType.get(objLead.CEL1_TipoCandidato__c); 
                if(objLead.CEL1_TipoCandidato__c == 'CEL1_ProspectosCuentaAcreedoraPJ' || objLead.CEL1_TipoCandidato__c == 'CEL1_ProspectoCuentaAcreedoraPN' ){
                    objLead.LeadSource = 'Cuenta Acreedora';
                }
                
                mapLeadLlave.put(objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c,objLead);
                setNumDocumento.add(objLead.CEL1_NumeroDocumento__c);
                setTipoDocumento.add(objLead.CEL1_TipoDocumento__c);
                System.debug('******LEAD QUE SE VA A CREAR :'+objLead);
                // setIdentificacion.add(objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c);
        	}
        }
        System.debug('mapLeadLlave--->>>>>'+mapLeadLlave);

       /* List<Account> lstCuentas = [SELECT Id,
                                   COM_Tiponumeroidentificacion__c
                                   FROM Account
                                   WHERE COM_Tiponumeroidentificacion__c IN: mapLeadLlave.keySet() AND COM_Estadoafiliacion__c = '1'];*/
        List<Account> lstCuentas = [SELECT Id, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c
                                    FROM Account
                                    WHERE COM_TipoIdentificacion__c IN: setTipoDocumento AND COM_Numero_de_identificacion__c IN: setNumDocumento AND COM_Estadoafiliacion__c =: Label.CEL1_EstadoAfiliacionCliente];
       
        
        System.debug('lstCuentas---->>>>'+lstCuentas);                                    
        if (!lstCuentas.isEmpty()) {
            System.debug('ENTRO A IF PORQUE ESTABA LLENA LA LISTA');
            for (Account objCuenta: lstCuentas) {
                if (mapLeadLlave.containsKey(objCuenta.COM_TipoIdentificacion__c + objCuenta.COM_Numero_de_identificacion__c)) {
                //if (mapLeadLlave.containsKey(objCuenta.COM_Tiponumeroidentificacion__c)) {
                    mapLeadLlave.get(objCuenta.COM_TipoIdentificacion__c + objCuenta.COM_Numero_de_identificacion__c).addError(Label.CEL1_ErrorCandidatosMasivos);
                    //mapLeadLlave.get(objCuenta.COM_Tiponumeroidentificacion__c).addError(Label.CEL1_ErrorCandidatosMasivos);
                }
            }
        }
    }


    /**
    * @Method:      actualizarTipoCuenta
    * @param:       List<Lead> lstProspectos
    * @Description: Actualiza el tipo de registro de la cuenta dependiendo del tipo de prospecto 
    *               cuenta acreedora y llena la(s) línea(s) de negocios a las que la cuenta 
    *               está asociada. 
    * @author       Paula Bohórquez Alfonso- 05 de Noviembre 2019 
    */
    public static void actualizarTipoCuenta(List<Lead> lstProspectos,Map<Id,Lead> mapOldLead){

        Map<String, List<String>> mapAccxRT = new Map<String, List<String>>();
        Map<String, String> mapAccxCon = new Map<String, String>();
        List<String> lstRTLead = new List<String>();
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        string strRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        
        for(Lead objLead : lstProspectos){
            if(objLead.RecordTypeId != strRecordTypeLeadSalud && objLead.RecordTypeId != strRecordTypeAfiliacionCaja){
                if((mapOldLead.get(objLead.Id).isConverted != objLead.isConverted)&&objLead.isConverted){
                    lstRTLead.add(objLead.RecordTypeId);
                    mapAccxCon.put(objLead.ConvertedAccountId,objLead.ConvertedContactId);                
                    //PB AVX 07-11-19 Descomentar cuando se haga conversión de múltiples prospectos.
                    /*if (mapAccxRT.containsKey(objLead.ConvertedAccountId)) {
                        mapAccxRT.get(objLead.ConvertedAccountId).add(objLead.RecordTypeId);
                    }
                    else{*/
                        List<String> lstRTS = new List<String>();
                        lstRTS.add(objLead.RecordTypeId);
                        mapAccxRT.put(objLead.ConvertedAccountId, lstRTS);
                    //}                                
                }
            }
        }
        System.debug('***** mapAccxRT'+mapAccxRT);
        Map<String, String> mapRTxDevName = new Map<String, String>();
        System.debug('******LOS RT QUE SE ENCONTRARON PARA LEADS: '+lstRTLead);
        //ID de RecordType de Lead con su respectivo DevName
        for(RecordType objRT : [SELECT Id,DeveloperName FROM RecordType WHERE Id IN: lstRTLead]){
            mapRTxDevName.put(objRT.Id, objRT.DeveloperName);            
        }

        String strTemp;
        List<Account> lstAccUpdate = new List<Account>();
        Set<Id> setIdConUpdate = new Set<Id>();
        Account objAccUpd;
        
        System.debug('****** mapRTxDevName: '+mapRTxDevName);
        //for(Account objAccount : [SELECT Id,RecordTypeId FROM Account WHERE COM_Numero_de_identificacion__c = '80159169' LIMIT 1]){
        for(Account objAccount : [SELECT Id,CEL1_OrigenEsProspecto__c,AccountSource,RecordTypeId,CEL1_LineaNegocio__c FROM Account WHERE (CEL1_OrigenEsProspecto__c = true OR COM_Estadoafiliacion__c = '1' OR COM_Estadoafiliacion__c='') AND COM_Numero_de_identificacion__c != '' AND Id IN: mapAccxRT.keySet()]){
           //Se procede a llamar al ws para consultar clientes en Gestión clientes para prospectos cuenta acreedora
            for (String strRT : mapAccxRT.get(objAccount.Id)) {
                strTemp = mapRTxDevName.get(strRT);
                if(String.isNotBlank(strTemp)){
                    objAccUpd = new Account();
                    if(strTemp == 'CEL1_ProspectoCuentaAcreedoraPN' || strTemp == 'CEL1_ProspectosCuentaAcreedoraPJ'){
                        if(strTemp == 'CEL1_ProspectoCuentaAcreedoraPN'){
                            objAccUpd.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('COM_Natural').getRecordTypeId();
                        }
                        else{
                            objAccUpd.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('COM_Juridico').getRecordTypeId();
                        }
                        
                        objAccUpd.AccountSource = 'Cuenta Acreedora';
                        if(String.isBlank(String.valueOf(objAccount.CEL1_LineaNegocio__c))){
                            objAccUpd.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
                        }
                        else if(!String.valueOf(objAccount.CEL1_LineaNegocio__c).contains('Afiliación Corporativa')){
                            objAccUpd.CEL1_LineaNegocio__c = objAccount.CEL1_LineaNegocio__c+';Afiliación Corporativa';
                        }
                        objAccUpd.Id = objAccount.Id;
                        System.debug('******* ES PROSPECTO CA-PN : ACCOUNT UPDATE :'+objAccUpd);
                        lstAccUpdate.add(objAccUpd);
                        setIdConUpdate.add(mapAccxCon.get(objAccount.Id));
                        if(objAccount.CEL1_OrigenEsProspecto__c){
                            agregarNautcliClienteFuture(objAccount.Id);
                        }
                        
                    }
                    
                    //PB AVX 07-11-19 Descomentar cuando haya más de un tipo de registro en Candidatos.
                    /*else{
                        //EL API NAME DE LA LÍNEA DE NEGOCIO DE LA CUENTA DEBE COINCIDIR CON EL DEVELOPERNAME
                        // DEL TIPO DE REGISTRO.
                        if(String.isNotBlank(objAccount.CEL1_LineaNegocio__c)){
                            objAccUpd.CEL1_LineaNegocio__c = objAccount.CEL1_LineaNegocio__c+';'+strTemp;
                        }
                        else{
                            objAccUpd.CEL1_LineaNegocio__c = strTemp;
                        }
                        objAccUpd.Id = objAccount.Id;
                        System.debug('******* ES OTRO PROSPECTO : ACCOUNT UPDATE :'+objAccUpd);
                        lstAccUpdate.add(objAccUpd);
                    }*/
                }                
            }         
        }

        if(!lstAccUpdate.isEmpty()){
            System.debug('****** VA A HACER UPDATE ACCOUNT :'+lstAccUpdate);
            try {
                update lstAccUpdate;
                System.debug('****** SE HIZO EL UPDATE DE ACCOUNT : lstAccUpdate');
            
            } catch (Exception ex) {
                System.debug('******* ERROR AL ACTUALIZAR ACC DEL LEAD : '+ex.getMessage());                
            }
            
        }

        if(!setIdConUpdate.isEmpty()){
            actualizarRolContactoNatural(setIdConUpdate);
        }
    }

    /**
    * @Method:      actualizarRolContactoNatural
    * @param:       Set<Id> setIdContactosUpd
    * @Description: Asigna el rol 'Representante Legal' al objeto AccountContactRelation para los contactos asociados
    *               a cuentas tipo 'Persona Natural'
    * @author       Paula Bohórquez Alfonso- 06 de Noviembre 2019 
    */

    public static void actualizarRolContactoNatural(Set<Id> setIdContactosUpd){

        List<AccountContactRelation> lstACRelationUpd = new List<AccountContactRelation>();
        for(AccountContactRelation objACR : [SELECT Roles FROM AccountContactRelation WHERE ContactId IN: setIdContactosUpd AND Roles = '']){
            lstACRelationUpd.add(new AccountContactRelation(Id = objACR.Id,
                                                            Roles = 'Representante Legal'));
        }
        if(!lstACRelationUpd.isEmpty()){
            try {
                update lstACRelationUpd;
            } catch (Exception ex) {
                System.debug('****** ERROR AL ACTUALIZAR ROL DE AccountContactRelation : '+ex.getMessage());
            }
        }
    }

     /**
    * @Method:      enviarCorreosCuentaAcreedora
    * @param:       Set<Id> mapCandidatos
    * @Description: Envía un correo a cada candidato tipo Cuenta Acreedora en la creación.
    * @author       Paula Bohórquez Alfonso- 06 de Diciembre 2019 
    */

    public static void enviarCorreosCuentaAcreedora(Map<Id,Lead> mapCandidatos){
        String strRTCAPN = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('CEL1_ProspectoCuentaAcreedoraPN').getRecordTypeId();
        String strRTCAPJ = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('CEL1_ProspectosCuentaAcreedoraPJ').getRecordTypeId();
        Set<Id> setIdsLead = new Set<Id>();
        List<Lead> lstCandidatosUpd = new List<Lead>();
        //LIMITAR SI EL TRIGGER.NEW ES MAYOR A LA CANTIDAD DE CORREOS DISPONIBLES NO CORRER NADA
        for(Lead objCandidato : mapCandidatos.values()){
            if((objCandidato.RecordTypeId == strRTCAPJ || objCandidato.RecordTypeId == strRTCAPN )&& String.isNotBlank(objCandidato.Email)){
               //(AT)ya que el metodo enviarCorreosCuentaAcreedoraFuture, se valida el tipo de aportante para el envio de las plantillas
                // if(objCandidato.CEL1_TipoAportante__c==Label.CEL1_CAIndependiente){
                   setIdsLead.add(objCandidato.Id);
               // }              
                
            }
        }
        
        if(!setIdsLead.isEmpty()){           
            enviarCorreosCuentaAcreedoraFuture(setIdsLead);
        }
        
    
    }
    

    /**
    * @Method:      agregarNautcliClienteFuture
    * @param:       List<Lead> lstProspectos
    * @Description: Verifica si el cliente creado a partir de la conversión de un prospecto está
    *               en el WS de Gestión Clientes. Si existe, llena el Naucli del registro en Salesforce
    *               a partir de la información que obtenga de la integración. No se tendrán en cuenta cuentas que
    *               puedan ser creadas sin Número de identificación.
    * @author       Paula Bohórquez Alfonso- 01 de Noviembre 2019 
    */
    @future (callout=true)
    public static void agregarNautcliClienteFuture(Id idAccount){
        COM_ConsultarClienteGC_ws cls  = new COM_ConsultarClienteGC_ws();
        Account objCuentaUpd = new Account();
        System.debug('**** ENTRA AL FUTURE '+idAccount);
        for(Account objCuenta : [SELECT Id,COM_TipoIdentificacion__c,COM_Numero_de_identificacion__c FROM Account WHERE Id =: idAccount]){
        //for(Account objCuenta : [SELECT Id,COM_TipoIdentificacion__c,COM_Numero_de_identificacion__c FROM Account WHERE Id =: idAccount AND COM_NAUTCLI__c = '']){
            System.debug('***** objCuenta : '+objCuenta);
            if(objCuenta.COM_TipoIdentificacion__c != '' && objCuenta.COM_Numero_de_identificacion__c != ''){
                COM_WrapperConsultaClienteGCResponse_cls.Body wrpCuenta = cls.Consultar(Integer.valueOf(objCuenta.COM_TipoIdentificacion__c), Integer.valueOf(objCuenta.COM_Numero_de_identificacion__c));
                if(wrpCuenta != null && wrpCuenta.Cliente != null && wrpCuenta.Cliente.Id != null && wrpCuenta.Cliente.Id != '-1'){
                    if(objCuentaUpd.COM_NAUTCLI__c != wrpCuenta.Cliente.Id  ){
                        objCuentaUpd.Id = idAccount;
                        objCuentaUpd.COM_NAUTCLI__c = wrpCuenta.Cliente.Id;
                        System.debug('*****PBAVX : NAUCLI : '+wrpCuenta.Cliente.Id);
                        System.debug('*****PBAVX : objCuentaUpd : '+objCuentaUpd);
                        update objCuentaUpd;
                    }
                }
                else{
                    System.debug('***** NO SE ENCONTRÓ EL CLIENTE EN GC ');
                }
            }
        }
    }

    /**
    * @Method:      enviarCorreosCuentaAcreedoraFuture
    * @param:       Set<Id> setIdCandidatos
    * @Description: Envía correos electrónicos a los candidatos cuenta acreedora nuevos, genera 
    *               además registros de logs de correo electrónico y marca el check 'Email Enviado'
    *               en los candidatos.
    * @author       Paula Bohórquez Alfonso- 09 de Diciembre 2019 
    */
    @future 
    public static void enviarCorreosCuentaAcreedoraFuture(Set<Id> setIdCandidatos){
        //Set de ids por tipo de aportante 
        Set<Id> setIdsLeadIndependiente = new Set<Id>();
        Set<Id> setIdsLeadJuridico      = new Set<Id>();
        Set<Id> setIdsLeadEmpDomestico  = new Set<Id>();
        Set<Id> setIdsLeadNatural       = new Set<Id>();

        List<CEL1_ConfiguracionLogCorreos__mdt> lstMdt = [SELECT CEL1_NumeroCorreosSalientes__c FROM CEL1_ConfiguracionLogCorreos__mdt LIMIT 1];
        Integer intCorreosEnviadosHoy = [SELECT count() FROM Log_Correo_Electronico__c WHERE CEL1_Candidato__c != '' AND Fecha_Envio__c >: System.today()];
        Integer intMaxCorreosDiarios = Integer.valueOf(lstMdt[0].CEL1_NumeroCorreosSalientes__c);
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        System.debug('**** enviarCorreosCuentaAcreedoraFuture : intMaxCorreosDiarios : '+intMaxCorreosDiarios);
        System.debug('**** enviarCorreosCuentaAcreedoraFuture : intCorreosEnviadosHoy : '+intCorreosEnviadosHoy);
        Integer intDisponiblesEnvioHoy = intMaxCorreosDiarios - intCorreosEnviadosHoy;
        if(intCorreosEnviadosHoy<intMaxCorreosDiarios && setIdCandidatos.size() <= intDisponiblesEnvioHoy){
           //List<Lead> lstLead = [SELECT Id  FROM Lead WHERE Id IN : setIdCandidatos];
           //(AT)Se añade el campo CEL1_TipoAportante__c para la asignacion de la plantilla
           List<Lead> lstLead = [SELECT Id, CEL1_TipoAportante__c, RecordTypeId FROM Lead WHERE Id IN : setIdCandidatos];
           for(Lead objLead:lstLead){
              if(objLead.RecordTypeId != strRecordTypeLeadSalud){ 
                if(objLead.CEL1_TipoAportante__c==Label.CEL1_TipoAportanteIndependiente){
                    setIdsLeadIndependiente.add(objLead.Id);
                } else if(objLead.CEL1_TipoAportante__c==Label.CEL1_TipoAportanteJuridica){
                    setIdsLeadJuridico.add(objLead.Id);
                } else if(objLead.CEL1_TipoAportante__c==Label.CEL1_TipoAportanteEmpleDomes){
                    setIdsLeadEmpDomestico.add(objLead.Id);
                } else {
                    setIdsLeadNatural.add(objLead.Id);
                }
              }
           }
           //Enviar correo electronico 
           if(!setIdsLeadIndependiente.isEmpty()){
               //Busca la plantilla segun el tipo de aportante del candidato
                List<EmailTemplate> lstETIndependiente = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAIndependiente];
                COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsLeadIndependiente,lstETIndependiente[0].Id);
           }          
           if(!setIdsLeadJuridico.isEmpty()){
                //Busca la plantilla segun el tipo de aportante del candidato
                List<EmailTemplate> lstETJuridica = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAPerJuridica];
                COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsLeadJuridico,lstETJuridica[0].Id);
           }
           if(!setIdsLeadEmpDomestico.isEmpty()){
                //Busca la plantilla segun el tipo de aportante del candidato
                List<EmailTemplate> lstETEmpDomestico = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAEmpleDomes];
                COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsLeadEmpDomestico,lstETEmpDomestico[0].Id);
            }
            if(!setIdsLeadNatural.isEmpty()){
                //Busca la plantilla segun el tipo de aportante del candidato
                List<EmailTemplate> lstETNatural = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.CEL1_CAPerNatural];
                COM_Utilidades_cls.enviarCorreosCuentaAcreedora(setIdsLeadNatural,lstETNatural[0].Id);
            }
            List<Lead> lstCandidatosUpd = new List<Lead>();
            for(Id candId : setIdCandidatos){
                lstCandidatosUpd.add(new Lead(Id = candId,
                CEL1_EmailFueEnviado__c = true));
            }   
            if(!lstCandidatosUpd.isEmpty()){
                update lstCandidatosUpd;
            }  

        }      
    }

    
    /**
    * @Method:      validarPerfil
    * @param:       List<Lead> lstLead
    * @Description: Valida que al cambiar de propietario sea un usuario con perfil asesor paf
    * @author       Manuel Mendez- 17 de Febrero 2020 
    */
    public static void validarPerfil(List<Lead> lstNewLead,List<Lead> lstOldLead){
        System.debug('ENTRO POR validarPerfil....');
        Set<Id> setIdOwner = new Set<Id>();
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        string strRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        
        for (Lead objLeadOwner : lstNewLead) {
            setIdOwner.add(objLeadOwner.OwnerId);
        }

        List<User> lstUsuario = [SELECT Id,
                                Profile.Name
                                FROM User
                                WHERE Id IN: setIdOwner];
        Map<Id,String> mapUsuarioxPerfil = new Map<Id,String>();
        for (User objUser: lstUsuario) {
            mapUsuarioxPerfil.put(objUser.Id,objUser.Profile.Name);
        }
        System.debug('mapUsuarioxPerfil.....'+mapUsuarioxPerfil);
        for (Integer i = 0; i< lstNewLead.size(); i++) {
            if(lstNewLead[i].RecordTypeId != strRecordTypeLeadSalud && lstNewLead[i].RecordTypeId != strRecordTypeAfiliacionCaja){
                // System.debug('mapOldLead.get(objLead.Id).OwnerId.....'+mapOldLead.get(objLead.Id).OwnerId);
                System.debug('mapUsuarioxPerfil.get(objLead.OwnerId).....'+mapUsuarioxPerfil.get(lstNewLead[i].OwnerId));
                // if (mapUsuarioxPerfil.get(lstNewLead[i].OwnerId) == 'Asesor - PAF') {
                if (lstOldLead[i].OwnerId != lstNewLead[i].OwnerId && !mapUsuarioxPerfil.get(lstNewLead[i].OwnerId).contains(label.CEL5_PerfilesLeadOwner)) {
                    lstNewLead[i].addError(label.CEL5_ErrorOwnerLead);
                }
            }
        }
    }


    /**
    * @Method:      convertirCandidatoBefore
    * @param:       List<Lead> lstLead
    * @Description: Valida que al convertir el candidato tenga cuenta y le asigne el asesor PAF 
    * @author       Manuel Mendez- 17 de Febrero 2020 
    */
    public static void convertirCandidatoBefore(List<Lead> lstNewLead,List<Lead> lstOldLead,String strMomento){
        System.debug('ENTRO POR convertirCandidatoBefore....');
        Map<String,String> mapCuentaxCandidato = new Map<String,String>();
        Map<String,Lead> mapLead = new Map<String,Lead>();
        Map<String,String> mapDocumentoxIdLead = new Map<String,String>();
        Set<String> setTipo = new Set<String>();
        Set<String> setDocumento = new Set<String>();
        Boolean blnConverted = false;
        string strRecordTypeLeadSalud = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('COS_ProspectoSalud').getRecordTypeId();
        string strRecordTypeAfiliacionCaja = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RL2_ProspectoAfiliacionCaja').getRecordTypeId();
        
        for (Lead objLead:lstNewLead) {
            if(objLead.RecordTypeId != strRecordTypeAfiliacionCaja){
                if(objLead.IsConverted == true){
                    blnConverted = true;
                    mapLead.put(objLead.Id,objLead);
                    mapDocumentoxIdLead.put(objLead.CEL1_TipoDocumento__c+objLead.CEL1_NumeroDocumento__c,objLead.Id);
                    setTipo.add(objLead.CEL1_TipoDocumento__c);
                    setDocumento.add(objLead.CEL1_NumeroDocumento__c);
                }
            }
        }
		
        if (blnConverted) {
            System.debug('mapLead....'+mapLead);
            List<AccountTeamMember> lstAccount = [SELECT Id,
                                        AccountId,
                                        Account.COM_TipoIdentificacion__c,
                                        Account.COM_Numero_de_identificacion__c
                                        FROM AccountTeamMember
                                        WHERE Account.COM_TipoIdentificacion__c IN: setTipo
                                        AND Account.COM_Numero_de_identificacion__c IN: setDocumento
                                        AND TeamMemberRole = 'COM_AuxiliarAdministrativoPAF'
                                        ORDER BY CreatedDate ASC NULLS FIRST];
            System.debug('lstAccount....'+lstAccount);
            if (strMomento == 'After') {
                Map<Id,Lead> mapResult = CEL1_ClienteCuentaAcreedora_cls.asignarPropietarioCandidato(null,mapLead,true,false);
            }else {
                List<Lead> lstLeadUpdate = new List<Lead>();
                for (AccountTeamMember objCuenta : lstAccount) {
                    mapCuentaxCandidato.put(objCuenta.AccountId,mapDocumentoxIdLead.get(objCuenta.Account.COM_TipoIdentificacion__c+objCuenta.Account.COM_Numero_de_identificacion__c));
                }
                System.debug('mapCuentaxCandidato....'+mapCuentaxCandidato);
                
                for(Lead objLeadConvertido:lstNewLead){
                    if(objLeadConvertido.RecordTypeId != strRecordTypeLeadSalud && objLeadConvertido.RecordTypeId != strRecordTypeAfiliacionCaja){
                        if(objLeadConvertido.IsConverted == true){
                            // objLeadConvertido.CEL1_ConvertidoDesdeCliente__c = true;
                            if(!mapLead.isEmpty() || mapLead != null){
                                System.debug('ENTRO A METODO CONVERTIR....');
                                Map<Id,Lead> mapResult = CEL1_ClienteCuentaAcreedora_cls.asignarPropietarioCandidato(mapCuentaxCandidato,mapLead,true,false);
                                objLeadConvertido = mapResult.get(objLeadConvertido.Id);
                                // lstLeadUpdate.add(objLeadConvertido);
                            }
                        }
                    }
                }
                // System.debug('lstLeadUpdate....'+lstLeadUpdate);
                // update lstLeadUpdate;
            }
        }
    }
}