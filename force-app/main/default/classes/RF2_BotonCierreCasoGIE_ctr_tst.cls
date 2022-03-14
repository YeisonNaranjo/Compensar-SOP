@isTest
private class RF2_BotonCierreCasoGIE_ctr_tst {
    
    @isTest static void test_method_1() {
        Test.startTest();
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        Case caso = COM_DataGenerator_cls.crearCaso(true, acc.Id, con.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    @isTest static void test_method_2() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        Case caso = COM_DataGenerator_cls.crearCaso(true, acc.Id, con.Id);
        caso.Status = 'Cerrado';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_TipoCierre__c = 'Exitoso';
        caso.RF2_Cantidad_de_registros__c = 1;
        RF2_Case_cls.stopTrigger();
        update caso;
        RF2_Case_cls.startTrigger();
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    @isTest static void test_method_3() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        Case caso = COM_DataGenerator_cls.crearCaso(true, acc.Id, con.Id);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_TipoCierre__c = 'Exitoso';
        caso.RF2_EsGIE__c = true;
        caso.RF2_Cantidad_de_registros__c = 1;
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        
        RF2_Case_cls.stopTrigger();
        update caso;
        RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    @isTest static void test_method_4() {
        //Account acc = COM_DataGenerator_cls.crearCuenta(true);
        //Contact con = COM_DataGenerator_cls.crearContacto(true, acc.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        Case caso = COM_DataGenerator_cls.crearCaso(false, null, null);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_EsGIE__c = true;
        COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
        caso.RF2_CiudadHuerfano__c = pob.Id;
        caso.RF2_CompanyaHuerfano__c = 'company';
        caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
        caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
        caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
        caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
        caso.RF2_TelefonoHuerfano__c = '323333232';
        caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
        caso.RF2_TipoIdentificacionHuerfano__c = '1';
        caso.RF2_CorreoElectronicoRespuesta__c = 'jsuarez@avanxo.com';
        caso.RF2_TipoCierre__c = 'Exitoso';
        caso.RF2_Cantidad_de_registros__c = 1;
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        RF2_Case_cls.stopTrigger();
        insert caso;
        RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    
    @isTest static void test_method_5() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.insertarAccAnonima(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, acc.Id);
        con.COM_TipoIdentificacion__c = '1';
        con.COM_Numeroidentificacion__c = '9999'; 
        insert con;
        Case caso = COM_DataGenerator_cls.crearCaso(false, acc.Id, con.Id);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_EsGIE__c = true;
        caso.RF2_Anonimo__c = true;
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        
        //RF2_Case_cls.stopTrigger();
        insert caso;
        //RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.objCaso = caso;
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    @isTest static void test_method_6() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.insertarAccAnonima(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, acc.Id);
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        con.COM_TipoIdentificacion__c = '1';
        con.COM_Numeroidentificacion__c = '9999'; 
        insert con;
        Case caso = COM_DataGenerator_cls.crearCaso(false, null, null);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_EsGIE__c = true;
        //caso.RF2_Anonimo__c = true;
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        
        COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
        caso.RF2_CiudadHuerfano__c = pob.Id;
        caso.RF2_CompanyaHuerfano__c = 'company';
        caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
        caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
        caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
        caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
        caso.RF2_TelefonoHuerfano__c = '323333232';
        caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
        caso.RF2_TipoIdentificacionHuerfano__c = '1';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        
        //RF2_Case_cls.stopTrigger();
        insert caso;
        //RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.objCaso = caso;
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    @isTest static void test_method_7() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, acc.Id);
        //con.COM_TipoIdentificacion__c = '1';
        //con.COM_Numeroidentificacion__c = '9999'; 
        insert con;
        Case caso = COM_DataGenerator_cls.crearCaso(false, null, con.Id);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_EsGIE__c = true;
        //caso.RF2_Anonimo__c = true;
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        
        COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
        caso.RF2_CiudadHuerfano__c = pob.Id;
        caso.RF2_CompanyaHuerfano__c = 'company';
        caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
        caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
        caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
        caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
        caso.RF2_TelefonoHuerfano__c = '323333232';
        caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
        caso.RF2_TipoIdentificacionHuerfano__c = '1';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        
        //RF2_Case_cls.stopTrigger();
        insert caso;
        //RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.objCaso = caso;
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    @isTest static void test_method_8() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, acc.Id);
        //con.COM_TipoIdentificacion__c = '1';
        //con.COM_Numeroidentificacion__c = '9999'; 
        insert con;
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        Case caso = COM_DataGenerator_cls.crearCaso(false, acc.Id, null);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_EsGIE__c = true;
        //caso.RF2_Anonimo__c = true;
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        
        COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
        caso.RF2_CiudadHuerfano__c = pob.Id;
        caso.RF2_CompanyaHuerfano__c = 'company';
        caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
        caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
        caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
        caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
        caso.RF2_TelefonoHuerfano__c = '323333232';
        caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
        caso.RF2_TipoIdentificacionHuerfano__c = '1';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
        
        //RF2_Case_cls.stopTrigger();
        insert caso;
        //RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.objCaso = caso;
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }
    
    
    @isTest static void test_method_9() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = Label.COM_NombreEncuestaSondeoGIE_lbl;
        insert plantillaTestGIE;
        
        AVX_ENC_PlantillaEncuesta__c plantillaTestPCE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestPCE.Name = Label.COM_NombreEncuestaSondeoPCE_lbl;
        insert plantillaTestPCE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest2 = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest2.Pregunta__c = 'prueba2';
        preguntaTest2.Name = 'prueba2';
        preguntaTest2.Tipo_pregunta__c = 'Texto';
        preguntaTest2.Plantilla_encuesta__c = plantillaTestPCE.id;
        insert preguntaTest2;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        plantillaTestPCE.Activo__c = true;
        update plantillaTestPCE;
        
