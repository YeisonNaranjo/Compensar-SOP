/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de realizar el consumo del webservice de aldea.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial del la clase.
**/
public class COM_AldeaRequisitoConsumer_cls {

    /** Instancia de la construccion del request aldea. **/
    private COM_BuilderRequestAldea_cls builderRequestAldea_cls = new COM_BuilderRequestAldea_cls();

    /**
     * Metodo encargado de consumir el servicio.
     * @param request los datos para hacer el request.
     * @return la respuesta del servicio.
     */
    public COM_AldeaRequisitoResponse_cls consumirServicio (COM_RequestAldeaDTO_cls request) {
        String xmlRequest = builderRequestAldea_cls.built(request);
        return null;

    }

    /**
     * Clase encargada de construri el request de la peticion.
     */
    public class COM_BuilderRequestAldea_cls {

        /** Instancia de utileria de xml.**/
        private COM_BuilderXMLUtil_cls builderXMLUtil_cls = new COM_BuilderXMLUtil_cls();

        /**
         * Metodo encragado de construir un xml a partir de un DTO.
         * @param request el dto con los datos que desea convertir a xml.
         * @return el xml generado.
         */
        public String built(COM_RequestAldeaDTO_cls request) {
            COM_BuilderXMLUtil_cls.XmlDocument document = new COM_BuilderXMLUtil_cls.XmlDocument();
            document.setName('Afiliado');
            document.addChild(COM_BuilderXMLUtil_cls.createElement
                    ('Identificacion', request.getIdentificacion(), null));
            document.addChild(COM_BuilderXMLUtil_cls.createElement
                    ('TipoIdentificacion', request.getTipoIdentificacion(), null));
            document.addChild(COM_BuilderXMLUtil_cls.createElement
                    ('Programa', request.getPrograma(), null));

            COM_BuilderXMLUtil_cls.XmlElement elementTblNemonico =
                    COM_BuilderXMLUtil_cls.createElement('tblNemonico', null, null);
            elementTblNemonico.addChild(COM_BuilderXMLUtil_cls.createElement
                    ('valor', request.getValor(), null));
            document.addChild(elementTblNemonico);
            return  builderXMLUtil_cls.builtXml(document);
        }

    }

    /**
     * Clase que define los atributos del request de aldea.
     */
    public class COM_RequestAldeaDTO_cls {

        /** Tipo de dentificacion.**/
        private String TipoIdentificacion;

        /** Numero de identificacion.**/
        private String Identificacion;

        /** El Programa.**/
        private String Programa;

        /** El valor nemonico.**/
        private String valor;

        /**
         * Getter del atributo tipoIdentificacion.
         *
         * @return el atributo tipoIdentificacion.
         */
        public String getTipoIdentificacion() {
            return TipoIdentificacion;
        }

        /**
         * Setter del atributo tipoIdentificacion.
         *
         * @param tipoIdentificacion el atributo tipoIdentificacion a establecer.
         */
        public void setTipoIdentificacion(String tipoIdentificacion) {
            TipoIdentificacion = tipoIdentificacion;
        }

        /**
         * Getter del atributo identificacion.
         *
         * @return el atributo identificacion.
         */
        public String getIdentificacion() {
            return Identificacion;
        }

        /**
         * Setter del atributo identificacion.
         *
         * @param identificacion el atributo identificacion a establecer.
         */
        public void setIdentificacion(String identificacion) {
            Identificacion = identificacion;
        }

        /**
         * Getter del atributo programa.
         *
         * @return el atributo programa.
         */
        public String getPrograma() {
            return Programa;
        }

        /**
         * Setter del atributo programa.
         *
         * @param programa el atributo programa a establecer.
         */
        public void setPrograma(String programa) {
            Programa = programa;
        }

        /**
         * Getter del atributo valor.
         *
         * @return el atributo valor.
         */
        public String getValor() {
            return valor;
        }

        /**
         * Setter del atributo valor.
         *
         * @param valor el atributo valor a establecer.
         */
        public void setValor(String valor) {
            this.valor = valor;
        }

    }



}