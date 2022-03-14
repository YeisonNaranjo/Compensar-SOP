/**
* Avanxo Colombia
* @author           Rubén Suárez Forero href=<rsuarez@avanxo.com>
* Project:          Compensar
* Description:      Controlador de la visualforce RF2_ActualizarEnrutador_pag para actualizar el objeto enrutador
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                          Description
*           -----   ----------      --------------------            ---------------
* @version  1.0     2017-12-07      Rubén Suárez Forero (RUSF)      Creación clase.
*************************************************************************************************************/
public with sharing class RF2_ActualizarEnrutador_ctr {
    public Boolean blnError {get; set;}
    public Boolean blnActualizacion {get; set;}
    public String mensaje {get; set;}   

    public RF2_ActualizarEnrutador_ctr() {
        blnActualizacion = false;
        blnError = false;
    }

    public void actualizarEnrutador(){
        blnActualizacion = true;
        List<GroupMember> lgm = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue'];
        List<RF2_Enrutador__c> le = new list<RF2_Enrutador__c>();
        Set<String> ss = new Set<String>();
        for(GroupMember gm :lgm){
            RF2_Enrutador__c e = new RF2_Enrutador__c();
            e.RF2_cola__c = gm.groupid;
            e.RF2_usuario__c = gm.UserOrGroupId;
            Datetime d = Datetime.now();
            e.RF2_Llave__c = (String)gm.GroupId+(String)gm.UserOrGroupId;
            le.add(e);
            ss.add(e.RF2_Llave__c);
        }
        try{
            upsert le RF2_Llave__c;
            le = new list<RF2_Enrutador__c>();
            list<RF2_Enrutador__c> leOld = new list<RF2_Enrutador__c>([SELECT Id, RF2_Llave__c FROM RF2_Enrutador__c]);
            for(RF2_Enrutador__c e : leOld){
                if(!ss.contains(e.RF2_Llave__c)){
                    le.add(e);
                }
            }
            delete le;
            mensaje = 'El objeto Enrutadores fue actualizado correctamente.';

        } catch(Exception e){
            blnError = true;
            mensaje = 'Error,<br/>No se pudo actualizar el objeto Enrutadores.<br/>'+e.getMessage();
        }
    }
}