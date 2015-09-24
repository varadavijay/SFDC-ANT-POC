<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Yipit_2000_Alert</fullName>
        <description>Yipit 2000 Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>gl.system@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/Yipit2000Alert</template>
    </alerts>
    <rules>
        <fullName>Yipit 2000 Alert</fullName>
        <actions>
            <name>Yipit_2000_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( PRIORVALUE( Deal_Revenue__c )  &lt; 8000,Deal_Revenue__c &gt; 7999,NOT(ISNULL( Market__c )),NOT(ISBLANK( Market__c )),NOT( Market__c = &quot;US, National&quot;),NOT(Market__c=&quot;a0cF0000004UWYw&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
