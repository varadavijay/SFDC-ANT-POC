<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Renewal_Date</fullName>
        <field>Renewal_Date__c</field>
        <formula>Execution_Date__c + ((Term__c * 365)/12)</formula>
        <name>Update Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Renewal_Notice</fullName>
        <field>Renewal_Notice__c</field>
        <formula>Renewal_Date__c   - ((1 * 365)/12)</formula>
        <name>Update Renewal Notice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Termination_Notice</fullName>
        <field>Termination_Notice__c</field>
        <formula>Renewal_Date__c - ((1 * 365)/12)</formula>
        <name>Update Termination Notice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Negotion_Window</fullName>
        <field>Negotiation_Window_Notice__c</field>
        <formula>Renewal_Date__c - ((2 * 365)/12)</formula>
        <name>Update the Negotion Window</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Misc%2E Date Fields</fullName>
        <actions>
            <name>Update_Renewal_Notice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Termination_Notice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_the_Negotion_Window</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DealChicken_Contract__c.Execution_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the Renewal Date</fullName>
        <actions>
            <name>Update_Renewal_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DealChicken_Contract__c.Execution_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
