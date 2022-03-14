/**
* Avanxo Colombia
* @author           Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:          Compensar
* @Description:     Clase encargada manejar los eventos de iterfaz de usuario del pdf cotizaciones
*                   alojamiento .
*                   
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     26/07/2017      Cristian Mosquera (CM)      Implementacion inicial del controlador.
* @version  1.1     02/04/2018      Brisleydi Calderon(BC)      Ajuste en método cargarMenusEspeciales y cargarOfertas.
* @version  1.2     11/04/2018      Brisleydi Calderon(BC)      Ajuste en método cargarConceptosLagoSol() para validar si el producto tiene descuento y de ser asi, mostrar campo de "Precio_de_Venta_con_Descuento__c".
* @version  2.0     18/07/2019      Yeison Naranjo	(YSN)       Ajuste firma por valor fijo.
* @version	3.0		21/10/2021		Yeison Naranjo	(YSN)		Ajuste Menús.
**/
public class COM_PVE_CotizacionAlojamiento_ctr {
    
    private List<String> args = new String[]{'0','number','###,###,###.00'};
        
        /** Nombre del Cliente.**/
        private String nombreCliente;
    
    /** Nombre del Representante legal. **/
    private String nombreRepresentateLegal;
    
    /** Numero de la cotización.**/
    private String numeroCotizacion;
    
    /** Nit de la empresa.**/
    private String nit;
    
    /** Fecha en la cual entreo el evento.**/
    private String fechaEntradaEvento;
    
    /** Fecha en que salio el evento.**/
    private String fechaSalidaEvento;
    
    /** El subtotal de conceptos.**/
    private String subtotalConcepts;
    
    /** El subtotal de conceptos.**/
    private String subtotalAdicionales;
    
    /** El total de la preliquidacion conceptos.**/
    private String totalPreliquidacion;
    
    /** El total de la preliquidacion servicios.**/
    private String totalServicios;
    
    /** Almacena en formato HTML las condiciones comerciales.**/
    private List<String> condicionesComerciales  = new List<String>();
    
    /** Almacena en formato HTML las cancelaciones.**/
    private List<String> cancelaciones = new List<String>();
    
    /** Almacena en formato HTML los aplazamientos.**/
    private List<String> aplazamientos = new List<String>();
    
    /** Fecha actual.**/
    private String fechaActual;
    
    /** La imagen de la firma.**/
    private String imagenFirma;
    
    /** El color de las cabeceras de la tabla.**/
    private String colorTabla;
    
    /** El color de las cajas de la informacion de la compañia.**/
    private String colorCajasInfoCia;
    
    /** Almacena en formato HTML los menus especiales.**/
    private List<String> menuEspeciales = new List<String>();
    
    /** Almacena en formato HTML los menus especiales.**/
    private List<String> ofertasDesayuno = new List<String>();
    
    /** El valor del label de fecha de entrada.**/
    private String labelFechaEntrada;
    
    /** Indica si el reporte es de lagomar.**/
    private boolean lagomar;
    
    /** Indica si el reporte es de lagosol.**/
    private boolean lagosol;
    
    /** Indica si el reporte es de pasadia lago mar.**/
    private boolean pasadiaLagomar;
    
    /** Indica si el reporte es pasadia lagosol. **/
    private boolean pasadiaLagosol;
    
    /** Indica si se debe mostrar ambos label de fecha de entrada y salida.**/
    private boolean fechaEntradaYSalida;
    
    /** Indica si solo se debe mostrar el labelr de fecha de entrada.**/
    private boolean mostrarMenuEspeciales;
    
    /** Indica si solo se debe mostrar el labelr de fecha de entrada.**/
    private boolean mostrarOfertasDesayuno;
    
    /** El color de las cabeceras de la tabla servicios adicionales.**/
    private String colorTablaServiciosAdicionales;
    
    /** Label de subtotal de conceptos**/
    private String labelSubtotalConceptos;
    
    /** Label del subtotal de servicios adicionales.**/
    private String labelSubtotalAdicionales;
    
    /** Label del encabezado de servicios adicionales.**/
    private String headerLabelServiciosAdicionales;
    
    /** Label con el html del texto de la carta.**/
    private String textCarta;
    
    /** Conceptos de notificaciones.**/
    private List<COM_PVE_ConceptosCotizacion_cls> conceptosCotizacions
        = new List<COM_PVE_ConceptosCotizacion_cls>();
    
    /** Servicios adicionales.**/
    private List<COM_PVE_ServiciosAdicionales_cls> serviciosAdicionales
        = new List<COM_PVE_ServiciosAdicionales_cls>();
    
    /** Servicios opcionales.**/
    private List<COM_PVE_ServiciosOpcionales_cls> serviciosOpcionales
        = new List<COM_PVE_ServiciosOpcionales_cls>();
    
    public String nombreAsesor {get;set;}
    public String cargoAsesor {get;set;}
    public String celularAsesor {get;set;}
    public String emailAsesor {get;set;}
    public String nombreTipoAsesor {get;set;}
    public String dependenciaAsesor {get;set;}
    public String lugarCotizado {get;set;}
    public String otroNombreLugarCotizado {get;set;}
    public String urlCompensar {get;set;}
    public String contratoLagosol {get;set;}
    public String contratoLagomar {get;set;}
    public String cargoContactoPrincipal {get;set;}
    
    public String hTelefono {get;set;}
    public String hCelular {get;set;}
    public String hDireccion {get;set;}
    public String hEmail {get;set;}
    public String hContacto {get;set;}
    public String hEmpresa {get;set;}
    
    /* Inicio 2.0 */
    public String labelnombreAsesor {get;set;}
    public String labelSegParte {get;set;}
    /* Fin 2.0 */
    
    List<Quote> lstCotizacion;
    List<Account> lstCuentas;
    List<AccountContactRelation> lstContactsRel;
    List<Opportunity> lstOportunidad;
    List<OpportunityLineItem> lstProductosPrecios;
    List<OpportunityLineItem> lstProductosAdicionales;
    
    
    
    /**
* Constructor de la clase.
*/
    public COM_PVE_CotizacionAlojamiento_ctr () {
        String idReport = ApexPages.currentpage().getparameters().get('tipoDoc');
        String idCotizacion = ApexPages.currentpage().getparameters().get('idCotizacion');
        lstCotizacion = [SELECT AccountId, OpportunityId, Opportunity.Contacto__c, QuoteNumber FROM Quote where Id =: idCotizacion];
        lstCuentas = [Select Name, COM_Nombre_completo_del_cliente__c, COM_Numero_de_identificacion__c, Phone, COM_Extension__c, COM_Movil__c, COM_Direccion__c, COM_CorreoElectronico__c From Account where Id =: lstCotizacion.get(0).AccountId];    
        //lstContactsRel = [SELECT Id,Contact.Name, COM_CargoEmpresa__c FROM AccountContactRelation WHERE AccountId =: lstCotizacion.get(0).AccountId AND Roles INCLUDES ('Representante Legal') AND isActive = true];
        lstContactsRel = [SELECT Id,Contact.Name, COM_CargoEmpresa__c FROM AccountContactRelation WHERE AccountId =: lstCotizacion.get(0).AccountId AND ContactId = :lstCotizacion.get(0).Opportunity.Contacto__c];
        lstOportunidad = [Select COM_Fechahorainicio__c, COM_Fechahorafinalizacion__c, Pricebook2Id, COM_Requieretransporte__c, COM_ValorTransporte__c From Opportunity WHERE Id =: lstCotizacion.get(0).OpportunityId];
        lstProductosPrecios = [SELECT Product2.COM_SubCategoriaSalud__c, Product2.Description, Product2.COM_Duracion__c, Product2.COM_Unidadmedida__c, Product2.Name, Quantity, Subtotal, Discount, Name, COM_NoPax__c, UnitPrice,Precio_de_Venta_con_Descuento__c, ListPrice, COM_NumeroNoches__c, TotalPrice, COM_CantidadAnterior__c, COM_Familia__c FROM OpportunityLineItem where COM_Familia__c != 'PyS' AND Product2.RecordType.DeveloperName = 'COM_Alojamiento' AND OpportunityId =: lstCotizacion.get(0).OpportunityId]; 
        lstProductosAdicionales = [SELECT Product2.COM_SubCategoriaSalud__c, Product2.Description, Product2.COM_Duracion__c, Product2.COM_Unidadmedida__c, Product2.Name, Quantity, Subtotal, Discount, Name, COM_NoPax__c, UnitPrice, COM_NumeroNoches__c, TotalPrice, COM_CantidadAnterior__c, COM_Familia__c FROM OpportunityLineItem where COM_Familia__c != 'PyS' AND Product2.RecordType.DeveloperName = 'COM_Adicionales' AND OpportunityId =: lstCotizacion.get(0).OpportunityId]; 
        
        hTelefono = lstCuentas.get(0).Phone;
        hTelefono += lstCuentas.get(0).COM_Extension__c!=null?'x'+lstCuentas.get(0).COM_Extension__c:'';
        hCelular = lstCuentas.get(0).COM_Movil__c;
        hDireccion = lstCuentas.get(0).COM_Direccion__c;
        hEmail = lstCuentas.get(0).COM_CorreoElectronico__c;
        hContacto = lstContactsRel.size()>0?lstContactsRel.get(0).Contact.Name:'Contacto';
        hEmpresa = lstCuentas.get(0).Name;
        
        if ('Lagomar'.equals(idReport)) {
            cargarPDFLagomar(idCotizacion, idReport);
        }
        else if ('Lagosol'.equals(idReport)) {
            cargarPDFLagosol(idCotizacion, idReport);
        }
        else if ('PasadiaLagomar'.equals(idReport)) {
            cargarPDFPasadiaLagomar(idCotizacion, idReport);
        }
        else if ('PasadiaLagosol'.equals(idReport)) {
            cargarPDFPasadiaLagosol(idCotizacion, idReport);
        }
        
    }
    
