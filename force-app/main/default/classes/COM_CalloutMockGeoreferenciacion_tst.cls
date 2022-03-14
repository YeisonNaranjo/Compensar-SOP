@isTest
global class COM_CalloutMockGeoreferenciacion_tst implements HttpCalloutMock{
	
	global HttpResponse respond(HTTPRequest req){
	    HttpResponse res = new HttpResponse();
	    res.setStatus('OK');
	    res.setStatusCode(200);
	    res.setBody('{"Georeferencia_Response": { "Header":{"System": { "RequestDate": "2017-07-12T14:00:02.334-05:00", "ResponseDate": "2017-07-12T14:00:03.864-05:00", "ResponseCode": "0", "ResponseDesc": "OK", "TransactionID": "GEO-099" }}, "Body": { "DireccionEstandarizada": "CL 129 # 58 - 61", "Barrio": "LAS VILLAS", "Localidad": "SUBA" } }}');
	    return res;
	}
    
}