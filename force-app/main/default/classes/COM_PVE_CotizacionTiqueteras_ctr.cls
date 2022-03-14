/*
 * Created by AVX_RSuarez on 23/10/2017.
*/

public class COM_PVE_CotizacionTiqueteras_ctr extends COM_BaseCotizacionSalud_ctr {
	public CotizacionTiqueteras__mdt contenido {get;set;}
    public COM_PVE_CotizacionTiqueteras_ctr() {
        super(ApexPages.currentPage().getParameters().get('IdCustomObject'), 'CotizacionTiqueteras__mdt'); 
        contenido = (CotizacionTiqueteras__mdt) cargarContenidoMetadata('CotizacionTiqueteras__mdt');
    }
}