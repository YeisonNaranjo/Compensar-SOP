/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase de prueba de la clase CEL1_LeadHelper_cls

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     31/10/19         Manuel Mendez (MM)      Creación Clase.
    1.1     07/11/19         Paula Bohórquez (PB)    Se añaden métodos de prueba para consulta GC
                                                     y actualización de clientes y prospectos.
	1.2     14/02/2020       Andrea Tellez           Se añade el método enviarCorreosCuentaAcreedoraFuturo
													 para validar el tipo de plantilla a enviar en los correos
													 de la creción de las cuentas acreedoras.
************************************************************************************************/
@isTest
public class CEL1_LeadHelper_tst {
    
   private class GCMockOK implements HttpCalloutMock {
    
        public HTTPResponse respond (HttpRequest objRequest) {
                HttpResponse objResponse = new HttpResponse();
                objResponse.setHeader('Content-Type', 'application/json');
                objResponse.setStatusCode(200);
                objResponse.setBody('{"CustomerMng_ConsultaCliente_Response" : {"Header" : {"RequestDate" : "2019-11-07T10:57:31.45-05:00","ResponseDate" : "2019-11-07T10:57:32.056-05:00","ResponseCode" : "0","ResponseDesc" : "OK","TransactionID" : "12620191107105730977801"},"Body" : {"Vinculacion" : {"AfiliadoCaja" : "false","AfiliacionConResponsable" : "false","AfiliadoSalud" : "false","AfiliadoPLC" : "false"},"Cliente" : {"TipoIdentificacion" : "1","NumeroIdentificacion" : "80159169","Id" : "9999805063666366","datosPersona" : {"nombrePrimero" : "JOHN","nombreSegundo" : "JAIRO","apellidoPrimero" : "GONZALEZ","apellidoSegundo" : "RODRIGUEZ","nombre" : "JOHN JAIRO GONZALEZ RODRIGUEZ","foneticoID" : "19820408JONSALESROJON","nuip" : null,"Familia" : null,"demografia" : {"nacimientoFecha" : "1982-04-08T00:00:00","nacimientoLugar" : null,"genero" : "M","estadoCivil" : "SO","gradoEscolaridad" : null,"TitulosObtenidos" : null,"OficiosProfesiones" : null,"OtrosEstudios" : null},"categoriaAfiliacion" : null,"estadoAfiliacion" : "A","motivoInactivacion" : {"id" : "0"}},"Sucursal" : { "sucursal" :[{"id" : null,"sucursalID" : "0","nivelAdicional" : "N","razonSocial" : null,"mantenimiento" : null}] },"comunicacionesCliente" : { "comunicacionCliente" :[{"telefonos" : { "telefonoComunicacion" :[{"tipoTelefono" : "1","telefono" : "2631598","extensionTelefono" : "0"}] },"domicilios" : { "domicilioComunicacion" :[{"barrio" : "SANTA CECILIA","tipoDomicilio" : null,"domicilio" : "CL 24 C # 80 C - 23","codigoPostal" : "-","localidad" : {"id" : "11001","municipio" : {"id" : "-1","nombre" : null,"departamento" : {"id" : "-"}},"nombre" : "BOGOTA D.C."},"tipoAreaGeografica" : "U"}] },"correosElectronicos" : null,"celulares" : null,"redesSociales" : null,"adicionalesContacto" : {"borradoEstado" : "A","creacionFecha" : "2014-03-21T00:00:00","ultimaNovedadFecha" : "2014-03-21T00:00:00","identificador" : "3166870","orden" : "1","zonaBogota" : "9"}}] },"Contacto" : null,"Afiliacion" : { "afiliacion" :[{"beneficiarios" : null,"cantidadVinculacion" : "240","categoriaAfiliacion" : "C","motivoRetiro" : {"id" : "20","nombre" : "-"},"ClienteResponsable" : { "clienteResponsable" :[{"tipoResponsable" : "1","id" : "9999805063666366","nombre" : "JOHN JAIRO GONZALEZ RODRIGUEZ","legalID" : "80159169","tipoIdentificacion" : "1"},{"tipoResponsable" : "2","id" : "9999803423044935","nombre" : " NASES EST EMPRESA DE SERVICIOS TEMPORALES SAS  ","legalID" : "830009600","tipoIdentificacion" : "2"},{"tipoResponsable" : "3","centroCostosID" : "0","sucursalID" : "1","id" : "9999803423568622","nombre" : "EMPRESAS NASES","legalID" : "830009600","tipoIdentificacion" : "2"},{"tipoResponsable" : "4","centroCostosID" : "3400","sucursalID" : "1","id" : "6238908352428071","nombre" : "TEXMODA S.A","legalID" : "830009600","tipoIdentificacion" : "2"}] },"cmnt" : "H","actualizadoEstado" : "false","nuevoEstado" : "false","estado" : "1","finFecha" : "2013-09-22T00:00:00","ingresoEmpresaFecha" : "2012-12-03T00:00:00","inicioFecha" : "2012-12-03T00:00:00","retiroFecha" : "2013-09-22T00:00:00","soloServicio" : "0","textoVinculacion" : "PROFESIONAL","valorVinculacion" : "2869160","variableRetiro" : "CRETRDP","Programa" : { "programa" :[{"condicion" : "2","diasPaHisto" : "0","tipoRadicacion" : "0","edadReAuto" : "0","genNuevoRadicadoEstado" : "false","grupo" : "0","id" : "1021","programaPadre" : "1011","indicadorProgramaEstado" : "0","indicadorVinculacionEstado" : "0","manejaResponsable1PersonaEstado" : "false","manejaResponsable2EmpresaEstado" : "false","motivoRetiroOpcional" : {"id" : "20","nombre" : "Desvinculación laboral"},"clientePropietarioID" : "0","tipoParentesco" : "TD","sigla" : "CJ","tipoIdClientePropietario" : "0","nombrePrograma" : "Trabajador Dependiente","nombreProgramaPadre" : null,"diasParaReactivacion" : "0"}] },"id" : "11176851","motivoInactivacion" : {"id" : "0"},"estadoAfiliacion" : "1","clienteID" : "9999805063666366"},{"beneficiarios" : null,"cantidadVinculacion" : "240","categoriaAfiliacion" : "C","motivoRetiro" : {"id" : "20","nombre" : "-"},"ClienteResponsable" : { "clienteResponsable" :[{"tipoResponsable" : "1","id" : "9999805063666366","nombre" : "JOHN JAIRO GONZALEZ RODRIGUEZ","legalID" : "80159169","tipoIdentificacion" : "1"},{"tipoResponsable" : "2","id" : "9999803423044935","nombre" : " NASES EST EMPRESA DE SERVICIOS TEMPORALES SAS  ","legalID" : "830009600","tipoIdentificacion" : "2"},{"tipoResponsable" : "3","centroCostosID" : "0","sucursalID" : "1","id" : "9999803423568622","nombre" : "EMPRESAS NASES","legalID" : "830009600","tipoIdentificacion" : "2"},{"tipoResponsable" : "4","centroCostosID" : "1","sucursalID" : "1","id" : "9999803423623371","nombre" : "SIN UBICACION","legalID" : "830009600","tipoIdentificacion" : "2"}] },"cmnt" : "H","actualizadoEstado" : "false","nuevoEstado" : "false","estado" : "1","finFecha" : "2013-12-01T00:00:00","ingresoEmpresaFecha" : "2013-10-15T00:00:00","inicioFecha" : "2013-10-15T00:00:00","retiroFecha" : "2013-12-01T00:00:00","soloServicio" : "0","textoVinculacion" : "PROFESIONAL II","valorVinculacion" : "2869160","variableRetiro" : "CRETRDP","Programa" : { "programa" :[{"condicion" : "2","diasPaHisto" : "0","tipoRadicacion" : "0","edadReAuto" : "0","genNuevoRadicadoEstado" : "false","grupo" : "0","id" : "1021","programaPadre" : "1011","indicadorProgramaEstado" : "0","indicadorVinculacionEstado" : "0","manejaResponsable1PersonaEstado" : "false","manejaResponsable2EmpresaEstado" : "false","motivoRetiroOpcional" : {"id" : "20","nombre" : "Desvinculación laboral"},"clientePropietarioID" : "0","tipoParentesco" : "TD","sigla" : "CJ","tipoIdClientePropietario" : "0","nombrePrograma" : "Trabajador Dependiente","nombreProgramaPadre" : null,"diasParaReactivacion" : "0"}] },"id" : "12423613","motivoInactivacion" : {"id" : "0"},"estadoAfiliacion" : "1","clienteID" : "9999805063666366"},{"beneficiarios" : null,"cantidadVinculacion" : "240","categoriaAfiliacion" : "C","motivoRetiro" : {"id" : "20","nombre" : "-"},"ClienteResponsable" : { "clienteResponsable" :[{"tipoResponsable" : "1","id" : "9999805063666366","nombre" : "JOHN JAIRO GONZALEZ RODRIGUEZ","legalID" : "80159169","tipoIdentificacion" : "1"},{"tipoResponsable" : "2","id" : "9999803423392818","nombre" : " ACTIVOS SAS  ","legalID" : "860090915","tipoIdentificacion" : "2"},{"tipoResponsable" : "3","centroCostosID" : "0","sucursalID" : "1","id" : "9999803423597103","nombre" : "ACTIVOS EMPRESA","legalID" : "860090915","tipoIdentificacion" : "2"},{"tipoResponsable" : "4","centroCostosID" : "1599","sucursalID" : "1","id" : "9999805064334569","nombre" : "UAE DIRECCION NACIONAL DE ESTUPEFACIENTES","legalID" : "860090915","tipoIdentificacion" : "2"}] },"cmnt" : "H","actualizadoEstado" : "false","nuevoEstado" : "false","estado" : "1","finFecha" : "2014-08-29T00:00:00","ingresoEmpresaFecha" : "2013-12-02T00:00:00","inicioFecha" : "2014-03-01T00:00:00","retiroFecha" : "2014-08-29T00:00:00","soloServicio" : "0","textoVinculacion" : "PROFESIONAL II","valorVinculacion" : "2955235","variableRetiro" : "CRETRDP","Programa" : { "programa" :[{"condicion" : "2","diasPaHisto" : "0","tipoRadicacion" : "0","edadReAuto" : "0","genNuevoRadicadoEstado" : "false","grupo" : "0","id" : "1021","programaPadre" : "1011","indicadorProgramaEstado" : "0","indicadorVinculacionEstado" : "0","manejaResponsable1PersonaEstado" : "false","manejaResponsable2EmpresaEstado" : "false","motivoRetiroOpcional" : {"id" : "20","nombre" : "Desvinculación laboral"},"clientePropietarioID" : "0","tipoParentesco" : "TD","sigla" : "CJ","tipoIdClientePropietario" : "0","nombrePrograma" : "Trabajador Dependiente","nombreProgramaPadre" : null,"diasParaReactivacion" : "0"}] },"id" : "13134696","motivoInactivacion" : {"id" : "0"},"estadoAfiliacion" : "1","clienteID" : "9999805063666366"}] },"Radicacion" : null},"atributosComunes" : {"fidelizacionFecha" : "2017-09-08T00:00:00","beneficiarioEstado" : "false","empresaEstado" : "false","saltarFoneticoEstado" : "false","indice" : "0","edadMayor" : "false"}}}}');           
                return objResponse;
        }
    }
  
