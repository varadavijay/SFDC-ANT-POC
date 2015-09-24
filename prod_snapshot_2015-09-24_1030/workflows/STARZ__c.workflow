<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>STARZ_Nomination</fullName>
        <description>STARZ Nomination</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jennifer.gateley@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Nominee__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/STARZNomination</template>
    </alerts>
    <alerts>
        <fullName>STARZ_Notifications</fullName>
        <description>STARZ Notifications</description>
        <protected>false</protected>
        <recipients>
            <field>Nominee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/AgreementSigned</template>
    </alerts>
    <rules>
        <fullName>STARZ Nomination</fullName>
        <actions>
            <name>STARZ_Nomination</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>STARZ__c.Nominee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>STARZ Notifications</fullName>
        <actions>
            <name>STARZ_Notifications</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>STARZ__c.Nominee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
