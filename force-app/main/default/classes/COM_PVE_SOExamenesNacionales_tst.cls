/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensor
* Description:		Clase encargada de ejecutar  las pruebas unitarias de la clase
*                   COM_PVE_SOExamenesNacionales_ctr
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_PVE_SOExamenesNacionales_tst {

     /**
     * Instancia del controlador.
     */
     private static COM_PVE_SOExamenesNacionales_ctr controller =
     new COM_PVE_SOExamenesNacionales_ctr();

    /**
     * Metodo encargado probal el metodo de cargar los datos.
     */
     @istest
     public static void testCargarDatos() {
        controller.cargarDatos();
    }


    @istest
    public static void testCargarDatos2() {
        COM_PVE_SOExamenesNacionales_ctr ppp = new COM_PVE_SOExamenesNacionales_ctr();

        ppp.getValorTotal();
        ppp.setValorTotal(1);
        ppp.getSaludo();
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
        ppp.getTituloTres();
        ppp.setTituloTres('');
        ppp.getSeccionUno();
        ppp.setSeccionUno('');
        ppp.getSeccionDos();
        ppp.setSeccionDos('');
        ppp.getSeccionTres();
        ppp.setSeccionTres('');
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
        ppp.getTituloTablaUnoColumnaSeis();
        ppp.setTituloTablaUnoColumnaSeis('');
        ppp.getCiudadGeneracion();
        ppp.setCiudadGeneracion('');
        ppp.getCiudad();
        ppp.setCiudad('');
        ppp.getSaludoCliente();
        ppp.setSaludoCliente('');
        ppp.getNombreCliente();
        ppp.setNombreCliente('');
        ppp.getServiciosGeneralesPrograma();
        ppp.setServiciosGeneralesPrograma(new List<String>());
        ppp.getItemsPropuestaEconomica();
        ppp.setItemsPropuestaEconomica(new List<COM_PVE_SOExamenesNacionales_ctr.COM_PVEPropuestaEconomica_cls>()); 
        ppp.getEspecificacionesServicio();
        ppp.setEspecificacionesServicio(new List<String>());
        ppp.getConfirmacionServicio();
        ppp.setConfirmacionServicio(new List<String>());
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
        ppp.getYear();

    }

    @istest
    public static void testCargarDatos3() {
       COM_PVE_SOExamenesNacionales_ctr.COM_PVEPropuestaEconomica_cls ppp = new COM_PVE_SOExamenesNacionales_ctr.COM_PVEPropuestaEconomica_cls(); 
       ppp.getCategoria();
       ppp.setCategoria('');
       ppp.getSubCategoria();
       ppp.setSubCategoria('');
       ppp.getValor();
       ppp.setValor(1);
       ppp.getProducto();
       ppp.setProducto('');
       ppp.getDescripcion();
       ppp.setDescripcion('');
       ppp.getSubvalor();
       ppp.setSubvalor(1);
       ppp.getDescuento();
       ppp.setDescuento(1);
   }



}