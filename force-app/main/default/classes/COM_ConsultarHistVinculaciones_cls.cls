/**
* Avanxo Colombia
* @author           Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada implementar la logica de negocio de las operaciones
*                   del historial de vinculaciones.
*                   
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     8/08/2017       Cenristian Mosquera (CM)        Implementacion inicial de la clase.
**/
public class COM_ConsultarHistVinculaciones_cls {

    /** Instancia encargada de realizar el consumo del webservice**/
    private COM_ConsultarClienteGC_ws consumer = new COM_ConsultarClienteGC_ws();

    /**
     * @description Metodo encargado de encontrar el historial de vinculaciones.
     * @param tipoId el tipo de identificacion.
     * @param numeroIdentificacion el numero de identificacion.
     * @return el historial de vinculaciones
     */
    public COM_Historial_VinculacionesDTO encontrarHistorialVinculaciones(Integer tipoId,
            Long numeroIdentificacion) {
        //COM_LogTransacciones__c objLog;
        list<COM_LogTransacciones__c> lstLogs;
        //String strRequestAux;
        COM_Historial_VinculacionesDTO historialVinculaciones = new COM_Historial_VinculacionesDTO();
        //strRequestAux = 'tipoId: ' + tipoId + '; numeroIdentificacion: ' + numeroIdentificacion;
        COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar
                                                    (tipoId, numeroIdentificacion);
        //objLog = COM_Utilidades_cls.generarLog(null, strRequestAux, response, Label.COM_WS_ConsultarClienteGC, null);
        
        try{
            lstLogs = (list<COM_LogTransacciones__c>)Cache.Org.get('local.partition1.logs');
            if(lstLogs != null && !lstLogs.isEmpty()){
                insert lstLogs;
                lstLogs = new list<COM_LogTransacciones__c>();
                Cache.Org.put('local.partition1.logs', lstLogs);
            }
        } catch(Exception e){
            system.debug('NO SE PUDO GUARDAR EL LOG.');
            System.Debug('====================== EXCEPCION [log COM_ConsultarHistVinculaciones_cls] ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('========================================================================================');
        }
        
        if (response == null || response.cliente == null){                
            return historialVinculaciones;
        }
        List<EmpresasDTO> empresas = encontrarEmpresasPorAfiliado(response);
        historialVinculaciones.setEmpresas(empresas);
        if(response.cliente.datosPersona != null){
            List<GrupoFamiliarDTO> grupos = encontrarGrupoFamiliarPorAfiliado(response);
            historialVinculaciones.setGrupoFamiliar(grupos);
            List<BeneficiarioDTO> beneficiarios = encontrarBeneficiariosPorAfiliado(response, empresas);
            historialVinculaciones.setBeneficiarios(beneficiarios);
        }

        if(response.cliente.datosEmpresa == null){

        }
        
        
       
        
        List<VinculacionDTO> vinculaciones = encontrarVinculacionesPorAfiliado(response);
        historialVinculaciones.setVinculaciones(vinculaciones);
        return historialVinculaciones;

    }

    /**
     * @description Metodo encargado de encontrar el grupo familiar del afiliado.
     * @param response la respuesta del servicio.
     * @return Los miembros del grupo familiar.
     */
    public List<GrupoFamiliarDTO> encontrarGrupoFamiliarPorAfiliado
                (COM_WrapperConsultaClienteGCResponse_cls.Body response) {

        List<GrupoFamiliarDTO> grupoFamiliar = new List<GrupoFamiliarDTO>();
        if (response.cliente.datosPersona.Familia == null
                || response.cliente.datosPersona.Familia.familia == null ||
                response.cliente.datosPersona.Familia.familia.isEmpty()) {
            return grupoFamiliar;
        }


        for (COM_WrapperConsultaClienteGCResponse_cls.Familia2 familia :
                response.cliente.datosPersona.Familia.familia) {
            COM_WrapperConsultaClienteGCResponse_cls.DatosPersona2
                    datosPersona = familia.familiar.datosPersona;
            COM_WrapperConsultaClienteGCResponse_cls.Afiliacion2 afiliacion =
                    familia.familiar.Afiliacion.afiliacion.get(0);
            GrupoFamiliarDTO grupo = new GrupoFamiliarDTO();
            grupo.setNombre(datosPersona.nombre);
            String tipoId = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_TIPO_ID_GRP_FAMILIAR,
                            familia.familiar.tipoIdentificacion);
            grupo.setTipoIdentificacion(tipoId);
            grupo.setIdentificacion(familia.familiar.legalID);
            String estadoCivil = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_ESTADO_CIVIL_GRP_FAMILIAR,
                            datosPersona.demografia.estadoCivil);
            grupo.setEstadoCivil(estadoCivil);
            if (String.isNotBlank(datosPersona.demografia.nacimientoFecha)) {
                DateTime actualdate = System.now();
                DateTime fechaNacimiento = COM_Utilidades_cls.stringToDatetime
                        (datosPersona.demografia.nacimientoFecha);
                grupo.setNacimientoFecha(fechaNacimiento.format('dd/MM/yyyy'));

                String edad = String.valueOf(COM_Utilidades_cls.calculateYearsBetweenFechas
                        (actualdate, fechaNacimiento));

                grupo.setEdad(edad);
            }

            grupo.setNombrePrograma
                    (afiliacion.Programa.programa.get(0).nombrePrograma);

            String estado = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_ESTADO_VINCULACION,
                            afiliacion.estado);
            grupo.setEstadoAfiliacion(estado);
            grupo.setCategoriaAfiliacion(afiliacion.categoriaAfiliacion);
            DateTime fecha = null;
            if (String.isNotBlank(afiliacion.inicioFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.inicioFecha);
                grupo.setFechaVinculacion(fecha.format('dd/MM/yyyy'));
            }
            if (String.isNotBlank(afiliacion.finFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.finFecha);
                grupo.setFechaFinVinculacion(fecha.format('dd/MM/yyyy'));
            }

