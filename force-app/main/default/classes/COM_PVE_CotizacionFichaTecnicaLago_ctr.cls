/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada implementar los metodos de eventos de interface grafica de usuario
*                   para las cotizaciones de Ficha Técnica de alojamiento
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-08-14      Rubén Suárez Forero (RUSF)      Creación clase.
* @version  1.1     2018-01-18      Carlos Villalba (CAV)           ajuste para que tenga en cuenta los descuentos NOLA 2442 
* @version  1.2     11/04/2018      Brisleydi Calderon(BC)          Validar si el producto tiene descuento y de ser asi, mostrar campo de "Precio_de_Venta_con_Descuento__c".
*************************************************************************************************************/

public class COM_PVE_CotizacionFichaTecnicaLago_ctr {
    
    public String strBody;
    public Account accCliente {get;set;}
    public COM_FichaTecnica__mdt ftCondiciones {get;set;}
    public String condReservaciones {get;set;}
    public String condPagoAnticipado {get;set;}
    public String condCancelacion {get;set;}
    public String condAplazamientos {get;set;}
    public String condServicio {get;set;}
    public String condAceptacion {get;set;}
    public List<String> lstColumnas {get;set;}
    
    public AccountContactRelation conContacto {get;set;}
    public Opportunity oppOportunidad {get;set;}
    public List<OpportunityLineItem> pliProductos {get;set;}
    public String strOperador {get;set;}
    public String strServicios {get;set;}
    public String strAlojamiento {get;set;}
    public List<COM_CuentasFacturacionPorOportunidades__c> cfoFacturacion {get;set;}
    public Map<Date,List<OpportunityLineItem>> mapAlojamiento {get;set;}
    public Map<Date,Decimal> mapAlojamientoValor {get;set;}
    public List<OpportunityLineItem> lstServicios {get;set;}
    public List<OpportunityLineItem> lstEventoActividad {get;set;}
    public List<AccountContactRelation> lstCon {get;set;}

    public Decimal decSubTotalServicio {get;set;}
    public Decimal decSubTotalEventoActividad {get;set;}
    public Decimal decTotalEvento {get;set;}
    public String strMinutograma {get;set;}
    public Decimal descuento {get;set;}
     

    public COM_PVE_CotizacionFichaTecnicaLago_ctr(Apexpages.Standardcontroller objStandardController){
        
        Integer intCols = 0;
        condReservaciones = '';
        condPagoAnticipado = '';
        condCancelacion = '';
        condAplazamientos = '';
        condServicio = '';
        condAceptacion = '';
        lstColumnas = new List<String>();
        accCliente = new Account();
        conContacto = new AccountContactRelation();
        oppOportunidad = new Opportunity(); 
        pliProductos = new List<OpportunityLineItem>();
        strOperador = '';
        strServicios = '';
        strAlojamiento = '';
        cfoFacturacion = new List<COM_CuentasFacturacionPorOportunidades__c>();
        mapAlojamiento = new Map<Date,List<OpportunityLineItem>>();
        mapAlojamientoValor = new Map<Date,Decimal>();
        lstCon = new List<AccountContactRelation>();
        lstServicios = new List<OpportunityLineItem>();
        lstEventoActividad = new List<OpportunityLineItem>();
        decSubTotalServicio = 0;
        decSubTotalEventoActividad = 0;
        decTotalEvento = 0;
        strMinutograma = null;
        ftCondiciones = new COM_FichaTecnica__mdt();
        descuento = 0;

         

        while(intCols < 54 ){
            lstColumnas.add('');
            intCols ++;
        }
        String opp = ApexPages.currentPage().getParameters().get('IdCustomObject');
        //System.debug('***WA*** =====>>> opp \n'+opp);
        mapCampos(opp);
        
    }   