    public static User getUser (){
        
        Id runningUserId = UserInfo.getUserId();
        User user = new user ();
        user = [Select id, name, Email, Phone from User where id =: runningUserId ]; 
        return user;
        
    }
    
    
    /**
* Metodo encargado de cargar el PDF de lago sol
*/
    public void cargarPDFLagosol(String idCotizacion, String idReport) {
        lagosol = true;
        if(!lstCuentas.isEmpty() && !lstCotizacion.isEmpty() && !lstOportunidad.isEmpty() && !lstContactsRel.isEmpty() && lstOportunidad.get(0).COM_Fechahorainicio__c!= null &&  lstOportunidad.get(0).COM_Fechahorafinalizacion__c != null){
            cargarGenericDataPDF('#FFFFFF', 
                                 '#FFFFFF', 
                                 '#FFFFFF',
                                 'FECHA DE ENTRADA DEL EVENTO', 
                                 'SERVICIOS ADICIONALES', 
                                 'Subtotal Servicios Adicionales',
                                 true, 
                                 'SUB-TOTAL ALOJAMIENTO', 
                                 lstCuentas.get(0).COM_Nombre_completo_del_cliente__c, 
                                 lstCotizacion.get(0).QuoteNumber, 
                                 lstCuentas.get(0).COM_Numero_de_identificacion__c, 
                                 lstOportunidad.get(0).COM_Fechahorainicio__c.format(), 
                                 lstOportunidad.get(0).COM_Fechahorafinalizacion__c.format(),
                                 date.today().format(), 
                                 lstContactsRel.get(0).Contact.Name);
        }else{
            if(lstOportunidad.get(0).COM_Fechahorainicio__c == null ||  
               lstOportunidad.get(0).COM_Fechahorafinalizacion__c == null){
                   //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin');
                   ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin');
                   ApexPages.addMessage(errMessage);
               }
            
            if(lstContactsRel.isEmpty()){
                //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.addMessage(errMessage);
            }
        }            
        
        //cargoContactoPrincipal = lstContactsRel.get(0).COM_CargoEmpresa__c;
        cargoContactoPrincipal = lstContactsRel.size()>0?lstContactsRel.get(0).COM_CargoEmpresa__c:'Cargo';
        
        List<COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt> lstConfig = [SELECT COM_texto_Carta__c, COM_Condiciones_Comerciales_lagoSol__c, COM_CondicionesCancelacionLagosol__c, COM_CondicionesAplazamientosLagosol__c, COM_ContratoSalgosol__c FROM COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt where QualifiedApiName = 'COM_cotizacion_Alojamiento_lagosol'];            
        textCarta = lstConfig.get(0).COM_texto_Carta__c;
        
        cargarConceptosLagoSol(lstProductosPrecios);
        cargarConceptosAdicionalesLagoSol(lstProductosAdicionales);
        if(lstOportunidad.get(0).COM_Requieretransporte__c){
            cargarConceptosOpcionalesLagoSol(lstOportunidad.get(0));
        }
        cargarCondicionesComercialesLagoSol(lstConfig.get(0));
        cargarCancelacionesLagoSol(lstConfig.get(0));
        cargarAplazamientosLagoSol(lstConfig.get(0));
        decimal subtotalConceptDecimal = calculaSubtotalConcepto(conceptosCotizacions);
        subtotalConcepts = '$ ' + calculaSubtotalConcepto(conceptosCotizacions);
        decimal subtotalAdicionalesDecimal = calculaSubtotalConcepto(serviciosAdicionales);
        subtotalAdicionales = '$ ' + calculaSubtotalConcepto(serviciosAdicionales);
        decimal subtotalOpcionalesDecimal = calculaSubtotalConcepto(serviciosOpcionales);
        totalPreliquidacion = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal);
        totalServicios = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal + subtotalOpcionalesDecimal);
        
        User asesor = new User ();
        asesor = getUser();
        nombreAsesor = asesor.Name;
        celularAsesor = asesor.Phone;
        emailAsesor = asesor.Email;
        cargoAsesor = 'Asesor Comercial';
        nombreTipoAsesor = 'Evento congresos y convenciones';
        dependenciaAsesor = 'Evento congresos y convenciones';
        lugarCotizado = 'Centro Convenciones Lagosol - Nilo';
        otroNombreLugarCotizado = 'Hotel y centro de convenciones Lagosol';
        urlCompensar = 'www.compensar.com';
        contratoLagosol = lstConfig.get(0).COM_ContratoSalgosol__c;
        
        /* Inicio 2.0 */
        labelnombreAsesor = label.labelnombreAsesor;
        labelSegParte = label.labelSegParte;
        /* Fin 2.0 */
    }
    
    
    /**
* Metodo encargado de cargar el PDF de lago mar
*/
    public void cargarPDFLagomar(String idCotizacion, String idReport) {
        lagomar = true;
        if(!lstCuentas.isEmpty() && !lstCotizacion.isEmpty() && !lstOportunidad.isEmpty() && !lstContactsRel.isEmpty() && lstOportunidad.get(0).COM_Fechahorainicio__c!= null &&  lstOportunidad.get(0).COM_Fechahorafinalizacion__c != null){
            cargarGenericDataPDF('#FFFFFF', 
                                 '#FFFFFF', 
                                 '#FFFFFF',
                                 'FECHA DE ENTRADA DEL EVENTO', 
                                 'SERVICIOS ADICIONALES', 
                                 'Subtotal Servicios Adicionales',
                                 true, 
                                 'SUB-TOTAL ALOJAMIENTO', 
                                 lstCuentas.get(0).COM_Nombre_completo_del_cliente__c, 
                                 lstCotizacion.get(0).QuoteNumber, 
                                 lstCuentas.get(0).COM_Numero_de_identificacion__c, 
                                 lstOportunidad.get(0).COM_Fechahorainicio__c.format(), 
                                 lstOportunidad.get(0).COM_Fechahorafinalizacion__c.format(),
                                 date.today().format(), 
                                 lstContactsRel.get(0).Contact.Name);
        }else{
            if(lstOportunidad.get(0).COM_Fechahorainicio__c == null ||  
               lstOportunidad.get(0).COM_Fechahorafinalizacion__c == null){
                   //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin');
                   ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin.');
                   ApexPages.addMessage(errMessage);
               }
            
            if(lstContactsRel.isEmpty()){
                //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.addMessage(errMessage);
            }
        }
        List<COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt> lstConfig = [SELECT COM_texto_Carta__c, COM_Condiciones_Comerciales_lagoSol__c, COM_CondicionesCancelacionLagosol__c, COM_CondicionesAplazamientosLagosol__c, COM_ContratoSalgosol__c FROM COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt where QualifiedApiName = 'COM_cotizacion_Alojamiento_lagomar'];            
        textCarta = lstConfig.get(0).COM_texto_Carta__c;
        cargoContactoPrincipal = lstContactsRel.size()>0?lstContactsRel.get(0).COM_CargoEmpresa__c:'Cargo';
        cargarConceptosLagoSol(lstProductosPrecios);
        cargarConceptosAdicionalesLagoSol(lstProductosAdicionales);
        if(lstOportunidad.get(0).COM_Requieretransporte__c){
            cargarConceptosOpcionalesLagoSol(lstOportunidad.get(0));
        }
        cargarCondicionesComercialesLagoSol(lstConfig.get(0));
        cargarCancelacionesLagoSol(lstConfig.get(0));
        cargarAplazamientosLagoSol(lstConfig.get(0));
        decimal subtotalConceptDecimal = calculaSubtotalConcepto(conceptosCotizacions);
        decimal subtotalAdicionalesDecimal = calculaSubtotalConcepto(serviciosAdicionales);
        decimal subtotalOpcionalesDecimal = calculaSubtotalConcepto(serviciosOpcionales);
        subtotalConcepts = '$ ' + calculaSubtotalConcepto(conceptosCotizacions);
        subtotalAdicionales = '$ ' + calculaSubtotalConcepto(serviciosAdicionales);
        totalPreliquidacion = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal);
        totalServicios = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal + subtotalOpcionalesDecimal);
        
        //cuando se implemente texto enriquecido se debe almacenar en esta variable y mostrarlo en un output text con escape=false
        //imagenFirma = $Resource.COM_PAF_FirmaDirector_img;
        //        User asesor = new User ();
        User asesor = new User ();
        asesor = getUser();
        nombreAsesor = asesor.Name;
        celularAsesor = asesor.Phone;
        emailAsesor = asesor.Email;
        cargoAsesor = 'Asesor Comercial';
        nombreTipoAsesor = 'Evento congresos y convenciones';
        dependenciaAsesor = 'Evento congresos y convenciones';
        lugarCotizado = 'Centro Convenciones Lagomar El peñon - Girardot';
        otroNombreLugarCotizado = 'Hotel y centro de convenciones Lagomar';
        urlCompensar = 'www.compensar.com';
        contratoLagomar = lstConfig.get(0).COM_ContratoSalgosol__c;
        
        /* Inicio 2.0 */
        labelnombreAsesor = label.labelnombreAsesor;
        labelSegParte = label.labelSegParte;
        /* Fin 2.0 */
    }
    
    
    /**
* Metodo encargado de cargar el PDF de pasadia lago mar
*/
    public void cargarPDFPasadiaLagomar(String idCotizacion, String idReport) {
        pasadiaLagomar = true;
        if(!lstCuentas.isEmpty() && !lstCotizacion.isEmpty() && !lstOportunidad.isEmpty() && !lstContactsRel.isEmpty() && lstOportunidad.get(0).COM_Fechahorainicio__c!= null &&  lstOportunidad.get(0).COM_Fechahorafinalizacion__c != null){
            cargarGenericDataPDF('#FFFFFF', 
                                 '#FFFFFF', 
                                 '#FFFFFF',
                                 'FECHA DEL EVENTO', 
                                 'Incluye', 
                                 'VALOR TOTAL',
                                 false, 
                                 'SUB-TOTAL ALOJAMIENTO', 
                                 lstCuentas.get(0).COM_Nombre_completo_del_cliente__c, 
                                 lstCotizacion.get(0).QuoteNumber, 
                                 lstCuentas.get(0).COM_Numero_de_identificacion__c, 
                                 lstOportunidad.get(0).COM_Fechahorainicio__c.format(), 
                                 lstOportunidad.get(0).COM_Fechahorafinalizacion__c.format(),
                                 date.today().format(), 
                                 lstContactsRel.get(0).Contact.Name);
        }else{
            if(lstOportunidad.get(0).COM_Fechahorainicio__c == null ||  
               lstOportunidad.get(0).COM_Fechahorafinalizacion__c == null){
                   //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin');
                   ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin.');
                   ApexPages.addMessage(errMessage);
               }
            
            if(lstContactsRel.isEmpty()){
                //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.addMessage(errMessage);
            }
        }
        
        List<COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt> lstConfig = [SELECT COM_texto_Carta__c, COM_Condiciones_Comerciales_lagoSol__c, COM_CondicionesCancelacionLagosol__c, COM_CondicionesAplazamientosLagosol__c, COM_ContratoSalgosol__c FROM COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt where QualifiedApiName = 'COM_cotizacion_Pasadia_lagomar'];            
        
        textCarta = lstConfig.get(0).COM_texto_Carta__c;
        //cargoContactoPrincipal = lstContactsRel.get(0).COM_CargoEmpresa__c;
        cargoContactoPrincipal = lstContactsRel.size()>0?lstContactsRel.get(0).COM_CargoEmpresa__c:'Cargo';
        
        cargarConceptosLagoSol(lstProductosPrecios);
        cargarConceptosAdicionalesLagoSol(lstProductosAdicionales);
        if(lstOportunidad.get(0).COM_Requieretransporte__c){
            cargarConceptosOpcionalesLagoSol(lstOportunidad.get(0));
        }
        cargarCondicionesComercialesLagoSol(lstConfig.get(0));
        cargarCancelacionesLagoSol(lstConfig.get(0));
        cargarAplazamientosLagoSol(lstConfig.get(0));
        decimal subtotalConceptDecimal = calculaSubtotalConcepto(conceptosCotizacions);
        decimal subtotalAdicionalesDecimal = calculaSubtotalConcepto(serviciosAdicionales);
        decimal subtotalOpcionalesDecimal = calculaSubtotalConcepto(serviciosOpcionales);
        subtotalConcepts = '$ ' + calculaSubtotalConcepto(conceptosCotizacions);
        subtotalAdicionales = '$ ' + calculaSubtotalConcepto(serviciosAdicionales);
        totalPreliquidacion = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal);
        totalServicios = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal + subtotalOpcionalesDecimal);
        
        //cuando se implemente texto enriquecido se debe almacenar en esta variable y mostrarlo en un output text con escape=false
        //imagenFirma = $Resource.COM_PAF_FirmaDirector_img;
        User asesor = new User ();
        asesor = getUser();
        nombreAsesor = asesor.Name;
        celularAsesor = asesor.Phone;
        emailAsesor = asesor.Email;
        cargoAsesor = 'Asesor Comercial';
        nombreTipoAsesor = 'Evento congresos y convenciones';
        dependenciaAsesor = 'Evento congresos y convenciones';
        lugarCotizado = 'Centro Convenciones Lagomar El peñon - Girardot';
        otroNombreLugarCotizado = 'Hotel y centro de convenciones Lagomar';
        urlCompensar = 'www.compensar.com';
        contratoLagomar = lstConfig.get(0).COM_ContratoSalgosol__c;
        
        /* Inicio 2.0 */
        labelnombreAsesor = label.labelnombreAsesor;
        labelSegParte = label.labelSegParte;
        /* Fin 2.0 */
    }
    
    
    /**
* Metodo encargado de cargar el PDF de pasadia lago sol
*/
    public void cargarPDFPasadiaLagosol(String idCotizacion, String idReport) {
        
        pasadiaLagosol = true;
        
        List<COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt> lstConfig = [SELECT COM_texto_Carta__c, COM_Condiciones_Comerciales_lagoSol__c, COM_CondicionesCancelacionLagosol__c, COM_CondicionesAplazamientosLagosol__c, COM_ContratoSalgosol__c FROM COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt where QualifiedApiName = 'COM_cotizacion_Pasadia_lagosol'];            
        
        textCarta = lstConfig.get(0).COM_texto_Carta__c;
        if(!lstCuentas.isEmpty() && !lstCotizacion.isEmpty() && !lstOportunidad.isEmpty() && !lstContactsRel.isEmpty() && lstOportunidad.get(0).COM_Fechahorainicio__c!= null &&  lstOportunidad.get(0).COM_Fechahorafinalizacion__c != null){
            cargarGenericDataPDF('#FFFFFF', 
                                 '#FFFFFF', 
                                 '#FFFFFF',
                                 'FECHA DEL EVENTO', 
                                 'Incluye', 
                                 'VALOR TOTAL',
                                 false, 
                                 'SUB-TOTAL ALOJAMIENTO', 
                                 lstCuentas.get(0).COM_Nombre_completo_del_cliente__c, 
                                 lstCotizacion.get(0).QuoteNumber, 
                                 lstCuentas.get(0).COM_Numero_de_identificacion__c, 
                                 lstOportunidad.get(0).COM_Fechahorainicio__c.format(), 
                                 lstOportunidad.get(0).COM_Fechahorafinalizacion__c.format(),
                                 date.today().format(), 
                                 lstContactsRel.get(0).Contact.Name);
        }else{
            if(lstOportunidad.get(0).COM_Fechahorainicio__c == null ||  
               lstOportunidad.get(0).COM_Fechahorafinalizacion__c == null){
                   //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin');
                   ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga fecha Inicio y fecha Fin.');
                   ApexPages.addMessage(errMessage);
               }
            
            if(lstContactsRel.isEmpty()){
                //throw new applicationException('Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.Message errMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Faltan datos para crear la cotizacion. Verifique que la oportunidad tenga un contacto.');
                ApexPages.addMessage(errMessage);
            }
        }
        
        //cargoContactoPrincipal = lstContactsRel.get(0).COM_CargoEmpresa__c;
        cargoContactoPrincipal = lstContactsRel.size()>0?lstContactsRel.get(0).COM_CargoEmpresa__c:'Cargo';
        
        cargarConceptosLagoSol(lstProductosPrecios);
        cargarConceptosAdicionalesLagoSol(lstProductosAdicionales);
        if(lstOportunidad.get(0).COM_Requieretransporte__c){
            cargarConceptosOpcionalesLagoSol(lstOportunidad.get(0));
        }
        cargarCondicionesComercialesLagoSol(lstConfig.get(0));
        cargarCancelacionesLagoSol(lstConfig.get(0));
        cargarAplazamientosLagoSol(lstConfig.get(0));
        
        cargarMenusEspeciales();
        cargarOfertas();
        decimal subtotalConceptDecimal = calculaSubtotalConcepto(conceptosCotizacions);
        decimal subtotalAdicionalesDecimal = calculaSubtotalConcepto(serviciosAdicionales);
        decimal subtotalOpcionalesDecimal = calculaSubtotalConcepto(serviciosOpcionales);
        subtotalConcepts = '$ ' + calculaSubtotalConcepto(conceptosCotizacions);
        subtotalAdicionales = '$ ' + calculaSubtotalConcepto(serviciosAdicionales);
        totalPreliquidacion = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal);
        totalServicios = '$ ' + (subtotalConceptDecimal + subtotalAdicionalesDecimal + subtotalOpcionalesDecimal);
        
        //cuando se implemente texto enriquecido se debe almacenar en esta variable y mostrarlo en un output text con escape=false
        //imagenFirma = $Resource.COM_PAF_FirmaDirector_img;
        User asesor = new User ();
        asesor = getUser();
        nombreAsesor = asesor.Name;
        celularAsesor = asesor.Phone;
        emailAsesor = asesor.Email;
        cargoAsesor = 'Asesor Comercial';
        nombreTipoAsesor = 'Evento congresos y convenciones';
        dependenciaAsesor = 'Evento congresos y convenciones';
        lugarCotizado = 'Centro Convenciones Lagosol - Nilo';
        otroNombreLugarCotizado = 'Hotel y centro de convenciones Lagosol';
        urlCompensar = 'www.compensar.com';
        contratoLagosol = lstConfig.get(0).COM_ContratoSalgosol__c;
        
        /* Inicio 2.0 */
        labelnombreAsesor = label.labelnombreAsesor;
        labelSegParte = label.labelSegParte;
        /* Fin 2.0 */
    }
    
    /**
* Metodo encargado de generar una columna de una tabla.
*/
    public String generarColumnTable(String content, String colspan) {
        String td = '<td height="130" style="border-top: 1px solid #000000; font-size:0.6em; ' +
            'border-bottom: 1px solid #000000; border-left: 1px solid #000000; border-right: 1px solid #000000" '+
            'align="center" valign="middle" ' + colspan + '>' +content + '</td>';
        return td;
    }
    
    /**
* Metodo encrgado de cargar los menus especiales.
*/
    public void cargarMenusEspeciales() {
        menuEspeciales = new List<String>();
        /*menuEspeciales.add(generarColumnTable('MENU ESPECIAL Nº 1<br/>Porción de fruta <br/>Sopa del día ' +
'<br/>Pollo al horno (¼ )<br/>Croqueta de yuca<br/>Arroz ' +
'<br/>Ensalada mixta<br/>Postre<br/>Jugo del día', ''));*/
        
        /*Inicio Caso 00258536 24-09-18*/
        //Cambio Menu Especial
        /*menuEspeciales.add(generarColumnTable(
'MENU ESPECIAL N° 1'+
'<br>Porción de fruta'+
'<br>Sopa del día'+
'<br>Mojarra frita (250 Grs)'+
'<br>Patacón'+
'<br>Arroz'+
'<br>Ensalada mixta'+
'<br>Postre'+
'<br>Jugo del día', ''));


menuEspeciales.add(generarColumnTable(
'MENU ESPECIAL Nº 2'+
'<br/>Porción de fruta'+
'<br/>Sopa del día'+
'<br/>Steak y pollo (125 Grs y 1/8)'+
'<br/>Croqueta de yuca'+
'<br/>Arroz'+
'<br/>Ensalada mixta'+
'<br/>Postre'+
'<br/>Jugo del día', ''));


menuEspeciales.add(generarColumnTable(
'<br/>PARRILLADA' +
'<br/>Steak, Pollo y Costilla de Cerdo' +
'<br>Chorizo' +
'<br>Papa y Yuca' +
'<br>Plátano Maduro' +
'<br>Mazorca' +
'<br>Guacamole' +
'<br>Cola y Pola' , ''));
*/
      /* Inicio 3.0  
      
        menuEspeciales.add(generarColumnTable(
            'MENU ESPECIAL N° 1'+
            '<br>Steak y pollo'+
            '<br>Mix de fruta 60 gr.'+
            '<br>Sopa del día 250 gr.'+
            '<br>Steak 125 gramos y Pollo 1/8'+
            '<br>Croqueta de yuca 100 gr'+
            '<br>Arroz 100 gr.'+
            '<br>Ensalada del dia 100 gr.'+
            '<br>Postre 80 gr.'+
            '<br>Jugo del día 25 (vaso de 10 oz)', ''));
        
        
        menuEspeciales.add(generarColumnTable(
            'Parrillada'+
            '<br/>Steak 125 gr'+
            '<br/>Pollo 1/8'+
            '<br/>Costilla de cerdo 125 gr'+
            '<br/>Chorizo 50 gr '+
            '<br/>Papa salada, Mazorca, Plátano'+
            '<br/>maduro, Yuca al vapor (100 gr'+
            '<br/>cada) una'+
            '<br/>Guacamole 30 gr'+
            '<br/>Bebida', ''));
*/
        menuEspeciales.add(generarColumnTable(
            'Porción Arroz Mixto 400 gr'+
            '<br/>(Carne de cerdo, pollo en'+
            '<br/>cubos, verduras, zanahoria,'+
            '<br/>arveja y maíz).'+
            '<br/><br/>Ensalada Mixta 100 gr'+
            '<br/><br/>Cascabeles de Plátano 100 gr'+
            '<br/>Flan de Vainilla 60 Onz'+
            '<br/>Jugo del Día 10 Onz', ''));
        
        
        menuEspeciales.add(generarColumnTable(
            'Sobrebarriga 100 gr'+
            '<br/><br/>Pollo Rotti 100 gr'+
            '<br/><br/>Costilla de Cerdo 110 gr'+
            '<br/><br/>Chorizo 50 gr'+
            '<br/><br/>Papa Salada 100 gr'+
            '<br/>Yuca al Vapor 100 gr'+
            '<br/>Plátano Maduro 100 gr'+
            '<br/>Mazorca 100 gr'+
            '<br/>Guacamole 1 onza'+
            '<br/>Gaseosa Lata', ''));
/* Fin 3.0 */
        /*Fin Caso 00258536 24-09-18*/  
    }
    
    
    /**
* Metodo encrgado de cargar los menus especiales.
*/
    public void cargarOfertas() {
        ofertasDesayuno = new List<String>();
        /* Inicio 3.0
        ofertasDesayuno.add(generarColumnTable('<br/>DESAYUNO Nº 1'+
                                               '<br/>Tamal'+
                                               '<br/>Chocolate o Café'+
                                               '<br/>Pan – Mantequilla – Mermelada', ''));
        ofertasDesayuno.add(generarColumnTable(
            '<br/>DESAYUNO Nº 2 '+
            '<br/>Huevos al Gusto'+
            '<br/>Arepa'+
            '<br/>Chocolate o Café'+
            '<br/>Pan – Mantequilla – Mermelada', ''));
        
        ofertasDesayuno.add(generarColumnTable(
            '<br/>MENU INFANTIL Nº 1'+
            '<br/>Hamburguesa Feliz'+
            '<br/>Papa a la Francesa'+
            '<br/>Postre'+
            '<br/>Jugo', ''
            
        ));
        
        
        ofertasDesayuno.add(generarColumnTable(
            '<br/>MENU INFANTIL Nº 2' +
            '<br/>Pollo apanado' +
            '<br/>Papa a la Francesa' +
            '<br/>Postre' +
            '<br/>Jugo', ''
            
        ));
*/
        ofertasDesayuno.add(generarColumnTable(
            '<br/>Tamal 250 gr' +
            '<br/>Bebida Caliente Vaso 6 Onz' +
            '<br/>Chocolate o Café' +
            '<br/>Porción de Pan 40 gr (Mantequilla -' +
            '<br/>Mermelada)', ''
            
        ));
        
        ofertasDesayuno.add(generarColumnTable(
            '<br/>Huevos revueltos 120 gr' +
            '<br/><br/>Arepa 60 gr' +
            '<br/><br/>Porción de Pan 40 gr' +
            '<br/>Mantequilla - Mermelada)' +
            '<br/>Bebida Caliente Vaso 6 Onz' +
            '<br/>(Chocolate o Café)', ''
            
        ));
        /* Fin 3.0 */
        
    }
    
    
    
    /**
* Metodo encargado de cargar la data general de pdf.
*/
    public void cargarGenericDataPDF(String colorTabla, String colorCajasInfoCia,
                                     String colorTablaServiciosAdicionales, String labelFechaEntrada,
                                     String headerLabelServiciosAdicionales, String labelSubtotalAdicionales,
                                     boolean fechaEntradaYSalida, String labelSubtotalConceptos, String nombreCliente, String numeroCotizacion,
                                     String nit, String fechaEntradaEvento,String fechaSalidaEvento, String fechaActual, String nombreRepresentateLegal) {
                                         
                                         this.colorTabla = colorTabla;
                                         this.colorCajasInfoCia = colorCajasInfoCia;
                                         this.colorTablaServiciosAdicionales = colorTablaServiciosAdicionales;
                                         this.labelFechaEntrada = labelFechaEntrada;
                                         this.headerLabelServiciosAdicionales = headerLabelServiciosAdicionales;
                                         this.labelSubtotalAdicionales = labelSubtotalAdicionales;
                                         this.fechaEntradaYSalida = fechaEntradaYSalida;
                                         this.labelSubtotalConceptos = labelSubtotalConceptos;
                                         this.nombreCliente = nombreCliente;
                                         this.numeroCotizacion = numeroCotizacion;
                                         this.nit = nit;
                                         this.fechaEntradaEvento = fechaEntradaEvento;
                                         this.fechaSalidaEvento = fechaSalidaEvento;
                                         this.fechaActual = fechaActual;
                                         this.nombreRepresentateLegal = nombreRepresentateLegal;
                                     }
    
    
    /**
* @description Metodo encargado de calcular los valores totales de los conceptos.
* @param conceptos lista con  los conceptos.
* @return valor calculado.
*/
    public Decimal calculaSubtotalConcepto (List<COM_PVE_ConceptosBase_cls> conceptos) {
        Decimal total = 0;
        for (COM_PVE_ConceptosBase_cls concepto: conceptos  ) {
            System.debug('concepto: ' + concepto);
            if (concepto != null) {
                String value = concepto.getValorTotal().replace('$', '').replace('.', '');
                //Corrección error decimales 12/08/2021 Soporte Globant
                try {
                    value = value.replaceAll(' ', '');//123,5
                    System.debug('value: ' + value);
                    System.debug('total: ' + total);
                    If(value == ''){
                        value = '0';
                    }
                    total += Decimal.valueOf(value);
                    System.debug('value: ' + value);
                    System.debug('total: ' + total);
                }
                catch (Exception e) {
                    system.debug(e.getMessage());
                    
                    //Corrección error decimales 12/08/2021 Soporte Globant
                    value = value.replaceAll(' ', '');
                    value = value.replaceAll(',', '.');
                    System.debug('value: ' + value);
                    System.debug('total: ' + total);
                    If(value == ''){
                        value = '0';
                    }
                    total += Decimal.valueOf(value).round();
                    
                    continue;
                }
            }
            
        }
        return total;
    }
    
    // Metodos para llenar la informacion de Lagosol Alojamiento
    
    /**
* @descripion  metodo encargado de cargar los conceptos de cotizacion de lago sol.
*/
    public void cargarConceptosLagoSol (List<OpportunityLineItem> lstProductosPrecios) {
        conceptosCotizacions = new List<COM_PVE_ConceptosCotizacion_cls>();
        try {
            for(OpportunityLineItem obj : lstProductosPrecios)
            {
                system.debug('producto->'+obj);
                COM_PVE_ConceptosCotizacion_cls conceptoGenerado = poblarConcepto
                    (obj.Product2.Name+'', 
                     
                     obj.COM_Familia__c==Label.COM_FamiliaAlojamiento?obj.COM_CantidadAnterior__c+'':obj.Quantity+'', 
                     
                     '$ '+String.format(obj.Discount==null?obj.ListPrice.format():obj.Precio_de_Venta_con_Descuento__c.format(), args), obj.COM_NumeroNoches__c+'', 
                     //'$ '+String.format(obj.UnitPrice==null?'0':obj.UnitPrice.format(), args), obj.COM_NumeroNoches__c+'', 
                     '$ '+String.format(obj.Subtotal==null?'0':obj.Subtotal.format(), args), obj.Discount+'%', '$ '+String.format(obj.TotalPrice.format(), args),
                     obj.Product2.Description, obj.Product2.COM_Duracion__c!=null?String.format(obj.Product2.COM_Duracion__c.format(), args):'', 
                     String.format(obj.Quantity.format(), args), obj.Product2.COM_Unidadmedida__c);
                conceptosCotizacions.add(conceptoGenerado);
            }
        }catch(NullPointerException e) {
            system.debug(e.getMessage());
        }
    }
    
    
    /**
* @descripion  metodo encargado de cargar los conceptos de cotizacion de lago sol.
*/
    public void cargarConceptosAdicionalesLagoSol (List<OpportunityLineItem> lstProductosAdicionales) {
        serviciosAdicionales = new List<COM_PVE_ServiciosAdicionales_cls>();
        for(OpportunityLineItem obj : lstProductosAdicionales){
            if(obj.Product2.COM_SubCategoriaSalud__c != null && obj.Product2.COM_SubCategoriaSalud__c.equals('Incluído')){
                COM_PVE_ServiciosAdicionales_cls conceptoGenerado = 
                    poblarConceptoAdicionales(
                        (obj.Name == null)?'':obj.Product2.Name+'', 
                        '', 
                        '',
                        '', 
                        '', 
                        '', 
                        'Incluído', 
                        obj.Product2.Description, 
                        '', 
                        '', 
                        '');
                serviciosAdicionales.add(conceptoGenerado);  
            } else {
                COM_PVE_ServiciosAdicionales_cls conceptoGenerado =
                    poblarConceptoAdicionales(
                        (obj.Name == null)?'':obj.Product2.Name+'', 
                        
                        (obj.UnitPrice == 0)?'':obj.Quantity+'', 
                        
                        obj.UnitPrice == 0?'Incluído':'$ '+String.format(obj.UnitPrice==null?'0':obj.UnitPrice.format(), args), 
                        (obj.UnitPrice == 0)?'':obj.COM_NumeroNoches__c+'', 
                        (obj.UnitPrice == 0 || obj.Subtotal == null)?'':'$ '+String.format(obj.Subtotal.format(), args), 
                        (obj.UnitPrice == 0)?'':obj.Discount+'%', 
                        (obj.UnitPrice == 0 || obj.TotalPrice == null)?'':'$ '+String.format(obj.TotalPrice.format(), args),
                        obj.Product2.Description, 
                        obj.Product2.COM_Duracion__c!=null?String.format(obj.Product2.COM_Duracion__c.format(), args):'',  
                        String.format(obj.Quantity.format(), args), obj.Product2.COM_Unidadmedida__c);
                serviciosAdicionales.add(conceptoGenerado);                    
            }
        }
    }
    
    /**
* Cargar condiciones comerciales de pasadia lago mar
*/
    public void cargarCondicionesComercialesLagoSol (COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt lstConfig) {
        condicionesComerciales = new List<String>();
        condicionesComerciales.addAll(lstConfig.COM_Condiciones_Comerciales_lagoSol__c.split('////'));
    }
    
    /**
* @description Metodo encargado de cargar las cancelaciones de lago sol.
*/
    public void cargarCancelacionesLagoSol(COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt lstConfig) {
        cancelaciones = new List<String>();
        cancelaciones.addAll(lstConfig.COM_CondicionesCancelacionLagosol__c.split('////'));
    }
    
    
    /**
* @description Metodo encargado de cargar los aplazamientos de lago sol.
*/
    public void cargarAplazamientosLagoSol(COM_PVE_Cot_Alojamiento_lagosol_mgt__mdt lstConfig) {
        aplazamientos = new List<String>();    
        aplazamientos.addAll(lstConfig.COM_CondicionesAplazamientosLagosol__c.split('////'));
    }
    
    /**
* @descripion  metodo encargado de cargar los conceptos opcionales de  lago sol.
*/
    public void cargarConceptosOpcionalesLagoSol(Opportunity oportunidad) {
        //cargarConceptosOpcionales();
        serviciosOpcionales = new List<COM_PVE_ServiciosOpcionales_cls>();
        COM_PVE_ServiciosOpcionales_cls conceptoGenerado =
            poblarConceptoOpcionales('Servicio de transporte (Opcional) Bogota - ' +
                                     'Girardot - Bogota para el grupo, modelo reciente, con baño, ' +
                                     'aire acondicionado y revisión técnico mecánica al día.', '1', '', '1', '', '', '$ '+oportunidad.COM_ValorTransporte__c, '','','','');
        serviciosOpcionales.add(conceptoGenerado);
    }
    
    /**
* @description metodo encargado de poblar y generar un concepto de cotizacion.
*
* @param nombreConcepto El nombre del concepto.
* @param numeroPax numero de pax.
* @param valorPorPersona el valor por persona.
* @param numeroNoches el numero de noches.
* @param valorTotal el valor total del concepto.
*
* @return el concepto de cotizacion poblado.
*/
    public COM_PVE_ConceptosCotizacion_cls poblarConcepto(String nombreConcepto, String numeroPax, String valorPorPersona,
                                                          String numeroNoches, String subTotal, String descuento, String valorTotal, String descripcion, String duracion, String cantidad, String unidadMedida) {
                                                              COM_PVE_ConceptosCotizacion_cls conceptoCotizacion = new COM_PVE_ConceptosCotizacion_cls();
                                                              poblarConceptoBase(conceptoCotizacion, nombreConcepto,
                                                                                 numeroPax, valorPorPersona, numeroNoches, subTotal, descuento, valorTotal, descripcion, duracion, cantidad, unidadMedida);
                                                              return conceptoCotizacion;
                                                          }
    
    
    /**
* @description metodo encargado de poblar y generar un concepto de servicio adicional.
*
* @param nombreConcepto El nombre del concepto.
* @param numeroPax numero de pax.
* @param valorPorPersona el valor por persona.
* @param numeroNoches el numero de noches.
* @param valorTotal el valor total del concepto.
*
* @return el concepto  poblado.
*/
    public COM_PVE_ServiciosAdicionales_cls poblarConceptoAdicionales
        (String nombreConcepto, String numeroPax, String valorPorPersona,
         String numeroNoches, String subTotal, String descuento, String valorTotal,
         String descripcion, String duracion, String cantidad, String unidadMedida) {
             COM_PVE_ServiciosAdicionales_cls concepto = new COM_PVE_ServiciosAdicionales_cls();
             poblarConceptoBase(concepto, nombreConcepto,
                                numeroPax, valorPorPersona, numeroNoches, subTotal, descuento, valorTotal, descripcion, duracion, cantidad, unidadMedida);
             return concepto;
         }
    
    
    /**
* @description metodo encargado de poblar y generar un concepto de servicio opcional.
*
* @param nombreConcepto El nombre del concepto.
* @param numeroPax numero de pax.
* @param valorPorPersona el valor por persona.
* @param numeroNoches el numero de noches.
* @param valorTotal el valor total del concepto.
*
* @return el concepto  poblado.
*/
    public COM_PVE_ServiciosOpcionales_cls poblarConceptoOpcionales
        (String nombreConcepto, String numeroPax, String valorPorPersona,
         String numeroNoches, String subTotal, String descuento, String valorTotal,
         String descripcion, String duracion, String cantidad, String unidadMedida) {
             COM_PVE_ServiciosOpcionales_cls concepto = new COM_PVE_ServiciosOpcionales_cls();
             poblarConceptoBase(concepto, nombreConcepto,
                                numeroPax, valorPorPersona, numeroNoches, subTotal, descuento, valorTotal, descripcion, duracion, cantidad, unidadMedida);
             return concepto;
         }
    
    
    
    /**
* @description metodo encargado de poblar un concepto base.
* @param conceptoBase instancia del concepto que desea llenar.
* @param nombreConcepto El nombre del concepto.
* @param numeroPax numero de pax.
* @param valorPorPersona el valor por persona.
* @param numeroNoches el numero de noches.
* @param valorTotal el valor total del concepto.
*/
    public void poblarConceptoBase(COM_PVE_ConceptosBase_cls conceptoBase,
                                   String nombreConcepto, String numeroPax, String valorPorPersona,
                                   String numeroNoches, String subTotal, String descuento, String valorTotal,
                                   String descripcion, String duracion, String cantidad, String unidadMedida) {
                                       conceptoBase.setNombreConcepto(nombreConcepto);
                                       conceptoBase.setNumeroPax(numeroPax);
                                       conceptoBase.setNumeroNoches(numeroNoches);
                                       conceptoBase.setValorPorPersona(valorPorPersona);
                                       conceptoBase.setSubTotal(subTotal);
                                       conceptoBase.setDescuento(descuento);
                                       conceptoBase.setValorTotal(valorTotal);
                                       conceptoBase.setDescripcion(descripcion);
                                       conceptoBase.setDuracion(duracion);
                                       conceptoBase.setCantidad(cantidad);
                                       conceptoBase.setUnidadMedida(unidadMedida);
                                       
                                   }
    
    public static AccountContactRelation getContactoPrincipal (String idAccount){
        
        list<AccountContactRelation> lstcontactoPrincipal = new list<AccountContactRelation> ();
        lstcontactoPrincipal = [SELECT id, Contact.firstname,Contact.Lastname, COM_CargoEmpresa__c 
                                FROM AccountContactRelation 
                                WHERE Accountid =: idAccount AND Roles INCLUDES ('Representante Legal') AND isActive = true Limit 1];
        return lstcontactoPrincipal.get(0);
    }
    
    /**
* Getter del atributo nombreRepresentateLegal.
*
* @return el atributo nombreRepresentateLegal.
*/
    public String getNombreRepresentateLegal() {
        return nombreRepresentateLegal;
    }
    
    
    /**
* Setter del atributo nombreRepresentateLegal.
*
* @param nombreRepresentateLegal el atributo nombreRepresentateLegal a establecer.
*/
    public void setNombreRepresentateLegal(String nombreRepresentateLegal) {
        this.nombreRepresentateLegal = nombreRepresentateLegal;
    }
    
    
    
    /**
* Getter del atributo nombreCliente.
*
* @return el atributo nombreCliente.
*/
    public String getNombreCliente() {
        return nombreCliente;
    }
    
    /**
* Setter del atributo nombreCliente.
*
* @param nombreCliente el atributo nombreCliente a establecer.
*/
    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }
    
    /**
* Getter del atributo numeroCotizacion.
*
* @return el atributo numeroCotizacion.
*/
    public String getNumeroCotizacion() {
        return numeroCotizacion;
    }
    
    /**
* Setter del atributo numeroCotizacion.
*
* @param numeroCotizacion el atributo numeroCotizacion a establecer.
*/
    public void setNumeroCotizacion(String numeroCotizacion) {
        this.numeroCotizacion = numeroCotizacion;
    }
    
    /**
* Getter del atributo nit.
*
* @return el atributo nit.
*/
    public String getNit() {
        return nit;
    }
    
    /**
* Setter del atributo nit.
*
* @param nit el atributo nit a establecer.
*/
    public void setNit(String nit) {
        this.nit = nit;
    }
    
    /**
* Getter del atributo fechaEntradaEvento.
*
* @return el atributo fechaEntradaEvento.
*/
    public String getFechaEntradaEvento() {
        return fechaEntradaEvento;
    }
    
    /**
* Setter del atributo fechaEntradaEvento.
*
* @param fechaEntradaEvento el atributo fechaEntradaEvento a establecer.
*/
    public void setFechaEntradaEvento(String fechaEntradaEvento) {
        this.fechaEntradaEvento = fechaEntradaEvento;
    }
    
    /**
* Getter del atributo fechaSalidaEvento.
*
* @return el atributo fechaSalidaEvento.
*/
    public String getFechaSalidaEvento() {
        return fechaSalidaEvento;
    }
    
    /**
* Setter del atributo fechaSalidaEvento.
*
* @param fechaSalidaEvento el atributo fechaSalidaEvento a establecer.
*/
    public void setFechaSalidaEvento(String fechaSalidaEvento) {
        this.fechaSalidaEvento = fechaSalidaEvento;
    }
    
    /**
* Getter del atributo subtotalConcepts.
*
* @return el atributo subtotalConcepts.
*/
    public String getSubtotalConcepts() {
        Decimal aux = Decimal.valueOf(subtotalConcepts.replace('$', '').replace('.', '').replace(' ', ''));
        return '$ '+String.format(aux.format(), args);
    }
    
    /**
* Setter del atributo subtotalConcepts.
*
* @param subtotalConcepts el atributo subtotalConcepts a establecer.
*/
    public void setSubtotalConcepts(String subtotalConcepts) {
        this.subtotalConcepts = subtotalConcepts;
    }
    
    /**
* Getter del atributo totalPreliquidacion.
*
* @return el atributo totalPreliquidacion.
*/
    public String getTotalPreliquidacion() {
        //return totalPreliquidacion;
        Decimal aux = Decimal.valueOf(totalPreliquidacion.replace('$', '').replace('.', '').replace(' ', ''));
        return '$ '+String.format(aux.format(), args);
    }
    
    /**
* Setter del atributo totalPreliquidacion.
*
* @param totalPreliquidacion el atributo totalPreliquidacion a establecer.
*/
    public void setTotalPreliquidacion(String totalPreliquidacion) {
        this.totalPreliquidacion = totalPreliquidacion;
    }
    
    /**
* Getter del atributo totalServicios.
*
* @return el atributo totalServicios.
*/
    public String getTotalServicios() {
        //return totalServicios;
        Decimal aux = Decimal.valueOf(totalServicios.replace('$', '').replace('.', '').replace(' ', ''));
        return '$ '+String.format(aux.format(), args);
    }
    
    /**
* Setter del atributo totalServicios.
*
* @param totalServicios el atributo totalServicios a establecer.
*/
    public void setTotalServicios(String totalServicios) {
        this.totalServicios = totalServicios;
    }
    
    /**
* Getter del atributo condicionesComerciales.
*
* @return el atributo condicionesComerciales.
*/
    public List<String> getCondicionesComerciales() {
        return condicionesComerciales;
    }
    
    /**
* Setter del atributo condicionesComerciales.
*
* @param condicionesComerciales el atributo condicionesComerciales a establecer.
*/
    public void setCondicionesComerciales(List<String> condicionesComerciales) {
        this.condicionesComerciales = condicionesComerciales;
    }
    
    
    
    /**
* Setter del atributo cancelaciones.
*
* @param canelaciones el atributo cancelaciones a establecer.
*/
    public void setCancelaciones(List<String> cancelaciones) {
        this.cancelaciones = cancelaciones;
    }
    
    /**
* Getter del atributo cancelaciones.
*
* @return el atributo cancelaciones.
*/
    public List<String> getCancelaciones() {
        return cancelaciones;
    }
    
    
    
    /**
* Getter del atributo conceptosCotizacions.
*
* @return el atributo conceptosCotizacions.
*/
    public List<COM_PVE_ConceptosCotizacion_cls> getConceptosCotizacions() {
        return conceptosCotizacions;
    }
    
    /**
* Setter del atributo conceptosCotizacions.
*
* @param conceptosCotizacions el atributo conceptosCotizacions a establecer.
*/
    public void setConceptosCotizacions(List<COM_PVE_ConceptosCotizacion_cls> conceptosCotizacions) {
        this.conceptosCotizacions = conceptosCotizacions;
    }
    
    /**
* Getter del atributo serviciosAdicionales.
*
* @return el atributo serviciosAdicionales.
*/
    public List<COM_PVE_ServiciosAdicionales_cls> getServiciosAdicionales() {
        return serviciosAdicionales;
    }
    
    /**
* Setter del atributo serviciosAdicionales.
*
* @param serviciosAdicionales el atributo serviciosAdicionales a establecer.
*/
    public void setServiciosAdicionales(List<COM_PVE_ServiciosAdicionales_cls> serviciosAdicionales) {
        this.serviciosAdicionales = serviciosAdicionales;
    }
    
    /**
* Getter del atributo serviciosOpcionales.
*
* @return el atributo serviciosOpcionales.
*/
    public List<COM_PVE_ServiciosOpcionales_cls> getServiciosOpcionales() {
        return serviciosOpcionales;
    }
    
    /**
* Setter del atributo serviciosOpcionales.
*
* @param serviciosOpcionales el atributo serviciosOpcionales a establecer.
*/
    public void setServiciosOpcionales(List<COM_PVE_ServiciosOpcionales_cls> serviciosOpcionales) {
        this.serviciosOpcionales = serviciosOpcionales;
    }
    
    
    /**
* Getter del atributo fechaActual.
*
* @return el atributo fechaActual.
*/
    public String getFechaActual() {
        return fechaActual;
    }
    
    /**
* Setter del atributo fechaActual.
*
* @param fechaActual el atributo fechaActual a establecer.
*/
    public void setFechaActual(String fechaActual) {
        this.fechaActual = fechaActual;
    }
    
    /**
* Getter del atributo aplazamientos.
*
* @return el atributo aplazamientos.
*/
    public List<String> getAplazamientos() {
        return aplazamientos;
    }
    
    
    
    /**
* Setter del atributo aplazamientos.
*
* @param aplazamientos el atributo aplazamientos a establecer.
*/
    public void setAplazamientos(List<String> aplazamientos) {
        this.aplazamientos = aplazamientos;
    }
    
    /**
* Setter del atributo subtotalAdicionales.
*
* @param subtotalAdicionales el atributo subtotalAdicionales a establecer.
*/
    public void setSubtotalAdicionales(String subtotalAdicionales) {
        this.subtotalAdicionales = subtotalAdicionales;
    }
    
    /**
* Getter del atributo subtotalAdicionales.
*
* @return el vañor del atributo subtotalAdicionales.
*/
    public String getSubtotalAdicionales() {
        Decimal aux = Decimal.valueOf(subtotalAdicionales.replace('$', '').replace('.', '').replace(' ', ''));
        return '$ '+String.format(aux.format(), args);
        //return subtotalAdicionales;
    }
    
    /**
* Getter del atributo colorTabla.
*
* @return el atributo colorTabla.
*/
    public String getColorTabla() {
        return colorTabla;
    }
    
    
    /**
* Setter del atributo colorTabla.
*
* @param colorTabla el atributo colorTabla a establecer.
*/
    public void setColorTabla(String colorTabla) {
        this.colorTabla = colorTabla;
    }
    
    
    /**
* Getter del atributo colorCajasInfoCia.
*
* @return el atributo colorCajasInfoCia.
*/
    public String getColorCajasInfoCia() {
        return colorCajasInfoCia;
    }
    
    
    /**
* Setter del atributo colorCajasInfoCia.
*
* @param colorCajasInfoCia el atributo colorCajasInfoCia a establecer.
*/
    public void setColorCajasInfoCia(String colorCajasInfoCia) {
        this.colorCajasInfoCia = colorCajasInfoCia;
    }
    
    
    /**
* Getter del atributo menuEspeciales.
*
* @return el atributo menuEspeciales.
*/
    public List<String> getMenuEspeciales() {
        return menuEspeciales;
    }
    
    
    /**
* Setter del atributo menuEspeciales.
*
* @param menuEspeciales el atributo menuEspeciales a establecer.
*/
    public void setMenuEspeciales(List<String> menuEspeciales) {
        this.menuEspeciales = menuEspeciales;
    }
    
    
    /**
* Getter del atributo ofertasDesayuno.
*
* @return el atributo ofertasDesayuno.
*/
    public List<String> getOfertasDesayuno() {
        return ofertasDesayuno;
    }
    
    
    /**
* Setter del atributo ofertasDesayuno.
*
* @param ofertasDesayuno el atributo ofertasDesayuno a establecer.
*/
    public void setOfertasDesayuno(List<String> ofertasDesayuno) {
        this.ofertasDesayuno = ofertasDesayuno;
    }
    
    
    /**
* Getter del atributo labelFechaEntrada.
*
* @return el atributo labelFechaEntrada.
*/
    public String getLabelFechaEntrada() {
        return labelFechaEntrada;
    }
    
    
    /**
* Setter del atributo labelFechaEntrada.
*
* @param labelFechaEntrada el atributo labelFechaEntrada a establecer.
*/
    public void setLabelFechaEntrada(String labelFechaEntrada) {
        this.labelFechaEntrada = labelFechaEntrada;
    }
    
    
    /**
* Getter del atributo lagomar.
*
* @return el atributo lagomar.
*/
    public boolean getLagomar() {
        return lagomar;
    }
    
    
    /**
* Setter del atributo lagomar.
*
* @param lagomar el atributo lagomar a establecer.
*/
    public void setLagomar(boolean lagomar) {
        this.lagomar = lagomar;
    }
    
    
    /**
* Getter del atributo lagosol.
*
* @return el atributo lagosol.
*/
    public boolean getLagosol() {
        return lagosol;
    }
    
    
    /**
* Setter del atributo lagosol.
*
* @param lagosol el atributo lagosol a establecer.
*/
    public void setLagosol(boolean lagosol) {
        this.lagosol = lagosol;
    }
    
    
    /**
* Getter del atributo pasadiaLagomar.
*
* @return el atributo pasadiaLagomar.
*/
    public boolean getPasadiaLagomar() {
        return pasadiaLagomar;
    }
    
    
    /**
* Setter del atributo pasadiaLagomar.
*
* @param pasadiaLagomar el atributo pasadiaLagomar a establecer.
*/
    public void setPasadiaLagomar(boolean pasadiaLagomar) {
        this.pasadiaLagomar = pasadiaLagomar;
    }
    
    /**
* Getter del atributo pasadiaLagosol.
*
* @return el atributo pasadiaLagosol.
*/
    public boolean getPasadiaLagosol() {
        return pasadiaLagosol;
    }
    
    
    /**
* Setter del atributo pasadiaLagosol.
*
* @param pasadiaLagosol el atributo pasadiaLagosol a establecer.
*/
    public void setPasadiaLagosol(boolean pasadiaLagosol) {
        this.pasadiaLagosol = pasadiaLagosol;
    }
    
    
    
    /**
* Getter del atributo fechaEntradaYSalida.
*
* @return el atributo fechaEntradaYSalida.
*/
    public boolean getfechaEntradaYSalida() {
        return fechaEntradaYSalida;
    }
    
    
    /**
* Setter del atributo fechaEntradaYSalida.
*
* @param fechaEntradaYSalida el atributo fechaEntradaYSalida a establecer.
*/
    public void setFechaEntradaYSalida(boolean fechaEntradaYSalida) {
        this.fechaEntradaYSalida = fechaEntradaYSalida;
    }
    
    /**
* Getter del atributo labelSubtotalConceptos.
*
* @return el atributo labelSubtotalConceptos.
*/
    public String getLabelSubtotalConceptos() {
        return labelSubtotalConceptos;
    }
    
    
    
    /**
* Setter del atributo labelSubtotalConceptos.
*
* @param labelSubtotalConceptos el atributo labelSubtotalConceptos a establecer.
*/
    public void setLabelSubtotalConceptos(String labelSubtotalConceptos) {
        this.labelSubtotalConceptos = labelSubtotalConceptos;
    }
    
    
    
    /**
* Getter del atributo mostrarMenuEspeciales.
*
* @return el atributo mostrarMenuEspeciales.
*/
    public boolean isMostrarMenuEspeciales() {
        return mostrarMenuEspeciales;
    }
    
    
    /**
* Setter del atributo mostrarMenuEspeciales.
*
* @param mostrarMenuEspeciales el atributo mostrarMenuEspeciales a establecer.
*/
    public void setMostrarMenuEspeciales(boolean mostrarMenuEspeciales) {
        this.mostrarMenuEspeciales = mostrarMenuEspeciales;
    }
    
    
    /**
* Getter del atributo mostrarOfertasDesayuno.
*
* @return el atributo mostrarOfertasDesayuno.
*/
    public boolean isMostrarOfertasDesayuno() {
        return mostrarOfertasDesayuno;
    }
    
    
    /**
* Setter del atributo mostrarOfertasDesayuno.
*
* @param mostrarOfertasDesayuno el atributo mostrarOfertasDesayuno a establecer.
*/
    public void setMostrarOfertasDesayuno(boolean mostrarOfertasDesayuno) {
        this.mostrarOfertasDesayuno = mostrarOfertasDesayuno;
    }
    
    /**
* Getter del atributo colorTablaServiciosAdicionales.
*
* @return el atributo colorTablaServiciosAdicionales.
*/
    public String getColorTablaServiciosAdicionales() {
        return colorTablaServiciosAdicionales;
    }
    
    
    /**
* Setter del atributo colorTablaServiciosAdicionales.
*
* @param colorTablaServiciosAdicionales el atributo colorTablaServiciosAdicionales a establecer.
*/
    public void setColorTablaServiciosAdicionales(String colorTablaServiciosAdicionales) {
        this.colorTablaServiciosAdicionales = colorTablaServiciosAdicionales;
    }
    
    
    
    
    /**
* @descrition Clase que representa la base de atributos de conceptos.
*/
    public abstract  class COM_PVE_ConceptosBase_cls {
        
        /** El nombre de concepto.**/
        private String nombreConcepto;
        /** El nombre de pax.**/
        private String numeroPax;
        /** El valor por persona.**/
        private String valorPorPersona;
        /** El numero de noches.**/
        private String numeroNoches;
        /** El valor total.**/
        private String valorTotal;
        private String subtotal;
        private String descuento;
        private String descripcion;
        private String duracion;
        private String cantidad;
        private String unidadMedida;
        
        
        
        /**
* Getter del atributo nombreConcepto.
*
* @return el atributo nombreConcepto.
*/
        public String getNombreConcepto() {
            return nombreConcepto;
        }
        public String getSubTotal() {
            return subtotal;
        }
        public String getDescuento() {
            return descuento;
        }
        public String getDescripcion() {
            return descripcion;
        }
        public String getDuracion() {
            return duracion;
        }
        public String getCantidad() {
            return cantidad;
        }
        public String getUnidadMedida() {
            return unidadMedida;
        }
        
        
        /**
* Setter del atributo nombreConcepto.
*
* @param nombreConcepto el atributo nombreConcepto a establecer.
*/
        public void setNombreConcepto(String nombreConcepto) {
            this.nombreConcepto = nombreConcepto;
        }
        public void setSubTotal(String subtotal) {
            this.subtotal = subtotal;
        }
        public void setDescuento(String descuento) {
            this.descuento = descuento;
        }
        public void setDescripcion(String descripcion) {
            this.descripcion = descripcion;
        }
        public void setDuracion(String duracion) {
            this.duracion = duracion;
        }
        public void setCantidad(String cantidad) {
            this.cantidad = cantidad;
        }
        public void setUnidadMedida(String unidadMedida) {
            this.unidadMedida = unidadMedida;
        }
        
        
        
        
        
        /**
* Getter del atributo numeroPax.
*
* @return el atributo numeroPax.
*/
        public String getNumeroPax() {
            return numeroPax;
        }
        
        
        
        
        /**
* Setter del atributo numeroPax.
*
* @param numeroPax el atributo numeroPax a establecer.
*/
        public void setNumeroPax(String numeroPax) {
            this.numeroPax = numeroPax;
        }
        
        
        
        
        /**
* Getter del atributo valorPorPersona.
*
* @return el atributo valorPorPersona.
*/
        public String getValorPorPersona() {
            return valorPorPersona;
        }
        
        
        
        
        /**
* Setter del atributo valorPorPersona.
*
* @param valorPorPersona el atributo valorPorPersona a establecer.
*/
        public void setValorPorPersona(String valorPorPersona) {
            this.valorPorPersona = valorPorPersona;
        }
        
        /**
* Getter del atributo numeroNoches.
*
* @return el atributo numeroNoches.
*/
        public String getNumeroNoches() {
            return numeroNoches;
        }
        
        
        
        
        /**
* Setter del atributo numeroNoches.
*
* @param numeroNoches el atributo numeroNoches a establecer.
*/
        public void setNumeroNoches(String numeroNoches) {
            this.numeroNoches = numeroNoches;
        }
        
        
        /**
* Getter del atributo valorTotal.
*
* @return el atributo valorTotal.
*/
        public String getValorTotal() {
            return valorTotal;
        }
        
        
        /**
* Setter del atributo valorTotal.
*
* @param valorTotal el atributo valorTotal a establecer.
*/
        public void setValorTotal(String valorTotal) {
            this.valorTotal = valorTotal;
        }
        
        
    }
    
    
    /**
* Getter del atributo imagenFirma.
*
* @return el atributo imagenFirma.
*/
    public String getImagenFirma() {
        return imagenFirma;
    }
    
    
    /**
* Setter del atributo imagenFirma.
*
* @param imagenFirma el atributo imagenFirma a establecer.
*/
    public void setImagenFirma(String imagenFirma) {
        this.imagenFirma = imagenFirma;
    }
    
    
    /**
* Getter del atributo labelSubtotalAdicionales.
*
* @return el atributo labelSubtotalAdicionales.
*/
    public String getLabelSubtotalAdicionales() {
        return labelSubtotalAdicionales;
    }
    
    /**
* Setter del atributo labelSubtotalAdicionales.
*
* @param labelSubtotalAdicionales el atributo labelSubtotalAdicionales a establecer.
*/
    public void setLabelSubtotalAdicionales(String labelSubtotalAdicionales) {
        this.labelSubtotalAdicionales = labelSubtotalAdicionales;
    }
    
    /**
* Getter del atributo headerLabelServiciosAdicionales.
*
* @return el atributo headerLabelServiciosAdicionales.
*/
    public String getHeaderLabelServiciosAdicionales() {
        return headerLabelServiciosAdicionales;
    }
    
    
    /**
* Setter del atributo headerLabelServiciosAdicionales.
*
* @param headerLabelServiciosAdicionales el atributo headerLabelServiciosAdicionales a establecer.
*/
    public void setHeaderLabelServiciosAdicionales(String headerLabelServiciosAdicionales) {
        this.headerLabelServiciosAdicionales = headerLabelServiciosAdicionales;
    }
    
    
    /**
* Getter del atributo textCarta.
*
* @return el atributo textCarta.
*/
    public String getTextCarta() {
        return textCarta;
    }
    
    /**
* Setter del atributo textCarta.
*
* @param textCarta el atributo textCarta a establecer.
*/
    public void setTextCarta(String textCarta) {
        this.textCarta = textCarta;
    }
    
    
    
    
    /**
* @descrition Clase que representa los conceptos de cotizacion.
*/
    public class COM_PVE_ConceptosCotizacion_cls extends COM_PVE_ConceptosBase_cls {
        
    }
    
    /**
* @descrition Clase que representa los servicios adicionales.
*/
    public class COM_PVE_ServiciosAdicionales_cls extends COM_PVE_ConceptosBase_cls {
        
    }
    
    /**
* @descrition Clase que representa los servicios opcionales.
*/
    public class COM_PVE_ServiciosOpcionales_cls extends COM_PVE_ConceptosBase_cls {
        
    }
    
    public class applicationException extends Exception {}
    
}