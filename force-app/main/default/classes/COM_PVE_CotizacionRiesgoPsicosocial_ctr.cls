/*
 * Created by AVX_RSuarez on 23/10/2017.
*/

public class COM_PVE_CotizacionRiesgoPsicosocial_ctr extends COM_BaseCotizacionSalud_ctr {
	public CotizacionRiesgoPsicosocial__mdt contenido {get;set;}
	public COM_PVE_CotizacionRiesgoPsicosocial_ctr() {
        super(ApexPages.currentPage().getParameters().get('IdCustomObject'), 'CotizacionRiesgoPsicosocial__mdt'); 
        contenido = (CotizacionRiesgoPsicosocial__mdt) cargarContenidoMetadata('CotizacionRiesgoPsicosocial__mdt');
    }
}