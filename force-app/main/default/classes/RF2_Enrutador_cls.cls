/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Clase encargada de asignar propietario a los casos cuando son asignados a una cola
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-11-27      Rubén Suárez Forero (RUSF)      Creación clase.
            1.1     2018-12-18      Jordan Parra        (JP)        Se comenta la inserción de la lista de miembros de casos que colocaba el creador del registro en esta
                                                                    Caso # 00260194.
*************************************************************************************************************/

public class RF2_Enrutador_cls{
    @Future(callout=true)
    //public static void asignarPropetario(List<Case> lstNewRecords){
    public static void asignarPropetario(Set<String> setIds, String objeto, String campo){
        List<sObject> lstNewRecords;
        if(objeto == 'Case'){
            lstNewRecords = new List<Case>([SELECT Id, OwnerId FROM Case WHERE Id IN :setIds]);
        } else if (objeto == 'RF2_EncuestasCasos__c'){
            lstNewRecords = new List<RF2_EncuestasCasos__c>([SELECT Id, OwnerId FROM RF2_EncuestasCasos__c WHERE Id IN :setIds]);
        } else {
            return;
        }
        //List<Object> lstNewRecords = Database.query('SELECT Id, Status, OwnerId FROM :objeto WHERE Id IN :setIds');
        List<RF2_Enrutador__c> configRuta = new List<RF2_Enrutador__c>([SELECT RF2_AsignacionCasos__c, RF2_AsignacionEncuestas__c, RF2_cantidad__c, RF2_Cola__c, RF2_Usuario__c FROM RF2_Enrutador__c]); //Rutas configuradas en el objeto temporal
        Map<String,List<RF2_Enrutador__c>> mapColaUsuario = new Map<String,List<RF2_Enrutador__c>>(); //Mapa con Colas y usuarios
        List<CaseTeamMember> lstMembers = new list<CaseTeamMember>(); //Miembros del caso
        CaseTeamRole rolusuario = [SELECT Id FROM CaseTeamRole where Name =: Label.RF2_FuncionTeamCaseLectura_lbl limit 1]; //función de los miembros del caso
        Set<String> setUsuarios = new Set<String>();
        if(configRuta.isEmpty()){
            system.debug('Advertencia - No hay configuración de rutas.');
            return; //Si no se encuentran rutas no se procesan los registros
        } else {
            //Insertar info de enrutamiento al mapa de colas y usuarios
            for(RF2_Enrutador__c obj : configRuta){
                if(mapColaUsuario.containsKey(obj.RF2_Cola__c)){
                    mapColaUsuario.get(obj.RF2_Cola__c).add(obj);
                } else {
                    mapColaUsuario.put(obj.RF2_Cola__c, new List<RF2_Enrutador__c>());
                    mapColaUsuario.get(obj.RF2_Cola__c).add(obj);
                }
                setUsuarios.add(obj.RF2_Usuario__c);
            }
            system.debug('mapColaUsuario -> '+mapColaUsuario);
        }       
        List<User> lstUsuarios = new List<User>([SELECT Id, IsActive FROM User WHERE Id IN :setUsuarios]); 
        Map<String, Boolean> mapUsuarios = new Map<String, Boolean>();
        for(User u :lstUsuarios){
            mapUsuarios.put(u.Id, u.IsActive);
        }
        //List<Case> lstUpdate = new List<Case>(); //Casos que se van a actualizar
        List<sObject> lstUpdate = new List<sObject>(); //Objetos que se van a actualizar
        Map<String, RF2_Enrutador__c> mapUpdateRuta = new Map<String,RF2_Enrutador__c>(); //Rutas que se van a actualizar
        //Integer x = 0;
        //for(Case obj : lstNewRecords){
        for(Integer i = 0; i < lstNewRecords.size(); i++) {
            sObject obj;
            String objAux;
            if(objeto == 'Case'){
                obj = (Case) lstNewRecords[i];
                objAux = ((Case)lstNewRecords[i]).OwnerId.getSObjectType().getDescribe().getName();
            } else if (objeto == 'RF2_EncuestasCasos__c'){
                obj = (RF2_EncuestasCasos__c) lstNewRecords[i];
                objAux = ((RF2_EncuestasCasos__c)lstNewRecords[i]).OwnerId.getSObjectType().getDescribe().getName();
            } else {
                continue;
            }
            system.debug('obj -> '+obj);
            system.debug('objAux -> '+objAux);
            if(objAux == 'Group'){
                if(mapColaUsuario.containsKey(String.valueOf(obj.get('OwnerId')))){
                    RF2_Enrutador__c aAsignar;
                    for(RF2_Enrutador__c ruta : mapColaUsuario.get(String.valueOf(obj.get('OwnerId')))){

                        System.debug('Stif ' + ruta.RF2_Usuario__c);
                        System.debug('Stif 2 ' + mapUsuarios);
                        if(mapUsuarios.containsKey(ruta.RF2_Usuario__c) && mapUsuarios.get(ruta.RF2_Usuario__c)){
                            if(aAsignar == null){
                                aAsignar = ruta;
                                system.debug('ruta vacia'); 
                            //} else if (Long.valueof(ruta.RF2_Asignacion__c) < Long.valueof(aAsignar.RF2_Asignacion__c)){
                            } else if (Long.valueof(String.valueOf(ruta.get(campo))) < Long.valueof(String.valueOf(aAsignar.get(campo)))){
                                //system.debug
                                aAsignar = ruta;
                            }
                        }
                    }
                    String ownerAnterior = String.valueOf(obj.get('OwnerId'));
                    if(aAsignar != null){
                        obj.put('OwnerId', aAsignar.RF2_Usuario__c);
                        lstUpdate.add(obj);
                        lstMembers.add(new CaseTeamMember(MemberId= UserInfo.getUserId(), ParentId= obj.Id, TeamRoleId = rolusuario.Id)); 
                    }
                    for(RF2_Enrutador__c ruta : mapColaUsuario.get(ownerAnterior)){
                        if(ruta.RF2_Usuario__c == String.valueOf(obj.get('OwnerId'))){

                            ruta.RF2_cantidad__c += 1;
                            //ruta.RF2_Asignacion__c = fechaAsignacion()+(i<100?(i<10?'00'+String.valueOf(i):'0'+String.valueOf(i)):String.valueOf(i));
                            ruta.put(campo, fechaAsignacion()+(i<100?(i<10?'00'+String.valueOf(i):'0'+String.valueOf(i)):String.valueOf(i)));
                            mapUpdateRuta.put(ruta.Id, ruta);
                            i++;
                            system.debug('ruta vacia'); 
                            break;
                        }
                    }
                } else {
                    system.debug('No se encontro la cola -> '+obj.get('OwnerId')+' en mapColaUsuario.'); 
                }
            }
        }
        if(!mapUpdateRuta.values().isEmpty()){
            try{

                RF2_Case_cls.stopTrigger();
                RF2_EncuestasCasos_cls.stopTrigger();

                    update lstUpdate;
                    update mapUpdateRuta.values();
                   // insert lstMembers; // (JP v1.1)

                RF2_Case_cls.startTrigger();
                RF2_EncuestasCasos_cls.startTrigger();
                
               
                system.debug('lstMembers -> '+lstMembers);                               
            } catch(Exception e){
                System.debug('Error actualizando rutas - '+e.getMessage());
            }
        }
        
    } 

    public static String fechaAsignacion(){
        datetime d = Datetime.now();
        String fa = String.valueOf(d.year()).substring(2);
        fa += d.month()<10?'0'+String.valueOf(d.month()):String.valueOf(d.month());
        fa += d.day()<10?'0'+String.valueOf(d.day()):String.valueOf(d.day());
        fa += d.hour()<10?'0'+String.valueOf(d.hour()):String.valueOf(d.hour());
        fa += d.minute()<10?'0'+String.valueOf(d.minute()):String.valueOf(d.minute());
        fa += d.second()<10?'0'+String.valueOf(d.second()):String.valueOf(d.second());
        fa += d.millisecond()<100?
                            (d.millisecond()<10?
                                                '00'+String.valueOf(d.millisecond())
                                                :'0'+String.valueOf(d.millisecond()))
                            :String.valueOf(d.millisecond());   
        system.debug(' asignacion -> '+fa);
        return fa; 
    }

}