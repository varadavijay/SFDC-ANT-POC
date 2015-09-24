<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Clicked_Open</fullName>
        <description>Email Clicked Open</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Do_Not_Use/SALES_Email_Clicked</template>
    </alerts>
    <rules>
        <fullName>Email Clicked Open</fullName>
        <actions>
            <name>Email_Clicked_Open</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>xtma_Individual_Email_Result__c.Opened__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>xtma_Individual_Email_Result__c.Number_of_Total_Clicks__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