    public void mapCampos(String idOportunidad){        
        oppOportunidad = [SELECT COM_IdOportunidad__c, COM_ClaseEvento__c, COM_Descripcionoportunidad__c, AccountId,
                        COM_Operador__r.Name, RecordType.DeveloperName, Amount, COM_Minutograma__c, Contacto__r.Name
                        FROM Opportunity WHERE Id = :idOportunidad];
        accCliente = [SELECT Id, Name, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c, COM_Direccion__c, Phone, COM_EstadoAcompanamiento__c, COM_TipoCliente__c, COM_Digitoverificacion__c, COM_Ciudad__r.Name, tolabel(COM_Estadoafiliacion__c) FROM Account WHERE Id = :oppOportunidad.AccountId];
            
        strMinutograma = oppOportunidad.COM_Minutograma__c;
        
        strMinutograma = String.isNotBlank(strMinutograma)?strMinutograma.replaceAll('colspan="1" rowspan="1"', ''):'';
        
        
        lstCon = [SELECT Contact.Name FROM AccountContactRelation WHERE AccountId =:accCliente.Id AND IsActive = true];
        
        if(lstCon.size() > 0)
            conContacto = lstCon.get(0);
        else
            conContacto = NULL;
        pliProductos = [SELECT Id,discount,COM_FechaHoraInicio__c, COM_FechaHoraFinalizacion__c, COM_Actividad__c, tolabel(COM_Escenario__c), COM_Montaje__c, Quantity, 
                        UnitPrice,Precio_de_Venta_con_Descuento__c, ListPrice, TotalPrice, Product2.Name, Product2.COM_Grupo__c, COM_NoPax__c, COM_NumeroHabitaciones__c, Product2.COM_Ciclo__c,
                        Product2.RecordType.DeveloperName, Product2.Description, COM_CantidadAnterior__c
                        FROM OpportunityLineItem WHERE OpportunityId =:oppOportunidad.Id AND Product2.Family != :System.Label.COM_PVE_FamiliaS_P];

        cfoFacturacion = [SELECT COM_CuentaFacturadora__r.Name, COM_NIT__c, COM_CuentaFacturadora__r.COM_Digitoverificacion__c, COM_Direccion__c, COM_Telefono__c, COM_FormaPago__c, COM_ValorPagado__c, COM_NombreQuienRecibeFactura__c, COM_CorreoElectronicoFactura__c, COM_Concepto__c
                        FROM COM_CuentasFacturacionPorOportunidades__c WHERE COM_Oportunidad__c =:oppOportunidad.Id];
        
		
        for(OpportunityLineItem producto : pliProductos){
			descuento =0;
            if(producto.Product2.RecordType.DeveloperName == 'COM_Alojamiento'){
                try{
                    Date fechaIni = producto.COM_FechaHoraInicio__c.date();
                    Date fechaFin = producto.COM_FechaHoraFinalizacion__c.date();
                    while(fechaIni <= fechaFin){
                        if(mapAlojamiento.containsKey(fechaIni)){
                            mapAlojamiento.get(fechaIni).add(producto);
                            //CAV --> 30-01-2018 Inicio
                            // CAV mapAlojamientoValor.put(fechaIni, mapAlojamientoValor.get(fechaIni) + producto.UnitPrice*producto.COM_CantidadAnterior__c);
                            
                            descuento = producto.discount!=null?producto.discount:0;
                            
                            mapAlojamientoValor.put(fechaIni, mapAlojamientoValor.get(fechaIni) + (producto.UnitPrice*producto.COM_CantidadAnterior__c*(100-descuento)/100));
                        } else {
                        	descuento = producto.discount!=null?producto.discount:0;
                            mapAlojamiento.put(fechaIni,new List<OpportunityLineItem>());
                            mapAlojamiento.get(fechaIni).add(producto);
                            //CAV mapAlojamientoValor.put(fechaIni, producto.TotalPrice);
                            mapAlojamientoValor.put(fechaIni, producto.UnitPrice*producto.COM_CantidadAnterior__c*(100-descuento)/100);
                            //CAV --> 30-01-2018 FIN
                        }
                        fechaIni = fechaIni.addDays(1);
                    }
                } catch(Exception e){
                    System.debug('producto de alojamiento sin fechas.');
                }
            }

            if(producto.Product2.RecordType.DeveloperName == 'COM_Adicionales'){
                lstServicios.add(producto);
                decSubTotalServicio+=producto.TotalPrice;
            }

            if(producto.COM_Actividad__c != null && producto.COM_Escenario__c != null && producto.COM_Montaje__c != null){
                lstEventoActividad.add(producto);
                decSubTotalEventoActividad+=producto.TotalPrice;
            }
        }

        for(Decimal valor: mapAlojamientoValor.values()){
            decTotalEvento += valor;
        }
        decTotalEvento += decSubTotalServicio+decSubTotalEventoActividad;
        try {
        ftCondiciones = [SELECT COM_Reservaciones__c, COM_PagoAnticipado__c, COM_Cancelacion__c, 
            COM_Aplazamientos__c, COM_ServicioYConfirmacion__c, COM_Aceptacion__c
            FROM COM_FichaTecnica__mdt 
            WHERE DeveloperName =:oppOportunidad.COM_Operador__r.Name.toUpperCase()];
        } catch(NullPointerException e){
            e.getMessage();
        }
        condReservaciones   = ftCondiciones.COM_Reservaciones__c;
        condPagoAnticipado  = ftCondiciones.COM_PagoAnticipado__c;
        condCancelacion     = ftCondiciones.COM_Cancelacion__c;
        condAplazamientos   = ftCondiciones.COM_Aplazamientos__c;
        condServicio        = ftCondiciones.COM_ServicioYConfirmacion__c;
        condAceptacion      = ftCondiciones.COM_Aceptacion__c;

    } 
}