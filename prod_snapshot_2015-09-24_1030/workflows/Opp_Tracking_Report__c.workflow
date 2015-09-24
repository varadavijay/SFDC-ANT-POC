<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_Date_Move</fullName>
        <field>Move_Approve_Date__c</field>
        <literalValue>0</literalValue>
        <name>Reset Date Move</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approve_Date</fullName>
        <field>Time_Stamp__c</field>
        <formula>Time_Stamp__c +  VALUE(TEXT(Move_Approve_Date__c))</formula>
        <name>Update Approve Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Approve Date</fullName>
        <actions>
            <name>Reset_Date_Move</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Approve_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Move_Approve_Date__c ),NOT(ISPICKVAL(Move_Approve_Date__c,&quot;0&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
