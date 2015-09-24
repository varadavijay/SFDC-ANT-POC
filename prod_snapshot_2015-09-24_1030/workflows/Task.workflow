<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assigned_to_akw_now</fullName>
        <description>updated to Salesforce Administration2 to deactivate Andrew Williams</description>
        <field>OwnerId</field>
        <lookupValue>sean.riley@gannett.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assigned to akw now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Task_Completed_Date</fullName>
        <field>Completed__c</field>
        <formula>Now()</formula>
        <name>Set Task Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Correct_Contact</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/corcntcts</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>atangudu@gannett.com</integrationUser>
        <name>Correct Contact</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Voicemail</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/vms</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>atangudu@gannett.com</integrationUser>
        <name>Voicemail</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ISDC Correct Contact</fullName>
        <actions>
            <name>Correct_Contact</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( AND( CallDisposition == &apos;correct contact&apos;, OR( CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), Created_By_Role_Name__c == &apos;Sales Analyst&apos;)) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ISDC Voicemail</fullName>
        <actions>
            <name>Voicemail</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF( AND( OR( CallDisposition ==&apos;Left Live Message&apos;,CallDisposition == &apos;Left Voicemail&apos;) , OR( CONTAINS(Owner:User.UserRole.Name, &quot;acquisition&quot;), Created_By_Role_Name__c == &apos;Sales Analyst&apos;)) , true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Re-Assign akw</fullName>
        <actions>
            <name>Assigned_to_akw_now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Your DealChicken Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Description</field>
            <operation>contains</operation>
            <value>The DealChicken Merchant Team</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Task Completed Date</fullName>
        <actions>
            <name>Set_Task_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
