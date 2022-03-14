/**
* Avanxo Colombia
* @author           Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada implementar los metodos de eventos de interface grafica de usuario
*                   para las cotizaciones de salud.
*                   
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     31/07/2017      Cristian Mosquera (CM)      Implementacion inicial del controlador.
*           2.0     23/08/2017      Daniel Alejandro López      Tomar los valores de los objetos y llevar a campos personalizados los textos.
**/
public class COM_PVE_SOExamenesNacionales_ctr {

    
    /** Saludo **/
    private String saludo;
    
    /** Párrafo 1 **/
    private String parrafoUno;
    
    /** Párrafo 2 **/
    private String parrafoDos;
    
    /** Párrafo 3 **/
    private String parrafoTres;
    
    /** Título Sección 1**/
    private String tituloUno;
    
    /** Título Sección 2**/
    private String tituloDos;
    
    /** Título Sección 2a**/
    private String tituloDosA;
    
    /** Título Sección 3**/
    private String tituloTres;
    
    /** Valores Sección 1**/
    private String seccionUno;
    
    /** Valores Sección 2**/
    private String seccionDos;
    
    /** Valores Sección 3**/
    private String seccionTres;
    
    /** Título Servicios Generales**/
    private String tituloServiciosGenerales;    
        
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
    
    /** Título Tabla 1 Columna Seis**/
    private String tituloTablaUnoColumnaSeis;    
    
    /** La fecha actual para mostrar en pdf. **/
    private String fechaActual;
    
    /** La ciudad para mostrar en el encabezado **/
    private String ciudadGeneracion;    
    
    /** Saludo Cliente **/
    private String saludoCliente;  
    
    /** Vigencia Tarifas **/
    private String vigenciaTarifas;   
    
    /** Párrafo 4**/
    private String parrafoCuatro;
    
    /** Párrafo 5**/
    private String parrafoCinco;
    
    /** Párrafo 6**/
    private String parrafoSeis;
    
    /** Párrafo 7**/
    private String parrafoSiete;
    
   
    /** Despedida**/
    private String despedida;
    
    /** Año Actual**/
    private String year;
    
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

     /** Valor Oportunidad.**/
    private Decimal valorTotal;


    /** Los servicios generales del programa.**/
    private List<String> serviciosGeneralesPrograma = new List<String> ();

    /** Los items de la propuesta economica.**/
    private List<COM_PVE_SOExamenesNacionales_ctr.COM_PVEPropuestaEconomica_cls> itemsPropuestaEconomica =
                                new List<COM_PVE_SOExamenesNacionales_ctr.COM_PVEPropuestaEconomica_cls>();
    /** Especificaciones del servicio.**/
    private List<String> especificacionesServicio = new List<String> ();
    
    /** Confirmación del servicio.**/
    private List<String> confirmacionServicio = new List<String> ();

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
       

