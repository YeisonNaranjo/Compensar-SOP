/**
* Avanxo Colombia
* @author           Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada implementar los metodos de eventos de interface grafica de usuario
*                   para las cotizaciones de inmunización.
*                   
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     31/07/2017      Cristian Mosquera (CM)      Implementacion inicial del controlador.
*           2.0     31/08/2017      Daniel Alejandro López      Tomar los valores de los objetos y llevar a campos personalizados los textos.
**/
public class COM_PVE_Cotizacion_Inmunizacion_ctr {

    
    /** Saludo **/
    private String saludo;
    
    
    /** Párrafo 1 **/
    private String parrafoUno;
    
    /** Párrafo 2 **/
    private String parrafoDos;
    
    /** Párrafo 3 **/
    private String parrafoTres;
    
    /** Párrafo 4**/
    private String parrafoCuatro;
    
    /** Párrafo 5**/
    private String parrafoCinco;
    
    /** Párrafo 6**/
    private String parrafoSeis;
    
    /** Párrafo 7**/
    private String parrafoSiete;
    
    /** Párrafo 8**/
    private String parrafoOcho;
    
    /** Párrafo 9**/
    private String parrafoNueve;
    
    /** Párrafo 10**/
    private String parrafoDiez;
    
    /** Párrafo 11**/
    private String parrafoOnce;
    
    /** Párrafo 12**/
    private String parrafoDoce;
    
    /** Párrafo 13**/
    private String parrafoTrece;
    
    /** Párrafo Catorce**/
    private String parrafoCatorce;
    
    /** Párrafo 15**/
    private String parrafoQuince;
    
    /** Párrafo 16**/
    private String parrafo16;
    
   /** Párrafo 17**/
    private String parrafo17;
    
   /** Párrafo 18**/
    private String parrafo18;
    
   /** Titulo Referencia**/
    private String tituloReferencia;  
    
  /** Valor Referencia**/
    private String valorReferencia;   
    
  /** Valor Especificaciones **/
  private String valorEspecificaciones;
    
  /** Titulo Metodología**/
    private String tituloMetodologia;      
 
  /** Valor Metodología**/
    private String valorMetodologia;      
    
  /** Valores Sección 1**/
    private String seccionUno;  
    
  /** Título Sección 1**/
    private String tituloUno;  
    
  /** Valores Sección 2**/
    private String seccionDos;    
    
   /** Título Sección 2**/
    private String tituloDos;    
    
    /** Párrafo Contenido**/
    private String parrafoContenido;    
   
    
    /** Título Sección 3**/
    private String tituloTres;
    
    /** Título Sección 3A**/
    private String tituloTresA;
    
    /** Título Tabla 1 Columna Uno**/
    private String tituloTablaUnoColumnaUno;
    
    /** Título Tabla 1 Columna Dos**/
    private String tituloTablaUnoColumnaDos;
    
    /** Título Tabla 1 Columna Tres**/
    private String tituloTablaUnoColumnaTres; 
    
    /** Título Tabla 1 Columna Cuatro**/
    private String tituloTablaUnoColumnaCuatro; 
    
    /** Título Tabla 1 Columna Cinco**/
    private String tituloTablaUnoColumnaCinco; 
    
   /** Título Tabla 2 Columna Uno Fila Uno**/
    private String tituloTablaDosColumnaUnoFilaUno;
    
    /** Título Tabla 2 Columna Uno Fila Dos**/
    private String tituloTablaDosColumnaUnoFilaDos;
    
    /** Título Tabla 2 Columna Uno Fila Tres**/
    private String tituloTablaDosColumnaUnoFilaTres;    
    
    /** Valor Tabla 2 Columna Dos Fila Uno**/
    private String valorTablaDosColumnaDosFilaUno;
    
    /** Valor Tabla 2 Columna Dos Fila Dos**/
    private String valorTablaDosColumnaDosFilaDos;
    
    /** Valor Tabla 2 Columna Dos Fila Tres**/
    private String valorTablaDosColumnaDosFilaTres;  
    
    /** Vigencia Tarifas **/
    private String vigenciaTarifas;   
    
    /** Título Sección 4**/
    private String tituloCuatro;
        
   /** Título Sección 4A**/
    private String tituloCuatroA;
   
   /** Título Sección 4B**/
    private String tituloCuatroB;
    
   /** Título Sección 4C**/
    private String tituloCuatroC;
   
   
    /** Valores Sección 3**/
    private String seccionTres;
    
    /** Valores Sección 4**/
    private String seccionCuatro;
    
    /** Título Servicios Generales**/
    private String tituloServiciosGenerales;       
       
    /** La fecha actual para mostrar en pdf. **/
    private String fechaActual;
    
    /** La ciudad para mostrar en el encabezado **/
    private String ciudadGeneracion;    
    
    /** Saludo Cliente **/
    private String saludoCliente;  
       
    /** Despedida**/
    private String despedida;
    
    /** Nombre del Cliente.**/
    private String nombreCliente;

    /** Nombre del Representante legal. **/
    private String nombreRepresentateLegal;

    /** Cargo de la persona a quien va dirigido. **/
    private String cargo;

    /** Ciudad de la persona a quien va dirigido. **/
    private String ciudad;

    /** Primer nombre de la persona a quien va dirigido. **/
    private String primerNombre;
    
   
    /** Los servicios generales del programa.**/
    private List<String> metodologiaPrograma = new List<String> ();

