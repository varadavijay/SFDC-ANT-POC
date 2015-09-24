<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Categories_Match</fullName>
        <field>Match__c</field>
        <literalValue>1</literalValue>
        <name>Categories Match</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Category_Match</fullName>
        <field>Match__c</field>
        <literalValue>0</literalValue>
        <name>Update Category Match</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Needed %26 Received Categories</fullName>
        <actions>
            <name>Categories_Match</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Category_Needed_Text__c =  Category_Received_Text__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>No Match</fullName>
        <actions>
            <name>Update_Category_Match</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Category_Received_Text__c  &lt;&gt;  Category_Needed_Text__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