    private class GCMockOKNoExiste implements HttpCalloutMock {
        
        public HTTPResponse respond (HttpRequest objRequest) {
                HttpResponse objResponse = new HttpResponse();
                objResponse.setHeader('Content-Type', 'application/json');
                objResponse.setStatusCode(200);
                objResponse.setBody('{"CustomerMng_ConsultaCliente_Response" : {"Header" : {"RequestDate" : "2019-11-07T11:12:03.074-05:00","ResponseDate" : "2019-11-07T11:12:03.293-05:00","ResponseCode" : "1","ResponseDesc" : "El cliente persona no existe","TransactionID" : "12620191107111202624101"},"Body" : {"Vinculacion" : {"AfiliadoCaja" : "false","AfiliacionConResponsable" : "false","AfiliadoSalud" : "false","AfiliadoPLC" : "false"},"Cliente" : {"TipoIdentificacion" : "-1","NumeroIdentificacion" : "-1","Id" : "-1","datosPersona" : {"nombrePrimero" : "-","nombreSegundo" : null,"apellidoPrimero" : "-","apellidoSegundo" : null,"nombre" : null,"foneticoID" : null,"nuip" : null,"Familia" : null,"demografia" : {"nacimientoLugar" : null,"genero" : null,"estadoCivil" : null,"gradoEscolaridad" : null,"TitulosObtenidos" : null,"OficiosProfesiones" : null,"OtrosEstudios" : null},"categoriaAfiliacion" : null,"estadoAfiliacion" : null},"Sucursal" : { "sucursal" :[{"id" : null,"nivelAdicional" : null,"razonSocial" : null,"mantenimiento" : null}] },"comunicacionesCliente" : { "comunicacionCliente" :[{"correosElectronicos" : null,"celulares" : null}] },"Contacto" : null,"Afiliacion" : null,"Radicacion" : null},"atributosComunes" : null}}}');           
                return objResponse;
        }
    }
    

