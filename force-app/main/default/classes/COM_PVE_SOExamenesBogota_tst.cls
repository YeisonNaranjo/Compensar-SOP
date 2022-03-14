/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de ejecutar  las pruebas unitarias de la clase
*                   COM_PVE_SOExamenesBogota_ctr
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_PVE_SOExamenesBogota_tst {

    /**
     * Instancia del controlador.
     */
     private static COM_PVE_SOExamenesBogota_ctr ppp =
     new COM_PVE_SOExamenesBogota_ctr();

    /**
     * Metodo encargado probal el metodo de cargar los datos.
     */
     @istest
     public static void testCargarDatos() {
        ppp.cargarDatos();
    }

    @istest
    public static void testCargarDatos2() {
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
        ppp.getDespedida();
        ppp.setDespedida('');
        ppp.getVigenciaTarifas();
        ppp.setVigenciaTarifas('');
        ppp.getTituloUno();
        ppp.setTituloUno('');
        ppp.getTituloDos();
        ppp.setTituloDos('');
        ppp.getTituloDosA();
        ppp.setTituloDosA(''); 
        ppp.getTituloDosB();
        ppp.setTituloDosB('');
        ppp.getValorTotal();
        ppp.setValorTotal(1);
        ppp.getTituloTablaDosColumnaUno();
        ppp.setTituloTablaDosColumnaUno('');
        ppp.getTituloTablaDosColumnaDos();
        ppp.setTituloTablaDosColumnaDos('');
        ppp.getTituloTablaDosColumnaTres();
        ppp.setTituloTablaDosColumnaTres('');
        ppp.getValorTablaDosColumnaUnoFilaUno();
        ppp.setValorTablaDosColumnaUnoFilaUno('');
        ppp.getValorTablaDosColumnaUnoFilaDos();
        ppp.setValorTablaDosColumnaUnoFilaDos('');
        ppp.getValorTablaDosColumnaUnoFilaTres();
        ppp.setValorTablaDosColumnaUnoFilaTres('');
        ppp.getValorTablaDosColumnaUnoFilaCuatro();
        ppp.setValorTablaDosColumnaUnoFilaCuatro('');
        ppp.getValorTablaDosColumnaDosFilaUno();
        ppp.setValorTablaDosColumnaDosFilaUno('');
        ppp.getValorTablaDosColumnaDosFilaDos();
        ppp.setValorTablaDosColumnaDosFilaDos('');
        ppp.getValorTablaDosColumnaDosFilaTres();
        ppp.setValorTablaDosColumnaDosFilaTres('');
        ppp.getValorTablaDosColumnaDosFilaCuatro();
        ppp.setValorTablaDosColumnaDosFilaCuatro('');
        ppp.getValorTablaDosColumnaTresFilaUno();
        ppp.setValorTablaDosColumnaTresFilaUno('');
        ppp.getValorTablaDosColumnaTresFilaDos();
        ppp.setValorTablaDosColumnaTresFilaDos('');
        ppp.getValorTablaDosColumnaTresFilaTres();
        ppp.setValorTablaDosColumnaTresFilaTres('');
        ppp.getValorTablaDosColumnaTresFilaCuatro();
        ppp.setValorTablaDosColumnaTresFilaCuatro('');
        ppp.getTituloTres(); 
        ppp.setTituloTres('');
        ppp.getTituloCuatro(); 
        ppp.setTituloCuatro('');
        ppp.getSeccionUno();
        ppp.setSeccionUno(''); 
        ppp.getSeccionDos();
        ppp.setSeccionDos(''); 
        ppp.getSeccionTres();
        ppp.setSeccionTres('');
        ppp.getSeccionCuatro(); 
        ppp.setSeccionCuatro('');
        ppp.setTituloServiciosGenerales('');
        ppp.getTituloServiciosGenerales();
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
        ppp.getYear();
        ppp.getFechaActual();
        ppp.setFechaActual('');
        ppp.getServiciosGeneralesPrograma();
        ppp.setServiciosGeneralesPrograma(new List<String>());
        ppp.setItemsPropuestaEconomica(new List<COM_PVE_SOExamenesBogota_ctr.COM_PVEPropuestaEconomica_cls>());
        ppp.getItemsPropuestaEconomica();
        ppp.setModalidadesCompensar(new List<String>());
        ppp.getModalidadesCompensar();
        ppp.setConfirmacionServicio(new List<String>());
        ppp.getConfirmacionServicio();
    }

    @istest
    public static void testCargarDatos3() {
        COM_PVE_SOExamenesBogota_ctr.COM_PVEPropuestaEconomica_cls pap = new COM_PVE_SOExamenesBogota_ctr.COM_PVEPropuestaEconomica_cls();
        pap.getCategoria();
        pap.setCategoria('');
        pap.getSubCategoria();
        pap.setSubCategoria('');
        pap.getValor();
        pap.setValor(1);
        pap.getProducto();
        pap.setProducto('');
        pap.getDescripcion();
        pap.setDescripcion('');
        pap.getSubvalor();
        pap.setSubvalor(1);
        pap.getDescuento();
        pap.setDescuento(1);
    }


}