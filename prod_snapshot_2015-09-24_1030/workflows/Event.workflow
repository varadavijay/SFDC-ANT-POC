<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Appointment_Held</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/apptsheld</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>neil.wingate@gannett.com</integrationUser>
        <name>Appointment Held</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Appointment_Set</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/apptsset</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>neil.wingate@gannett.com</integrationUser>
        <name>Appointment Set</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Contact</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/contacts</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>atangudu@gannett.com</integrationUser>
        <name>Contact</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Dial</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/dials</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>neil.wingate@gannett.com</integrationUser>
        <name>Dial</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Email</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/emails</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>neil.wingate@gannett.com</integrationUser>
        <name>Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ISDC Appointment Held</fullName>
        <actions>
            <name>Appointment_Held</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(  AND( ISPICKVAL(Status__c, &apos;Ran&apos;),  OR(CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), CreatedBy.UserRole.Name ==&apos;Sales Analyst&apos;)),true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ISDC Appointment Set</fullName>
        <actions>
            <name>Appointment_Set</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( OR( CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), Created_By_Role_Name__c == &apos;Sales Analyst&apos;), true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ISDC Contact</fullName>
        <actions>
            <name>Contact</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( AND(ISPICKVAL(Call_Completed__c, &apos;Conversation&apos;) , OR( CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), Created_By_Role_Name__c == &apos;Sales Analyst&apos;)) , true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ISDC Dial</fullName>
        <actions>
            <name>Dial</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( AND( CONTAINS(Subject, &apos;Call&apos;),  OR( CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), Created_By_Role_Name__c == &apos;Sales Analyst&apos;)) , true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ISDC Email</fullName>
        <actions>
            <name>Email</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( AND( CONTAINS(Subject, &apos;email&apos;),  OR( CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), Created_By_Role_Name__c == &apos;Sales Analyst&apos;)) , true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
