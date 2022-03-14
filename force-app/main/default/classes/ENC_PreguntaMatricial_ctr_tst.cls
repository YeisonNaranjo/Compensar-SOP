@isTest
private class ENC_PreguntaMatricial_ctr_tst {
	
	@isTest static void test_method_1() {
		AVX_ENC_PlantillaEncuesta__c pl = COM_DataGenerator_cls.generarPlantillaAlone(true); 


		ENC_PreguntaMatricial_ctr ppp = new ENC_PreguntaMatricial_ctr();


		AVX_ENC_PreguntaEncuesta__c preg =  COM_DataGenerator_cls.preguntaEncuesta(true, pl.id);
		AVX_ENC_PreguntaEncuesta__c preg2 = COM_DataGenerator_cls.preguntaEncuesta(true, pl.id);
		pl.Activo__c = true;
		update pl;
		ppp.preguntaInterna = new ENC_PreguntaInterna_cls(0, 0, '',  preg);
		ppp.preguntaInterna.pregunta = preg;
		ppp.preguntaInterna.pregunta.Pregunta_dependiente__c = preg2.id;
		ppp.preguntaInterna.pregunta.Valor_dependiente__c = 'val1;val2;val3';
		map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls> mmmm = new map<Integer,ENC_PreguntaInterna_cls.ENC_RespuestaPregunta_cls>();		
		ppp.preguntaInterna.mapRespuestaXPregunta = mmmm;
		


		AVX_ENC_Encuesta__c encc = COM_DataGenerator_cls.generarEncuesta(true, pl.id);

		
        //account.COM_TipoIdentificacion__c = '3';
        //account.COM_Numero_de_identificacion__c = '28868463';
        ApexPages.StandardController controller = new ApexPages.StandardController(encc);
        ppp.ctr = new ENC_ResponderEncuesta_ctr(controller);
        System.debug(ppp.ctr);
        System.debug(ppp.preguntaInterna);
        ppp.getEstaGuardando();
        ppp.actualizarPregunta();
        ppp.blnMostrarPregunta = true;
        ppp.setStrRespuestas('1'+'\\|Õ\\|'+'2'+'\\|Õ\\|'+'3');
        ppp.getStrRespuestas();

        System.debug(ppp.blnMostrarPregunta);
        //map<String,Integer> mapy = new map<String,Integer>();
        //mapy.put(preg.id, 1);
        //ppp.ctr.mapIndiceXId = mapy;


        


    }

    @isTest static void test_method_2() {
    	ENC_PreguntaMatricial_ctr.infoOpcion xxx = new ENC_PreguntaMatricial_ctr.infoOpcion('', '0', true, 0 );
    	list<ENC_PreguntaMatricial_ctr.infoOpcion> lstop =  new list<ENC_PreguntaMatricial_ctr.infoOpcion>();
    	lstop.add(xxx);
    	ENC_PreguntaMatricial_ctr.infoPregunta yyy = new ENC_PreguntaMatricial_ctr.infoPregunta('', '0', lstop);
    	yyy.getOpcion(0);
    	yyy.getOpcion(1);
    	ENC_PreguntaMatricial_ctr ppp1 = new ENC_PreguntaMatricial_ctr();
    	ppp1.getEstaGuardando();

    	AVX_ENC_PlantillaEncuesta__c pl = COM_DataGenerator_cls.generarPlantillaAlone(true); 
    	AVX_ENC_PreguntaEncuesta__c preg =  COM_DataGenerator_cls.preguntaEncuesta(true, pl.id);
    	AVX_ENC_PreguntaEncuesta__c preg2 = COM_DataGenerator_cls.preguntaEncuesta(true, pl.id);
    	ppp1.preguntaInterna = new ENC_PreguntaInterna_cls(0, 0, '',  preg);
    	ppp1.preguntaInterna.pregunta = preg;
    	ppp1.preguntaInterna.pregunta.Pregunta_dependiente__c = preg2.id;

    	List<ENC_PreguntaMatricial_ctr.infoPregunta> lTemp = new List<ENC_PreguntaMatricial_ctr.infoPregunta>();
    	lTemp.add(new ENC_PreguntaMatricial_ctr.infoPregunta('', '0', lstop));
    	lTemp.add(new ENC_PreguntaMatricial_ctr.infoPregunta('', '0', lstop));
    	ppp1.setLstPreguntas(lTemp);

    	ppp1.getLstPreguntas();

    	ppp1.getStrRespuestas();
    	ppp1.getNumPreguntas();


    	
    }


}