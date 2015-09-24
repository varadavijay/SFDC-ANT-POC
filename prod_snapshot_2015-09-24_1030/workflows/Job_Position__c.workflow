<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dax_Approved</fullName>
        <description>Dax Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>neil.wingate@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Job_Position_Templetes/New_Job_Position_Final_Approval_Granted</template>
    </alerts>
    <alerts>
        <fullName>Job_Position_Approved_by_Recruiting_Email_to_Hiring_Manager</fullName>
        <description>Job Position Approved by Recruiting - Email to Hiring Manager</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Job_Position_Templetes/New_Job_Position_Recruiting_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Select_Final_Approver</fullName>
        <field>Final_Approver__c</field>
        <name>Select Final Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