        Account acc = COM_DataGenerator_cls.crearCuenta(true);
        Contact con = COM_DataGenerator_cls.crearContacto(false, acc.Id);
        acc.COM_CorreoElectronico__c ='jsuarez@avanxo.com';
        update acc;
        //con.COM_TipoIdentificacion__c = '1';
        //con.COM_Numeroidentificacion__c = '9999'; 
        insert con;
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'afterUpdate');
        COM_TriggerExecutionControl_cls.setAlreadyDone('RF2_Case_tgr', 'beforeUpdate');
        Case caso = COM_DataGenerator_cls.crearCaso(false, acc.Id, null);
        caso.Status = 'Pendiente PDF Respuesta Cierre';
        caso.RF2_ComentarioCierre__c = 'todo bien';
        caso.RF2_MedioRespuesta__c = 'Correo Electronico';
        caso.RF2_EsGIE__c = true;
        //caso.RF2_Anonimo__c = true;
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';
        caso.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        caso.RF2_TipoSolicitud__c = 'Solicitud GIE';
        
        COM_Poblacion__c pob = COM_DataGenerator_cls.crearPoblacion(true);
        caso.RF2_CorreoElectronicoHuerfano__c = 'jsuarez@avanxo.com';
        caso.RF2_NombreContactoHuerfano__c = 'j rubencho';
        caso.RF2_CiudadHuerfano__c = pob.Id;
        caso.RF2_CompanyaHuerfano__c = 'company';
        caso.RF2_DireccionHuerfano__c = 'calle 1 # 2 - 3';
        caso.RF2_NombreContactoHuerfano__c = 'huerfanito';
        caso.RF2_NumeroIdentificacionContactoHuerfano__c = '1234567';
        caso.RF2_NumeroIdentificacionHuerfano__c  = '1234567';
        caso.RF2_TelefonoHuerfano__c = '323333232';
        caso.RF2_TelefonoMovilHuerfano__c = '2132132132';
        caso.RF2_TipoIdentificacionHuerfano__c = '1';
        caso.RF2_CorreoElectronicoRespuesta__c = 'pruebas@compensar.com';
       
        //RF2_Case_cls.stopTrigger();
        insert caso;
        //RF2_Case_cls.startTrigger();
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, caso.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(caso);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        
        app.objCaso = caso;
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        app.verPdf();
        Test.stopTest();
    }
    
    
    
    @isTest(SeeAllData=true)
    static void test_method_10() {
        AVX_ENC_PlantillaEncuesta__c plantillaTestGIE = new AVX_ENC_PlantillaEncuesta__c();
        plantillaTestGIE.Name = 'Encuesta Sondeo GIE2';
        insert plantillaTestGIE;
        
        AVX_ENC_PreguntaEncuesta__c preguntaTest = 	new AVX_ENC_PreguntaEncuesta__c();
        preguntaTest.Pregunta__c = 'prueba';
        preguntaTest.Name = 'prueba';
        preguntaTest.Tipo_pregunta__c = 'Texto';
        preguntaTest.Plantilla_encuesta__c = plantillaTestGIE.id;
        insert preguntaTest;
        
        plantillaTestGIE.Activo__c = true;
        update plantillaTestGIE;
        
        Account accTest = new Account();
        accTest.Name = 'prueba1';
        accTest.COM_Numero_de_identificacion__c = '001';
        insert accTest;
        
        Contact conTest = new Contact();
        conTest.FirstName = 'prueba';
        conTest.LastName = 'uno';
        conTest.AccountId = accTest.id;
        insert conTest;
        
        Case testCaseGIE = new Case();
        testCaseGIE.RF2_EsPCE__c = false;
        testCaseGIE.RF2_EsGIE__c = true;
        testCaseGIE.RF2_MedioRespuesta__c = 'Correo Electronico';
        testCaseGIE.Origin = 'Chat';
        testCaseGIE.RF2_ProcesoDestinoMatrizResponsable__c = 'CRM GIE';	
        testCaseGIE.RF2_RelacionadoCon__c = 'Aclaraciones empleadores';
        testCaseGIE.RF2_TipoSolicitud__c = 'Solicitud GIE';
        testCaseGIE.Description = 'prueba dos';
        testCaseGIE.RF2_CorreoElectronicoRespuesta__c = 'jsparra@avanxo.com';
        testCaseGIE.AccountId = accTest.id;
        testCaseGIE.RF2_FechaVencimientoCaso__c = System.Today() + 3;
        testCaseGIE.ContactId = conTest.id;
        testCaseGIE.RF2_Colaborador__c = 'Yo ayude a solucionar';
        
        insert testCaseGIE;
        
        testCaseGIE.RF2_Cantidad_de_registros__c = 1;
        testCaseGIE.status= 'Solucionado';
        
        
        Attachment att1 = COM_DataGenerator_cls.creaAdjunto(true, testCaseGIE.Id);
        Attachment att2 = COM_DataGenerator_cls.creaAdjunto(true, testCaseGIE.Id);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(testCaseGIE);
        RF2_BotonCierreCasoGIE_ctr app = new RF2_BotonCierreCasoGIE_ctr(controller);
        app.objCaso = testCaseGIE;
        app.enviarPDF();
        app.valorTipoDoc = ''; 
        app.mensajeTransaccion = '';
        app.lightning  = true;
        app.salesforce1 = false;
        Test.stopTest();
    }    
}