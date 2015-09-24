<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MLC_Change_Alert</fullName>
        <description>MLC Change Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Email_Alert_MLC_Change</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Do_Not_Use/SALES_Email_Clicked</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Name</fullName>
        <field>Name</field>
        <formula>State__c + &quot;, &quot; + City_Area__c</formula>
        <name>Update Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MLC Change Alert</fullName>
        <actions>
            <name>MLC_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(PRIORVALUE( DealChicken_MLC__c ) = DealChicken_MLC__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Name</fullName>
        <actions>
            <name>Update_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Market__c.City_Area__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
