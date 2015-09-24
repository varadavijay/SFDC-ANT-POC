<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deal_of_the_Day_Task</fullName>
        <description>Deal of the Day Task</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Deal_of_the_Day</template>
    </alerts>
    <alerts>
        <fullName>Send_Test_Email</fullName>
        <description>Send Test Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Email_Alert_Send_Test_Email</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/AffiliateEmailTestForDistros</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_akw</fullName>
        <field>OwnerId</field>
        <lookupValue>sean.riley@gannett.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign akw</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_Test_Email_Reset</fullName>
        <field>Send_Test_Email__c</field>
        <literalValue>0</literalValue>
        <name>Send Test Email Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Inactive_Status_to_false</fullName>
        <field>InactiveStatus__c</field>
        <literalValue>0</literalValue>
        <name>Set Inactive Status to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Inactive_Status_to_true</fullName>
        <field>InactiveStatus__c</field>
        <literalValue>1</literalValue>
        <name>Set Inactive Status to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_Affiliated</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Affiliated</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to Affiliated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_Inactive_Affiliated</fullName>
        <description>Set 
RecordType to Inactive Affiliated Contact</description>
        <field>RecordTypeId</field>
        <lookupValue>Inactive_Affiliated_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to Inactive Affiliated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Toggle_Marketo_Sync_Contact_Field_FALSE</fullName>
        <description>Toggles Sync with Marketo Contact field to &quot;FALSE,&quot; as record does not qualify to be sync&apos;d with Marketo</description>
        <field>Sync_With_Marketo__c</field>
        <literalValue>0</literalValue>
        <name>Toggle Marketo Sync Field - FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Toggle_Marketo_Sync_Contact_Field_TRUE</fullName>
        <description>Toggles Sync with Marketo Contact field to &quot;TRUE,&quot; as record does not qualify to be sync&apos;d with Marketo</description>
        <field>Sync_With_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Toggle Marketo Sync Field - TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Capture_Date</fullName>
        <field>Deal_of_the_Day_Capture_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Capture Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>Updates from the ZenDesk Default to DealChicken Contact. Currently being used as a work around since we cannot find the source of the problem.</description>
        <field>RecordTypeId</field>
        <lookupValue>DealChicken_ZenDesk_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DealChicken_ZenDesk_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Change Contact Type</fullName>
        <actions>
            <name>Assign_akw</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Zendesk__zendesk_id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Deactivated 9/8/15 so that we can deactivate Andrew Williams.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deal of the Day Capture Date - Contacts</fullName>
        <actions>
            <name>Deal_of_the_Day_Task</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Capture_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Site__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mark Affiliated Contact</fullName>
        <actions>
            <name>Set_Inactive_Status_to_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Record_Type_to_Affiliated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Mark Affiliated Contact</description>
        <formula>OR(AND(ISCHANGED(InactiveStatus__c),!InactiveStatus__c), AND(OR(ISNEW(),ISCHANGED(RecordTypeId)), RecordType.DeveloperName = &apos;Affiliated&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mark Inactive Affiliated Contact</fullName>
        <actions>
            <name>Set_Inactive_Status_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Record_Type_to_Inactive_Affiliated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Mark Inactive Affiliated Contact</description>
        <formula>OR(AND(ISCHANGED(InactiveStatus__c),InactiveStatus__c), AND(OR(ISNEW(),ISCHANGED(RecordTypeId)), RecordType.DeveloperName = &apos;Inactive_Affiliated_Contact&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Marketo Sync - FALSE</fullName>
        <actions>
            <name>Toggle_Marketo_Sync_Contact_Field_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>SML Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule determines which Contacts are sync&apos;d to Marketo and toggles the Sync with Marketo field to FALSE.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketo Sync - TRUE</fullName>
        <actions>
            <name>Toggle_Marketo_Sync_Contact_Field_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>SML Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Do_Not_Call__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This rule determines which Contacts are sync&apos;d to Marketo and toggles the Sync with Marketo field to TRUE.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Test Email</fullName>
        <actions>
            <name>Send_Test_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Send_Test_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Test_Email_Reset</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
