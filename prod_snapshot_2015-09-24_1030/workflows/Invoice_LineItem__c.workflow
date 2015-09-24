<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_ILI_isLocked</fullName>
        <field>isLocked__c</field>
        <literalValue>1</literalValue>
        <name>Update ILI  isLocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update isLocked</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_LineItem__c.isLocked__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_LineItem__c.Invoice_PeriodStart__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_LineItem__c.Invoice_ScheduleDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_LineItem__c.isDeleted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_ILI_isLocked</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Invoice_LineItem__c.Invoice_ScheduleDate__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
