/**
**************************************************************************************************************
* @company          Avanxo Colombia
* @author 			Antonio Torres href=<atorres@avanxo.com>
* @project          Compensar - Migración Lightning
* @name             MGLT_QueueManager_tst
* @description      Test class that covers the following classes/triggers:  MGLT_QueueManager_ctr
* @dependencies     MGLT_QueueManager_ctr
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------------
* @version   1.0   2019-12-23   Antonio Torres                Initial version.
**************************************************************************************************************
**/

@isTest
public class MGLT_QueueManager_tst {
    /**
    * @method      getActiveAgentsTest
    * @description Tests the method "getActiveAgents".
    * @author      Antonio Torres - 2019-12-23
    */
    @isTest public static void getActiveAgentsTest() {
        Test.startTest();
            MGLT_QueueManager_ctr.getActiveAgents();
        Test.stopTest();
    }

    /**
    * @method      getGroupsTest
    * @description Tests the method "getGroups".
    * @author      Antonio Torres - 2019-12-23
    */
    @isTest public static void getGroupsTest() {
        MGLT_QueueManager_ctr.AgentWrapper objAgentWrapper = new MGLT_QueueManager_ctr.AgentWrapper();
        MGLT_QueueManager_ctr.GroupWrapper objGroupWrapper = new MGLT_QueueManager_ctr.GroupWrapper();

        Test.startTest();
            MGLT_QueueManager_ctr.getGroups(new List<MGLT_QueueManager_ctr.AgentWrapper>{ new MGLT_QueueManager_ctr.AgentWrapper(UserInfo.getUserId(), UserInfo.getUserName()) });
        Test.stopTest();
    }

    /**
    * @method      upsertGroupMembersTest
    * @description Tests the method "upsertGroupMembers".
    * @author      Antonio Torres - 2019-12-23
    */
    @isTest public static void upsertGroupMembersTest() {
        MGLT_QueueManager_ctr.GroupResponseWrapper objGroupResponseWrapper = MGLT_QueueManager_ctr.getGroups(new List<MGLT_QueueManager_ctr.AgentWrapper>{ new MGLT_QueueManager_ctr.AgentWrapper(UserInfo.getUserId(), UserInfo.getUserName()) });

        // Clone existing group members because they will be removed and then reasigned.
        List<MGLT_QueueManager_ctr.GroupWrapper> lstGroupWrapperToRestore = new List<MGLT_QueueManager_ctr.GroupWrapper>();
        MGLT_QueueManager_ctr.GroupWrapper objGroupWrapperToCopy;
        for (MGLT_QueueManager_ctr.GroupWrapper objGroupWrapper : objGroupResponseWrapper.lstGroupWrapper) {
            lstGroupWrapperToRestore.add(objGroupWrapper);
            for (MGLT_QueueManager_ctr.GroupWrapper objGroupWrapperChild : objGroupWrapper.lstGroupWrapper) {
                objGroupWrapperToCopy = new MGLT_QueueManager_ctr.GroupWrapper(objGroupWrapperChild.strUniqueId, objGroupWrapperChild.strGroupId, objGroupWrapperChild.strGroupName, objGroupWrapperChild.intTotalAgentCount);
                objGroupWrapperToCopy.strAgentId     = objGroupWrapperChild.strAgentId;
                objGroupWrapperToCopy.strAgentName   = objGroupWrapperChild.strAgentName;
                lstGroupWrapperToRestore.add(objGroupWrapperToCopy);
            }
        }

        Test.startTest();
            // Delete current group members.
            MGLT_QueueManager_ctr.upsertGroupMembers(objGroupResponseWrapper.lstGroupWrapper, new List<MGLT_QueueManager_ctr.GroupWrapper> ());
            // Insert previously deleted group members.
            objGroupResponseWrapper = MGLT_QueueManager_ctr.getGroups(new List<MGLT_QueueManager_ctr.AgentWrapper>{ new MGLT_QueueManager_ctr.AgentWrapper(UserInfo.getUserId(), UserInfo.getUserName()) });
            MGLT_QueueManager_ctr.upsertGroupMembers(objGroupResponseWrapper.lstGroupWrapper, lstGroupWrapperToRestore);
        Test.stopTest();
    }
}