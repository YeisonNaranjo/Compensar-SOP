/***************************************************************************************************************
* Avanxo 
* @author           Daniel Alejandro López
* Proyecto:         CRM Compensar
* Descripción:      Clase que consume el servicio de Consultar Requisitos en el sistema Aldea de Compensar.
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    22/08/2017      Daniel Alejandro López Monsalve     Creación de la clase
****************************************************************************************************************/

public class COM_ConsultarRequisitosAldea_ws {
	
	public COM_ConsultarRequisitosAldea_ws() {

    }
    
    public static COM_WrapperConsultaRequisitoResponse_cls consultarRequisitos(Account accCliente, List<String> listaRequisitos) {
    	
    	COM_WrapperConsultaRequisitosRequest_cls.ConsultaRequisitos_Request requestConsultarRequisitos = new COM_WrapperConsultaRequisitosRequest_cls.ConsultaRequisitos_Request();
    	requestConsultarRequisitos.Header = COM_UtilidadWebService_cls.obtenerCabecera(Label.COM_WS_ConsultarRequisitosAldea);
    	COM_WrapperConsultaRequisitosRequest_cls.Body reqBody = new COM_WrapperConsultaRequisitosRequest_cls.Body();
    	reqBody.TipoIdAfiliado = accCliente.COM_TipoIdentificacion__c;
    	reqBody.NumeroIdAfiliado = accCliente.COM_Numero_de_identificacion__c;
    	system.debug('========>>>> listaRequisitos: ' + listaRequisitos);
    	reqBody.Requisitos = COM_ConsultarRequisitosAldea_ws.obtenerListaRequisitos(listaRequisitos);
    	requestConsultarRequisitos.Body = reqBody;
    	
    	COM_WrapperConsultaRequisitosRequest_cls wrpRequest = new COM_WrapperConsultaRequisitosRequest_cls();
    	wrpRequest.ConsultaRequisitos_Request = requestConsultarRequisitos; 
    	    	
    	COM_WrapperConsultaRequisitoResponse_cls wrpResponse;
    	
    	try {
    		
    	    wrpResponse = (COM_WrapperConsultaRequisitoResponse_cls) COM_UtilidadWebService_cls.consumirWS(wrpRequest, Label.COM_WS_ConsultarRequisitosAldea, COM_WrapperConsultaRequisitoResponse_cls.class, accCliente.Id);    	      	    	
            system.debug('========>>>> wrpResponse: ' + wrpResponse);
    	}
    	catch (Exception e) {
            System.debug('Error ========>'+e.getMessage());
        }
    	
     	return wrpResponse;
    	
    }

    private static COM_WrapperConsultaRequisitosRequest_cls.Requisitos obtenerListaRequisitos(List<String> listaRequisitos){
        COM_WrapperConsultaRequisitosRequest_cls.Requisitos requisitos = new COM_WrapperConsultaRequisitosRequest_cls.Requisitos();
        List <COM_WrapperConsultaRequisitosRequest_cls.Requisito> listRequisitos = new List <COM_WrapperConsultaRequisitosRequest_cls.Requisito>();
        for(String strReq : listaRequisitos)
        {
            COM_WrapperConsultaRequisitosRequest_cls.Requisito requisito = new COM_WrapperConsultaRequisitosRequest_cls.Requisito();
            requisito.Tipo = strReq;
            listRequisitos.add(requisito);        
        }
        requisitos.Requisito = listRequisitos;
        return requisitos;
    }
    
}