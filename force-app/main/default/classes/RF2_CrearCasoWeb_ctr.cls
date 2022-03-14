/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Controlador para la pagina del portal web para la creacion de casos

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor            Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/11/16      Juan David Uribe Ruiz   Creación Clase.
    1.1     2018/09/10      Stifen Panche Gutierrez Adicionar tipo de Programa No Afiliado.
    1.2     2019-08-21      Camilo Andrés Gamarra (CG) Se adiciona campo medio de respuesta con valores definidos en el NOLA 00265676
    1.3     2019-12-23      Steven Moque Quintero (SM) Migración Lightning - Se reemplazan Attachments por Content Documents.
************************************************************************************************/
global without sharing class RF2_CrearCasoWeb_ctr {

    public String strNegocio {get; set;}
    public String strDocumentosRequeridos {get; set;}
    public String strSelectPrograma {get; set;}
    public String strSelectTipoSolicitud {get; set;}
    public String strlabelTipoSolicitud {get; set;}
    public String strSedeSuceso {get; set;}
    public String strMedioRespuesta {get; set;}
    public static List<RF2_MatrizResponsablesCaso__c> lstMatrizResponsables = [SELECT Id, Name, RF2_GCN__c, RF2_ResponsableCaso__c, RF2_TipoSolicitud__c, RF2_ProcesoDestino__c, RF2_RelacionadoCon__c, RF2_DocumentosRequeridos__c FROM RF2_MatrizResponsablesCaso__c];
    public String strSelectCiudad {get; set;}
    public List<ArchivosWrapper> lstDocumentos {get; set;}
    public String strNombreArchivo {get; set;}
    public Integer intRow {get; set;}
    public list<String> lstIdsArchivos {get; set;}

    private final Static String WEB_PCE = 'WEB_PCE';
    private final Static String WEB_GIE = 'WEB_GIE';
    private final Static String SOLICITUD_PCE = 'Solicitud PCE';
    private final Static String SOLICITUD_GIE = 'Solicitud GIE';
    private final Static String NIT = '2';

    public RF2_CrearCasoWeb_ctr() {
        //strDocumentosRequeridos = "";
        this.strSelectPrograma = '';
        this.strSelectTipoSolicitud = '';
        this.strSedeSuceso = '';

        this.strNegocio = ApexPages.currentPage().getParameters().get('negocio');
        if(this.strNegocio == null) {
            this.strNegocio = '';
        }

        system.debug('=====>negocio: ' + this.strNegocio);

        if(this.strNegocio.equals(WEB_GIE)) {
            strlabelTipoSolicitud = 'Tipo de Programa';

            strSelectPrograma = '<select name="_Programa" onchange="" id="_Programa" class="form-control"> ';
            strSelectPrograma += '<option selected="selected" value="Seleccione">Seleccione &gt;</option>';
            strSelectPrograma += '<option value="Empresarial">Empresarial</option> ';
            strSelectPrograma += '<option value="Trabajador Dependiente">Trabajador Dependiente</option> ';
            strSelectPrograma += '<option value="Pensionado">Pensionado</option> ';
            strSelectPrograma += '<option value="Independiente">Independiente</option> ';
            /*Inicio 1.1*/
            strSelectPrograma += '<option value="No Afiliado">No Afiliado</option> ';
            /*Fin 1.1*/

            strSelectTipoSolicitud = '<select name="_TipoSolicitud" onchange="" id="_TipoSolicitud" class="form-control" style="display: none;">';
            strSelectTipoSolicitud += '</select>';
        } else if(this.strNegocio.equals(WEB_PCE)) {
            strlabelTipoSolicitud = 'Tipo';

            strSelectPrograma = '<select name="_Programa" onchange="" id="_Programa" class="form-control" style="display: none;"> ';
            strSelectPrograma += '<option selected="selected" value="URL PCE">URL PCE</option> ';
            //strSelectPrograma += '<option value="CRM_PCE">CRM PCE</option> ';

            strSelectTipoSolicitud = '<select name="_TipoSolicitud" onchange="" id="_TipoSolicitud" class="form-control">';
            strSelectTipoSolicitud += '<option selected="selected" value="Seleccione">Seleccione &gt;</option>';
            strSelectTipoSolicitud += '<option value="Queja">Queja</option> ';
            strSelectTipoSolicitud += '<option value="Reconocimiento">Reconocimiento</option> ';
            strSelectTipoSolicitud += '<option value="Sugerencia">Sugerencia</option> ';
            strSelectTipoSolicitud += '<option value="Solicitud PCE">Solicitud PCE</option> ';
            strSelectTipoSolicitud += '</select>';
        }
        strSelectPrograma += '</select>';

        strSelectCiudad = '<select name="ciudad" id="ciudad" class="form-control">';
        strSelectCiudad += '<option selected="selected" value="Seleccione">Seleccione &gt;</option>';

        //Se consulta primero Bogota para que aparezca de primero en la lista
        List<COM_Poblacion__c> lstPoblaciones = [SELECT Id, Name FROM COM_Poblacion__c WHERE COM_Codigo__c = '11001'];
        for(COM_Poblacion__c obj : lstPoblaciones)
        {
            strSelectCiudad += '<option value="'+ obj.Id + '">' + obj.Name + '</option>';
        }

        lstPoblaciones = [SELECT Id, Name FROM COM_Poblacion__c WHERE COM_Codigo__c != '11001' ORDER BY Name];
        for(COM_Poblacion__c obj : lstPoblaciones)
        {
            strSelectCiudad += '<option value="'+ obj.Id + '">' + obj.Name + '</option>';
        }

        strSelectCiudad += '</select>';


        strSedeSuceso = '<select name="sedeSuceso" onchange="" id="sedeSuceso" class="form-control"> ';
        strSedeSuceso += '<option selected="selected" value="Seleccione">Seleccione &gt;</option>';
        if(this.strNegocio.equals(WEB_PCE)) {
            Schema.DescribeFieldResult schTipo = Case.RF2_SedeSuceso__c.getDescribe();
            List<Schema.PicklistEntry> lstSchTipo = schTipo.getPicklistValues();
            for( Schema.PicklistEntry valor : lstSchTipo) {
                system.debug('>>>>>>>>>>>>>>> ' + valor.getLabel());
                strSedeSuceso += '<option value="'+valor.getValue()+'">'+valor.getLabel()+'</option>';
            }
        }
        strSedeSuceso += '</select>';

        //Inicio de la versión 1.2 CG
        list<medioRespuesta__mdt> lstmtdResp = [SELECT Id, MasterLabel FROM medioRespuesta__mdt];
        list<String> valoresRespuesta = new list<String>();
        for (medioRespuesta__mdt objmtd : lstmtdResp)
            valoresRespuesta.add(objmtd.MasterLabel);

        strMedioRespuesta = '<select name="medioRespuesta" onchange="" id="medioRespuesta" class="form-control"> ';
        strMedioRespuesta += '<option selected="selected" value="Seleccione">Seleccione &gt;</option>';
        Schema.DescribeFieldResult schTipo = Case.RF2_MedioRespuesta__c.getDescribe();
        List<Schema.PicklistEntry> lstSchTipo = schTipo.getPicklistValues();
        for( Schema.PicklistEntry valor : lstSchTipo) {
            system.debug('>>>>>>>>>>>>>>> ' + valor.getLabel());
            if(valoresRespuesta.contains(valor.getLabel()))
                strMedioRespuesta += '<option value="'+valor.getValue()+'">'+valor.getLabel()+'</option>';
        }

        strMedioRespuesta += '</select>';

        //Fin de la versión 1.2 CG



        lstDocumentos = new List<ArchivosWrapper>();
        lstIdsArchivos = new list<String>();

        strDocumentosRequeridos = '';//obtenerDocumentosCaso('Solicitud', 'Independiente', 'Aclaración y corrección de Aportes');
    }

    /**
     * [obtenerDocumentosCaso description]
     * @param  strTipo           [description]
     * @param  strProceso        [description]
     * @param  strRelacionadoCon [description]
     * @return                   [description]
     */
    @RemoteAction
    global static String obtenerDocumentosCaso(String strTipo, String strProceso, String strRelacionadoCon) {
        system.debug('----->>>>> strTipo: ' + strTipo);
        system.debug('----->>>>> strProceso: ' + strProceso);
        system.debug('----->>>>> strRelacionadoCon: ' + strRelacionadoCon);
        for(RF2_MatrizResponsablesCaso__c obj : lstMatrizResponsables)
        {
            if(obj.RF2_TipoSolicitud__c == strTipo && obj.RF2_ProcesoDestino__c == strProceso && obj.RF2_RelacionadoCon__c == strRelacionadoCon) {
                return  obj.RF2_DocumentosRequeridos__c;
            }
        }
        return '';
    }

    @RemoteAction
    global static RespuestaCrearCasoWrapper finalizar(boolean blnEsAnonimo, String strPrograma, String strRelacionadoCon, String strDescripcionSolicitud,
                            boolean blnAutorizaCorreo, boolean blnAutorizaHabeas, String strTipoIdentificacion, String strNumeroDeIdentificacion,
                            String strRazonsocial, String strTipoIdContacto, String strNumeroDeIdentificacionContacto, String strNombreContacto,
                            String strCorreoContacto, String strDireccionContacto, String strCiudad, String strTelefonoFijo, String strTelefonoMovil,
                            String strSedeSuceso, String strFechaSuceso, String strMedioRespuesta, String strNegocioAux, String strListaDocumentos, String strTipoSolicitud) {
        list<String> lstDocumentosParam;
        Date dtFechaSuceso;
        RespuestaCrearCasoWrapper objRespuestaCrearCasoWrapper = new RespuestaCrearCasoWrapper();
        system.debug(' =====>>>>>blnEsAnonimo: ' + blnEsAnonimo);
        system.debug(' =====>>>>>strPrograma: ' + strPrograma);
        system.debug(' =====>>>>>strRelacionadoCon: ' + strRelacionadoCon);
        system.debug(' =====>>>>>strDescripcionSolicitud: ' + strDescripcionSolicitud);
        system.debug(' =====>>>>>blnAutorizaCorreo: ' + blnAutorizaCorreo);
        system.debug(' =====>>>>>blnAutorizaHabeas: ' + blnAutorizaHabeas);
        system.debug(' =====>>>>>strTipoIdentificacion: ' + strTipoIdentificacion);
        system.debug(' =====>>>>>strNumeroDeIdentificacion: ' + strNumeroDeIdentificacion);
        system.debug(' =====>>>>>strRazonsocial: ' + strRazonsocial);
        system.debug(' =====>>>>>strTipoIdContacto: ' + strTipoIdContacto);
        system.debug(' =====>>>>>strNumeroDeIdentificacionContacto: ' + strNumeroDeIdentificacionContacto);
        system.debug(' =====>>>>>strNombreContacto: ' + strNombreContacto);
        system.debug(' =====>>>>>strCorreoContacto: ' + strCorreoContacto);
        system.debug(' =====>>>>>strDireccionContacto: ' + strDireccionContacto);
        system.debug(' =====>>>>>strCiudad: ' + strCiudad);
        system.debug(' =====>>>>>strTelefonoFijo: ' + strTelefonoFijo);
        system.debug(' =====>>>>>strTelefonoMovil: ' + strTelefonoMovil);
        system.debug(' =====>>>>>strSedeSuceso: ' + strSedeSuceso);
        system.debug(' =====>>>>>strFechaSuceso: ' + strFechaSuceso);
        system.debug(' =====>>>>>strNegocioAux: ' + strNegocioAux);
        system.debug(' =====>>>>>strListaDocumentos: ' + strListaDocumentos);
        system.debug(' =====>>>>>strTipoSolicitud: ' + strTipoSolicitud);
        system.debug(' =====>>>>>strMedioRespuesta: ' + strMedioRespuesta);
        //strListaDocumentos = strListaDocumentos.replaceAll('[', '[\'').replaceAll(']', '\']').replaceAll(', ', '\',\'');
        //system.debug(' =====>>>>>strListaDocumentos: ' + strListaDocumentos);
        lstDocumentosParam = (List<String>)System.JSON.deserialize(strListaDocumentos, List<String>.class);
        system.debug(' =====>>>>>lstDocumentosParam: ' + lstDocumentosParam);

        Case caso = new Case();
        caso.Status = Label.RF2_EstadoCasoAbierto;
        system.debug(' =====>>>>>prueba a ver ' + Label.RF2_EstadoCasoAbierto);
        caso.Origin = Label.RF2_OrigenCasoPaginaWeb_lbl;
        //caso.RF2_NumeroRadicadoExterno__c = dc.idCaso;
        //caso.RF2_DocumentaHandlerID__c = dc.documentHandler;
        caso.RF2_Anonimo__c = blnEsAnonimo;
        caso.RF2_FechaRecepcion__c = Date.today();
        caso.Description = strDescripcionSolicitud;
        caso.RF2_ProcesoDestinoMatrizResponsable__c  = strPrograma;
        caso.RF2_RelacionadoCon__c = strRelacionadoCon;
        caso.RF2_TipoSolicitud__c = strTipoSolicitud;
        caso.RF2_Autorizaenviorespuestaemail__c = blnAutorizaCorreo;
        caso.RF2_AutorizacionHabeasData__c = blnAutorizaHabeas;
        caso.RF2_MedioRespuesta__c = strMedioRespuesta;
        //caso.RF2_SolucionadoPrimerContacto__c = false;
        //caso.Subject = strDescripcionSolicitud;

        if(strNegocioAux.equals(WEB_PCE)) {
            caso.RF2_SedeSuceso__c = strSedeSuceso;
            try{
                dtFechaSuceso = Date.valueOf(strFechaSuceso);
                system.debug(' =====>>>>>dtFechaSuceso: ' + dtFechaSuceso);
                caso.RF2_FechaSuceso__c = dtFechaSuceso;
            } catch(Exception e) {
                system.debug('......... ERROR PARSEANDO LA FECHA DEL SUCESO');
            }
        }

        system.debug(' =====>>>>> caso.RF2_TipoSolicitud__c: ' + caso.RF2_TipoSolicitud__c);

        List<Account> lstClientes = new List<Account>();
        List<Contact> lstContactos = new List<Contact>();
        List<AccountContactRelation> lstRelacion = new List<AccountContactRelation>();

        if(blnEsAnonimo) {
            //Si es anonimo se busca el el registro del contacto anonimo y se asocia al caso
            lstContactos = [SELECT Id, AccountId FROM Contact WHERE COM_TipoIdentificacion__c = :Label.RF2_TipoIdentificacionClienteAnonimo_lbl AND COM_Numeroidentificacion__c = :Label.RF2_NumeroIdentificacionClienteAnonimo_lbl LIMIT 1];
            if(lstContactos.isEmpty()) {
                throw new RF2_CrearCasosException('No se encontró el Cliente Anónimo, consulte el administrador CRM.');
            }
            caso.AccountId = lstContactos.get(0).AccountId;
            caso.ContactId = lstContactos.get(0).Id;
        } else {
           // if(!blnEsAnonimo) {
            caso.RF2_CorreoElectronicoHuerfano__c = strCorreoContacto;
            caso.RF2_TelefonoHuerfano__c = strTelefonoFijo;
            caso.RF2_TelefonoMovilHuerfano__c = strTelefonoMovil;
            caso.RF2_CiudadHuerfano__c = strCiudad;
            caso.RF2_DireccionHuerfano__c = strDireccionContacto;
            caso.RF2_TipoIdentificacionHuerfano__c = strTipoIdentificacion;
            caso.RF2_NumeroIdentificacionHuerfano__c = strNumeroDeIdentificacion;
            if(NIT.equals(strTipoIdentificacion)) {
                caso.RF2_TipoIdentificacionContactoHuerfano__c = strTipoIdContacto;
                caso.RF2_NumeroIdentificacionContactoHuerfano__c = strNumeroDeIdentificacionContacto;
            }
            caso.RF2_NombreContactoHuerfano__c = strNombreContacto;
            caso.RF2_CompanyaHuerfano__c = strRazonsocial;
            //}

            //Si el caso no es anónimo se busca en SF
            lstClientes = [SELECT Id, Name FROM Account WHERE COM_TipoIdentificacion__c = :strTipoIdentificacion AND COM_Numero_de_identificacion__c = :strNumeroDeIdentificacion LIMIT 1];
            if(!lstClientes.isEmpty()) {
                caso.AccountId = lstClientes.get(0).Id;
                if(NIT.equals(strTipoIdentificacion)) {
                    lstRelacion = [SELECT Id, ContactId FROM AccountContactRelation
                                             WHERE AccountId = :lstClientes.get(0).Id
                                                AND Contact.COM_TipoIdentificacion__c = :strTipoIdContacto
                                                AND Contact.COM_Numeroidentificacion__c = :strNumeroDeIdentificacionContacto
                                                LIMIT 1];
                    if(!lstRelacion.isEmpty()) {
                        caso.ContactId = lstRelacion.get(0).ContactId;
                    }
                    /*else {
                        caso.RF2_CompanyaHuerfano__c = strRazonsocial;
                    }*/
                } else {
                    lstContactos = [SELECT Id FROM Contact
                                              WHERE COM_TipoIdentificacion__c = :strTipoIdentificacion
                                                AND COM_Numeroidentificacion__c = :strNumeroDeIdentificacion
                                                AND AccountId =: lstClientes.get(0).Id
                                                LIMIT 1];
                    if(!lstContactos.isEmpty()) {
                        caso.ContactId = lstContactos.get(0).Id;
                    }
                    /*else {
                        // aca deberia asignar toda la informacion de contacto huerfano
                        caso.RF2_NombreContactoHuerfano__c = strNombreContacto;
                    }*/
                }
            } else {
                system.debug('>> No se ha encontrado informacion del cliente TipoID: ' + strTipoIdentificacion + ', numID: '+strNumeroDeIdentificacion);
                /*if(NIT.equals(strTipoIdentificacion)) {
                    caso.RF2_TipoIdentificacionHuerfano__c = strTipoIdentificacion;
                    caso.RF2_NumeroIdentificacionHuerfano__c = strNumeroDeIdentificacion;
                        //
                    caso.RF2_TipoIdentificacionContactoHuerfano__c = strTipoIdContacto;
                    caso.RF2_NumeroIdentificacionContactoHuerfano__c = strNumeroDeIdentificacionContacto;
                }else{
                    caso.RF2_TipoIdentificacionHuerfano__c = strTipoIdContacto;
                    caso.RF2_NumeroIdentificacionHuerfano__c = strNumeroDeIdentificacionContacto;
                }
                caso.RF2_NombreContactoHuerfano__c = strNombreContacto;
                caso.RF2_CompanyaHuerfano__c = strRazonsocial;*/
            }
        }
        try{
            insert caso;
            //Ejecucion del trigger
            system.debug('>>>>>>>>>> idCaso: ' + caso.id);
                system.debug('>>>>>>>>>> CaseNumber: ' + caso.CaseNumber);
        } catch(Exception e) {
            system.debug('CG Error reportado = '+e);
            objRespuestaCrearCasoWrapper.strMensaje = 'Error: ' + e.getMessage();
            objRespuestaCrearCasoWrapper.blnError = true;
            return objRespuestaCrearCasoWrapper;
        }

        if(lstDocumentosParam.size() > 0) {
            system.debug('>>>>>>>>>> Se van a procesar los adjuntos ');
            try{
                list<Document> lstDocument;
                set<Id> setIdDocumentos;
                List<ContentVersion> lstContentV;
                //list<Attachment> lstAdjuntos;

                setIdDocumentos = new set<Id>();
                for(String strIdDocumento : lstDocumentosParam) {
                    setIdDocumentos.add(strIdDocumento);
                }

                lstDocument = [SELECT Id, Body, Name, Type FROM Document WHERE Id IN :setIdDocumentos];

                lstContentV = new List<ContentVersion>();
                //lstAdjuntos = new list<Attachment>();
                ContentVersion objContentVersion;
                //Attachment objAttachment;

                for(Document objDocument : lstDocument) {
                    System.debug('\n\n-=#=-   ' + 'objDocument' + ': ' + objDocument + '\n');

                    objContentVersion = new ContentVersion();
                    objContentVersion.ContentLocation   = 'S';
                    objContentVersion.VersionData       = objDocument.Body;
                    objContentVersion.Title             = label.RF2_PreNombreArchivoWeb + objDocument.Name;
                    objContentVersion.PathOnClient      = objDocument.Name;
                    System.debug('\n\n-=#=-   ' + 'objContentVersion' + ': ' + objContentVersion + '\n');

                    /*objAttachment = new Attachment();
                    objAttachment.Body = objDocument.Body;
                    objAttachment.Name = label.RF2_PreNombreArchivoWeb + objDocument.Name;
                    objAttachment.ParentId = caso.Id;
                    lstAdjuntos.add(objAttachment);*/
                    lstContentV.add(objContentVersion);
                }
                // System.debug('\n\n-=#=-   ' + 'lstContentV' + ': ' + lstContentV + '\n');

                //if(!lstAdjuntos.isEmpty()) {
                if(!lstContentV.isEmpty()) {
                    insert lstContentV;
                    System.debug('Content version creados...');

                    List<ContentDocumentLink> lstContentDocumentLinkToInsert = new List<ContentDocumentLink>();
                    for (ContentVersion objContentVersionQuey : [   SELECT  Id,
                                                                            ContentDocumentId
                                                                    FROM    ContentVersion
                                                                    WHERE   Id IN: lstContentV]) {
                        lstContentDocumentLinkToInsert.add(new ContentDocumentLink( ContentDocumentId   = objContentVersionQuey.ContentDocumentId,
                                                                                    LinkedEntityId      = caso.Id,
                                                                                    ShareType           = 'I'));
                    }
                    insert lstContentDocumentLinkToInsert;
                    System.debug('Content document links creados...');

                    // insert lstAdjuntos;
                    // system.debug('Attachment creados...');

                    delete lstDocument;
                    system.debug('Documentos eliminados...');
                }
            }  catch(Exception e) {
                System.Debug('================= EXCEPCION GUARDANDO ATTACHMENTS =================');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                System.Debug('===================================================================');
                Case objCasoAux = [SELECT Id, CaseNumber FROM Case WHERE Id = :caso.id];
                objRespuestaCrearCasoWrapper.strMensaje = 'El caso se creó exitosamente, pero los archivos adjuntos no se puedieron guardar, Nro Caso: ' + objCasoAux.CaseNumber;
                objRespuestaCrearCasoWrapper.IdCaso = objCasoAux.Id;
                objRespuestaCrearCasoWrapper.blnError = false;
                return objRespuestaCrearCasoWrapper;
            }
        }


        Case objCasoAux = [SELECT Id, CaseNumber, RF2_FechaVencimientoCaso__c FROM Case WHERE Id = :caso.id];

        objRespuestaCrearCasoWrapper.strMensaje = label.RF2_MensajeCasoExito.replace('<<NroCaso>>', objCasoAux.CaseNumber);
        objRespuestaCrearCasoWrapper.IdCaso = objCasoAux.Id;
        objRespuestaCrearCasoWrapper.blnError = false;
        return objRespuestaCrearCasoWrapper;

        /*String strMensajeRta = label.RF2_MensajeCasoExito.replace('<<NroCaso>>', objCasoAux.CaseNumber);
        if(objCasoAux.RF2_FechaVencimientoCaso__c != null) {
            strMensajeRta = strMensajeRta.replace('<<fechaCierre>>', 'la fecha máxima para atender el caso es ' + objCasoAux.RF2_FechaVencimientoCaso__c);
        } else{
            strMensajeRta = strMensajeRta.replace('<<fechaCierre>>', 'Su caso será atendido con la mayor brevedad. ' + objCasoAux.RF2_FechaVencimientoCaso__c);
        }*/
        system.debug('>>>>>>>>>>>>>> objRespuestaCrearCasoWrapper: ' + objRespuestaCrearCasoWrapper);
        return objRespuestaCrearCasoWrapper;
    }

    @RemoteAction
    global static String consultarCaso(String idCaso) {
        Case objCasoAux;
        objCasoAux = [SELECT CaseNumber, RF2_FechaVencimientoCaso__c FROM Case WHERE Id = :idCaso];

        if(objCasoAux.RF2_FechaVencimientoCaso__c == null) {
            COM_Utilidades_cls.threadSleep(5000);
        }

        objCasoAux = [SELECT CaseNumber, RF2_FechaVencimientoCaso__c FROM Case WHERE Id = :idCaso];
        system.debug('+++++++++++++++ objCasoAux: ' + objCasoAux);
        String strMensaje = label.RF2_MensajeCasoExito.replace('<<NroCaso>>', objCasoAux.CaseNumber);
        if(objCasoAux.RF2_FechaVencimientoCaso__c != null) {
            strMensaje = strMensaje.replace('<<fechaCierre>>', 'la fecha máxima para atender el caso es ' + objCasoAux.RF2_FechaVencimientoCaso__c.format('yyyy-MM-dd'));
        } else{
            strMensaje = strMensaje.replace('<<fechaCierre>>', 'su caso será atendido en la mayor brevedad.');
        }

        return strMensaje;
    }

    public Document document {
        get {
            if (document == null)
                document = new Document();
            return document;
        }
        set;
    }

    public void cargarArchivo() {
        ArchivosWrapper objArchivosWrapper;
        this.document.AuthorId = UserInfo.getUserId();
        this.document.FolderId = label.RF2_IdCarpetaArchivosCasos_lbl;
        //document.FolderId = UserInfo.getUserId(); // put it in running user's folder 00l1I000000qPgw
        this.document.name = strNombreArchivo;
        this.document.description = strNombreArchivo;
        this.document.keywords = strNombreArchivo;
        system.debug('===== strNombreArchivo : ' + strNombreArchivo );

        //if(this.document.Body.size()>5242880) {
        if(String.isBlank(this.strNombreArchivo)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Por favor seleccione un archivo para subir.'));
            return;
        }

        try {
            insert this.document;
            objArchivosWrapper = new ArchivosWrapper();
            objArchivosWrapper.intIndex = this.lstDocumentos.size() + 1;
            objArchivosWrapper.strIdDocumento = document.Id;
            objArchivosWrapper.strNombreDocumento = strNombreArchivo;
            this.lstDocumentos.add(objArchivosWrapper);
            lstIdsArchivos.add('"' + objArchivosWrapper.strIdDocumento + '"');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error cargando el archivo, por favor intente nuevamente'));
            return;
        }
        this.document = new Document();
        strNombreArchivo = '';
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Archivo cargado con éxito.'));
        return;
    }

    public void eliminarDocumento() {
        Integer intContador;
        list<Document> lstDocumentEliminar;
        Id idDocument;

        if(this.lstDocumentos.size() <= 0) {
            system.debug('>>>>>>>>> NO HIZO NADA: ' + this.lstDocumentos.size());
            return;
        }

        system.debug('>>>>>>>>> intRow: ' + this.intRow);
        intContador = 0;
        idDocument = null;
        for(ArchivosWrapper objArchivosWrapper : this.lstDocumentos) {
            system.debug('>>>>>>>>> intIndex: ' + objArchivosWrapper.intIndex);
            if(objArchivosWrapper.intIndex == this.intRow) {
                system.debug('>>>>>>>>> Va a remover lista');
                idDocument = this.lstDocumentos.get(intContador).strIdDocumento;
                this.lstDocumentos.remove(intContador);
                break;
            }
            intContador++;
        }

        lstIdsArchivos = new list<String>();
        intContador = 1;
        for(ArchivosWrapper objArchivosWrapper : this.lstDocumentos) {
            objArchivosWrapper.intIndex = intContador;
            lstIdsArchivos.add('"' + objArchivosWrapper.strIdDocumento + '"');
            intContador++;
        }

        if(idDocument != null) {
            lstDocumentEliminar = [SELECT Id FROM Document WHERE Id = :idDocument];
            if(!lstDocumentEliminar.isEmpty()) {
                system.debug('::::::::: Va a eliminar: ' + lstDocumentEliminar);
                delete lstDocumentEliminar;
            }
        }
    }

    public void eliminarTodosDocumento() {
        Integer intContador;
        list<Document> lstDocumentEliminar;
        set<Id> setIdDocumentos;
        Id idDocument;

        if(this.lstDocumentos.size() <= 0) {
            system.debug('>>>>>>>>> NO HIZO NADA: ' + this.lstDocumentos.size());
            return;
        }

        setIdDocumentos = new set<Id>();
        for(ArchivosWrapper objArchivosWrapper : this.lstDocumentos) {
            setIdDocumentos.add(objArchivosWrapper.strIdDocumento);
        }

        this.lstDocumentos.clear();


        if(!setIdDocumentos.isEmpty()) {
            lstDocumentEliminar = [SELECT Id FROM Document WHERE Id IN :setIdDocumentos];
            if(!lstDocumentEliminar.isEmpty()) {
                system.debug('::::::::: Va a eliminar: ' + lstDocumentEliminar);
                delete lstDocumentEliminar;
            } else{
                system.debug('::::::::: NO SE VA A ELIMINAR NINGUN DOCUMENTO : ' + setIdDocumentos);
            }
        }
    }

    public class ArchivosWrapper{
        public Integer intIndex {get; set;}
        public String strIdDocumento {get; set;}
        public String strNombreDocumento {get; set;}
    }

    global class RespuestaCrearCasoWrapper{
        global String strMensaje {get; set;}
        global String idCaso {get; set;}
        global boolean blnError {get; set;}
    }


}