/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de ejecutar  las pruebas unitarias de la clase
*                  COM_PVECotizacionChequeosMedicos_ctr
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_PVECotizacionChequeosMedicos_tst {



    /**
     * Metodo encargado probal el metodo de cargar los datos.
     */
     @istest
     public static void testCargarDatos() {

        COM_PVECotizacionChequeosMedicos_ctr ppp = new COM_PVECotizacionChequeosMedicos_ctr();
        ppp.getSaludo();
        ppp.setSaludo('');
        ppp.getParrafoUno();
        ppp.setParrafoUno('');
        ppp.getParrafoDos();
        ppp.setParrafoDos('');
        ppp.getParrafoTres();
        ppp.setParrafoTres('');
        
        ppp.getDespedida();
        ppp.setDespedida('');
        ppp.getTituloUno();
        ppp.setTituloUno('');
        ppp.getValorTotal();
        ppp.setValorTotal(1);
        ppp.getTituloDos();
        ppp.setTituloDos('');
        ppp.getTituloTres();
        ppp.setTituloTres('');
        ppp.getTituloCuatro();
        ppp.setTituloCuatro('');


        ppp.getTituloTablaUnoColumnaUno();
        ppp.setTituloTablaUnoColumnaUno('');
        ppp.getTituloTablaUnoColumnaDos();
        ppp.setTituloTablaUnoColumnaDos('');
        ppp.getTituloTablaUnoColumnaTres();
        ppp.setTituloTablaUnoColumnaTres('');
        ppp.getTituloTablaUnoColumnaCuatro();
        ppp.setTituloTablaUnoColumnaCuatro('');
        ppp.getNombreCliente();
        ppp.setNombreCliente('');
        ppp.getItemsPropuestaEconomica();
        ppp.setItemsPropuestaEconomica(new List<COM_PVECotizacionChequeosMedicos_ctr.COM_PVEPropuestaEconomica_cls>());

        
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

        COM_PVECotizacionChequeosMedicos_ctr.COM_PVEPropuestaEconomica_cls p2 = new COM_PVECotizacionChequeosMedicos_ctr.COM_PVEPropuestaEconomica_cls();
        p2.getCategoria();
        p2.setCategoria('');
        p2.getSubCategoria();
        p2.setSubCategoria('');
        p2.getValor();
        p2.setValor(1);
        p2.getProducto();
        p2.setProducto('');
        p2.getDescripcion();
        p2.setDescripcion('');
        p2.getSubvalor();
        p2.setSubvalor(1);
        p2.getDescuento();
        p2.setDescuento(1);

        ppp.getTituloCinco();
        ppp.setTituloCinco('');
        ppp.getTituloSeis();
        ppp.setTituloSeis('');
        ppp.getTituloTablaDosColumnaUno();
        ppp.setTituloTablaDosColumnaUno('');
        ppp.getTituloTablaTresColumnaUno();
        ppp.setTituloTablaTresColumnaUno('');
        ppp.getBeneficios();
        ppp.setBeneficios('');
        ppp.getRecomendaciones();
        ppp.setRecomendaciones('');
        ppp.getListaBeneficios();
        ppp.setListaBeneficios(new List<String>());
        ppp.getListaRecomendaciones();
        ppp.setListaRecomendaciones(new List<String>());
        ppp.getTituloTablaUnoSeccionUno() ;
        ppp.setTituloTablaUnoSeccionUno('');
        ppp.getTituloTablaUnoSeccionDos();
        ppp.setTituloTablaUnoSeccionDos('');
        ppp.getTituloTablaUnoSeccionTres();
        ppp.setTituloTablaUnoSeccionTres('');
        ppp.getTituloTablaUnoSeccionCuatro();
        ppp.setTituloTablaUnoSeccionCuatro('');
        ppp.getTituloTablaUnoSeccionCinco();
        ppp.setTituloTablaUnoSeccionCinco('');
        ppp.getTituloTablaUnoSeccionSeis();
        ppp.setTituloTablaUnoSeccionSeis('');
        ppp.getTituloTablaUnoSeccionSiete();
        ppp.setTituloTablaUnoSeccionSiete('');
        ppp.getTituloTablaUnoSeccionOcho();
        ppp.getTituloTablaUnoSeccionNueve();
        ppp.setTituloTablaUnoSeccionNueve('');
        ppp.getTituloTablaUnoSeccionDiez();
        ppp.setTituloTablaUnoSeccionDiez('');
        ppp.getValoresTablaUnoSeccionUno();
        ppp.setValoresTablaUnoSeccionUno('');
        ppp.getValoresTablaUnoSeccionDos();
        ppp.setValoresTablaUnoSeccionDos('');
        ppp.getValoresTablaUnoSeccionTres();
        ppp.setValoresTablaUnoSeccionTres('');
        ppp.getValoresTablaUnoSeccionCuatro();
        ppp.setValoresTablaUnoSeccionCuatro('');
        ppp.getValoresTablaUnoSeccionCinco();
        ppp.setValoresTablaUnoSeccionCinco('');
        ppp.getValoresTablaUnoSeccionSeis();
        ppp.setValoresTablaUnoSeccionSeis('');
        ppp.getValoresTablaUnoSeccionSiete();
        ppp.setValoresTablaUnoSeccionSiete('');
        ppp.getValoresTablaUnoSeccionOcho();
        ppp.setValoresTablaUnoSeccionOcho('');
        ppp.getValoresTablaUnoSeccionNueve();
        ppp.setValoresTablaUnoSeccionNueve('');
        ppp.getValoresTablaUnoSeccionDiez();
        ppp.setValoresTablaUnoSeccionDiez('');
        ppp.getListaSeccionUnoTablaUno();
        ppp.getListaSeccionDosTablaUno();
        ppp.getListaSeccionTresTablaUno();
        ppp.getListaSeccionCuatroTablaUno();
        ppp.getListaSeccionCincoTablaUno();
        ppp.getListaSeccionSeisTablaUno();
        ppp.getListaSeccionSieteTablaUno();
        ppp.getListaSeccionOchoTablaUno();
        ppp.getListaSeccionNueveTablaUno();
        ppp.getListaSeccionDiezTablaUno();
        ppp.getTituloTablaDosSeccionUno();
        ppp.setTituloTablaDosSeccionUno('');
        ppp.getTituloTablaDosSeccionDos();
        ppp.setTituloTablaDosSeccionDos('');
        ppp.getTituloTablaDosSeccionTres();
        ppp.setTituloTablaDosSeccionTres('');
        ppp.getTituloTablaDosSeccionCuatro();
        ppp.setTituloTablaDosSeccionCuatro('');
        ppp.getTituloTablaDosSeccionCinco();
        ppp.setTituloTablaDosSeccionCinco('');
        ppp.getTituloTablaTresSeccionUno();
        ppp.setTituloTablaTresSeccionUno('');
        ppp.getTituloTablaTresSeccionDos();
        ppp.setTituloTablaTresSeccionDos('');
        ppp.getTituloTablaTresSeccionTres();
        ppp.setTituloTablaTresSeccionTres('');
        ppp.getTituloTablaTresSeccionCuatro();
        ppp.setTituloTablaTresSeccionCuatro('');
        ppp.getTituloTablaTresSeccionCinco();
        ppp.setTituloTablaTresSeccionCinco('');
        ppp.getValoresTablaDosSeccionUno();
        ppp.setValoresTablaDosSeccionUno('');
        ppp.getValoresTablaDosSeccionDos();
        ppp.setValoresTablaDosSeccionDos('');
        ppp.getValoresTablaDosSeccionTres();
        ppp.setValoresTablaDosSeccionTres('');
        ppp.getValoresTablaDosSeccionCuatro();
        ppp.setValoresTablaDosSeccionCuatro('');
        ppp.getValoresTablaDosSeccionCinco();
        ppp.setValoresTablaDosSeccionCinco('');
        ppp.getValoresTablaTresSeccionUno();
        ppp.setValoresTablaTresSeccionUno('');
        ppp.getValoresTablaTresSeccionDos();
        ppp.setValoresTablaTresSeccionDos('');
        ppp.getValoresTablaTresSeccionTres();
        ppp.setValoresTablaTresSeccionTres('');
        ppp.getValoresTablaTresSeccionCuatro();
        ppp.setValoresTablaTresSeccionCuatro('');
        ppp.getValoresTablaTresSeccionCinco();
        ppp.setValoresTablaTresSeccionCinco('');
        ppp.getListaSeccionUnoTablaDos();
        ppp.getListaSeccionDosTablaDos();
        ppp.getListaSeccionTresTablaDos();
        ppp.getListaSeccionCuatroTablaDos();
        ppp.getListaSeccionCincoTablaDos();
        ppp.getListaSeccionUnoTablaTres();
        ppp.getListaSeccionDosTablaTres();
        ppp.getListaSeccionTresTablaTres();
        ppp.getListaSeccionCuatroTablaTres();
        ppp.getListaSeccionCincoTablaTres();
        ppp.getTituloTablaCincoColumnaUno();
        ppp.setTituloTablaCincoColumnaUno('');
        ppp.getTituloTablaCincoColumnaDos();
        ppp.setTituloTablaCincoColumnaDos('');
        ppp.getListaSedes();
        ppp.getItemsPropuestaEconomica();
        ppp.setItemsPropuestaEconomica(new List<COM_PVECotizacionChequeosMedicos_ctr.COM_PVEPropuestaEconomica_cls>());
        ppp.getValoresTablaCincoColumnaUno();
        ppp.setValoresTablaCincoColumnaUno('');
        ppp.getValoresTablaCincoColumnaDos();
        ppp.setValoresTablaCincoColumnaDos('');
        ppp.getTituloTablaCuatroColumnaUno();
        ppp.setTituloTablaCuatroColumnaUno('');
        ppp.getTituloTablaCuatroColumnaDos();
        ppp.setTituloTablaCuatroColumnaDos('');
        ppp.getTituloTablaCuatroColumnaTres();
        ppp.setTituloTablaCuatroColumnaTres('');
        ppp.getTituloTablaCuatroColumnaCuatro();
        ppp.setTituloTablaCuatroColumnaCuatro('');
        ppp.getTituloTablaCuatroColumnaCinco();
        ppp.setTituloTablaCuatroColumnaCinco('');
        ppp.cargarDatos();

        COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls sede = new  COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls();
        sede.getSede();
        sede.getDireccion();
    }
}