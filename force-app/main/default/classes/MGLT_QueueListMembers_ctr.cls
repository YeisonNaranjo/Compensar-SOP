/**
* Avanxo
* @author 			<a href = "mailto:cmosquera@avanxo.com">Cristian Jose Mosquera Puello </a>
* Project:			Compensar
* Description:		Clase encargada de administrar  las operaciones de Interfaz de usuarios para
*                   el componente de lista de miebros en colas.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		3/02/20		Cristian Mosquera (CM)		Implementación inicial de la clase.
**/
public without sharing class MGLT_QueueListMembers_ctr {

    /**
     * Metodo responsable de obtener la informacion de colas y usuarios.
     *
     * @return colas y usuarios
     */
    @AuraEnabled
    public static QueueResponseDTO getQueues() {

        Profile profileFound = [select id, Name from Profile where Id = :UserInfo.getProfileId()];
        QueueResponseDTO finalResponse = new QueueResponseDTO();
        Try {
            if (!'Administrador del sistema'.equals(profileFound.Name) && !'System Administrator'.equals(profileFound.Name) &&
                !'Gestor Servicio al Cliente PCA'.equals(profileFound.Name) ) {
                throw new COM_VinculacionClienteException('No tiene permisos suficientes para realizar esta funcion');
            }
            List<Group> lstQueues = [Select id, Name from Group where QueueRoutingConfigId != null order by Name];

            List<GroupMember> lstQueuesMembers = [Select Id, UserOrGroupId, GroupId from GroupMember where GroupId in :lstQueues];
            Map<String, List<User>> mapUsers = new Map<String, List<User>>();
            List<GroupMember> lstFinalQueuesMembers = new List<GroupMember>();
            Set<String> idsUsers = new Set<String>();
            for (GroupMember groupMemberIt : lstQueuesMembers) {
                Schema.sObjectType entityType = groupMemberIt.UserOrGroupId.getSObjectType();
                if (User.getSObjectType() == entityType) {
                    idsUsers.add(groupMemberIt.UserOrGroupId);
                    lstFinalQueuesMembers.add(groupMemberIt);
                }
            }

            Map<String, User> mapUsersByIds = new Map<String, User>([select Id, Name from User where id in :idsUsers]);

            for (GroupMember groupMemberIt : lstFinalQueuesMembers) {
                if (!mapUsers.containsKey(groupMemberIt.GroupId)) {
                    mapUsers.put(groupMemberIt.GroupId, new List<User>());
                }
                mapUsers.get(groupMemberIt.GroupId).add(mapUsersByIds.get(groupMemberIt.UserOrGroupId).clone(true));
            }

            finalResponse = new QueueResponseDTO(lstQueues, mapUsers);
        }
        catch (Exception e) {
            finalResponse.success = false;
            finalResponse.errorMessage = e.getMessage();
            System.debug('Error-->' + e.getMessage());
            System.debug('TracingError-->' + e.getStackTraceString());
        }
        return finalResponse;
    }

    /**
     * Clase que representa la respuesta general de las colas por usuairos.
     */
    public class QueueResponseDTO {


        public QueueResponseDTO () {

        }

        public QueueResponseDTO (List<Group> lstGroups, Map<String, List<User>> mapUsers) {
            this.lstQueues = new List<QueueDTO>();
            for (Group groupIt : lstGroups) {
                if (mapUsers.get(groupIt.Id) == null) {
                    continue;
                }
                mapUsers.get(groupIt.Id).sort();
                lstQueues.add(new QueueDTO(groupIt, mapUsers.get(groupIt.Id)));
            }
        }
        @AuraEnabled
        public List<QueueDTO> lstQueues {get; set;}
        @AuraEnabled
        public String errorMessage {get; set;}
        @AuraEnabled
        public Boolean success = true;
    }

    /**
     * Clase que define cada cola por usuario.
     */
    public class QueueDTO {
        @AuraEnabled
        public Group queue {get; set;}
        @AuraEnabled
        public List<User> lstUsers {get; set;}

        public QueueDTO (Group queue, List<User> lstUsers) {
            this.queue = queue;
            this.lstUsers = lstUsers;
        }

    }


}