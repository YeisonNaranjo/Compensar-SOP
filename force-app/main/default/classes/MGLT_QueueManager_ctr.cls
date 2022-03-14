/**
**************************************************************************************************************
* @company          Avanxo Colombia
* @author           Antonio Torres href=<atorres@avanxo.com>
* @project          Compensar - Migración Lightning
* @name             MGLT_QueueManager_ctr
* @description      Controller for the lightning component "MGLT_QueueManager_lcp".
* @dependencies     None
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------------
* @version   1.0   2019-12-11   Antonio Torres                Initial version.
**************************************************************************************************************
**/

public without sharing class MGLT_QueueManager_ctr {
    /**
    * @method       getActiveAgents
    * @description  Return the current active agents in omni channel.
    * @author       Antonio Torres - 2019-12-11
    */
    @AuraEnabled(cacheable = true)
    public static AgentResponseWrapper getActiveAgents() {
        AgentResponseWrapper objAgentResponseWrapper = new AgentResponseWrapper(
            !([ SELECT  Id
                FROM    PermissionSetAssignment
                WHERE   AssigneeId          = :UserInfo.getUserId()
                AND     PermissionSet.Name  =: Label.MGLT_GestorColasNombreConjuntoPermisos]).isEmpty()
        );

        if (objAgentResponseWrapper.blnIsAuthorized) {
            for(UserServicePresence objUserServicePresence : [  SELECT      UserId,
                                                                            User.Name
                                                                FROM        UserServicePresence
                                                                WHERE       IsCurrentState = true
                                                                ORDER BY    User.Name]) {
                objAgentResponseWrapper.lstAgentWrapper.add(new AgentWrapper(objUserServicePresence.UserId, objUserServicePresence.User.Name));
            }
        }

        return objAgentResponseWrapper;
    }

    /**
    * @method       getGroups
    * @description  Return the omnichannel groups (queues).
    * @author       Antonio Torres - 2019-12-17
    */
    @AuraEnabled(cacheable = false)
    public static GroupResponseWrapper getGroups(List<AgentWrapper> lstAgentWrapper) {
        GroupResponseWrapper objGroupResponseWrapper = new GroupResponseWrapper();

        Set<String> setAgentId = getAgentIds(lstAgentWrapper);

        GroupWrapper objGroupWrapper;
        GroupWrapper objGroupWrapperChild;
        for(Group objGroup : [  SELECT      Id,
                                            Name,
                                            (   SELECT  Id,
                                                        UserOrGroupId
                                                FROM    GroupMembers
                                                WHERE   UserOrGroupId IN: setAgentId)
                                FROM        Group
                                WHERE       QueueRoutingConfigId != null
                                ORDER BY    Name]) {
            objGroupWrapper = new GroupWrapper(objGroup.Id, objGroup.Id, objGroup.Name, lstAgentWrapper.size());
            for (AgentWrapper objAgentWrapper : lstAgentWrapper) {
                objGroupWrapperChild = new GroupWrapper(objGroup.Id + '-' + objAgentWrapper.strAgentId, objGroup.Id, '', null);
                objGroupWrapperChild.strAgentId         = objAgentWrapper.strAgentId;
                objGroupWrapperChild.strAgentName       = objAgentWrapper.strAgentName;
                objGroupWrapperChild.lstGroupWrapper    = null;

                for (GroupMember objGroupMember : objGroup.GroupMembers) {
                    if (objGroupMember.UserOrGroupId.equals(objAgentWrapper.strAgentId)) {
                        objGroupWrapperChild.strGroupMemberId = objGroupMember.Id;
                        objGroupWrapper.intSelectedAgentCount++;

                        // Set the child agent as selected
                        objGroupResponseWrapper.lstSelectedRows.add(objGroupWrapperChild.strUniqueId);
                        if(!objGroupResponseWrapper.lstSelectedRows.contains(objGroupWrapper.strUniqueId)){
                            objGroupResponseWrapper.lstSelectedRows.add(objGroupWrapper.strUniqueId);
                        }
						
                        /*if (objGroupWrapper.intSelectedAgentCount == objGroupWrapper.intTotalAgentCount) {
                            // Set the group as selected because all it's agents are selected
                            objGroupResponseWrapper.lstSelectedRows.add(objGroupWrapper.strUniqueId);
                        }*/

                        break;
                    }
                }
                objGroupWrapper.lstGroupWrapper.add(objGroupWrapperChild);
            }
            objGroupWrapper.strAgentName = objGroupWrapper.intSelectedAgentCount + ' de ' + objGroupWrapper.intTotalAgentCount + ' agentes seleccionados';
            objGroupResponseWrapper.lstGroupWrapper.add(objGroupWrapper);
        }

        return objGroupResponseWrapper;
    }

    /**
    * @method       getAgentIds
    * @description  Return the agent ids inside the agent wrappers.
    * @author       Antonio Torres - 2019-12-19
    */
    private static Set<String> getAgentIds(List<AgentWrapper> lstAgentWrapper) {
        Set<String> setAgentId = new Set<String>();

        if (lstAgentWrapper != null) {
            for (AgentWrapper objAgentWrapper : lstAgentWrapper) {
                setAgentId.add(objAgentWrapper.strAgentId);
            }
        }

        return setAgentId;
    }

    /**
    * @method       upsertGroupMembers
    * @description  Create or update group members according to user selections.
    * @author       Antonio Torres - 2019-12-19
    */
    @AuraEnabled(cacheable = false)
    public static void upsertGroupMembers(List<GroupWrapper> lstGroupWrapper, List<GroupWrapper> lstGroupWrapperSelected) {
        // Set that store existing group members that are still checked. It will help to check which group members needs to be deleted
        Set<String> setSelectedExistingGroupMemberIds = new Set<String>();

        // Set that store the ids of the users that will be notified because their asignations were modified
        Set<String> setUserId = new Set<String>();

        // Insert new queue-user assignments
        List<GroupMember> lstGroupMemberToInsert = new List<GroupMember>();
        for (GroupWrapper objGroupWrapper : lstGroupWrapperSelected) {
            if (objGroupWrapper.strGroupId != null && objGroupWrapper.strAgentId != null && objGroupWrapper.strGroupMemberId == null) {
                lstGroupMemberToInsert.add(new GroupMember( GroupId         = objGroupWrapper.strGroupId,
                                                            UserOrGroupId   = objGroupWrapper.strAgentId));
                setUserId.add(objGroupWrapper.strAgentId);
            } else if (objGroupWrapper.strGroupMemberId != null) {
                setSelectedExistingGroupMemberIds.add(objGroupWrapper.strGroupMemberId);
            }
        }
        insert lstGroupMemberToInsert;

        // Delete removed queue-user assignments
        List<GroupMember> lstGroupMemberToDelete = new List<GroupMember>();
        // Loop level 1 - Queues
        for (GroupWrapper objGroupWrapper : lstGroupWrapper) {
            // Loop level 2 - Agents
            for (GroupWrapper objGroupWrapperChild : objGroupWrapper.lstGroupWrapper) {
                // Check if an existing group-member was deselected in order to delete it
                if (objGroupWrapperChild.strGroupMemberId != null && !setSelectedExistingGroupMemberIds.contains(objGroupWrapperChild.strGroupMemberId)) {
                    lstGroupMemberToDelete.add(new GroupMember(Id = objGroupWrapperChild.strGroupMemberId));
                    setUserId.add(objGroupWrapperChild.strAgentId);
                }
            }
        }
        delete lstGroupMemberToDelete;

        sendNotifications(setUserId);
    }

    /**
    * @method       sendNotifications
    * @description  Creates the platform events that allow sending the notifications to the agents.
    * @author       Antonio Torres - 2019-12-20
    */
    private static void sendNotifications(Set<String> setUserId) {
        // Store the notification platform events that will be sent to the agents whose asignations were modified
        List<MGLT_GestorColas__e> lstGestorColasEvent = new List<MGLT_GestorColas__e>();

        for (String strUserId : setUserId) {
            lstGestorColasEvent.add(new MGLT_GestorColas__e(MGLT_IdUsuario__c = strUserId));
        }

        // Call method to publish events
        List<Database.SaveResult> lstSaveResult = EventBus.publish(lstGestorColasEvent);
        System.debug('\n\n-=#=-   ' + 'lstSaveResult' + ': ' + lstSaveResult + '\n');

        String strErrorMessage;
        Integer i = 0;
        for (MGLT_GestorColas__e objGestorColas : lstGestorColasEvent) {
            strErrorMessage = '';

            if (!lstSaveResult[i].isSuccess()) {
                for (Database.Error objError : lstSaveResult[i].getErrors()) strErrorMessage += (objError.getStatusCode() + ' - ' + objError.getMessage() + ', ');
                System.debug('\n\n-=#=-   ' + 'Error al notificar al usuario "' + objGestorColas.MGLT_IdUsuario__c + '": ' + strErrorMessage.removeEnd(', ') + '\n');
            }
            i++;
        }
    }

    /**
    * @class        AgentResponseWrapper
    * @description  Wrapper class to send the agent query response to the ui
    * @author       Antonio Torres - 2019-12-11
    */
    public class AgentResponseWrapper {
        @AuraEnabled
        public Boolean blnIsAuthorized                  { get; set; }
        @AuraEnabled
        public List<AgentWrapper> lstAgentWrapper       { get; set; }

        public AgentResponseWrapper(Boolean blnIsAuthorized) {
            this.blnIsAuthorized    = blnIsAuthorized;
            this.lstAgentWrapper    = new List<AgentWrapper>();
        }
    }

    /**
    * @class        AgentWrapper
    * @description  Wrapper class to store the agent's info
    * @author       Antonio Torres - 2019-12-11
    */
    public class AgentWrapper {
        @AuraEnabled
        public String strAgentId                { get; set; }
        @AuraEnabled
        public String strAgentName              { get; set; }

        public AgentWrapper() {}

        public AgentWrapper(String strAgentId, String strAgentName) {
            this.strAgentId         = strAgentId;
            this.strAgentName       = strAgentName;
        }
    }

    /**
    * @class        GroupResponseWrapper
    * @description  Wrapper class to send the group query response to the ui
    * @author       Antonio Torres - 2019-12-17
    */
    public class GroupResponseWrapper {
        @AuraEnabled
        public List<GroupWrapper> lstGroupWrapper                   { get; set; }
        @AuraEnabled
        public List<String> lstSelectedRows                         { get; set; }

        public GroupResponseWrapper() {
            this.lstGroupWrapper    = new List<GroupWrapper>();
            this.lstSelectedRows    = new List<String>();
        }
    }

    /**
    * @class        GroupWrapper
    * @description  Wrapper class to store the group info
    * @author       Antonio Torres - 2019-12-17
    */
    public class GroupWrapper {
        @AuraEnabled
        public String strUniqueId                                   { get; set; }
        @AuraEnabled
        public String strGroupId                                    { get; set; }
        @AuraEnabled
        public String strGroupName                                  { get; set; }
        @AuraEnabled
        public String strGroupMemberId                              { get; set; }
        @AuraEnabled
        public String strAgentId                                    { get; set; }
        @AuraEnabled
        public String strAgentName                                  { get; set; }
        @AuraEnabled
        public Integer intTotalAgentCount                           { get; set; }
        @AuraEnabled
        public Integer intSelectedAgentCount                        { get; set; }
        @AuraEnabled
        public List<GroupWrapper> lstGroupWrapper                   { get; set; }

        public GroupWrapper() {}

        public GroupWrapper(String strUniqueId, String strGroupId, String strGroupName, Integer intTotalAgentCount) {
            this.strUniqueId            = strUniqueId;
            this.strGroupId             = strGroupId;
            this.strGroupName           = strGroupName;
            this.intTotalAgentCount     = intTotalAgentCount;
            this.intSelectedAgentCount  = intTotalAgentCount == null ? null : 0;
            this.lstGroupWrapper        = new List<GroupWrapper>();
        }
    }
}