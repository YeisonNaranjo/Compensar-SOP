/************************************************************************************************
Desarrollado por:  Globant
Autor:             Jorge Pozo (JPA)
Proyecto:          Compensar
Descripción:       Clase para el LWC rl2_ConsultarVinculacion_lwc que se muestra en Ligthning Page Prospecto Afiliación Caja

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     05/08/21        Jorge Pozo (JPA)		Creación Clase.
**************************************************************************************************/

public without sharing class RL2_ConsultarVinculacion_ctr {

    /**
	 * Get Historial Vinculaciones
     * @param String vTipoIdentificacion
     * @param String vNumeroIdentificacion
	 * @return historialVinculaciones.
	 */
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getHistorialVinculaciones(String vTipoIdentificacion, String vNumeroIdentificacion) {
        try{
            COM_ConsultarHistVinculaciones_cls logicaConsultarVinculaciones = new COM_ConsultarHistVinculaciones_cls();
            COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO historialVinculaciones = new COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO();
            historialVinculaciones = (new RL2_ConsultarVinculacion_ctr()).getHistory(Integer.valueOf(vTipoIdentificacion),Long.valueOf(vNumeroIdentificacion));
            List<ResultWrapper> lstResult = new List<ResultWrapper>();
            for(COM_ConsultarHistVinculaciones_cls.VinculacionDTO vc : historialVinculaciones.getVinculaciones()){
                ResultWrapper vResult = new ResultWrapper();
                vResult.tipoVinculacion = vc.getTipoVinculacion();
                vResult.trabajador = vc.getTrabajador();
                vResult.fechaIngreso = vc.getFechaIngresoEmpresa();
                vResult.fechaFin = vc.getFechaFin();
                vResult.estado = vc.getEstadoAfiliacion();
                vResult.empleador = vc.getEmpleador();
                vResult.categoria = vc.getCategoriaAfiliacion();

                lstResult.add(vResult);
            }
            return lstResult;
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO getHistory(Integer vId, Long vNumeroIdentificacion){
        COM_ConsultarClienteGC_ws consumer = new COM_ConsultarClienteGC_ws();
        COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO historialVinculaciones = new COM_ConsultarHistVinculaciones_cls.COM_Historial_VinculacionesDTO();
        
        COM_WrapperConsultaClienteGCResponse_cls.Body response = consumer.Consultar(vId, vNumeroIdentificacion);
        
        if (response == null || response.cliente == null){ return historialVinculaciones; }

        List<COM_ConsultarHistVinculaciones_cls.EmpresasDTO> empresas = (new COM_ConsultarHistVinculaciones_cls()).encontrarEmpresasPorAfiliado(response);
        historialVinculaciones.setEmpresas(empresas);
        
        List<COM_ConsultarHistVinculaciones_cls.VinculacionDTO> vinculaciones = (new COM_ConsultarHistVinculaciones_cls()).encontrarVinculacionesPorAfiliado(response);
        historialVinculaciones.setVinculaciones(vinculaciones);
        return historialVinculaciones;
    }

    /**
     * ResultWrapper Class
     */
    public class ResultWrapper {
        @AuraEnabled
        public String tipoVinculacion;
        @AuraEnabled
        public String trabajador;
        @AuraEnabled
        public String fechaIngreso;
        @AuraEnabled
        public String fechaFin;
        @AuraEnabled
        public String estado;
        @AuraEnabled
        public String empleador;
        @AuraEnabled
        public String categoria;
    }

}