    private class GCMockError implements HttpCalloutMock {
        
        public HTTPResponse respond (HttpRequest objRequest) {
                HttpResponse objResponse = new HttpResponse();
                objResponse.setHeader('Content-Type', 'application/json');
                objResponse.setStatusCode(503);
                objResponse.setBody('');           
                return objResponse;
        }
    }


  @istest
    public static void validarCuentas_tst(){
        string idRecordType = [select id, name from RecordType where DeveloperName ='CEL1_ProspectoCuentaAcreedoraPN' limit 1].id;
        Account objCuenta = COM_DataGenerator_cls.crearCuenta3(false);
        objCuenta.COM_TipoIdentificacion__c = '1';
        objCuenta.COM_Tiponumeroidentificacion__c = '18800990077';
        objCuenta.COM_Estadoafiliacion__c = Label.CEL1_EstadoAfiliacionCliente;
        objCuenta.CEL1_LineaNegocio__c = 'Afiliación Corporativa';
        insert objCuenta;

        Account temp = [SELECT COM_TipoIdentificacion__c, COM_Tiponumeroidentificacion__c,COM_Estadoafiliacion__c FROM Account WHERE Id =: objCuenta.Id];
        System.debug('****** CUENTA DEL INICIO :'+temp);

        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '8800990077';
        objCandidato.Email                      =   'prueba@prueba.com';
		objCandidato.RecordTypeId				=	idRecordType;

        Test.startTest();
            try {
                insert objCandidato;
			} catch (Exception e) {
				System.assert(e.getMessage().contains(label.CEL1_ErrorCandidatosMasivos));			
			}
        Test.stopTest();
    }

