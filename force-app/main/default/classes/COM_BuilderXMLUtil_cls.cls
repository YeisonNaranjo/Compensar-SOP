/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			compensar
* Description:		Classe encargadoa de realizar operaciones de parseo de xml.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
public class COM_BuilderXMLUtil_cls {

     /** XML de salida.**/
    private String xmlOut;

    /**
     * Metodo encargado de construir un xml apartir de un <code>XMLDocument</code>.
     * @param document el documento que desea convertir.
     * @return xml generado.
     */
    public String builtXml(XmlDocument document) {
        xmlOut = '';
        xmlOut = '<' + document.getName() + '>';
        loadXmlElements(document.getChilds());
        xmlOut += '</' + document.getName() + '>';
        return xmlOut;

    }

    /**
     * Genera un elemento xml.
     * @param name nombre del elemento.
     * @param value valor del elemento.
     * @param childs lista de hijos.
     */
    public static XmlElement createElement(String name, String value, List<XmlElement> childs) {
        XmlElement xmlElement = new XmlElement();
        xmlElement.setName(name);
        xmlElement.setValue(value);
        if (childs != null) {
            xmlElement.setChilds(childs);
        }

        return xmlElement;
    }


    public static Object xmlToSObject (String xml, Type apexType) {
        String jsonString = COM_XmlToJson_cls.parseDocumentToJson(xml);
        System.debug('jsonString-->' + jsonString);
        Object obj = JSON.deserialize(jsonString,apexType);
        return  obj;
    }

    /**
     * Metodo encaragado de cargar todos los elementos recursivamente.
     * param elements los elememtos.
     */
    public void loadXmlElements(List<XmlElement> elements) {
        for (XmlElement element: elements) {
            xmlOut +='<' + element.getName() + '>';
            if (element.getValue() != null) {
                xmlOut += element.getValue();
                xmlOut +='</' + element.getName() + '>';
            }
            else if(!element.getChilds().isEmpty()) {
                loadXmlElements(element.getChilds());
                xmlOut +='</' + element.getName() + '>';
            }
            else {
                xmlOut +='</' + element.getName() + '>';
            }
        }
    }

    /**
     * CLase que define un elemento xml.
     */
    public class XmlElement {
        /** Nombre del elemento.**/
        private String name;
        /** Valor del elemento.**/
        private String value;
        /** Elementos hijos.**/
        private List<XmlElement> childs = new List<XmlElement>();

        /**
	     * Getter del atributo name.
	     *
	     * @return el atributo name.
	    */
        public String getName() {
            return name;
        }

        /**
         * Setter del atributo name.
         *
         * @param name el atributo name a establecer.
         */
        public void setName(String name) {
            this.name = name;
        }

        /**
         * Getter del atributo value.
         *
         * @return el atributo value.
         */
        public String getValue() {
            return value;
        }

        /**
         * Setter del atributo value.
         *
         * @param value el atributo value a establecer.
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Getter del atributo childs.
         *
         * @return el atributo childs.
         */
        public List<XmlElement> getChilds() {
            return childs;
        }

        /**
         * Setter del atributo childs.
         *
         * @param childs el atributo childs a establecer.
         */
        public void setChilds(List<XmlElement> childs) {
            this.childs = childs;
        }

        /**
         * Metodo encargado de adicionar un hijo al xml.
         * @param child el hijo que desea adicionar.
         */
        public void addChild(XmlElement child) {
            childs.add(child);
        }

    }

     /**
     * CLase que define un documento xml.
     */
    public class XmlDocument {
        /** Nombre del elemento.**/
        private String name;
       /** Elementos hijos.**/
        private List<XmlElement> childs = new List<XmlElement>();

        /**
         * Getter del atributo childs.
         *
         * @return el atributo childs.
         */
        public List<XmlElement> getChilds() {
            return childs;
        }

        /**
         * Setter del atributo childs.
         *
         * @param childs el atributo childs a establecer.
         */
        public void setChilds(List<XmlElement> childs) {
            this.childs = childs;
        }

        /**
	     * Getter del atributo name.
	     *
	     * @return el atributo name.
	    */
        public String getName() {
            return name;
        }

        /**
         * Setter del atributo name.
         *
         * @param name el atributo name a establecer.
         */
        public void setName(String name) {
            this.name = name;
        }

        /**
         * Metodo encargado de adicionar un hijo al xml.
         * @param child el hijo que desea adicionar.
         */
        public void addChild(XmlElement child) {
            childs.add(child);
        }


    }

}