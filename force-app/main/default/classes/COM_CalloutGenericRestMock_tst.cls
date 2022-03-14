/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Compensar
* Description:		Clase encargada de definir un mock generico para servicios rest.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		10/08/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
global class COM_CalloutGenericRestMock_tst implements HttpCalloutMock {
    /** La respuesta del servicio.**/
    private String response;
    /** El codigo de respuesta. **/
    private Integer responseCode;
    /** El estado de la peticion. **/
    private String status;

    /**
     * Constructor de la clase.
     */
    global  COM_CalloutGenericRestMock_tst(String response, Integer responseCode, String status) {
        this.response = response;
        this.responseCode = responseCode;
        this.status = status;
    }

    /**
     * @see HttpCalloutMock.respond(HTTPRequest).
     */
    global HttpResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatus(status);
        res.setStatusCode(responseCode);
        res.setBody(response);
        return res;
    }
}