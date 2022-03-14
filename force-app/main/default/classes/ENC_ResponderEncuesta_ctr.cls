public class ENC_ResponderEncuesta_ctr
{
    /* ATRIBUTOS PRIVADOS */
    private final Apexpages.Standardcontroller ctr;
    private final Boolean guardarInfo;
    private map<String,Integer> mapIndiceXId;
    private ENC_Query_int doQuery;

    /* ATRIBUTOS PUBLICOS */
    public AVX_ENC_PlantillaEncuesta__c encuesta {get; set; }
    public ENC_ResponderEncuesta_ctr elControl { get{ return this; } set; }
    public List<ENC_PreguntaInterna_cls> lstPreguntas {get; set; }
    public Boolean boolReadonly { get; set; }
    public Boolean boolPreguntas { get; set; }
    public Boolean boolEncuestaCerrada { get; set; }
    public Boolean blnGuardarEncuesta { get; set; }
    public Boolean blnGuardarTemporal { get; set; }
    
    public ENC_ResponderEncuesta_ctr( Apexpages.Standardcontroller controller )
    {
        ctr = controller;
        AVX_ENC_Encuesta__c rpe = (AVX_ENC_Encuesta__c)ctr.getRecord();
        mapIndiceXId = new map<String,Integer>();
        lstPreguntas = new List<ENC_PreguntaInterna_cls>();
        boolReadonly = false;
        boolPreguntas = true;
        boolEncuestaCerrada = true;
        blnGuardarEncuesta = false;
        blnGuardarTemporal = false;
        doQuery = new ENC_Query_imp();
        ID idPreguntaAbierta = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Abierta' ).getRecordTypeId();
        ID idPreguntaCerrada = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Cerrada' ).getRecordTypeId();
        ID idPreguntaMatricial = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Matricial' ).getRecordTypeId();

        RecordType rt1 = (RecordType)doQuery.getSObject( 'RecordType', 'Id, Name', 'sObjectType = \'AVX_ENC_Encuesta__c\' AND DeveloperName = \'Sin_contestar\'' );
        RecordType rt2 = (RecordType)doQuery.getSObject( 'RecordType', 'Id, Name', 'sObjectType = \'AVX_ENC_Encuesta__c\' AND DeveloperName = \'Pendiente_respuesta\'' );
        
        
        if( rpe.RecordTypeId != null && rpe.RecordTypeId != rt1.Id  && rpe.RecordTypeId != rt2.Id )
        {
            boolPreguntas = false;
            boolEncuestaCerrada = false;
        }

        try
        {
            String strIdEncuestaTemp = null;
            system.debug( '\n\n ****** ID Encuesta: ' + Apexpages.currentPage().getParameters().get( 'idEncuesta' ) );
            if( Apexpages.currentPage().getParameters().containsKey( 'idEncuesta' ) )
            {
                rpe.Plantilla_Encuesta__c = Apexpages.currentPage().getParameters().get( 'idEncuesta' );
                strIdEncuestaTemp = Apexpages.currentPage().getParameters().get( 'idEncuesta' );
                guardarInfo = false;
            }
            else if( Apexpages.currentPage().getParameters().containsKey( 'id' ) )
            {
                system.debug('\n\n ****** El param id es: ' + Apexpages.currentPage().getParameters().get( 'id' ));
                system.debug('\n\n ****** El param readonly es: ' + Apexpages.currentPage().getParameters().get( 'readonly' ));
                guardarInfo = true;
                blnGuardarEncuesta = true;
                strIdEncuestaTemp = rpe.Plantilla_encuesta__c;
                
                /*if( !rpe.Encuesta__r.Activo__c )
                    boolEncuestaCerrada = false;*/
                
            }
            
            String strFieldTemp = 'Name, Id, Numero_de_pregunta__c, RecordTypeId, RecordType.DeveloperName, Plantilla_encuesta__c, Opciones_de_respuesta__c, Pregunta__c, Pregunta_dependiente__c, Obligatorio__c, Tipo_pregunta__c, Orientacion__c, Valor_dependiente__c';
            strFieldTemp += ', ListaPreguntas__c, NumeroPreguntas__c';
            String strWhereTemp = 'Plantilla_encuesta__c = \'' + strIdEncuestaTemp + '\'';
            
            //Obtiene el listado de las preguntas de la encuesta
            List<AVX_ENC_PreguntaEncuesta__c> lstPreguntasTemp = (list<AVX_ENC_PreguntaEncuesta__c>)
                                                            doQuery.getListaSObject(    'AVX_ENC_PreguntaEncuesta__c', strFieldTemp, strWhereTemp, 
                                                                                        null, 'Numero_de_pregunta__c, CreatedDate' );
                                
            system.debug('\n\n ****** La lista de preguntas es: ' + lstPreguntasTemp);
            
            //Recorre las preguntas y asigna los valores de estas a cada uno de los campos correspondientes
            //for( Integer i = 1; i <= lstPreguntasTemp.size(); i++ )
            Integer i = 0;
            for( AVX_ENC_PreguntaEncuesta__c p : lstPreguntasTemp )
            {
                //AVX_ENC_PreguntaEncuesta__c p = lstPreguntasTemp.get( i - 1 );
                ENC_PreguntaInterna_cls pInterna;
                //Funcionalidad para preguntas matriciales
                if( p.RecordTypeId == idPreguntaMatricial ){
                    map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls> mapRespuestas = new map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls>();
                    list<String> lstPregs = p.ListaPreguntas__c != null ? p.ListaPreguntas__c.split( '\\{!Õ}' ) : new list<String>();
                    system.debug( 'NUM PREGUNTAS: ' + p.NumeroPreguntas__c );
                    for( Integer numSubPregunta = 0; numSubPregunta < p.NumeroPreguntas__c; numSubPregunta++ ){
                        i++;
                        String strPregunta = lstPregs.get( numSubPregunta );
                        //Carga la información que haya en la BD.
                        Integer intResp = Integer.valueOf( (Decimal)rpe.get( 'Valor_respuesta_p' + i + '__c' ) );
                        String strResp = (String)rpe.get( 'Respuesta_p' + i + '__c' );


                        ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls resp = new ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls( i, numSubPregunta, intResp, strResp );
                        resp.strPreguntaAbreviada = strPregunta;
                        resp.strPreguntacompleta = p.Name;
                        mapRespuestas.put( numSubPregunta, resp );
                        
                        //if( numSubPregunta < lstPreguntasTemp.size() - 1 )
                        //  i++;
                    }

                    pInterna = new ENC_PreguntaInterna_cls( i, mapRespuestas, p );
                    system.debug('\n\n ****** La pInterna M es: ' + pInterna );
                }
                else{
                    i++;
                    //Carga la información que haya en la BD.
                    Integer intResp = Integer.valueOf( (Decimal)rpe.get( 'Valor_respuesta_p' + i + '__c' ) );
                    String strResp = (String)rpe.get( 'Respuesta_p' + i + '__c' );
                    pInterna = new ENC_PreguntaInterna_cls( i, intResp, strResp, p );
                }
                lstPreguntas.add( pInterna );
                mapIndiceXId.put( p.Id, lstPreguntas.size() - 1 );
                system.debug('\n\n ****** La lstPreguntasM es: ' + lstPreguntas);
                system.debug('\n\n ****** La mapIndiceXId es: ' + mapIndiceXId);
            }
            
            encuesta = (AVX_ENC_PlantillaEncuesta__c)doQuery.getSObject( 'AVX_ENC_PlantillaEncuesta__c', 'Guardar_temporalmente__c, Encabezado__c, Pie_pagina__c, Cierre_encuesta__c, Encuesta_cerrada__c', 'Id = \'' + strIdEncuestaTemp + '\'' );
            
            system.debug('\n\n ****** La encuesta es: ' + encuesta);
        }
        catch( System.exception e )
        {
            system.debug('\n\n ****** El error fue: ' + e.getMessage());
        }
    }
    
    public PageReference guardarTemporal()
    {
        blnGuardarTemporal = true;
        return null;
    }
    
    public PageReference guardar()
    {
        PageReference pr = null;
        blnGuardarEncuesta = true;
        AVX_ENC_Encuesta__c rpe = (AVX_ENC_Encuesta__c)ctr.getRecord();
        ID idPreguntaMatricial = Schema.SObjectType.AVX_ENC_PreguntaEncuesta__c .getRecordTypeInfosByName().get( 'Matricial' ).getRecordTypeId();

        if( validarErrores() )
        {
            system.savepoint sp = Database.setSavepoint();
            try
            {
                if( guardarInfo )
                {
                    for( ENC_PreguntaInterna_cls pInterna : lstPreguntas )
                    {
                        System.debug('Pregunta Interna...  ' + pInterna );
                        //Funcionalidad para preguntas matriciales
                        if( pInterna.pregunta.RecordTypeId == idPreguntaMatricial ){
                            system.debug( 'MAPA: ' + pInterna.mapRespuestaXPregunta );
                            for( ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls respuesta : pInterna.mapRespuestaXPregunta.values() ){
                                system.debug( 'MAPA22: ' + respuesta  );
                                String strPreguntaAjustada = respuesta.strPreguntaCompleta.length() >= 255 ? respuesta.strPreguntaCompleta.subString( 0, 255 ) : respuesta.strPreguntaCompleta;
                                system.debug( 'MAPA23: ' + strPreguntaAjustada );
                                rpe.put( 'Valor_respuesta_p' + respuesta.numPregunta + '__c', respuesta.intRespuesta );
                                rpe.put( 'Respuesta_p' + respuesta.numPregunta + '__c', respuesta.strRespuesta );
                                rpe.put( 'Pregunta_abreviada_p' + respuesta.numPregunta + '__c', respuesta.strPreguntaAbreviada );
                                rpe.put( 'Pregunta_p' + respuesta.numPregunta + '__c', strPreguntaAjustada );
                                system.debug( 'MAPA23rpe: ' + rpe);
                            }
                        }
                        else{
                            String strPreguntaAjustada = pInterna.pregunta.Name.length() >= 255 ? pInterna.pregunta.Name.subString( 0, 255 ) : pInterna.pregunta.Name;
                            rpe.put( 'Valor_respuesta_p' + pInterna.numPregunta + '__c', pInterna.intRespuesta );
                            rpe.put( 'Respuesta_p' + pInterna.numPregunta + '__c', pInterna.strRespuesta );
                            rpe.put( 'Pregunta_abreviada_p' + pInterna.numPregunta + '__c', pInterna.pregunta.Name );
                            rpe.put( 'Pregunta_p' + pInterna.numPregunta + '__c', strPreguntaAjustada );
                        }
                    }
                    
                    String strRTDeveloperName = blnGuardarTemporal ? 'Pendiente_respuesta' : 'Contestada';
                    RecordType rtEncuesta = (RecordType)doQuery.getSObject( 'RecordType', 'Id, Name', 'sObjectType = \'AVX_ENC_Encuesta__c\' AND DeveloperName = \'' + strRTDeveloperName + '\'' );
                    rpe.RecordTypeId = rtEncuesta.Id;
                    rpe.Fecha_Respuesta_Encuesta__c = system.now();
                    update rpe;
                }
                
                if( !blnGuardarTemporal )
                {
                    boolPreguntas = false;
                    boolEncuestaCerrada = true;
                }
                else
                {
                    blnGuardarTemporal = false;
                }
            }
            catch( system.exception e )
            {
                Database.rollback( sp );
                Apexpages.Message pMessage = new Apexpages.Message( Apexpages.Severity.ERROR, 'Ha ocurrido un problema guardando la encuesta. ' + e.getMessage() );
                Apexpages.addMessage( pMessage );
            }
        }
        return pr;
    }
    
    public String darRespuestas( String idPregunta )
    {
        //OJO: Pendiente que retorne las respuestas solo con el ID de la pregunta y el map viene con el número también.
        String resp = '';
        system.debug( 'MAPA23idPregunta : ' + idPregunta );
        system.debug( 'MAPA23imapIndiceXId : ' + mapIndiceXId.GET(idPregunta ));
        if( mapIndiceXId.containsKey( idPregunta ) )
            resp = lstPreguntas.get( mapIndiceXId.get( idPregunta ) ).strRespuesta;
        system.debug( 'MAPA23resp : ' + resp );
        return resp;
    }
    
    /* metodos privados */
    private Boolean validarErrores()
    {
        for( ENC_PreguntaInterna_cls pInterna : lstPreguntas )
        {
            if( pInterna.blnMostrarError )
                return false;
        }
        
        return true;
    }
}