<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Declined Credit Card</fullName>
        <actions>
            <name>Credit_Card_Declined</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Payment_Processing__c.Processing_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <description>Fire to rep when credit card is declined</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Credit_Card_Declined</fullName>
        <assignedToType>owner</assignedToType>
        <description>A customer&apos;s credit card processing was declined. Please contact the customer to resolve this issue.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Credit Card Declined - Contact Customer</subject>
    </tasks>
</Workflow>
