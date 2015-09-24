<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_OnOpp_ACH_Name</fullName>
        <field>Business_Legal_Name_2__c</field>
        <formula>IF(NOT(ISBLANK(Checking_Company_Name__c)),Checking_Company_Name__c,
IF(NOT(ISBLANK( Deposit_Company_Name__c)),Deposit_Company_Name__c,&quot;None Entered&quot;))</formula>
        <name>Update OnOpp ACH Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_OnOpp_W8_W9_Company_Name</fullName>
        <field>Business_Legal_Name_1__c</field>
        <formula>IF(NOT(ISBLANK(W8_Company_Name__c)),W8_Company_Name__c,IF(NOT(ISBLANK(W9_Company_Name__c)),W9_Company_Name__c,&quot;None Entered&quot;))</formula>
        <name>Update OnOpp W8/W9 Company Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update On Opp Last Legal Name Fields</fullName>
        <actions>
            <name>Update_OnOpp_ACH_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_OnOpp_W8_W9_Company_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>FormStack_Data__c.Checking_Company_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>FormStack_Data__c.W8_Company_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>FormStack_Data__c.W9_Company_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
