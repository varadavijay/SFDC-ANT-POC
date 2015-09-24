<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Declined_Alert_To_Dig_Acct_Manager</fullName>
        <description>Declined Alert To Dig Acct Manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>michael.ogaz@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>DigAccountManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Declined_Alert_for_Dig_Acct_Manager2</template>
    </alerts>
    <alerts>
        <fullName>Send_Payment_Entry_Update_Check_To_Admin</fullName>
        <description>Send Payment Entry Update Check To Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>phillip.pratt@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Record_Transfer_Request</template>
    </alerts>
    <alerts>
        <fullName>Send_TimeBased_Note</fullName>
        <description>Send TimeBased Note</description>
        <protected>false</protected>
        <recipients>
            <recipient>AdSupportTAR</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>debra.sadowniczak@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mari.smith@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Processor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/Charge_Reminder_II</template>
    </alerts>
    <alerts>
        <fullName>Send_TimeBased_Note_Forgot</fullName>
        <description>Send TimeBased Note Forgot</description>
        <protected>false</protected>
        <recipients>
            <field>Processor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Charge_Reminder_II_FollowUp</template>
    </alerts>
    <rules>
        <fullName>Declined Alert for Dig Acct Manager</fullName>
        <actions>
            <name>Declined_Alert_To_Dig_Acct_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Payment_Entries__c.Declined__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send TimeBased Note</fullName>
        <active>true</active>
        <formula>AND( Custom_Set__c = False, Date__c &gt;= TODAY(),Completed__c &lt;&gt; True,NOT(ISNULL(Processor__c)))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_TimeBased_Note</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Payment_Entries__c.Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send TimeBased Note Forgot</fullName>
        <active>true</active>
        <formula>AND( Custom_Set__c = False, Date__c &gt;= TODAY(),Completed__c &lt;&gt; True)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_TimeBased_Note_Forgot</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Payment_Entries__c.Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send TimeBased Note On Update</fullName>
        <active>true</active>
        <formula>AND( Custom_Set__c = True, Date__c &gt;= TODAY(), Completed__c &lt;&gt; True, NOT(ISNULL(Processor__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_TimeBased_Note</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Payment_Entries__c.Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send TimeBased Note On Update Forgot</fullName>
        <active>true</active>
        <formula>AND( Custom_Set__c = True, Date__c &gt;= TODAY(), Completed__c &lt;&gt; True)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_TimeBased_Note_Forgot</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Payment_Entries__c.Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
