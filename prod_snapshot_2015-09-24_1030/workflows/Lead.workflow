<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Buyer_Zone_Email_lead</fullName>
        <description>Buyer Zone Email lead</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Do_Not_Use/BuyerZone_Auto_Response_Email</template>
    </alerts>
    <alerts>
        <fullName>Completed_Decision_Engine</fullName>
        <description>Completed Decision Engine</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Direct_Mail_Campaign/Decision_Engine_Consultation_request_website</template>
    </alerts>
    <alerts>
        <fullName>Direct_Mail_Inbound_Lead</fullName>
        <description>Direct Mail Inbound Lead</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Do_Not_Use/BuyerZone_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Marketing_Kit_Requested</fullName>
        <ccEmails>ashley.lange@gannett.com</ccEmails>
        <description>Marketing Kit Requested</description>
        <protected>false</protected>
        <recipients>
            <recipient>christine.olivas@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kelly.walsh@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Marketing_Prospecting/Marketing_Kit_Requested</template>
    </alerts>
    <alerts>
        <fullName>New_DealChicken_Merchant_Lead</fullName>
        <description>New DealChicken Merchant Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>anwilliams@dealchicken.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bailey.herlov@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>danielle.dee@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gloria.carew@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>isaac.rivera@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jaime.vigil@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>troy.gibson@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>anwilliams@gannett.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DealChicken_Merchant_Comm/New_Merchant_Form_Lead</template>
    </alerts>
    <alerts>
        <fullName>New_Simply_Gifted_Lead</fullName>
        <description>New Simply Gifted Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>anwilliams@dealchicken.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jmillier@dealchicken.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>anwilliams@gannett.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DealChicken_Merchant_Comm/New_Simply_Gifted_Lead</template>
    </alerts>
    <alerts>
        <fullName>Newsletter_Opt_In</fullName>
        <description>Newsletter Opt-In</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Direct_Mail_Campaign/Newsletter_subscription_request</template>
    </alerts>
    <alerts>
        <fullName>Requested_Needs_Assessment</fullName>
        <description>Requested Needs Assessment</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Direct_Mail_Campaign/Consultation_email_request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Capture_Date_Stamp</fullName>
        <field>Deal_of_the_Day_Capture_Date__c</field>
        <formula>TODAY()</formula>
        <name>Capture Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Alternate_Email_Captured</fullName>
        <description>Fire when alternate email is captured</description>
        <field>Date_Alternate_Email_Captured__c</field>
        <formula>TODAY()</formula>
        <name>Date Alternate Email Captured</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Cap_Boolean</fullName>
        <field>Email_Captured__c</field>
        <literalValue>1</literalValue>
        <name>Email Cap Boolean</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Cap_Date</fullName>
        <field>Date_Email_Captured__c</field>
        <formula>Today()</formula>
        <name>Email Cap Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Present_Clear</fullName>
        <field>Email_Captured__c</field>
        <literalValue>0</literalValue>
        <name>Email Present Clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Call_Source_Date_Stamp</fullName>
        <description>Stamps the date of the inbound call source being modified</description>
        <field>Date_of_Inbound_Call_Source__c</field>
        <formula>TODAY()</formula>
        <name>Inbound Call Source Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JSS_Queue_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>JSS_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>JSS Queue Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Transfer_To_Collver_From_Interns</fullName>
        <field>OwnerId</field>
        <lookupValue>mark.collver@gannett.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Lead Transfer To Collver From Interns</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Performed_Needs_Assessment</fullName>
        <field>Performed_Needs_Assessment_Date__c</field>
        <formula>TODAY()</formula>
        <name>Performed Needs Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SG_Lead_Source</fullName>
        <field>LeadSource</field>
        <literalValue>Simply Gifted Website</literalValue>
        <name>SG Lead Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Scheduled_Needs_Assessment</fullName>
        <field>Scheduled_Needs_Assessment__c</field>
        <formula>TODAY()</formula>
        <name>Scheduled Needs Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Watch</fullName>
        <field>Status_Watch2__c</field>
        <formula>TODAY()</formula>
        <name>Status_Watch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Toggle_Marketo_Sync_Lead_Field_FALSE</fullName>
        <description>Toggles Sync with Marketo field to &quot;FALSE,&quot; as record does not qualify to be sync&apos;d with Marketo</description>
        <field>Sync_With_Marketo__c</field>
        <literalValue>0</literalValue>
        <name>Toggle Marketo Sync Field - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Toggle_Marketo_Sync_Lead_Field_TRUE</fullName>
        <description>Changes Sync with Marketo field to &quot;TRUE,&quot; because record qualified to be sync&apos;d to Marketo</description>
        <field>Sync_With_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Toggle Marketo Sync Field - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDemoRanDatetime</fullName>
        <field>Demo_Ran_DateTime__c</field>
        <formula>Now()</formula>
        <name>UpdateDemoRanDatetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDemoSetDatetime</fullName>
        <field>Demo_Set_DateTime__c</field>
        <formula>Now()</formula>
        <name>UpdateDemoSetDatetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_When_Blank</fullName>
        <description>Update Country to United States when Blank</description>
        <field>Country</field>
        <formula>&quot;United States&quot;</formula>
        <name>Update Country When Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Days_in_Stage</fullName>
        <description>When status moves, update this field</description>
        <field>In_Stage_Since__c</field>
        <formula>TODAY()</formula>
        <name>Update Days in Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dig_Aud_Client_Name</fullName>
        <field>FirstName</field>
        <formula>LEFT( LastName ,  FIND(&quot; &quot;, LastName) )</formula>
        <name>Update Dig Aud Client Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dig_Aud_Client_Name2</fullName>
        <field>LastName</field>
        <formula>MID(LastName,FIND(&quot; &quot;, LastName)+1,50)</formula>
        <name>Update Dig Aud Client Name2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Inbound_Lead_Source</fullName>
        <field>Inbound_Lead_Source__c</field>
        <literalValue>BuyerZone</literalValue>
        <name>Update Inbound Lead Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Source_Detail_For_Dig_Audits</fullName>
        <field>Lead_Source_Detail__c</field>
        <literalValue>Online</literalValue>
        <name>Update Lead Source Detail For Dig Audits</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Source_For_Dig_Audits</fullName>
        <field>LeadSource</field>
        <literalValue>Audit Request</literalValue>
        <name>Update Lead Source For Dig Audits</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>Changes the record type to Simply Gifted</description>
        <field>RecordTypeId</field>
        <lookupValue>SimplyGifted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Contacted_Not_Interest</fullName>
        <description>When the stage is changed, fire this rule</description>
        <field>In_Stage_Since__c</field>
        <formula>TODAY()</formula>
        <name>Update Status - Contacted - Not Interest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Contacted_Remove_from</fullName>
        <description>When the stage is changed, fire this rule</description>
        <field>In_Stage_Since__c</field>
        <formula>TODAY()</formula>
        <name>Update Status - Contacted - Remove from</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_In_Dialogue</fullName>
        <field>In_Stage_Since__c</field>
        <formula>TODAY()</formula>
        <name>Update Status - In Dialogue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Qualified</fullName>
        <description>When the Stage is changed, fire this rule</description>
        <field>In_Stage_Since__c</field>
        <formula>TODAY()</formula>
        <name>Update Status - Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Web_Form_Completed_Date_Stamp</fullName>
        <field>Web_Form_Completed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Web Form Completed- Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Disqualified_Lead</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/disqlld</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>neil.wingate@gannett.com</integrationUser>
        <name>Disqualified Lead</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>KPI_AppointmentSet</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/apptsset</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>gl.system@gannett.com</integrationUser>
        <name>KPI - AppointmentSet</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>BZ Email Lead</fullName>
        <actions>
            <name>Buyer_Zone_Email_lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Inbound_Lead_Source__c</field>
            <operation>equals</operation>
            <value>2f</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BuyerZone Field Update</fullName>
        <actions>
            <name>Update_Inbound_Lead_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>BuyerZone - Email Marketing Services</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Completed Decision Engine</fullName>
        <actions>
            <name>Completed_Decision_Engine</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Completed_Decision_Engine</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Completed Decision Engine</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deal of the Day Capture Date</fullName>
        <actions>
            <name>Capture_Date_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Site__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DemoRanTimeStamp</fullName>
        <actions>
            <name>UpdateDemoRanDatetime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Demo_Ran__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Demo_Ran_DateTime__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If Demo Ran is marked true and the Demo Ran time Stamp is null, set time stamp to today</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DemoSetTimeStamp</fullName>
        <actions>
            <name>UpdateDemoSetDatetime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Demo_Set__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Demo_Set_DateTime__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If Demo Set is marked true and the Demo Set time Stamp is null, set time stamp to today</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Direct Mail Lead</fullName>
        <actions>
            <name>Direct_Mail_Inbound_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Inbound_Lead_Source__c</field>
            <operation>equals</operation>
            <value>2e</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Capture</fullName>
        <actions>
            <name>Email_Cap_Boolean</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_Cap_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fire when e-mail is captured by Sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Capture Clear</fullName>
        <actions>
            <name>Email_Present_Clear</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Fire when e-mail is captured by Sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Capture- Alternate</fullName>
        <actions>
            <name>Date_Alternate_Email_Captured</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Alternate_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Alternate email capture not equal to null</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ISDC Disqualified Lead</fullName>
        <actions>
            <name>Disqualified_Lead</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Send Back to Marketing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Call Source Mod</fullName>
        <actions>
            <name>Inbound_Call_Source_Date_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Inbound_Lead_Source__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Rule fires any time Inbound Call Source is not equal to null</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JSS Queue Assignment</fullName>
        <actions>
            <name>JSS_Queue_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>contains</operation>
            <value>Digital Audit Requestor</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>KPI-AppointmentSet</fullName>
        <actions>
            <name>KPI_AppointmentSet</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Demo_Set__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Transfer To Collver From Interns</fullName>
        <actions>
            <name>Lead_Transfer_To_Collver_From_Interns</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.Id  = &quot;005A0000001XYV5&quot;,Marketing_Decision_Maker__c = True,ISPICKVAL( Trans_List__c,&quot;SPC-SCT-06022011&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Kit Leads</fullName>
        <actions>
            <name>Marketing_Kit_Requested</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Requested Marketing Kit</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketo Sync - FALSE</fullName>
        <actions>
            <name>Toggle_Marketo_Sync_Lead_Field_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3 or 4</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>SML Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notContain</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule determines which Leads are sync&apos;d to Marketo and toggles the Sync with Marketo field to FALSE.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketo Sync - TRUE</fullName>
        <actions>
            <name>Toggle_Marketo_Sync_Lead_Field_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>SML Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This rule determines which Leads are sync&apos;d to Marketo and toggles the Sync with Marketo field to TRUE.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Landing Page Lead - Discount</fullName>
        <actions>
            <name>Immediate_Action_Discount</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Requested 30-Percent Discount,Requested 30-Percent Discount- DM</value>
        </criteriaItems>
        <description>Existing lead has visited the landing page- please follow up</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Landing Page Lead - Needs</fullName>
        <actions>
            <name>Immediate_Action_Needs_Assessment_Follow_Up</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Requested Needs Assessment,Requested Needs Assessment- DM</value>
        </criteriaItems>
        <description>Existing lead has visited the landing page- please follow up</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Landing Page Lead -Free Keys</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Downloaded Whitepaper- DM,Downloaded Whitepaper</value>
        </criteriaItems>
        <description>Existing lead filled out Landing page- please follow up</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Immediate_Action_Free_Keys_Follow_Up2</name>
                <type>Task</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>New Merchant Form Lead</fullName>
        <actions>
            <name>New_DealChicken_Merchant_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Detail_Text__c</field>
            <operation>contains</operation>
            <value>DC IB Contact Us</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Newsletter Opt-In</fullName>
        <actions>
            <name>Newsletter_Opt_In</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Signed Up for Newsletter</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Newsletter_Opt_In</name>
                <type>Task</type>
            </actions>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Performed Needs Assessment</fullName>
        <actions>
            <name>Performed_Needs_Assessment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Campaign_Status__c</field>
            <operation>equals</operation>
            <value>Performed Needs Assessment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Requested Needs Assessment</fullName>
        <actions>
            <name>Requested_Needs_Assessment</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Requested_Needs_Assessment</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>Requested Needs Assessment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SG Lead</fullName>
        <actions>
            <name>New_Simply_Gifted_Lead</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SG_Lead_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.SG__c</field>
            <operation>contains</operation>
            <value>SG</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Scheduled Needs Assessment</fullName>
        <actions>
            <name>Scheduled_Needs_Assessment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Campaign_Status__c</field>
            <operation>equals</operation>
            <value>Scheduled Needs Assessment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status_Watch</fullName>
        <actions>
            <name>Status_Watch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(

AND(
ISPICKVAL(PRIORVALUE(Status),&quot;Contacted - Not Interested&quot;),
NOT(ISPICKVAL(Status,&quot;Contacted - Not Interested&quot;))

)
,



AND(ISPICKVAL(PRIORVALUE(Status),&quot;Uncontacted - New&quot;),
OR(
ISPICKVAL(Status,&quot;Contacted - Not Interested&quot;),
ISPICKVAL(Status,&quot;Contacted - Remove from List&quot;)
))

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Country When Blank</fullName>
        <actions>
            <name>Update_Country_When_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Country to United States When There is no Country Populated</description>
        <formula>AND(ISBLANK(Country))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Dig Aud Client Name</fullName>
        <actions>
            <name>Update_Dig_Aud_Client_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dig_Aud_Client_Name2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(LastName)),ISBLANK(FirstName), CONTAINS(LastName,&quot; &quot;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Source For Dig Audits</fullName>
        <actions>
            <name>Update_Lead_Source_Detail_For_Dig_Audits</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Source_For_Dig_Audits</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Alias</field>
            <operation>equals</operation>
            <value>guest</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Status - Contacted - Not Interested</fullName>
        <actions>
            <name>Update_Status_Contacted_Not_Interest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Contacted - Not Interested</value>
        </criteriaItems>
        <description>When the status is changed, fire this rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status - Contacted - Remove from List</fullName>
        <actions>
            <name>Update_Status_Contacted_Remove_from</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Contacted - Remove from List</value>
        </criteriaItems>
        <description>When the status is changed, fire this rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status - In Dialogue</fullName>
        <actions>
            <name>Update_Status_In_Dialogue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>In Dialogue</value>
        </criteriaItems>
        <description>When the Status is changed, fire this rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status - Qualified</fullName>
        <actions>
            <name>Update_Status_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <description>When the status is changed, fire this rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status - Uncontacted- New</fullName>
        <actions>
            <name>Update_Days_in_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Uncontacted - New</value>
        </criteriaItems>
        <description>When the lead status is changed, fire this rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web Form Completed- Date Stamp</fullName>
        <actions>
            <name>Web_Form_Completed_Date_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>stamps the create date to the webform completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web Form Completed- Thank you</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>contains</operation>
            <value>Downloaded Whitepaper,Requested 30-Percent Discount,Requested Needs Assessment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Webform Completed- %24200 Coupon</fullName>
        <actions>
            <name>X200_Free_Ad_Promo</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Form_Completed__c</field>
            <operation>equals</operation>
            <value>$200 Coupon</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Completed_Decision_Engine</fullName>
        <assignedToType>owner</assignedToType>
        <description>Follow up with lead to schedule a live demo; to see their responses, go to the Lead record, scroll to the Survey Results and click the link; Also, don&apos;t forget to mention the discount coupon on a 3-month marketing campaign they receive with their results.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Completed Decision Engine</subject>
    </tasks>
    <tasks>
        <fullName>Immediate_Action_Discount</fullName>
        <assignedToType>owner</assignedToType>
        <description>One of your assigned leads from the direct marketing campaign filled out the form at www.gannettlocal.com/30Off. 
Please follow-up to discuss product selection and purchase process.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Immediate Action - Discount</subject>
    </tasks>
    <tasks>
        <fullName>Immediate_Action_Free_Keys_Follow_Up</fullName>
        <assignedToType>owner</assignedToType>
        <description>One of your assigned leads from the direct marketing campaign filled out the form at www.gannettlocal.com/Free7Keys. 
Please follow-up to see if they were able to download it and to start a conversation about their needs.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Immediate Action - Free Keys Follow-Up</subject>
    </tasks>
    <tasks>
        <fullName>Immediate_Action_Free_Keys_Follow_Up2</fullName>
        <assignedToType>owner</assignedToType>
        <description>One of your assigned leads from the direct marketing campaign filled out the form at www.gannettlocal.com/Free7Keys. 
Please follow-up to see if they were able to download it and to start a conversation about their needs.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Immediate Action - Free Keys Follow-Up</subject>
    </tasks>
    <tasks>
        <fullName>Immediate_Action_Needs_Assessment_Follow_Up</fullName>
        <assignedToType>owner</assignedToType>
        <description>One of your assigned leads from the direct marketing campaign filled out the form at www.gannettlocal.com/FREEConsultation. 
Please follow-up to schedule a consultation about their needs.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Immediate Action - Needs Assessment Follow-Up</subject>
    </tasks>
    <tasks>
        <fullName>Newsletter_Opt_In</fullName>
        <assignedToType>owner</assignedToType>
        <description>Action Required: follow up with lead who subscribed to newsletter to see if they have any local marketing need or any questions about the GL product suite</description>
        <dueDateOffset>6</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Newsletter Opt-In</subject>
    </tasks>
    <tasks>
        <fullName>Requested_Needs_Assessment</fullName>
        <assignedToType>owner</assignedToType>
        <description>Action Required: follow up with lead to schedule a live demo/needs assessment; be sure to schedule an appointment in Salesforce</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Requested Needs Assessment</subject>
    </tasks>
    <tasks>
        <fullName>X200_Free_Ad_Promo</fullName>
        <assignedToType>owner</assignedToType>
        <description>One of your Leads has responded to our $200 free advertising promotion. 

Please follow up with them ASAP to fulfill. 

Please note that they have to spend at least $300 to get the $200 free.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>$200 Free Ad Promo</subject>
    </tasks>
</Workflow>
