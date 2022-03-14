/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Manuel Mendez (MM)
Proyecto:          Compensar
Descripción:       Crontoller para sumisnitrar campos lupa a componente LookupGIE
Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     30/10/19         Manuel Mendez  (MM)                    Creación Clase.
*************************************************************************************************/
global with sharing class CEL1_LookupCustom_ctr {
    @AuraEnabled
    public static WrapperLookup lupasTipificacionGIE(String strIdCaso)
    {
        System.debug('ENTRO POR lupasTipificacionGIE');
        System.debug('strIdCaso--->>>'+strIdCaso);

        // String strQuery = 'SELECT Id';
        List<CEL1_ConfiguracionLupas__mdt> lstTipidicacionGIE = [SELECT Id,
                                                                CEL1_CampoCaso__c,
                                                                CEL1_CampoFiltro__c,
                                                                CEL1_Nombre__c,
                                                                CEL1_Objeto__c,
                                                                CEL1_ObjetoPadre__c,
                                                                CEL1_OrdenNumero__c,
                                                                CEL1_Tipificacion__c,
                                                                CEL1_Tipo__c,
                                                                MGLT_Disabled__c,
                                                                MDTL_CampoRelacion__c,
                                                                MGLT_Complementofiltro__c
                                                                FROM CEL1_ConfiguracionLupas__mdt
                                                                WHERE CEL1_Tipificacion__c = 'Tipificación GIE'
                                                                ORDER BY CEL1_OrdenNumero__c];
        System.debug('lstTipidicacionGIE--->>>'+lstTipidicacionGIE);
        Map<String,Object> mapSobject = new Map<String,Object>();
        Map<String,String> mapPicklist = new Map<String,String>();
        String strField     = 'Id';
        String strObject    = 'Case';
        String strWhere     = 'Id ='+'\''+ strIdCaso +'\'';

        for (CEL1_ConfiguracionLupas__mdt objMDT2: lstTipidicacionGIE) {
            System.debug('objMDT2.MDTL_CampoRelacion__c......'+objMDT2.MDTL_CampoRelacion__c);
            System.debug('objMDT2.CEL1_Tipo__c......'+objMDT2.CEL1_Tipo__c);
            if (objMDT2.CEL1_Tipo__c=='Lupa') {
                if (objMDT2.MDTL_CampoRelacion__c != null) {
                    strField += ','+ objMDT2.MDTL_CampoRelacion__c+ '.Id,'+ objMDT2.MDTL_CampoRelacion__c + '.Name';
                }
            }else{
                strField += ','+ objMDT2.CEL1_CampoCaso__c;
            }
        }
        String strQuery = 'SELECT '+strField+ ' FROM '+ strObject + ' WHERE ' + strWhere;
        System.debug('strQuery--->>>'+strQuery);
        List<Case> lstCase = Database.query(strQuery);
        System.debug('objCase--->>>'+lstCase);

        for (CEL1_ConfiguracionLupas__mdt objMDT3: lstTipidicacionGIE) {
            if(!lstCase.isEmpty()){
                if(objMDT3.MDTL_CampoRelacion__c != null){
                    Object sobj = lstCase.get(0).getSObject(objMDT3.MDTL_CampoRelacion__c);
                    mapSobject.put(objMDT3.CEL1_Objeto__c,sobj);
                }else {
                    System.debug('objCase.get(objMDT3.CEL1_CampoCaso__c)---->>>'+lstCase.get(0).get(objMDT3.CEL1_CampoCaso__c));
                    String valorList = String.valueOf(lstCase.get(0).get(objMDT3.CEL1_CampoCaso__c));
                    System.debug('objMDT3.CEL1_CampoCaso__c---->>>'+objMDT3.CEL1_CampoCaso__c);
                    mapPicklist.put(objMDT3.CEL1_CampoCaso__c,valorList);
                }
            }else {
                mapSobject.put(objMDT3.CEL1_Objeto__c,null);
            }
        }
        System.debug('mapSobject--->>>'+mapSobject);
        WrapperLookup objWrapper = new WrapperLookup();
        WrapperTipificacionGIE objWrapperGIE;
        List<WrapperTipificacionGIE> lstWrapper = new List<WrapperTipificacionGIE>();
        if(!lstTipidicacionGIE.isEmpty()){
            for (CEL1_ConfiguracionLupas__mdt objMDT: lstTipidicacionGIE) {
                objWrapperGIE = new WrapperTipificacionGIE();
                // strQuery += ','+objMDT.CEL1_CampoCaso__c;
                if (objMDT.CEL1_Tipo__c == 'Lista de selección') {
                    System.debug('ENTRO PORQUE TIENE Lista de selecccion--->>>>');
                    System.debug('objMDT.CEL1_CampoCaso__c--->>>>'+objMDT.CEL1_CampoCaso__c);
                    System.debug('objWrapperGIE.lstValoresPiscklist-ANTES-->>>>'+objWrapperGIE.lstValoresPiscklist);
                    objWrapperGIE.lstValoresPiscklist = getPicklistValues(new Case(),objMDT.CEL1_CampoCaso__c,true);
                    objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                    System.debug('objWrapperGIE.lstValoresPiscklist--->>>>'+objWrapperGIE.lstValoresPiscklist);
                }else {
                    if(objMDT.CEL1_Tipo__c == 'Lupa'){
                        if(mapSobject.get(objMDT.CEL1_Objeto__c) != null){
                            String str = JSON.serialize(mapSobject.get(objMDT.CEL1_Objeto__c));   
                            Map<String, Object> m =  (Map<String, Object>) JSON.deserializeUntyped(str);
                            objWrapperGIE.strValorLupa = String.valueOf(m.get('Id'));
                        }
                    }else {
                        objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                    }

                }
                System.debug('objWrapperGIE.strCampoCaso----->>>>'+objWrapperGIE.strCampoCaso);
                objWrapperGIE.strCampoCaso = objMDT.CEL1_CampoCaso__c;
                objWrapperGIE.strCampoFiltro = objMDT.CEL1_CampoFiltro__c;
                objWrapperGIE.strNombre = objMDT.CEL1_Nombre__c;
                objWrapperGIE.strObjeto = objMDT.CEL1_Objeto__c;
                objWrapperGIE.strObjetoPadre = objMDT.CEL1_ObjetoPadre__c;
                objWrapperGIE.strOrden = String.valueOf(objMDT.CEL1_OrdenNumero__c);
                objWrapperGIE.strTipificacion = objMDT.CEL1_Tipificacion__c;
                objWrapperGIE.strTipo = objMDT.CEL1_Tipo__c;
                objWrapperGIE.strId = objMDT.Id;
                // objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                // objWrapperGIE.strValorLupa = '';
                objWrapperGIE.strFiltro = '';
                objWrapperGIE.blnBuscar = false;
                objWrapperGIE.blnValorMenu = false;
                objWrapperGIE.strComplementoFiltro = objMDT.MGLT_Complementofiltro__c;
                System.debug('mapSobject.get(objMDT.CEL1_Objeto__c)--->>>'+mapSobject.get(objMDT.CEL1_Objeto__c));
                objWrapperGIE.objSoBject   =  mapSobject.get(objMDT.CEL1_Objeto__c) != null ?mapSobject.get(objMDT.CEL1_Objeto__c):'';
                objWrapperGIE.blnDisabled = objMDT.MGLT_Disabled__c;
                lstWrapper.add(objWrapperGIE);
                System.debug('lstWrapper----FOR>>>'+lstWrapper);
            }
            System.debug('lstWrapper---->>>>'+lstWrapper);

            objWrapper.lstTipificacionGIE = lstWrapper;
            return objWrapper;
        }else {
            return null;
        }
    }

    @AuraEnabled
    public static WrapperLookup lupasTipificacionPCA(String strIdCaso)
    {
        System.debug('ENTRO POR lupasTipificacionGIE');
        System.debug('strIdCaso--->>>'+strIdCaso);

        List<CEL1_ConfiguracionLupas__mdt> lstTipidicacionGIE = [SELECT Id,
                                                                CEL1_CampoCaso__c,
                                                                CEL1_CampoFiltro__c,
                                                                CEL1_Nombre__c,
                                                                CEL1_Objeto__c,
                                                                CEL1_ObjetoPadre__c,
                                                                CEL1_OrdenNumero__c,
                                                                CEL1_Tipificacion__c,
                                                                CEL1_Tipo__c,
                                                                MGLT_Disabled__c,
                                                                MDTL_CampoRelacion__c,
                                                                MGLT_Complementofiltro__c
                                                                FROM CEL1_ConfiguracionLupas__mdt
                                                                WHERE CEL1_Tipificacion__c = 'Tipificación PCA'
                                                                ORDER BY CEL1_OrdenNumero__c ASC];
        System.debug('lstTipidicacionGIE--->>>'+lstTipidicacionGIE);

        Map<String,Object> mapSobject = new Map<String,Object>();
        Map<String,String> mapPicklist = new Map<String,String>();
        String strField     = 'Id';
        String strObject    = 'Case';
        String strWhere     = 'Id ='+'\''+ strIdCaso +'\'';

        for (CEL1_ConfiguracionLupas__mdt objMDT2: lstTipidicacionGIE) {
            if (objMDT2.CEL1_Tipo__c=='Lupa') {
                if(objMDT2.MDTL_CampoRelacion__c != null){
                    strField += ','+ objMDT2.MDTL_CampoRelacion__c+ '.Id,'+ objMDT2.MDTL_CampoRelacion__c + '.Name';
                }
            }else{
                strField += ','+ objMDT2.CEL1_CampoCaso__c;
            }
        }
        String strQuery = 'SELECT '+strField+ ' FROM '+ strObject + ' WHERE ' + strWhere;
        System.debug('strQuery--->>>'+strQuery);
        List<Case> lstCase = Database.query(strQuery);
        System.debug('objCase--->>>'+lstCase);

        for (CEL1_ConfiguracionLupas__mdt objMDT3: lstTipidicacionGIE) {
            if(!lstCase.isEmpty()){
                if(objMDT3.MDTL_CampoRelacion__c != null){
                    System.debug('ENTRO IF DE objMDT3.MDTL_CampoRelacion__c.....');
                    Object sobj = lstCase.get(0).getSObject(objMDT3.MDTL_CampoRelacion__c);
                    System.debug('sobj.....'+sobj);
                    mapSobject.put(objMDT3.CEL1_Objeto__c,sobj);
                }else {
                    System.debug('objCase.get(objMDT3.CEL1_CampoCaso__c)---->>>'+lstCase.get(0).get(objMDT3.CEL1_CampoCaso__c));
                    String valorList = String.valueOf(lstCase.get(0).get(objMDT3.CEL1_CampoCaso__c));
                    System.debug('objMDT3.CEL1_CampoCaso__c---->>>'+objMDT3.CEL1_CampoCaso__c);
                    mapPicklist.put(objMDT3.CEL1_CampoCaso__c,valorList);
                }
            }
        }
        System.debug('mapSobject---->>>'+mapSobject);

        WrapperLookup objWrapper = new WrapperLookup();
        WrapperTipificacionGIE objWrapperGIE;
        List<WrapperTipificacionGIE> lstWrapper = new List<WrapperTipificacionGIE>();
        if(!lstTipidicacionGIE.isEmpty()){
            for (CEL1_ConfiguracionLupas__mdt objMDT: lstTipidicacionGIE) {
                objWrapperGIE = new WrapperTipificacionGIE();
                if (objMDT.CEL1_Tipo__c == 'Lista de selección') {
                    System.debug('ENTRO PORQUE TIENE Lista de selecccion--->>>>');
                    System.debug('objMDT.CEL1_CampoCaso__c--->>>>'+objMDT.CEL1_CampoCaso__c);
                    System.debug('objWrapperGIE.lstValoresPiscklist-ANTES-->>>>'+objWrapperGIE.lstValoresPiscklist);
                    objWrapperGIE.lstValoresPiscklist = getPicklistValues(new Case(),objMDT.CEL1_CampoCaso__c,true);
                    objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                    System.debug('objWrapperGIE.lstValoresPiscklist--->>>>'+objWrapperGIE.lstValoresPiscklist);
                }else {
                    if(objMDT.CEL1_Tipo__c == 'Lupa'){
                        if(mapSobject.get(objMDT.CEL1_Objeto__c) != null){
                            String str = JSON.serialize(mapSobject.get(objMDT.CEL1_Objeto__c));   
                            Map<String, Object> m =  (Map<String, Object>) JSON.deserializeUntyped(str);
                            objWrapperGIE.strValorLupa = String.valueOf(m.get('Id'));
                        }
                    }else {
                        objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                    }

                }
                System.debug('objWrapperGIE.strCampoCaso----->>>>'+objWrapperGIE.strCampoCaso);
                objWrapperGIE.strCampoCaso = objMDT.CEL1_CampoCaso__c;
                objWrapperGIE.strCampoFiltro = objMDT.CEL1_CampoFiltro__c;
                objWrapperGIE.strNombre = objMDT.CEL1_Nombre__c;
                objWrapperGIE.strObjeto = objMDT.CEL1_Objeto__c;
                objWrapperGIE.strObjetoPadre = objMDT.CEL1_ObjetoPadre__c;
                objWrapperGIE.strOrden = String.valueOf(objMDT.CEL1_OrdenNumero__c);
                objWrapperGIE.strTipificacion = objMDT.CEL1_Tipificacion__c;
                objWrapperGIE.strTipo = objMDT.CEL1_Tipo__c;
                // objWrapperGIE.strValorLupa = '';
                objWrapperGIE.strFiltro = '';
                objWrapperGIE.blnValorMenu = false;
                objWrapperGIE.strCampoMenu  =   '';
                objWrapperGIE.strComplementoFiltro = objMDT.MGLT_Complementofiltro__c;
                objWrapperGIE.blnBuscar = false;
                objWrapperGIE.objSoBject   =  mapSobject.get(objMDT.CEL1_Objeto__c) != null ?mapSobject.get(objMDT.CEL1_Objeto__c):'';
                objWrapperGIE.blnDisabled = objMDT.MGLT_Disabled__c;
                lstWrapper.add(objWrapperGIE);
                System.debug('lstWrapper----FOR>>>'+lstWrapper);
            }
            System.debug('lstWrapper---->>>>'+lstWrapper);
            objWrapper.lstTipificacionGIE = lstWrapper;
            return objWrapper;
        }else {
            return null;
        }
    }

    @AuraEnabled
    public static WrapperLookup lupasTipificacionGC(String strIdCaso)
    {
        System.debug('ENTRO POR lupasTipificacionGC');

        List<CEL1_ConfiguracionLupas__mdt> lstTipidicacionGIE = [SELECT Id,
                                                                CEL1_CampoCaso__c,
                                                                CEL1_CampoFiltro__c,
                                                                CEL1_Nombre__c,
                                                                CEL1_Objeto__c,
                                                                CEL1_ObjetoPadre__c,
                                                                CEL1_OrdenNumero__c,
                                                                CEL1_Tipificacion__c,
                                                                CEL1_Tipo__c,
                                                                MGLT_Disabled__c,
                                                                MDTL_CampoRelacion__c,
                                                                MGLT_Complementofiltro__c
                                                                FROM CEL1_ConfiguracionLupas__mdt
                                                                WHERE CEL1_Tipificacion__c = 'Tipificación CE'
                                                                ORDER BY CEL1_OrdenNumero__c ASC];
        System.debug('lstTipidicacionGC--->>>'+lstTipidicacionGIE);
        System.debug('strIdCaso--->>>'+strIdCaso);

        Map<String,Object> mapSobject = new Map<String,Object>();
        Map<String,String> mapPicklist = new Map<String,String>();
        String strField     = 'Id';
        String strObject    = 'Case';
        String strWhere     = 'Id ='+'\''+ strIdCaso +'\'';

        for (CEL1_ConfiguracionLupas__mdt objMDT2: lstTipidicacionGIE) {
            if (objMDT2.CEL1_Tipo__c=='Lupa') {
                if(objMDT2.MDTL_CampoRelacion__c != null){
                    strField += ','+ objMDT2.MDTL_CampoRelacion__c+ '.Id,'+ objMDT2.MDTL_CampoRelacion__c + '.Name';
                }
            }else{
                strField += ','+ objMDT2.CEL1_CampoCaso__c;
            }
        }
        String strQuery = 'SELECT '+strField+ ' FROM '+ strObject + ' WHERE ' + strWhere;
        System.debug('strQuery--->>>'+strQuery);
        List<Case> lstCase = Database.query(strQuery);
        System.debug('objCase--->>>'+lstCase);

        for (CEL1_ConfiguracionLupas__mdt objMDT3: lstTipidicacionGIE) {
            if(!lstCase.isEmpty()){
                if(objMDT3.MDTL_CampoRelacion__c != null){
                    Object sobj = lstCase.get(0).getSObject(objMDT3.MDTL_CampoRelacion__c);
                    mapSobject.put(objMDT3.CEL1_Objeto__c,sobj);
                }else {
                    System.debug('objCase.get(objMDT3.CEL1_CampoCaso__c)---->>>'+lstCase.get(0).get(objMDT3.CEL1_CampoCaso__c));
                    String valorList = String.valueOf(lstCase.get(0).get(objMDT3.CEL1_CampoCaso__c));
                    System.debug('objMDT3.CEL1_CampoCaso__c---->>>'+objMDT3.CEL1_CampoCaso__c);
                    mapPicklist.put(objMDT3.CEL1_CampoCaso__c,valorList);
                }
            }else {
                mapSobject.put(objMDT3.CEL1_Objeto__c,null);
            }
        }
        System.debug('mapSobject---->>>'+mapSobject);
        System.debug('mapSobject---->>>'+mapSobject);

        WrapperLookup objWrapper = new WrapperLookup();
        WrapperTipificacionGIE objWrapperGIE;
        List<WrapperTipificacionGIE> lstWrapper = new List<WrapperTipificacionGIE>();
        if(!lstTipidicacionGIE.isEmpty()){
            for (CEL1_ConfiguracionLupas__mdt objMDT: lstTipidicacionGIE) {
                objWrapperGIE = new WrapperTipificacionGIE();
                if (objMDT.CEL1_Tipo__c == 'Lista de selección') {
                    System.debug('ENTRO PORQUE TIENE Lista de selecccion--->>>>');
                    System.debug('objMDT.CEL1_CampoCaso__c--->>>>'+objMDT.CEL1_CampoCaso__c);
                    System.debug('objWrapperGIE.lstValoresPiscklist-ANTES-->>>>'+objWrapperGIE.lstValoresPiscklist);
                    // objWrapperGIE.lstValoresPiscklist = getPicklistValues(new Case(),objMDT.CEL1_CampoCaso__c,true);
                    objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                    System.debug('objWrapperGIE.lstValoresPiscklist--->>>>'+objWrapperGIE.lstValoresPiscklist);
                }else {
                    if(objMDT.CEL1_Tipo__c == 'Lupa'){
                        if(mapSobject.get(objMDT.CEL1_Objeto__c) != null){
                            String str = JSON.serialize(mapSobject.get(objMDT.CEL1_Objeto__c));   
                            Map<String, Object> m =  (Map<String, Object>) JSON.deserializeUntyped(str);
                            objWrapperGIE.strValorLupa = String.valueOf(m.get('Id'));
                        }
                    }else {
                        objWrapperGIE.strValorLupa = mapPicklist.get(objMDT.CEL1_CampoCaso__c);
                    }

                }
                System.debug('objWrapperGIE.strCampoCaso----->>>>'+objWrapperGIE.strCampoCaso);
                objWrapperGIE.strCampoCaso = objMDT.CEL1_CampoCaso__c;
                objWrapperGIE.strCampoFiltro = objMDT.CEL1_CampoFiltro__c;
                objWrapperGIE.strNombre = objMDT.CEL1_Nombre__c;
                objWrapperGIE.strObjeto = objMDT.CEL1_Objeto__c;
                objWrapperGIE.strObjetoPadre = objMDT.CEL1_ObjetoPadre__c;
                objWrapperGIE.strOrden = String.valueOf(objMDT.CEL1_OrdenNumero__c);
                objWrapperGIE.strTipificacion = objMDT.CEL1_Tipificacion__c;
                objWrapperGIE.strTipo = objMDT.CEL1_Tipo__c;
                // objWrapperGIE.strValorLupa = '';
                objWrapperGIE.strFiltro = '';
                objWrapperGIE.strComplementoFiltro = objMDT.MGLT_Complementofiltro__c;
                objWrapperGIE.blnBuscar = false;
                objWrapperGIE.objSoBject   =  mapSobject.get(objMDT.CEL1_Objeto__c) != null ?mapSobject.get(objMDT.CEL1_Objeto__c):'';
                objWrapperGIE.blnDisabled = objMDT.MGLT_Disabled__c;
                lstWrapper.add(objWrapperGIE);
                System.debug('lstWrapper----FOR>>>'+lstWrapper);
            }
            System.debug('lstWrapper---->>>>'+lstWrapper);
            objWrapper.lstTipificacionGIE = lstWrapper;
            return objWrapper;
        }else {
            return null;
        }
    }

    public static list<String> getPicklistValues(sObject obj, String fld, Boolean doSort)
    {
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        list<String> lstSort = new list<String>();
        // Add these values to the sort list.
        for (Schema.PicklistEntry a : values)
            lstSort.add( a.getLabel() );

        if( doSort )
            lstSort.sort();

        return lstSort;
    }

    @AuraEnabled
    public static WrapperLookup guardarGIE(List<WrapperTipificacionGIE> lstValores, String strIdCaso){
        System.debug('ENTRO A GUARDAR GIE--->>>');
        System.debug('lstValores--->>>'+lstValores);
        System.debug('strIdCaso--->>>'+strIdCaso);

        List<CEL1_ConfiguracionLupas__mdt> lstTipidicacionGIE = [SELECT Id,
                                                                CEL1_CampoCaso__c,
                                                                CEL1_CampoFiltro__c,
                                                                CEL1_Nombre__c,
                                                                CEL1_Objeto__c,
                                                                CEL1_ObjetoPadre__c,
                                                                CEL1_OrdenNumero__c,
                                                                CEL1_Tipificacion__c,
                                                                CEL1_Tipo__c,
                                                                MGLT_Disabled__c,
                                                                MDTL_CampoRelacion__c,
                                                                MGLT_Complementofiltro__c
                                                                FROM CEL1_ConfiguracionLupas__mdt
                                                                WHERE CEL1_Tipificacion__c = 'Tipificación GIE'
                                                                ORDER BY CEL1_OrdenNumero__c];
        System.debug('lstTipidicacionGIE--->>>'+lstTipidicacionGIE);

        Map<String,Object> mapSobject = new Map<String,Object>();
        Map<String,String> mapPicklist = new Map<String,String>();
        String strField     = 'Subject';
        String strObject    = 'Case';
        String strWhere     = 'Id ='+'\''+ strIdCaso +'\'';

        for (CEL1_ConfiguracionLupas__mdt objMDT2: lstTipidicacionGIE) {
            strField += ','+ objMDT2.CEL1_CampoCaso__c;
        }
        String strQuery = 'SELECT '+strField+ ' FROM '+ strObject + ' WHERE ' + strWhere;
        System.debug('strQuery..guardar...'+strQuery);

        List<Case> lstCase = Database.query(strQuery);
        List<Case> lstCasoGuardar = new List<Case>();
        List<String> lstGuardarFINAL = new List<String>();
        Map<String,String> mapGuardar = new Map<String,String>();
        Map<String,String> mapCampo = new Map<String,String>();

        for(WrapperTipificacionGIE objWrapper : lstValores){
            mapGuardar.put(objWrapper.strCampoCaso,objWrapper.strValorLupa);
            mapCampo.put(objWrapper.strCampoCaso,objWrapper.strCampoCaso);
        }
        // Case objCasoGuardar = new Case();
        System.debug('lstValores ... tamaño...'+lstValores.size());
        System.debug('lstCase ... tamaño...'+lstCase.size());
        Integer intValor =0;
        Case objCase = new Case();
        // for(Case objCaseGuardar:lstCase){
            // intValor++;
        objCase.Id = strIdCaso;
        WrapperLookup objWrapperLookup = new WrapperLookup();
        for (WrapperTipificacionGIE objWrapper2 : lstValores) {
            System.debug('ENTRO A IF PORQUE LO CONTIENE....'+objWrapper2);
            System.debug('objWrapper2.strCampoCaso....'+objWrapper2.strCampoCaso);
            if(objWrapper2.strTipo == 'Fecha'){
                if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null){
                    objCase.put(mapCampo.get(objWrapper2.strCampoCaso),Date.valueOf(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))));
                }
            }else {
                if (objWrapper2.strTipo == 'Decimal') {
                    System.debug('mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))..DECIMAL..'+mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)));
                    if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null && mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != ''){
                        try{
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),Decimal.valueOf(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))));
                        }
                        catch(Exception e){
                            objWrapperLookup.strMensaje   =   'El campo Cantidad de registros debe ser numérico'+e.getMessage();
                            objWrapperLookup.blnRespuesta =   false;
                            return objWrapperLookup;
                        }
                    }else{
                        objCase.put(mapCampo.get(objWrapper2.strCampoCaso),null);
                    }
                }else {
                    objCase.put(mapCampo.get(objWrapper2.strCampoCaso),mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)));
                }
            }
            System.debug('objCase....'+objCase);
        }
        lstCasoGuardar.add(objCase);
        System.debug('lstCasoGuardar....'+lstCasoGuardar);
        System.debug('intValor....'+intValor);
        // WrapperLookup objWrapperLookup = new WrapperLookup();
        try {

            System.debug('lstCasoGuardar---->>>>'+lstCasoGuardar);
            update lstCasoGuardar;
            objWrapperLookup.strMensaje   =   'Se ha actualizado satisfactoriamente su registro';
            objWrapperLookup.blnRespuesta =   true;
        } catch (DmlException  e) {
            for (Integer i= 0; i < e.getNumDml(); i++) {
                System.debug('mensaje de error for...'+e.getDmlMessage(i));
                objWrapperLookup.strMensaje   =   e.getDmlMessage(i).unescapeHtml4();
                objWrapperLookup.blnRespuesta =   false;
            }
        }
        return objWrapperLookup;
    }

    @AuraEnabled
    public static WrapperLookup guardarPCA(List<WrapperTipificacionGIE> lstValores, String strIdCaso){
        System.debug('ENTRO A GUARDAR GIE--->>>');
        System.debug('lstValores--->>>'+lstValores);
        System.debug('strIdCaso--->>>'+strIdCaso);

        List<CEL1_ConfiguracionLupas__mdt> lstTipidicacionGIE = [SELECT Id,
                                                                CEL1_CampoCaso__c,
                                                                CEL1_CampoFiltro__c,
                                                                CEL1_Nombre__c,
                                                                CEL1_Objeto__c,
                                                                CEL1_ObjetoPadre__c,
                                                                CEL1_OrdenNumero__c,
                                                                CEL1_Tipificacion__c,
                                                                CEL1_Tipo__c,
                                                                MGLT_Disabled__c,
                                                                MDTL_CampoRelacion__c,
                                                                MGLT_Complementofiltro__c
                                                                FROM CEL1_ConfiguracionLupas__mdt
                                                                WHERE CEL1_Tipificacion__c = 'Tipificación PCA'
                                                                ORDER BY CEL1_OrdenNumero__c ASC];
        System.debug('lstTipidicacionGIE--->>>'+lstTipidicacionGIE);

        Map<String,Object> mapSobject = new Map<String,Object>();
        Map<String,String> mapPicklist = new Map<String,String>();
        String strField     = 'Subject';
        String strObject    = 'Case';
        String strWhere     = 'Id ='+'\''+ strIdCaso +'\'';

        for (CEL1_ConfiguracionLupas__mdt objMDT2: lstTipidicacionGIE) {
            strField += ','+ objMDT2.CEL1_CampoCaso__c;
        }
        String strQuery = 'SELECT '+strField+ ' FROM '+ strObject + ' WHERE ' + strWhere;
        System.debug('strQuery..guardar...'+strQuery);

        List<Case> lstCase = Database.query(strQuery);
        List<Case> lstCasoGuardar = new List<Case>();
        List<String> lstGuardarFINAL = new List<String>();
        Map<String,String> mapGuardar = new Map<String,String>();
        Map<String,String> mapCampo = new Map<String,String>();

        for(WrapperTipificacionGIE objWrapper : lstValores){
            mapGuardar.put(objWrapper.strCampoCaso,objWrapper.strValorLupa);
            mapCampo.put(objWrapper.strCampoCaso,objWrapper.strCampoCaso);
        }
        // Case objCasoGuardar = new Case();
        System.debug('lstValores ... tamaño...'+lstValores.size());
        System.debug('lstCase ... tamaño...'+lstCase.size());
        Integer intValor =0;
        Case objCase = new Case();
        // for(Case objCaseGuardar:lstCase){
            // intValor++;
        objCase.Id = strIdCaso;
        WrapperLookup objWrapperLookup = new WrapperLookup();
        for (WrapperTipificacionGIE objWrapper2 : lstValores) {
            System.debug('ENTRO A IF PORQUE LO CONTIENE....'+objWrapper2);
            System.debug('objWrapper2.strCampoCaso....'+objWrapper2.strCampoCaso);
            if(objWrapper2.strTipo == 'Fecha'){
                if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null){
                    objCase.put(mapCampo.get(objWrapper2.strCampoCaso),Date.valueOf(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))));
                }
            }else {
                if (objWrapper2.strTipo == 'Decimal') {
                    if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null && mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != ''){
                        try{
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),Decimal.valueOf(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))));
                        }
                        catch(Exception e){
                            objWrapperLookup.strMensaje   =   'El campo Afiliado relacionado debe ser numérico'+e.getMessage();
                            objWrapperLookup.blnRespuesta =   false;
                            return objWrapperLookup;
                        }
                    }
                }else {
                    objCase.put(mapCampo.get(objWrapper2.strCampoCaso),mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)));
                }
            }
            System.debug('objCase....'+objCase);
        }
        lstCasoGuardar.add(objCase);
        System.debug('lstCasoGuardar....'+lstCasoGuardar);
        System.debug('intValor....'+intValor);
        // WrapperLookup objWrapperLookup = new WrapperLookup();
        try {

            System.debug('lstCasoGuardar---->>>>'+lstCasoGuardar);
            update lstCasoGuardar;
            objWrapperLookup.strMensaje   =   'Se ha actualizado satisfactoriamente su registro';
            objWrapperLookup.blnRespuesta =   true;
        } catch (DmlException  e) {
            for (Integer i= 0; i < e.getNumDml(); i++) {
                System.debug('mensaje de error for...'+e.getDmlMessage(i));
                objWrapperLookup.strMensaje   =   e.getDmlMessage(i).unescapeHtml4();
                objWrapperLookup.blnRespuesta =   false;
            }
        }
        return objWrapperLookup;
    }

    @AuraEnabled
    public static WrapperLookup guardarGE(List<WrapperTipificacionGIE> lstValores, String strIdCaso){
        System.debug('ENTRO A GUARDAR GIE--->>>');
        System.debug('lstValores--->>>'+lstValores);
        System.debug('strIdCaso--->>>'+strIdCaso);

        List<CEL1_ConfiguracionLupas__mdt> lstTipidicacionGIE = [SELECT Id,
                                                                CEL1_CampoCaso__c,
                                                                CEL1_CampoFiltro__c,
                                                                CEL1_Nombre__c,
                                                                CEL1_Objeto__c,
                                                                CEL1_ObjetoPadre__c,
                                                                CEL1_OrdenNumero__c,
                                                                CEL1_Tipificacion__c,
                                                                CEL1_Tipo__c,
                                                                MGLT_Disabled__c,
                                                                MDTL_CampoRelacion__c,
                                                                MGLT_Complementofiltro__c
                                                                FROM CEL1_ConfiguracionLupas__mdt
                                                                WHERE CEL1_Tipificacion__c = 'Tipificación CE'
                                                                ORDER BY CEL1_OrdenNumero__c ASC];
        System.debug('lstTipidicacionGC--->>>'+lstTipidicacionGIE);
        // System.debug('strIdCaso--->>>'+strIdCaso);

        Map<String,Object> mapSobject = new Map<String,Object>();
        Map<String,String> mapPicklist = new Map<String,String>();
        String strField     = 'Subject';
        String strObject    = 'Case';
        String strWhere     = 'Id ='+'\''+ strIdCaso +'\'';

        for (CEL1_ConfiguracionLupas__mdt objMDT2: lstTipidicacionGIE) {
            strField += ','+ objMDT2.CEL1_CampoCaso__c;
        }
        String strQuery = 'SELECT '+strField+ ' FROM '+ strObject + ' WHERE ' + strWhere;
        System.debug('strQuery..guardar...'+strQuery);

        List<Case> lstCase = Database.query(strQuery);
        List<Case> lstCasoGuardar = new List<Case>();
        List<String> lstGuardarFINAL = new List<String>();
        Map<String,String> mapGuardar = new Map<String,String>();
        Map<String,String> mapCampo = new Map<String,String>();

        for(WrapperTipificacionGIE objWrapper : lstValores){
            System.debug('objWrapper.....'+objWrapper);
            System.debug('objWrapper.strValorLupa.....'+objWrapper.strValorLupa);
            mapGuardar.put(objWrapper.strCampoCaso,objWrapper.strValorLupa);
            mapCampo.put(objWrapper.strCampoCaso,objWrapper.strCampoCaso);
        }
        // Case objCasoGuardar = new Case();
        System.debug('lstValores ... tamaño...'+lstValores.size());
        System.debug('lstCase ... tamaño...'+lstCase.size());
        Integer intValor =0;
        Case objCase = new Case();
        // for(Case objCaseGuardar:lstCase){
            // intValor++;
        objCase.Id = strIdCaso;
        WrapperLookup objWrapperLookup = new WrapperLookup();
        for (WrapperTipificacionGIE objWrapper2 : lstValores) {
            System.debug('ENTRO A IF PORQUE LO CONTIENE....'+objWrapper2);
            System.debug('objWrapper2.strCampoCaso....'+objWrapper2.strCampoCaso);
            System.debug('objWrapper2.strTipo....'+objWrapper2.strTipo);
            if(objWrapper2.strTipo == 'Fecha'){
                if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null){
                    objCase.put(mapCampo.get(objWrapper2.strCampoCaso),Date.valueOf(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))));
                }else{
                    objCase.put(mapCampo.get(objWrapper2.strCampoCaso),null);
                }
            }else {
                if (objWrapper2.strTipo == 'Decimal') {
                    if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null && mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != ''){
                        try{
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),Decimal.valueOf(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))));
                        }
                        catch(Exception e){
                            objWrapperLookup.strMensaje   =   'El campo Afiliado relacionado debe ser numérico'+e.getMessage();
                            objWrapperLookup.blnRespuesta =   false;
                            return objWrapperLookup;
                        }
                    }else{
                        objCase.put(mapCampo.get(objWrapper2.strCampoCaso),null);
                    }
                }else {
                    if(objWrapper2.strTipo == 'Lupa'){
                        System.debug('ENTRO SOLO POR TUPO LUPA......');
                        System.debug('mapCampo.get(objWrapper2.strCampoCaso)......'+mapCampo.get(objWrapper2.strCampoCaso));
                        System.debug('mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso))......'+mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)));
                        if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != null){
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)));
                        }else {
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),null);
                        }

                    }else {
                        if(mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)) != ''){
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),mapGuardar.get(mapCampo.get(objWrapper2.strCampoCaso)));
                        }else {
                            objCase.put(mapCampo.get(objWrapper2.strCampoCaso),'');
                        }
                    }
                }
            }
            System.debug('objCase....'+objCase);
        }
        lstCasoGuardar.add(objCase);
        System.debug('lstCasoGuardar....'+lstCasoGuardar);
        System.debug('intValor....'+intValor);
        // WrapperLookup objWrapperLookup = new WrapperLookup();
        try {

            System.debug('lstCasoGuardar---->>>>'+lstCasoGuardar);
            update lstCasoGuardar;
            objWrapperLookup.strMensaje   =   'Se ha actualizado satisfactoriamente su registro';
            objWrapperLookup.blnRespuesta =   true;
        } catch (DmlException  e) {
            for (Integer i= 0; i < e.getNumDml(); i++) {
                System.debug('mensaje de error for...'+e.getDmlMessage(i));
                objWrapperLookup.strMensaje   =   e.getDmlMessage(i).unescapeHtml4();
                objWrapperLookup.blnRespuesta =   false;
            }
        }
        return objWrapperLookup;
    }

    global class WrapperLookup
    {
        @AuraEnabled global List<WrapperTipificacionGIE> lstTipificacionGIE {get;set;}
        @AuraEnabled global String strMensaje {get;set;}
        @AuraEnabled global Boolean blnRespuesta {get;set;}
    }


    global class WrapperTipificacionGIE
    {
        @AuraEnabled global String strCampoCaso {get;set;}
        @AuraEnabled global String strCampoFiltro {get;set;}
        @AuraEnabled global String strNombre {get;set;}
        @AuraEnabled global String strObjeto {get;set;}
        @AuraEnabled global String strObjetoPadre {get;set;}
        @AuraEnabled global String strOrden {get;set;}
        @AuraEnabled global String strTipificacion {get;set;}
        @AuraEnabled global String strTipo {get;set;}
        @AuraEnabled global String strValorLupa {get;set;}
        @AuraEnabled global String strFiltro {get;set;}
        @AuraEnabled global String strCampoMenu {get;set;}
        @AuraEnabled global String strComplementoFiltro {get;set;}
        @AuraEnabled global String strId {get;set;}
        @AuraEnabled global Boolean blnBuscar {get;set;}
        @AuraEnabled global Boolean blnValorMenu {get;set;}
        @AuraEnabled global Boolean blnDisabled {get;set;}
        @AuraEnabled global Object objSoBject {get;set;}
        @AuraEnabled global List<String> lstValoresPiscklist {get;set;}
        global WrapperTipificacionGIE(){
                lstValoresPiscklist = new List<String>();
        }
    }
}