public with sharing class COS_ConsultaGFyVinculacionesV2_ctr {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> obtenerGrupoFamiliar(String registroId){
        String Tipodoc = '';
        String NroDoc = '';
        // verifico si el Id que ingresa es una cuenta o un prospecto
        if(registroId.startsWith('001')){
            Account acc = [Select Id, COM_TipoIdentificacion__c, COM_Numero_de_identificacion__c FROM Account WHERE ID = : registroId LIMIT 1 ];
            Tipodoc = acc.COM_TipoIdentificacion__c;
            NroDoc = acc.COM_Numero_de_identificacion__c;
        }
        if(registroId.startsWith('00Q')){
            Lead leadInfo = [Select Id, CEL1_TipoDocumento__c, CEL1_NumeroDocumento__c, COS_Nit_empresa__c FROM Lead WHERE ID = : registroId LIMIT 1 ];
            Tipodoc = leadInfo.CEL1_TipoDocumento__c;
            NroDoc = leadInfo.CEL1_NumeroDocumento__c;
        }
        
        HttpRequest httpRequest = new HttpRequest();
        String NombreServicio = 'ConsultarGrupoFamiliar';
        String wsEndPoint = construirEndPoint (NombreServicio,NroDoc,Tipodoc);    
        
        httpRequest.setEndpoint(wsEndPoint);
        httpRequest.setMethod('GET');
        
        Map<String, Object> newsJsonData = new Map<String, Object>();
        String strResponse = null;
        String RespuestaHomologada = null;
        
        try{
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if(httpResponse.getStatusCode() == 200){
                strResponse = httpResponse.getBody();
            } else {
                throw new CalloutException(httpResponse.getBody());
            }
            
        } catch(Exception ex){
            throw ex;
        }
        
        if(!String.isBlank(strResponse)){
            
            RespuestaHomologada = parseJSONResponse(strResponse);
            newsJsonData = (Map<String, Object>)JSON.deserializeUntyped(RespuestaHomologada);
            return newsJsonData;
            
        } else {
            return null;
        }
        
    }
    
    
    public static String parseJSONResponse (String strResponse){
        
        //Map<String, Object> wsJsonData = newsJsonData;
        List<Object> GFObjectList = New List<Object>();
        List<Object> VincObjectList = New List<Object>();
        List<Object> EmpresaObjectList = New List<Object>();
        List<Object> ErrorObjectList = New List<Object>();
        String resultado = '';
        
        String numAux = '';
        String planAux = '';
        
        COS_ConsultaWSSaludWrapper responseWrapper = COS_ConsultaWSSaludWrapper.parse(strResponse);
        
        //COnsulta del grupo Familiar y homologacion de Tipo de Identificacion - Parentesco
        if (responseWrapper.ConsultarDatosVinculacionOut.GrupoFamiliar <> null){
            for(Integer i=0; i<responseWrapper.ConsultarDatosVinculacionOut.GrupoFamiliar.size(); i++) {
                
                COS_ConsultaWSSaludWrapper.GrupoFamiliar Gfamiliar = responseWrapper.ConsultarDatosVinculacionOut.GrupoFamiliar.get(i);
                Gfamiliar.Plan = homologacionPlan (Gfamiliar.Plan); 
                
                if (Gfamiliar.NumeroIdentificacion != numAux){
                    
                    numAux = Gfamiliar.NumeroIdentificacion;
                    planAux = Gfamiliar.Plan;
                    
                    Gfamiliar.TipoIdentificacion = homologacionTipoDocumento(Gfamiliar.TipoIdentificacion);
                    Gfamiliar.Parentesco = homologacionParentesco(Gfamiliar.Parentesco);
                    Gfamiliar.Genero = homologacionGenero(Gfamiliar.Genero);
                    
                    if (Gfamiliar.PlanVarios == null){
                        Gfamiliar.PlanVarios = '';
                    }
                    Gfamiliar.PlanVarios = Gfamiliar.Plan + ' ' + Gfamiliar.PlanVarios;
                    GFObjectList.add(Gfamiliar);
                    
                } else{
                    
                    COS_ConsultaWSSaludWrapper.GrupoFamiliar GfamiliarAux = responseWrapper.ConsultarDatosVinculacionOut.GrupoFamiliar.get(i - 1);
                    GfamiliarAux.PlanVarios = planAux + ' - ' + Gfamiliar.Plan;
                    
                }
                
            }
        }
        //-----------------------------------------------------------------------------------
        
        
        //Consulta de Vinculaciones
        string cadenaorig = '';
        string[] partes;
        string subcadena;
        if (responseWrapper.ConsultarDatosVinculacionOut.Vinculacion <> null){
            for(Integer i=0; i<responseWrapper.ConsultarDatosVinculacionOut.Vinculacion.size(); i++) {
                COS_ConsultaWSSaludWrapper.Vinculacion VinculacionList = responseWrapper.ConsultarDatosVinculacionOut.Vinculacion.get(i);
                
                cadenaorig = VinculacionList.ProgramaVinculacion;
                if (cadenaorig <> null){
                    partes = cadenaorig.Split(' ');
                	subcadena = partes[2];
                	VinculacionList.ProgramaVinculacion = subcadena;
                }
                
                VinculacionList.Estado = homologacionEstados(VinculacionList.Estado);
                
                VincObjectList.add(VinculacionList);
            }
        }
        //-----------------------------
        
        //Consulta de EMPRESA
        if (responseWrapper.ConsultarDatosVinculacionOut.Empresa <> null){
            for(Integer i=0; i<responseWrapper.ConsultarDatosVinculacionOut.Empresa.size(); i++) {
                COS_ConsultaWSSaludWrapper.Empresa EmpresaList = responseWrapper.ConsultarDatosVinculacionOut.Empresa.get(i);
                EmpresaObjectList.add(EmpresaList);
            }
        }
        //-------------------
        
        
        //Consulta Sin Informacion - Devuelvo el mensaje de error proveniente del WS
        if (responseWrapper.ConsultarDatosVinculacionOut.Errores <> null){
            for(Integer i=0; i<responseWrapper.ConsultarDatosVinculacionOut.Errores.size(); i++) {
                COS_ConsultaWSSaludWrapper.Errores ErrorMsj = responseWrapper.ConsultarDatosVinculacionOut.Errores.get(i);
                ErrorObjectList.add(ErrorMsj);
            }
            String strErrorJSON = JSON.serialize(ErrorObjectList);
            String JSONinicio = '{"ConsultarDatosVinculacionOut":';
            String respuestaJSONError = '{"Errores":' + strErrorJSON + '}';
            resultado = JSONinicio + respuestaJSONError + '}';
            return resultado;
        }
        //--------------------------------------------------------------------------
        
        String strGrupoFamiliarJSON = JSON.serialize(GFObjectList);
        String strVinculacionJSON = JSON.serialize(VincObjectList);
        String strEmpresaJSON = JSON.serialize(EmpresaObjectList);
        
        String JSONinicio = '{"ConsultarDatosVinculacionOut":';
        String respuestaJSONVin = '{"Vinculacion":' + strVinculacionJSON;
        String respuestaJSONGF = ',"GrupoFamiliar":' + strGrupoFamiliarJSON;
        String respuestaJSONEM = ',"Empresa":' + strEmpresaJSON + '}';
        resultado = JSONinicio + respuestaJSONVin + respuestaJSONGF + respuestaJSONEM + '}';
        
        
        //string RespuestaJSON = JSONinicio + respuestaJSONVin + respuestaJSONGF + respuestaJSONEM + respuestaJSONError + '}';
        
        return resultado;
    }
    
    
    
    public static String construirEndPoint (String strNombreServicio, String NroDoc, String Tipodoc){
        
        String strEndPoint;  
        COS_ConfiguracionWebServiceSalud__mdt objConfiguracionWebService;
        
        objConfiguracionWebService = [Select COS_Activo__c, COS_CodigoAplicacion__c, COS_DireccionIp__c, COS_Formato__c, COS_IdAfiliado__c, COS_Metodo__c, COS_Opcion__c,
                                      COS_Protocolo__c, COS_Puerto__c, COS_Recurso__c, COS_TimeOut__c, COS_TipoAfiliado__c From COS_ConfiguracionWebServiceSalud__mdt where Label =: strNombreServicio limit 1];
        
        
        if(!objConfiguracionWebService.COS_Activo__c){
            system.debug('El Web Service ' + strNombreServicio + ' se encuentra desactivado.');
            throw new COM_WSInactivoException('El Web Service ' + strNombreServicio + ' se encuentra desactivado.');
        }
        
        
        strEndPoint = '';
        strEndPoint += objConfiguracionWebService.COS_Protocolo__c + '://' + objConfiguracionWebService.COS_DireccionIp__c;
        strEndPoint += '/' + objConfiguracionWebService.COS_Recurso__c.removeStart('/').removeEnd('/');
        strEndPoint += objConfiguracionWebService.COS_CodigoAplicacion__c + objConfiguracionWebService.COS_IdAfiliado__c + NroDoc + objConfiguracionWebService.COS_TipoAfiliado__c + Tipodoc;
        strEndPoint += objConfiguracionWebService.COS_Opcion__c + objConfiguracionWebService.COS_Formato__c;
        
        return strEndPoint;
        
    }
    
    
    @AuraEnabled(cacheable=true)
    public static String homologacionTipoDocumento(String tipoDocumento){
        
        COS_Homologacion_tipo_documento__mdt objHomologacion;
        
        objHomologacion = [Select Label FROM COS_Homologacion_tipo_documento__mdt WHERE COS_Codigo_consorcio__c = :tipoDocumento];
        String respuesta = objHomologacion.Label;
        
        return respuesta;
    }
    
    @AuraEnabled(cacheable=true)
    public static String homologacionParentesco(String parentescoH){
        
        COS_ParentescosSalud__mdt objHomologacion;
        
        objHomologacion = [Select Label FROM COS_ParentescosSalud__mdt WHERE COS_Codigo_consorcio__c = :parentescoH];
        String respuesta = objHomologacion.Label;
        
        return respuesta;
    }
    
    @AuraEnabled(cacheable=true)
    public static String homologacionGenero(String genero){
        
        COS_Genero_Salud__mdt objHomologacion;
        
        objHomologacion = [Select Label FROM COS_Genero_Salud__mdt WHERE COS_Codigo_consorcio__c = :genero];
        String respuesta = objHomologacion.Label;
        
        return respuesta;
    }
    
     //Homologacion de estados
    @AuraEnabled(cacheable=true)
    public static String homologacionEstados(String estado){
        
        COS_Homologacion_Estados_Salud__mdt objHomologacion;
        
        objHomologacion = [Select Label FROM COS_Homologacion_Estados_Salud__mdt WHERE COS_Codigo_consorcio__c = :estado];
        String respuesta = objHomologacion.Label;
        
        return respuesta;
    }
    
    //Homologacion de planes
    @AuraEnabled(cacheable=true)
    public static String homologacionPlan(String plan){
        
        COS_Homologacion_tipo_plan__mdt objHomologacion;
        
        objHomologacion = [Select Label FROM COS_Homologacion_tipo_plan__mdt WHERE COS_Codigo_consorcio__c = :plan];
        String respuesta = objHomologacion.Label;
        
        return respuesta;
    }
    
}