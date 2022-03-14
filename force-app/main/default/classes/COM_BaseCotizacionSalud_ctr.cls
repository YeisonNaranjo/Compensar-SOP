/*
 * Created by AVX_RSuarez on 23/10/2017.
 * Versión   Consultor                 Fecha
 * 1.1       Stifen Panche(SP)         16/03/2018            
*/

public virtual class COM_BaseCotizacionSalud_ctr {
    protected String idQuote;
    protected String objetoMetadata;
    private Opportunity objOportunidad;
    //private AccountContactRelation objContacto;
    //Inicio 1.1
    private List <AccountContactRelation> objContacto;
    //Fin 1.1
    private User objUser;
    //Variables contenido carta    
    public String fecha {get;set;}
    public String clienteNombre {get;set;}
    public String clienteContacto {get;set;}
    public String clienteCargo {get;set;}
    public String asesorNombre {get;set;}
    public String asesorCargo {get;set;}
    public String asesorProceso {get;set;}
    public String asesorCelular {get;set;}
    public String asesorCorreo {get;set;}  
    public Decimal valorTotal {get;set;}  
    //Variables contenido Metadata    
    public List<productoPropuesta> lstProductosPropuesta {get;set;}

	public COM_BaseCotizacionSalud_ctr(String idQuote, String objetoMetadata) {
        this.idQuote = idQuote;
        this.objetoMetadata = objetoMetadata;
        Quote objCotizacion = [SELECT OpportunityId FROM Quote WHERE Id =:this.idQuote];
        objOportunidad = [SELECT Id, Account.Name, Contacto__c, Contacto__r.Name, OwnerId, Owner.FirstName, Owner.LastName, Owner.MobilePhone, Owner.Email, Owner.Title
            FROM Opportunity    
            WHERE Id =: objCotizacion.OpportunityId];
        objUser = [SELECT Department FROM User WHERE Id =:objOportunidad.OwnerId];            
        objContacto = [SELECT COM_CargoEmpresa__c 
            FROM AccountContactRelation 
            WHERE AccountId =:objOportunidad.AccountId AND ContactId =:objOportunidad.Contacto__c];
        cargarContenidoCarta();
        cargarContenidoPropuesta();        
    }

    public void cargarContenidoCarta(){
        clienteNombre = objOportunidad.Account.Name;
        clienteContacto = objOportunidad.Contacto__r.Name;
        //clienteCargo = objContacto.COM_CargoEmpresa__c;
        //Inicio 1.1
        if(!objContacto.isEmpty() && objContacto != null)
        {
        clienteCargo = objContacto[0].COM_CargoEmpresa__c;
        }
        //Fin 1.1
        asesorNombre = objOportunidad.Owner.FirstName+' '+objOportunidad.Owner.LastName;
        asesorCargo = objOportunidad.Owner.Title;
        asesorProceso = objUser.Department;
        asesorCelular = objOportunidad.Owner.MobilePhone;
        asesorCorreo = objOportunidad.Owner.Email;
        fecha = ', '+COM_Utilidades_cls.obtenerMes(Date.Today().month())+' '+String.valueOf(Date.Today().day())+' de '+String.valueOf(Date.Today().year());
    }

    public SObject cargarContenidoMetadata(String objetoMetadata){
        List<String> lstCampos = new List<String>();
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objetoMetadata).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){
                Schema.DescribeFieldResult fd = ft.getDescribe();
                lstCampos.add(String.valueOf(fd.getSobjectField()));
            }
        }
        String query = 'SELECT '+string.join(lstCampos,',')+' FROM '+objetoMetadata;
        List<Object> lstContenido = Database.query(query);
        if(objetoMetadata == 'CotizacionRiesgoPsicosocial__mdt')
            return (CotizacionRiesgoPsicosocial__mdt) lstContenido.get(0);
        else if(objetoMetadata == 'CotizacionCapacitaciones__mdt')
            return (CotizacionCapacitaciones__mdt) lstContenido.get(0);
        else if(objetoMetadata == 'CotizacionTiqueteras__mdt')
            return (CotizacionTiqueteras__mdt) lstContenido.get(0);
        return null;       
    }

    public void cargarContenidoPropuesta(){
        list<OpportunityLineItem> lstProdPorOportunidad = [SELECT id, Product2.Name, Product2.Description, Subtotal, Discount, TotalPrice,
            Quantity, Product2.COM_TipoPoblacion__c, UnitPrice
            FROM OpportunityLineItem
            WHERE OpportunityId =: objOportunidad.Id AND Product2.Family != :Label.RF2_FamiliaProductosPyS]; 
        lstProductosPropuesta = new List<productoPropuesta>();
        valorTotal = 0;
        for(OpportunityLineItem oli : lstProdPorOportunidad){
            productoPropuesta producto = new productoPropuesta();
            producto.nombre = oli.Product2.Name;
            producto.descripcion = oli.Product2.Description;
            producto.subtotal = oli.Subtotal;
            producto.descuento = oli.Discount!=null?oli.Discount:0;
            producto.total = oli.TotalPrice;
            producto.nopax = oli.Quantity;
            producto.poblacion = oli.Product2.COM_TipoPoblacion__c;
            producto.unitario = oli.UnitPrice;
            lstProductosPropuesta.add(producto);
            valorTotal += oli.TotalPrice;
        }
    } 

    public class productoPropuesta{
        public String nombre {get;set;}
        public String descripcion {get;set;}
        public Decimal nopax {get;set;}
        public String poblacion {get;set;}
        public Decimal unitario {get;set;}
        public Decimal subtotal {get;set;}
        public Decimal descuento {get;set;}
        public Decimal total {get;set;}
    }
}