    /**
     * El constructor de la clase.
     */
    public COM_PVE_SOExamenesNacionales_ctr() {
        idOportunidad = ApexPages.currentPage().getParameters().get('IdCustomObject');
        cargarContenidoDinamico();
        cargarDatos();
    }
    
    
    /**
    Carga el texto estático desde el tipo de metadatos personalizado.
    */
     public void cargarTextoEstatico() {
        
           CotizacionExamenesNacionales__mdt[] lineasEstaticas = [SELECT Saludo__c, Parrafo1__c, Parrafo2__c, Parrafo3__c, 
                                                                    TituloSeccion1__c, tituloSeccion2__c, tituloSeccion3__c, tituloSeccion2a__c, 
                                                                    tituloTablaUnoColumnaUno__c, tituloTablaUnoColumnaDos__c,
                                                                    tituloTablaUnoColumnaTres__c, tituloTablaUnoColumnaCuatro__c,
                                                                    tituloTablaUnoColumnaCinco__c, tituloTablaUnoColumnaSeis__c,
                                                                    Ciudad__c, valoresSeccion1__c, valoresSeccion2__c, valoresSeccion3__c, 
                                                                    SaludoCliente__c, vigenciaTarifas__c, parrafo4__c,
                                                                    parrafo5__c, Parrafo6__c, Parrafo7__c, tituloServiciosGenerales__c,
                                                                    ciudadCliente__c, ProcesoAsesor__c
                                                             FROM CotizacionExamenesNacionales__mdt ];
                                                           
           for (CotizacionExamenesNacionales__mdt lineaEstatica : lineasEstaticas) {
                 String saludoConf = lineaEstatica.Saludo__c;
                 String parrafo1Conf = lineaEstatica.Parrafo1__c;
                 String parrafo2Conf = lineaEstatica.Parrafo2__c;
                 String parrafo3Conf = lineaEstatica.Parrafo3__c;
                 String titulo1Conf  = lineaEstatica.tituloSeccion1__c;
                 String titulo2Conf  = lineaEstatica.tituloSeccion2__c;
                 String titulo3Conf  = lineaEstatica.tituloSeccion3__c;
                 String titulo2aConf  = lineaEstatica.tituloSeccion2a__c;
                 String valores1Conf = lineaEstatica.valoresSeccion1__c;
                 String valores2Conf = lineaEstatica.valoresSeccion2__c;
                 String valores3Conf = lineaEstatica.valoresSeccion3__c;
                 String tituloTabla1Columna1Conf  = lineaEstatica.tituloTablaUnoColumnaUno__c;
                 String tituloTabla1Columna2Conf  = lineaEstatica.tituloTablaUnoColumnaDos__c;
                 String tituloTabla1Columna3Conf  = lineaEstatica.tituloTablaUnoColumnaTres__c;
                 String tituloTabla1Columna4Conf  = lineaEstatica.tituloTablaUnoColumnaCuatro__c;
                 String tituloTabla1Columna5Conf  = lineaEstatica.tituloTablaUnoColumnaCinco__c;
                 String tituloTabla1Columna6Conf  = lineaEstatica.tituloTablaUnoColumnaSeis__c;
                 String tituloServGeneralesConf   = lineaEstatica.tituloServiciosGenerales__c;
                 String ciudadConf = lineaEstatica.Ciudad__c;
                 String ciudadClienteConf = lineaEstatica.ciudadCliente__c;
                 String procesoAsesorConf = lineaEstatica.ProcesoAsesor__c;
                 String parrafo4Conf = lineaEstatica.parrafo4__c;
                 String parrafo5Conf = lineaEstatica.parrafo5__c;
                 String parrafo6Conf = lineaEstatica.Parrafo6__c;
                 String parrafo7Conf = lineaEstatica.Parrafo7__c;
                 String saludoClienteConf = lineaEstatica.SaludoCliente__c;
                 String vigenciaTarifasConf = lineaEstatica.vigenciaTarifas__c;
                 
                 setSaludo(saludoConf);
                 setParrafoUno(parrafo1Conf);
                 setParrafoDos(parrafo2Conf);
                 setParrafoTres(parrafo3Conf);
                 setParrafoCuatro(parrafo4Conf);
                 setParrafoCinco(parrafo5Conf);
                 setParrafoSeis(parrafo6Conf);
                 setParrafoSiete(parrafo7Conf);
                               
                 setTituloUno(titulo1Conf);
                 setTituloDos(titulo2Conf);
                 setTituloDosA(titulo2aConf);
                 setTituloTres(titulo3Conf);
                 setSeccionUno(valores1Conf);
                 setSeccionDos(valores2Conf);
                 setSeccionTres(valores3Conf);
                 setTituloTablaUnoColumnaUno(tituloTabla1Columna1Conf);
                 setTituloTablaUnoColumnaDos(tituloTabla1Columna2Conf);
                 setTituloTablaUnoColumnaTres(tituloTabla1Columna3Conf);
                 setTituloTablaUnoColumnaCuatro(tituloTabla1Columna4Conf);
                 setTituloTablaUnoColumnaCinco(tituloTabla1Columna5Conf);
                 setTituloTablaUnoColumnaSeis(tituloTabla1Columna6Conf);
                 setCiudadGeneracion(ciudadConf);
                 setCiudad(ciudadClienteConf);
                 setProcesoAsesor(procesoAsesorConf);
                 setSaludoCliente(saludoClienteConf);
                 setTituloServiciosGenerales(tituloServGeneralesConf);
                 setVigenciaTarifas(vigenciaTarifasConf);
                 
           }
     }
     

