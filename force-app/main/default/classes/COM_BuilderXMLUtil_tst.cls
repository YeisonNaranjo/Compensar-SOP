/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compoensar
* Description:		Clase encargada de ejecutar  las pruebas de la clase COM_BuilderXMLUtil_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_BuilderXMLUtil_tst {

    /** Instancia de utileria de xml.**/
    private static COM_BuilderXMLUtil_cls builderXMLUtil_cls = new COM_BuilderXMLUtil_cls();

    /**
     * Metodo encargado de probar la funcionalidad del metodo COM_BuilderXMLUtil_cls.builtXml().
     */
    @istest
    public static void testBuilt() {

        COM_BuilderXMLUtil_cls.XmlElement elements = new COM_BuilderXMLUtil_cls.XmlElement();
        elements.setName('nombre');
        elements.setValue('prueba');
        List<COM_BuilderXMLUtil_cls.XmlElement> childs = new List<COM_BuilderXMLUtil_cls.XmlElement>();
        childs.add(elements); 
        childs.add(elements); 
        childs.add(elements); 

        COM_BuilderXMLUtil_cls.XmlDocument document = new COM_BuilderXMLUtil_cls.XmlDocument();
        document.setName('Afiliado');
        document.addChild(COM_BuilderXMLUtil_cls.createElement
                ('Identificacion', '1128057876', null));
        document.addChild(COM_BuilderXMLUtil_cls.createElement
                ('TipoIdentificacion', 'CC', null));
        document.addChild(COM_BuilderXMLUtil_cls.createElement
                ('Programa', 'Sistemas', childs));
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

    }

     @istest
    public static void testTwo() {

        COM_BuilderXMLUtil_cls.xmlToSObject ('<prueba />', Type.forName('Account'));
    }

        @istest
    public static void test3() {
          COM_BuilderXMLUtil_cls.XmlElement elements = new COM_BuilderXMLUtil_cls.XmlElement();
        elements.setName('nombre');
        elements.setValue('prueba');
        List<COM_BuilderXMLUtil_cls.XmlElement> childs = new List<COM_BuilderXMLUtil_cls.XmlElement>();
        childs.add(elements); 
        childs.add(elements); 
        childs.add(elements); 

        COM_BuilderXMLUtil_cls.XmlDocument document = new COM_BuilderXMLUtil_cls.XmlDocument();
        document.setChilds(childs);
    }
}