    @istest
    public static void actualizarTipoCuentaWSNE_tst(){
        GCMockOKNoExiste objGCMockOKNoExiste = new GCMockOKNoExiste();
        Test.setMock(HttpCalloutMock.class, objGCMockOKNoExiste);
		string idRecordType = [select id, name from RecordType where DeveloperName ='CEL1_ProspectoCuentaAcreedoraPN' limit 1].id;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '880099067';
        objCandidato.Email                      =   'prueba@prueba.com';
		objCandidato.RecordTypeId				= 	idRecordType;
        
        Test.startTest();
            try {
                insert objCandidato;
			} catch (Exception e) {
                System.debug('--->>ERROR AL INSERTAR CANDIDATO : '+e.getMessage());
			}
        Test.stopTest();

        objCandidato.Status = 'EnGestion';
        update objCandidato;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Convertido');

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        System.assertEquals(true, lcr.isSuccess());
    } 

    @istest
    public static void actualizarTipoCuentaPNWSOK_tst(){
        GCMockOK objGCMockOK = new GCMockOK();
        Test.setMock(HttpCalloutMock.class, objGCMockOK);
		string idRecordType = [select id, name from RecordType where DeveloperName ='CEL1_ProspectoCuentaAcreedoraPN' limit 1].id;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '80159169';
        objCandidato.Email                      =   'prueba@prueba.com';
		objCandidato.RecordTypeId				=	idRecordType;
        Test.startTest();
            try {
                insert objCandidato;
			} catch (Exception e) {
                System.debug('--->>ERROR AL INSERTAR CANDIDATO : '+e.getMessage());
			}

        objCandidato.Status = 'EnGestion';
        update objCandidato;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Convertido');

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        Test.stopTest();
        Lead objLead2 = [SELECT ConvertedContactId FROM Lead WHERE Id =: objCandidato.Id];
        AccountContactRelation objACR = [SELECT Roles FROM AccountContactRelation WHERE ContactId =: objLead2.ConvertedContactId LIMIT 1];
       // System.assertEquals('Representante Legal', objACR.Roles);
    }

