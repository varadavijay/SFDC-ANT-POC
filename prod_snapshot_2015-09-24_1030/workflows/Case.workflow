<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Audit_Request_Thank_You_Email_Affl_Rep</fullName>
        <description>Audit Request Thank You Email Affl Rep</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>derik.hettinger@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Audit_Request_Thank_You_Email</template>
    </alerts>
    <alerts>
        <fullName>Audit_Request_Thank_You_Email_GL_Rep</fullName>
        <description>Audit Request Thank You Email GL Rep</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>derik.hettinger@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Audit_Request_Thank_You_Email</template>
    </alerts>
    <alerts>
        <fullName>Case_Support_Ticket_Approved</fullName>
        <description>Case - Support Ticket Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Team_SFDC_Support</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>lkrout@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Dev_Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Support_Ticket_Approved</template>
    </alerts>
    <alerts>
        <fullName>Case_Support_Ticket_Completed</fullName>
        <description>Case - Support Ticket Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Dev_Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Support_Ticket_Completed</template>
    </alerts>
    <alerts>
        <fullName>Case_Support_Ticket_Denied</fullName>
        <description>Case - Support Ticket Denied</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Team_SFDC_Support</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>lkrout@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Dev_Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Support_Ticket_Denied</template>
    </alerts>
    <alerts>
        <fullName>Case_Support_Ticket_Recalled</fullName>
        <description>Case - Support Ticket Recalled</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Team_SFDC_Support</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lkrout@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Dev_Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Support_Ticket_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Case_Support_Ticket_Submitted</fullName>
        <description>Case - Support Ticket Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Team_SFDC_Support</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>lkrout@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Dev_Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Support_Ticket_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Email_Count_Request_Notification</fullName>
        <description>Email Count Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>james.hamilton@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/EmailCountReqAlert</template>
    </alerts>
    <alerts>
        <fullName>Email_Count_Thank_You_Email</fullName>
        <description>Email Count Thank You Email</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Email_Alert_Email_Count_thank_you</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/EmailCountRequest_Thank_You_Email</template>
    </alerts>
    <alerts>
        <fullName>GL_Care_Created_Alert_Broadcast</fullName>
        <ccEmails>posika@gannett.com</ccEmails>
        <description>GL Care Created Alert - Broadcast - DEACTIVATED</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>G_O_Care</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLCareCreatedAlertBroadcast</template>
    </alerts>
    <alerts>
        <fullName>GL_Care_Created_Alert_Deactivated_08272015</fullName>
        <description>GL Care Created Alert - Deactivated 08272015</description>
        <protected>false</protected>
        <recipients>
            <recipient>G_O_Care</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLCareCreatedAlert</template>
    </alerts>
    <alerts>
        <fullName>GL_Care_Created_Alert_v1_1</fullName>
        <description>GL Care Created Alert - v1.1</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>G_O_Care</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLCareCreatedAlert</template>
    </alerts>
    <alerts>
        <fullName>GL_Care_Reply_Deactivated_08272015</fullName>
        <description>GL Care Reply - Deactivated 08272015</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GO_Care_Submitted_Reply_Deactivated_08272015</template>
    </alerts>
    <alerts>
        <fullName>GL_DA_Misaligned_Product_Alert</fullName>
        <description>GL DA Misaligned Product Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>courtney.vix@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Misaligned_Product_Alert</template>
    </alerts>
    <alerts>
        <fullName>GL_DA_Website_Audit_NotificationCustom</fullName>
        <description>GL DA Website Audit Notification Custom</description>
        <protected>false</protected>
        <recipients>
            <recipient>shickman@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/WebsiteRequest_CaseLink</template>
    </alerts>
    <alerts>
        <fullName>GL_OnBoard_Alert</fullName>
        <description>GL OnBoard Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>bjohnson8@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>courtney.vix@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/OnBoardAlert2</template>
    </alerts>
    <alerts>
        <fullName>GL_Rate_Request_Close_Alert_to_Rep</fullName>
        <description>GL Rate Request - Close Alert to Rep - USCP</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>bjohnson8@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>courtney.vix@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sean.sorber@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLRateRequestCloseAlertToRep</template>
    </alerts>
    <alerts>
        <fullName>GL_Rate_Request_Close_Alert_to_Rep_BC</fullName>
        <description>GL Rate Request - Close Alert to Rep - BC</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>bjohnson8@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>courtney.vix@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sean.sorber@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLRateRequestCloseAlertToRep</template>
    </alerts>
    <alerts>
        <fullName>GL_Rate_Request_Notice_For_USCP</fullName>
        <ccEmails>bzapata@gannett.com</ccEmails>
        <description>GL Rate Request - Notice For USCP</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/GLRateSubmittedNotice</template>
    </alerts>
    <alerts>
        <fullName>GL_Rate_Request_Notice_To_Team_ALL</fullName>
        <description>GL Rate Request - Notice To Team - ALL</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/GLRateSubmittedNotice</template>
    </alerts>
    <alerts>
        <fullName>GL_Rate_Request_Thank_You_to_Rep_BC</fullName>
        <description>GL Rate Request - Thank You to Rep - BC</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>mandy.keller@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melanie.ricotta@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLRateSubmittedReply</template>
    </alerts>
    <alerts>
        <fullName>GL_Rate_Request_Thank_You_to_Rep_USCP</fullName>
        <description>GL Rate Request - Thank You to Rep - USCP</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>mandy.keller@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melanie.ricotta@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/GLRateSubmittedReply</template>
    </alerts>
    <alerts>
        <fullName>GL_Sales_Call_Request_Alert</fullName>
        <description>GL Sales Call Request Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Email_Alert_GL_Sales_Call_Request</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/SalesCallRequestAlert</template>
    </alerts>
    <alerts>
        <fullName>New_Support_Case_Comment_Added</fullName>
        <description>New Support Case Comment Added</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Dev_Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>godigitaldonotreply@gannett.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Support_Case_Comment_Added</template>
    </alerts>
    <alerts>
        <fullName>Not_In_List_Sales_Rep_Text_Check</fullName>
        <description>Not In List Sales Rep Text Check</description>
        <protected>false</protected>
        <recipients>
            <recipient>Email_Alert_Not_in_List</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/NotInListAlert</template>
    </alerts>
    <alerts>
        <fullName>OnBoard_Request_Thank_You</fullName>
        <description>OnBoard Request Thank You</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/OnBoardThankYou</template>
    </alerts>
    <alerts>
        <fullName>Product_Enhance_Thank_You_Group_1</fullName>
        <ccEmails>bzapata@gannett.com</ccEmails>
        <ccEmails>mvmeadows@gannett.com</ccEmails>
        <description>Product Enhance Thank You - Group 1</description>
        <protected>false</protected>
        <recipients>
            <recipient>melanie.ricotta@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Product_Enhance_Thank_You</template>
    </alerts>
    <alerts>
        <fullName>Product_Enhance_Thank_You_Group_2</fullName>
        <description>Product Enhance Thank You - Group 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>melanie.ricotta@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>posika@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Product_Enhance_Thank_You</template>
    </alerts>
    <alerts>
        <fullName>Website_Audit_For_8_Page_Template_With_Addon_On_but_blank_additions_field_alert</fullName>
        <description>Website Audit For 8 Page Template With Addon On but blank additions field alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>phillip.pratt@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/BlankWebsiteAdditionsAlert</template>
    </alerts>
    <alerts>
        <fullName>Website_Request_Complete_Email</fullName>
        <description>Website Request Complete Email</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/Website_Request_Complete_Email_HTML</template>
    </alerts>
    <alerts>
        <fullName>Website_Request_Thank_You_Email</fullName>
        <description>Website Request Thank You &amp; Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Affl_Sales_Rep__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Notify_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Notify_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>derik.hettinger@gannett.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Templates/WebsiteRequest_Thank_You_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_After_Hours</fullName>
        <field>RecordTypeId</field>
        <lookupValue>After_Hours_Issue</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Assign to After Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_MLC_System</fullName>
        <field>Contact_Name__c</field>
        <formula>&quot;DealChicken MLC System&quot;</formula>
        <name>Change to MLC System</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DC_Audit_Lead_To_Lead_Gen</fullName>
        <field>OwnerId</field>
        <lookupValue>DC_Audit_Lead_Gen</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>DC Audit Lead To Lead Gen</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Development_Status_Approved</fullName>
        <field>Dev_Development_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Development Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GL_Care_Description_Update</fullName>
        <field>Description</field>
        <formula>GLC_Request_Reason__c</formula>
        <name>GL Care Description Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GL_Care_Subject_Update</fullName>
        <field>Subject</field>
        <formula>IF(ISBLANK( AccountId ),&quot;GL Care-&quot; &amp;  Company_Name__c ,&quot;GL Care-&quot; &amp;   Account.Name )</formula>
        <name>GL Care Subject Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GL_Care_User</fullName>
        <field>GL_Care_User__c</field>
        <formula>Owned_Stamp__c - Care_Case_Created_Stamp__c - Weekend_Days_Open_To_Own__c</formula>
        <name>GL Care User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GL_Rate_Submitted_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>GL_Rate</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>GL Rate Submitted Assignment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MLC_Re_Route_Assignment</fullName>
        <description>9/8/15 - changed user from Andrew Williams to Salesforce Administration2 so Andrew Williams can be deactivated.</description>
        <field>OwnerId</field>
        <lookupValue>sean.riley@gannett.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>MLC Re Route Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Salesforce_Support</fullName>
        <field>OwnerId</field>
        <lookupValue>Salesforce_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Salesforce Support</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Clear_Full_Page_Type</fullName>
        <field>GLW_Full_Page_Type__c</field>
        <name>Set Clear Full Page Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Full_Custom_Website_For_SML_2</fullName>
        <field>GLW_Full_Page_Type__c</field>
        <formula>&quot;Full Custom Site&quot;</formula>
        <name>Set Full Custom Website For SML 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Full_Page_Eight_Page_Template</fullName>
        <field>GLW_Full_Page_Type__c</field>
        <formula>&quot;Eight Page Template&quot;</formula>
        <name>Set Full Page Eight Page Template</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Full_Page_Four_Page_Template</fullName>
        <field>GLW_Full_Page_Type__c</field>
        <formula>&quot;Four Page Template&quot;</formula>
        <name>Set Full Page Four Page Template</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Full_Website_For_SML_1</fullName>
        <field>GLW_Web_Page_Type__c</field>
        <formula>&quot;Full Page&quot;</formula>
        <name>Set Full  Website For SML 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Landing_Page_Type_To_Custom</fullName>
        <field>GLW_Landing_Page_Type__c</field>
        <formula>&quot;Custom Landing Page&quot;</formula>
        <name>Set Landing Page Type To Custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Landing_Page_Type_To_Template</fullName>
        <field>GLW_Landing_Page_Type__c</field>
        <formula>&quot;Template Landing Page&quot;</formula>
        <name>Set Landing Page Type To Template</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Landing_Website_For_SML</fullName>
        <field>GLW_Web_Page_Type__c</field>
        <formula>&quot;Landing Page&quot;</formula>
        <name>Set Landing Website For SML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Page_Clear_Landing</fullName>
        <field>GLW_Landing_Page_Type__c</field>
        <name>Set Page Clear Landing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Business_Approved</fullName>
        <description>Business Approved, Submitting to Salesforce Support for resolution</description>
        <field>Status</field>
        <literalValue>Business Approved</literalValue>
        <name>Status: Business Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Denied</fullName>
        <description>The Case has been closed as Denied.</description>
        <field>Status</field>
        <literalValue>Denied</literalValue>
        <name>Status: Denied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Origin</fullName>
        <field>Origin</field>
        <literalValue>Email2Case</literalValue>
        <name>Update Origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RSM_Region_Text</fullName>
        <field>RSM_Region_Text__c</field>
        <formula>TEXT(Media_Partner__r.RSM_Region__c )</formula>
        <name>Update RSM Region Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_by_Owner</fullName>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>Update Status by Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Blank Website Additions Field Alert</fullName>
        <actions>
            <name>Website_Audit_For_8_Page_Template_With_Addon_On_but_blank_additions_field_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Website Audit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_Template_Additions__c</field>
            <operation>equals</operation>
            <value>8 Page Template With Add-Ons</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_Full_Page_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Just setup to test problem noted by Adam Lindsey on SR-00000758.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change to MLC System</fullName>
        <actions>
            <name>Change_to_MLC_System</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>DealChicken Merchant Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>Andrew Williams</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>merchantsupport@</value>
        </criteriaItems>
        <description>If a case comes in that is a DC case it will auto-assign to Andrew.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DC Audit Lead To Lead Gen</fullName>
        <actions>
            <name>DC_Audit_Lead_To_Lead_Gen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>LG Digital Audit</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Care Created</fullName>
        <actions>
            <name>GL_Care_Created_Alert_v1_1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Care Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Care Created Broadcast Prop - Paula Osika - DEACTIVATED</fullName>
        <actions>
            <name>GL_Care_Created_Alert_Broadcast</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Care Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Media_Partner_Type__c</field>
            <operation>equals</operation>
            <value>BC</value>
        </criteriaItems>
        <description>Deactivated 08272015</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Care Description Update</fullName>
        <actions>
            <name>GL_Care_Description_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLC_Request_Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Care Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Care Subject Update</fullName>
        <actions>
            <name>GL_Care_Subject_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISNULL( CaseNumber )), RecordTypeId =&quot;012F0000000yDXz&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GL Care User</fullName>
        <actions>
            <name>GL_Care_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the field GL Care User to true if the prior owner was GL Care Site User</description>
        <formula>AND(ISCHANGED(OwnerId), NOT(ISBLANK(Owned_Stamp__c)), NOT(ISBLANK(Care_Case_Created_Stamp__c)), Owned_Stamp__c &gt; Care_Case_Created_Stamp__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Call Request Alert</fullName>
        <actions>
            <name>GL_Sales_Call_Request_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Call Request</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Digital Audit Request Thank You Email Affl Rep</fullName>
        <actions>
            <name>Audit_Request_Thank_You_Email_Affl_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Digital Audit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>equals</operation>
            <value>Digital Audit Requestor</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Digital Audit Request Thank You Email GL Rep</fullName>
        <actions>
            <name>Audit_Request_Thank_You_Email_GL_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Digital Audit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notEqual</operation>
            <value>Digital Audit Requestor</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL DA EmailCount Request Alert %26 Thank You</fullName>
        <actions>
            <name>Email_Count_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Count_Thank_You_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Email Count</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Misaligned Product Alert</fullName>
        <actions>
            <name>GL_DA_Misaligned_Product_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.DA_Misaligned_Product__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Website Audit Completed Notification</fullName>
        <actions>
            <name>Website_Request_Complete_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Website Audit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Close</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_Audit_Solution__c</field>
            <operation>equals</operation>
            <value>Template w/Add On,Proposal</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Website Audit Request %26 Notification</fullName>
        <actions>
            <name>Website_Request_Thank_You_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Website Audit</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL DA Website Custom Audit Request %26 Notification</fullName>
        <actions>
            <name>GL_DA_Website_Audit_NotificationCustom</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Website Audit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_Full_Page_Type__c</field>
            <operation>contains</operation>
            <value>Custom</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_Landing_Page_Type__c</field>
            <operation>contains</operation>
            <value>Custom</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL OnBoard Request Notification</fullName>
        <actions>
            <name>GL_OnBoard_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL OnBoard</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL OnBoard Request ThankYou</fullName>
        <actions>
            <name>OnBoard_Request_Thank_You</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL OnBoard</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Rate Request - Close Alert to Affl Rep - BC</fullName>
        <actions>
            <name>GL_Rate_Request_Close_Alert_to_Rep_BC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( IsClosed = True, Media_Partner_Type__c = &quot;BC&quot;,PRIORVALUE(IsClosed)=False, RecordTypeId = &quot;012F0000000yDv9&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GL Rate Request - Close Alert to Affl Rep - USCP</fullName>
        <actions>
            <name>GL_Rate_Request_Close_Alert_to_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( IsClosed = True,Media_Partner_Type__c = &quot;USCP&quot;,PRIORVALUE(IsClosed)=False, RecordTypeId = &quot;012F0000000yDv9&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GL Rate Request - Thank You To Rep %26 Notice - BC</fullName>
        <actions>
            <name>GL_Rate_Request_Notice_To_Team_ALL</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>GL_Rate_Request_Thank_You_to_Rep_BC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Media_Partner_Type__c = &quot;BC&quot;,RecordTypeId = &quot;012F0000000yDv9&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Rate Request - Thank You To Rep %26 Notice - USCP</fullName>
        <actions>
            <name>GL_Rate_Request_Notice_For_USCP</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>GL_Rate_Request_Notice_To_Team_ALL</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>GL_Rate_Request_Thank_You_to_Rep_USCP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Media_Partner_Type__c = &quot;USCP&quot;,RecordTypeId = &quot;012F0000000yDv9&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GL Rate Submitted Assignment</fullName>
        <actions>
            <name>GL_Rate_Submitted_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Rate Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MLC CC Re-Route</fullName>
        <actions>
            <name>MLC_Re_Route_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>merchantsupport@2y4wawjl2mdl0beu5iczbivhwhez23tl6aeqxhegdku09rs27r.a-heotmao.f.case.salesforce</value>
        </criteriaItems>
        <description>Deactivated 9/8/15 after we learned Andrew Williams had left the company.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Not In List Check</fullName>
        <actions>
            <name>Not_In_List_Sales_Rep_Text_Check</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Affl_Sales_Rep__c = &quot;003F000000y4o1V&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Enhance - Thank You Group 1</fullName>
        <actions>
            <name>Product_Enhance_Thank_You_Group_1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Product Enhancement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Name_Text__c</field>
            <operation>contains</operation>
            <value>Zapata,Meadows</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Enhance - Thank You Group 2</fullName>
        <actions>
            <name>Product_Enhance_Thank_You_Group_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GL Product Enhancement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Name_Text__c</field>
            <operation>contains</operation>
            <value>Osika</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Full 4 Page Template Website For SML</fullName>
        <actions>
            <name>Set_Full_Page_Four_Page_Template</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Full_Website_For_SML_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Page_Clear_Landing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.GLW_SML_Web_Page_Type__c</field>
            <operation>equals</operation>
            <value>Full Site</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_SML_Full_Site_Design__c</field>
            <operation>equals</operation>
            <value>4 Page Template</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Full 8 Page Template Website For SML</fullName>
        <actions>
            <name>Set_Full_Page_Eight_Page_Template</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Full_Website_For_SML_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Page_Clear_Landing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.GLW_SML_Web_Page_Type__c</field>
            <operation>equals</operation>
            <value>Full Site</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_SML_Full_Site_Design__c</field>
            <operation>equals</operation>
            <value>8 Page Template</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Full Custom Website For SML</fullName>
        <actions>
            <name>Set_Full_Custom_Website_For_SML_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Full_Website_For_SML_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Page_Clear_Landing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.GLW_SML_Web_Page_Type__c</field>
            <operation>equals</operation>
            <value>Full Site</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_SML_Full_Site_Design__c</field>
            <operation>equals</operation>
            <value>Full Custom Site</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Landing Custom Website For SML</fullName>
        <actions>
            <name>Set_Clear_Full_Page_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Landing_Page_Type_To_Custom</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Landing_Website_For_SML</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.GLW_SML_Web_Page_Type__c</field>
            <operation>equals</operation>
            <value>Landing Page</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_SML_Landing_Page_Type__c</field>
            <operation>equals</operation>
            <value>Custom</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Landing Template Website For SML</fullName>
        <actions>
            <name>Set_Clear_Full_Page_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Landing_Page_Type_To_Template</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Landing_Website_For_SML</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.GLW_SML_Web_Page_Type__c</field>
            <operation>equals</operation>
            <value>Landing Page</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GLW_SML_Landing_Page_Type__c</field>
            <operation>equals</operation>
            <value>Template</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Case Comment</fullName>
        <actions>
            <name>New_Support_Case_Comment_Added</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Last Comment field gets updated when a new comment is added to Support Case Record Type</description>
        <formula>AND( NOT(ISBLANK(Last_Comment__c)), PRIORVALUE(Last_Comment__c) &lt;&gt; Last_Comment__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Support Ticket Completed</fullName>
        <actions>
            <name>Case_Support_Ticket_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Complete,Completed Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support Ticket</value>
        </criteriaItems>
        <description>When a support ticket is Completed, sends email to Submitter</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Ticket Submitted</fullName>
        <actions>
            <name>Case_Support_Ticket_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support Ticket</value>
        </criteriaItems>
        <description>When a support ticket is submitted, sends email to Support Team</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update RSM Region Text</fullName>
        <actions>
            <name>Update_RSM_Region_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED( Media_Partner__c ),AND(NOT(ISBLANK( RSM_Region__c)),ISBLANK(RSM_Region_Text__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status by Owner</fullName>
        <actions>
            <name>Update_Status_by_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>Digital Audit Requestor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <description>Trigger when a new case changes ownership form the default user</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
