/**
* Avanxo Colombia
* @author           Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada implementar los metodos de eventos de interface grafica de usuario
*                   para las cotizaciones de chequeos médicos.
*                   
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     31/07/2017      Cristian Mosquera (CM)      Implementacion inicial del controlador.
*           2.0     04/09/2017      Daniel Alejandro López      Tomar los valores de los objetos y llevar a campos personalizados los textos.
**/
public class COM_PVECotizacionChequeosMedicos_ctr {

    
    /** Saludo **/
    private String saludo;
    
    
    /** Párrafo 1 **/
    private String parrafoUno;
    
    /** Párrafo 2 **/
    private String parrafoDos;
    
    /** Párrafo 3 **/
    private String parrafoTres;
    
     
    
  /** Valores Sección Beneficios**/
    private String beneficios;  
    
  /** Valores Sección Recomendaciones**/
    private String recomendaciones; 
    
  /** Título Sección 1**/
    private String tituloUno;  
    
  /** Valores Sección 2**/
    private String seccionDos;    
    
   /** Título Sección 2**/
    private String tituloDos;    
         
    
    /** Título Sección 3**/
    private String tituloTres;
        
    /** Título Sección 4**/
    private String tituloCuatro;
        
   /** Título Sección 5**/
    private String tituloCinco;
    
  /** Título Sección 6**/
    private String tituloSeis;
          
    /** Despedida**/
    private String despedida;
    
    /** Nombre del Cliente.**/
    private String nombreCliente;

    /** Nombre del Representante legal. **/
    private String nombreRepresentateLegal;

    /** Cargo de la persona a quien va dirigido. **/
    private String cargo;

    /** Primer nombre de la persona a quien va dirigido. **/
    private String primerNombre;
       
    
    /** Nombre del asesor.**/
    private String nombreAsesor;

    /** Cargo del asesor.**/
    private String cargoAsesor;

    /** Valor Oportunidad.**/
    private Decimal valorTotal;

    /** Email del asesor.**/
    private String emailAsesor;

    /** Telefono del asesor.**/
    private String telefonoAsesor;

    /** El proceso al que pertenece el asesor.**/
    private String procesoAsesor;

    /** La lista de beneficios**/
    private List<String> listaBeneficios;
    
    /** La lista de recomendaciones**/
    private List<String> listaRecomendaciones;
    
   /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionUnoTablaUno;
    
    /** La lista de valores sección dos tabla uno**/
    private List<String> listaSeccionDosTablaUno;
    
    /** La lista de valores sección tres tabla uno**/
    private List<String> listaSeccionTresTablaUno;
    
    /** La lista de valores sección cuatro tabla uno**/
    private List<String> listaSeccionCuatroTablaUno;
    
    /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionCincoTablaUno;
    
    /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionSeisTablaUno;
    
    /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionSieteTablaUno;
    
    /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionOchoTablaUno;
    
    /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionNueveTablaUno;
    
    /** La lista de valores sección uno tabla uno**/
    private List<String> listaSeccionDiezTablaUno;
    
    /** La lista de valores sección uno tabla dos**/
    private List<String> listaSeccionUnoTablaDos;
    
    /** La lista de valores sección dos tabla dos**/
    private List<String> listaSeccionDosTablaDos;
    
    /** La lista de valores sección tres tabla dos**/
    private List<String> listaSeccionTresTablaDos;
    
    /** La lista de valores sección cuatro tabla dos**/
    private List<String> listaSeccionCuatroTablaDos;
    
    /** La lista de valores sección uno tabla dos**/
    private List<String> listaSeccionCincoTablaDos;
    
      /** La lista de valores sección uno tabla Tres**/
    private List<String> listaSeccionUnoTablaTres;
    
    /** La lista de valores sección dos tabla Tres**/
    private List<String> listaSeccionDosTablaTres;
    
    /** La lista de valores sección tres tabla Tres**/
    private List<String> listaSeccionTresTablaTres;
    
    /** La lista de valores sección cuatro tabla Tres**/
    private List<String> listaSeccionCuatroTablaTres;
    
    /** La lista de valores sección uno tabla Tres**/
    private List<String> listaSeccionCincoTablaTres;
    
    /** Título Tabla 1 Columna 1  **/
    private String tituloTablaUnoColumnaUno;
   
   
    /** Título Tabla 1 Columna 2 **/
    private String tituloTablaUnoColumnaDos;
    
    /** Título Tabla 1 Columna 3 **/
    private String tituloTablaUnoColumnaTres;
    
    /** Título Tabla 1 Columna 4 **/
    private String tituloTablaUnoColumnaCuatro;
    
    /** Título Tabla 2 Columna 1  **/
    private String tituloTablaDosColumnaUno;    
        
    /** Título Tabla 3 Columna 1  **/
    private String tituloTablaTresColumnaUno;
    
    
    /** Título Tabla 1 Sección 1  **/
    private String tituloTablaUnoSeccionUno;
    
    /** Título Tabla 1 Sección 2  **/
    private String tituloTablaUnoSeccionDos;
    
    /** Título Tabla 1 Sección 3  **/
    private String tituloTablaUnoSeccionTres;
    
    /** Título Tabla 1 Sección 4  **/
    private String tituloTablaUnoSeccionCuatro;
    
    /** Título Tabla 1 Sección 5  **/
    private String tituloTablaUnoSeccionCinco;
    
    /** Título Tabla 1 Sección 6  **/
    private String tituloTablaUnoSeccionSeis;
    
    /** Título Tabla 1 Sección 7  **/
    private String tituloTablaUnoSeccionSiete;
    
    /** Título Tabla 1 Sección 8  **/
    private String tituloTablaUnoSeccionOcho;
    
    /** Título Tabla 1 Sección 9  **/
    private String tituloTablaUnoSeccionNueve;
    
    /** Título Tabla 1 Sección 10  **/
    private String tituloTablaUnoSeccionDiez;
    
    /** Título Tabla 2 Sección 1  **/
    private String tituloTablaDosSeccionUno;
    
    /** Título Tabla 2 Sección 2  **/
    private String tituloTablaDosSeccionDos;
    
    /** Título Tabla 2 Sección 3  **/
    private String tituloTablaDosSeccionTres;
    
    /** Título Tabla 2 Sección 4  **/
    private String tituloTablaDosSeccionCuatro;
    
    /** Título Tabla 2 Sección 5  **/
    private String tituloTablaDosSeccionCinco;
    
    /** Título Tabla 3 Sección 1  **/
    private String tituloTablaTresSeccionUno;
    
    /** Título Tabla 3 Sección 2  **/
    private String tituloTablaTresSeccionDos;
    
    /** Título Tabla 3 Sección 3  **/
    private String tituloTablaTresSeccionTres;
    
    /** Título Tabla 3 Sección 4  **/
    private String tituloTablaTresSeccionCuatro;
    
    /** Título Tabla 3 Sección 5  **/
    private String tituloTablaTresSeccionCinco;
    
   /** Valores Tabla 1 Sección 1  **/
    private String valoresTablaUnoSeccionUno;
    
    /** Valores Tabla 1 Sección 2  **/
    private String valoresTablaUnoSeccionDos; 
    
    /** Valores Tabla 1 Sección 3  **/
    private String valoresTablaUnoSeccionTres; 
    
    /** Valores Tabla 1 Sección 4  **/
    private String valoresTablaUnoSeccionCuatro;
    
    /** Valores Tabla 1 Sección 5  **/
    private String valoresTablaUnoSeccionCinco; 
    
    /** Valores Tabla 1 Sección 6  **/
    private String valoresTablaUnoSeccionSeis; 
    
    /** Valores Tabla 1 Sección 7  **/
    private String valoresTablaUnoSeccionSiete;   
    
    /** Valores Tabla 1 Sección 8  **/
    private String valoresTablaUnoSeccionOcho;  
    
    /** Valores Tabla 1 Sección 9  **/
    private String valoresTablaUnoSeccionNueve;    
    
    /** Valores Tabla 1 Sección 10  **/
    private String valoresTablaUnoSeccionDiez; 

  
   /** Valores Tabla 2 Sección 1  **/
    private String valoresTablaDosSeccionUno;
    
    /** Valores Tabla 2 Sección 2  **/
    private String valoresTablaDosSeccionDos; 
    
    /** Valores Tabla 2 Sección 3  **/
    private String valoresTablaDosSeccionTres; 
    
    /** Valores Tabla 2 Sección 4  **/
    private String valoresTablaDosSeccionCuatro;
    
    /** Valores Tabla 2 Sección 5  **/
    private String valoresTablaDosSeccionCinco; 
    
     
   /** Valores Tabla 3 Sección 1  **/
    private String valoresTablaTresSeccionUno;
    
    /** Valores Tabla 3 Sección 2  **/
    private String valoresTablaTresSeccionDos; 
    
    /** Valores Tabla 3 Sección 3  **/
    private String valoresTablaTresSeccionTres; 
    
    /** Valores Tabla 3 Sección 4  **/
    private String valoresTablaTresSeccionCuatro;
    
    /** Valores Tabla 3 Sección 5  **/
    private String valoresTablaTresSeccionCinco; 


   /** Título Tabla 5 Columna 1  **/
    private String tituloTablaCincoColumnaUno;
    
    /** Título Tabla 5 Columna 2  **/
    private String tituloTablaCincoColumnaDos;
    
    /** Valores Tabla 5 Columna 1  **/
    private String valoresTablaCincoColumnaUno;
    
    /** Valores Tabla 5 Columna 2  **/
    private String valoresTablaCincoColumnaDos;

   /** La lista de valores Tabla 5 Columna 1/2 **/
    private List<COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls> listaSedes;
    
     /** Título Tabla 4 Columna 1  **/
    private String tituloTablaCuatroColumnaUno;
    
    /** Título Tabla 4 Columna 2  **/
    private String tituloTablaCuatroColumnaDos;
    
    /** Título Tabla 4 Columna 3  **/
    private String tituloTablaCuatroColumnaTres;
    
    /** Título Tabla 4 Columna 4  **/
    private String tituloTablaCuatroColumnaCuatro;
    
    /** Título Tabla 4 Columna 5  **/
    private String tituloTablaCuatroColumnaCinco;
 
     /** La oportunidad asociada**/
    private String idOportunidad; 

   /** Los items de la propuesta economica.**/
    private List<COM_PVECotizacionChequeosMedicos_ctr.COM_PVEPropuestaEconomica_cls> itemsPropuestaEconomica =
                                new List<COM_PVECotizacionChequeosMedicos_ctr.COM_PVEPropuestaEconomica_cls>();


