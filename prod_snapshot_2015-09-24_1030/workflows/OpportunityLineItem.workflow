<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DigFul_InFulfillment_Notice</fullName>
        <description>DigFul - InFulfillment Notice</description>
        <protected>false</protected>
        <recipients>
            <field>Add_Notice_1__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Add_Notice_2__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Add_Notice_3__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Dig_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/InFulfillmentStatusAlertToNotifiesRepDigAM</template>
    </alerts>
    <alerts>
        <fullName>Digital_Late_Live_Alert10Days</fullName>
        <description>Digital Late Live Alert 10 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Dig_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Opp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/DigDelayedLive10Days</template>
    </alerts>
    <alerts>
        <fullName>Digital_Late_Live_Alert15DaysDays</fullName>
        <description>Digital Late Live Alert15Days</description>
        <protected>false</protected>
        <recipients>
            <field>Dig_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Opp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/DigDelayedLive15Days</template>
    </alerts>
    <alerts>
        <fullName>Digital_Late_Live_Alert_10Days</fullName>
        <description>Digital Late Live Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Opp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/DigDelayedLive10Days</template>
    </alerts>
    <alerts>
        <fullName>Finance_Notification_Status_change_from_Paused_Billing_To_Live</fullName>
        <description>Finance Notification - Status change from Paused:Billing To Live</description>
        <protected>false</protected>
        <recipients>
            <recipient>Finance_Accounting</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Finance_Notification_Paused_Billing_To_Live</template>
    </alerts>
    <alerts>
        <fullName>Finance_Notification_Status_change_from_Paused_No_Contract_To_Live</fullName>
        <description>Finance Notification - Status change from Paused:No Contract To Live</description>
        <protected>false</protected>
        <recipients>
            <recipient>Finance_Accounting</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Finance_Notification_Paused_No_Contract_To_Live</template>
    </alerts>
    <alerts>
        <fullName>Live_Date_Back_Dated</fullName>
        <description>Live Date Back Dated</description>
        <protected>false</protected>
        <recipients>
            <recipient>Team_Finance</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Live_Date_PreDated_Alert</template>
    </alerts>
    <alerts>
        <fullName>New_Onboard_Alert</fullName>
        <description>New Onboard Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Email_Alert_New_Onboard_Alert</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/AfflRepNoticeDigAMAssignedAwaitingOnboard</template>
    </alerts>
    <alerts>
        <fullName>Setup_Fee_List_Variance</fullName>
        <description>Setup Fee List Variance</description>
        <protected>false</protected>
        <recipients>
            <recipient>SalesManagers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Setup_Fee_List_Variance</template>
    </alerts>
    <alerts>
        <fullName>Tier_1_Facebook_Ads_Closed_Won</fullName>
        <description>Tier 1 Facebook Ads Closed Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Tier_1_FB_Ads</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Fulfillment/Tier_1_FB_Ads_Closed_Won</template>
    </alerts>
    <alerts>
        <fullName>Tier_1_PPC_Closed_Won</fullName>
        <description>Tier 1 PPC Closed Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Tier_1_PPC</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Fulfillment/Tier_1_PPC_Closed_Won</template>
    </alerts>
    <alerts>
        <fullName>X8K_PPC_Alert</fullName>
        <description>8K PPC Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>aspilburg@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kent.pearce@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lisa.hannigan@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Email_Templates/X8K_PPC_Alert</template>
    </alerts>
    <alerts>
        <fullName>iSales_Opp_Prod_Hesse</fullName>
        <description>iSales Opp Prod (Hesse)</description>
        <protected>false</protected>
        <recipients>
            <recipient>iSales_Hesse</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Opp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/iSales_Opp_Prod_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>iSales_Opp_Prod_Kurland</fullName>
        <description>iSales Opp Prod (Kurland)</description>
        <protected>false</protected>
        <recipients>
            <recipient>iSales_Kurland</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Opp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/iSales_Opp_Prod_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>iSales_Opp_Prod_Van_Horne</fullName>
        <description>iSales Opp Prod (Van Horne)</description>
        <protected>false</protected>
        <recipients>
            <recipient>iSales_Van_Horne</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Opp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/iSales_Opp_Prod_Status_Changed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Digiful_Waiting_Status_Set_End_Date</fullName>
        <field>Status_Last_Waiting_UnSet_Date__c</field>
        <formula>Now()</formula>
        <name>Digiful Waiting Status - Set End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fulfilled_Complete_Time_Stamp</fullName>
        <field>Fulfilled_Date__c</field>
        <formula>NOW()</formula>
        <name>Fulfilled Complete Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fulfilled_NonRenewed_Time_Stamp</fullName>
        <field>Fulfilled_Date__c</field>
        <formula>NOW()</formula>
        <name>Fulfilled NonRenewed Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fulfilled_Renewed_Time_Stamp</fullName>
        <field>Fulfilled_Date__c</field>
        <formula>NOW()</formula>
        <name>Fulfilled Renewed Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InStatus_SetTotTime_AwaitingOnBoard</fullName>
        <field>InStatus_Awaiting_OnBoard__c</field>
        <formula>IF(ISBLANK( InStatus_Awaiting_OnBoard__c ),0,
(InStatus_Awaiting_OnBoard__c ) + ((NOW() - InStatus_TimeIn__c)*1440)
)</formula>
        <name>InStatus SetTotTime AwaitingOnBoard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InStatus_SetTotTime_Pending</fullName>
        <field>InStatus_Pending__c</field>
        <formula>IF( 
ISBLANK(InStatus_Pending__c),0, 
(InStatus_Pending__c) + ((NOW() - InStatus_TimeIn__c)*1440)
)</formula>
        <name>InStatus SetTotTime Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InStatus_SetTotTime_WaitingApproval</fullName>
        <field>InStatus_WaitingApproval__c</field>
        <formula>IF(
ISBLANK(InStatus_WaitingApproval__c ),0,
((InStatus_WaitingApproval__c) + (NOW() - InStatus_TimeIn__c)*1440)
)</formula>
        <name>InStatus SetTotTime WaitingApproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InStatus_SetTotTime_WaitingResource</fullName>
        <field>InStatus_WaitingResource__c</field>
        <formula>IF( 
ISBLANK(InStatus_WaitingResource__c),0, 
(InStatus_WaitingResource__c) + ((NOW() - InStatus_TimeIn__c)*1440) 
)</formula>
        <name>InStatus SetTotTime WaitingResource</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InStatus_Set_Time_In</fullName>
        <field>InStatus_TimeIn__c</field>
        <formula>NOW()</formula>
        <name>InStatus Set Time In</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InStatus_SettotTime_InFulfillment</fullName>
        <description>(1 + InStatus_In_Fulfillment__c)  + (NOW() - InStatus_TimeIn__c)</description>
        <field>InStatus_In_Fulfillment__c</field>
        <formula>IF(ISBLANK(InStatus_In_Fulfillment__c),0,
(InStatus_In_Fulfillment__c)  + ((NOW() - InStatus_TimeIn__c)*1440)
)</formula>
        <name>InStatus SettotTime InFulfillment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Live_Set_Tracking_Value</fullName>
        <field>Live_Last_Set_Value__c</field>
        <formula>Live_Date__c</formula>
        <name>Last Live Set Tracking Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Live_Set_Tracking_Person</fullName>
        <field>Live_Last_Set_Person__c</field>
        <formula>&quot;Set By &quot; &amp; $User.FirstName &amp; &quot; &quot; &amp;  $User.LastName</formula>
        <name>Live Set Tracking Person</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Live_Set_Update_Date</fullName>
        <field>Live_Last_Set_DateTime__c</field>
        <formula>Now()</formula>
        <name>Live Set Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Live_Set_Update_Last</fullName>
        <field>Live_Last_Set_Prev_Val__c</field>
        <formula>PRIORVALUE( Live_Date__c )</formula>
        <name>Live Set Update Last</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_P_or_C_Date_Clear</fullName>
        <field>Product_PorC_Date__c</field>
        <name>Product P or C Date Clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_P_or_C_Date_update</fullName>
        <field>Product_PorC_Date__c</field>
        <formula>TODAY()</formula>
        <name>Product P or C Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_Status_Pending_Delay_Reset_Rsrc</fullName>
        <field>Waiting_Status__c</field>
        <literalValue>Waiting On Client Resource</literalValue>
        <name>Project Status Pending Delay-Reset Rsrc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_Status_Pending_Delay_RstAppr</fullName>
        <field>Waiting_Status__c</field>
        <literalValue>Waiting On Client Approval</literalValue>
        <name>Project Status Pending Delay-Reset Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Include_in_Monthly_Total_to_False</fullName>
        <description>Set Include in Monthly Total checkbox to False</description>
        <field>chk_Include_in_Monthly__c</field>
        <literalValue>0</literalValue>
        <name>Set Include in Monthly Total to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Setup_Fee_Checked_for_Setup_Fee</fullName>
        <description>Toggle that check True the &quot;Setup Fee&quot; when a Setup Fee product is added</description>
        <field>Setup_Fee__c</field>
        <literalValue>1</literalValue>
        <name>Setup Fee Checked for Setup Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Setup_Fee_Checker_Toggle</fullName>
        <field>Setup_Fee_Required__c</field>
        <literalValue>1</literalValue>
        <name>Setup Fee Checker Toggle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Canceled_Set_If_Needed</fullName>
        <field>Canceled__c</field>
        <literalValue>1</literalValue>
        <name>Update - Canceled Set If Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Include_Monthly</fullName>
        <description>Updates Include in Monthly Check box to true</description>
        <field>chk_Include_in_Monthly__c</field>
        <literalValue>1</literalValue>
        <name>Update Include Monthly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Live_Checkbox_On_Status_Live</fullName>
        <field>Live__c</field>
        <literalValue>1</literalValue>
        <name>Update Live Checkbox On Status Live</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Live_DateTime</fullName>
        <field>Live_Date__c</field>
        <formula>Now()</formula>
        <name>Update Live DateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Setup_Fee</fullName>
        <field>Setup_Fee_Amt__c</field>
        <formula>Product2.Setup_Fee__c</formula>
        <name>Update Setup Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiting_Status_To_Cancelled</fullName>
        <field>Waiting_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Update_Waiting_Status_To_Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Waiting_Status_To_HardCancel</fullName>
        <field>Waiting_Status__c</field>
        <literalValue>Hard Cancel</literalValue>
        <name>Update_Waiting_Status_To_HardCancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Descr_Set_On_Opp</fullName>
        <field>Waiting_Status_Descr_Last_Set__c</field>
        <formula>Waiting_Status_Descr__c</formula>
        <name>Waiting Status Descr - Set On Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Last_Set_Date</fullName>
        <field>Waiting_Status_Last_Set_Date__c</field>
        <formula>NOW()</formula>
        <name>Waiting Status Last Set Date-OnOpp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Set_Check</fullName>
        <field>Status_Waiting_Check__c</field>
        <literalValue>1</literalValue>
        <name>Waiting Status - Set Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Set_Date</fullName>
        <field>Status_Last_Waiting_Set_Date__c</field>
        <formula>Now()</formula>
        <name>Waiting Status - Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Set_On_Opp_ClAppr</fullName>
        <field>Waiting_Status_Last_Set__c</field>
        <literalValue>Waiting On Client Approval</literalValue>
        <name>Waiting Status - Set On Opp - Cl Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Set_On_Opp_Cl_Rsrc</fullName>
        <field>Waiting_Status_Last_Set__c</field>
        <literalValue>Waiting On Client Resource</literalValue>
        <name>Waiting Status - Set On Opp - Cl Rsrc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Set_On_Opp_Live</fullName>
        <field>Waiting_Status_Last_Set__c</field>
        <literalValue>Live</literalValue>
        <name>Waiting Status - Set On Opp - Live</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_UnSet_Date</fullName>
        <field>Status_Last_Waiting_UnSet_Date__c</field>
        <name>Waiting Status - UnSet Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_Status_Update</fullName>
        <field>Waiting_Status__c</field>
        <literalValue>Live</literalValue>
        <name>Waiting Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>KPI_Monthly_Bill</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/mon_rec_rev</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>TotalPrice</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>neil.wingate@gannett.com</integrationUser>
        <name>KPI - Monthly Bill</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Neil</fullName>
        <apiVersion>25.0</apiVersion>
        <endpointUrl>http://www.neil.com</endpointUrl>
        <fields>Id</fields>
        <fields>Opp_Product_Id__c</fields>
        <fields>Setup_Fee_Required__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>gl.system@gannett.com</integrationUser>
        <name>Neil</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>8K PPC Alert</fullName>
        <actions>
            <name>X8K_PPC_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.UnitPrice</field>
            <operation>greaterThan</operation>
            <value>7999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Product_Name__c</field>
            <operation>contains</operation>
            <value>ppc,PPC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Awaiting Onboard Alert</fullName>
        <actions>
            <name>New_Onboard_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Onboard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ClearPorCDate</fullName>
        <actions>
            <name>Product_P_or_C_Date_Clear</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>notEqual</operation>
            <value>Paused:Billing,Paused:No Contact,Cancelled,Hard Cancel</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delete - Status Alert - Client Approval - GL %26 Affl</fullName>
        <actions>
            <name>Waiting_Status_Descr_Set_On_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Last_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_On_Opp_ClAppr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Digital Fulfillment,SML Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delete - Status Alert - Client Resource - GL %26 Affl</fullName>
        <actions>
            <name>Waiting_Status_Descr_Set_On_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Last_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_On_Opp_Cl_Rsrc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Resource</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Digital Fulfillment,SML Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delete - Status Alert - Update Notes</fullName>
        <actions>
            <name>Waiting_Status_Descr_Set_On_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Waiting_Status_Descr__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DigFul - Waiting Status Set End Date</fullName>
        <actions>
            <name>Digiful_Waiting_Status_Set_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>notEqual</operation>
            <value>Waiting On Client Resource,Waiting On Client Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Status_Last_Waiting_Set_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Status_Last_Waiting_UnSet_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Digital Live Delayed Alert 10 %26 15 Bus Days</fullName>
        <active>true</active>
        <formula>AND( ISPICKVAL(Opportunity.StageName,&quot;Closed Won&quot;), AND( NOT(ISPICKVAL(Waiting_Status__c,&quot;Fulfilled&quot;)), NOT(ISPICKVAL(Waiting_Status__c,&quot;Fulfilled Non-Renewal&quot;)), NOT(ISPICKVAL(Waiting_Status__c,&quot;Fulfilled Renewed&quot;)), NOT(ISPICKVAL(Waiting_Status__c,&quot;Fulfilled Ineligible-Renewal&quot;)), NOT(ISPICKVAL(Waiting_Status__c,&quot;Live&quot;)), NOT(ISPICKVAL(Waiting_Status__c,&quot;Cancelled&quot;))), Digital_Product__c = &quot;Yes&quot;, Opportunity.Opportunity_IsReplicated__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Digital_Late_Live_Alert15DaysDays</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>OpportunityLineItem.Bus_Days_10__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Digital_Late_Live_Alert10Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>OpportunityLineItem.Bus_Days_10__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Finance Notification - Status change from Paused%3ABilling To Live</fullName>
        <actions>
            <name>Finance_Notification_Status_change_from_Paused_Billing_To_Live</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Rule to email &apos;Finance - Accounting&apos; group when the status changes from Paused:Billing to Live.</description>
        <formula>ISPICKVAL(PRIORVALUE(Waiting_Status__c), &quot;Paused:Billing&quot;) &amp;&amp; ISPICKVAL(Waiting_Status__c, &quot;Live&quot;)  &amp;&amp; Opportunity.RecordTypeId = &quot;012A0000000PKOI&quot; &amp;&amp; Opportunity.Opportunity_IsReplicated__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Finance Notification - Status change from Paused%3ANo Contract To Live</fullName>
        <actions>
            <name>Finance_Notification_Status_change_from_Paused_No_Contract_To_Live</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Rule to email &apos;Finance - Accounting&apos; group when the status changes from Paused::No Contract to Live.</description>
        <formula>ISPICKVAL(PRIORVALUE(Waiting_Status__c), &quot;Paused:No Contact&quot;) &amp;&amp;ISPICKVAL(Waiting_Status__c, &quot;Live&quot;) &amp;&amp;   Opportunity.RecordTypeId = &quot;012A0000000PKOI&quot; &amp;&amp;  Opportunity.Opportunity_IsReplicated__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fulfilled Complete Time Stamp</fullName>
        <actions>
            <name>Fulfilled_Complete_Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Fulfilled-Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fulfilled NonRenewed Time Stamp</fullName>
        <actions>
            <name>Fulfilled_NonRenewed_Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Fulfilled Non-Renewal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fulfilled Renewed Time Stamp</fullName>
        <actions>
            <name>Fulfilled_Renewed_Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Fulfilled Renewed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>InStatus Set Time In</fullName>
        <actions>
            <name>InStatus_Set_Time_In</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($User.LastName=&quot;Local&quot;),
OR(
ISCHANGED( InStatus_Awaiting_OnBoard__c),
ISCHANGED( InStatus_WaitingResource__c),
ISCHANGED( InStatus_Pending__c),
ISCHANGED(InStatus_In_Fulfillment__c),
ISCHANGED(InStatus_WaitingApproval__c),
AND(NOT(ISPICKVAL(Waiting_Status__c,&quot;&quot;)),ISBLANK( InStatus_TimeIn__c)))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InStatus SetTime AwaitingOnBoard</fullName>
        <actions>
            <name>InStatus_SetTotTime_AwaitingOnBoard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
PRIORVALUE(Status_Text__c)=&quot;Awaiting Onboard&quot;,
NOT(Status_Text__c=&quot;Awaiting Onboard&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InStatus SetTime ClientApproval</fullName>
        <actions>
            <name>InStatus_SetTotTime_WaitingApproval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
PRIORVALUE(Status_Text__c)=&quot;Waiting On Client Approval&quot;, 
NOT(Status_Text__c=&quot;Waiting On Client Approval&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InStatus SetTime In Fulfillment</fullName>
        <actions>
            <name>InStatus_SettotTime_InFulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
PRIORVALUE(Status_Text__c)=&quot;In Fulfillment&quot;,
NOT(Status_Text__c=&quot;In Fulfillment&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InStatus SetTime Pending</fullName>
        <actions>
            <name>InStatus_SetTotTime_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
PRIORVALUE(Status_Text__c)=&quot;Pending&quot;,
NOT(Status_Text__c=&quot;Pending&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InStatus SetTime WaitingResource</fullName>
        <actions>
            <name>InStatus_SetTotTime_WaitingResource</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
PRIORVALUE(Status_Text__c)=&quot;Waiting On Client Resource&quot;,
NOT(Status_Text__c=&quot;Waiting On Client Resource&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Live Date Pre-Dated Alert</fullName>
        <actions>
            <name>Live_Date_Back_Dated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Live_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Live_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>YESTERDAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Live Set Tracking</fullName>
        <actions>
            <name>Last_Live_Set_Tracking_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Live_Set_Tracking_Person</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Live_Set_Update_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Live_Set_Update_Last</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Live_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityProduct Waiting Status Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.ReferenceID_OriginalNewSell__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Sell_Type__c</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Waiting_Status_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>OpportunityLineItem.Invoice_ServiceStartDate__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Product P or C Date Populate</fullName>
        <actions>
            <name>Product_P_or_C_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Paused:Billing,Paused:No Contact,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Project Status Pending Delay</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Product_Name__c</field>
            <operation>equals</operation>
            <value>Email Blast</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.ServiceDate</field>
            <operation>greaterThan</operation>
            <value>NEXT 30 DAYS</value>
        </criteriaItems>
        <description>Update The Opp Product Status to &apos;Waiting On Client Approval&apos; to two weeks prior to the start date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Project_Status_Pending_Delay_RstAppr</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>OpportunityLineItem.ServiceDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Include in Monthly Total to False</fullName>
        <actions>
            <name>Set_Include_in_Monthly_Total_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Default_Include_In_Monthly_Total__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets include Monthly total Check Box to False</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Include in Monthly Total to true</fullName>
        <actions>
            <name>Update_Include_Monthly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Default_Include_In_Monthly_Total__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets include Monthly total Check Box to True</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set_OLI_Waiting_Status_To_Cancelled</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>equals</operation>
            <value>Cancel</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Waiting_Status_To_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>OpportunityLineItem.Invoice_CancelDate__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set_OLI_Waiting_status_To_HardCancel</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>equals</operation>
            <value>Hard Cancel</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Product_P_or_C_Date_update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Canceled_Set_If_Needed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Waiting_Status_To_HardCancel</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>OpportunityLineItem.Invoice_CancelDate__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set_Waiting_Status_To_Cancelled</fullName>
        <actions>
            <name>Update_Waiting_Status_To_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>equals</operation>
            <value>Cancel</value>
        </criteriaItems>
        <description>Update the Waiting_Status__c to Cancelled if the Invoice Cancel Date is less than or equal to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set_Waiting_Status_To_HardCancel</fullName>
        <actions>
            <name>Product_P_or_C_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Canceled_Set_If_Needed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Waiting_Status_To_HardCancel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Invoice_CancelDate__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.CancelType__c</field>
            <operation>equals</operation>
            <value>Hard Cancel</value>
        </criteriaItems>
        <description>Updates Waiting_Status__c to Hard Cancel if Type of Cancel is Hard Cancel and Invoice Cancel Date is Less than or Equal to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Setup Fee Checked</fullName>
        <actions>
            <name>Setup_Fee_Checked_for_Setup_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>equals</operation>
            <value>Setup Fee</value>
        </criteriaItems>
        <description>Auto checks a setup fee checkbox to enable Setup Fee missing reports</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Setup Fee Checker</fullName>
        <actions>
            <name>Setup_Fee_Checker_Toggle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Setup_Fee_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Checks a hidden setup fee checkbox if product requires a setup fee</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Setup Fee List Variance</fullName>
        <actions>
            <name>Setup_Fee_List_Variance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used for ensuring reps aren&apos;t tweaking the Setup fee&apos;s without approval</description>
        <formula>AND( ListPrice  &lt;&gt;UnitPrice,  Product2Id=&quot;01tA0000000W5ZR&quot;, Opportunity.Opportunity_IsReplicated__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Alert - Live - GL %26 Affl</fullName>
        <actions>
            <name>Waiting_Status_Last_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Waiting_Status_Set_On_Opp_Live</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Live</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Live_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>YESTERDAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Digital Fulfillment,SML Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tier 1 FB Ads Closed Won</fullName>
        <actions>
            <name>Tier_1_Facebook_Ads_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Product_Name__c</field>
            <operation>contains</operation>
            <value>Facebook Ads</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.UnitPrice</field>
            <operation>greaterOrEqual</operation>
            <value>7500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tier 1 PPC Closed Won</fullName>
        <actions>
            <name>Tier_1_PPC_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Product_Name__c</field>
            <operation>contains</operation>
            <value>PPC</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.UnitPrice</field>
            <operation>greaterOrEqual</operation>
            <value>7500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update - Cancelled Set If Needed</fullName>
        <actions>
            <name>Update_Canceled_Set_If_Needed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update - Live Date Set If Needed</fullName>
        <actions>
            <name>Update_Live_Checkbox_On_Status_Live</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Live_DateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Fulfilled-Complete,Live,Fulfilled Renewed,Fulfilled Non-Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Live_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Setup Fee</fullName>
        <actions>
            <name>Update_Setup_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Setup_Fee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Setup_Fee_Amt__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Awaiting Onboard %28Hesse%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Hesse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Onboard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 1 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Awaiting Onboard</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Awaiting Onboard %28Kurland%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Kurland</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Onboard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 2 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Awaiting Onboard</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Awaiting Onboard %28Van Horne%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Van_Horne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Onboard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 3 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Awaiting Onboard</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Closed Won %28Hesse%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Hesse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 1 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Closed Won %28Kurland%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Kurland</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 2 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Closed Won %28Van Horne%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Van_Horne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 3 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod In Fulfillment %28Hesse%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Hesse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>In Fulfillment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 1 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is In Fulfillment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod In Fulfillment %28Kurland%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Kurland</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>In Fulfillment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 2 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is In Fulfillment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod In Fulfillment %28Van Horne%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Van_Horne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>In Fulfillment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 3 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is In Fulfillment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Live %28Hesse%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Hesse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Live</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 1 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Awaiting Onboard</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Live %28Kurland%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Kurland</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Live</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 2 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Live</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Live %28Van Horne%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Van_Horne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Live</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 3 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Live</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Waiting On Client Approval %28Hesse%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Hesse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 1 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Waiting On Client Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Waiting On Client Approval %28Kurland%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Kurland</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 2 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Waiting On Client Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Waiting On Client Approval %28Van Horne%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Van_Horne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 3 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Waiting On Client Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Waiting On Client Resource %28Hesse%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Hesse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Resource</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 1 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Waiting On Client Resource</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Waiting On Client Resource %28Kurland%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Kurland</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Resource</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 2 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Waiting On Client Resource</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iSales Opp Prod Waiting On Client Resource %28Van Horne%29</fullName>
        <actions>
            <name>iSales_Opp_Prod_Van_Horne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Waiting_Status__c</field>
            <operation>equals</operation>
            <value>Waiting On Client Resource</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opp_Owner_Role__c</field>
            <operation>contains</operation>
            <value>Acquisition Team 3 Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_IsReplicated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to iSales Manager when Opportunity Product is Waiting On Client Resource</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
