<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Exception_Email_Rule</fullName>
        <ccEmails>GODigitalCRMTeam-SnR@gannett.com</ccEmails>
        <description>Send Exception Email Rule</description>
        <protected>false</protected>
        <recipients>
            <recipient>sharmila.jeevarakshagen@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vvarada@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support_Emails/Send_Exception_Email_Template</template>
    </alerts>
    <rules>
        <fullName>Code Exception Email Alert</fullName>
        <actions>
            <name>Send_Exception_Email_Rule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ApplicationLogs__c.Send_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ApplicationLogs__c.Log_Level__c</field>
            <operation>equals</operation>
            <value>Error</value>
        </criteriaItems>
        <description>Code Exception Email Alert</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