    @istest
    public static void actualizarTipoCuentaPJWSOK_tst(){
        GCMockOK objGCMockOK = new GCMockOK();
        Test.setMock(HttpCalloutMock.class, objGCMockOK);
		
        string idRecordType = [select id, name from RecordType where DeveloperName ='CEL1_ProspectosCuentaAcreedoraPJ' limit 1].id;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPJ';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '80159169';
        objCandidato.Email                      =   'prueba@prueba.com';
		objCandidato.RecordTypeId				=	idRecordType;
        Test.startTest();
            try {
                insert objCandidato;
			} catch (Exception e) {
                System.debug('--->>ERROR AL INSERTAR CANDIDATO : '+e.getMessage());
			}

        objCandidato.Status = 'EnGestion';
        update objCandidato;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Convertido');

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        Test.stopTest();
        
    }

     @istest

    public static void actualizarTipoCuentaOtro_tst(){
        string idRecordType = [select id, name from RecordType where DeveloperName ='CEL1_ProspectoCuentaAcreedoraPN' limit 1].id;
        
        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   '';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '880099067';
        objCandidato.Email                      =   'prueba@prueba.com';
        objCandidato.RecordTypeId				= 	idRecordType;

        Test.startTest();
            try {
                insert objCandidato;
			} catch (Exception e) {
                System.debug('--->>ERROR AL INSERTAR CANDIDATO : '+e.getMessage());
			}

        objCandidato.Status = 'EnGestion';
        update objCandidato;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Convertido');

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        Test.stopTest();
        
    }



@istest

