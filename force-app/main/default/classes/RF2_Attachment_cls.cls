/************************************************************************************************
Desarrollado por:  Avanxo
Autor:             Juan David Uribe Ruiz (JDUR)
Proyecto:          Compensar
Descripción:       Clase con la logica para el trigger RF2_Attachment_tgr

Cambios (Versiones)
-------------------------------------------------------------------------------------------------
    No.     Fecha                  Autor                                 Descripción
----------  -------------   ----------------------  ---------------------------------------------
    1.0     2017/12/19      Juan David Uribe Ruiz   Creación Clase.
    1.1     2018/06/18      Stifen Panche (SP)      Validación de tareas archivos adjuntos.
************************************************************************************************/
public with sharing class RF2_Attachment_cls {
	
	/* 
	* Nombre: validarEliminarAdjunto
    * Descripcion: Metodo con la logica para permitir borrar archivos de casos solo al propietario del archivo o 
    * si es el Administrador del sistema y si el caso esta en estado diferente de 'Cerrado'.
    *
    * Fecha Creación: 19/12/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            19-Dic-2017     Juan David Uribe Ruiz         Creacion del metodo.
    *   1.1          17-Jun-2018     Stifen Panche (SP)            Evitar eliminación adjuntos en tareas.
    * --------------------------------------------------------------------------------------------------------------
    */
	public void validarEliminarAdjunto(list<Attachment> lstAttachmentsOld){
		set<Id> setIdCasos = new set<Id>();
		list<Case> lstCasos;
		map<Id, Case> mapCasos;
		Map<Id, Profile> mapPerfil;
		
		system.debug('........... Entro a validarEliminarAdjunto');
		
		mapPerfil = new Map<Id, Profile>([SELECT Id, Name FROM Profile]);
		
		//Estas validaciones solo se hacen para los usuarios que NO son administradores del sistema
		if(mapPerfil.get(userinfo.getProfileId()).Name != 'Administrador del sistema'){
			
			for(Attachment objAttachment : lstAttachmentsOld){
				if(objAttachment.ParentId.getSObjectType() == Case.SobjectType){
					setIdCasos.add(objAttachment.ParentId);
				}

			}

            if(setIdCasos.isEmpty()){
				return;
			}
			
			lstCasos = [SELECT Id, Status FROM Case WHERE Id IN :setIdCasos];
			mapCasos = new map<Id, Case>(lstCasos);
			
			for(Attachment objAttachment : lstAttachmentsOld){
				if(objAttachment.ParentId.getSObjectType() == Case.SobjectType){
					if(label.RF2_EstadoCerradoCaso_lbl.equals(mapCasos.get(objAttachment.ParentId).Status)){
						objAttachment.addError(label.RF2_MsjEliminarArchivoCasoCerrado);
						return;
					}
					
					if(!objAttachment.OwnerId.equals(UserInfo.getUserId())){
						objAttachment.addError(label.RF2_MsjElimiarArchivoPropietario);
						return;
					}
				}
			}
		} else{
			system.debug('.......... Es Administrador del Sistema');
		}
	}

	/*Inicio 1-1*/
    	public void validarEliminarAdjuntoTarea(list<Attachment> lstAttachmentsOld){
		
        set<Id> setIdTareas = new set<Id>();
		list<Task> lstTareas;
		map<Id, Task> mapTareas;
		Map<Id, Profile> mapPerfil;
		
		system.debug('........... Entro a validarEliminarAdjunto');
		
		mapPerfil = new Map<Id, Profile>([SELECT Id, Name FROM Profile]);
		
		//Estas validaciones solo se hacen para los usuarios que NO son administradores del sistema
		if(mapPerfil.get(userinfo.getProfileId()).Name != 'Administrador del sistema'){
                
			for(Attachment objAttachment : lstAttachmentsOld){
				if(objAttachment.ParentId.getSObjectType() == Task.SobjectType){
					setIdTareas.add(objAttachment.ParentId);
				}
			}
              

            if(setIdTareas.isEmpty()){
				return;
			}
			
			lstTareas = [SELECT Id, whatid FROM Task WHERE Id IN :setIdTareas];
			mapTareas = new map<Id, Task>(lstTareas);
			
			for(Attachment objAttachment : lstAttachmentsOld){
				
					if(((mapTareas.get(objAttachment.ParentId)).whatid.getSObjectType() == Case.SobjectType)){
						objAttachment.addError('No puede eliminar el archivo por permisos de perfil.');
					}
				}
			
		} else{
			system.debug('.......... Es Administrador del Sistema');
		}
	}

	/*Fin 1.1*/    
}