<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Canceled_Product_Alert</fullName>
        <description>Canceled Product Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Email_Distro_Product_Cancellation</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Fulfillment/CanceledProjectAlertv2</template>
    </alerts>
    <alerts>
        <fullName>Fullfilled_Non_Renewal_Product_Alert</fullName>
        <description>Fullfilled Non-Renewal Product Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Email_Distro_Product_Cancellation</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>brianna.holloway@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.caldie@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/FulfilledNRProjectAlert</template>
    </alerts>
    <alerts>
        <fullName>Waiting_Status_Alert_7_14_21_49</fullName>
        <description>Waiting Status Alert 7-14-21-49</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Digital_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Project_Email_Templates/WaitingProjectStatusAlertv1</template>
    </alerts>
    <alerts>
        <fullName>Waiting_Status_Alert_7_14_21_49_Initial</fullName>
        <description>Waiting Status Alert 7-14-21-49 Initial</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Digital_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Project_Email_Templates/WaitingProjectStatusAlertv2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Awaiting_Client_Approval_Out_Stamp</fullName>
        <description>Set Out stamp to Now() when the status changes to something else</description>
        <field>In_Waiting_Approval_Out_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Awaiting Client Approval Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Closed_Won_Out_Stamp</fullName>
        <description>Clear Closed Won Out Stamp</description>
        <field>In_Closed_Won_Out_Stamp__c</field>
        <name>Clear Closed Won Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notice_0_Send</fullName>
        <field>Send_Delayed_Notice__c</field>
        <literalValue>Notice 0</literalValue>
        <name>Notice 0 Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notice_1_Send</fullName>
        <field>Send_Delayed_Notice__c</field>
        <literalValue>Notice 1</literalValue>
        <name>Notice 1 Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notice_2_Send</fullName>
        <field>Send_Delayed_Notice__c</field>
        <literalValue>Notice 2</literalValue>
        <name>Notice 2 Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notice_3_Send</fullName>
        <field>Send_Delayed_Notice__c</field>
        <literalValue>Notice 3</literalValue>
        <name>Notice 3 Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notice_4_Send</fullName>
        <field>Send_Delayed_Notice__c</field>
        <literalValue>Notice 4</literalValue>
        <name>Notice 4 Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Closed_Won_Stamp</fullName>
        <description>Set Closed Won Stamp to Now()</description>
        <field>In_Closed_Won_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Set Closed Won Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AwaitingOnBoard_Stamp</fullName>
        <field>In_Awaiting_Onboard_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update AwaitingOnBoard Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Awaiting_Approval_Out_Stamp_clear</fullName>
        <description>Clear the Out timestamp when the status comes back into this one</description>
        <field>In_Waiting_Approval_Out_Stamp__c</field>
        <name>Update Awaiting Approval Out Stamp clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Awaiting_Client_Approval_Stamp</fullName>
        <description>Update the in timestamp to Now()</description>
        <field>In_Waiting_Approval_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update Awaiting Client Approval Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Awaiting_Onboard_Out_Stamp</fullName>
        <field>In_Awaiting_Onboard_Out_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update Awaiting Onboard Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Awaiting_Onboard_Out_Stamp_Clear</fullName>
        <field>In_Awaiting_Onboard_Out_Stamp__c</field>
        <name>Update Awaiting Onboard Out Stamp Clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Won_Out_Stamp</fullName>
        <description>Sets Out Stamp to NOW()</description>
        <field>In_Closed_Won_Out_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update Closed Won Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_InFulfillment_Out_Stamp</fullName>
        <field>In_Fulfillment_Out_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update InFulfillment Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_InFulfillment_Stamp</fullName>
        <field>In_Fulfillment_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update InFulfillment Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Out_Stamp</fullName>
        <field>In_Pending_Out_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Stamp</fullName>
        <field>In_Pending_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update Pending Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Change_From_Won_Date</fullName>
        <field>Last_Status_Change_From_Won_Date__c</field>
        <formula>NOW() -  Opportunity__r.Closed_Won_Time_Stamp__c</formula>
        <name>Update Status Change From Won Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_WaitingResource_Stamp</fullName>
        <field>In_Waiting_Resource_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update WaitingResource Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiting_Resource_Out_Stamp</fullName>
        <field>In_Waiting_Resource_Out_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Update Waiting Resource Out Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Canceled Project Alert</fullName>
        <actions>
            <name>Canceled_Product_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( CONTAINS(Project_Status__c, &quot;Cancel&quot;), Opportunity__r.Opportunity_IsReplicated__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delayed Status Alert Client Approval</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_2_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_7__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_3_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_7__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_4_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_7__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_0_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_1_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_3__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Delayed Status Alert Client Resource</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Resource</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_4_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_7__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_3_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_7__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_0_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_1_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_3__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notice_2_Send</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project__c.Status_Bus_Days_7__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Fulfilled Non-Renewal Project Alert</fullName>
        <actions>
            <name>Fullfilled_Non_Renewal_Product_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( Project_Status__c = &quot;Fulfilled Non-Renewal&quot;,  Opportunity__r.Opportunity_IsReplicated__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Awaiting Client Approval Out Stamp</fullName>
        <actions>
            <name>Awaiting_Client_Approval_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Timestamp when a project leaves this status</description>
        <formula>AND(PRIORVALUE( Project_Status__c ) = &quot;Waiting On Client Approval&quot;,NOT(Project_Status__c=&quot;Waiting On Client Approval&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Awaiting Client Approval Stamp</fullName>
        <actions>
            <name>Update_Awaiting_Approval_Out_Stamp_clear</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Awaiting_Client_Approval_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Approval</value>
        </criteriaItems>
        <description>Update the Timestamp when a project enters the Awaiting Client Approval status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Awaiting Onboard Out Stamp</fullName>
        <actions>
            <name>Update_Awaiting_Onboard_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(PRIORVALUE( Project_Status__c ) = &quot;Awaiting Onboard&quot;,NOT(Project_Status__c=&quot;Awaiting Onboard&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update AwaitingOnBoard Stamp</fullName>
        <actions>
            <name>Update_AwaitingOnBoard_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Awaiting_Onboard_Out_Stamp_Clear</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Onboard</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed Won Out Stamp</fullName>
        <actions>
            <name>Update_Closed_Won_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>updates the project.In_Closed_Won_Stamp when the Project Status changes from &quot;Closed Won&quot; to anything else</description>
        <formula>PRIORVALUE( Project_Status__c ) = &quot;Closed Won&quot; &amp;&amp; Project_Status__c != &quot;Closed Won&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed Won Stamp</fullName>
        <actions>
            <name>Clear_Closed_Won_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Closed_Won_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>updates the project.In_Closed_Won_Stamp when the status changes to &quot;Closed Won&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update InFulfillment Out Stamp</fullName>
        <actions>
            <name>Update_InFulfillment_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(PRIORVALUE( Project_Status__c ) = &quot;In Fulfillment&quot;,NOT(Project_Status__c=&quot;In Fulfillment&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update InFulfillment Stamp</fullName>
        <actions>
            <name>Update_InFulfillment_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>In Fulfillment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Pending Out Stamp</fullName>
        <actions>
            <name>Update_Pending_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(PRIORVALUE( Project_Status__c ) = &quot;Pending&quot;,NOT(Project_Status__c=&quot;Pending&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Pending Stamp</fullName>
        <actions>
            <name>Update_Pending_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Change From Won Date</fullName>
        <actions>
            <name>Update_Status_Change_From_Won_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Project_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Waiting Resource Out Stamp</fullName>
        <actions>
            <name>Update_Waiting_Resource_Out_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(PRIORVALUE( Project_Status__c ) = &quot;Waiting On Client Resource&quot;,NOT(Project_Status__c=&quot;Waiting On Client Resource&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update WaitingResource Stamp</fullName>
        <actions>
            <name>Update_WaitingResource_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Project_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Resource</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