    /** Los items de la propuesta economica.**/
    private List<COM_PVE_Cotizacion_Inmunizacion_ctr.COM_PVEPropuestaEconomica_cls> itemsPropuestaEconomica =
                                new List<COM_PVE_Cotizacion_Inmunizacion_ctr.COM_PVEPropuestaEconomica_cls>();
    /** Especificaciones del servicio.**/
    private List<String> especificacionesServicio = new List<String> ();
    
        
    /** Confirmación del servicio.**/
    private List<String> modalidadesCompensar = new List<String> ();

    /** Nombre del asesor.**/
    private String nombreAsesor;

    /** Cargo del asesor.**/
    private String cargoAsesor;

    /** Email del asesor.**/
    private String emailAsesor;

    /** Telefono del asesor.**/
    private String telefonoAsesor;

    /** El proceso al que pertenece el asesor.**/
    private String procesoAsesor;

    /** La oportunidad asociada**/
    private String idOportunidad;
    
    
    /** El año actual**/
    private String year;  
       

    /**
     * El constructor de la clase.
     */
    public COM_PVE_Cotizacion_Inmunizacion_ctr() {
        idOportunidad = ApexPages.currentPage().getParameters().get('IdCustomObject');
        cargarContenidoDinamico();
        cargarDatos();
    }
    
    
    /**
    Carga el texto estático desde el tipo de metadatos personalizado.
    */
     public void cargarTextoEstatico() {
        
           CotizacionInmunizacion__mdt[] lineasEstaticas = [SELECT parrafoUno__c, parrafoDos__c, parrafoTres__c, parrafoCuatro__c,
                                                                             parrafoCinco__c, parrafoSeis__c, parrafoSiete__c, parrafoOcho__c,
                                                                             parrafoNueve__c, parrafoDiez__c, parrafoOnce__c, parrafoDoce__c,
                                                                             Saludo__c,
                                                                             ciudad__c,  SaludoCliente__c, parrafoTrece__c, 
                                                                             SeccionUno__c, tituloUno__c, tituloTablaUnoColumnaCuatro__c, tituloTablaUnoColumnaCinco__c,
                                                                             tituloDos__c, parrafoContenido__c, tituloTres__c,
                                                                             tituloTablaUnoColumnaUno__c, tituloTablaUnoColumnaDos__c, tituloTablaUnoColumnaTres__c,
                                                                             tituloCuatro__c, tituloCuatroA__c, tituloCuatroB__c,  tituloCuatroC__c,
                                                                             valorEspecificaciones__c, parrafoCatorce__c, parrafoQuince__c, Despedida__c,              
                                                                             tituloTablaDosColumnaUnoFilaUno__c, tituloTablaDosColumnaUnoFilaDos__c, tituloTablaDosColumnaUnoFilaTres__c ,
                                                                             valorTablaDosColumnaDosFilaUno__c, valorTablaDosColumnaDosFilaDos__c, valorTablaDosColumnaDosFilaTres__c,
                                                                             ciudadCliente__c, ProcesoAsesor__c, tituloTresA__c
                                                             FROM CotizacionInmunizacion__mdt ];
                                                           
           for (CotizacionInmunizacion__mdt lineaEstatica : lineasEstaticas) {
                 String saludoConf = lineaEstatica.Saludo__c;
                 String parrafo1Conf = lineaEstatica.parrafoUno__c;
                 String parrafo2Conf = lineaEstatica.parrafoDos__c;
                 String parrafo3Conf = lineaEstatica.parrafoTres__c;
                 String parrafo4Conf = lineaEstatica.parrafoCuatro__c;
                 String parrafo5Conf = lineaEstatica.parrafoCinco__c;
                 String parrafo6Conf = lineaEstatica.ParrafoSeis__c;
                 String parrafo7Conf = lineaEstatica.ParrafoSiete__c;
                 String parrafo8Conf = lineaEstatica.ParrafoOcho__c;
                 String parrafo9Conf = lineaEstatica.ParrafoNueve__c;
                 String parrafo10Conf = lineaEstatica.ParrafoDiez__c;
                 String parrafo11Conf = lineaEstatica.ParrafoOnce__c;
                 String parrafo12Conf = lineaEstatica.ParrafoDoce__c;
                 String parrafo13Conf = lineaEstatica.ParrafoTrece__c;
                 String parrafo14Conf = lineaEstatica.ParrafoCatorce__c;
                 String parrafo15Conf = lineaEstatica.ParrafoQuince__c;
                 String parrafoContenidoConf = lineaEstatica.parrafoContenido__c;
                 
                 String saludoClienteConf = lineaEstatica.SaludoCliente__c;
                 String despedidaConf = lineaEstatica.Despedida__c;
                 String ciudadConf = lineaEstatica.Ciudad__c;
                 String ciudadClienteConf = lineaEstatica.ciudadCliente__c;
                 String valorEspecificacionesConf = lineaEstatica.valorEspecificaciones__c;
                 String seccionUnoConf = lineaEstatica.SeccionUno__c;
                 String procesoAsesorConf = lineaEstatica.ProcesoAsesor__c;
                                                  
                 String titulo1Conf  = lineaEstatica.tituloUno__c;
                 String titulo2Conf  = lineaEstatica.tituloDos__c;
                 String titulo3Conf  = lineaEstatica.tituloTres__c;
                 String titulo3AConf  = lineaEstatica.tituloTresA__c;
                 String titulo4Conf  = lineaEstatica.tituloCuatro__c;
                 String titulo4AConf  = lineaEstatica.tituloCuatroA__c;
                 String titulo4BConf  = lineaEstatica.tituloCuatroB__c;
                 String titulo4CConf  = lineaEstatica.tituloCuatroC__c;
                 
                 String tituloTabla1Columna1Conf  = lineaEstatica.tituloTablaUnoColumnaUno__c;
                 String tituloTabla1Columna2Conf  = lineaEstatica.tituloTablaUnoColumnaDos__c;
                 String tituloTabla1Columna3Conf  = lineaEstatica.tituloTablaUnoColumnaTres__c;
                 String tituloTabla1Columna4Conf  = lineaEstatica.tituloTablaUnoColumnaCuatro__c;
                 String tituloTabla1Columna5Conf  = lineaEstatica.tituloTablaUnoColumnaCinco__c;
                 String tituloTablaDosColumnaUnoFilaUnoConf = lineaEstatica.tituloTablaDosColumnaUnoFilaUno__c;
                 String tituloTablaDosColumnaUnoFilaDosConf = lineaEstatica.tituloTablaDosColumnaUnoFilaDos__c;
                 String tituloTablaDosColumnaUnoFilaTresConf = lineaEstatica.tituloTablaDosColumnaUnoFilaTres__c;
                 String valorTablaDosColumnaDosFilaUnoConf = lineaEstatica.valorTablaDosColumnaDosFilaUno__c;
                 String valorTablaDosColumnaDosFilaDosConf = lineaEstatica.valorTablaDosColumnaDosFilaDos__c;
                 String valorTablaDosColumnaDosFilaTresConf = lineaEstatica.valorTablaDosColumnaDosFilaTres__c;
                                  
                 //String vigenciaTarifasConf = lineaEstatica.vigenciaTarifas__c;
                 
                 setSaludo(saludoConf);
                 setParrafoUno(parrafo1Conf);
                 setParrafoDos(parrafo2Conf);
                 setParrafoTres(parrafo3Conf);
                 setParrafoCuatro(parrafo4Conf);
                 setParrafoCinco(parrafo5Conf);
                 setParrafoSeis(parrafo6Conf);
                 setParrafoSiete(parrafo7Conf);
                 setParrafoOcho(parrafo8Conf);
                 setParrafoNueve(parrafo9Conf);
                 setParrafoDiez(parrafo10Conf);
                 setParrafoOnce(parrafo11Conf);
                 setParrafoDoce(parrafo12Conf);
                 setParrafoTrece(parrafo13Conf);
                 setParrafoCatorce(parrafo14Conf);
                 setParrafoQuince(parrafo15Conf);
                 setParrafoContenido(parrafoContenidoConf);
                 
                 setCiudadGeneracion(ciudadConf);
                 setCiudad(ciudadClienteConf);
                 setProcesoAsesor(procesoAsesorConf);
                 setSaludoCliente(saludoClienteConf);
                 setSaludo(saludoConf);
                 setDespedida(despedidaConf);
                 
                 setSeccionUno(seccionUnoConf);
                 setValorEspecificaciones(valorEspecificacionesConf);
                                                
                 setTituloUno(titulo1Conf);
                 setTituloDos(titulo2Conf);
                 setTituloTres(titulo3Conf);
                 setTituloTresA(titulo3AConf);
                 setTituloCuatro(titulo4Conf);
                 setTituloCuatroA(titulo4AConf);
                 setTituloCuatroB(titulo4BConf);
                 setTituloCuatroC(titulo4CConf);
                 
                 setTituloTablaUnoColumnaUno(tituloTabla1Columna1Conf);
                 setTituloTablaUnoColumnaDos(tituloTabla1Columna2Conf);
                 setTituloTablaUnoColumnaTres(tituloTabla1Columna3Conf);
                 setTituloTablaUnoColumnaCuatro(tituloTabla1Columna4Conf);
                 setTituloTablaUnoColumnaCinco(tituloTabla1Columna5Conf);
                 
                 setTituloTablaDosColumnaUnoFilaUno(tituloTablaDosColumnaUnoFilaUnoConf);
                 setTituloTablaDosColumnaUnoFilaDos(tituloTablaDosColumnaUnoFilaDosConf);
                 setTituloTablaDosColumnaUnoFilaTres(tituloTablaDosColumnaUnoFilaTresConf);
                 
                 setValorTablaDosColumnaDosFilaUno(valorTablaDosColumnaDosFilaUnoConf);
                 setValorTablaDosColumnaDosFilaDos(valorTablaDosColumnaDosFilaDosConf);
                 setValorTablaDosColumnaDosFilaTres(valorTablaDosColumnaDosFilaTresConf);
                 
                 //setVigenciaTarifas(vigenciaTarifasConf); 
                 
           }
     }
     

