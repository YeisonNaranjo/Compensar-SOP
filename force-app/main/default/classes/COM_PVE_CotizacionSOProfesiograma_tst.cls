/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de ejecutar  las pruebas unitarias de la clase
*                   COM_PVE_CotizacionSOProfesiograma_ctr
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_PVE_CotizacionSOProfesiograma_tst {

    /**
     * Instancia del controlador.
     */
    private static COM_PVE_CotizacionSOProfesiograma_ctr ppp =
            new COM_PVE_CotizacionSOProfesiograma_ctr();

    /**
     * Metodo encargado probal el metodo de cargar los datos.
     */
    @istest
    public static void testCargarDatos() {
        ppp.cargarDatos();
         ppp.getSaludo();
        ppp.setSaludo('');
        ppp.getParrafoUno();
        ppp.setParrafoUno('');
        ppp.getParrafoDos();
        ppp.setParrafoDos('');
        ppp.getParrafoTres();
        ppp.setParrafoTres('');
        ppp.getParrafoCuatro();
        ppp.setParrafoCuatro('');
        ppp.getParrafoCinco();
        ppp.setParrafoCinco('');
        ppp.getParrafoSeis();
        ppp.setParrafoSeis('');
        ppp.getParrafoSiete();
        ppp.setParrafoSiete('');
        ppp.getParrafoOcho();
        ppp.setParrafoOcho('');
        ppp.getParrafoNueve();
        ppp.setParrafoNueve('');
        ppp.getParrafoDiez();
        ppp.setParrafoDiez('');
        ppp.getParrafoOnce();
        ppp.setParrafoOnce('');
        ppp.getDespedida();
        ppp.setDespedida('');
        ppp.getTituloUno();
        ppp.setTituloUno('');
        ppp.getTituloDos();
        ppp.setTituloDos('');
        ppp.getValorTotal();
        ppp.setValorTotal(1);
        ppp.getTituloTres(); 
        ppp.setTituloTres('');
        ppp.getSeccionUno();
        ppp.setSeccionUno(''); 
        ppp.getSeccionCuatro(); 
        ppp.setSeccionCuatro('');
        ppp.getTituloTablaUnoColumnaUno();
        ppp.setTituloTablaUnoColumnaUno('');
        ppp.getTituloTablaUnoColumnaDos();
        ppp.setTituloTablaUnoColumnaDos('');
        ppp.getTituloTablaUnoColumnaTres();
        ppp.setTituloTablaUnoColumnaTres('');
        ppp.getTituloTablaUnoColumnaCuatro();
        ppp.setTituloTablaUnoColumnaCuatro('');
        ppp.getTituloTablaUnoColumnaCinco();
        ppp.setTituloTablaUnoColumnaCinco('');
        ppp.getCiudadGeneracion();
        ppp.setCiudadGeneracion('');
        ppp.getCiudad();
        ppp.setCiudad('');
        ppp.getSaludoCliente();
        ppp.setSaludoCliente('');
        ppp.getNombreCliente();
        ppp.setNombreCliente('');
        ppp.getEspecificacionesServicio();
        ppp.setEspecificacionesServicio(new List<String>());
        ppp.getNombreAsesor();
        ppp.setNombreAsesor('');
        ppp.getCargoAsesor();
        ppp.setCargoAsesor('');
        ppp.getEmailAsesor();
        ppp.setEmailAsesor('');
        ppp.getTelefonoAsesor();
        ppp.setTelefonoAsesor('');
        ppp.getProcesoAsesor();
        ppp.setProcesoAsesor('');
        ppp.getFechaActual();
        ppp.setFechaActual('');
        ppp.getServiciosGeneralesPrograma();
        ppp.setServiciosGeneralesPrograma(new List<String>());
        ppp.setItemsPropuestaEconomica(new List<COM_PVE_CotizacionSOProfesiograma_ctr.COM_PVEPropuestaEconomica_cls>());
        ppp.getItemsPropuestaEconomica();
        ppp.getValorTablaUnoColumnaUno(); 
        ppp.setValorTablaUnoColumnaUno('');
        ppp.getValorTablaUnoColumnaDos();
        ppp.setValorTablaUnoColumnaDos('');
        ppp.getValorTablaUnoColumnaTres();
        ppp.setValorTablaUnoColumnaTres('');
        ppp.getValorTablaUnoColumnaCuatro();
        ppp.setValorTablaUnoColumnaCuatro('');
        ppp.getValorTablaUnoColumnaCinco();
        ppp.setValorTablaUnoColumnaCinco('');
        ppp.getTarifasVigentes();
        ppp.setTarifasVigentes('');


    }

    @istest
    public static void testCargarDatos1() {
        COM_PVE_CotizacionSOProfesiograma_ctr.COM_PVEPropuestaEconomica_cls ppp1 = new COM_PVE_CotizacionSOProfesiograma_ctr.COM_PVEPropuestaEconomica_cls(); 
        ppp1.getCategoria();
        ppp1.setCategoria('');
        ppp1.getSubCategoria();
        ppp1.setSubCategoria('');
        ppp1.getValor();
        ppp1.setValor(1);
        ppp1.getProducto();
        ppp1.setProducto('');
        ppp1.getDescripcion();
        ppp1.setDescripcion('');
        ppp1.getSubvalor();
        ppp1.setSubvalor(1);
        ppp1.getDescuento();
        ppp1.setDescuento(1);
    }
}