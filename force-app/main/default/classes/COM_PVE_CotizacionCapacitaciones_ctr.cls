/*
 * Created by AVX_RSuarez on 23/10/2017.
*/

public class COM_PVE_CotizacionCapacitaciones_ctr extends COM_BaseCotizacionSalud_ctr {
    public CotizacionCapacitaciones__mdt contenido {get;set;}
    public COM_PVE_CotizacionCapacitaciones_ctr() {
        super(ApexPages.currentPage().getParameters().get('IdCustomObject'), 'CotizacionCapacitaciones__mdt'); 
        contenido = (CotizacionCapacitaciones__mdt) cargarContenidoMetadata('CotizacionCapacitaciones__mdt');
    }
}