    /**
     * @descrition Metodo encargado de cargar los servicios generales.
     */
    public void cargarMetodologiaPrograma() {
        metodologiaPrograma = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= seccionUno.countMatches(saltoLinea);
        String seccionUnoTemporal = seccionUno;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            metodologiaPrograma.add(linea);
            seccionUnoTemporal = seccionUnoTemporal.substring(indice+1,seccionUnoTemporal.length());        
            
        }         
    }
    
    

    /**
     * @description Metodo encargado de cargar el detalle de los examenes ocupacionales
     */
    public void cargarEspecificacionesServicios() {
        especificacionesServicio = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= valorEspecificaciones.countMatches(saltoLinea);
        String seccionEspecificacionesTemporal = valorEspecificaciones;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionEspecificacionesTemporal.indexOf(saltoLinea);
            String linea = seccionEspecificacionesTemporal.substring(0,indice);
            especificacionesServicio.add(linea);
            seccionEspecificacionesTemporal = seccionEspecificacionesTemporal.substring(indice+1,seccionEspecificacionesTemporal.length());        
            
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
        year = anio+'';
        
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
        
        fechaActual = ciudadGeneracion + ' '+ nombreMes+' '+dia+' de '+anio;
        String strId = Apexpages.currentPage().getParameters().get( 'id' );
        
        cargarMetodologiaPrograma();
        cargarEspecificacionesServicios();
                
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
         * Getter del atributo párrafo 4.
         * @return el atributo párrafo 4.
         */
        public String getParrafoCuatro() {
            return parrafoCuatro;
        }

       /**
         * Setter del atributo párrafo 4.
         * @param párrafo 4 el atributo párrafo 4 a establecer.
         */
        public void setParrafoCuatro(String parrafoCuatro) {
            this.parrafocuatro = parrafoCuatro;
        }
        

       /**
         * Getter del atributo párrafo 5.
         * @return el atributo párrafo 5.
         */
        public String getParrafoCinco() {
            return parrafoCinco;
        }

        /**
         * Setter del atributo párrafo 5.
         * @param párrafo 5 el atributo párrafo 5 a establecer.
         */
        public void setParrafoCinco(String parrafoCinco) {
            this.parrafoCinco = parrafoCinco;
        }


       /**
         * Getter del atributo párrafo 6.
         * @return el atributo párrafo 6.
         */
        public String getParrafoSeis() {
            return parrafoSeis;
        }

        /**
         * Setter del atributo párrafo 6.
         * @param párrafo 6 el atributo párrafo 6 a establecer.
         */
        public void setParrafoSeis(String parrafoSeis) {
            this.parrafoSeis = parrafoSeis;
        }


       /**
         * Getter del atributo párrafo 7.
         * @return el atributo párrafo 7.
         */
        public String getParrafoSiete() {
            return parrafoSiete;
        }

        /**
         * Setter del atributo párrafo 7.
         * @param párrafo 7 el atributo párrafo 7 a establecer.
         */
        public void setParrafoSiete(String parrafoSiete) {
            this.parrafoSiete = parrafoSiete;
        }


       /**
         * Getter del atributo párrafo 8.
         * @return el atributo párrafo 8.
         */
        public String getParrafoOcho() {
            return parrafoOcho;
        }

        /**
         * Setter del atributo párrafo 8.
         * @param párrafo 8 el atributo párrafo 8 a establecer.
         */
        public void setParrafoOcho(String parrafoOcho) {
            this.parrafoOcho = parrafoOcho;
        }


       /**
         * Getter del atributo párrafo 9.
         * @return el atributo párrafo 9.
         */
        public String getParrafoNueve() {
            return parrafoNueve;
        }


        /**
         * Setter del atributo párrafo 9.
         * @param párrafo 9 el atributo párrafo 9 a establecer.
         */
        public void setParrafoNueve(String parrafoNueve) {
            this.parrafoNueve = parrafoNueve;
        }       
        

       /**
         * Getter del atributo párrafo 10.
         * @return el atributo párrafo 10.
         */
        public String getParrafoDiez() {
            return parrafoDiez;
        }

        
        /**
         * Setter del atributo párrafo 10.
         * @param párrafo 10 el atributo párrafo 10 a establecer.
         */
        public void setParrafoDiez(String parrafoDiez) {
            this.parrafoDiez = parrafoDiez;
        }

      /**
         * Getter del atributo párrafo 11.
         * @return el atributo párrafo 11.
         */
        public String getParrafoOnce() {
            return parrafoOnce;
        }

        
        /**
         * Setter del atributo párrafo 11.
         * @param párrafo 11 el atributo párrafo 11 a establecer.
         */
        public void setParrafoOnce(String parrafoOnce) {
            this.parrafoOnce = parrafoOnce;
        }

      /**
         * Getter del atributo párrafo 12.
         * @return el atributo párrafo 12.
         */
        public String getParrafoDoce() {
            return parrafoDoce;
        }
        
               
        /**
         * Setter del atributo párrafo 12.
         * @param párrafo 12 el atributo párrafo 12 a establecer.
         */
        public void setParrafoDoce(String parrafoDoce) {
            this.parrafoDoce = parrafoDoce;
        }
 
 
 
        
       
        /**
         * Setter del atributo título de Referencia
         * @param título de Referencia el atributo título de Referencia a establecer.
         */
        public void setTituloReferencia(String tituloReferencia) {
            this.tituloReferencia = tituloReferencia;
        }
        
  

      /**
         * Getter del atributo Título de Referencia.
         * @return el atributo Título de Referencia.
         */
        public String getTituloReferencia() {
            return tituloReferencia;
        }
        
      /**
         * Getter del atributo párrafo 13.
         * @return el atributo párrafo 13.
         */
        public String getParrafoTrece() {
            return parrafoTrece;
        }
        
              
        /**
         * Setter del atributo párrafo 13.
         * @param párrafo 13 el atributo párrafo 13 a establecer.
         */
        public void setParrafoTrece(String parrafoTrece) {
            this.parrafoTrece = parrafoTrece;
        }
 
      /**
         * Getter del atributo párrafo 14.
         * @return el atributo párrafo 14.
         */
        public String getParrafoCatorce() {
            return parrafoCatorce;
        }
        
              
        /**
         * Setter del atributo párrafo 14.
         * @param párrafo 14 el atributo párrafo 14 a establecer.
         */
        public void setParrafoCatorce(String parrafoCatorce) {
            this.parrafoCatorce = parrafoCatorce;
        }
        
      /**
         * Getter del atributo párrafo 15.
         * @return el atributo párrafo 15.
         */
        public String getParrafoQuince() {
            return parrafoQuince;
        }
        
              
        /**
         * Setter del atributo párrafo 15.
         * @param párrafo 15 el atributo párrafo 15 a establecer.
         */
        public void setParrafoQuince(String parrafoQuince) {
            this.parrafoQuince = parrafoQuince;
        }
        
      /**
         * Getter del atributo párrafo 16.
         * @return el atributo párrafo 16.
         */
        public String getParrafo16() {
            return parrafo16;
        }
        
              
        /**
         * Setter del atributo párrafo 16.
         * @param párrafo 16 el atributo párrafo 16 a establecer.
         */
        public void setParrafo16(String parrafo16) {
            this.parrafo16 = parrafo16;
        }
        
        
      /**
         * Getter del atributo párrafo 17.
         * @return el atributo párrafo 17.
         */
        public String getParrafo17() {
            return parrafo17;
        }
        
              
        /**
         * Setter del atributo párrafo 17.
         * @param párrafo 17 el atributo párrafo 17 a establecer.
         */
        public void setParrafo17(String parrafo17) {
            this.parrafo17 = parrafo17;
        }
        
      
      /**
         * Getter del atributo párrafo 18.
         * @return el atributo párrafo 18.
         */
        public String getParrafo18() {
            return parrafo18;
        }
        
              
        /**
         * Setter del atributo párrafo 18.
         * @param párrafo 18 el atributo párrafo 18 a establecer.
         */
        public void setParrafo18(String parrafo18) {
            this.parrafo18 = parrafo18;
        }                                                       
       
      /**
         * Getter del atributo párrafo Contenido.
         * @return el atributo párrafo Contenido.
         */
        public String getParrafoContenido() {
            return parrafoContenido;
        }
        
              
        /**
         * Setter del atributo párrafo Contenido.
         * @param párrafo Contenido el atributo párrafo Contenido a establecer.
         */
        public void setParrafoContenido(String parrafoContenido) {
            this.parrafoContenido = parrafoContenido;
        }
                
 
      
        /**
         * Setter del atributo Valor de Referencia
         * @param Valor de Referencia el atributo Valor de Referencia a establecer.
         */
        public void setValorReferencia(String valorReferencia) {
            this.valorReferencia = valorReferencia;
        }

      /**
         * Getter del atributo párrafo 12.
         * @return el atributo párrafo 12.
         */
        public String getValorReferencia() {
            return valorReferencia;
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
         * Getter del atributo Vigencia de las Tarifas.
         * @return el atributo Vigencia de las Tarifas.
         */
        public String getVigenciaTarifas() {
            return vigenciaTarifas;
        }

        /**
         * Setter del atributo Vigencia de las Tarifas.
         * @param Vigencia de las Tarifas el atributo Vigencia de las Tarifas a establecer.
         */
        public void setVigenciaTarifas(String vigenciaTarifas) {
            this.vigenciaTarifas = vigenciaTarifas;
        }


      /**
         * Getter del atributo Título Metodología.
         * @return el atributo Título Metodología.
         */
        public String getTituloMetodologia() {
            return tituloMetodologia;
        }
        

        /**
         * Setter del atributo Título Metodología.
         * @param Título Metodología el atributo Título Metodología a establecer.
         */
        public void setTituloMetodologia(String tituloMetodologia) {
            this.tituloMetodologia = tituloMetodologia;
        }
        

      /**
         * Getter del atributo Valor Especificaciones.
         * @return el atributo Valor Especificaciones.
         */
        public String getValorEspecificaciones() {
            return valorEspecificaciones;
        }
        

        /**
         * Setter del atributo Valor Especificaciones.
         * @param Valor Especificaciones el atributo Valor Especificaciones a establecer.
         */
        public void setValorEspecificaciones(String valorEspecificaciones) {
            this.valorEspecificaciones = valorEspecificaciones;
        }
        
        

      /**
         * Getter del atributo Valor Metodología.
         * @return el atributo Valor Metodología.
         */
        public String getValorMetodologia() {
            return valorMetodologia;
        }
        

        /**
         * Setter del atributo Valor Metodología.
         * @param Valor Metodología el atributo Valor Metodología a establecer.
         */
        public void setValorMetodologia(String valorMetodologia) {
            this.valorMetodologia = valorMetodologia;
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
         * Getter del atributo título 3A.
         * @return el atributo título 3A.
         */
        public String getTituloTresA() {
            return tituloTresA;
        }
        

        /**
         * Setter del atributo Título 3A.
         * @param Título 3A el atributo Título 3A a establecer.
         */
        public void setTituloTresA(String tituloTresA) {
            this.tituloTresA = tituloTresA;
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
         * Getter del atributo título 4A.
         * @return el atributo título 4A.
         */
        public String getTituloCuatroA() {
            return tituloCuatroA;
        }
        

        /**
         * Setter del atributo Título 4A.
         * @param Título 4A el atributo Título 4A a establecer.
         */
        public void setTituloCuatroA(String tituloCuatroA) {
            this.tituloCuatroA = tituloCuatroA;
        }
        

      /**
         * Getter del atributo título 4B.
         * @return el atributo título 4B.
         */
        public String getTituloCuatroB() {
            return tituloCuatroB;
        }
        

        /**
         * Setter del atributo Título 4B.
         * @param Título 4B el atributo Título 4B a establecer.
         */
        public void setTituloCuatroB(String tituloCuatroB) {
            this.tituloCuatroB = tituloCuatroB;
        }  
        
        

      /**
         * Getter del atributo título 4C.
         * @return el atributo título 4C.
         */
        public String getTituloCuatroC() {
            return tituloCuatroC;
        }
        

        /**
         * Setter del atributo Título 4C.
         * @param Título 4C el atributo Título 4C a establecer.
         */
        public void setTituloCuatroC(String tituloCuatroC) {
            this.tituloCuatroC = tituloCuatroC;
        }      
   
      /**
         * Getter del atributo Sección 1.
         * @return el atributo Sección 1.
         */
        public String getSeccionUno() {
            return seccionUno;
        }      
        
        /**
         * Setter del atributo Sección 1.
         * @param Sección 1 el atributo Sección 1 a establecer.
         */
        public void setSeccionUno(String seccionUno) {
            this.seccionUno = seccionUno;
        }
 
      
      /**
         * Getter del atributo Sección 2.
         * @return el atributo Sección 2.
         */
        public String getSeccionDos() {
            return seccionDos;
        }
        
        
 
        /**
         * Setter del atributo Sección 2.
         * @param Sección 2 el atributo Sección 2 a establecer.
         */
        public void setSeccionDos(String seccionDos) {
            this.seccionDos = seccionDos;
        }
 
      
      /**
         * Getter del atributo Sección 3.
         * @return el atributo Sección 3.
         */
        public String getSeccionTres() {
            return seccionTres;
        }
        
        
 
        /**
         * Setter del atributo Sección 3.
         * @param Sección 3 el atributo Sección 3 a establecer.
         */
        public void setSeccionTres(String seccionTres) {
            this.seccionTres = seccionTres;
        }   
        

      /**
         * Getter del atributo Sección 4.
         * @return el atributo Sección 4.
         */
        public String getSeccionCuatro() {
            return seccionCuatro;
        }        
        
 
        /**
         * Setter del atributo Sección 4.
         * @param Sección 4 el atributo Sección 4 a establecer.
         */
        public void setSeccionCuatro(String seccionCuatro) {
            this.seccionCuatro = seccionCuatro;
        }     
        
        
        /**
         * Setter del atributo Título Servicios Generales
         * @param Título Servicios Generales el atributo Título Servicios Generales a establecer.
         */
        public void setTituloServiciosGenerales(String tituloServiciosGenerales) {
            this.tituloServiciosGenerales = tituloServiciosGenerales;
        }
 
      
      /**
         * Getter del atributo título Servicios Generales.
         * @return el atributo título Servicios Generales.
         */
        public String getTituloServiciosGenerales() {
            return tituloServiciosGenerales;
        }
  
     
       /**
         * Getter del atributo Título Tabla Uno Columna 1.
         * @return el atributo Título Tabla Uno Columna 1.
         */
        public String getTituloTablaUnoColumnaUno() {
            return tituloTablaUnoColumnaUno;
        }
            
       
        /**
         * Setter del atributo Título Tabla Uno Columna 1.
         * @param Título Tabla Uno Columna 1 el atributo Título Tabla Uno Columna 1 a establecer.
         */
        public void setTituloTablaUnoColumnaUno(String tituloTablaUnoColumnaUno) {
            this.tituloTablaUnoColumnaUno = tituloTablaUnoColumnaUno;
        }
        
      
       /**
         * Getter del atributo Título Tabla Uno Columna 2.
         * @return el atributo Título Tabla Uno Columna 2.
         */
        public String getTituloTablaUnoColumnaDos() {
            return tituloTablaUnoColumnaDos;
        }
            
       
        /**
         * Setter del atributo Título Tabla Uno Columna 2.
         * @param Título Tabla Uno Columna 2 el atributo Título Tabla Uno Columna 2 a establecer.
         */
        public void setTituloTablaUnoColumnaDos(String tituloTablaUnoColumnaDos) {
            this.tituloTablaUnoColumnaDos = tituloTablaUnoColumnaDos;
        }
               
       
       /**
         * Getter del atributo Título Tabla Uno Columna 3.
         * @return el atributo Título Tabla Uno Columna 3.
         */
        public String getTituloTablaUnoColumnaTres() {
            return tituloTablaUnoColumnaTres;
        }
            
       
        /**
         * Setter del atributo Título Tabla Uno Columna 3.
         * @param Título Tabla Uno Columna 3 el atributo Título Tabla Uno Columna 3 a establecer.
         */
        public void setTituloTablaUnoColumnaTres(String tituloTablaUnoColumnaTres) {
            this.tituloTablaUnoColumnaTres = tituloTablaUnoColumnaTres;
        }

     
       /**
         * Getter del atributo Título Tabla Uno Columna 4.
         * @return el atributo Título Tabla Uno Columna 4.
         */
        public String getTituloTablaUnoColumnaCuatro() {
            return tituloTablaUnoColumnaCuatro;
        }
            
       
        /**
         * Setter del atributo Título Tabla Uno Columna 4.
         * @param Título Tabla Uno Columna 4 el atributo Título Tabla Uno Columna 4 a establecer.
         */
        public void setTituloTablaUnoColumnaCuatro(String tituloTablaUnoColumnaCuatro) {
            this.tituloTablaUnoColumnaCuatro = tituloTablaUnoColumnaCuatro;
        }
 
      
       /**
         * Getter del atributo Título Tabla Uno Columna 5.
         * @return el atributo Título Tabla Uno Columna 5.
         */
        public String getTituloTablaUnoColumnaCinco() {
            return tituloTablaUnoColumnaCinco;
        }
            
       
        /**
         * Setter del atributo Título Tabla Uno Columna 5.
         * @param Título Tabla Uno Columna 5 el atributo Título Tabla Uno Columna 5 a establecer.
         */
        public void setTituloTablaUnoColumnaCinco(String tituloTablaUnoColumnaCinco) {
            this.tituloTablaUnoColumnaCinco = tituloTablaUnoColumnaCinco;
        }            
 
     
      /**
     * Getter del atributo ciudad de generación
     *
     * @return el atributo ciudad de generación
     */
    public String getCiudadGeneracion() {
        return ciudadGeneracion;
    }

    /**
     * Setter del atributo ciudad de generación
     *
     * @param ciudad el atributo ciudad de generación a establecer.
     */
    public void setCiudadGeneracion(String ciudadGeneracion) {
        this.ciudadGeneracion = ciudadGeneracion;
    }
     
     
     
          
       /**
         * Getter del atributo Ciudad.
         * @return el atributo Ciudad.
         */
        public String getCiudad() {
            return ciudad;
        }
            
       
        /**
         * Setter del atributo Ciudad.
         * @param Ciudad  el atributo Ciudad a establecer.
         */
        public void setCiudad(String ciudad) {
            this.ciudad = ciudad;
        }
                
          
       /**
         * Getter del atributo Saludo Cliente.
         * @return el atributo Saludo Cliente.
         */
        public String getSaludoCliente() {
            return saludoCliente;
        }
            
       
        /**
         * Setter del atributo Saludo Cliente.
         * @param Saludo Cliente  el atributo Saludo Cliente a establecer.
         */
        public void setSaludoCliente(String saludoCliente) {
            this.saludoCliente = saludoCliente;
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
     * Getter del atributo metodologiaPrograma.
     *
     * @return el atributo metodologiaPrograma.
     */
    public List<String> getMetodologiaPrograma() {
        return metodologiaPrograma;
    }

    /**
     * Setter del atributo metodologiaPrograma.
     *
     * @param metodologiaPrograma el atributo metodologiaPrograma a establecer.
     */
    public void setMetodologiaPrograma(List<String> metodologiaPrograma) {
        this.metodologiaPrograma = metodologiaPrograma;
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
     * Getter del atributo especificacionesServicio.
     *
     * @return el atributo especificacionesServicio.
     */
    public List<String> getEspecificacionesServicio() {
        return especificacionesServicio;
    }

    /**
     * Setter del atributo especificacionesServicio.
     *
     * @param especificacionesServicio el atributo especificacionesServicio a establecer.
     */
    public void setEspecificacionesServicio(List<String> especificacionesServicio) {
        this.especificacionesServicio = especificacionesServicio;
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
     * Getter del atributo año actual.
     *
     * @return el atributo año actual.
     */
    public String getYear() {
        return year;
    }
    
    /**
     * Getter del atributo fechaActual.
     *
     * @return el atributo fechaActual.
     */
    public String getFechaActual() {
        return fechaActual;
    }

    /**
     * Setter del atributo fechaActual.
     *
     * @param fechaActual el atributo fechaActual a establecer.
     */
    public void setFechaActual(String fechaActual) {
        this.fechaActual = fechaActual;
    }
    
       
       /**
         * Getter del atributo Título Tabla Dos Columna 1 Fila 1.
         * @return el atributo Título Tabla Dos Columna 1 Fila 1.
         */
        public String getTituloTablaDosColumnaUnoFilaUno() {
            return tituloTablaDosColumnaUnoFilaUno;
        }
            
       
        /**
         * Setter del atributo Título Tabla Dos Columna 1 Fila 1.
         * @param Título Tabla Dos Columna 1 Fila 1 el atributo Título Tabla Dos Columna 1 Fila 1 a establecer.
         */
        public void setTituloTablaDosColumnaUnoFilaUno(String tituloTablaDosColumnaUnoFilaUno) {
            this.tituloTablaDosColumnaUnoFilaUno = tituloTablaDosColumnaUnoFilaUno;
        }
        

     
       /**
         * Getter del atributo Título Tabla Dos Columna 1 Fila 2.
         * @return el atributo Título Tabla Dos Columna 1 Fila 2.
         */
        public String getTituloTablaDosColumnaUnoFilaDos() {
            return tituloTablaDosColumnaUnoFilaDos;
        }
            
       
        /**
         * Setter del atributo Título Tabla Dos Columna 1 Fila 2.
         * @param Título Tabla Dos Columna 1 Fila 2 el atributo Título Tabla Dos Columna 1 Fila 2 a establecer.
         */
        public void setTituloTablaDosColumnaUnoFilaDos(String tituloTablaDosColumnaUnoFilaDos) {
            this.tituloTablaDosColumnaUnoFilaDos = tituloTablaDosColumnaUnoFilaDos;
        }
        
 
       /**
         * Getter del atributo Título Tabla Dos Columna 1 Fila 3.
         * @return el atributo Título Tabla Dos Columna 1 Fila 3.
         */
        public String getTituloTablaDosColumnaUnoFilaTres() {
            return tituloTablaDosColumnaUnoFilaTres;
        }
            
       
        /**
         * Setter del atributo Título Tabla Dos Columna 1 Fila 3.
         * @param Título Tabla Dos Columna 1 Fila 3 el atributo Título Tabla Dos Columna 1 Fila 3 a establecer.
         */
        public void setTituloTablaDosColumnaUnoFilaTres(String tituloTablaDosColumnaUnoFilaTres) {
            this.tituloTablaDosColumnaUnoFilaTres = tituloTablaDosColumnaUnoFilaTres;
        }
        


   
       /**
         * Getter del atributo Valor Tabla Dos Columna 2 Fila 1.
         * @return el atributo Valor Tabla Dos Columna 2 Fila 1.
         */
        public String getValorTablaDosColumnaDosFilaUno() {
            return valorTablaDosColumnaDosFilaUno;
        }
            
       
        /**
         * Setter del atributo Valor Tabla Dos Columna 2 Fila 1.
         * @param Valor Tabla Dos Columna 2 Fila 1 el atributo Valor Tabla Dos Columna 2 Fila 1 a establecer.
         */
        public void setValorTablaDosColumnaDosFilaUno(String valorTablaDosColumnaDosFilaUno) {
            this.valorTablaDosColumnaDosFilaUno = valorTablaDosColumnaDosFilaUno;
        }
        
        
        
       /**
         * Getter del atributo Valor Tabla Dos Columna 2 Fila 2.
         * @return el atributo Valor Tabla Dos Columna 2 Fila 2.
         */
        public String getValorTablaDosColumnaDosFilaDos() {
            return valorTablaDosColumnaDosFilaDos;
        }
            
       
        /**
         * Setter del atributo Valor Tabla Dos Columna 2 Fila 2.
         * @param Valor Tabla Dos Columna 2 Fila 2 el atributo Valor Tabla Dos Columna 2 Fila 2 a establecer.
         */
        public void setValorTablaDosColumnaDosFilaDos(String valorTablaDosColumnaDosFilaDos) {
            this.valorTablaDosColumnaDosFilaDos = valorTablaDosColumnaDosFilaDos;
        }

    
       /**
         * Getter del atributo Valor Tabla Dos Columna 2 Fila 3.
         * @return el atributo Valor Tabla Dos Columna 2 Fila 3.
         */
        public String getValorTablaDosColumnaDosFilaTres() {
            return valorTablaDosColumnaDosFilaTres;
        }
            
       
        /**
         * Setter del atributo Valor Tabla Dos Columna 2 Fila 3.
         * @param Valor Tabla Dos Columna 2 Fila 3 el atributo Valor Tabla Dos Columna 2 Fila 3 a establecer.
         */
        public void setValorTablaDosColumnaDosFilaTres(String valorTablaDosColumnaDosFilaTres) {
            this.valorTablaDosColumnaDosFilaTres = valorTablaDosColumnaDosFilaTres;
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
        
        /** Nombre del producto. **/
        private String producto;
        
        /** Descripción del producto. **/
        private String descripcion;

        /**
         * Getter del atributo Categoría.
         * @return el atributo Categoría.
         */
        public String getCategoria() {
            return categoria;
        }

        /**
         * Setter del atributo Categoría.
         * @param Categoría el atributo Categoría a establecer.
         */
        public void setCategoria(String categoria) {
            this.categoria = categoria;
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
                                               Owner.MobilePhone, Owner.Email, Owner.Title   
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
               
        }
        
        
       //Obtener la información de los productos y productos por oportunidad
       list<OpportunityLineItem> lstProdPorOportunidad = [SELECT id, Product2.Name,
                                                          Product2.COM_CategoriaSalud__c, Product2.COM_SubCategoriaSalud__c,
                                                          Product2.Description, TotalPrice, Product2.Family  
                                                          FROM OpportunityLineItem
                                                          WHERE OpportunityId =: idOppt]; 
       
       for(Integer i=0;i<lstProdPorOportunidad.size();i++){
            
               OpportunityLineItem objProdOportunidad = lstProdPorOportunidad.get(i);
               String nombreProducto = objProdOportunidad.Product2.Name; 
               String categoriaProducto = objProdOportunidad.Product2.COM_CategoriaSalud__c; 
               String subCatProducto = objProdOportunidad.Product2.COM_SubCategoriaSalud__c; 
               Decimal precioProducto = objProdOportunidad.TotalPrice; 
                              
               precioProducto = precioProducto.round(System.RoundingMode.DOWN);
               String descripcionProducto = objProdOportunidad.Product2.Description; 
               String familiaProducto = objProdOportunidad.Product2.Name; 
               
               //NOLA-2083: Se solicita que en los PDF de cotizacion de salud los PyS no aparezcan con valor 0
                if(precioProducto != 0){ 
                   
                   COM_PVEPropuestaEconomica_cls objPropuesta = new COM_PVEPropuestaEconomica_cls();
                   objPropuesta.setProducto(nombreProducto);
                   objPropuesta.setCategoria(categoriaProducto);
                   objPropuesta.setSubCategoria(subCatProducto);
                   objPropuesta.setValor(precioProducto);
                   objPropuesta.setDescripcion(descripcionProducto);
                   
                   if (familiaProducto != System.Label.COM_PVE_FamiliaS_P){
                       itemsPropuestaEconomica.add(objPropuesta);
                   }
                }//END
              
     }
  }
        
   


}