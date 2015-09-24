<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Completion_Notice</fullName>
        <description>Completion Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/SystemsRequestCompleted</template>
    </alerts>
    <alerts>
        <fullName>ETA_Submitted_Notice</fullName>
        <description>ETA Submitted Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/SystemsETAEntered</template>
    </alerts>
    <alerts>
        <fullName>Issue_Reported_Alert</fullName>
        <description>Issue Reported Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Owner_Supervisor__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>rwegner2@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/SystemsIssueReported</template>
    </alerts>
    <alerts>
        <fullName>Request_Submit_Alert</fullName>
        <description>Request Submit Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Email_Alert_Request_Submit</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/SystemsRequestSubmitted</template>
    </alerts>
    <alerts>
        <fullName>SFUserRequest</fullName>
        <description>SF User Request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>rwegner2@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/UserRequestSubmitted</template>
    </alerts>
    <alerts>
        <fullName>SF_Record_Transfer_Request</fullName>
        <description>SF Record Transfer Request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SFDC_Administrators</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Record_Transfer_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Request_Date_Set</fullName>
        <field>Submit_Date__c</field>
        <formula>Today()</formula>
        <name>Request Date Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Manager_Email</fullName>
        <field>Owner_Supervisor__c</field>
        <formula>Submitter__r.Manager.Email</formula>
        <name>Update Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Completed Notice</fullName>
        <actions>
            <name>Completion_Notice</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Configuration Request Submitted</fullName>
        <actions>
            <name>Request_Submit_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RequestsIssues__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Configuration</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ETA Set Update</fullName>
        <actions>
            <name>ETA_Submitted_Notice</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notice to Submitter/Owner when an ETA is entered.</description>
        <formula>OR(NOT( PRIORVALUE(ETA__c) = ETA__c),AND(ISNULL(PRIORVALUE(ETA__c)),NOT(ISNULL(ETA__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Issue Reported Alert</fullName>
        <actions>
            <name>Issue_Reported_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RequestsIssues__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Issue Report</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Request Date Set</fullName>
        <actions>
            <name>Request_Date_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.Submit_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets Request Date To Present If Left Empty</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RequestSubmitAlert</fullName>
        <actions>
            <name>Request_Submit_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>RequestsIssues__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dev Request,User Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF Record Transfer Request</fullName>
        <actions>
            <name>SF_Record_Transfer_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Owner Transfer</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF User Request</fullName>
        <actions>
            <name>SFUserRequest</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DC User Request,GL User Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Manager Email</fullName>
        <actions>
            <name>Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RequestsIssues__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