    /**
     * @descrition Metodo encargado de cargar los servicios generales.
     */
    public void cargarServiciosGenerales() {
        serviciosGeneralesPrograma = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= seccionUno.countMatches(saltoLinea);
        String seccionUnoTemporal = seccionUno;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionUnoTemporal.indexOf(saltoLinea);
            String linea = seccionUnoTemporal.substring(0,indice);
            serviciosGeneralesPrograma.add(linea);
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
        Integer numeroLineas= seccionDos.countMatches(saltoLinea);
        String seccionDosTemporal = seccionDos;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionDosTemporal.indexOf(saltoLinea);
            String linea = seccionDosTemporal.substring(0,indice);
            especificacionesServicio.add(linea);
            seccionDosTemporal = seccionDosTemporal.substring(indice+1,seccionDosTemporal.length());        
            
        }        
    }
    
    
        /**
     * @description Metodo encargado de cargar el detalle de la confirmación del servicio
     */
    public void cargarConfirmacionServicio() {
        confirmacionServicio = new List<String>();
        
        //Recorre el texto y separar por salto de línea.
        String saltoLinea = '\n';
        Integer numeroLineas= seccionTres.countMatches(saltoLinea);
        String seccionTresTemporal = seccionTres;
        
        for(Integer i=0; i<numeroLineas; i++){
            
            Integer indice = seccionTresTemporal.indexOf(saltoLinea);
            String linea = seccionTresTemporal.substring(0,indice);
            confirmacionServicio.add(linea);
            seccionTresTemporal = seccionTresTemporal.substring(indice+1,seccionTresTemporal.length());         
            
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
        
        cargarServiciosGenerales();
        cargarEspecificacionesServicios();
        cargarConfirmacionServicio();
        
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
         * Getter del atributo título 2a.
         * @return el atributo título 2a.
         */
        public String getTituloDosA() {
            return tituloDosA;
        }
        

        /**
         * Setter del atributo Título 2a.
         * @param Título 2a el atributo Título 2a a establecer.
         */
        public void setTituloDosA(String tituloDosA) {
            this.tituloDosA = tituloDosA;
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
         * Getter del atributo Título Tabla Uno Columna 6.
         * @return el atributo Título Tabla Uno Columna 6.
         */
        public String getTituloTablaUnoColumnaSeis() {
            return tituloTablaUnoColumnaSeis;
        }
            
       
        /**
         * Setter del atributo Título Tabla Uno Columna 6.
         * @param Título Tabla Uno Columna 6 el atributo Título Tabla Uno Columna 6 a establecer.
         */
        public void setTituloTablaUnoColumnaSeis(String tituloTablaUnoColumnaSeis) {
            this.tituloTablaUnoColumnaSeis = tituloTablaUnoColumnaSeis;
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
     * Getter del atributo serviciosGeneralesPrograma.
     *
     * @return el atributo serviciosGeneralesPrograma.
     */
    public List<String> getServiciosGeneralesPrograma() {
        return serviciosGeneralesPrograma;
    }

    /**
     * Setter del atributo serviciosGeneralesPrograma.
     *
     * @param serviciosGeneralesPrograma el atributo serviciosGeneralesPrograma a establecer.
     */
    public void setServiciosGeneralesPrograma(List<String> serviciosGeneralesPrograma) {
        this.serviciosGeneralesPrograma = serviciosGeneralesPrograma;
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
     * Getter del atributo Confirmación Servicio.
     *
     * @return el atributo Confirmación Servicio.
     */
    public List<String> getConfirmacionServicio() {
        return confirmacionServicio;
    }

    /**
     * Setter del atributo Confirmación Servicio.
     *
     * @param Confirmación Servicio el atributo Confirmación Servicio a establecer.
     */
    public void setConfirmacionServicio(List<String> confirmacionServicio) {
        this.confirmacionServicio = confirmacionServicio;
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
     * Getter del atributo año Actual.
     *
     * @return el atributo Year.
     */
    public String getYear() {
        return year;
    }       

 /**
     * Clase encargada de definir los atributos de los items de propuessta economica.
     */
    public class COM_PVEPropuestaEconomica_cls {

        /** Categoría del producto. **/
        private String categoria;

        /** Subcategoria del producto. **/
        private String subcategoria;
/** Valor del subvalor. **/
        private Decimal subvalor;

        /** Valor del descuento. **/
        private Decimal descuento;
        /** Valor del producto. **/
        private Decimal valor;
        
        /** Nombre del producto. **/
        private String producto;
        
        /** Descripción del producto. **/
        private String descripcion;

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