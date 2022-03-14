/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Cristian David Mejia (CM)
Proyecto:          Compensar
Descripción:       Clase del Trigger COM_Opportunity_tgr donde se realizan los siguientes operaciones
- Validar y crear Cliente en GC

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
1.0     11/08/17            Cristian David Mejia (CM)           Creación Clase.
1.1     27/03/18            Stifen Panche (SP)                  Metas por fecha de facturación.
1.2		23/09/20			Yeison Naranjo (YN)					Ajuste actualización cuentas NOLA 00019935.
************************************************************************************************/
public without sharing class COM_Opportunity_cls 
{
    
    public static Boolean allow = true;
    public static Boolean test1 = true;
    
    public static void stopTrigger(){
        allow = false;
        test1 = false;
    }
    
    public static boolean canIRun(){
        test1 = false;
        return allow;
    }
    
    public static void startTrigger(){
        test1 = false;
        allow = false;
    }
    
    /* public void validacionClienteGC(Map<Id,Opportunity> mapOldRecords,Map<Id,Opportunity> mapNewRecords)
{
System.debug('mapOldRecords ===>>> \n'+mapOldRecords);
System.debug('mapNewRecords ===>>> \n'+mapNewRecords);

Map<Id,Set<Id>> mapAccountOpps = new Map<Id,Set<Id>>();

Set<Id> setOppId;
for(Id idOpp : mapNewRecords.keySet())
{
if(
mapNewRecords.get(idOpp).StageName == 'Reconfirmado' &&
(
mapOldRecords == null || 
mapOldRecords.get(idOpp).StageName != mapNewRecords.get(idOpp).StageName
)
)
{
setOppId = mapAccountOpps.get(mapNewRecords.get(idOpp).AccountId);
if(setOppId == null)
{
setOppId = new Set<Id>();
mapAccountOpps.put(mapNewRecords.get(idOpp).AccountId,setOppId);
}
setOppId.add(mapNewRecords.get(idOpp).AccountId);
}
}
System.debug('setOppId ===>>> \n'+setOppId);
Map<Id,Account> mapAcc = new Map<id,Account>([SELECT Id FROM Account WHERE Id IN: setOppId AND COM_NAUTCLI__c = null]);
System.debug('mapAcc ===>>> \n'+mapAcc);

if(!(system.isBatch() || system.isFuture())){
COM_Opportunity_cls.envioClientesGC(mapAcc.keySet());
}
}

@Future(callout=true)
public static void envioClientesGC(Set<Id> setAccountIds)
{
List<Account> lstAccount = new List<Account>();
List<Account> lstAccountMod = new List<Account>();
//Decimal decResponse;
boolean blnActualizar; 
COM_WrapperCrearClienteGCResponse_cls nautcli;

lstAccount = [SELECT Id, COM_No_procesado_On_Line__c, COM_NAUTCLI__c FROM Account WHERE Id IN :setAccountIds];

for(Account objAccount : lstAccount)
{
blnActualizar = false;
try
{
try{
nautcli = COM_CrearActualizarClienteGC_ws.CrearCliente(objAccount.Id, true, 1);

//Si la transaccion estaba marcada indicando que NO fue procesada Online
//Se desmarca para indicar que ya se proceso Online
if(objAccount.COM_No_procesado_On_Line__c){
objAccount.COM_No_procesado_On_Line__c = false;
blnActualizar = true;
} 
} catch (COM_WSInactivoException e) {
objAccount.COM_No_procesado_On_Line__c = true;
blnActualizar = true;
system.debug('EL WEB SERVICE PARA CREAR CLIENTES EN ONBASE SE ENCUENTRA DESACTIVADO');
} catch(Exception e){
throw e;
}

if(nautcli != null && nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente != null){
//objAccount.COM_NAUTCLI__c = decResponse;
objAccount.COM_NAUTCLI__c = nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente;
System.debug('decResponse ===>>> \n'+ nautcli.CustomerMng_CrearClienteResponse.Body.Cliente.IdCliente );
lstAccountMod.add(objAccount);
}  else {
System.debug('No se pudo actualizar el cliente');
if(blnActualizar){
lstAccountMod.add(objAccount);
}
}
} catch(Exception e) {
System.debug(e.getMessage());
}
}

if(!lstAccountMod.isEmpty()){
update lstAccount;
}
}*/
    
   
    
    public void calcularFechaPazYSalvo(List<Opportunity> lstNewRecords){
        BusinessHours horarioOficina = [SELECT Id FROM BusinessHours WHERE Name ='Default'];
        for(Opportunity oportunidad : lstNewRecords){
            if(oportunidad.COM_Fecharadicacioncartaretiro__c != null){
                Datetime dtFecha = datetime.newInstance(oportunidad.COM_Fecharadicacioncartaretiro__c.year(), oportunidad.COM_Fecharadicacioncartaretiro__c.month(),oportunidad.COM_Fecharadicacioncartaretiro__c.day());
                oportunidad.COM_Vencimiento60diashabiles__c = COM_Utilidades_cls.calcularFechaDiasHabiles(horarioOficina.Id, dtFecha, 60).date();
            }
        }
    }
    
    /*public void enviarFichaTecnica(Map<Id,Opportunity> mapOldRecords, List<Opportunity> lstNewRecords){

Map<Id, RecordType> mapTiposRegistro = new Map<Id, RecordType>([SELECT Id, DeveloperName FROM RecordType]);
Set<Id> setOportunidades = new Set<Id>();
system.debug('tipos de registro - '+mapTiposRegistro);
for(Opportunity oportunidad : lstNewRecords){
if(mapOldRecords.get(oportunidad.Id).StageName != 'Reconfirmado' && mapTiposRegistro.get(oportunidad.RecordTypeId).DeveloperName == 'COM_Alojamiento' && oportunidad.StageName == 'Reconfirmado'){
setOportunidades.add(oportunidad.Id);
}
}
if(setOportunidades.size()>0){
fichaTecnica(setOportunidades);
}
}   
public void enviarFichaTecnica(List<Opportunity> lstNewRecords){

Map<Id, RecordType> mapTiposRegistro = new Map<Id, RecordType>([SELECT Id, DeveloperName FROM RecordType]);
Set<Id> setOportunidades = new Set<Id>();
system.debug('tipos de registro - '+mapTiposRegistro);
for(Opportunity oportunidad : lstNewRecords){
if(mapTiposRegistro.get(oportunidad.RecordTypeId).DeveloperName == 'COM_Alojamiento' && oportunidad.StageName == 'Reconfirmado'){
setOportunidades.add(oportunidad.Id);
}
}
if(setOportunidades.size()>0){
fichaTecnica(setOportunidades);
}
}           

@Future(callout=true)
public static void fichaTecnica(Set<Id> setId){         
Map<Id, COM_Operador__c> mapOperadores = new Map<Id, COM_Operador__c>([SELECT Id, COM_CorreoElectronico__c FROM COM_Operador__c]);
String strAsunto = 'Ficha técnica';
String strCuerpoCorreo = 'has recibido una ficha técnica';
Set<String> setCorreos = new Set<String>(); 
List<Attachment> lstAdjuntos = new List<Attachment>();
Set<Id> setIdAdjuntos = new Set<Id>();
Map<Id, Id> mapAdjuntos = new Map<Id, Id>();
List<Opportunity> lstOportunidades = new List<Opportunity>([SELECT Id, Name, COM_Operador__c FROM Opportunity WHERE Id IN :setId]);
for(Opportunity oportunidad : lstOportunidades){
lstAdjuntos.add(adjuntarFichaTecnica(oportunidad.Id, oportunidad.Name));
}
System.debug('lstAdjuntos - '+lstAdjuntos);
if(lstAdjuntos.size()>0){
insert lstAdjuntos;
for(Attachment adjunto : lstAdjuntos){
mapAdjuntos.put(adjunto.ParentId, adjunto.Id);
}
}
for(Opportunity oportunidad : lstOportunidades){
setCorreos.clear();
setIdAdjuntos.clear();
setCorreos.add(mapOperadores.get(oportunidad.COM_Operador__c).COM_CorreoElectronico__c);
setIdAdjuntos.add(mapAdjuntos.get(oportunidad.Id));
COM_UtilidadCorreo_cls.enviarCorreoSimple(setCorreos, setIdAdjuntos, strAsunto, strCuerpoCorreo);
}
}

private static Attachment adjuntarFichaTecnica(String id, String nombre){

PageReference prfPDF = new PageReference('/apex/COM_PVE_CotizacionFichaTecnicaLago_pag');
prfPDF.getParameters().put('idOpp', id);
Blob blbPDF = prfPDF.getContent();
Attachment attach = new Attachment();
attach.Body = blbPDF;
attach.Name = 'Ficha Técnica - '+nombre+'.pdf';
attach.IsPrivate = false;
attach.ParentId = id;
System.debug('Adjuto - '+attach);
return attach;

}*/
    
    /* 
* Nombre: procesarOpp
* Descripcion: Metodo encargado de procesar calculos cuando se guarda o actualiza una oportunidad
* Fecha Creación: 27/09/2017
* Cambios de Version del Metodo:
* --------------------------------------------------------------------------------------------------------------
* Version        Fecha                   Autor                           Descripción
* ---------     ------------     ----------------------      -----------------------------
*   1            27-Sep-2017     Juan David Uribe Ruiz         Creacion del metodo.
* --------------------------------------------------------------------------------------------------------------
*/
    public void procesarOpp(list<Opportunity> lstOppNew, list<Opportunity> lstOppOld){
        list<COM_ProgramaVinculacion__c> lstProgramaVinculacion;
        list<Account> lstCuentas;
        list<Account> lstCuentasActualizar;
        list<RecordType> lstRecordType;
        list<User> lstOwners;
        list<Product2> lstProduct;
        list<COM_MetasIndividuales__c> lstMetasIndividuales;
        list<COM_MetasIndividuales__c> lstMetasIndividualesActualizar;
        map<Id, COM_ProgramaVinculacion__c> mapProgramaVinculacionxOpp;
        map<Id, Account> mapCuentasxOpp;
        map<Id, RecordType> mapRecordTypexOpp;
        map<Id, User> mapOwnersxOpp;
        map<Id, Product2> mapProductxOpp;
        set<Id> setIdProgramaVinculacion;
        set<Id> setIdCuentas;
        set<Id> setIdRecordType;
        set<Id> setIdOwners;
        set<Id> setIdProduct;
        set<String> setStrCanalVentas;
        set<String> setStrRecordTypeName;
        Opportunity objOppNew;
        Opportunity objOppOld;
        Account objCuenta;
        RecordType objRecordType;
        COM_ProgramaVinculacion__c objProgramaVinculacion;
        COM_CalculadoraSuperavit2__c objCalculadoraSuperavit2;
        COM_MetasIndividuales__c objMetasIndividuales;
        String StrAnio;
        String Strmes;
        String strBloqueCalc;
        String strSegmentoCalc;
        boolean blnActualizarCuenta;
        boolean blnActualizarMetasIndividuale;
        
        lstCuentasActualizar = new list<Account>();
        lstMetasIndividualesActualizar = new list<COM_MetasIndividuales__c>();
        
        setIdProgramaVinculacion = new set<Id>();
        setIdCuentas = new set<Id>();
        setIdRecordType = new set<Id>();
        setIdOwners = new set<Id>();
        setIdProduct = new set<Id>();
        setStrCanalVentas = new set<String>();
        setStrRecordTypeName = new set<String>();
        for(Integer i = 0; i < lstOppNew.size(); i++){
            setIdProgramaVinculacion.add(lstOppNew[i].COM_ProgramaVinculacion1__c);
            setIdCuentas.add(lstOppNew[i].AccountId);
            setIdRecordType.add(lstOppNew[i].RecordTypeId);
            setIdOwners.add(lstOppNew[i].OwnerId);
            //setIdProduct.add(lstOppNew[i].COM_PYS__c);
            setStrCanalVentas.add(lstOppNew[i].COM_Canalventas__c);
            if(lstOppNew[i].COM_PYS__c!=null){
                system.debug('pruabaaaaaaa');
                list<String> lstStr = new list <String>();
                lstStr = lstOppNew[i].COM_PYS__c.split(' ');
                for(Integer j = 0;j<lstStr.size();j++){
                    setIdProduct.add(Id.valueOf(lstStr[j]));
                }
            }else{
                setIdProduct.add(lstOppNew[i].COM_PYS__c);
            }
        }
        
        //Se consultan los programas de vinculacion asociados a las Oportunidades
        lstProgramaVinculacion = [SELECT Id, COM_Codigo__c 
                                  FROM COM_ProgramaVinculacion__c 
                                  WHERE Id IN :setIdProgramaVinculacion];
        mapProgramaVinculacionxOpp = new map<Id, COM_ProgramaVinculacion__c>(lstProgramaVinculacion);
        
        //Se consultan las cuentas asociadas a las Oportunidades
        lstCuentas = [SELECT Id, COM_DS_Inicial__c, COM_Bloque__c, COM_Segmento__c, COM_Comite__c, COM_ActividadEconomicaCIIU__c, 
                      COM_ActividadeconomicaSENA__c, COM_ARL1__c, COM_EntidadPensionadora1__c, COM_SectorEconomico__c, Type
                      FROM Account 
                      WHERE Id IN :setIdCuentas];
        mapCuentasxOpp = new map<Id, Account>(lstCuentas);
        
        //Se consultan los RecordType asociados a las Oportunidades
        lstRecordType = [SELECT Id, BusinessProcessId, DeveloperName, Name, SobjectType 
                         FROM RecordType 
                         WHERE Id IN :setIdRecordType];
        mapRecordTypexOpp = new map<Id, RecordType>(lstRecordType);
        for(RecordType objRT : lstRecordType){
            setStrRecordTypeName.add(objRT.Name);
        }
        
        //Se consulta los usuarios Owners asociados a las oportunidades
        lstOwners = [SELECT Id, Manager.Email 
                     FROM User 
                     WHERE Id IN :setIdOwners];
        mapOwnersxOpp = new map<Id, User>(lstOwners);
        
        //Se consultan los productos (PyS) asociados a la oportunidad
        lstProduct = [SELECT Name, COM_Linea__c 
                      FROM Product2 
                      WHERE Id IN :setIdProduct];
        system.debug('================ lstProduct: ' + setIdOwners);
        mapProductxOpp = new map<Id, Product2>(lstProduct);
        
        system.debug('================ setIdOwners: ' + setIdOwners);
        system.debug('================ setStrCanalVentas: ' + setStrCanalVentas);
        system.debug('================ setStrRecordTypeName: ' + setStrRecordTypeName);
        lstMetasIndividuales = [SELECT Id, COM_Anio__c, COM_Mes__c, COM_Linea__c, COM_ValorEjecutado__c, COM_Asesor__c, COM_Canal__c, COM_Ciclo__c
                                FROM COM_MetasIndividuales__c 
                                WHERE (COM_Asesor__c IN :setIdOwners AND COM_Canal__c IN :setStrCanalVentas)
                                OR (COM_Canal__c IN :setStrCanalVentas AND COM_Ciclo__c IN :setStrRecordTypeName)
                                OR (COM_Asesor__c IN :setIdOwners AND COM_Ciclo__c IN :setStrRecordTypeName)];
        
        system.debug('================ lstMetasIndividuales : ' + lstMetasIndividuales );
        //Se consultand los datos de la configuracion personalziada de Superavit
        objCalculadoraSuperavit2 = COM_CalculadoraSuperavit2__c.getInstance();
        
        system.debug(':::::::::::::: Entro a procesar Opp');
        
        for(Integer i = 0; i < lstOppNew.size(); i++){
            objOppNew = lstOppNew[i];
            system.debug(':::::::::::::: objOppNew['+i+'] : ' + objOppNew );
            
            if(lstOppOld != null){
                objOppOld = lstOppOld[i];
                system.debug(':::::::::::::: objOppOld: ' + objOppOld );
            }
            
            blnActualizarCuenta = false;
            blnActualizarMetasIndividuale = false;
            
            objProgramaVinculacion = mapProgramaVinculacionxOpp.get(objOppNew.COM_ProgramaVinculacion1__c);
            objCuenta = mapCuentasxOpp.get(objOppNew.AccountId);
            objRecordType = mapRecordTypexOpp.get(objOppNew.RecordTypeId);
            
            //Se recalculas los formula fields que algunos son usados en la logica mas abajo 
            //objOppNew.recalculateFormulas();
            if(objOppNew.COM_ProgramaVinculacion1__c != null){
                system.debug(':::::::::::::: 1');
                //1. Calcular Caja
                if (objProgramaVinculacion.COM_Codigo__c.equals('1011') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('1012') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('1013') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('1014')){
                        system.debug(':::::::::::::: 1. objProgramaVinculacion.COM_Codigo__c' + objProgramaVinculacion.COM_Codigo__c);
                        system.debug(':::::::::::::: 1. Calcular Caja');
                        system.debug(':::::::::::::: 1. objCalculadoraSuperavit2: ' + objCalculadoraSuperavit2);
                        system.debug(':::::::::::::: 1. objOppNew.COM_AporteTOTALCalc__c: ' + objOppNew.COM_AporteTOTALCalc__c);
                        system.debug(':::::::::::::: 1. objCalculadoraSuperavit2.COM_PorcentajeApropiacion__c: ' + objCalculadoraSuperavit2.COM_PorcentajeApropiacion__c);
                        system.debug(':::::::::::::: 1. objOppNew.COM_Subsidiomensual__c: ' + objOppNew.COM_Subsidiomensual__c);
                        system.debug(':::::::::::::: 1. objCalculadoraSuperavit2.COM_PorcentajeFactor__c: ' + objCalculadoraSuperavit2.COM_PorcentajeFactor__c);
                        //Validar si esos campos formula estan en el before update o before insert, sino hay que calcular esos campos aca
                        lstOppNew[i].COM_DSCalc__c = (
                            (objOppNew.COM_AporteTOTALCalc__c * objCalculadoraSuperavit2.COM_PorcentajeApropiacion__c) - objOppNew.COM_Subsidiomensual__c) 
                            * objCalculadoraSuperavit2.COM_PorcentajeFactor__c;
                    }
                
                //1. Calcular pensionados e independientes
                if (objProgramaVinculacion.COM_Codigo__c.equals('10251') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('10254') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('10222') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('10225')){
                        system.debug(':::::::::::::: 1.1 Calcular pensionados e independientes');
                        lstOppNew[i].COM_DSCalc__c = objOppNew.COM_AporteTOTALCalc__c;
                    }
                
                if (objProgramaVinculacion.COM_Codigo__c.equals('10224') || 
                    objProgramaVinculacion.COM_Codigo__c.equals('10221')){
                        system.debug(':::::::::::::: 1.2 Calcular pensionados e independientes');
                        lstOppNew[i].COM_DSCalc__c = objOppNew.COM_AporteTOTALCalc__c;
                    }
                
                if(lstOppNew[i].COM_DSCalc__c != null){
                    //Asignar el campo COM_DSCalc__c al campo COM_DS_Inicial__c de la cuenta
                    system.debug(':::::::::::::: 1.3 Calcular pensionados e independientes');
                    /* Inicio 1.2 */
                    if(objCuenta.COM_DS_Inicial__c != objOppNew.COM_DSCalc__c){
                        /* Fin 1.2 */
                        objCuenta.COM_DS_Inicial__c = objOppNew.COM_DSCalc__c;
                        blnActualizarCuenta = true;                        
                        /* Inicio 1.2 */
                    }                    
                    /* Fin 1.2 */
                }
            }
            system.debug(':::::::::::::: 2');
            //2. Calcular Bloque (subirlo a la cuenta)
            if(objRecordType.DeveloperName.equals('COM_Vinculacion_Contratista') ||
               objRecordType.DeveloperName.equals('COM_VEmpresas') ||
               objRecordType.DeveloperName.equals('COM_VIndependientes') ||
               objRecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')){
                   system.debug(':::::::::::::: 2. objOppNew.COM_CajaAnterior__c: ' + objOppNew.COM_CajaAnterior__c);
                   system.debug(':::::::::::::: 2. objOppNew.COM_DSCalc__c: ' + objOppNew.COM_DSCalc__c);
                   
                   if(objOppNew.COM_SustitucionPatronalAumentoTrab__c){
                       strBloqueCalc = 'E1';
                   } else if(objOppNew.COM_SustitucionPatronal__c){
                       strBloqueCalc = 'E';
                   } else if(String.isBlank(objOppNew.COM_CajaAnterior__c) && objOppNew.COM_DSCalc__c < 0){
                       strBloqueCalc = 'D';
                   } else if(String.isBlank(objOppNew.COM_CajaAnterior__c) && objOppNew.COM_DSCalc__c > 0 && objOppNew.COM_DSCalc__c < 50000){
                       strBloqueCalc = 'C';
                   } else if(String.isBlank(objOppNew.COM_CajaAnterior__c) && objOppNew.COM_DSCalc__c > 50000){
                       strBloqueCalc = 'B';
                   } else if(!String.isBlank(objOppNew.COM_CajaAnterior__c) && objOppNew.COM_DSCalc__c < 0){
                       strBloqueCalc = 'A1';
                   } else if(!String.isBlank(objOppNew.COM_CajaAnterior__c) && objOppNew.COM_DSCalc__c > 0){
                       strBloqueCalc = 'A';
                   } else{
                       strBloqueCalc = '';
                   }
                   
                   system.debug('>>>>>>>>>>>> objOppNew.COM_BloqueCalc__c : ' + objOppNew.COM_BloqueCalc__c);
                   system.debug('>>>>>>>>>>>> lstOppNew[i].COM_BloqueCalc__c : ' + lstOppNew[i].COM_BloqueCalc__c);
                   system.debug('>>>>>>>>>>>> strBloqueCalc : ' + strBloqueCalc);
                   //Aca seria por el insert
                   //if(lstOppOld == null && objOppNew.COM_BloqueCalc__c != null){
                   if(lstOppOld == null && !String.isBlank(strBloqueCalc)){
                       system.debug(':::::::::::::: 2. Calcular Bloque (subirlo a la cuenta)');
                       /* Inicio 1.2 */
                       if(objCuenta.COM_Bloque__c != strBloqueCalc && strBloqueCalc != '' && strBloqueCalc != Null){
                           /* Fin 1.2 */
                           objCuenta.COM_Bloque__c = strBloqueCalc;
                           blnActualizarCuenta = true;                           
                           /* Inicio 1.2 */
                       }                       
                       /* Fin 1.2 */
                   }
                   
                   //Aca seria por el update 
                   if(lstOppOld != null && strBloqueCalc != objOppOld.COM_BloqueCalc__c){
                       system.debug(':::::::::::::: 2. Calcular Bloque (subirlo a la cuenta)');
                       /* Inicio 1.2 */
                       if(objCuenta.COM_Bloque__c != strBloqueCalc && strBloqueCalc != '' && strBloqueCalc != Null){
                           /* Inicio 1.2 */
                           objCuenta.COM_Bloque__c = strBloqueCalc;
                           blnActualizarCuenta = true;
                           /* Inicio 1.2 */
                       }
                       /* Inicio 1.2 */
                   }
               }
            
            
            system.debug(':::::::::::::: 3');
            //3. Calcular Segmento (lo sube a la cuenta)
            if(objRecordType.DeveloperName.equals('COM_Vinculacion_Contratista') ||
               objRecordType.DeveloperName.equals('COM_VEmpresas') ||
               objRecordType.DeveloperName.equals('COM_VIndependientes') ||
               objRecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')){
                   
                   
                   if(objOppNew.COM_DSCalc__c < 0){
                       strSegmentoCalc = '6';
                   } else if(objOppNew.COM_DSCalc__c >= 0 && objOppNew.COM_DSCalc__c < 100000){
                       strSegmentoCalc = '5';
                   } else if(objOppNew.COM_DSCalc__c >= 100000 && objOppNew.COM_DSCalc__c < 1000000){
                       strSegmentoCalc = '4';
                   } else if(objOppNew.COM_DSCalc__c >= 1000000 && objOppNew.COM_DSCalc__c < 6000000){
                       strSegmentoCalc = '3';
                   } else if(objOppNew.COM_DSCalc__c >= 6000000 && objOppNew.COM_DSCalc__c < 15000000){
                       strSegmentoCalc = '2';
                   } else if(objOppNew.COM_DSCalc__c >= 15000000){
                       strSegmentoCalc = '1';
                   } else{
                       strSegmentoCalc = '';
                   }
                   
                   system.debug(':::::::::::::: 3. Calcular Segmento (lo sube a la cuenta)');
                   //Aca seria por el insert
                   //if(lstOppOld == null && objOppNew.COM_SegmentoCalc__c != null){
                   if(lstOppOld == null && !String.isBlank(strSegmentoCalc)){
                       //objCuenta.COM_Segmento__c = objOppNew.COM_SegmentoCalc__c;
                       /* Inicio 1.2 */
                       if(objCuenta.COM_Segmento__c != strSegmentoCalc && strSegmentoCalc != '' && strSegmentoCalc != Null){
                           /* Fin 1.2 */
                           objCuenta.COM_Segmento__c = strSegmentoCalc;
                           blnActualizarCuenta = true;
                           /* Inicio 1.2 */
                       }
                       /* Fin 1.2 */                       
                   }
                   
                   //Aca seria por el update 
                   if(lstOppOld != null && strSegmentoCalc != objOppOld.COM_SegmentoCalc__c){
                       //objCuenta.COM_Segmento__c = objOppNew.COM_SegmentoCalc__c;
                       /* Inicio 1.2 */
                       if(objCuenta.COM_Segmento__c != strSegmentoCalc && strSegmentoCalc != '' && strSegmentoCalc != Null){
                           /* Fin 1.2 */
                           objCuenta.COM_Segmento__c = strSegmentoCalc;
                           blnActualizarCuenta = true; 
                           /* Inicio 1.2 */
                       }
                       /* Fin 1.2 */
                       
                   }
               }
            
            system.debug(':::::::::::::: 4');
            //4. Subir Comite a la cuenta
            if(objRecordType.DeveloperName.equals('COM_Vinculacion_Contratista') || objRecordType.DeveloperName.equals('COM_VEmpresas') || objRecordType.DeveloperName.equals('COM_VIndependientes') || objRecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')){
                
                system.debug(':::::::::::::: 4. Subir Comite a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_Comite__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_Comite__c != objOppNew.COM_Comite__c){
                        /* Fin 1.2 */
                        objCuenta.COM_Comite__c = objOppNew.COM_Comite__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_Comite__c != objOppOld.COM_Comite__c){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_Comite__c != objOppNew.COM_Comite__c){
                        /* Fin 1.2 */
                        objCuenta.COM_Comite__c = objOppNew.COM_Comite__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */
                }
            }
            
            
            system.debug(':::::::::::::: 5');
            //5. Subir Actividad economica CIIU a la cuenta
            if(objRecordType.DeveloperName.equals('COM_VEmpresas')){
                
                system.debug(':::::::::::::: 5. Subir Actividad economica CIIU a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_ActividadEconomicaCIIU__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_ActividadEconomicaCIIU__c != objOppNew.COM_ActividadEconomicaCIIU__c){
                        /* Fin 1.2 */
                        objCuenta.COM_ActividadEconomicaCIIU__c = objOppNew.COM_ActividadEconomicaCIIU__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_ActividadEconomicaCIIU__c != objOppOld.COM_ActividadEconomicaCIIU__c){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_ActividadEconomicaCIIU__c != objOppNew.COM_ActividadEconomicaCIIU__c){
                        /* Fin 1.2 */
                        objCuenta.COM_ActividadEconomicaCIIU__c = objOppNew.COM_ActividadEconomicaCIIU__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
            } 
            
            system.debug(':::::::::::::: 6');
            //6. Subir Actividad economica SENA a la cuenta
            if(objRecordType.DeveloperName.equals('COM_VEmpresas')){
                
                system.debug(':::::::::::::: 6. Subir Actividad economica SENA a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_ActividadeconomicaSENA__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_ActividadeconomicaSENA__c != objOppNew.COM_ActividadeconomicaSENA__c){
                        /* Fin 1.2 */
                        objCuenta.COM_ActividadeconomicaSENA__c = objOppNew.COM_ActividadeconomicaSENA__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_ActividadeconomicaSENA__c != objOppOld.COM_ActividadeconomicaSENA__c){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_ActividadeconomicaSENA__c != objOppNew.COM_ActividadeconomicaSENA__c){
                        /* Fin 1.2 */
                        objCuenta.COM_ActividadeconomicaSENA__c = objOppNew.COM_ActividadeconomicaSENA__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
            } 
            
            system.debug(':::::::::::::: 7');
            //7. Subir ARL a la cuenta
            if(objRecordType.DeveloperName.equals('COM_VEmpresas')){
                
                system.debug(':::::::::::::: 7. Subir ARL a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_ARL1__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_ARL1__c != objOppNew.COM_ARL1__c){
                        /* Fin 1.2 */
                        objCuenta.COM_ARL1__c = objOppNew.COM_ARL1__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_ARL1__c != objOppOld.COM_ARL1__c){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_ARL1__c != objOppNew.COM_ARL1__c){
                        /* Fin 1.2 */
                        objCuenta.COM_ARL1__c = objOppNew.COM_ARL1__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
            }
            
            system.debug(':::::::::::::: 8');
            //8. Subir Entidad Pensionadora (AFP) a la cuenta
            if(objRecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')){
                
                system.debug(':::::::::::::: 8. Subir Entidad Pensionadora (AFP) a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_EntidadPensionadora1__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_EntidadPensionadora1__c != objOppNew.COM_EntidadPensionadora1__c){
                        /* Fin 1.2 */
                        objCuenta.COM_EntidadPensionadora1__c = objOppNew.COM_EntidadPensionadora1__c;
                        blnActualizarCuenta = true;    
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_EntidadPensionadora1__c != objOppOld.COM_EntidadPensionadora1__c){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_EntidadPensionadora1__c != objOppNew.COM_EntidadPensionadora1__c){
                        /* Fin 1.2 */
                        objCuenta.COM_EntidadPensionadora1__c = objOppNew.COM_EntidadPensionadora1__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                       
                }
            }
            
            system.debug(':::::::::::::: 9');
            //9. Subir Sector Economico a la cuenta
            if(objRecordType.DeveloperName.equals('COM_VEmpresas')){
                
                system.debug(':::::::::::::: 9. Subir Sector Economico a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_SectorEconomico__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_SectorEconomico__c != objOppNew.COM_SectorEconomico__c){
                        /* Fin 1.2 */
                        objCuenta.COM_SectorEconomico__c = objOppNew.COM_SectorEconomico__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_SectorEconomico__c != objOppOld.COM_SectorEconomico__c){
                    /* Inicio 1.2 */
                    if(objCuenta.COM_SectorEconomico__c != objOppNew.COM_SectorEconomico__c){
                        /* Fin 1.2 */
                        objCuenta.COM_SectorEconomico__c = objOppNew.COM_SectorEconomico__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }                    
                    /* Fin 1.2 */
                }
            }
            
            system.debug(':::::::::::::: 10');
            //10. Subir tipo de empresa a la cuenta
            if(objRecordType.DeveloperName.equals('COM_VEmpresas')){
                
                system.debug(':::::::::::::: 10. Subir tipo de empresa a la cuenta');
                //Aca seria por el insert
                if(lstOppOld == null && objOppNew.COM_TipoEmpresa__c != null){
                    /* Inicio 1.2 */
                    if(objCuenta.Type != objOppNew.COM_TipoEmpresa__c){
                        /* Fin 1.2 */
                        objCuenta.Type = objOppNew.COM_TipoEmpresa__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
                
                //Aca seria por el update 
                if(lstOppOld != null && objOppNew.COM_TipoEmpresa__c != objOppOld.COM_TipoEmpresa__c){
                    /* Inicio 1.2 */
                    if(objCuenta.Type != objOppNew.COM_TipoEmpresa__c){
                        /* Fin 1.2 */
                        objCuenta.Type = objOppNew.COM_TipoEmpresa__c;
                        blnActualizarCuenta = true;
                        /* Inicio 1.2 */
                    }
                    /* Fin 1.2 */                    
                }
            }
            
            system.debug(':::::::::::::: 11');
            //11. Poner en el campo Total Trabajadores = 1 solo cuando las oportunidades son de un Tipo de Registro, solo en insert
            if(lstOppOld == null && (objRecordType.DeveloperName.equals('COM_Vinculacion_Contratista') || objRecordType.DeveloperName.equals('COM_VIndependientes') || objRecordType.DeveloperName.equals('COM_Vinculacion_Pensionado'))){
                
                system.debug(':::::::::::::: 11. Poner en el campo Total Trabajadores = 1 solo cuando las oportunidades son de un Tipo de Registro, solo en insert');
                objOppNew.COM_TotalTrabajadores__c = 1;
            }
            
            system.debug(':::::::::::::: 12');
            //12. Actualizar correo del Jefe del Propietario
            if(objRecordType.DeveloperName.equals('COM_Alimentos') || objRecordType.DeveloperName.equals('COM_Alojamiento') || objRecordType.DeveloperName.equals('COM_Deportes') || objRecordType.DeveloperName.equals('COM_COM_Educacion') || objRecordType.DeveloperName.equals('Eventos') ||objRecordType.DeveloperName.equals('COM_FinancieroCredito') ||objRecordType.DeveloperName.equals('COM_Recreacion') ||objRecordType.DeveloperName.equals('COM_Salud"')){
                
                system.debug(':::::::::::::: 12. Actualizar correo del Jefe del Propietario');
                system.debug(':::::::::::::: 12. mapOwnersxOpp.get(objOppNew.OwnerId).Manager.Email: ' + mapOwnersxOpp.get(objOppNew.OwnerId).Manager.Email);
                objOppNew.COM_CorreoelectronicoPVE__c = mapOwnersxOpp.get(objOppNew.OwnerId).Manager.Email;
            }
            
            system.debug(':::::::::::::: 13');
            //13. Ha cambiado etapa registrado
            if(lstOppOld != null && objOppNew.StageName != objOppOld.StageName && objOppNew.StageName.equals('Registrado')){
                system.debug(':::::::::::::: 13. Ha cambiado etapa registrado');
                objOppNew.COM_FechaRegistrado__c = date.today();
            }
            
            if(lstOppOld == null && objOppNew.StageName.equals('Registrado')){
                system.debug(':::::::::::::: 13. Ha cambiado etapa registrado');
                objOppNew.COM_FechaRegistrado__c = date.today();
            }
            
            system.debug(':::::::::::::: 14');
            //14. Asignar Meta Individual
            //Se debe ejecutar en el before Insert o before Update -- 5 AND ((1 AND 6) OR ((2 OR 3 OR 4) AND 7))
            system.debug(':::::::::::::: objOppNew.isWon: ' + objOppNew.isWon);
            /*Inicio 1.1*/
            if( objOppNew.isWon == true && ((objRecordType.DeveloperName.equals('COM_FinancieroCredito') && objOppNew.COM_FechaFacturacion__c != null)|| ((objRecordType.DeveloperName.equals('COM_Salud') || objRecordType.DeveloperName.equals('COM_Alojamiento') || objRecordType.DeveloperName.equals('Eventos')|| objRecordType.DeveloperName.equals('COM_Educacion')
                                                                                                                                                           || objRecordType.DeveloperName.equals('COM_Deportes')|| objRecordType.DeveloperName.equals('COM_Alimentos')|| objRecordType.DeveloperName.equals('COM_Recreacion')|| objRecordType.DeveloperName.equals('COM_BonosTJCompensar')) && objOppNew.COM_FechaFacturacion__c != null))){
                                                                                                                                                               system.debug(':::::::::::::: 14. Asignar Meta Individual');
                                                                                                                                                               StrAnio = '';
                                                                                                                                                               StrMes = '';
                                                                                                                                                               /*Inicio 1.1*/
                                                                                                                                                               /*if(!objRecordType.DeveloperName.equals('COM_FinancieroCredito')){
StrAnio = String.valueOf(objOppNew.CloseDate.year());//Se obtiene el Año del campo Fecha Cierre
StrMes = COM_Utilidades_cls.obtenerMes(objOppNew.CloseDate.month());//Se obtiene el Mes del campo Fecha Cierre
} else{
StrAnio = String.valueOf(objOppNew.COM_FechaFacturacion__c.year());//Se obtiene el Año del campo Fecha Facturacion
StrMes = COM_Utilidades_cls.obtenerMes(objOppNew.COM_FechaFacturacion__c.month());//Se obtiene el Mes del campo FechadeFacturacion
}*/
                                                                                                                                                               
                                                                                                                                                               /*if(!objRecordType.DeveloperName.equals('COM_FinancieroCredito')){
StrAnio = String.valueOf(objOppNew.CloseDate.year());//Se obtiene el Año del campo Fecha Cierre
StrMes = COM_Utilidades_cls.obtenerMes(objOppNew.CloseDate.month());//Se obtiene el Mes del campo Fecha Cierre
} else{*/
                                                                                                                                                               StrAnio = String.valueOf(objOppNew.COM_FechaFacturacion__c.year());//Se obtiene el Año del campo Fecha Facturacion
                                                                                                                                                               StrMes = COM_Utilidades_cls.obtenerMes(objOppNew.COM_FechaFacturacion__c.month());//Se obtiene el Mes del campo FechadeFacturacion
                                                                                                                                                               //}
                                                                                                                                                               
                                                                                                                                                               
                                                                                                                                                               
                                                                                                                                                               /* if(objRecordType.DeveloperName.equals('COM_FinancieroCredito')){
system.debug(':::::::::::::: 14. objOppNew.COM_Linea__c: ' + objOppNew.COM_Linea__c);
objMetasIndividuales = obtenerMetaIndividual(lstMetasIndividuales, StrAnio, StrMes, objOppNew.COM_Linea__c, objOppNew.OwnerId, objOppNew.COM_Canalventas__c, objRecordType.Name);
} else{

//if(objOppNew.COM_PYS__c != null){


objMetasIndividuales = obtenerMetaIndividual(lstMetasIndividuales, StrAnio, StrMes, objOppNew.COM_Linea__c, objOppNew.OwnerId, objOppNew.COM_Canalventas__c, objRecordType.Name);
system.debug(':::::::::::::: 14. Prueba objMetasIndividuales: ' + objMetasIndividuales);
// }
}*/
                                                                                                                                                               System.debug('Stif 35 ' + lstMetasIndividuales);
                                                                                                                                                               
                                                                                                                                                               if((!objRecordType.DeveloperName.equals('COM_FinancieroCredito') && objOppNew.StageName.equals('Facturada')) || (objRecordType.DeveloperName.equals('COM_FinancieroCredito') && objOppNew.StageName.equals('DESEMBOLSADO')))
                                                                                                                                                               {
                                                                                                                                                                   objMetasIndividuales = obtenerMetaIndividual(lstMetasIndividuales, StrAnio, StrMes, objOppNew.COM_Linea__c, objOppNew.OwnerId, objOppNew.COM_Canalventas__c, objRecordType.Name);
                                                                                                                                                               }
                                                                                                                                                               /*Fin 1.1*/
                                                                                                                                                               
                                                                                                                                                               
                                                                                                                                                               system.debug(':::::::::::::: objMetasIndividuales: ' + objMetasIndividuales);
                                                                                                                                                               if(objMetasIndividuales != null){ 
                                                                                                                                                                   objOppNew.COM_MetaIndividual__c = objMetasIndividuales.Id;
                                                                                                                                                               } else{
                                                                                                                                                                   
                                                                                                                                                                   objOppNew.COM_MetaIndividual__c = null;
                                                                                                                                                                   system.debug('::::::::: NO SE VA A ASIGNAR META INDIVIDUAL PORQUE NO SE ENCONTRO :::::::::');
                                                                                                                                                               }
                                                                                                                                                           }
            
            //15. Actualizar meta individal 1
            /*if(lstOppOld != null && objOppNew.COM_MetaIndividual__c != null && objMetasIndividuales != null
&& objOppNew.StageName != objOppOld.StageName 
&& !objOppOld.StageName.equals('Facturada')
&& !objOppOld.StageName.equals('DESEMBOLSADO')
&& (objOppNew.StageName.equals('Facturada')
|| objOppNew.StageName.equals('DESEMBOLSADO'))){*/
            
            //Carlos Villalba Inicio:: Cambio de campo si el tipo de registro es alojamiento y si el valor es nulo le asigna 0 para evitar Null pointer.
            
            decimal AmountOld =0;
            decimal AmountNew=0; 
            if(objOppOld!=null)
            {
                if(objOppOld.Amount!=null || objOppOld.COM_Valor_antes_impuesto__c != null)
                {
                    AmountOld = !objRecordType.DeveloperName.equals('COM_Alojamiento')  ? objOppOld.Amount: objOppOld.COM_Valor_antes_impuesto__c != null? objOppOld.COM_Valor_antes_impuesto__c: 0;
                }
            }
            if(objOppNew!=null)
            {
                if(objOppNew.Amount!=null || objOppNew.COM_Valor_antes_impuesto__c != null)
                {
                    AmountNew = !objRecordType.DeveloperName.equals('COM_Alojamiento')  ? objOppNew.Amount: objOppNew.COM_Valor_antes_impuesto__c != null? objOppNew.COM_Valor_antes_impuesto__c: 0;
                }
            }
            
            //carlos Villalba Fin
            //
           
            
            if(lstOppOld != null && objOppNew.COM_MetaIndividual__c != null && objMetasIndividuales != null && !objRecordType.DeveloperName.equals('COM_FinancieroCredito')
               /*Inicio 1.1*/ /*&& objOppNew.StageName != objOppOld.StageName 
&& !objOppOld.StageName.equals('Facturada')*/ 
               && objOppNew.StageName == objOppOld.StageName /*FIn 1.1*/
               && objOppOld.StageName.equals('Facturada')
               && objOppNew.StageName.equals('Facturada')){         
                   system.debug(':::::::::::::: 15 A. Actualizar meta individal Facturada');
                   
                   
                   if(objMetasIndividuales.COM_ValorEjecutado__c == null){
                       objMetasIndividuales.COM_ValorEjecutado__c = AmountNew; //objOppNew.Amount;
                   } else{
                       //Desembolsado no sume más de un valor
                       objMetasIndividuales.COM_ValorEjecutado__c -= AmountOld; //objOppOld.Amount;
                       objMetasIndividuales.COM_ValorEjecutado__c += AmountNew; //objOppNew.Amount;
                   }
                   blnActualizarMetasIndividuale = true;
               }
            
            
            if(lstOppOld != null && objOppNew.COM_MetaIndividual__c != null && objMetasIndividuales != null && !objRecordType.DeveloperName.equals('COM_FinancieroCredito') && objOppNew.StageName != objOppOld.StageName && !objOppOld.StageName.equals('Facturada') && objOppNew.StageName.equals('Facturada')){         
                system.debug(':::::::::::::: 15.1 A. Actualizar meta individal Facturada');
                if(objMetasIndividuales.COM_ValorEjecutado__c == null){
                    objMetasIndividuales.COM_ValorEjecutado__c = AmountNew;//objOppNew.Amount;
                } else{
                    //Desembolsado no sume más de un valor
                    objMetasIndividuales.COM_ValorEjecutado__c += AmountNew;//objOppNew.Amount;
                }
                blnActualizarMetasIndividuale = true;
            }
            
            
            /*Inicio 1.1*/
            
            if(lstOppOld == null && objOppNew.COM_MetaIndividual__c != null && objMetasIndividuales != null && !objRecordType.DeveloperName.equals('COM_FinancieroCredito')
               && objOppNew.StageName.equals('Facturada')){         
                   system.debug(':::::::::::::: 15.2 A. Actualizar meta individal Facturada');
                   if(objMetasIndividuales.COM_ValorEjecutado__c == null){
                       objMetasIndividuales.COM_ValorEjecutado__c = AmountNew; //objOppNew.Amount;
                   } else{
                       objMetasIndividuales.COM_ValorEjecutado__c += AmountNew; //objOppNew.Amount;
                   }
                   blnActualizarMetasIndividuale = true;
               }
            
            /*Fin 1.1*/
            
             System.debug(' Stif 34 objOppNew.COM_MetaIndividual__c ' + objOppNew.COM_MetaIndividual__c + ' objMetasIndividuales' + objMetasIndividuales + ' recortype ' + objRecordType.DeveloperName + ' objOppNew.StageName ' + objOppNew.StageName);
            
            if(objMetasIndividuales != null && lstOppOld == null && objRecordType.DeveloperName.equals('COM_FinancieroCredito') && objOppNew.StageName.equals('DESEMBOLSADO')){
                system.debug(':::::::::::::: 15 B. Actualizar meta individal DESEMBOLSADO insert');
                if(objMetasIndividuales.COM_ValorEjecutado__c == null){
                    objMetasIndividuales.COM_ValorEjecutado__c = objOppNew.Amount != null ? objOppNew.Amount : 0;
                } else{
                    objMetasIndividuales.COM_ValorEjecutado__c += objOppNew.Amount != null ? objOppNew.Amount : 0;
                }
                blnActualizarMetasIndividuale = true;
            }
            
            if(objMetasIndividuales != null && lstOppOld != null && objRecordType.DeveloperName.equals('COM_FinancieroCredito') && objOppNew.StageName.equals('DESEMBOLSADO') && objOppNew.StageName == objOppOld.StageName){
                system.debug(':::::::::::::: 15 B. Actualizar meta individal DESEMBOLSADO update');
                if(objMetasIndividuales.COM_ValorEjecutado__c == null){
                    objMetasIndividuales.COM_ValorEjecutado__c = objOppNew.Amount != null ? objOppNew.Amount : 0;
                } else{
                    //Desembolsado no sume más de un valor
                    objMetasIndividuales.COM_ValorEjecutado__c -= objOppOld.Amount != null ? objOppOld.Amount : 0;
                    objMetasIndividuales.COM_ValorEjecutado__c += objOppNew.Amount != null ? objOppNew.Amount : 0;
                }
                blnActualizarMetasIndividuale = true;
            }
            
            //16. Actualizar meta individal 2
            /*if(lstOppOld != null && objOppNew.Amount != objOppOld.Amount && objOppNew.StageName == objOppOld.StageName 
&& (objOppNew.StageName.equals('Facturada') || objOppNew.StageName.equals('Cobrado')) 
&& objOppNew.COM_MetaIndividual__c != null){

system.debug(':::::::::::::: //16. Actualizar meta individal 2');
if(objMetasIndividuales != null){
if(objMetasIndividuales.COM_ValorEjecutado__c == null){                                  
objMetasIndividuales.COM_ValorEjecutado__c = (objOppNew.Amount - objOppOld.Amount);
} else{
objMetasIndividuales.COM_ValorEjecutado__c += (objOppNew.Amount - objOppOld.Amount);
}
blnActualizarMetasIndividuale = true;
}
}*/
            
            //Se asigna la 'Fecha de Ingreso Empresa' y 'Vinculado desde' de acuerdo a la 'Fecha de negociación'
            /*if((objRecordType.DeveloperName.equals('COM_Vinculacion_Contratista') ||
objRecordType.DeveloperName.equals('COM_VEmpresas') ||
objRecordType.DeveloperName.equals('COM_VIndependientes') ||
objRecordType.DeveloperName.equals('COM_Vinculacion_Pensionado')) && objOppNew.CloseDate != null){

objOppNew.COM_FechaIngresoEmpresa__c = objOppNew.CloseDate;
objOppNew.COM_Vinculadodesde__c = objOppNew.CloseDate;
}*/
            System.debug('blnActualizarCuenta: ' + blnActualizarCuenta);
            if(blnActualizarCuenta){
                lstCuentasActualizar.add(objCuenta);
            }
            
            if(blnActualizarMetasIndividuale){
                lstMetasIndividualesActualizar.add(objMetasIndividuales);
            }
        }
        
        if(!lstCuentasActualizar.isEmpty()){
            User u = [SELECT COM_PermisosEscrituraGC__c FROM User WHERE Id =: userinfo.getUserId()];
            
            if(u.COM_PermisosEscrituraGC__c){
                COM_Opportunity_cls.stopTrigger();
                update lstCuentasActualizar;
                COM_Opportunity_cls.startTrigger();
            } else {
                u.COM_PermisosEscrituraGC__c = true;
                update u;
                COM_Opportunity_cls.stopTrigger();
                update lstCuentasActualizar;
                COM_Opportunity_cls.startTrigger();
                u.COM_PermisosEscrituraGC__c = false;
                update u;
            }
            
        }
        
        Map<Id,COM_MetasIndividuales__c> mapMetas = new Map<Id,COM_MetasIndividuales__c>();
        
        if(!lstMetasIndividualesActualizar.isEmpty()){
            /* Inicio 1.1*/
            
            for(COM_MetasIndividuales__c metaAux : lstMetasIndividualesActualizar)
            {
                mapMetas.put(metaAux.Id, metaAux);
                if(!mapMetas.values().isEmpty())
                {
                    update mapMetas.values();
                }
            }
            //update lstMetasIndividualesActualizar;
            
            /*Fin 1.1*/
        }
        
    }
    
    public COM_MetasIndividuales__c obtenerMetaIndividual(list<COM_MetasIndividuales__c> lstMetasIndividuales, 
                                                          String StrAnio, String StrMes, String strLinea, Id idOwner, String strCanal, String strCiclo){
                                                              
                                                              system.debug('================ lstMetasIndividuales: ' + lstMetasIndividuales);
                                                              system.debug('================ StrAnio: ' + StrAnio);
                                                              system.debug('================ StrMes: ' + StrMes);
                                                              system.debug('================ strLinea: ' + strLinea);
                                                              system.debug('================ idOwner: ' + idOwner);
                                                              system.debug('================ strCanal: ' + strCanal);
                                                              system.debug('================ strCiclo: ' + strCiclo);
                                                              for(COM_MetasIndividuales__c objMetasIndividuales : lstMetasIndividuales){
                                                                  system.debug('================ COM_Anio__c: ' + objMetasIndividuales.COM_Anio__c);
                                                                  system.debug('================ COM_Mes__c: ' + objMetasIndividuales.COM_Mes__c);
                                                                  system.debug('================ COM_Linea__c: ' + objMetasIndividuales.COM_Linea__c);
                                                                  system.debug('================ COM_Asesor__c: ' + objMetasIndividuales.COM_Asesor__c);
                                                                  system.debug('================ COM_Canal__c: ' + objMetasIndividuales.COM_Canal__c);
                                                                  system.debug('================ COM_Ciclo__c: ' + objMetasIndividuales.COM_Ciclo__c);
                                                                  if(objMetasIndividuales.COM_Anio__c == StrAnio 
                                                                     && objMetasIndividuales.COM_Mes__c == StrMes 
                                                                     && objMetasIndividuales.COM_Linea__c == strLinea
                                                                     && objMetasIndividuales.COM_Asesor__c == idOwner
                                                                     && objMetasIndividuales.COM_Canal__c == strCanal
                                                                     && objMetasIndividuales.COM_Ciclo__c == strCiclo
                                                                    ){                                                                        
                                                                        return objMetasIndividuales;
                                                                    }
                                                              }
                                                              
                                                              return null; 
                                                          }
    
}