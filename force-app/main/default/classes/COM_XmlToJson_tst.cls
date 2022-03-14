/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de ejecutar las pruebas unitarias de la clase COM_XmlToJson
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_XmlToJson_tst {

    /** Instancia de utileria de xml.**/
    private static COM_BuilderXMLUtil_cls builderXMLUtil_cls = new COM_BuilderXMLUtil_cls();


    /**
     * Metodo encargado de parsear el documento xml a objeto
     */
    @istest
    public static void testParseDocumentToObject() {
        COM_XmlToJson_cls xmlToJson = new COM_XmlToJson_cls();
        COM_BuilderXMLUtil_cls.XmlDocument document = new COM_BuilderXMLUtil_cls.XmlDocument();
        document.setName('Afiliado');
        document.addChild(COM_BuilderXMLUtil_cls.createElement
                ('Identificacion', '1128057876', null));
        document.addChild(COM_BuilderXMLUtil_cls.createElement
                ('TipoIdentificacion', 'CC', null));
        document.addChild(COM_BuilderXMLUtil_cls.createElement
                ('Programa', 'Sistemas', null));
        COM_BuilderXMLUtil_cls.XmlElement elementTblNemonico =
                COM_BuilderXMLUtil_cls.createElement('tblNemonico', null, null);
        elementTblNemonico.addChild(COM_BuilderXMLUtil_cls.createElement
                ('valor', 'SIS', null));
        document.addChild(elementTblNemonico);
        String value = builderXMLUtil_cls.builtXml(document);

        System.assert(value.contains('1128057876'));
        System.assert(value.contains('CC'));
        System.assert(value.contains('Sistemas'));
        System.assert(value.contains('SIS'));
        system.debug(value);
        COM_Afiliado_tst afiliado =  (COM_Afiliado_tst) COM_XmlToJson_cls.parseDocumentToObject
                                                                (value, COM_Afiliado_tst.class);
        System.assertEquals('1128057876', afiliado.getIdentificacion());
        System.assertEquals('CC', afiliado.getTipoIdentificacion());
        System.assertEquals('Sistemas', afiliado.getPrograma());
        System.assertEquals('SIS', afiliado.getTblNemonico().getValor());

        xmlToJson.xmlText = '{}';
        xmlToJson.getJsonText(); 

    }

    /**
     * Clase para probar la conversion a objeto.
     */
    public class COM_Afiliado_tst {

        private String TipoIdentificacion;

        private String Identificacion;

        private TblNemonico tblNemonico;

        private String Programa;

        public String getTipoIdentificacion ()
        {
            return TipoIdentificacion;
        }

        public void setTipoIdentificacion (String TipoIdentificacion)
        {
            this.TipoIdentificacion = TipoIdentificacion;
        }

        public String getIdentificacion ()
        {
            return Identificacion;
        }

        public void setIdentificacion (String Identificacion)
        {
            this.Identificacion = Identificacion;
        }

        public TblNemonico getTblNemonico ()
        {
            return tblNemonico;
        }

        public void setTblNemonico (TblNemonico tblNemonico)
        {
            this.tblNemonico = tblNemonico;
        }

        public String getPrograma ()
        {
            return Programa;
        }

        public void setPrograma (String Programa)
        {
            this.Programa = Programa;
        }

    }

    /**
     * Clase para definir atributos de nemonico
     */
    public class TblNemonico
    {
        private String valor;

        public String getValor ()
        {
            return valor;
        }

        public void setValor (String valor)
        {
            this.valor = valor;
        }

    }



}