            if (String.isNotBlank(afiliacion.retiroFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.retiroFecha);
                grupo.setFechaRetiro(fecha.format('dd/MM/yyyy'));
            }
            /* Todo no se sabe cual es etse campo*/
            if (String.isNotBlank(afiliacion.cantidadVinculacion)) {
                grupo.setIdentificadorSubsidio(COM_ConsultarTablaDominio_cls.consultarValorTabla('IndicadorSubsidio', afiliacion.cantidadVinculacion));
            }
            /*String parentezco = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_PARENTEZCO_GRP_FAMILIAR,
                            familia.tipoParentesco);
            grupo.setTipoParentesco(parentezco);*/
            try {
                //grupo.setTipoParentesco(familia.familiar.Afiliacion.afiliacion[0].Programa.programa[0].nombrePrograma);
                grupo.setTipoParentesco(familia.tipoParentesco);
             }
            catch (Exception e) {
                 grupo.setTipoParentesco(familia.tipoParentesco);
            }
            //grupo.setTipoParentesco(familia.tipoParentesco);
            grupoFamiliar.add(grupo);
        }

        return grupoFamiliar;
    }


    /**
     * @description Metodo encargado de encontrar las empresas del afiliado.
     * @param response la respuesta del servicio.
     * @return Las empresas del afiliado.
     */
    public List<EmpresasDTO> encontrarEmpresasPorAfiliado
            (COM_WrapperConsultaClienteGCResponse_cls.Body response) {

        List<EmpresasDTO> empresas = new List<EmpresasDTO>();
        if (response.cliente.Afiliacion == null
                || response.cliente.afiliacion == null ||
                response.cliente.afiliacion.afiliacion.isEmpty()) {
            return empresas;
        }

        for (COM_WrapperConsultaClienteGCResponse_cls.Afiliacion4 afiliacion : response.cliente.afiliacion.afiliacion ){
            EmpresasDTO empresa = new EmpresasDTO();
            if (afiliacion.ClienteResponsable != null &&
                    afiliacion.ClienteResponsable.clienteResponsable != null &&
                    !afiliacion.ClienteResponsable.clienteResponsable.isEmpty()) {

                /*if (String.isBlank(afiliacion.ClienteResponsable.clienteResponsable.get
                                                                                (1).legalID)) {
                    continue;
                }*/
                /* Todo no se sabe cual es este atributo */
                //empresa.setTipoVinculacion();
                empresa.setNombre(afiliacion.ClienteResponsable.clienteResponsable.get(1).nombre);
                DateTime fecha = null;
                if (String.isNotBlank(afiliacion.inicioFecha)) {
                    fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.inicioFecha);
                    empresa.setFechaVinculacion(fecha.format('dd/MM/yyyy'));
                }
                if (String.isNotBlank(afiliacion.finFecha)) {
                    fecha = COM_Utilidades_cls.stringToDatetime
                            (afiliacion.finFecha);
                    empresa.setFechaFinVinculacion(fecha.format('dd/MM/yyyy'));
                }

                if (String.isNotBlank(afiliacion.retiroFecha)) {
                    fecha = COM_Utilidades_cls.stringToDatetime
                            (afiliacion.retiroFecha);
                    empresa.setFechaRetiro(fecha.format('dd/MM/yyyy'));
                }
                if (String.isNotBlank(afiliacion.ingresoEmpresaFecha)) {
                    fecha = COM_Utilidades_cls.stringToDatetime
                            (afiliacion.ingresoEmpresaFecha);
                    empresa.setFechaIngresoEmpresa(fecha.format('dd/MM/yyyy'));
                }
                String estado = COM_ConsultarTablaDominio_cls.consultarValorTabla
                        (Label.COM_NAME_ESTADO_EMPRESA,
                                afiliacion.estado);
                empresa.setEstadoAfiliacion(estado);
                empresa.setCategoriaAfiliacion(afiliacion.categoriaAfiliacion);
                empresas.add(empresa);
                system.debug('ruben'+empresa);
            }
        }

        return empresas;

    }


    /**
     * @description Metodo encargado de encontrar los beneficios del afiliado.
     * @param response la respuesta del servicio.
     * @return los beneficios del afiliado.
     */
    public List<BeneficiarioDTO> encontrarBeneficiariosPorAfiliado
            (COM_WrapperConsultaClienteGCResponse_cls.Body response, List<EmpresasDTO> empresas) {

        List<BeneficiarioDTO> beneficiarios = new List<BeneficiarioDTO>();
        if (response.cliente.datosPersona.Familia == null
                || response.cliente.datosPersona.Familia.familia == null ||
                response.cliente.datosPersona.Familia.familia.isEmpty()) {
            return beneficiarios;
        }

        for (COM_WrapperConsultaClienteGCResponse_cls.Familia2 familia :
                response.cliente.datosPersona.Familia.familia) {
            BeneficiarioDTO beneficiario = new BeneficiarioDTO();
            COM_WrapperConsultaClienteGCResponse_cls.Afiliacion2 afiliacion
                    = familia.familiar.Afiliacion.afiliacion.get(0);
                /* Todo no se sabe cual es este atributo */
            //empresa.setTipoVinculacion();
            DateTime fecha = null;
            if (String.isNotBlank(afiliacion.inicioFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.inicioFecha);
                beneficiario.setFechaVinculacion(fecha.format('dd/MM/yyyy'));
            }
            if (String.isNotBlank(afiliacion.finFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.finFecha);
                beneficiario.setFechaFinVinculacion(fecha.format('dd/MM/yyyy'));
            }
            if (String.isNotBlank(afiliacion.retiroFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.retiroFecha);
                beneficiario.setFechaRetiro(fecha.format('dd/MM/yyyy'));
            }
            if (String.isNotBlank(afiliacion.ingresoEmpresaFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.ingresoEmpresaFecha);
                beneficiario.setFechaIngresoEmpresa(fecha.format('dd/MM/yyyy'));
            }

            String estado = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_ESTADO_BENEFICIARIO,
                            afiliacion.estado);
            beneficiario.setEstadoAfiliacion(estado);
            beneficiario.setCategoriaAfiliacion(afiliacion.categoriaAfiliacion);
                /* Todo no se sabe cual es etse atributo.*/
            //beneficiario.setSalario()
                /* Todo no se sabe cual es etse atributo.*/
            //beneficiario.setHorasLab()
                /* Todo no se sabe cual es etse atributo.*/
            //beneficiario.setTrabajador()
            String tipoId = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_TIPO_ID_GRP_FAMILIAR,
                            familia.familiar.tipoIdentificacion);
            beneficiario.setTrabajador(tipoId + ' ' + familia.familiar.legalID);
                /* Todo no se sabe cual es etse atributo.*/
            //beneficiario.setEmpleador()
                /* Todo no se sabe cual es etse atributo.*/
            //beneficiario.setActualizar()
            beneficiarios.add(beneficiario);
        }

        return beneficiarios;

    }


    /**en
     * @description Metodo encargado de encontrar las vinculaciones del afiliado.
     * @param response la respuestena del servicio.
     * @return las vinculaciones del afiliado.
     */
    public List<VinculacionDTO> encontrarVinculacionesPorAfiliado(COM_WrapperConsultaClienteGCResponse_cls.Body response) {
    
        List<VinculacionDTO> vinculaciones = new List<VinculacionDTO>();
        system.debug('parte0');
        if (response.cliente.Afiliacion == null
                || response.cliente.afiliacion == null ||
                response.cliente.afiliacion.afiliacion.isEmpty()) {
                system.debug('response.cliente.Afiliacion -> '+response.cliente.Afiliacion);
            return vinculaciones;
        }
        system.debug('parte1');

        for (COM_WrapperConsultaClienteGCResponse_cls.Afiliacion4
                                afiliacion : response.cliente.afiliacion.afiliacion) {
            VinculacionDTO vinculacion = new VinculacionDTO();

                /* Todo no se sabe cual es este atributo */
            vinculacion.setTipoVinculacion(afiliacion.Programa.programa[0].nombrePrograma);
            DateTime fecha = null;
            if (String.isNotBlank(afiliacion.ingresoEmpresaFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime
                        (afiliacion.ingresoEmpresaFecha);
                vinculacion.setFechaIngresoEmpresa(fecha.format('dd/MM/yyyy'));
            }
            if (String.isNotBlank(afiliacion.finFecha)) {
                fecha = COM_Utilidades_cls.stringToDatetime(afiliacion.finFecha);
                vinculacion.setFechaFin(fecha.format('dd/MM/yyyy'));
            }

            String estado = COM_ConsultarTablaDominio_cls.consultarValorTabla
                    (Label.COM_NAME_ESTADO_VINCULACION,
                            afiliacion.estado);
            vinculacion.setEstadoAfiliacion(estado);
            vinculacion.setCategoriaAfiliacion(afiliacion.categoriaAfiliacion);
            if (afiliacion.ClienteResponsable != null &&
                    afiliacion.ClienteResponsable.clienteResponsable != null &&
                    !afiliacion.ClienteResponsable.clienteResponsable.isEmpty()) {
                COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable4 datosTrabajador =
                        afiliacion.ClienteResponsable.clienteResponsable.get(0);

                COM_WrapperConsultaClienteGCResponse_cls.ClienteResponsable4 datosEmpleador =
                        afiliacion.ClienteResponsable.clienteResponsable.get(1);
                String tipoId = COM_ConsultarTablaDominio_cls.consultarValorTabla
                        (Label.COM_NAME_TIPO_ID_GRP_FAMILIAR,
                                datosTrabajador.tipoIdentificacion);
                vinculacion.setTrabajador(tipoId + ' ' + datosTrabajador.legalID );
                system.debug('parte2');
                if(datosEmpleador.nombre != null) {
                 vinculacion.setEmpleador(datosEmpleador.nombre.trim());
                 system.debug('parte3');
                }
            }
            /* Todo no se sabe cual es etse atributo.*/
            //vinculacion.setSalario()
                /* Todo no se sabe cual es etse atributo.*/
            //vinculacion.setTrabajador()
                /* Todo no se sabe cual es etse atributo.*/
            //vinculacion.setEmpleador()
                /* Todo no se sabe cual es etse atributo.*/
            //vinculacion.setActualizar()
            vinculaciones.add(vinculacion);
        }

        return vinculaciones;

    }


    /**
     * Clase que define los atributos del historial de vinculaciones.
     */
    public class COM_Historial_VinculacionesDTO {

        /** Almacena los miembros del grupo familiar. **/
        private List<GrupoFamiliarDTO> grupoFamiliar = new List<GrupoFamiliarDTO>();
        /** Almacena la informacion de empresas.**/
        private List<EmpresasDTO> empresas = new List<EmpresasDTO> ();
        /** Almacena la informacion de beneficiarios.**/
        private List<BeneficiarioDTO> beneficiarios = new List<BeneficiarioDTO> ();
        /** Las vinculaciones.**/
        private List<VinculacionDTO> vinculaciones = new List<VinculacionDTO>();

        /**
        * Getter del atributo grupoFamiliar.
        *
        * @return el atributo grupoFamiliar.
        */
        public List<GrupoFamiliarDTO> getGrupoFamiliar() {
            return grupoFamiliar;
        }

        /**
         * Setter del atributo grupoFamiliar.
         *
         * @param grupoFamiliar el atributo grupoFamiliar a establecer.
         */
        public void setGrupoFamiliar(List<GrupoFamiliarDTO> grupoFamiliar) {
            this.grupoFamiliar = grupoFamiliar;
        }


        /**
         * Getter del atributo empresas.
         *
         * @return el atributo empresas.
         */
        public List<EmpresasDTO> getEmpresas() {
            return empresas;
        }

        /**
         * Setter del atributo empresas.
         *
         * @param empresas el atributo empresas a establecer.
         */
        public void setEmpresas(List<EmpresasDTO> empresas) {
            this.empresas = empresas;
        }

        /**
         * Getter del atributo beneficiarios.
         *
         * @return el atributo beneficiarios.
         */
        public List<BeneficiarioDTO> getBeneficiarios() {
            return beneficiarios;
        }

        /**
         * Setter del atributo beneficiarios.
         *
         * @param beneficiarios el atributo beneficiarios a establecer.
         */
        public void setBeneficiarios(List<BeneficiarioDTO> beneficiarios) {
            this.beneficiarios = beneficiarios;
        }


        /**
         * Getter del atributo vinculaciones.
         *
         * @return el atributo vinculaciones.
         */
        public List<VinculacionDTO> getVinculaciones() {
            return vinculaciones;
        }

        /**
         * Setter del atributo vinculaciones.
         *
         * @param vinculaciones el atributo vinculaciones a establecer.
         */
        public void setVinculaciones(List<VinculacionDTO> vinculaciones) {
            this.vinculaciones = vinculaciones;
        }

    }


    /**
     * CLase encargada de representar los atributos del grupo familiar.
     */
    public class GrupoFamiliarDTO {

        /** El tipo de identificacion.**/
        private String tipoIdentificacion;
        /** El numero de identificacion.**/
        private String identificacion;
        /** Nombre del familiar.**/
        private String nombre;
        /** Estado civil del familiar.**/
        private String estadoCivil;
        /** Fecha nacimiento del familiar.**/
        private String nacimientoFecha;
        /** Edad del familiar.**/
        private String edad;
        /** Nombre del familiar.**/
        private String nombrePrograma;
        /** Estado de afiliacion.**/
        private String estadoAfiliacion;
        /** Categoria del familiar.**/
        private String categoriaAfiliacion;
        /** Fecha de vinculacion del familiar.**/
        private String fechaVinculacion;
        /** Fecha final de vinculacion del familiar.**/
        private String fechaFinVinculacion;
        /** Fecha de retiro del familiar.**/
        private String fechaRetiro;
        /** Identifica si tiene subsidio.**/
        private String identificadorSubsidio;
        /** Parentesco del familiar.**/
        private String tipoParentesco;

        /**
         * Getter del atributo fechaFinVinculacion.
         *
         * @return el atributo fechaFinVinculacion.
         */
        public String getFechaFinVinculacion() {
            return fechaFinVinculacion;
        }

        /**
         * Setter del atributo fechaFinVinculacion.
         *
         * @param fechaFinVinculacion el atributo fechaFinVinculacion a establecer.
         */
        public void setFechaFinVinculacion(String fechaFinVinculacion) {
            this.fechaFinVinculacion = fechaFinVinculacion;
        }


        /**
         * Getter del atributo tipoIdentificacion.
         *
         * @return el atributo tipoIdentificacion.
         */
        public String getTipoIdentificacion() {
            return tipoIdentificacion;
        }
        /**
         * Setter del atributo tipoIdentificacion.
         *
         * @param tipoIdentificacion el atributo tipoIdentificacion a establecer.
         */
        public void setTipoIdentificacion(String tipoIdentificacion) {
            this.tipoIdentificacion = tipoIdentificacion;
        }
        /**
         * Getter del atributo identificacion.
         *
         * @return el atributo identificacion.
         */
        public String getIdentificacion() {
            return identificacion;
        }
        /**
         * Setter del atributo identificacion.
         *
         * @param identificacion el atributo identificacion a establecer.
         */
        public void setIdentificacion(String identificacion) {
            this.identificacion = identificacion;
        }


        /**
         * Getter del atributo nombre.
         *
         * @return el atributo nombre.
        */
        public String getNombre() {
            return nombre;
        }
        /**
         * Setter del atributo nombre.
         *
         * @param nombre el atributo nombre a establecer.
         */
        public void setNombre(String nombre) {
            this.nombre = nombre;
        }
        /**
         * Getter del atributo estadoCivil.
         *
         * @return el atributo estadoCivil.
         */
        public String getEstadoCivil() {
            return estadoCivil;
        }
        /**
         * Setter del atributo estadoCivil.
         *
         * @param estadoCivil el atributo estadoCivil a establecer.
         */
        public void setEstadoCivil(String estadoCivil) {
            this.estadoCivil = estadoCivil;
        }
        /**
         * Getter del atributo nacimientoFecha.
         *
         * @return el atributo nacimientoFecha.
         */
        public String getNacimientoFecha() {
            return nacimientoFecha;
        }
        /**
         * Setter del atributo nacimientoFecha.
         *
         * @param nacimientoFecha el atributo nacimientoFecha a establecer.
         */
        public void setNacimientoFecha(String nacimientoFecha) {
            this.nacimientoFecha = nacimientoFecha;
        }
        /**
         * Getter del atributo edad.
         *
         * @return el atributo edad.
         */
        public String getEdad() {
            return edad;
        }
        /**
         * Setter del atributo edad.
         *
         * @param edad el atributo edad a establecer.
         */
        public void setEdad(String edad) {
            this.edad = edad;
        }
        /**
         * Getter del atributo nombrePrograma.
         *
         * @return el atributo nombrePrograma.
         */
        public String getNombrePrograma() {
            return nombrePrograma;
        }
        /**
         * Setter del atributo nombrePrograma.
         *
         * @param nombrePrograma el atributo nombrePrograma a establecer.
         */
        public void setNombrePrograma(String nombrePrograma) {
            this.nombrePrograma = nombrePrograma;
        }
        /**
         * Getter del atributo estadoAfiliacion.
         *
         * @return el atributo estadoAfiliacion.
         */
        public String getEstadoAfiliacion() {
            return estadoAfiliacion;
        }
        /**
         * Setter del atributo estadoAfiliacion.
         *
         * @param estadoAfiliacion el atributo estadoAfiliacion a establecer.
         */
        public void setEstadoAfiliacion(String estadoAfiliacion) {
            this.estadoAfiliacion = estadoAfiliacion;
        }
        /**
         * Getter del atributo categoriaAfiliacion.
         *
         * @return el atributo categoriaAfiliacion.
         */
        public String getCategoriaAfiliacion() {
            return categoriaAfiliacion;
        }
        /**
         * Setter del atributo categoriaAfiliacion.
         *
         * @param categoriaAfiliacion el atributo categoriaAfiliacion a establecer.
         */
        public void setCategoriaAfiliacion(String categoriaAfiliacion) {
            this.categoriaAfiliacion = categoriaAfiliacion;
        }
        /**
         * Getter del atributo fechaVinculacion.
         *
         * @return el atributo fechaVinculacion.
         */
        public String getFechaVinculacion() {
            return fechaVinculacion;
        }
        /**
         * Setter del atributo fechaVinculacion.
         *
         * @param fechaVinculacion el atributo fechaVinculacion a establecer.
         */
        public void setFechaVinculacion(String fechaVinculacion) {
            this.fechaVinculacion = fechaVinculacion;
        }
        /**
         * Getter del atributo fechaRetiro.
         *
         * @return el atributo fechaRetiro.
         */
        public String getFechaRetiro() {
            return fechaRetiro;
        }
        /**
         * Setter del atributo fechaRetiro.
         *
         * @param fechaRetiro el atributo fechaRetiro a establecer.
         */
        public void setFechaRetiro(String fechaRetiro) {
            this.fechaRetiro = fechaRetiro;
        }
        /**
         * Getter del atributo identificadorSubsidio.
         *
         * @return el atributo identificadorSubsidio.
         */
        public String getIdentificadorSubsidio() {
            return identificadorSubsidio;
        }
        /**
         * Setter del atributo identificadorSubsidio.
         *
         * @param identificadorSubsidio el atributo identificadorSubsidio a establecer.
         */
        public void setIdentificadorSubsidio(String identificadorSubsidio) {
            this.identificadorSubsidio = identificadorSubsidio;
        }
        /**
         * Getter del atributo tipoParentesco.
         *
         * @return el atributo tipoParentesco.
         */
        public String getTipoParentesco() {
            return tipoParentesco;
        }
        /**
         * Setter del atributo tipoParentesco.
         *
         * @param tipoParentesco el atributo tipoParentesco a establecer.
         */
        public void setTipoParentesco(String tipoParentesco) {
            this.tipoParentesco = tipoParentesco;
        }

    }

    /**
     * Clase que define los atributos de las empresas.
     */
    public class EmpresasDTO {

        /** El tipo de vinculacion. **/
        private String tipoVinculacion;
        /** Fecha de vinculacion. **/
        private String fechaVinculacion;
        /** El tipo de ingreso a la empresa. **/
        private String fechaIngresoEmpresa;
        /** La fecha final de vinculacion. **/
        private String fechaFin;
        /** La fecha de retiro. **/
        private String fechaRetiro;
        /** El estado de la afiliacion. **/
        private String estadoAfiliacion;
        /** La categoria de la afiliacion. **/
        private String categoriaAfiliacion;
        /** El nombre de la empresa**/
        private String nombre;
        /** Fecha final de vinculacion. **/
        private String fechaFinVinculacion;


        /**
         * Getter del atributo tipoVinculacion.
         *
         * @return el atributo tipoVinculacion.
         */
        public String getTipoVinculacion() {
            return tipoVinculacion;
        }

        /**
         * Setter del atributo tipoVinculacion.
         *
         * @param tipoVinculacion
         *            el atributo tipoVinculacion a establecer.
         */
        public void setTipoVinculacion(String tipoVinculacion) {
            this.tipoVinculacion = tipoVinculacion;
        }

        /**
         * Getter del atributo fechaVinculacion.
         *
         * @return el atributo fechaVinculacion.
         */
        public String getFechaVinculacion() {
            return fechaVinculacion;
        }

        /**
         * Setter del atributo fechaVinculacion.
         *
         * @param fechaVinculacion
         *            el atributo fechaVinculacion a establecer.
         */
        public void setFechaVinculacion(String fechaVinculacion) {
            this.fechaVinculacion = fechaVinculacion;
        }

        /**
         * Getter del atributo fechaIngresoEmpresa.
         *
         * @return el atributo fechaIngresoEmpresa.
         */
        public String getFechaIngresoEmpresa() {
            return fechaIngresoEmpresa;
        }

        /**
         * Setter del atributo fechaIngresoEmpresa.
         *
         * @param fechaIngresoEmpresa
         *            el atributo fechaIngresoEmpresa a establecer.
         */
        public void setFechaIngresoEmpresa(String fechaIngresoEmpresa) {
            this.fechaIngresoEmpresa = fechaIngresoEmpresa;
        }


        /**
         * Getter del atributo fechaRetiro.
         *
         * @return el atributo fechaRetiro.
         */
        public String getFechaRetiro() {
            return fechaRetiro;
        }

        /**
         * Setter del atributo fechaRetiro.
         *
         * @param fechaRetiro
         *            el atributo fechaRetiro a establecer.
         */
        public void setFechaRetiro(String fechaRetiro) {
            this.fechaRetiro = fechaRetiro;
        }

        /**
         * Getter del atributo estadoAfiliacion.
         *
         * @return el atributo estadoAfiliacion.
         */
        public String getEstadoAfiliacion() {
            return estadoAfiliacion;
        }

        /**
         * Setter del atributo estadoAfiliacion.
         *
         * @param estadoAfiliacion
         *            el atributo estadoAfiliacion a establecer.
         */
        public void setEstadoAfiliacion(String estadoAfiliacion) {
            this.estadoAfiliacion = estadoAfiliacion;
        }

        /**
         * Getter del atributo categoriaAfiliacion.
         *
         * @return el atributo categoriaAfiliacion.
         */
        public String getCategoriaAfiliacion() {
            return categoriaAfiliacion;
        }

        /**
         * Setter del atributo categoriaAfiliacion.
         *
         * @param categoriaAfiliacion
         *            el atributo categoriaAfiliacion a establecer.
         */
        public void setCategoriaAfiliacion(String categoriaAfiliacion) {
            this.categoriaAfiliacion = categoriaAfiliacion;
        }

        /**
         * Getter del atributo nombre.
         *
         * @return el atributo nombre.
         */
        public String getNombre() {
            return nombre;
        }

        /**
         * Setter del atributo nombre.
         *
         * @param nombre el atributo nombre a establecer.
         */
        public void setNombre(String nombre) {
            this.nombre = nombre;
        }


        /**
         * Getter del atributo fechaFinVinculacion.
         *
         * @return el atributo fechaFinVinculacion.
         */
        public String getFechaFinVinculacion() {
            return fechaFinVinculacion;
        }

        /**
         * Setter del atributo fechaFinVinculacion.
         *
         * @param fechaFinVinculacion el atributo fechaFinVinculacion a establecer.
         */
        public void setFechaFinVinculacion(String fechaFinVinculacion) {
            this.fechaFinVinculacion = fechaFinVinculacion;
        }





    }

    /**
     * @description Clase encargada de representar los atributos de los beneficiearios
     */
    public class BeneficiarioDTO {
         /** El tipo de vinculacion. **/
        private String tipoVinculacion;
        /** Fecha de vinculacion. **/
        private String fechaVinculacion;
        /** El tipo de ingreso a la empresa. **/
        private String fechaIngresoEmpresa;
        /** La fecha final de vinculacion. **/
        private String fechaFinVinculacion;
        /** La fecha de retiro. **/
        private String fechaRetiro;
        /** El estado de la afiliacion. **/
        private String estadoAfiliacion;
        /** La categoria de la afiliacion. **/
        private String categoriaAfiliacion;
        /** El salario del beneficiario.**/
        private String salario;
        /** El salario del beneficiario.**/
        private String horasLab;
        /** El numero de cedula del trabajador.**/
        private String trabajador;
        /** El empleador.**/
        private String empleador;
        /** El salario del beneficiario.**/
        private String actualizar;


        /**
         * Getter del atributo tipoVinculacion.
         *
         * @return el atributo tipoVinculacion.
         */
        public String getTipoVinculacion() {
            return tipoVinculacion;
        }

        /**
         * Setter del atributo tipoVinculacion.
         *
         * @param tipoVinculacion
         *            el atributo tipoVinculacion a establecer.
         */
        public void setTipoVinculacion(String tipoVinculacion) {
            this.tipoVinculacion = tipoVinculacion;
        }

        /**
         * Getter del atributo fechaVinculacion.
         *
         * @return el atributo fechaVinculacion.
         */
        public String getFechaVinculacion() {
            return fechaVinculacion;
        }

        /**
         * Setter del atributo fechaVinculacion.
         *
         * @param fechaVinculacion
         *            el atributo fechaVinculacion a establecer.
         */
        public void setFechaVinculacion(String fechaVinculacion) {
            this.fechaVinculacion = fechaVinculacion;
        }

        /**
         * Getter del atributo fechaIngresoEmpresa.
         *
         * @return el atributo fechaIngresoEmpresa.
         */
        public String getFechaIngresoEmpresa() {
            return fechaIngresoEmpresa;
        }

        /**
         * Setter del atributo fechaIngresoEmpresa.
         *
         * @param fechaIngresoEmpresa
         *            el atributo fechaIngresoEmpresa a establecer.
         */
        public void setFechaIngresoEmpresa(String fechaIngresoEmpresa) {
            this.fechaIngresoEmpresa = fechaIngresoEmpresa;
        }

        /**
         * Getter del atributo fechaFinVinculacion.
         *
         * @return el atributo fechaFinVinculacion.
         */
        public String getFechaFinVinculacion() {
            return fechaFinVinculacion;
        }

        /**
         * Setter del atributo fechaFinVinculacion.
         *
         * @param fechaFin
         *            el atributo fechaFinVinculacion a establecer.
         */
        public void setFechaFinVinculacion(String fechaFinVinculacion) {
            this.fechaFinVinculacion = fechaFinVinculacion;
        }

        /**
         * Getter del atributo fechaRetiro.
         *
         * @return el atributo fechaRetiro.
         */
        public String getFechaRetiro() {
            return fechaRetiro;
        }

        /**
         * Setter del atributo fechaRetiro.
         *
         * @param fechaRetiro
         *            el atributo fechaRetiro a establecer.
         */
        public void setFechaRetiro(String fechaRetiro) {
            this.fechaRetiro = fechaRetiro;
        }

        /**
         * Getter del atributo estadoAfiliacion.
         *
         * @return el atributo estadoAfiliacion.
         */
        public String getEstadoAfiliacion() {
            return estadoAfiliacion;
        }

        /**
         * Setter del atributo estadoAfiliacion.
         *
         * @param estadoAfiliacion
         *            el atributo estadoAfiliacion a establecer.
         */
        public void setEstadoAfiliacion(String estadoAfiliacion) {
            this.estadoAfiliacion = estadoAfiliacion;
        }

        /**
         * Getter del atributo categoriaAfiliacion.
         *
         * @return el atributo categoriaAfiliacion.
         */
        public String getCategoriaAfiliacion() {
            return categoriaAfiliacion;
        }

        /**
         * Setter del atributo categoriaAfiliacion.
         *
         * @param categoriaAfiliacion
         *            el atributo categoriaAfiliacion a establecer.
         */
        public void setCategoriaAfiliacion(String categoriaAfiliacion) {
            this.categoriaAfiliacion = categoriaAfiliacion;
        }

        /**
         * Getter del atributo salario.
         *
         * @return el atributo salario.
         */
        public String getSalario() {
            return salario;
        }

        /**
         * Setter del atributo salario.
         *
         * @param salario
         *            el atributo salario a establecer.
         */
        public void setSalario(String salario) {
            this.salario = salario;
        }

        /**
         * Getter del atributo horasLab.
         *
         * @return el atributo horasLab.
         */
        public String getHorasLab() {
            return horasLab;
        }

        /**
         * Setter del atributo horasLab.
         *
         * @param horasLab
         *            el atributo horasLab a establecer.
         */
        public void setHorasLab(String horasLab) {
            this.horasLab = horasLab;
        }

        /**
         * Getter del atributo trabajador.
         *
         * @return el atributo trabajador.
         */
        public String getTrabajador() {
            return trabajador;
        }

        /**
         * Setter del atributo trabajador.
         *
         * @param trabajador
         *            el atributo trabajador a establecer.
         */
        public void setTrabajador(String trabajador) {
            this.trabajador = trabajador;
        }

        /**
         * Getter del atributo empleador.
         *
         * @return el atributo empleador.
         */
        public String getEmpleador() {
            return empleador;
        }

        /**
         * Setter del atributo empleador.
         *
         * @param empleador
         *            el atributo empleador a establecer.
         */
        public void setEmpleador(String empleador) {
            this.empleador = empleador;
        }

        /**
         * Getter del atributo actualizar.
         *
         * @return el atributo actualizar.
         */
        public String getActualizar() {
            return actualizar;
        }

        /**
         * Setter del atributo actualizar.
         *
         * @param actualizar
         *            el atributo actualizar a establecer.
         */
        public void setActualizar(String actualizar) {
            this.actualizar = actualizar;
        }

    }


    /**
     * @description Clase encargada de representar los atributos de las vinculaciones.
     */
    public class VinculacionDTO {
         /** El tipo de vinculacion. **/
        private String tipoVinculacion;
        /** El tipo de ingreso a la empresa. **/
        private String fechaIngresoEmpresa;
        /** La fecha final de vinculacion. **/
        private String fechaFin;
        /** El estado de la afiliacion. **/
        private String estadoAfiliacion;
        /** El salario del afliado.**/
        private String salario;
        /** La categoria de la afiliacion. **/
        private String categoriaAfiliacion;
        /** El numero de cedula del trabajador.**/
        private String trabajador;
        /** El empleador.**/
        private String empleador;
        /** El salario del beneficiario.**/
        private String actualizar;



        /**
         * Getter del atributo tipoVinculacion.
         *
         * @return el atributo tipoVinculacion.
         */
        public String getTipoVinculacion() {
            return tipoVinculacion;
        }

        /**
         * Setter del atributo tipoVinculacion.
         *
         * @param tipoVinculacion
         *            el atributo tipoVinculacion a establecer.
         */
        public void setTipoVinculacion(String tipoVinculacion) {
            this.tipoVinculacion = tipoVinculacion;
        }


        /**
         * Getter del atributo fechaIngresoEmpresa.
         *
         * @return el atributo fechaIngresoEmpresa.
         */
        public String getFechaIngresoEmpresa() {
            return fechaIngresoEmpresa;
        }

        /**
         * Setter del atributo fechaIngresoEmpresa.
         *
         * @param fechaIngresoEmpresa
         *            el atributo fechaIngresoEmpresa a establecer.
         */
        public void setFechaIngresoEmpresa(String fechaIngresoEmpresa) {
            this.fechaIngresoEmpresa = fechaIngresoEmpresa;
        }

        /**
         * Getter del atributo fechaFin.
         *
         * @return el atributo fechaFin.
         */
        public String getFechaFin() {
            return fechaFin;
        }

        /**
         * Setter del atributo fechaFin.
         *
         * @param fechaFin
         *            el atributo fechaFin a establecer.
         */
        public void setFechaFin(String fechaFin) {
            this.fechaFin = fechaFin;
        }

        /**
         * Getter del atributo estadoAfiliacion.
         *
         * @return el atributo estadoAfiliacion.
         */
        public String getEstadoAfiliacion() {
            return estadoAfiliacion;
        }

        /**
         * Setter del atributo estadoAfiliacion.
         *
         * @param estadoAfiliacion
         *            el atributo estadoAfiliacion a establecer.
         */
        public void setEstadoAfiliacion(String estadoAfiliacion) {
            this.estadoAfiliacion = estadoAfiliacion;
        }

        /**
         * Getter del atributo salario.
         *
         * @return el atributo salario.
         */
        public String getSalario() {
            return salario;
        }

        /**
         * Setter del atributo salario.
         *
         * @param salario
         *            el atributo salario a establecer.
         */
        public void setSalario(String salario) {
            this.salario = salario;
        }

        /**
         * Getter del atributo categoriaAfiliacion.
         *
         * @return el atributo categoriaAfiliacion.
         */
        public String getCategoriaAfiliacion() {
            return categoriaAfiliacion;
        }

        /**
         * Setter del atributo categoriaAfiliacion.
         *
         * @param categoriaAfiliacion
         *            el atributo categoriaAfiliacion a establecer.
         */
        public void setCategoriaAfiliacion(String categoriaAfiliacion) {
            this.categoriaAfiliacion = categoriaAfiliacion;
        }

        /**
         * Getter del atributo trabajador.
         *
         * @return el atributo trabajador.
         */
        public String getTrabajador() {
            return trabajador;
        }

        /**
         * Setter del atributo trabajador.
         *
         * @param trabajador
         *            el atributo trabajador a establecer.
         */
        public void setTrabajador(String trabajador) {
            this.trabajador = trabajador;
        }

        /**
         * Getter del atributo empleador.
         *
         * @return el atributo empleador.
         */
        public String getEmpleador() {
            return empleador;
        }

        /**
         * Setter del atributo empleador.
         *
         * @param empleador
         *            el atributo empleador a establecer.
         */
        public void setEmpleador(String empleador) {
            this.empleador = empleador;
        }

        /**
         * Getter del atributo actualizar.
         *
         * @return el atributo actualizar.
         */
        public String getActualizar() {
            return actualizar;
        }

        /**
         * Setter del atributo actualizar.
         *
         * @param actualizar
         *            el atributo actualizar a establecer.
         */
        public void setActualizar(String actualizar) {
            this.actualizar = actualizar;
        }


    }

}