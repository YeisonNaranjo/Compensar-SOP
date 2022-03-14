/****************************************************************************************************
    -------------------
    Developer:        Avanxo Colombia
    Autor:            Jordan Steven Parra Torres
    Project:          Compensar
    Description:      
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     2018-06-12  Jordan Steven Parra Torres  Clase creada.
    ------  ----------  --------------------------  -----------
    2.0     2020-08-21  Yeison Stic Naranjo Rendón  Actualización campo tipo de actividad.
 ****************************************************************************************************/

public class COM_TaskTriggerHandler_cls 
{
    public static void CheckTask(List<Task> lstTask){

        String pru = 'prueba';
        ID_Admin_Casos__c  configAdmin = [select ID__c from ID_Admin_Casos__c]; // Se trae el ID del admin quemado en la configuración personalizada
        String ad1 = (configAdmin.ID__c).substring(0,15); // Se recoge el ID y se convierte en String de longitud 15
        String usuario = (userinfo.getProfileId()).substring(0,15); // Se trae el ID del usuario que actualemnte está en la instancia y se acota a 15 caracteres
            for (Task tsk : lstTask){ //Recorre los datos antiguos
                if (!usuario.equals(ad1) && tsk.whatId != null) { //Si el perfil del usuario actual no es igual a admin bota el error 
                    if(tsk.whatId.getSObjectType().getDescribe().getName()=='Case'){//Se valida que las tareas sean relacionadas con "Casos"
                        tsk.addError('No se puede borrar la tarea debido a sus permisos de perfil, verifique con el administrador');
                    }
                }
            } 
    }
    
    /* Inicio 2.0 */
    public static void UpdateActivityType(List<Task> lstTask){

        List<Task> lstTaskNew = [Select Id, TaskSubtype, COM_TipoActividad__c From Task where Id IN: lstTask And COM_TipoActividad__c = Null];
        
        For(Task objTask : lstTaskNew){
            If(objTask.TaskSubtype == 'Task'){
                objTask.COM_TipoActividad__c = 'Tarea';
            }
            If(objTask.TaskSubtype == 'Call'){
                objTask.COM_TipoActividad__c = 'Llamada';
            }
            If(objTask.TaskSubtype == 'Email'){
                objTask.COM_TipoActividad__c = 'Correo electrónico';
            }
        }
        
        Update lstTaskNew;
    }
    /* Fin 2.0 */ 
}