    /**
     * El constructor de la clase.
     */
    public COM_PVECotizacionChequeosMedicos_ctr() {
        idOportunidad = ApexPages.currentPage().getParameters().get('IdCustomObject');
        cargarContenidoDinamico();
        cargarDatos();
    }
    
    
    /**
    Carga el texto estático desde el tipo de metadatos personalizado.
    */
     public void cargarTextoEstatico() {
        
           CotizacionChequeosMedicos__mdt[] lineasEstaticas = [SELECT parrafo1__c, parrafo2__c, parrafo3__c, 
                                                                             Saludo__c,
                                                                             Beneficios__c, tituloUno__c, 
                                                                             tituloDos__c, tituloTres__c,
                                                                             tituloCuatro__c, tituloCinco__c, tituloSeis__c,
                                                                             Despedida__c, tituloTablaUnoColumnaUno__c, tituloTablaUnoColumnaDos__c,
                                                                             tituloTablaUnoColumnaTres__c,  tituloTablaUnoColumnaCuatro__c,
                                                                             tituloTablaUnoSeccionUno__c, tituloTablaUnoSeccionDos__c, tituloTablaUnoSeccionTres__c,
                                                                             tituloTablaUnoSeccionCuatro__c, tituloTablaUnoSeccionCinco__c, tituloTablaUnoSeccionSeis__c,
                                                                             tituloTablaUnoSeccionSiete__c,  tituloTablaUnoSeccionOcho__c, tituloTablaUnoSeccionNueve__c,
                                                                             tituloTablaUnoSeccionDiez__c,
                                                                             valoresTablaUnoSeccionUno__c, valoresTablaUnoSeccionDos__c, valoresTablaUnoSeccionTres__c,
                                                                             valoresTablaUnoSeccionCuatro__c, valoresTablaUnoSeccionCinco__c, valoresTablaUnoSeccionSeis__c,              
                                                                             valoresTablaUnoSeccionSiete__c, valoresTablaUnoSeccionOcho__c, valoresTablaUnoSeccionNueve__c,
                                                                             valoresTablaUnoSeccionDiez__c,
                                                                             tituloTablaDosColumnaUno__c,  tituloTablaDosSeccionUno__c,
                                                                             tituloTablaDosSeccionDos__c,  tituloTablaDosSeccionTres__c,
                                                                             tituloTablaDosSeccionCuatro__c, tituloTablaDosSeccionCinco__c,
                                                                             tituloTablaTresColumnaUno__c, tituloTablaTresSeccionUno__c, tituloTablaTresSeccionDos__c,
                                                                             tituloTablaTresSeccionTres__c, tituloTablaTresSeccionCuatro__c, tituloTablaTresSeccionCinco__c,
                                                                             valoresTablaDosSeccionUno__c, valoresTablaDosSeccionDos__c, valoresTablaDosSeccionTres__c,
                                                                             valoresTablaDosSeccionCuatro__c, valoresTablaTresSeccionUno__c, valoresTablaTresSeccionDos__c,
                                                                             valoresTablaTresSeccionTres__c, valoresTablaTresSeccionCuatro__c, valoresTablaTresSeccionCinco__c,
                                                                             Recomendaciones__c,
                                                                             tituloTablaCincoColumnaUno__c, tituloTablaCincoColumnaDos__c,
                                                                             valoresTablaCincoColumnaUno__c,    valoresTablaCincoColumnaDos__c,
                                                                             tituloTablaCuatroColumnaUno__c, tituloTablaCuatroColumnaDos__c, tituloTablaCuatroColumnaTres__c,
                                                                             tituloTablaCuatroColumnaCuatro__c, tituloTablaCuatroColumnaCinco__c, 
                                                                             ProcesoAsesor__c 
                                                             FROM CotizacionChequeosMedicos__mdt ];
                                                           
           for (CotizacionChequeosMedicos__mdt lineaEstatica : lineasEstaticas) {
                 String saludoConf = lineaEstatica.Saludo__c;
                 String parrafo1Conf = lineaEstatica.parrafo1__c;
                 String parrafo2Conf = lineaEstatica.parrafo2__c;
                 String parrafo3Conf = lineaEstatica.parrafo3__c;
                 String procesoAsesorConf = lineaEstatica.ProcesoAsesor__c;
                                  
                 String despedidaConf = lineaEstatica.Despedida__c;
                 String seccionBeneficiosConf = lineaEstatica.Beneficios__c;
                 String seccionRecomendacionesConf = lineaEstatica.Recomendaciones__c;
                                                  
                 String titulo1Conf  = lineaEstatica.tituloUno__c;
                 String titulo2Conf  = lineaEstatica.tituloDos__c;
                 String titulo3Conf  = lineaEstatica.tituloTres__c;
                 String titulo4Conf  = lineaEstatica.tituloCuatro__c;
                 String titulo5Conf  = lineaEstatica.tituloCinco__c;
                 String titulo6Conf  = lineaEstatica.tituloSeis__c;
                 
                 String tituloTablaUnoColumnaUnoConf =  lineaEstatica.tituloTablaUnoColumnaUno__c;
                 String tituloTablaUnoColumnaDosConf =  lineaEstatica.tituloTablaUnoColumnaDos__c;
                 String tituloTablaUnoColumnaTresConf =  lineaEstatica.tituloTablaUnoColumnaTres__c;
                 String tituloTablaUnoColumnaCuatroConf =  lineaEstatica.tituloTablaUnoColumnaCuatro__c;
                 String tituloTablaDosColumnaUnoConf =  lineaEstatica.tituloTablaDosColumnaUno__c;
                 String tituloTablaTresColumnaUnoConf =  lineaEstatica.tituloTablaTresColumnaUno__c;
                 
                 String tituloTablaUnoSeccionUnoConf =  lineaEstatica.tituloTablaUnoSeccionUno__c;
                 String tituloTablaUnoSeccionDosConf =  lineaEstatica.tituloTablaUnoSeccionDos__c;
                 String tituloTablaUnoSeccionTresConf =  lineaEstatica.tituloTablaUnoSeccionTres__c;
                 String tituloTablaUnoSeccionCuatroConf =  lineaEstatica.tituloTablaUnoSeccionCuatro__c;
                 String tituloTablaUnoSeccionCincoConf =  lineaEstatica.tituloTablaUnoSeccionCinco__c;
                 String tituloTablaUnoSeccionSeisConf =  lineaEstatica.tituloTablaUnoSeccionSeis__c;
                 String tituloTablaUnoSeccionSieteConf =  lineaEstatica.tituloTablaUnoSeccionSiete__c;
                 String tituloTablaUnoSeccionOchoConf =  lineaEstatica.tituloTablaUnoSeccionOcho__c;
                 String tituloTablaUnoSeccionNueveConf =  lineaEstatica.tituloTablaUnoSeccionNueve__c;
                 String tituloTablaUnoSeccionDiezConf =  lineaEstatica.tituloTablaUnoSeccionDiez__c;
                 
                 String tituloTablaDosSeccionUnoConf =  lineaEstatica.tituloTablaDosSeccionUno__c;
                 String tituloTablaDosSeccionDosConf =  lineaEstatica.tituloTablaDosSeccionDos__c;
                 String tituloTablaDosSeccionTresConf =  lineaEstatica.tituloTablaDosSeccionTres__c;
                 String tituloTablaDosSeccionCuatroConf =  lineaEstatica.tituloTablaDosSeccionCuatro__c;
                                  
                 String tituloTablaTresSeccionUnoConf =  lineaEstatica.tituloTablaTresSeccionUno__c;
                 String tituloTablaTresSeccionDosConf =  lineaEstatica.tituloTablaTresSeccionDos__c;
                 String tituloTablaTresSeccionTresConf =  lineaEstatica.tituloTablaTresSeccionTres__c;
                 String tituloTablaTresSeccionCuatroConf =  lineaEstatica.tituloTablaTresSeccionCuatro__c;
                 String tituloTablaTresSeccionCincoConf =  lineaEstatica.tituloTablaTresSeccionCinco__c;
                 
                 String valorTablaUnoSeccionUnoConf =  lineaEstatica.valoresTablaUnoSeccionUno__c;
                 String valorTablaUnoSeccionDosConf =  lineaEstatica.valoresTablaUnoSeccionDos__c;
                 String valorTablaUnoSeccionTresConf =  lineaEstatica.valoresTablaUnoSeccionTres__c;
                 String valorTablaUnoSeccionCuatroConf =  lineaEstatica.valoresTablaUnoSeccionCuatro__c;
                 String valorTablaUnoSeccionCincoConf =  lineaEstatica.valoresTablaUnoSeccionCinco__c;
                 String valorTablaUnoSeccionSeisConf =  lineaEstatica.valoresTablaUnoSeccionSeis__c;
                 String valorTablaUnoSeccionSieteConf =  lineaEstatica.valoresTablaUnoSeccionSiete__c;
                 String valorTablaUnoSeccionOchoConf =  lineaEstatica.valoresTablaUnoSeccionOcho__c;
                 String valorTablaUnoSeccionNueveConf =  lineaEstatica.valoresTablaUnoSeccionNueve__c;
                 String valorTablaUnoSeccionDiezConf =  lineaEstatica.valoresTablaUnoSeccionDiez__c;
                 
                 String valorTablaDosSeccionUnoConf =  lineaEstatica.valoresTablaDosSeccionUno__c;
                 String valorTablaDosSeccionDosConf =  lineaEstatica.valoresTablaDosSeccionDos__c;
                 String valorTablaDosSeccionTresConf =  lineaEstatica.valoresTablaDosSeccionTres__c;
                 String valorTablaDosSeccionCuatroConf =  lineaEstatica.valoresTablaDosSeccionCuatro__c;
                                  
                 String valorTablaTresSeccionUnoConf =  lineaEstatica.valoresTablaTresSeccionUno__c;
                 String valorTablaTresSeccionDosConf =  lineaEstatica.valoresTablaTresSeccionDos__c;
                 String valorTablaTresSeccionTresConf =  lineaEstatica.valoresTablaTresSeccionTres__c;
                 String valorTablaTresSeccionCuatroConf =  lineaEstatica.valoresTablaTresSeccionCuatro__c;
                 String valorTablaTresSeccionCincoConf =  lineaEstatica.valoresTablaTresSeccionCinco__c;
                 
                 String tituloTablaCincoColumnaUnoConf =  lineaEstatica.tituloTablaCincoColumnaUno__c;
                 String tituloTablaCincoColumnaDosConf =  lineaEstatica.tituloTablaCincoColumnaDos__c;
                 String valorTablaCincoColumnaUnoConf =  lineaEstatica.valoresTablaCincoColumnaUno__c;
                 String valorTablaCincoColumnaDosConf =  lineaEstatica.valoresTablaCincoColumnaDos__c;
                 
                 String tituloTablaCuatroColumnaUnoConf =  lineaEstatica.tituloTablaCuatroColumnaUno__c;
                 String tituloTablaCuatroColumnaDosConf =  lineaEstatica.tituloTablaCuatroColumnaDos__c;
                 String tituloTablaCuatroColumnaTresConf =  lineaEstatica.tituloTablaCuatroColumnaTres__c;
                 String tituloTablaCuatroColumnaCuatroConf =  lineaEstatica.tituloTablaCuatroColumnaCuatro__c;
                 String tituloTablaCuatroColumnaCincoConf =  lineaEstatica.tituloTablaCuatroColumnaCinco__c;
                                  
                 setSaludo(saludoConf);
                 setParrafoUno(parrafo1Conf);
                 setParrafoDos(parrafo2Conf);
                 setParrafoTres(parrafo3Conf);
                                 
                 setSaludo(saludoConf);
                 setDespedida(despedidaConf);
                 
                 setBeneficios(seccionBeneficiosConf);
                 setRecomendaciones(seccionRecomendacionesConf);
                                                                 
                 setTituloUno(titulo1Conf);
                 setTituloDos(titulo2Conf);
                 setTituloTres(titulo3Conf);
                 setTituloCuatro(titulo4Conf);
                 setTituloCinco(titulo5Conf);
                 setTituloSeis(titulo6Conf);
                 
                 setTituloTablaUnoColumnaUno(tituloTablaUnoColumnaUnoConf);
                 setTituloTablaUnoColumnaDos(tituloTablaUnoColumnaDosConf);
                 setTituloTablaUnoColumnaTres(tituloTablaUnoColumnaTresConf);
                 setTituloTablaUnoColumnaCuatro(tituloTablaUnoColumnaCuatroConf);
                 setTituloTablaDosColumnaUno(tituloTablaDosColumnaUnoConf); 
                 setTituloTablaTresColumnaUno(tituloTablaTresColumnaUnoConf); 
                 
                 setTituloTablaUnoSeccionUno(tituloTablaUnoSeccionUnoConf);
                 setTituloTablaUnoSeccionDos(tituloTablaUnoSeccionDosConf);
                 setTituloTablaUnoSeccionTres(tituloTablaUnoSeccionTresConf);
                 setTituloTablaUnoSeccionCuatro(tituloTablaUnoSeccionCuatroConf);
                 setTituloTablaUnoSeccionCinco(tituloTablaUnoSeccionCincoConf);
                 setTituloTablaUnoSeccionSeis(tituloTablaUnoSeccionSeisConf);
                 setTituloTablaUnoSeccionSiete(tituloTablaUnoSeccionSieteConf);
                 setTituloTablaUnoSeccionOcho(tituloTablaUnoSeccionOchoConf);
                 setTituloTablaUnoSeccionNueve(tituloTablaUnoSeccionNueveConf);
                 setTituloTablaUnoSeccionDiez(tituloTablaUnoSeccionDiezConf);
                 
                 setTituloTablaDosSeccionUno(tituloTablaDosSeccionUnoConf);
                 setTituloTablaDosSeccionDos(tituloTablaDosSeccionDosConf);
                 setTituloTablaDosSeccionTres(tituloTablaDosSeccionTresConf);
                 setTituloTablaDosSeccionCuatro(tituloTablaDosSeccionCuatroConf);
                                  
                 setTituloTablaTresSeccionUno(tituloTablaTresSeccionUnoConf);
                 setTituloTablaTresSeccionDos(tituloTablaTresSeccionDosConf);
                 setTituloTablaTresSeccionTres(tituloTablaTresSeccionTresConf);
                 setTituloTablaTresSeccionCuatro(tituloTablaTresSeccionCuatroConf);
                 setTituloTablaTresSeccionCinco(tituloTablaTresSeccionCincoConf);
                 
                 setTituloTablaCuatroColumnaUno(tituloTablaCuatroColumnaUnoConf);
                 setTituloTablaCuatroColumnaDos(tituloTablaCuatroColumnaDosConf);
                 setTituloTablaCuatroColumnaTres(tituloTablaCuatroColumnaTresConf);
                 setTituloTablaCuatroColumnaCuatro(tituloTablaCuatroColumnaCuatroConf);
                 setTituloTablaCuatroColumnaCinco(tituloTablaCuatroColumnaCincoConf);
                 
                 setValoresTablaUnoSeccionUno(valorTablaUnoSeccionUnoConf);
                 setValoresTablaUnoSeccionDos(valorTablaUnoSeccionDosConf);
                 setValoresTablaUnoSeccionTres(valorTablaUnoSeccionTresConf);
                 setValoresTablaUnoSeccionCuatro(valorTablaUnoSeccionCuatroConf);
                 setValoresTablaUnoSeccionCinco(valorTablaUnoSeccionCincoConf);
                 setValoresTablaUnoSeccionSeis(valorTablaUnoSeccionSeisConf);
                 setValoresTablaUnoSeccionSiete(valorTablaUnoSeccionSieteConf);
                 setValoresTablaUnoSeccionOcho(valorTablaUnoSeccionOchoConf);
                 setValoresTablaUnoSeccionNueve(valorTablaUnoSeccionNueveConf);
                 setValoresTablaUnoSeccionDiez(valorTablaUnoSeccionDiezConf);
                 
                 setValoresTablaDosSeccionUno(valorTablaDosSeccionUnoConf);
                 setValoresTablaDosSeccionDos(valorTablaDosSeccionDosConf);
                 setValoresTablaDosSeccionTres(valorTablaDosSeccionTresConf);
                 setValoresTablaDosSeccionCuatro(valorTablaDosSeccionCuatroConf);
                                  
                 setValoresTablaTresSeccionUno(valorTablaTresSeccionUnoConf);
                 setValoresTablaTresSeccionDos(valorTablaTresSeccionDosConf);
                 setValoresTablaTresSeccionTres(valorTablaTresSeccionTresConf);
                 setValoresTablaTresSeccionCuatro(valorTablaTresSeccionCuatroConf);
                 setValoresTablaTresSeccionCinco(valorTablaTresSeccionCincoConf);
                 
                 setTituloTablaCincoColumnaUno(tituloTablaCincoColumnaUnoConf);
                 setTituloTablaCincoColumnaDos(tituloTablaCincoColumnaDosConf);
                 setValoresTablaCincoColumnaUno(valorTablaCincoColumnaUnoConf);
                 setValoresTablaCincoColumnaDos(valorTablaCincoColumnaDosConf);
                 
                 setProcesoAsesor(procesoAsesorConf);
                 
                 
                                  
           }
     }
     

