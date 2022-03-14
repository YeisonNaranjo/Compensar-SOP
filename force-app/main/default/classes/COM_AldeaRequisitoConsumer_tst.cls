/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de ejecutar las pruebas unitarias de la clase
*					COM_AldeaRequisitoConsumer_cls.
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@istest
public class COM_AldeaRequisitoConsumer_tst {

    /** Instancia del consumidor del servicio.**/
    private static COM_AldeaRequisitoConsumer_cls aldeaRequisitoConsumer =
                                                new COM_AldeaRequisitoConsumer_cls();

    /**
     * Metodo encargado de realizar la prueba de consumir el servicio.
     */
    @istest
    public static void testConsumirServicio() {
        Test.startTest();
        COM_AldeaRequisitoConsumer_cls.COM_RequestAldeaDTO_cls aldeaDTO_cls =
                    new COM_AldeaRequisitoConsumer_cls.COM_RequestAldeaDTO_cls();
        aldeaDTO_cls.setIdentificacion('1128057876');
        aldeaDTO_cls.setTipoIdentificacion('CC');
        aldeaDTO_cls.setPrograma('Sistemas');
        aldeaDTO_cls.setIdentificacion('SIS');
        COM_AldeaRequisitoResponse_cls response =
                aldeaRequisitoConsumer.consumirServicio(aldeaDTO_cls);

        /* Todo Validar respuesta esperada. */
        aldeaDTO_cls.setValor('valor');

        Test.stopTest();
    }


}