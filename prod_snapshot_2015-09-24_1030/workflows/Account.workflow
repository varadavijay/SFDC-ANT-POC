<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SMS_Assigned</fullName>
        <description>SMS Assigned</description>
        <protected>false</protected>
        <recipients>
            <recipient>krystofer.vanslyke@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>SocialMediaSpecialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/SMSAssigned</template>
    </alerts>
    <fieldUpdates>
        <fullName>CF_CheckSend_To_Add_Or_Update</fullName>
        <field>CF_CheckSend__c</field>
        <literalValue>Add Or Update</literalValue>
        <name>CF CheckSend To Add Or Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Company_Health_LastUpdated</fullName>
        <field>Market_Health_LastUpdated__c</field>
        <formula>LastModifiedDate</formula>
        <name>Update Company Health LastUpdated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CF CheckSend To Add Or Update</fullName>
        <actions>
            <name>CF_CheckSend_To_Add_Or_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>AND(ISCHANGED( LastModifiedDate ), NOT(ISCHANGED(CF_CheckSend__c)),ISPICKVAL(CF_CheckSend__c,&quot;Sent&quot;))</description>
        <formula>OR( ISCHANGED( CF_Client_Status__c ) ,ISCHANGED( CF_EndDate__c ),ISCHANGED( CF_StartDate__c ),ISCHANGED(  CF_Reporting_Requested__c  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last Updated Company Health</fullName>
        <actions>
            <name>Update_Company_Health_LastUpdated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Field should be updated by whatever appropriate means in Salesforce automatically. Field should be updated when a user updates the &quot;Market_Health__c&quot; field from null to a value or from one value to a different value after committing the Save of a record.</description>
        <formula>OR( AND(IsNew(),NOT(ISBLANK(TEXT(Market_Health__c)))), IsChanged(Market_Health__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Social Media Specialist - Assignment</fullName>
        <actions>
            <name>SMS_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(PRIORVALUE(  SocialMediaSpecialist__c ) = SocialMediaSpecialist__c ),NOT(ISBLANK(SocialMediaSpecialist__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