    /**
     * @descrition Metodo encargado de cargar los servicios generales.
     */
    public void cargarBeneficios() {
        listaBeneficios = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= beneficios.countMatches(saltoLinea);
        String seccionUnoTemporal = beneficios;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            listaBeneficios.add(linea);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice+1,seccionUnoTemporal.length());        
            
        }         
    }


   /**
     * @descrition Metodo encargado de cargar las recomendaciones.
     */
    public void cargarRecomendaciones() {
        listaRecomendaciones = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= recomendaciones.countMatches(saltoLinea);
        String seccionUnoTemporal = recomendaciones;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            listaRecomendaciones.add(linea);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice+1,seccionUnoTemporal.length());        
            
        }         
    }
    
    
    
   /**
     * @descrition Metodo encargado de cargar las sedes y direcciones.
     */
    public void cargarSedes() {
        listaSedes = new List<COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls>();
                
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= valoresTablaCincoColumnaUno.countMatches(saltoLinea);
        String seccionUnoTemporal = valoresTablaCincoColumnaUno;
        String seccionDosTemporal = valoresTablaCincoColumnaDos;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice1 = seccionUnoTemporal.indexOf(saltoLinea);
            Integer indice2 = seccionDosTemporal.indexOf(saltoLinea);
            String linea1 = seccionUnoTemporal.substring(0,indice1);
            String linea2 = seccionDosTemporal.substring(0,indice2);
            COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls sedeAgregar= new COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls();
            sedeAgregar.sede = linea1;
            sedeAgregar.direccion = linea2;
            listaSedes.add(sedeAgregar);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice1+1,seccionUnoTemporal.length());
            seccionDosTemporal = seccionDosTemporal.substring(indice2+1,seccionDosTemporal.length());         
            
        }         
    }


    /**
     * @descrition Metodo encargado de cargar las secciones de la tabla uno.
     */
    public void cargarTablaUno() {
        listaSeccionUnoTablaUno = new List<String>();
        listaSeccionDosTablaUno = new List<String>();
        listaSeccionTresTablaUno = new List<String>();
        listaSeccionCuatroTablaUno = new List<String>();
        listaSeccionCincoTablaUno = new List<String>();
        listaSeccionSeisTablaUno = new List<String>();
        listaSeccionSieteTablaUno = new List<String>();
        listaSeccionOchoTablaUno = new List<String>();
        listaSeccionNueveTablaUno = new List<String>();
        listaSeccionDiezTablaUno = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n'; 
        Integer numeroLineas1= valoresTablaUnoSeccionUno.countMatches(saltoLinea);
        Integer numeroLineas2= valoresTablaUnoSeccionDos.countMatches(saltoLinea);
        Integer numeroLineas3= valoresTablaUnoSeccionTres.countMatches(saltoLinea);
        Integer numeroLineas4= valoresTablaUnoSeccionCuatro.countMatches(saltoLinea);
        Integer numeroLineas5= valoresTablaUnoSeccionCinco.countMatches(saltoLinea);
        Integer numeroLineas6= valoresTablaUnoSeccionSeis.countMatches(saltoLinea);
        Integer numeroLineas7= valoresTablaUnoSeccionSiete.countMatches(saltoLinea);
        Integer numeroLineas8= valoresTablaUnoSeccionOcho.countMatches(saltoLinea);
        Integer numeroLineas9= valoresTablaUnoSeccionNueve.countMatches(saltoLinea);
        Integer numeroLineas10= valoresTablaUnoSeccionDiez.countMatches(saltoLinea);
        
        
        String seccionUnoTemporal = valoresTablaUnoSeccionUno;
        String seccionDosTemporal = valoresTablaUnoSeccionDos;
        String seccionTresTemporal = valoresTablaUnoSeccionTres;
        String seccionCuatroTemporal = valoresTablaUnoSeccionCuatro;
        String seccionCincoTemporal = valoresTablaUnoSeccionCinco;
        String seccionSeisTemporal = valoresTablaUnoSeccionSeis;
        String seccionSieteTemporal = valoresTablaUnoSeccionSiete;
        String seccionOchoTemporal = valoresTablaUnoSeccionOcho;
        String seccionNueveTemporal = valoresTablaUnoSeccionNueve;
        String seccionDiezTemporal = valoresTablaUnoSeccionDiez;
                
        for(Integer i=0; i<numeroLineas1; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            listaSeccionUnoTablaUno.add(linea);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice+1,seccionUnoTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas2; i++){
            
            Integer indice = seccionDosTemporal.indexOf(saltoLinea);
            String linea = seccionDosTemporal.substring(0,indice);
            listaSeccionDosTablaUno.add(linea);
            seccionDosTemporal = seccionDosTemporal.substring(indice+1,seccionDosTemporal.length());        
            
        }   
        
        for(Integer i=0; i<numeroLineas3; i++){
            
            Integer indice = seccionTresTemporal.indexOf(saltoLinea);
            String linea = seccionTresTemporal.substring(0,indice);
            listaSeccionTresTablaUno.add(linea);
            seccionTresTemporal = seccionTresTemporal.substring(indice+1,seccionTresTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas4; i++){
            
            Integer indice = seccionCuatroTemporal.indexOf(saltoLinea);
            String linea = seccionCuatroTemporal.substring(0,indice);
            listaSeccionCuatroTablaUno.add(linea);
            seccionCuatroTemporal = seccionCuatroTemporal.substring(indice+1,seccionCuatroTemporal.length());        
            
        }    
        
        for(Integer i=0; i<numeroLineas5; i++){
            
            Integer indice = seccionCincoTemporal.indexOf(saltoLinea);
            String linea = seccionCincoTemporal.substring(0,indice);
            listaSeccionCincoTablaUno.add(linea);
            seccionCincoTemporal = seccionCincoTemporal.substring(indice+1,seccionCincoTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas6; i++){
            
            Integer indice = seccionSeisTemporal.indexOf(saltoLinea);
            String linea = seccionSeisTemporal.substring(0,indice);
            listaSeccionSeisTablaUno.add(linea);
            seccionSeisTemporal = seccionSeisTemporal.substring(indice+1,seccionSeisTemporal.length());        
            
        }  
        
        for(Integer i=0; i<numeroLineas7; i++){
            
            Integer indice = seccionSieteTemporal.indexOf(saltoLinea);
            String linea = seccionSieteTemporal.substring(0,indice);
            listaSeccionSieteTablaUno.add(linea);
            seccionSieteTemporal = seccionSieteTemporal.substring(indice+1,seccionSieteTemporal.length());        
            
        }     
        
        for(Integer i=0; i<numeroLineas8; i++){
            
            Integer indice = seccionOchoTemporal.indexOf(saltoLinea);
            String linea = seccionOchoTemporal.substring(0,indice);
            listaSeccionOchoTablaUno.add(linea);
            seccionOchoTemporal = seccionOchoTemporal.substring(indice+1,seccionOchoTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas9; i++){
            
            Integer indice = seccionNueveTemporal.indexOf(saltoLinea);
            String linea = seccionNueveTemporal.substring(0,indice);
            listaSeccionNueveTablaUno.add(linea);
            seccionNueveTemporal = seccionNueveTemporal.substring(indice+1,seccionNueveTemporal.length());        
            
        } 
        
            for(Integer i=0; i<numeroLineas10; i++){
            
            Integer indice = seccionDiezTemporal.indexOf(saltoLinea);
            String linea = seccionDiezTemporal.substring(0,indice);
            listaSeccionDiezTablaUno.add(linea);
            seccionDiezTemporal = seccionDiezTemporal.substring(indice+1,seccionDiezTemporal.length());        
            
        }                                         
    }    
    



    /**
     * @descrition Metodo encargado de cargar las secciones de la tabla DOS.
     */
    public void cargarTablaDos() {
        listaSeccionUnoTablaDos = new List<String>();
        listaSeccionDosTablaDos = new List<String>();
        listaSeccionTresTablaDos = new List<String>();
        listaSeccionCuatroTablaDos = new List<String>();
                        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n'; 
        Integer numeroLineas1= valoresTablaDosSeccionUno.countMatches(saltoLinea);
        Integer numeroLineas2= valoresTablaDosSeccionDos.countMatches(saltoLinea);
        Integer numeroLineas3= valoresTablaDosSeccionTres.countMatches(saltoLinea);
        Integer numeroLineas4= valoresTablaDosSeccionCuatro.countMatches(saltoLinea);
                
        
        String seccionUnoTemporal = valoresTablaDosSeccionUno;
        String seccionDosTemporal = valoresTablaDosSeccionDos;
        String seccionTresTemporal = valoresTablaDosSeccionTres;
        String seccionCuatroTemporal = valoresTablaDosSeccionCuatro;
        String seccionCincoTemporal = valoresTablaDosSeccionCinco;
        
        for(Integer i=0; i<numeroLineas1; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            listaSeccionUnoTablaDos.add(linea);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice+1,seccionUnoTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas2; i++){
            
            Integer indice = seccionDosTemporal.indexOf(saltoLinea);
            String linea = seccionDosTemporal.substring(0,indice);
            listaSeccionDosTablaDos.add(linea);
            seccionDosTemporal = seccionDosTemporal.substring(indice+1,seccionDosTemporal.length());        
            
        }   
        
        for(Integer i=0; i<numeroLineas3; i++){
            
            Integer indice = seccionTresTemporal.indexOf(saltoLinea);
            String linea = seccionTresTemporal.substring(0,indice);
            listaSeccionTresTablaDos.add(linea);
            seccionTresTemporal = seccionTresTemporal.substring(indice+1,seccionTresTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas4; i++){
            
            Integer indice = seccionCuatroTemporal.indexOf(saltoLinea);
            String linea = seccionCuatroTemporal.substring(0,indice);
            listaSeccionCuatroTablaDos.add(linea);
            seccionCuatroTemporal = seccionCuatroTemporal.substring(indice+1,seccionCuatroTemporal.length());        
            
        }    
                      
    }    



    /**
     * @descrition Metodo encargado de cargar las secciones de la tabla TRES.
     */
    public void cargarTablaTres() {
        listaSeccionUnoTablaTres = new List<String>();
        listaSeccionDosTablaTres = new List<String>();
        listaSeccionTresTablaTres = new List<String>();
        listaSeccionCuatroTablaTres = new List<String>();
        listaSeccionCincoTablaTres = new List<String>();
                        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n'; 
        Integer numeroLineas1= valoresTablaTresSeccionUno.countMatches(saltoLinea);
        Integer numeroLineas2= valoresTablaTresSeccionDos.countMatches(saltoLinea);
        Integer numeroLineas3= valoresTablaTresSeccionTres.countMatches(saltoLinea);
        Integer numeroLineas4= valoresTablaTresSeccionCuatro.countMatches(saltoLinea);
        Integer numeroLineas5= valoresTablaTresSeccionCinco.countMatches(saltoLinea);
                
        
        String seccionUnoTemporal = valoresTablaTresSeccionUno;
        String seccionDosTemporal = valoresTablaTresSeccionDos;
        String seccionTresTemporal = valoresTablaTresSeccionTres;
        String seccionCuatroTemporal = valoresTablaTresSeccionCuatro;
        String seccionCincoTemporal = valoresTablaTresSeccionCinco;
        
        for(Integer i=0; i<numeroLineas1; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            listaSeccionUnoTablaTres.add(linea);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice+1,seccionUnoTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas2; i++){
            
            Integer indice = seccionDosTemporal.indexOf(saltoLinea);
            String linea = seccionDosTemporal.substring(0,indice);
            listaSeccionDosTablaTres.add(linea);
            seccionDosTemporal = seccionDosTemporal.substring(indice+1,seccionDosTemporal.length());        
            
        }   
        
        for(Integer i=0; i<numeroLineas3; i++){
            
            Integer indice = seccionTresTemporal.indexOf(saltoLinea);
            String linea = seccionTresTemporal.substring(0,indice);
            listaSeccionTresTablaTres.add(linea);
            seccionTresTemporal = seccionTresTemporal.substring(indice+1,seccionTresTemporal.length());        
            
        }
        
        for(Integer i=0; i<numeroLineas4; i++){
            
            Integer indice = seccionCuatroTemporal.indexOf(saltoLinea);
            String linea = seccionCuatroTemporal.substring(0,indice);
            listaSeccionCuatroTablaTres.add(linea);
            seccionCuatroTemporal = seccionCuatroTemporal.substring(indice+1,seccionCuatroTemporal.length());        
            
        }    

       
        for(Integer i=0; i<numeroLineas5; i++){
            
            Integer indice = seccionCincoTemporal.indexOf(saltoLinea);
            String linea = seccionCincoTemporal.substring(0,indice);
            listaSeccionCincoTablaTres.add(linea);
            seccionCincoTemporal = seccionCincoTemporal.substring(indice+1,seccionCincoTemporal.length());        
            
        }    
                      
    }    


  

    /**
     * @description Metodo encargado de cargar los datos del PDF.
     */
    public void cargarDatos() {
        
        cargarTextoEstatico();
        
        //Cargar fecha actual
        Integer mes = Date.Today().month();
        Integer anio= Date.Today().year();
        Integer dia = Date.Today().day();
        String nombreMes='';
        
        //Convertir mes a texto español
        if (mes==1){
            nombreMes = 'Enero';
        }
        else if (mes==2){
            nombreMes = 'Febrero';
        }
        else if (mes==3){
            nombreMes = 'Marzo';
        }
        else if (mes==4){
            nombreMes = 'Abril';
        }
        else if (mes==5){
            nombreMes = 'Mayo';
        }
        else if (mes==6){
            nombreMes = 'Junio';
        }
        else if (mes==7){
            nombreMes = 'Julio';
        }
        else if (mes==8){
            nombreMes = 'Agosto';
        }
        else if (mes==9){
            nombreMes = 'Septiembre';
        }
        else if (mes==10){
            nombreMes = 'Octubre';
        }
        else if (mes==11){
            nombreMes = 'Noviembre';
        }
        else if (mes==12){
            nombreMes = 'Diciembre';
        }
        
        String strId = Apexpages.currentPage().getParameters().get( 'id' );
                                
        cargarBeneficios();
        cargarTablaUno();
        cargarTablaDos();
        cargarTablaTres();
        cargarRecomendaciones();
        cargarSedes();
                
    }
    
     
         /**
         * Getter del atributo saludo.
         * @return el atributo saludo.
         */
        public String getSaludo() {
            return saludo;
        }

        /**
         * Setter del atributo saludo.
         * @param saludo el atributo saludo a establecer.
         */
        public void setSaludo(String saludo) {
            this.saludo = saludo;
        }
        
        /**
         * Getter del atributo párrafo 1.
         * @return el atributo párrafo 1.
         */
        public String getParrafoUno() {
            return parrafoUno;
        }

        /**
         * Setter del atributo párrafo 1.
         * @param párrafo 1 el atributo párrafo 1 a establecer.
         */
        public void setParrafoUno(String parrafoUno) {
            this.parrafoUno = parrafoUno;
        }
      
      /**
         * Getter del atributo párrafo 2.
         * @return el atributo párrafo 2.
         */
        public String getParrafoDos() {
            return parrafoDos;
        }
        
        
        /**
         * Setter del atributo párrafo 2.
         * @param párrafo 2 el atributo párrafo 2 a establecer.
         */
        public void setParrafoDos(String parrafoDos) {
            this.parrafoDos = parrafoDos;
        }

         /**
         * Getter del atributo párrafo 3.
         * @return el atributo párrafo 3.
         */
        public String getParrafoTres() {
            return parrafoTres;
        }
        

        /**
         * Setter del atributo párrafo 3.
         * @param párrafo 3 el atributo párrafo 3 a establecer.
         */
        public void setParrafoTres(String parrafoTres) {
            this.parrafoTres = parrafoTres;
        }
 
 
         /**
         * Getter del atributo despedida.
         * @return el atributo despedida.
         */
        public String getDespedida() {
            return despedida;
        }

        /**
         * Setter del atributo saludo.
         * @param saludo el atributo saludo a establecer.
         */
        public void setDespedida(String despedida) {
            this.despedida = despedida;
        }
        
    
      /**
         * Getter del atributo título 1.
         * @return el atributo título 1.
         */
        public String getTituloUno() {
            return tituloUno;
        }
        

        /**
         * Setter del atributo Título 1.
         * @param Título 1 el atributo Título 1 a establecer.
         */
        public void setTituloUno(String tituloUno) {
            this.tituloUno = tituloUno;
        }
 
      
      /**
         * Getter del atributo título 2.
         * @return el atributo título 2.
         */
        public String getTituloDos() {
            return tituloDos;
        }
        

        /**
         * Setter del atributo Título 2.
         * @param Título 2 el atributo Título 2 a establecer.
         */
        public void setTituloDos(String tituloDos) {
            this.tituloDos = tituloDos;
        }
 
      
     
     
      /**
         * Getter del atributo título 3.
         * @return el atributo título 3.
         */
        public String getTituloTres() {
            return tituloTres;
        }
        

        /**
         * Setter del atributo Título 3.
         * @param Título 3 el atributo Título 3 a establecer.
         */
        public void setTituloTres(String tituloTres) {
            this.tituloTres = tituloTres;
        }
        
        

      /**
         * Getter del atributo título 4.
         * @return el atributo título 4.
         */
        public String getTituloCuatro() {
            return tituloCuatro;
        }
        

        /**
         * Setter del atributo Título 4.
         * @param Título 4 el atributo Título 4 a establecer.
         */
        public void setTituloCuatro(String tituloCuatro) {
            this.tituloCuatro = tituloCuatro;
        }  
        

      /**
         * Getter del atributo título 5.
         * @return el atributo título 5.
         */
        public String getTituloCinco() {
            return tituloCinco;
        }
        

        /**
         * Setter del atributo Título 5.
         * @param Título 5 el atributo Título 5 a establecer.
         */
        public void setTituloCinco(String tituloCinco) {
            this.tituloCinco = tituloCinco;
        }
 
 
 
      /**
         * Getter del atributo título 6.
         * @return el atributo título 6.
         */
        public String getTituloSeis() {
            return tituloSeis;
        }
        

        /**
         * Setter del atributo Título 6.
         * @param Título 6 el atributo Título 6 a establecer.
         */
        public void setTituloSeis(String tituloSeis) {
            this.tituloSeis = tituloSeis;
        }       
       

      /**
         * Getter del atributo Título Tabla Uno Columna Uno.
         * @return el atributo título Título Tabla Uno Columna Uno.
         */
        public String getTituloTablaUnoColumnaUno() {
            return tituloTablaUnoColumnaUno;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Columna Uno.
         * @param Título Tabla Uno Columna Uno el atributo Título Tabla Uno Columna Uno a establecer.
         */
        public void setTituloTablaUnoColumnaUno(String tituloTablaUnoColumnaUno) {
            this.tituloTablaUnoColumnaUno = tituloTablaUnoColumnaUno;
        }
        

      /**
         * Getter del atributo Título Tabla Uno Columna Dos.
         * @return el atributo título Título Tabla Uno Columna Dos.
         */
        public String getTituloTablaUnoColumnaDos() {
            return tituloTablaUnoColumnaDos;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Columna Dos.
         * @param Título Tabla Uno Columna Dos el atributo Título Tabla Uno Columna Dos a establecer.
         */
        public void setTituloTablaUnoColumnaDos(String tituloTablaUnoColumnaDos) {
            this.tituloTablaUnoColumnaDos = tituloTablaUnoColumnaDos;
        }


      /**
         * Getter del atributo Título Tabla Uno Columna Tres.
         * @return el atributo título Título Tabla Uno Columna Tres.
         */
        public String getTituloTablaUnoColumnaTres() {
            return tituloTablaUnoColumnaTres;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Columna Tres.
         * @param Título Tabla Uno Columna Tres el atributo Título Tabla Uno Columna Tres a establecer.
         */
        public void setTituloTablaUnoColumnaTres(String tituloTablaUnoColumnaTres) {
            this.tituloTablaUnoColumnaTres = tituloTablaUnoColumnaTres;
        }


      /**
         * Getter del atributo Título Tabla Uno Columna Cuatro.
         * @return el atributo título Título Tabla Uno Columna Cuatro.
         */
        public String getTituloTablaUnoColumnaCuatro() {
            return tituloTablaUnoColumnaCuatro;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Columna Cuatro.
         * @param Título Tabla Uno Columna Cuatro el atributo Título Tabla Uno Columna Cuatro a establecer.
         */
        public void setTituloTablaUnoColumnaCuatro(String tituloTablaUnoColumnaCuatro) {
            this.tituloTablaUnoColumnaCuatro = tituloTablaUnoColumnaCuatro;
        }
        
        
 
      /**
         * Getter del atributo Título Tabla Dos Columna Uno.
         * @return el atributo título Título Tabla Dos Columna Uno.
         */
        public String getTituloTablaDosColumnaUno() {
            return tituloTablaDosColumnaUno;
        }
        

        /**
         * Setter del atributo Título Tabla Dos Columna Uno.
         * @param Título Tabla Dos Columna Uno el atributo Título Tabla Dos Columna Uno a establecer.
         */
        public void setTituloTablaDosColumnaUno(String tituloTablaDosColumnaUno) {
            this.tituloTablaDosColumnaUno = tituloTablaDosColumnaUno;
        }


      /**
         * Getter del atributo Título Tabla Tres Columna Uno.
         * @return el atributo título Título Tabla Tres Columna Uno.
         */
        public String getTituloTablaTresColumnaUno() {
            return tituloTablaTresColumnaUno;
        }
        

        /**
         * Setter del atributo Título Tabla Tres Columna Uno.
         * @param Título Tabla Tres Columna Uno el atributo Título Tabla Tres Columna Uno a establecer.
         */
        public void setTituloTablaTresColumnaUno(String tituloTablaTresColumnaUno) {
            this.tituloTablaTresColumnaUno = tituloTablaTresColumnaUno;
        }


   
      /**
         * Getter del atributo Sección Beneficios.
         * @return el atributo Sección Beneficios.
         */
        public String getBeneficios() {
            return beneficios;
        }      
        
        /**
         * Setter del atributo Sección Beneficios.
         * @param Sección Beneficios el atributo Sección Beneficios a establecer.
         */
        public void setBeneficios(String beneficios) {
            this.beneficios = beneficios;
        }
 
 
      /**
         * Getter del atributo Sección Recomendaciones.
         * @return el atributo Sección Recomendaciones.
         */
        public String getRecomendaciones() {
            return recomendaciones;
        }      
        
        /**
         * Setter del atributo Sección Recomendaciones.
         * @param Sección Recomendaciones el atributo Sección Recomendaciones a establecer.
         */
        public void setRecomendaciones(String recomendaciones) {
            this.recomendaciones = recomendaciones;
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
     * Getter del atributo Lista de Beneficios
     *
     * @return el atributo Lista de Beneficios.
     */
    public List<String> getListaBeneficios() {
        return listaBeneficios;
    }

    /**
     * Setter del atributo Lista de Beneficios
     *
     * @param Lista de Beneficios el atributo Lista de Beneficios a establecer.
     */
    public void setListaBeneficios(List<String> listaBeneficios) {
        this.listaBeneficios = listaBeneficios;
    }
    

    /**
     * Getter del atributo Lista de Recomendaciones
     *
     * @return el atributo Lista de Recomendaciones.
     */
    public List<String> getListaRecomendaciones() {
        return listaRecomendaciones;
    }

    /**
     * Setter del atributo Lista de Recomendaciones
     *
     * @param Lista de Beneficios el atributo Lista de Recomendaciones a establecer.
     */
    public void setListaRecomendaciones(List<String> listaRecomendaciones) {
        this.listaRecomendaciones = listaRecomendaciones;
    }
        
   
    /**
     * Getter del atributo nombreAsesor.
     *
     * @return el atributo nombreAsesor.
     */
    public String getNombreAsesor() {
        return nombreAsesor;
    }

    /**
     * Setter del atributo nombreAsesor.
     *
     * @param nombreAsesor el atributo nombreAsesor a establecer.
     */
    public void setNombreAsesor(String nombreAsesor) {
        this.nombreAsesor = nombreAsesor;
    }

    /**
     * Getter del atributo cargoAsesor.
     *
     * @return el atributo cargoAsesor.
     */
    public String getCargoAsesor() {
        return cargoAsesor;
    }

    /**
     * Setter del atributo cargoAsesor.
     *
     * @param cargoAsesor el atributo cargoAsesor a establecer.
     */
    public void setCargoAsesor(String cargoAsesor) {
        this.cargoAsesor = cargoAsesor;
    }

    /**
     * Getter del atributo valorTotal.
     *
     * @return el atributo ValorTotal.
     */
    public Decimal getValorTotal() {
        return valorTotal;
    }

    /**
     * Setter del atributo valorTotal.
     *
     * @param valorTotal el atributo valorTotal a establecer.
     */
    public void setValorTotal(Decimal valorTotal) {
        this.valorTotal = valorTotal;
    }

    /**
     * Getter del atributo emailAsesor.
     *
     * @return el atributo emailAsesor.
     */
    public String getEmailAsesor() {
        return emailAsesor;
    }

    /**
     * Setter del atributo emailAsesor.
     *
     * @param emailAsesor el atributo emailAsesor a establecer.
     */
    public void setEmailAsesor(String emailAsesor) {
        this.emailAsesor = emailAsesor;
    }

    /**
     * Getter del atributo telefonoAsesor.
     *
     * @return el atributo telefonoAsesor.
     */
    public String getTelefonoAsesor() {
        return telefonoAsesor;
    }

    /**
     * Setter del atributo telefonoAsesor.
     *
     * @param telefonoAsesor el atributo telefonoAsesor a establecer.
     */
    public void setTelefonoAsesor(String telefonoAsesor) {
        this.telefonoAsesor = telefonoAsesor;
    }

    /**
     * Getter del atributo procesoAsesor.
     *
     * @return el atributo procesoAsesor.
     */
    public String getProcesoAsesor() {
        return procesoAsesor;
    }

    /**
     * Setter del atributo procesoAsesor.
     *
     * @param procesoAsesor el atributo procesoAsesor a establecer.
     */
    public void setProcesoAsesor(String procesoAsesor) {
        this.procesoAsesor = procesoAsesor;
    }


       /**
         * Getter del atributo Título Tabla Uno Sección Uno.
         * @return el atributo Título Tabla Uno Sección Uno.
         */
        public String getTituloTablaUnoSeccionUno() {
            return tituloTablaUnoSeccionUno;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Uno.
         * @param Título Tabla Uno Seccion Uno el atributo Título Tabla Uno Seccion Uno a establecer.
         */
        public void setTituloTablaUnoSeccionUno(String tituloTablaUnoSeccionUno) {
            this.tituloTablaUnoSeccionUno = tituloTablaUnoSeccionUno;
        } 

      /**
         * Getter del atributo Título Tabla Uno Sección Dos.
         * @return el atributo Título Tabla Uno Sección Dos.
         */
        public String getTituloTablaUnoSeccionDos() {
            return tituloTablaUnoSeccionDos;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Dos.
         * @param Título Tabla Uno Seccion Dos el atributo Título Tabla Uno Seccion Dos a establecer.
         */
        public void setTituloTablaUnoSeccionDos(String tituloTablaUnoSeccionDos) {
            this.tituloTablaUnoSeccionDos = tituloTablaUnoSeccionDos;
        } 
        
 /**
         * Getter del atributo Título Tabla Uno Sección Tres.
         * @return el atributo Título Tabla Uno Sección Tres.
         */
        public String getTituloTablaUnoSeccionTres() {
            return tituloTablaUnoSeccionTres;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Tres.
         * @param Título Tabla Uno Seccion Tres el atributo Título Tabla Uno Seccion Tres a establecer.
         */
        public void setTituloTablaUnoSeccionTres(String tituloTablaUnoSeccionTres) {
            this.tituloTablaUnoSeccionTres = tituloTablaUnoSeccionTres;
        } 
        
/**
         * Getter del atributo Título Tabla Uno Sección Cuatro.
         * @return el atributo Título Tabla Uno Sección Cuatro.
         */
        public String getTituloTablaUnoSeccionCuatro() {
            return tituloTablaUnoSeccionCuatro;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Cuatro.
         * @param Título Tabla Uno Seccion Cuatro el atributo Título Tabla Uno Seccion Cuatro a establecer.
         */
        public void setTituloTablaUnoSeccionCuatro(String tituloTablaUnoSeccionCuatro) {
            this.tituloTablaUnoSeccionCuatro = tituloTablaUnoSeccionCuatro;
        } 
        
      /**
         * Getter del atributo Título Tabla Uno Sección Cinco.
         * @return el atributo Título Tabla Uno Sección Cinco.
         */
        public String getTituloTablaUnoSeccionCinco() {
            return tituloTablaUnoSeccionCinco;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Cinco.
         * @param Título Tabla Uno Seccion Cinco el atributo Título Tabla Uno Seccion Cinco a establecer.
         */
        public void setTituloTablaUnoSeccionCinco(String tituloTablaUnoSeccionCinco) {
            this.tituloTablaUnoSeccionCinco = tituloTablaUnoSeccionCinco;
        } 
        
  /**
         * Getter del atributo Título Tabla Uno Sección Seis.
         * @return el atributo Título Tabla Uno Sección Seis.
         */
        public String getTituloTablaUnoSeccionSeis() {
            return tituloTablaUnoSeccionSeis;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Seis.
         * @param Título Tabla Uno Seccion Seis el atributo Título Tabla Uno Seccion Seis a establecer.
         */
        public void setTituloTablaUnoSeccionSeis(String tituloTablaUnoSeccionSeis) {
            this.tituloTablaUnoSeccionSeis = tituloTablaUnoSeccionSeis;
        } 
        
/**
         * Getter del atributo Título Tabla Uno Sección Siete.
         * @return el atributo Título Tabla Uno Sección Siete.
         */
        public String getTituloTablaUnoSeccionSiete() {
            return tituloTablaUnoSeccionSiete;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Siete.
         * @param Título Tabla Uno Seccion Siete el atributo Título Tabla Uno Seccion Siete a establecer.
         */
        public void setTituloTablaUnoSeccionSiete(String tituloTablaUnoSeccionSiete) {
            this.tituloTablaUnoSeccionSiete = tituloTablaUnoSeccionSiete;
        } 
        
 /**
         * Getter del atributo Título Tabla Uno Sección Ocho.
         * @return el atributo Título Tabla Uno Sección Ocho.
         */
        public String getTituloTablaUnoSeccionOcho() {
            return tituloTablaUnoSeccionOcho;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Ocho.
         * @param Título Tabla Uno Seccion Ocho el atributo Título Tabla Uno Seccion Ocho a establecer.
         */
        public void setTituloTablaUnoSeccionOcho(String tituloTablaUnoSeccionOcho) {
            this.tituloTablaUnoSeccionOcho = tituloTablaUnoSeccionOcho;
        } 

      /**
         * Getter del atributo Título Tabla Uno Sección Nueve.
         * @return el atributo Título Tabla Uno Sección Nueve.
         */
        public String getTituloTablaUnoSeccionNueve() {
            return tituloTablaUnoSeccionNueve;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Nueve.
         * @param Título Tabla Uno Seccion Nueve el atributo Título Tabla Uno Seccion Nueve a establecer.
         */
        public void setTituloTablaUnoSeccionNueve(String tituloTablaUnoSeccionNueve) {
            this.tituloTablaUnoSeccionNueve = tituloTablaUnoSeccionNueve;
        } 


      /**
         * Getter del atributo Título Tabla Uno Sección Diez.
         * @return el atributo Título Tabla Uno Sección Diez.
         */
        public String getTituloTablaUnoSeccionDiez() {
            return tituloTablaUnoSeccionDiez;
        }
        

        /**
         * Setter del atributo Título Tabla Uno Seccion Diez.
         * @param Título Tabla Uno Seccion Diez el atributo Título Tabla Uno Seccion Diez a establecer.
         */
        public void setTituloTablaUnoSeccionDiez(String tituloTablaUnoSeccionDiez) {
            this.tituloTablaUnoSeccionDiez = tituloTablaUnoSeccionDiez;
        } 

        /**
         * Getter del atributo Valores Tabla Uno Sección Uno.
         * @return el atributo Valores Tabla Uno Sección Uno.
         */
        public String getValoresTablaUnoSeccionUno() {
            return valoresTablaUnoSeccionUno;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Uno.
         * @param Valores Tabla Uno Seccion Uno el atributo Valores Tabla Uno Seccion Uno a establecer.
         */
        public void setValoresTablaUnoSeccionUno(String valoresTablaUnoSeccionUno) {
            this.valoresTablaUnoSeccionUno = valoresTablaUnoSeccionUno;
        } 

        /**
         * Getter del atributo Valores Tabla Uno Sección Dos.
         * @return el atributo Valores Tabla Uno Sección Dos.
         */
        public String getValoresTablaUnoSeccionDos() {
            return valoresTablaUnoSeccionDos;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Dos.
         * @param Valores Tabla Uno Seccion Dos el atributo Valores Tabla Uno Seccion Dos a establecer.
         */
        public void setValoresTablaUnoSeccionDos(String valoresTablaUnoSeccionDos) {
            this.valoresTablaUnoSeccionDos = valoresTablaUnoSeccionDos;
        } 
        

         /**
         * Getter del atributo Valores Tabla Uno Sección Tres.
         * @return el atributo Valores Tabla Uno Sección Tres.
         */
        public String getValoresTablaUnoSeccionTres() {
            return valoresTablaUnoSeccionTres;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Tres.
         * @param Valores Tabla Uno Seccion Tres el atributo Valores Tabla Uno Seccion Tres a establecer.
         */
        public void setValoresTablaUnoSeccionTres(String valoresTablaUnoSeccionTres) {
            this.valoresTablaUnoSeccionTres = valoresTablaUnoSeccionTres;
        } 
        
         /**
         * Getter del atributo Valores Tabla Uno Sección Cuatro.
         * @return el atributo Valores Tabla Uno Sección Cuatro.
         */
        public String getValoresTablaUnoSeccionCuatro() {
            return valoresTablaUnoSeccionCuatro;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Cuatro.
         * @param Valores Tabla Uno Seccion Cuatro el atributo Valores Tabla Uno Seccion Cuatro a establecer.
         */
        public void setValoresTablaUnoSeccionCuatro(String valoresTablaUnoSeccionCuatro) {
            this.valoresTablaUnoSeccionCuatro = valoresTablaUnoSeccionCuatro;
        } 

        /**
         * Getter del atributo Valores Tabla Uno Sección Cinco.
         * @return el atributo Valores Tabla Uno Sección Cinco.
         */
        public String getValoresTablaUnoSeccionCinco() {
            return valoresTablaUnoSeccionCinco;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Cinco.
         * @param Valores Tabla Uno Seccion Cinco el atributo Valores Tabla Uno Seccion Cinco a establecer.
         */
        public void setValoresTablaUnoSeccionCinco(String valoresTablaUnoSeccionCinco) {
            this.valoresTablaUnoSeccionCinco = valoresTablaUnoSeccionCinco;
        } 
        
       /**
         * Getter del atributo Valores Tabla Uno Sección Seis.
         * @return el atributo Valores Tabla Uno Sección Seis.
         */
        public String getValoresTablaUnoSeccionSeis() {
            return valoresTablaUnoSeccionSeis;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Seis.
         * @param Valores Tabla Seis Seccion Uno el atributo Valores Tabla Seis Seccion Seis a establecer.
         */
        public void setValoresTablaUnoSeccionSeis(String valoresTablaUnoSeccionSeis) {
            this.valoresTablaUnoSeccionSeis = valoresTablaUnoSeccionSeis;
        } 
        
     /**
         * Getter del atributo Valores Tabla Uno Sección Siete.
         * @return el atributo Valores Tabla Uno Sección Siete.
         */
        public String getValoresTablaUnoSeccionSiete() {
            return valoresTablaUnoSeccionSiete;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Siete.
         * @param Valores Tabla Siete Seccion Uno el atributo Valores Tabla Uno Seccion Siete a establecer.
         */
        public void setValoresTablaUnoSeccionSiete(String valoresTablaUnoSeccionSiete) {
            this.valoresTablaUnoSeccionSiete = valoresTablaUnoSeccionSiete;
        } 
        
        /**
         * Getter del atributo Valores Tabla Uno Sección Ocho.
         * @return el atributo Valores Tabla Uno Sección Ocho.
         */
        public String getValoresTablaUnoSeccionOcho() {
            return valoresTablaUnoSeccionOcho;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Ocho.
         * @param Valores Tabla Uno Seccion Ocho el atributo Valores Tabla Uno Seccion Ocho a establecer.
         */
        public void setValoresTablaUnoSeccionOcho(String valoresTablaUnoSeccionOcho) {
            this.valoresTablaUnoSeccionOcho = valoresTablaUnoSeccionOcho;
        } 
        
         /**
         * Getter del atributo Valores Tabla Uno Sección Nueve.
         * @return el atributo Valores Tabla Uno Sección Nueve.
         */
        public String getValoresTablaUnoSeccionNueve() {
            return valoresTablaUnoSeccionNueve;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Nueve.
         * @param Valores Tabla Uno Seccion Nueve el atributo Valores Tabla Uno Seccion Nueve a establecer.
         */
        public void setValoresTablaUnoSeccionNueve(String valoresTablaUnoSeccionNueve) {
            this.valoresTablaUnoSeccionNueve = valoresTablaUnoSeccionNueve;
        } 

         /**
         * Getter del atributo Valores Tabla Uno Sección Diez.
         * @return el atributo Valores Tabla Uno Sección Diez.
         */
        public String getValoresTablaUnoSeccionDiez() {
            return valoresTablaUnoSeccionDiez;
        }
        

        /**
         * Setter del atributo Valores Tabla Uno Seccion Diez.
         * @param Valores Tabla Diez Seccion Uno el atributo Valores Tabla Uno Seccion Diez a establecer.
         */
        public void setValoresTablaUnoSeccionDiez(String valoresTablaUnoSeccionDiez) {
            this.valoresTablaUnoSeccionDiez = valoresTablaUnoSeccionDiez;
        }
        
        
   /**
     * Getter del atributo Lista Sección Uno Tabla Uno
     * @return el atributo Lista Sección Uno Tabla Uno
     */
    public List<String> getListaSeccionUnoTablaUno() {
        return listaSeccionUnoTablaUno;
    } 
 
 
   /**
     * Getter del atributo Lista Sección Dos Tabla Uno
     * @return el atributo Lista Sección Dos Tabla Uno
     */
    public List<String> getListaSeccionDosTablaUno() {
        return listaSeccionDosTablaUno;
    } 
 
   /**
     * Getter del atributo Lista Sección Tres Tabla Uno
     * @return el atributo Lista Sección Tres Tabla Uno
     */
    public List<String> getListaSeccionTresTablaUno() {
        return listaSeccionTresTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Cuatro Tabla Uno
     * @return el atributo Lista Sección Cuatro Tabla Uno
     */
    public List<String> getListaSeccionCuatroTablaUno() {
        return listaSeccionCuatroTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Cinco Tabla Uno
     * @return el atributo Lista Sección Cinco Tabla Uno
     */
    public List<String> getListaSeccionCincoTablaUno() {
        return listaSeccionCincoTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Seis Tabla Uno
     * @return el atributo Lista Sección Seis Tabla Uno
     */
    public List<String> getListaSeccionSeisTablaUno() {
        return listaSeccionSeisTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Siete Tabla Uno
     * @return el atributo Lista Sección Siete Tabla Uno
     */
    public List<String> getListaSeccionSieteTablaUno() {
        return listaSeccionSieteTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Ocho Tabla Uno
     * @return el atributo Lista Sección Ocho Tabla Uno
     */
    public List<String> getListaSeccionOchoTablaUno() {
        return listaSeccionOchoTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Nueve Tabla Uno
     * @return el atributo Lista Sección Nueve Tabla Uno
     */
    public List<String> getListaSeccionNueveTablaUno() {
        return listaSeccionNueveTablaUno;
    } 
    
      /**
     * Getter del atributo Lista Sección Diez Tabla Uno
     * @return el atributo Lista Sección Diez Tabla Uno
     */
    public List<String> getListaSeccionDiezTablaUno() {
        return listaSeccionDiezTablaUno;
    }
    
    
        /**
         * Getter del atributo Título Tabla Dos Sección Uno.
         * @return el atributo Título Tabla Dos Sección Uno.
         */
        public String getTituloTablaDosSeccionUno() {
            return tituloTablaDosSeccionUno;
        }
        

        /**
         * Setter del atributo Título Tabla Dos Seccion Uno.
         * @param Título Tabla Dos Seccion Uno el atributo Título Tabla Dos Seccion Uno a establecer.
         */
        public void setTituloTablaDosSeccionUno(String tituloTablaDosSeccionUno) {
            this.tituloTablaDosSeccionUno = tituloTablaDosSeccionUno;
        } 

      /**
         * Getter del atributo Título Tabla Dos Sección Dos.
         * @return el atributo Título Tabla Dos Sección Dos.
         */
        public String getTituloTablaDosSeccionDos() {
            return tituloTablaDosSeccionDos;
        }
        

        /**
         * Setter del atributo Título Tabla Dos Seccion Dos.
         * @param Título Tabla Dos Seccion Dos el atributo Título Tabla Dos Seccion Dos a establecer.
         */
        public void setTituloTablaDosSeccionDos(String tituloTablaDosSeccionDos) {
            this.tituloTablaDosSeccionDos = tituloTablaDosSeccionDos;
        } 
        
 /**
         * Getter del atributo Título Tabla Dos Sección Tres.
         * @return el atributo Título Tabla Dos Sección Tres.
         */
        public String getTituloTablaDosSeccionTres() {
            return tituloTablaDosSeccionTres;
        }
        

        /**
         * Setter del atributo Título Tabla Dos Seccion Tres.
         * @param Título Tabla Dos Seccion Tres el atributo Título Tabla Dos Seccion Tres a establecer.
         */
        public void setTituloTablaDosSeccionTres(String tituloTablaDosSeccionTres) {
            this.tituloTablaDosSeccionTres = tituloTablaDosSeccionTres;
        } 
        
/**
         * Getter del atributo Título Tabla Dos Sección Cuatro.
         * @return el atributo Título Tabla Dos Sección Cuatro.
         */
        public String getTituloTablaDosSeccionCuatro() {
            return tituloTablaDosSeccionCuatro;
        }
        

        /**
         * Setter del atributo Título Tabla Dos Seccion Cuatro.
         * @param Título Tabla Dos Seccion Cuatro el atributo Título Tabla Dos Seccion Cuatro a establecer.
         */
        public void setTituloTablaDosSeccionCuatro(String tituloTablaDosSeccionCuatro) {
            this.tituloTablaDosSeccionCuatro = tituloTablaDosSeccionCuatro;
        } 
        
      /**
         * Getter del atributo Título Tabla Dos Sección Cinco.
         * @return el atributo Título Tabla Dos Sección Cinco.
         */
        public String getTituloTablaDosSeccionCinco() {
            return tituloTablaDosSeccionCinco;
        }
        

        /**
         * Setter del atributo Título Tabla Dos Seccion Cinco.
         * @param Título Tabla Dos Seccion Cinco el atributo Título Tabla Dos Seccion Cinco a establecer.
         */
        public void setTituloTablaDosSeccionCinco(String tituloTablaDosSeccionCinco) {
            this.tituloTablaDosSeccionCinco = tituloTablaDosSeccionCinco;
        }  
 
 
  /**
         * Getter del atributo Título Tabla Tres Sección Uno.
         * @return el atributo Título Tabla Tres Sección Uno.
         */
        public String getTituloTablaTresSeccionUno() {
            return tituloTablaTresSeccionUno;
        }
        

        /**
         * Setter del atributo Título Tabla Tres Seccion Uno.
         * @param Título Tabla Tres Seccion Uno el atributo Título Tabla Tres Seccion Uno a establecer.
         */
        public void setTituloTablaTresSeccionUno(String tituloTablaTresSeccionUno) {
            this.tituloTablaTresSeccionUno = tituloTablaTresSeccionUno;
        } 

      /**
         * Getter del atributo Título Tabla Tres Sección Dos.
         * @return el atributo Título Tabla Tres Sección Dos.
         */
        public String getTituloTablaTresSeccionDos() {
            return tituloTablaTresSeccionDos;
        }
        

        /**
         * Setter del atributo Título Tabla Tres Seccion Dos.
         * @param Título Tabla Tres Seccion Dos el atributo Título Tabla Tres Seccion Dos a establecer.
         */
        public void setTituloTablaTresSeccionDos(String tituloTablaTresSeccionDos) {
            this.tituloTablaTresSeccionDos = tituloTablaTresSeccionDos;
        } 
        
 /**
         * Getter del atributo Título Tabla Tres Sección Tres.
         * @return el atributo Título Tabla Tres Sección Tres.
         */
        public String getTituloTablaTresSeccionTres() {
            return tituloTablaTresSeccionTres;
        }
        

        /**
         * Setter del atributo Título Tabla Tres Seccion Tres.
         * @param Título Tabla Tres Seccion Tres el atributo Título Tabla Tres Seccion Tres a establecer.
         */
        public void setTituloTablaTresSeccionTres(String tituloTablaTresSeccionTres) {
            this.tituloTablaTresSeccionTres = tituloTablaTresSeccionTres;
        } 
        
/**
         * Getter del atributo Título Tabla Tres Sección Cuatro.
         * @return el atributo Título Tabla Tres Sección Cuatro.
         */
        public String getTituloTablaTresSeccionCuatro() {
            return tituloTablaTresSeccionCuatro;
        }
        

        /**
         * Setter del atributo Título Tabla Tres Seccion Cuatro.
         * @param Título Tabla Tres Seccion Cuatro el atributo Título Tabla Tres Seccion Cuatro a establecer.
         */
        public void setTituloTablaTresSeccionCuatro(String tituloTablaTresSeccionCuatro) {
            this.tituloTablaTresSeccionCuatro = tituloTablaTresSeccionCuatro;
        } 
        
      /**
         * Getter del atributo Título Tabla Tres Sección Cinco.
         * @return el atributo Título Tabla Tres Sección Cinco.
         */
        public String getTituloTablaTresSeccionCinco() {
            return tituloTablaTresSeccionCinco;
        }
        

        /**
         * Setter del atributo Título Tabla Tres Seccion Cinco.
         * @param Título Tabla Tres Seccion Cinco el atributo Título Tabla Tres Seccion Cinco a establecer.
         */
        public void setTituloTablaTresSeccionCinco(String tituloTablaTresSeccionCinco) {
            this.tituloTablaTresSeccionCinco = tituloTablaTresSeccionCinco;
        } 
        
       /**
         * Getter del atributo Valores Tabla Dos Sección Uno.
         * @return el atributo Valores Tabla Dos Sección Uno.
         */
        public String getValoresTablaDosSeccionUno() {
            return valoresTablaDosSeccionUno;
        }
        

        /**
         * Setter del atributo Valores Tabla Dos Seccion Uno.
         * @param Valores Tabla Dos Seccion Uno el atributo Valores Tabla Dos Seccion Uno a establecer.
         */
        public void setValoresTablaDosSeccionUno(String valoresTablaDosSeccionUno) {
            this.valoresTablaDosSeccionUno = valoresTablaDosSeccionUno;
        } 

        /**
         * Getter del atributo Valores Tabla Dos Sección Dos.
         * @return el atributo Valores Tabla Dos Sección Dos.
         */
        public String getValoresTablaDosSeccionDos() {
            return valoresTablaDosSeccionDos;
        }
        

        /**
         * Setter del atributo Valores Tabla Dos Seccion Dos.
         * @param Valores Tabla Dos Seccion Dos el atributo Valores Tabla Dos Seccion Dos a establecer.
         */
        public void setValoresTablaDosSeccionDos(String valoresTablaDosSeccionDos) {
            this.valoresTablaDosSeccionDos = valoresTablaDosSeccionDos;
        } 
        

         /**
         * Getter del atributo Valores Tabla Dos Sección Tres.
         * @return el atributo Valores Tabla Dos Sección Tres.
         */
        public String getValoresTablaDosSeccionTres() {
            return valoresTablaDosSeccionTres;
        }
        

        /**
         * Setter del atributo Valores Tabla Dos Seccion Tres.
         * @param Valores Tabla Dos Seccion Tres el atributo Valores Tabla Dos Seccion Tres a establecer.
         */
        public void setValoresTablaDosSeccionTres(String valoresTablaDosSeccionTres) {
            this.valoresTablaDosSeccionTres = valoresTablaDosSeccionTres;
        } 
        
         /**
         * Getter del atributo Valores Tabla Dos Sección Cuatro.
         * @return el atributo Valores Tabla Dos Sección Cuatro.
         */
        public String getValoresTablaDosSeccionCuatro() {
            return valoresTablaDosSeccionCuatro;
        }
        

        /**
         * Setter del atributo Valores Tabla Dos Seccion Cuatro.
         * @param Valores Tabla Dos Seccion Cuatro el atributo Valores Tabla Dos Seccion Cuatro a establecer.
         */
        public void setValoresTablaDosSeccionCuatro(String valoresTablaDosSeccionCuatro) {
            this.valoresTablaDosSeccionCuatro = valoresTablaDosSeccionCuatro;
        } 

        /**
         * Getter del atributo Valores Tabla Dos Sección Cinco.
         * @return el atributo Valores Tabla Dos Sección Cinco.
         */
        public String getValoresTablaDosSeccionCinco() {
            return valoresTablaDosSeccionCinco;
        }
        
        /**
         * Setter del atributo Valores Tabla Dos Seccion Cinco.
         * @param Valores Tabla Dos Seccion Cinco el atributo Valores Tabla Dos Seccion Cinco a establecer.
         */
        public void setValoresTablaDosSeccionCinco(String valoresTablaDosSeccionCinco) {
            this.valoresTablaDosSeccionCinco = valoresTablaDosSeccionCinco;
        } 
        
        /**
         * Getter del atributo Valores Tabla Tres Sección Uno.
         * @return el atributo Valores Tabla Tres Sección Uno.
         */
        public String getValoresTablaTresSeccionUno() {
            return valoresTablaTresSeccionUno;
        }
        

        /**
         * Setter del atributo Valores Tabla Tres Seccion Uno.
         * @param Valores Tabla Tres Seccion Uno el atributo Valores Tabla Tres Seccion Uno a establecer.
         */
        public void setValoresTablaTresSeccionUno(String valoresTablaTresSeccionUno) {
            this.valoresTablaTresSeccionUno = valoresTablaTresSeccionUno;
        } 

        /**
         * Getter del atributo Valores Tabla Tres Sección Dos.
         * @return el atributo Valores Tabla Tres Sección Dos.
         */
        public String getValoresTablaTresSeccionDos() {
            return valoresTablaTresSeccionDos;
        }
        

        /**
         * Setter del atributo Valores Tabla Tres Seccion Dos.
         * @param Valores Tabla Tres Seccion Dos el atributo Valores Tabla Tres Seccion Dos a establecer.
         */
        public void setValoresTablaTresSeccionDos(String valoresTablaTresSeccionDos) {
            this.valoresTablaTresSeccionDos = valoresTablaTresSeccionDos;
        } 
        

         /**
         * Getter del atributo Valores Tabla Tres Sección Tres.
         * @return el atributo Valores Tabla Tres Sección Tres.
         */
        public String getValoresTablaTresSeccionTres() {
            return valoresTablaTresSeccionTres;
        }
        

        /**
         * Setter del atributo Valores Tabla Tres Seccion Tres.
         * @param Valores Tabla Tres Seccion Tres el atributo Valores Tabla Tres Seccion Tres a establecer.
         */
        public void setValoresTablaTresSeccionTres(String valoresTablaTresSeccionTres) {
            this.valoresTablaTresSeccionTres = valoresTablaTresSeccionTres;
        } 
        
         /**
         * Getter del atributo Valores Tabla Tres Sección Cuatro.
         * @return el atributo Valores Tabla Tres Sección Cuatro.
         */
        public String getValoresTablaTresSeccionCuatro() {
            return valoresTablaTresSeccionCuatro;
        }
        

        /**
         * Setter del atributo Valores Tabla Tres Seccion Cuatro.
         * @param Valores Tabla Tres Seccion Cuatro el atributo Valores Tabla Tres Seccion Cuatro a establecer.
         */
        public void setValoresTablaTresSeccionCuatro(String valoresTablaTresSeccionCuatro) {
            this.valoresTablaTresSeccionCuatro = valoresTablaTresSeccionCuatro;
        } 

        /**
         * Getter del atributo Valores Tabla Tres Sección Cinco.
         * @return el atributo Valores Tabla Tres Sección Cinco.
         */
        public String getValoresTablaTresSeccionCinco() {
            return valoresTablaTresSeccionCinco;
        }  
        
        
        /**
         * Setter del atributo Valores Tabla Tres Seccion Cinco.
         * @param Valores Tabla Tres Seccion Cinco el atributo Valores Tabla Tres Seccion Cinco a establecer.
         */
        public void setValoresTablaTresSeccionCinco(String valoresTablaTresSeccionCinco) {
            this.valoresTablaTresSeccionCinco = valoresTablaTresSeccionCinco;
        }
        
        
      
   /**
     * Getter del atributo Lista Sección Uno Tabla Dos
     * @return el atributo Lista Sección Uno Tabla Dos
     */
    public List<String> getListaSeccionUnoTablaDos() {
        return listaSeccionUnoTablaDos;
    } 
 
 
   /**
     * Getter del atributo Lista Sección Dos Tabla Dos
     * @return el atributo Lista Sección Dos Tabla Dos
     */
    public List<String> getListaSeccionDosTablaDos() {
        return listaSeccionDosTablaDos;
    } 
 
   /**
     * Getter del atributo Lista Sección Tres Tabla Dos
     * @return el atributo Lista Sección Tres Tabla Dos
     */
    public List<String> getListaSeccionTresTablaDos() {
        return listaSeccionTresTablaDos;
    } 
    
      /**
     * Getter del atributo Lista Sección Cuatro Tabla Dos
     * @return el atributo Lista Sección Cuatro Tabla Dos
     */
    public List<String> getListaSeccionCuatroTablaDos() {
        return listaSeccionCuatroTablaDos;
    } 
    
      /**
     * Getter del atributo Lista Sección Cinco Tabla Dos
     * @return el atributo Lista Sección Cinco Tabla Dos
     */
    public List<String> getListaSeccionCincoTablaDos() {
        return listaSeccionCincoTablaDos;
    }
    
    
    
    
   /**
     * Getter del atributo Lista Sección Uno Tabla Tres
     * @return el atributo Lista Sección Uno Tabla Tres
     */
    public List<String> getListaSeccionUnoTablaTres() {
        return listaSeccionUnoTablaTres;
    } 
 
 
   /**
     * Getter del atributo Lista Sección Dos Tabla Tres
     * @return el atributo Lista Sección Dos Tabla Tres
     */
    public List<String> getListaSeccionDosTablaTres() {
        return listaSeccionDosTablaTres;
    } 
 
   /**
     * Getter del atributo Lista Sección Tres Tabla Tres
     * @return el atributo Lista Sección Tres Tabla Tres
     */
    public List<String> getListaSeccionTresTablaTres() {
        return listaSeccionTresTablaTres;
    } 
    
      /**
     * Getter del atributo Lista Sección Cuatro Tabla Tres
     * @return el atributo Lista Sección Cuatro Tabla Tres
     */
    public List<String> getListaSeccionCuatroTablaTres() {
        return listaSeccionCuatroTablaTres;
    } 
    
      /**
     * Getter del atributo Lista Sección Cinco Tabla Tres
     * @return el atributo Lista Sección Cinco Tabla Tres
     */
    public List<String> getListaSeccionCincoTablaTres() {
        return listaSeccionCincoTablaTres;
    }
    

      /**
         * Getter del atributo Título Tabla Cinco Columna Uno.
         * @return el atributo título Título Tabla Cinco Columna Uno.
         */
        public String getTituloTablaCincoColumnaUno() {
            return tituloTablaCincoColumnaUno;
        }
        

        /**
         * Setter del atributo Título Tabla Cinco Columna Uno.
         * @param Título Tabla Cinco Columna Uno el atributo Título Tabla Cinco Columna Uno a establecer.
         */
        public void setTituloTablaCincoColumnaUno(String tituloTablaCincoColumnaUno) {
            this.tituloTablaCincoColumnaUno = tituloTablaCincoColumnaUno;
        }
        
        

      /**
         * Getter del atributo Título Tabla Cinco Columna Dos.
         * @return el atributo título Título Tabla Cinco Columna Dos.
         */
        public String getTituloTablaCincoColumnaDos() {
            return tituloTablaCincoColumnaDos;
        }
        

        /**
         * Setter del atributo Título Tabla Cinco Columna Dos.
         * @param Título Tabla Cinco Columna Dos el atributo Título Tabla Cinco Columna Dos a establecer.
         */
        public void setTituloTablaCincoColumnaDos(String tituloTablaCincoColumnaDos) {
            this.tituloTablaCincoColumnaDos = tituloTablaCincoColumnaDos;
        } 
        
 
     /**
     * Getter del atributo Lista Columna Uno Tabla cinco
     * @return el atributo Lista Columna Uno Tabla cinco
     */
    public List<COM_PVECotizacionChequeosMedicos_ctr.SedeExamenes_cls> getListaSedes() {
        return listaSedes;
    }
    
 
  /**
     * Getter del atributo itemsPropuestaEconomica.
     *
     * @return el atributo itemsPropuestaEconomica.
     */
    public List<COM_PVEPropuestaEconomica_cls> getItemsPropuestaEconomica() {
        return itemsPropuestaEconomica;
    }

    /**
     * Setter del atributo itemsPropuestaEconomica.
     *
     * @param itemsPropuestaEconomica el atributo itemsPropuestaEconomica a establecer.
     */
    public void setItemsPropuestaEconomica(List<COM_PVEPropuestaEconomica_cls> itemsPropuestaEconomica) {
        this.itemsPropuestaEconomica = itemsPropuestaEconomica;
    }   
    
     /**
        
    

        /**
         * Getter del atributo Valores Tabla Cinco Columna Uno.
         * @return el atributo Valores Tabla Cinco Columna Uno.
         */
        public String getValoresTablaCincoColumnaUno() {
            return valoresTablaCincoColumnaUno;
        }  
        
        
        /**
         * Setter del atributo Valores Tabla Cinco Columna Uno.
         * @param Valores Tabla Cinco Columna Uno el atributo Valores Tabla Cinco Columna Uno a establecer.
         */
        public void setValoresTablaCincoColumnaUno(String valoresTablaCincoColumnaUno) {
            this.valoresTablaCincoColumnaUno = valoresTablaCincoColumnaUno;
        }


        /**
         * Getter del atributo Valores Tabla Cinco Columna Dos.
         * @return el atributo Valores Tabla Cinco Columna Dos.
         */
        public String getValoresTablaCincoColumnaDos() {
            return valoresTablaCincoColumnaDos;
        }  
        
        
        /**
         * Setter del atributo Valores Tabla Cinco Columna Dos.
         * @param Valores Tabla Cinco Columna Dos el atributo Valores Tabla Cinco Columna Dos a establecer.
         */
        public void setValoresTablaCincoColumnaDos(String valoresTablaCincoColumnaDos) {
            this.valoresTablaCincoColumnaDos = valoresTablaCincoColumnaDos;
        }



      /**
         * Getter del atributo Título Tabla Cuatro Columna Uno.
         * @return el atributo título Título Tabla Cuatro Columna Uno.
         */
        public String getTituloTablaCuatroColumnaUno() {
            return tituloTablaCuatroColumnaUno;
        }
        

        /**
         * Setter del atributo Título Tabla Cuatro Columna Uno.
         * @param Título Tabla Cuatro Columna Uno el atributo Título Tabla Cuatro Columna Uno a establecer.
         */
        public void setTituloTablaCuatroColumnaUno(String tituloTablaCuatroColumnaUno) {
            this.tituloTablaCuatroColumnaUno = tituloTablaCuatroColumnaUno;
        }
 
 
 
      /**
         * Getter del atributo Título Tabla Cuatro Columna Dos.
         * @return el atributo título Título Tabla Cuatro Columna Dos.
         */
        public String getTituloTablaCuatroColumnaDos() {
            return tituloTablaCuatroColumnaDos;
        }
        

        /**
         * Setter del atributo Título Tabla Cuatro Columna Dos.
         * @param Título Tabla Cuatro Columna Dos el atributo Título Tabla Cuatro Columna Dos a establecer.
         */
        public void setTituloTablaCuatroColumnaDos(String tituloTablaCuatroColumnaDos) {
            this.tituloTablaCuatroColumnaDos = tituloTablaCuatroColumnaDos;
        }
        
 
 
      /**
         * Getter del atributo Título Tabla Cuatro Columna Tres.
         * @return el atributo título Título Tabla Cuatro Columna Tres.
         */
        public String getTituloTablaCuatroColumnaTres() {
            return tituloTablaCuatroColumnaTres;
        }
        

        /**
         * Setter del atributo Título Tabla Cuatro Columna Tres.
         * @param Título Tabla Cuatro Columna Tres el atributo Título Tabla Cuatro Columna Tres a establecer.
         */
        public void setTituloTablaCuatroColumnaTres(String tituloTablaCuatroColumnaTres) {
            this.tituloTablaCuatroColumnaTres = tituloTablaCuatroColumnaTres;
        }
        
 
      /**
         * Getter del atributo Título Tabla Cuatro Columna Cuatro.
         * @return el atributo título Título Tabla Cuatro Columna Cuatro.
         */
        public String getTituloTablaCuatroColumnaCuatro() {
            return tituloTablaCuatroColumnaCuatro;
        }
        

        /**
         * Setter del atributo Título Tabla Cuatro Columna Cuatro.
         * @param Título Tabla Cuatro Columna Cuatro el atributo Título Tabla Cuatro Columna Cuatro a establecer.
         */
        public void setTituloTablaCuatroColumnaCuatro(String tituloTablaCuatroColumnaCuatro) {
            this.tituloTablaCuatroColumnaCuatro = tituloTablaCuatroColumnaCuatro;
        }
               

      /**
         * Getter del atributo Título Tabla Cuatro Columna Cinco.
         * @return el atributo título Título Tabla Cuatro Columna Cinco.
         */
        public String getTituloTablaCuatroColumnaCinco() {
            return tituloTablaCuatroColumnaCinco;
        }
        

        /**
         * Setter del atributo Título Tabla Cuatro Columna Cinco.
         * @param Título Tabla Cuatro Columna Cinco el atributo Título Tabla Cuatro Columna Cinco a establecer.
         */
        public void setTituloTablaCuatroColumnaCinco(String tituloTablaCuatroColumnaCinco) {
            this.tituloTablaCuatroColumnaCinco = tituloTablaCuatroColumnaCinco;
        }
               



  public class SedeExamenes_cls
        {

            public String sede;
            public String direccion;
   
               public String getSede() {
                  return sede;
               }  
               
               public String getDireccion() {
                  return direccion;
               }  

        }


    /**
     * Clase encargada de definir los atributos de los items de propuessta economica.
     */
    public class COM_PVEPropuestaEconomica_cls {

        /** Categoría del producto. **/
        private String categoria;

        /** Subcategoria del producto. **/
        private String subcategoria;

        /** Valor del producto. **/
        private Decimal valor;

        /** Valor del subvalor. **/
        private Decimal subvalor;

        /** Valor del descuento. **/
        private Decimal descuento;
        
        /** Nombre del producto. **/
        private String producto;
        
        /** Descripción del producto. **/
        private String descripcion;
         /** Descripción del producto. **/
        private String poblacion;
        private Decimal nopax;
        private Decimal unitario;

        /**
         * Getter del atributo Categoría.
         * @return el atributo Categoría.
         */
        public String getCategoria() {
            return categoria;
        }
        public String getPoblacion() {
            return poblacion;
        }

        /**
         * Setter del atributo Categoría.
         * @param Categoría el atributo Categoría a establecer.
         */
        public void setCategoria(String categoria) {
            this.categoria = categoria;
        }
        public void setPoblacion(String poblacion) {
            this.poblacion = poblacion;
        }


        /**
         * Getter del atributo SubCategoría.
         * @return el atributo SubCategoría.
         */
        public String getSubCategoria() {
            return subCategoria;
        }

        /**
         * Setter del atributo SubCategoría.
         * @param SubCategoría el atributo SubCategoría a establecer.
         */
        public void setSubCategoria(String subcategoria) {
            this.subcategoria = subcategoria;
        }
     
        /**
         * Getter del atributo Valor.
         * @return el atributo Valor.
         */
        public Decimal getValor() {
            return valor;
        }

        /**
         * Setter del atributo Valor.
         * @param Valor el atributo Valor a establecer.
         */
        public void setValor(Decimal valor) {
            this.valor = valor;
        }
        

        /**
         * Getter del atributo Producto.
         * @return el atributo Producto.
         */
        public String getProducto() {
            return producto;
        }

        /**
         * Setter del atributo Producto.
         * @param Producto el atributo Producto a establecer.
         */
        public void setProducto(String producto) {
            this.producto = producto;
        }        
       
       
       
        /**
         * Getter del atributo Descripción.
         * @return el atributo Descripción.
         */
        public String getDescripcion() {
            return descripcion;
        }

        /**
         * Setter del atributo Descripcion.
         * @param Descripcion el atributo Descripcion a establecer.
         */
        public void setDescripcion(String descripcion) {
            this.descripcion = descripcion;
        }        

        /**
         * Getter del atributo Descripción.
         * @return el atributo Descripción.
         */
        public Decimal getSubvalor() {
            return subvalor;
        }

        /**
         * Setter del atributo Descripcion.
         * @param Descripcion el atributo Descripcion a establecer.
         */
        public void setSubvalor(Decimal subvalor) {
            this.subvalor = subvalor;
        }     
        /**
         * Getter del atributo Descripción.
         * @return el atributo Descripción.
         */
        public Decimal getDescuento() {
            return descuento;
        }

        /**
         * Setter del atributo Descripcion.
         * @param Descripcion el atributo Descripcion a establecer.
         */
        public void setDescuento(Decimal descuento) {
            this.descuento = descuento;
        }          
        
        public Decimal getNoPax() {
            return nopax;
        }
        
        public void setNoPax(Decimal nopax) {
            this.nopax = nopax;
        } 
       
        public Decimal getUnitario() {
            return unitario;
        }

        public void setUnitario(Decimal unitario) {
            this.unitario = unitario;
        }  

    }

  /**
    Carga el contenido dinámico a partir de el identificador de la cotización recuperado como parámetro.
  */
     public void cargarContenidoDinamico() {
     
     String idOppt='';
        
         
         //Obtener identificador de la Oportunidad a partir del id de la cotización
         List<Quote> lstCotizacion =    [SELECT OpportunityId           
                                           FROM Quote
                                           WHERE Id =: idOportunidad ];
                 
        for(Integer i=0;i<lstCotizacion.size();i++){
            
               Quote cotizacion = lstCotizacion.get(i);
               idOppt = cotizacion.OpportunityId;
        }
                
        //Obtener la información requerida de la Oportunidad.                
        list<Opportunity> lstOportunidades  = [SELECT id, 
                                               Account.Name,  Owner.FirstName, Owner.LastName, 
                                               Owner.MobilePhone, Owner.Email, Owner.Title, Amount   
                                               FROM Opportunity
                                               WHERE id =: idOppt]; 
                                               
                                               
        for(Integer i=0;i<lstOportunidades.size();i++){
            
               Opportunity objOportunidad = lstOportunidades.get(i);
               nombreCliente = objOportunidad.Account.Name;
               String nombreOwner = objOportunidad.Owner.FirstName;
               String apellidoOwner = objOportunidad.Owner.LastName;
               nombreAsesor =nombreOwner+' '+ apellidoOwner;
               telefonoAsesor = objOportunidad.Owner.MobilePhone;
               emailAsesor = objOportunidad.Owner.Email;
               cargoAsesor = objOportunidad.Owner.Title;
               valorTotal = objOportunidad.Amount;
               
        }
        
        
       //Obtener la información de los productos y productos por oportunidad
       list<OpportunityLineItem> lstProdPorOportunidad = [SELECT id, Product2.Name, Product2.COM_TipoPoblacion__c,
                                                          Product2.COM_CategoriaSalud__c, Product2.COM_SubCategoriaSalud__c,
                                                          Product2.Description, TotalPrice, Product2.Family, Subtotal, Discount,
                                                          Quantity, UnitPrice   
                                                          FROM OpportunityLineItem
                                                          WHERE OpportunityId =: idOppt]; 
       
       for(Integer i=0;i<lstProdPorOportunidad.size();i++){
            
               OpportunityLineItem objProdOportunidad = lstProdPorOportunidad.get(i);
               String nombreProducto = objProdOportunidad.Product2.Name; 
               String categoriaProducto = objProdOportunidad.Product2.COM_CategoriaSalud__c; 
               String subCatProducto = objProdOportunidad.Product2.COM_SubCategoriaSalud__c; 
               Decimal precioProducto = objProdOportunidad.TotalPrice; 
               String descripcionProducto = objProdOportunidad.Product2.Description; 
               String familiaProducto = objProdOportunidad.Product2.Name; 
               Decimal subvalor = objProdOportunidad.Subtotal; 
               Decimal descuento = objProdOportunidad.Discount; 
               String poblacion = objProdOportunidad.Product2.COM_TipoPoblacion__c; 
               Decimal nopax = objProdOportunidad.Quantity;
               Decimal unitario = objProdOportunidad.UnitPrice;
               
               //NOLA-2083: Se solicita que en los PDF de cotizacion de salud los PyS no aparezcan con valor 0
                if(precioProducto != 0){ 
                   
                   COM_PVEPropuestaEconomica_cls objPropuesta = new COM_PVEPropuestaEconomica_cls();
                   objPropuesta.setProducto(nombreProducto);
                   objPropuesta.setCategoria(categoriaProducto);
                   objPropuesta.setSubCategoria(subCatProducto);
                   objPropuesta.setValor(precioProducto);
                   objPropuesta.setDescripcion(descripcionProducto);
                   objPropuesta.setSubvalor(subvalor);
                   objPropuesta.setDescuento(descuento);
                   objPropuesta.setPoblacion(poblacion);
                   objPropuesta.setNoPax(nopax);
                   objPropuesta.setUnitario(unitario);

                   
                   if (objProdOportunidad.Product2.Family != System.Label.COM_PVE_FamiliaS_P){
                       itemsPropuestaEconomica.add(objPropuesta);
                   }

                }//END
              
     }
  }


              
   }