    public static void enviarCorreosCuentaAcreedoraFuturo_tst(){
       	List<Lead> LstLead = new List <Lead>();
        string idRecordTypePN = [select id, name from RecordType where DeveloperName ='CEL1_ProspectoCuentaAcreedoraPN' limit 1].id;
        string idRecordTypePJ = [select id, name from RecordType where DeveloperName ='CEL1_ProspectosCuentaAcreedoraPJ' limit 1].id;
        
        Lead objCandidato1                       =   new Lead();
        objCandidato1.FirstName                  =   'Prueba';
        objCandidato1.MiddleName                 =   'Test';
        objCandidato1.LastName                   =   'Compensar';
        objCandidato1.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato1.CEL1_TipoDocumento__c      = 	 '1';
        objCandidato1.CEL1_NumeroDocumento__c    = 	 '8800990077';
        objCandidato1.CEL1_TipoAportante__c		 = 	 'Independiente no afiliado';
        objCandidato1.Email						 = 	 'andrea@test.com';
        objCandidato1.RecordTypeId				=	idRecordTypePN;
        LstLead.add(objCandidato1); 
        
        Lead objCandidato2	                     =   new Lead();
        objCandidato2.FirstName                  =   'Prueba';
        objCandidato2.MiddleName                 =   'Test';
        objCandidato2.LastName                   =   'Compensar';
        objCandidato2.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato2.CEL1_TipoDocumento__c      = 	 '1';
        objCandidato2.CEL1_NumeroDocumento__c    = 	 '8800990077';
        objCandidato2.CEL1_TipoAportante__c		 = 	 'Empleador de servicio doméstico no afiliado';
        objCandidato2.Email						 = 	 'andrea@test.com';
        objCandidato1.RecordTypeId				=	idRecordTypePN;
        LstLead.add(objCandidato2); 
        
        Lead objCandidato3                       =   new Lead();
        objCandidato3.FirstName                  =   'Prueba';
        objCandidato3.MiddleName                 =   'Test';
        objCandidato3.LastName                   =   'Compensar';
        objCandidato3.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato3.CEL1_TipoDocumento__c      = 	 '1';
        objCandidato3.CEL1_NumeroDocumento__c    = 	 '8800990077';
        objCandidato3.CEL1_TipoAportante__c		 = 	 'Empresa no afiliada';
        objCandidato3.Email						 = 	 'andrea@test.com';
        objCandidato1.RecordTypeId				=	idRecordTypePN;
        LstLead.add(objCandidato3); 
        
        Test.startTest();
       	insert LstLead;
        
         
        Test.stopTest();
        
    }

/*@istest 
    
    public static void  actualizarRolContactoNatural_tst(){
       	List<Contact> ContactoNuevo = new List<Contact>();
        Contact contact1 = new contact();
        contact1.FirstName  = 'Prueba';
       
        
        Test.startTest();
       	insert ContactoNuevo;
        
         
        Test.stopTest();
    }

@istest
	
   public static void  validarCuentaLlena_tst(){
        
        List<Account> lstCuentas = new List<Account>();
        
        Account accountLlena = new Account();
        accountLlena.COM_TipoIdentificacion__c ='1';
        accountLlena.COM_Numero_de_identificacion__c='2222222';
        accountLlena.COM_Estadoafiliacion__c= '1';
       	accountLlena.FirstName                  =   'Prueba';
        accountLlena.MiddleName                 =   'Test';
        accountLlena.LastName                   =   'Compensar';
       
        lstCuentas.add(accountLlena);
        
        List<Lead> LstLead = new List <Lead>();
        Lead objCandidato1       =   new Lead();
        objCandidato1.CEL1_TipoDocumento__c    =   '1';
        objCandidato1.CEL1_NumeroDocumento__c  =   '222222';
        objCandidato1.FirstName                =   'Prueba';
        objCandidato1.MiddleName               =   'Test';
        objCandidato1.LastName                 =   'Compensar';
        objCandidato1.email    				   =  'test@tes.com';
        
        
       	LstLead.add(objCandidato1);
        
        Test.startTest();
        insert LstLead;
        insert lstCuentas;
        Test.stopTest();
       
        
        Test.startTest();
      
        update LstLead;
        Test.stopTest();
        
    }  
    
     @istest
	  public static void actualizarTipoCuentaPNWSOKFOR_tst(){
        List<Account> lstCuentas = new List<Account>();
        
        Account accountLlena = new Account();
        accountLlena.COM_TipoIdentificacion__c ='1';
        accountLlena.COM_Numero_de_identificacion__c='880099067';
        accountLlena.COM_Estadoafiliacion__c= '1';
       
        lstCuentas.add(accountLlena);

        Lead objCandidato                       =   new Lead();
        objCandidato.FirstName                  =   'Prueba';
        objCandidato.MiddleName                 =   'Test';
        objCandidato.LastName                   =   'Compensar';
        objCandidato.CEL1_TipoCandidato__c      =   'CEL1_ProspectoCuentaAcreedoraPN';
        objCandidato.CEL1_TipoDocumento__c      =   '1';
        objCandidato.CEL1_NumeroDocumento__c    =   '880099067';
        objCandidato.Email                      =   'prueba@prueba.com';
            

        Test.startTest();
            try {
                insert lstCuentas;
                insert objCandidato;
			} catch (Exception e) {
                System.debug('--->>ERROR AL INSERTAR CANDIDATO : '+e.getMessage());
			}

       // objCandidato.Status = 'EnGestion';
        update lstCuentas;

        /*Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objCandidato.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Convertido');

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.debug('--->>>SE CONVIRTIÓ EL CANDIDATO : '+lcr.isSuccess());
        Test.stopTest();
        Lead objLead2 = [SELECT Id FROM Lead WHERE Id =: objCandidato.Id];
       
    }
    */
    
    
}