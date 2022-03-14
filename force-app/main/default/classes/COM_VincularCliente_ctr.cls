/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         CRM Rhino
* Descripción:      Clase con la logica para el procesamiento de las solicitudes de Vinculación de Clientes en GC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    16/08/2017      Juan David Uribe Ruiz               Creación de la clase
* @version   1.1    18/02/2020      Paula Bohórquez Alfonso             Se crea validación que evita que un cliente
																		sea mandado a vinculación si no tiene el campo
																		'Línea de negocio' con al menos un valor.
****************************************************************************************************************/
public with sharing class COM_VincularCliente_ctr {

    public Opportunity objOportunidad {get; set;}
    public Account objCuenta  {get; set;}
    public String strNombreCliente {get; set;}
    public String strPrograma {get; set;}
    public boolean blnBotonGuardar {get; set;}
    public String strMensaje {get; set;}
    public boolean blnMensaje {get; set;}

    public COM_VincularCliente_ctr(Apexpages.Standardcontroller objStandardController){
        list<Opportunity> lstOportunidad;
        list<Account> lstCuenta;
        list<Contact> lstRepresentanteLegal;
        Account objCuenta; 
        blnMensaje = false;
        this.objOportunidad = (Opportunity) objStandardController.getRecord();

        this.blnBotonGuardar = true;

        if(this.objOportunidad == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No hay oportunidad a vincular.'));
        }

        lstOportunidad = [SELECT Id, AccountId, COM_FechaIngresoEmpresa__c, 
        LastModifiedDate, CreatedDate, COM_TotalHijosDerechoSubsidio__c, COM_Opcionvinculacion__c, 
        COM_ProgramaVinculacion1__c, COM_ProgramaVinculacion1__r.Name, 
        COM_EntidadContratista__r.COM_NAUTCLI__c, COM_EntidadContratista__r.COM_TipoIdentificacion__c, COM_EntidadContratista__r.COM_Numero_de_identificacion__c,
        COM_EntidadPensionadora1__r.COM_NAUTCLI__c,  COM_EntidadPensionadora1__r.COM_TipoIdentificacion__c, COM_EntidadPensionadora1__r.COM_Numero_de_identificacion__c,
        RecordType.DeveloperName
        FROM Opportunity 
        WHERE Id = :this.objOportunidad.Id];
        
        if(lstOportunidad.isEmpty()){
            //Levantar excepcion indicando que no se encontro la oportunidad
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No se encontro la oportunidad solicitada.'));
            this.blnBotonGuardar = false;
            }else{
                
                lstCuenta = [SELECT Id, Name, COM_Otrosnombres__c, COM_Primerapellido__c, COM_Segundoapellido__c, COM_Nombre_completo_del_cliente__c, 
                COM_FechaNacimiento__c, COM_Genero__c, COM_Estado_civil__c, COM_Profesion__c, COM_Categoria__c, 
                COM_Estadoafiliacion__c, COM_Digitoverificacion__c, Type, COM_NombreComercial__c, COM_Fechaconstitucion__c, 
                COM_ActividadEconomicaCIIU__c, COM_SectorEconomico__c, Parent.Name, COM_Sucursal__c, COM_CentroCosto__c, 
                COM_Negociacionadicional__c, Phone, COM_Extension__c, COM_Barrio__c, COM_Aceptaenviocorreoelectronico__c,
                COM_Tipodireccion__c, COM_Direccion__c, COM_Localidad__c, COM_Ciudad__r.COM_Codigo__c, COM_Ciudad__r.Name, 
                COM_Ciudad__r.COM_Departamento__c, COM_CorreoElectronico__c, COM_UsuarioFacebook__c, COM_UsuarioTwitter__c, 
                RecordTypeId, RecordType.DeveloperName, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, COM_NAUTCLI__c,
                COM_Primernombre__c, COM_TipoCliente__c,    COM_Movil__c, COM_Segmento__c,CEL1_LineaNegocio__c
                FROM Account 
                WHERE Id = :lstOportunidad.get(0).AccountId];
                
                if(lstCuenta.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No se encontro la cuenta asociada a la oportunidad.'));
                    this.blnBotonGuardar = false;
                    }else{
                        if(
                            (
                                lstOportunidad.get(0).RecordType.DeveloperName == 'COM_Vinculacion_Contratista' && 
                                (lstOportunidad.get(0).COM_EntidadContratista__c == null ||
                                lstOportunidad.get(0).COM_EntidadContratista__r.COM_NAUTCLI__c == null)
                                
                            ) 
                            || 
                            (
                                lstOportunidad.get(0).RecordType.DeveloperName == 'COM_Vinculacion_Pensionado' && 
                                (lstOportunidad.get(0).COM_EntidadPensionadora1__c == null ||
                                lstOportunidad.get(0).COM_EntidadPensionadora1__r.COM_NAUTCLI__c == null)                               
                            )
                        ){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Verifique que la entidad Contratista/Pensionadora este creada correctamente y registrada en GC.'));
                            this.blnBotonGuardar = false;
                        }
                        Account acc = lstCuenta.get(0);
                        	//CEL1 PB 
                            if(acc.CEL1_LineaNegocio__c == null){
                                //No tiene línea de negocio
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Verifique que el cliente tenga por lo menos una línea de negocio asociada.'));
                            	this.blnBotonGuardar = false;
                            }
                            //CEL1 PB 
                        	else{
                                
                                if(acc.RecordType.DeveloperName == 'COM_Juridico' && (acc.Phone == null || acc.COM_Barrio__c == null || acc.COM_Tipodireccion__c == null || 
                            acc.COM_Direccion__c == null || acc.COM_NAUTCLI__c == null)){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Para vincular los campos: '+
                                'Teléfono, Barrio, Tipo de dirección, Dirección, Correo electrónico, Móvil y NAUTCLI '+
                                'son obligatorios.'));
                            this.blnBotonGuardar = false;
                            } else {
                                if(lstCuenta.get(0).RecordType.DeveloperName.equals('COM_Natural')) {
                                    if(acc.COM_Primernombre__c == null || acc.COM_Primerapellido__c == null || acc.COM_Estado_civil__c == null
                                        || acc.COM_FechaNacimiento__c == null){
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Para vincular una persona natural los campos: '+
                                            'Primer Nombre, Primer Apellido, Estado Civil y Fecha de nacimiento '+
                                            'son obligatorios.'));
                                        this.blnBotonGuardar = false;
                                    } 
                                    }else if(lstCuenta.get(0).RecordType.DeveloperName.equals('COM_Juridico')){

                                        if(acc.COM_Digitoverificacion__c == null || acc.COM_NombreComercial__c == null || acc.COM_Fechaconstitucion__c == null ||
                                            acc.COM_TipoCliente__c == null || acc.COM_Segmento__c == null){
                                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Para vincular una persona jurídica los campos: '+
                                                'Dígito de verificación, Tipo de Cliente, Nombre Comercial, Segmento y Fecha de Constitución '+
                                                'son obligatorios.'));
                                            this.blnBotonGuardar = false;
                                        }
                                    }
                                }

                                if(lstCuenta.get(0).RecordType.DeveloperName.equals('COM_Natural')) { 
                                    strNombreCliente = lstCuenta.get(0).COM_Nombre_completo_del_cliente__c;
                                    } else if(lstCuenta.get(0).RecordType.DeveloperName.equals('COM_Juridico')){
                                        strNombreCliente = lstCuenta.get(0).Name;
                                    }
                                    strPrograma = lstOportunidad.get(0).COM_ProgramaVinculacion1__r.Name;
                                }
                            }
                                
                            }
                        
                        }

                        public void vincularCliente(){
                            COM_LogicaVinculacionClienteGC_cls objLogicaVinculacionClienteGC = new COM_LogicaVinculacionClienteGC_cls();
                            try{
                                strMensaje = objLogicaVinculacionClienteGC.procesarVinculacion(this.objOportunidad.Id);
                                }catch(COM_WSInactivoException e){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                                    }catch(COM_VinculacionClienteException e){
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                                    }
                                    blnMensaje = false;
                                    if(String.isNotBlank(strMensaje)){
                                        blnMensaje = true;
                                        strMensaje = strMensaje.replaceAll('[-.]','<br/>'); 

                                        } else {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error!, consulte el log de transacciones.'));
                                        }

                                    }
                                }