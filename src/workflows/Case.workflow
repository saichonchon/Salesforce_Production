<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Team_Notification_for_Migration_Case_Changes</fullName>
        <description>Account Team Notification for Migration Case Changes</description>
        <protected>false</protected>
        <recipients>
            <recipient>Enterprise Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Onboarding Specialist</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Enterprise_Account_Manager_Notification</template>
    </alerts>
    <alerts>
        <fullName>Autoresponse_BC_Consulting</fullName>
        <description>Autoresponse: Premium Account Services</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>premiumservices@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Autoresponse/BC_Consulting_Autoresponse</template>
    </alerts>
    <alerts>
        <fullName>Billing_Closed_Case_Notification_to_Client</fullName>
        <description>Billing : Closed Case Notification to Client</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Subscription_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Closure_NoticeBilling</template>
    </alerts>
    <alerts>
        <fullName>Billing_Open_Case_Notification_to_Client</fullName>
        <description>Billing : Open Case Notification to Client</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Subscription_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Billing_Case_Opened_Notice</template>
    </alerts>
    <alerts>
        <fullName>CS_New_Case_Sent_to_support_bigcommerce_com</fullName>
        <description>CS : New Case Sent to support@bigcommerce.com - directs client to open case another way</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/CS_New_Email_to_Support</template>
    </alerts>
    <alerts>
        <fullName>CS_Notify_API_Case_Opened</fullName>
        <description>CS: Notify Client of API Case Opened</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/CS_API_Case_Opened_Notification</template>
    </alerts>
    <alerts>
        <fullName>CS_Notify_Case_Opened</fullName>
        <description>CS : Notify Case Opened</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/CS_Case_Opened_Notification</template>
    </alerts>
    <alerts>
        <fullName>CS_SBD_Escalation_Autoresponse_to_Client</fullName>
        <description>CS: SBD Escalation Autoresponse to Client</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sbdsupport@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/CS_SBD_Escalations_Autoresponse</template>
    </alerts>
    <alerts>
        <fullName>CS_Status_Closed_Case_Closed_With_Survey</fullName>
        <description>CS : Send Closed Case Closed Notification With Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/CS_Case_Closure_Withtice</template>
    </alerts>
    <alerts>
        <fullName>Case_Enterprise_Cancellation_Case_Notification</fullName>
        <description>Enterprise Client Submitted a Cancellation Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>anna.thoni@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cynthia.balusek@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Enterprise_Cancellation_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Send_Final_OCR_Closure_email</fullName>
        <description>Case: Send Final OCR Closure email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_OCR_Final_Response_and_Closure</template>
    </alerts>
    <alerts>
        <fullName>Case_Send_Second_OCR_Response_Email</fullName>
        <description>Case: Send Second OCR Response Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_OCR_Second_Response</template>
    </alerts>
    <alerts>
        <fullName>Client_Success_Contact_Waiting_on_Customer_Status_96_hrs</fullName>
        <description>CS : Case has been in Waiting on Customer Status &gt; 96 hrs - Asks client to reply if they still need help</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_96_Hour_Closure_Warning_Contact</template>
    </alerts>
    <alerts>
        <fullName>Email_Enterprise_Account_Managers_when_an_Enterprise_Support_Case_is_Opened</fullName>
        <description>Email Enterprise Account Managers when an Enterprise Support Case is Opened</description>
        <protected>false</protected>
        <recipients>
            <recipient>Enterprise_Account_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Premium_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Owner_of_Approval</fullName>
        <description>Email Owner of Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Approval_for_Billing_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_Owner_of_Rejection</fullName>
        <description>Email Owner of Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Rejection_for_Billing_Request</template>
    </alerts>
    <alerts>
        <fullName>Email_Received_for_Closed_Case</fullName>
        <description>Email that asks clients who have replied to a closed case to open a new one</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/CS_Email_Received_for_Closed_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_SOW</fullName>
        <description>Email SOW</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>professional_Services/Prof_Services_SOW</template>
    </alerts>
    <alerts>
        <fullName>Migration_Data_Migration_24_hour_reminder</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Data Migration Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Data_Spot_Check_24_hour_reminder</template>
    </alerts>
    <alerts>
        <fullName>Migration_Data_Spot_Check_1st_Email</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Data Spot Check 1st Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Data_Spot_Check_1st_Email</template>
    </alerts>
    <alerts>
        <fullName>Migration_Delayed_CSAT_Survey</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Delayed CSAT Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Delayed_CSAT_Survey</template>
    </alerts>
    <alerts>
        <fullName>Migration_Invalid_Credential_Request</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Invalid Credential - Request</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Invalid_Credentials_Email</template>
    </alerts>
    <alerts>
        <fullName>Migration_Migration_Complete_No_CSAT</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Migration Complete No CSAT</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Migration_Complete_No_CSAT</template>
    </alerts>
    <alerts>
        <fullName>Migration_Migration_Complete_with_CSAT</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Migration Complete with CSAT</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Migration_Complete_with_CSAT_Survey</template>
    </alerts>
    <alerts>
        <fullName>Migration_Reviewing_your_Verification_Notes</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration:  Reviewing your Verification Notes</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Reviewing_your_Verification_Notes</template>
    </alerts>
    <alerts>
        <fullName>Migration_UAT_Spot_Check_Email</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: UAT Spot Check Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_UAT_Data_Spot_Check</template>
    </alerts>
    <alerts>
        <fullName>Migration_Valid_Credentials_Received</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Valid Credentials Received</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Valid_Credentials_Received</template>
    </alerts>
    <alerts>
        <fullName>New_Sales_Case_Notification_to_Sales_Rep</fullName>
        <description>New Sales Case Notification to Sales Rep</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_Record_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Case_Sales_Rep_New_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Owner_Assignment_Notification</fullName>
        <description>PS: Owner Assignment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>professional_Services/Owner_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>PS_New_Case_Notification</fullName>
        <description>PS: New Case Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>professional_Services/PS_New_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Partner_Notify_Waiting_on_Client_5</fullName>
        <description>Partner: Notify Waiting on Client +5</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Partner_Email_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Premium_Case_Notification</fullName>
        <ccEmails>AccountManagement@bigcommerce.com</ccEmails>
        <description>Client Success Premium Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Premium_Case_Notifications</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Premium_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Refund_Credit_Approver_Email_Notification</fullName>
        <description>Refund/Credit Approver Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Refund_Credit_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Refund_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Cancellation_Survey</fullName>
        <description>Send Cancellation Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cancellations@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Survey_Templates/CS_Cancellation_Survey</template>
    </alerts>
    <alerts>
        <fullName>Send_Marketing_Public_Client_Cancel_Email</fullName>
        <ccEmails>marketingteam@bigcommerce.com, comms@bigcommerce.com</ccEmails>
        <description>Send Marketing Public Client Cancel Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>adelle.archer@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>andrea.wagner@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>debbie.maysonave@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Marketing_Public_Client_Cancel</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_Kick_off_Admin_Only_Emails</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Send Kick off Admin Only Emails</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Kick_Off_Admin_Only</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_Kick_off_Admin_and_FTP_Email</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Send Kick off Admin and FTP Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Kick_Off_Admin_FTP</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_Re_Request_Admin</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Send Re-Request Admin</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Re_Request_Admin_Only</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_Re_Request_Admin_and_FTP</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Send Re-Request Admin and FTP</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Re_Request_Admin_FTP</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_Withdrawn_to_Client</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Send Withdrawn to Client</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>catalogtransfer@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_Withdrawn_to_Internal_Team</fullName>
        <ccEmails>mindy.kreitzman@bigcommerce.com</ccEmails>
        <description>Migration: Send Withdrawn to Internal Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>Migration_Specialists</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Migration_Leader</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>john.mcleod@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>timothy.shuman@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Sold_by__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Migration_Emails/Migration_Internal_Withdrawn_Client</template>
    </alerts>
    <alerts>
        <fullName>Send_PS_Email_that_we_ve_autoclosed_the_case</fullName>
        <description>Send PS Email that we&apos;ve autoclosed the case</description>
        <protected>false</protected>
        <recipients>
            <field>Client_Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>professional_Services/PS_Closing_Case_4_28</template>
    </alerts>
    <alerts>
        <fullName>Send_SBD_Escalations_alert</fullName>
        <description>Send SBD Escalations alert to Escalation team</description>
        <protected>false</protected>
        <recipients>
            <recipient>Client_Success_Escalation_Team</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Autoresponse/SBD_Escalations_Queue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sent_Default_Email</fullName>
        <description>Sent Default Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_2016_Templates/CS_Public_HTML_Template</template>
    </alerts>
    <alerts>
        <fullName>Store_Launched_Case_Survey</fullName>
        <description>Store Launched Case Survey Sent</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Survey_Templates/SS_Case_Survey_Consultation</template>
    </alerts>
    <alerts>
        <fullName>send_email_with_chat_transcript</fullName>
        <description>send email with chat transcript</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Chat_Transcript</template>
    </alerts>
    <fieldUpdates>
        <fullName>Added_to_Auto_Close_True</fullName>
        <field>Added_to_Auto_Close_List__c</field>
        <literalValue>1</literalValue>
        <name>Added to Auto-Close = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Fritz</fullName>
        <description>Assign case to Abbey in Billing---
Assign to Fritz since Abbey has left.</description>
        <field>OwnerId</field>
        <lookupValue>friedrich.stegmann@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Fritz</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_PS_Launch_TeamQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>Launch_Team_PS_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to PS-Launch TeamQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_PS_Success_Squad_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Success_Squad_PS_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to PS-Success Squad Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BC_Migration_Assignee_N_A</fullName>
        <description>If Technician = C2C, auto-update BC Assignee to N/A</description>
        <field>BC_Migration_Assignee__c</field>
        <literalValue>N/A</literalValue>
        <name>BC Migration Assignee = N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BC_Migration_Technician_Unassigned</fullName>
        <field>BC_Migration_Assignee__c</field>
        <literalValue>Unassigned</literalValue>
        <name>BC Migration Technician = Unassigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Backpay_Requested_Date_Today</fullName>
        <field>Backpay_Requested_Date__c</field>
        <formula>TODAY()</formula>
        <name>Backpay Requested Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Category_to_JIRA</fullName>
        <description>update Case Category to JIRA</description>
        <field>Category__c</field>
        <literalValue>JIRA</literalValue>
        <name>Case Category to JIRA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Chat_Transcript_Sent</fullName>
        <field>Chat_Transcript_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Case Chat Transcript Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Closed_By_Current_User</fullName>
        <field>Case_Closed_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Case Closed By = Current User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Do_Not_Send_Survey_FALSE</fullName>
        <field>Do_Not_Send_Survey__c</field>
        <literalValue>0</literalValue>
        <name>Case: Do Not Send Survey = FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Email_Log_Final_OCR_Response</fullName>
        <field>Email_Log__c</field>
        <formula>Email_Log__c +&quot;; &quot;+&quot;Final OCR Response&quot;</formula>
        <name>Case: Email Log =+ Final OCR Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Origin_Cancellations</fullName>
        <description>Update Case Origin to be Cancellations</description>
        <field>Origin</field>
        <literalValue>cancellations@bigcommerce.com</literalValue>
        <name>Case Origin = Cancellations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Origin_Pixel_Union_Themes</fullName>
        <description>Update case origin when the case is related to Pixel Union Themes</description>
        <field>Origin</field>
        <literalValue>Pixel Union Themes</literalValue>
        <name>Case Origin = Pixel Union Themes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_Support_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner = Support Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason</fullName>
        <description>Update Case Reason to &quot;App Store Communications&quot;</description>
        <field>Reason</field>
        <literalValue>App Store Communications</literalValue>
        <name>Case Reason = App Store Communication</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason_Cancellation</fullName>
        <field>Reason</field>
        <literalValue>Cancellation</literalValue>
        <name>Case Reason = Cancellation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason_No_Support_Provided</fullName>
        <description>Update case reason for pixel union support requests</description>
        <field>Reason</field>
        <literalValue>No Support Provided</literalValue>
        <name>Case Reason = No Support Provided</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason_Trash_Spam</fullName>
        <field>Reason</field>
        <literalValue>Trash/Spam</literalValue>
        <name>Case Reason = Trash/Spam</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason_support_bc</fullName>
        <field>Reason</field>
        <literalValue>support@bigcommerce.com</literalValue>
        <name>Case Reason = support@bc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reset_OCR_Resolution</fullName>
        <field>OCR_Resolution__c</field>
        <name>Case: Reset OCR Resolution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_SetSubscriptionEmail</fullName>
        <field>Subscription_Email__c</field>
        <formula>Subscription__r.Email__c</formula>
        <name>Case: SetSubscriptionEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Auto_Closed</fullName>
        <field>Status</field>
        <literalValue>Auto-Closed</literalValue>
        <name>Case Status = Auto-Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Case Status = Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Open_Unsolved</fullName>
        <field>Status</field>
        <literalValue>Open Unsolved</literalValue>
        <name>Case Status = Open Unsolved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Completed</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Case Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Completed_by_Ops</fullName>
        <field>Status</field>
        <literalValue>Completed by Ops</literalValue>
        <name>Case Status to Completed by Ops</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Director_Approved</fullName>
        <field>Status</field>
        <literalValue>Director Approved</literalValue>
        <name>Case Status to Director Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Case Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Pending_Approval</fullName>
        <field>Status</field>
        <literalValue>Pending Approval</literalValue>
        <name>Case Status to Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Request_Decline</fullName>
        <field>Status</field>
        <literalValue>Request Declined</literalValue>
        <name>Case Status to Request Decline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_owner</fullName>
        <description>Updates the case owner to the Knowledge queue</description>
        <field>OwnerId</field>
        <lookupValue>Knowledge</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case: Update owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_Other</fullName>
        <description>Update the support category for Pixel union support cases.</description>
        <field>Category__c</field>
        <literalValue>Other</literalValue>
        <name>Category = Other</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Notification_Email_Population</fullName>
        <description>If contact &lt;&gt; blank, contact email, then lead, web (supplied) email, opp email, sub email</description>
        <field>Client_Notification_Email__c</field>
        <formula>IF( ContactId &lt;&gt; NULL,  Contact.Email ,
IF( Lead__c &lt;&gt; NULL,  Lead__r.Email , 
IF( SuppliedEmail &lt;&gt; NULL, SuppliedEmail,
IF(Opportunity__r.Contact_Email__c &lt;&gt; NULL,Opportunity__r.Contact_Email__c, 
 Subscription__r.Email__c ))))</formula>
        <name>Client Notification Email Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <description>Closes case based on filter.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Completion_Date_Now</fullName>
        <field>Completion_Date__c</field>
        <formula>Now()</formula>
        <name>Completion Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Migration_Verified_Checked</fullName>
        <field>SS_DataMigrationVerified__c</field>
        <literalValue>1</literalValue>
        <name>Data Migration Verified = Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Department_Cancellations</fullName>
        <field>Department__c</field>
        <literalValue>Cancellations</literalValue>
        <name>Department = Cancellations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Do_Not_Send_Survey_True</fullName>
        <field>Do_Not_Send_Survey__c</field>
        <literalValue>1</literalValue>
        <name>Do Not Send Survey = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Recd_Closed_Case_False</fullName>
        <field>Email_Recd_Closed_Case__c</field>
        <literalValue>0</literalValue>
        <name>Email Recd Closed Case = False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_By</fullName>
        <field>Escalated_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Escalated By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_True</fullName>
        <field>Escalated__c</field>
        <literalValue>1</literalValue>
        <name>Escalated = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalation_Date_Now</fullName>
        <field>Escalation_Date__c</field>
        <formula>Now()</formula>
        <name>Escalation Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalation_Reason_Status_Reason</fullName>
        <field>Escalation_Reason__c</field>
        <formula>Text(Status_Reason__c)</formula>
        <name>Escalation Reason = Status Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Migration_Credential_Request</fullName>
        <description>Increment Migration Credential Request Count</description>
        <field>MIG_Credentials_Requests__c</field>
        <formula>MIG_Credentials_Requests__c + 1</formula>
        <name>Increment Migration Credential Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_UAT_Review_Count</fullName>
        <description>Increment UAT Review Count</description>
        <field>UAT_Review_Count__c</field>
        <formula>IF(ISBLANK(UAT_Review_Count__c),1, UAT_Review_Count__c + 1)</formula>
        <name>Increment UAT Review Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manager_Callback_Date_Populated</fullName>
        <field>Manager_Callback_Date__c</field>
        <formula>NOW ()</formula>
        <name>Manager Callback Date Populated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manager_Callback_Requestor</fullName>
        <field>Manager_Callback_Requestor__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Manager Callback Requestor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manager_Callback_True</fullName>
        <field>Manager_Callback__c</field>
        <literalValue>1</literalValue>
        <name>Manager Callback = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Migration_Clear_Survey</fullName>
        <description>Need to Clear the Survey date since the previously submitted survey contains invalid credentials</description>
        <field>Survey_Completion_Date__c</field>
        <name>Migration: Clear Survey Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Migration_Support_Dept_Support</fullName>
        <description>Migration_Support_Dept_Support</description>
        <field>Migration_Supporting_Department__c</field>
        <literalValue>Support</literalValue>
        <name>Migration Support Dept = Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Migration_Verification_Autoverified</fullName>
        <description>Migration Verification = Autoverified</description>
        <field>Migration_Verification__c</field>
        <literalValue>Auto Verified</literalValue>
        <name>Migration Verification = Autoverified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Migration_Verification_Client_Verified</fullName>
        <description>Migration Verification = Client Verified</description>
        <field>Migration_Verification__c</field>
        <literalValue>Client Verified</literalValue>
        <name>Migration Verification = Client Verified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPS_update_to_case_reason</fullName>
        <description>Update the case reason to Tier 2 Phone Escalation when the NPS less than or equal to 6.</description>
        <field>Reason</field>
        <literalValue>Tier 2 Phone Escalation</literalValue>
        <name>NPS update to case reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NPS_update_to_case_reason_to_Tier2_phone</fullName>
        <description>Update the case reason to Tier 2 Phone Escalation when the NPS less than or equal to 6 or blank.</description>
        <field>Reason</field>
        <literalValue>Tier 2 Phone Escalation</literalValue>
        <name>NPS update to case reason to Tier2 hone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_Hold_Date_Now</fullName>
        <field>On_Hold_Date__c</field>
        <formula>Now()</formula>
        <name>On Hold Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_Hold_Reason_Status_Reason</fullName>
        <field>On_Hold_Reason__c</field>
        <formula>TEXT(Status_Reason__c )</formula>
        <name>On Hold Reason = Status Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Cancellation_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Case_Cancellation_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Cancellation Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Channel_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Sales_Partners</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Channel Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Escalated_Level_1</fullName>
        <description>If status of escalated is selected, set owner to Escalated 1 queue</description>
        <field>OwnerId</field>
        <lookupValue>Support_Escalated_Level_1</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Escalated Level 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Direct_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Sales Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Support_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Support Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Trash_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Support_Trash</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Trash Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_Billing_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Case_Billing_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Billing Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Parent_Owner_Email_Population</fullName>
        <field>Parent_Record_Owner_Email__c</field>
        <formula>IF( ISBLANK( Subscription__r.Account__c ) = FALSE,  Subscription__r.Account__r.Owner.Email,
IF( ISBLANK( Subscription__r.Lead__c ) = FALSE,  Subscription__r.Lead__r.Owner:User.Email  , NULL))</formula>
        <name>Parent Owner Email Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Acceptance_Date_Now</fullName>
        <field>Pending_Acceptance_Date__c</field>
        <formula>Now()</formula>
        <name>Pending Acceptance Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Priority_is_Enterprise</fullName>
        <description>change to enterprise</description>
        <field>Priority</field>
        <literalValue>Enterprise</literalValue>
        <name>Priority is Enterprise</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Billing</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Billing</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_CS</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_Success</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Client Success</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Cancellations</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Cancellations</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Cancellations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Sales</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Direct_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reopened_False</fullName>
        <description>Pixel Union Support</description>
        <field>Reopened__c</field>
        <literalValue>0</literalValue>
        <name>Reopened = False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reopened_True</fullName>
        <field>Reopened__c</field>
        <literalValue>1</literalValue>
        <name>Reopened = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_owner_to_Billing_Queue</fullName>
        <description>Set Case owner to Billing Queue</description>
        <field>OwnerId</field>
        <lookupValue>Case_Billing_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case owner to Billing Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Employee_Account_Subject_Line</fullName>
        <description>Set Employee Account Subject Line</description>
        <field>Subject</field>
        <formula>&quot;Employee Account: Action Needed&quot;</formula>
        <name>Set Employee Account Subject Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Migration_Credential_Requests_to_1</fullName>
        <description>Set Migration Credential Requests to 1</description>
        <field>MIG_Credentials_Requests__c</field>
        <formula>1</formula>
        <name>Set Migration Credential Requests to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Migration_Support_Dept_to_Migration</fullName>
        <description>Set Migration Support Dept to Migration</description>
        <field>Migration_Supporting_Department__c</field>
        <literalValue>Migration</literalValue>
        <name>Set Migration Support Dept to Migration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Migration_Verification_to_Auto</fullName>
        <description>Set Migration Verification to Auto Verified</description>
        <field>Migration_Verification__c</field>
        <literalValue>Auto Verified</literalValue>
        <name>Set Migration Verification to Auto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Awaiting_Requirements</fullName>
        <description>Set Status to Awaiting Requirements</description>
        <field>Status</field>
        <literalValue>Awaiting Requirements</literalValue>
        <name>Set Status to Awaiting Requirements</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_New</fullName>
        <description>Set Case Status to New</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Set Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Re_Requested_Credentials</fullName>
        <description>Set Status to Re-Requested Credentials</description>
        <field>Status</field>
        <literalValue>Re-Requested Credentials</literalValue>
        <name>Set Status to Re-Requested Credentials</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Valid_Credentials_Received_Date</fullName>
        <description>Set Valid Credentials Received Date</description>
        <field>Valid_Credentials_Received__c</field>
        <formula>today()</formula>
        <name>Set Valid Credentials Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Assigned</fullName>
        <description>Set Case Status to Assigned</description>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>Status = Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_No_Credentials</fullName>
        <description>Status = No Credentials</description>
        <field>Status</field>
        <literalValue>No Credentials</literalValue>
        <name>Status = No Credentials</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Requirements_Review</fullName>
        <description>Status = Requirements Review</description>
        <field>Status</field>
        <literalValue>Requirements Review</literalValue>
        <name>Status = Requirements Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_To_Cosed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Status To Cosed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Open</fullName>
        <description>When NPS less than or eual to 6 update status to open</description>
        <field>Status</field>
        <literalValue>Reopened</literalValue>
        <name>Status to Re-opened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Re_opened</fullName>
        <description>When NPS less than or eual to 6 or blank update status to re-open</description>
        <field>Status</field>
        <literalValue>Reopened</literalValue>
        <name>Status to Re-opened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Sent_Date_Now</fullName>
        <field>Survey_Sent_Date__c</field>
        <formula>NOW ()</formula>
        <name>Survey Sent Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Sent_True</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Survey Sent = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Status_AutoClose_Pending_Acce</fullName>
        <field>Survey_Status__c</field>
        <literalValue>AutoClose - Pending Acceptance</literalValue>
        <name>Survey Status = AutoClose - Pending Acce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Status_Autoclose_Waiting_on_C</fullName>
        <field>Survey_Status__c</field>
        <literalValue>Autoclose - Waiting on Client</literalValue>
        <name>Survey Status = Autoclose - Waiting on C</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Status_Close_Survey_Last_30_Day</fullName>
        <field>Survey_Status__c</field>
        <literalValue>Close Survey Last 30 Days</literalValue>
        <name>Survey Status = Close Survey Last 30 Day</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Status_Closed_Inbound_Email</fullName>
        <field>Survey_Status__c</field>
        <literalValue>Closed Inbound Email</literalValue>
        <name>Survey Status = Closed Inbound Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Status_Closed_with_Survey</fullName>
        <field>Survey_Status__c</field>
        <literalValue>Closed with Survey</literalValue>
        <name>Survey Status = Closed with Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEST</fullName>
        <field>Subject</field>
        <formula>&quot;Eligible for Close WFR&quot;</formula>
        <name>TEST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Technician_BC</fullName>
        <description>If Platform =  Interspire, ProStores or Yahoo</description>
        <field>Technician__c</field>
        <literalValue>Bigcommerce</literalValue>
        <name>Technician = BC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Technician_C2C</fullName>
        <description>WFR: Migration: Technicial Default to C2C</description>
        <field>Technician__c</field>
        <literalValue>Cart2Cart</literalValue>
        <name>Technician = C2C</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Flag_for_PXU</fullName>
        <description>Update the case flag for escalated Pixel Union support cases</description>
        <field>Case_Flag__c</field>
        <literalValue>PXU</literalValue>
        <name>Update Case Flag for PXU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Reason_to_Jira</fullName>
        <description>Update Case Reason to Jira</description>
        <field>Reason</field>
        <literalValue>JIRA</literalValue>
        <name>Update Case Reason to Jira</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Insight_Billing_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Insights_Billing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Insight Billing Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verification_Date_Now</fullName>
        <field>Verification_Date__c</field>
        <formula>NOW()</formula>
        <name>Verification Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verification_Date_Populated</fullName>
        <field>Verification_Date__c</field>
        <formula>Now()</formula>
        <name>Verification Date Populated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_on_Client_Date_Now</fullName>
        <field>Waiting_Date__c</field>
        <formula>Now()</formula>
        <name>Waiting on Client Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Green</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Green</literalValue>
        <name>WorkIt! Case Overtime Level: Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Red</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Red</literalValue>
        <name>WorkIt! Case Overtime Level: Red</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Yellow</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Yellow</literalValue>
        <name>WorkIt! Case Overtime Level: Yellow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Case_Allow_Update_to_On</fullName>
        <field>WorkIt2__Allow_Update__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set Case &quot;Allow Update&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Closed_with_Package_to_On</fullName>
        <field>WorkIt2__Closed_with_Package__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set &quot;Closed with Package&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Don_t_Time_to_Off</fullName>
        <field>WorkIt2__Dont_Time__c</field>
        <literalValue>0</literalValue>
        <name>WorkIt! Set &quot;Don&apos;t Time&quot; to Off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Don_t_Time_to_On</fullName>
        <field>WorkIt2__Dont_Time__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set &quot;Don&apos;t Time&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>reset_Send_Email_Initial</fullName>
        <description>Reset checkbox after sending email</description>
        <field>Send_Initial_Email__c</field>
        <literalValue>0</literalValue>
        <name>reset Send Email Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>rvee__NotifyRVMemberReset</fullName>
        <field>rvpe__NotifyRVMember__c</field>
        <literalValue>0</literalValue>
        <name>Notify RV Member Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <flowActions>
        <fullName>Trigger_Insight_Billing_Flow</fullName>
        <description>Associates the insights billing case with the store opportunity, subscription, and account.</description>
        <flow>Insights_Billing</flow>
        <flowInputs>
            <name>CaseID</name>
            <value>{!Id}</value>
        </flowInputs>
        <flowInputs>
            <name>StoreID</name>
            <value>{!Subject}</value>
        </flowInputs>
        <label>Trigger Insight Billing Flow</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <rules>
        <fullName>All %3A %22Client Notification Email%22 Population</fullName>
        <actions>
            <name>Client_Notification_Email_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the email address that case open and closure notifications go to
Set by hierarchy : Contact &gt; Lead &gt; Web Email &gt; Subscription Email</description>
        <formula>DATEVALUE( CreatedDate ) = TODAY() 
|| ISCHANGED( ContactId ) = TRUE 
|| ISCHANGED( Lead__c ) = TRUE 
|| ISCHANGED( Subscription__c ) = TRUE
|| ISCHANGED (  Opportunity__c ) = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>All %3A Auto Close Spam Cases</fullName>
        <actions>
            <name>Case_Reason_Trash_Spam</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Do_Not_Send_Survey_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Owner_Trash_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 4) OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>email loop protection,Undelivered Mail Returned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Homestead Bigcommerce Store cancellation request</value>
        </criteriaItems>
        <description>Loop Protection, mailer-daemon, postmaster</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Associate Store to Insight Billing Case</fullName>
        <actions>
            <name>Trigger_Insight_Billing_Flow</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <description>Associate Store to Insight Billing Case</description>
        <formula>isblank(Opportunity__c) &amp;&amp;   ISPICKVAL(Origin, &quot;Insight Billing&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Autoresponse%3A Premium Account Services</fullName>
        <actions>
            <name>Autoresponse_BC_Consulting</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Premium Services Email</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Backpay Request Date %3D Today</fullName>
        <actions>
            <name>Backpay_Requested_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Partner Support Record Type: Update Backpay Request Date to today when Backpay Requested is checked.</description>
        <formula>ISCHANGED(Backpay_Requested__c) &amp;&amp;  Backpay_Requested__c = TRUE &amp;&amp; ISBLANK(Backpay_Requested_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Billing %3A Case Closed Notification</fullName>
        <actions>
            <name>Billing_Closed_Case_Notification_to_Client</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 2) OR (2 AND 3)) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web,billing@bigcommerce.com,cancellations@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Send_Client_Email_Notifications__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends case closure notification email to client IF the Send Client Email Notifications box is checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Billing %3A Case Opened Notification</fullName>
        <actions>
            <name>Billing_Open_Case_Notification_to_Client</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web,billing@bigcommerce.com,cancellations@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Send_Client_Email_Notifications__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends case opened notification email to client IF the Send Client Email Notifications box is checked</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS %3A Status %3D On Hold</fullName>
        <actions>
            <name>On_Hold_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>On_Hold_Reason_Status_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>capture date &amp; reason</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS %3A Transfer to Trash Queue Closes Case</fullName>
        <actions>
            <name>Case_Reason_Trash_Spam</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Do_Not_Send_Survey_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (1 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Support - Trash</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>Escalation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <description>Closes case when transferred to Trash Queue if RT is Billing or User Role contains Escalation + RT = CS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS %3A Update Subscription Email field on Case</fullName>
        <actions>
            <name>Case_SetSubscriptionEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a Subscription is assigned to a Case, set the Subscription Email field from the email associated to the Subscription record.  Used for Email notifications.</description>
        <formula>NOT( ISNULL( Subscription__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS -Email Chat Case transcript</fullName>
        <actions>
            <name>send_email_with_chat_transcript</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Chat_Transcript_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Email Chat Transcript when chat is ended</description>
        <formula>ISPICKVAL(Origin, &apos;Chat&apos;) &amp;&amp;  Total_Chat_Time__c &gt; 0
&amp;&amp;  Chat_Transcript_Sent__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A Case Open Notification</fullName>
        <actions>
            <name>CS_Notify_Case_Opened</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 or 5) and 6</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Documentation_Only__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Pixel Union Themes,support@bigcommerce.com (closed),apisupport@bigcommerce.com,SBD - Escalations,Phone,Sift Science,eigsupport@bigcommerce.com,heartlandsupport@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Bigcommerce |,email loop protection,Undelivered Mail Returned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>support+bc@pixelunion.net,mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subscription_Purchase_Team__c</field>
            <operation>notEqual</operation>
            <value>SBD</value>
        </criteriaItems>
        <description>Sends case opened notification to client when the case is not for documentation only</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A Closed By</fullName>
        <actions>
            <name>Case_Closed_By_Current_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Closed_By__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success,Billing</value>
        </criteriaItems>
        <description>Updates closed by with the current user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A PA Date</fullName>
        <actions>
            <name>Pending_Acceptance_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending Acceptance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <description>Captures date the status was changed to Pending Acceptance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A Reopen Checkbox</fullName>
        <actions>
            <name>Reopened_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Reopened</value>
        </criteriaItems>
        <description>If case status changes to Reopened, check the box called reopened.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A WOC Date</fullName>
        <actions>
            <name>Waiting_on_Client_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting on Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <description>Updates the waiting date when the status is changed to Waiting on Client</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS Email %3A API Case Opened</fullName>
        <actions>
            <name>CS_Notify_API_Case_Opened</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 and 5 and 6 and 7 and 8</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subscription_Purchase_Team__c</field>
            <operation>notEqual</operation>
            <value>Strategic Business Development</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>support@bigcommerce.com (closed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection,Undelivered Mail Returned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Documentation_Only__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>apisupport@bigcommerce.com</value>
        </criteriaItems>
        <description>Sends case opened notification for CS if case is NOT for documentation only and the origin is equal to API</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS Email %3A New Email Sent to support%40bigcommerce%2Ecom</fullName>
        <actions>
            <name>CS_New_Case_Sent_to_support_bigcommerce_com</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Reason_support_bc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Do_Not_Send_Survey_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>support@bigcommerce.com (closed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>loop protection,Undelivered Mail Return</value>
        </criteriaItems>
        <description>If client emails support@bigcommerce.com without case reference, automatically close new case and email client directing them to open case via chat, web, or phone</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS Enterprise Case Manager Notification</fullName>
        <actions>
            <name>Premium_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Priority_is_Enterprise</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Bigcommerce_Plan__c</field>
            <operation>equals</operation>
            <value>bigcommerce enterprise plan,bigcommerce enterprise plan subsidiary,Bigcommerce Enterprise Plan Plus SLA,Enterprise Tier 1 Plan,Enterprise Tier 2 Plan,Enterprise Tier 3 Plan,Enterprise Tier 4 Plan</value>
        </criteriaItems>
        <description>Update status to Enterprise and send an email to Client Success Escalation managers when an Enterprise client submits a Support  case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS%3A Auto Close Pending Acceptance</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending Acceptance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subscription_Purchase_Team__c</field>
            <operation>notEqual</operation>
            <value>SBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <description>Auto closes the case on day 3 after the status is changed to Pending Acceptance.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Added_to_Auto_Close_True</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Closed_By_Current_User</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Survey_Status_AutoClose_Pending_Acce</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Pending_Acceptance_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CS%3A Auto Close Waiting on Client - No Case Closed Email or Survey at Closure</fullName>
        <actions>
            <name>Do_Not_Send_Survey_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting on Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subscription_Purchase_Team__c</field>
            <operation>notEqual</operation>
            <value>SBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <description>Email notification on day 4 that case will be closed then auto closes the case on day 5 after the status is changed to Waiting on Client. No survey email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Added_to_Auto_Close_True</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Closed_By_Current_User</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Survey_Status_Autoclose_Waiting_on_C</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Waiting_Date__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Client_Success_Contact_Waiting_on_Customer_Status_96_hrs</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WFR_Emailed_Auto_Close_Warning</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Case.Waiting_Date__c</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CS%3A SBD Escalations Autoresponse</fullName>
        <actions>
            <name>CS_SBD_Escalation_Autoresponse_to_Client</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>SBD - Escalations,Sift Science,eigsupport@bigcommerce.com,heartlandsupport@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection,Undelivered Mail Returned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <description>Sends an autoresponse when an SBD escalation case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS%3A SBD Internal Escalations Email Notification</fullName>
        <actions>
            <name>Send_SBD_Escalations_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>SBD - Escalations,Sift Science,eigsupport@bigcommerce.com,heartlandsupport@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Emails the Escalations team when a new SBD Escalations case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS%3A Send Cancellation Survey</fullName>
        <actions>
            <name>Send_Cancellation_Survey</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Survey_Sent_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Survey_Sent_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cancellations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Bigcommerce_Plan__c</field>
            <operation>notEqual</operation>
            <value>Pro Bronze,Pro Gold,Pro Platinum,Pro Silver,Go Bronze,Go Gold,Go Platinum,Go Silver</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Cancellation Reasons</value>
        </criteriaItems>
        <description>Sends the Cancellation Survey to clients who cancel</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS%3A Send Case Closed Notification with Survey Email 2 Hr Delay</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND (7 or 8) AND 9 AND 10 AND 11</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_Not_Send_Survey__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Owner_Team__c</field>
            <operation>notEqual</operation>
            <value>SBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success,Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>legal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Documentation_Only__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>notEqual</operation>
            <value>SBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Employee Account</value>
        </criteriaItems>
        <description>Sends Client Success Survey Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CS_Status_Closed_Case_Closed_With_Survey</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Survey_Sent_Date_Now</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Survey_Sent_True</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>WFR_Emailed_Survey</name>
                <type>Task</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CS%3A Set Do Not Send Survey to True</fullName>
        <actions>
            <name>Case_Do_Not_Send_Survey_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For cases with &quot;Do Not Send Survey&quot; to true, clear it (set to false) if status is changed and case isn&apos;t closed, and a survey hasn&apos;t already been sent</description>
        <formula>Do_Not_Send_Survey__c = TRUE &amp;&amp;
Survey_Sent__c = FALSE &amp;&amp;
ISCHANGED(Status) &amp;&amp;
NOT(ISPICKVAL(Status,&quot;Closed&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cancellation %3A Created with cancellations%40 Origin</fullName>
        <actions>
            <name>Case_Reason_Cancellation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>cancellations@bigcommerce.com</value>
        </criteriaItems>
        <description>Updates made to the case Department &amp; Reason when Case Origin is cancellations@bigcommerce.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Monitor after First OCR Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_Log__c</field>
            <operation>contains</operation>
            <value>First OCR Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Issue_Resolved__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Auto-Closed,Open Unsolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OCR_Resolution__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Send_Second_OCR_Response_Email</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Monitor after Second OCR Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_Log__c</field>
            <operation>contains</operation>
            <value>Second OCR Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Issue_Resolved__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Auto-Closed,Open Unsolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OCR_Resolution__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Send_Final_OCR_Closure_email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Case_Email_Log_Final_OCR_Response</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Status_Auto_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case%3A Client Referral Program Cancellation</fullName>
        <actions>
            <name>Send_Marketing_Public_Client_Cancel_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Client_reference_store_count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Record_Type_ID__c</field>
            <operation>equals</operation>
            <value>012a0000001NYWL</value>
        </criteriaItems>
        <description>Notifies Client Referral team when a Client Referral Program store client submits a cancellation case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Enterprise Cancellation Case Notification</fullName>
        <actions>
            <name>Case_Enterprise_Cancellation_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Bigcommerce_Plan__c</field>
            <operation>equals</operation>
            <value>bigcommerce enterprise plan,Bigcommerce Enterprise Plan Plus SLA,Enterprise Tier 3 Plan,Enterprise Tier 4 Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Record_Type_ID__c</field>
            <operation>equals</operation>
            <value>012a0000001NYWL</value>
        </criteriaItems>
        <description>Notifies Client Experience Leads when an Enterprise client submits a cancellation case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A OCR Close Case on Client Accepting Resolution</fullName>
        <actions>
            <name>Case_Status_Auto_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Issue_Resolved__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Owner to Support on Client Accepting Resolution</fullName>
        <actions>
            <name>Case_Owner_Support_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Issue_Resolved__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalated__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tier_2_Request_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update after Issue Resolved%3F %3D No</fullName>
        <actions>
            <name>Case_Reset_OCR_Resolution</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Status_Open_Unsolved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Issue_Resolved__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Insight Billing Cases</fullName>
        <actions>
            <name>Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Insight Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Default Email to Case</value>
        </criteriaItems>
        <description>Rule that closes Insight Billing Cases when they are created as requested by Friedrich Stegmann on 1/15/2016 in reference to BAP-2721.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close Partner Deal Reg Case</fullName>
        <actions>
            <name>Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Partner Deal Registration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>New Deal Registration Received</value>
        </criteriaItems>
        <description>Set Partner Deal Registration cases created by email-to-case are Closed on creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EAM Enterprise Case Manager Notification</fullName>
        <actions>
            <name>Email_Enterprise_Account_Managers_when_an_Enterprise_Support_Case_is_Opened</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Bigcommerce_Plan__c</field>
            <operation>equals</operation>
            <value>bigcommerce enterprise plan,bigcommerce enterprise plan subsidiary,Bigcommerce Enterprise Plan Plus SLA,Enterprise Tier 3 Plan,Enterprise Tier 4 Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success,Billing,Cancellations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Bigcommerce_Plan__c</field>
            <operation>notContain</operation>
            <value>Tier 1,Tier 2</value>
        </criteriaItems>
        <description>Update status to Enterprise and send an email to Enterprise Account Managers group  when an Enterprise client submits a support case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EIG Billing Trash Cases</fullName>
        <actions>
            <name>Set_Case_owner_to_Billing_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>EIG Billing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Support - Trash</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Move EIG Billing cases that go to trash out of trash</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Refund%2FCredit Approver</fullName>
        <actions>
            <name>Refund_Credit_Approver_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sends an email alert to the refund/credit approver when a refund/credit billing case is created and the approver is selected.</description>
        <formula>(ISNEW()&amp;&amp; NOT(ISNULL(Refund_Credit_Approver__c))) ||
ISCHANGED(Refund_Credit_Approver__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Filter for closing Email to Case Spam</fullName>
        <actions>
            <name>Close_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 or 4 or 5 or 6</booleanFilter>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Want more Likes for your Facebook?</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>ク,ロ,エ,財,布,公,式,コ,ー,チ,レ,ザ,特,別,訳,あ,り,特,価</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Automatic reply</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Account transferred to you.</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>New lead assigned to you:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>peter@pjwaters.com.au</value>
        </criteriaItems>
        <description>Move spam cases to trash queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MIG Case - Credential Reminder - Admin</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Migration_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Migration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Requirements</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Migration_Email_Type__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>MIG Case - Credential Reminder - Admin</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Migration_Re_Request_Admin</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Increment_Migration_Credential_Request</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Status_to_Re_Requested_Credentials</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Case - Credential Reminder - Admin %26 FTP</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Migration_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Migration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Requirements</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Migration_Email_Type__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>MIG Case - Credential Reminder - Admin &amp; FTP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Migration_Re_Request_Admin_and_FTP</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Increment_Migration_Credential_Request</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Status_to_Re_Requested_Credentials</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Case Creation - Admin %26 FTP</fullName>
        <actions>
            <name>Send_Migration_Kick_off_Admin_and_FTP_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Migration_Credential_Requests_to_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Awaiting_Requirements</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Migration_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Migration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Migration_Email_Type__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>MIG Case Creation - Admin &amp; FTP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Case Creation - Admin Only</fullName>
        <actions>
            <name>Send_Migration_Kick_off_Admin_Only_Emails</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Migration_Credential_Requests_to_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Awaiting_Requirements</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Migration_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Migration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Migration_Email_Type__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>MIG Case Creation - Admin Only</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Case Withdrawn</fullName>
        <actions>
            <name>Send_Migration_Withdrawn_to_Client</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Migration_Withdrawn_to_Internal_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>MIG Case Withdrawn</description>
        <formula>Migration_Automated_Emails__c &amp;&amp;  RecordType.Name = &apos;Migration&apos; &amp;&amp;  ISPICKVAL(Status, &apos;Withdrawn&apos;) &amp;&amp;  ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MIG Client Approves Data Migration</fullName>
        <actions>
            <name>Migration_Migration_Complete_with_CSAT</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Migration_Support_Dept_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Migration_Verification_Client_Verified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Verification_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>MIG Client Approves Data Migration</description>
        <formula>Migration_Automated_Emails__c &amp;&amp; RecordType.Name = &apos;Migration&apos; &amp;&amp; ISPICKVAL(Status, &apos;Closed&apos;) &amp;&amp; ISCHANGED(Status) &amp;&amp; ISPICKVAL(Migration_Verified_Clicktools__c, &apos;Yes&apos;) &amp;&amp; ISCHANGED(Migration_Verified_Clicktools__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MIG Credentials Received</fullName>
        <actions>
            <name>Status_Requirements_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Survey_Completion_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Migration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>,Awaiting Requirements,Re-Requested Credentials</value>
        </criteriaItems>
        <description>MIG Credentials Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MIG Data Migration Rejected</fullName>
        <actions>
            <name>Migration_Reviewing_your_Verification_Notes</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Increment_UAT_Review_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>MIG Data Migration Rejected</description>
        <formula>Migration_Automated_Emails__c &amp;&amp; RecordType.Name = &apos;Migration&apos; &amp;&amp; ISPICKVAL(Status, &apos;UAT Review&apos;) &amp;&amp; ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MIG No Cred --%3E Requirements Review</fullName>
        <actions>
            <name>Status_Requirements_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>MIG - Update a case status from &quot;no credentials&quot; to &quot;Requirements review&quot; when a new survey is submitted on the case.</description>
        <formula>RecordTypeId = &apos;012a0000001NV9N&apos; &amp;&amp;
ISPICKVAL(Status, &apos;No Credentials&apos;) &amp;&amp;
ISCHANGED( Survey_Completion_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MIG No Credential Received</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-Requested Credentials</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MIG_Credentials_Requests__c</field>
            <operation>greaterThan</operation>
            <value>1</value>
        </criteriaItems>
        <description>MIG No Credential Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Status_No_Credentials</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Re-Request for Invalid Credentials</fullName>
        <actions>
            <name>Migration_Invalid_Credential_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Increment_Migration_Credential_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Migration_Clear_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Re_Requested_Credentials</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>MIG Re-Request for Invalid Credentials</description>
        <formula>Migration_Automated_Emails__c &amp;&amp; RecordType.Name = &apos;Migration&apos; &amp;&amp; ISPICKVAL(Status, &apos;Invalid Credentials&apos;) &amp;&amp; ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MIG Reverification and Close</fullName>
        <active>true</active>
        <description>MIG Reverification and Close</description>
        <formula>Migration_Automated_Emails__c &amp;&amp; RecordType.Name = &apos;Migration&apos; &amp;&amp; ISPICKVAL(Status, &apos;Awaiting Re-Verification&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Migration_Migration_Complete_No_CSAT</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Case_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Migration_Verification_Autoverified</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Migration_Support_Dept_to_Migration</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Verification_Date_Now</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Send Initial Data Spot Check Email %26 Reminder %26 Auto Close 2</fullName>
        <actions>
            <name>Migration_Data_Spot_Check_1st_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>MIG Send Initial Data Spot Check Email &amp; Reminder</description>
        <formula>Migration_Automated_Emails__c &amp;&amp; RecordType.Name = &apos;Migration&apos; &amp;&amp; ISPICKVAL(Status, &apos;Awaiting Verification&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Migration_Migration_Complete_No_CSAT</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Case_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Migration_Verification_Autoverified</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Migration_Support_Dept_to_Migration</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Verification_Date_Now</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Migration_Data_Migration_24_hour_reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Update Autoverified Closed Case</fullName>
        <active>true</active>
        <description>MIG Update Autoverified Closed Case</description>
        <formula>Migration_Automated_Emails__c &amp;&amp;  RecordType.Name = &apos;Migration&apos; &amp;&amp;  ISPICKVAL(Status, &apos;Closed&apos;) &amp;&amp; ISPICKVAL( Migration_Verification__c, &apos;Auto Verified&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Migration_Delayed_CSAT_Survey</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Migration_Support_Dept_Support</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MIG Valid Credentials Received</fullName>
        <actions>
            <name>Migration_Valid_Credentials_Received</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Valid_Credentials_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>MIG Valid Credentials Received</description>
        <formula>Migration_Automated_Emails__c &amp;&amp; RecordType.Name = &apos;Migration&apos; &amp;&amp; ISPICKVAL(Status, &apos;Assigned&apos;) &amp;&amp; ISCHANGED(Status) &amp;&amp; ISNULL(Valid_Credentials_Received__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PAR%3A Close PAR cases 5 Days after Waiting on Client</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>partners@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting on Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Partner</value>
        </criteriaItems>
        <description>Closes Channel Partner cases 5 days after it&apos;s been set to waiting on client.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Partner_Notify_Waiting_on_Client_5</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Added_to_Auto_Close_True</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PS%3A New Case Notification</fullName>
        <actions>
            <name>PS_New_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <description>Email notification to the case when a new case is created for Professional Services.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Parent Owner Email Population</fullName>
        <actions>
            <name>Parent_Owner_Email_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If account or lead is changed, populate the owner&apos;s email for WFRs</description>
        <formula>DATEVALUE(CreatedDate )=TODAY() || ISCHANGED( Subscription__c ) = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pixel Union Email Support</fullName>
        <actions>
            <name>Case_Origin_Pixel_Union_Themes</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Reason_No_Support_Provided</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Category_Other</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Do_Not_Send_Survey_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reopened_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>escalation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Client_Notification_Email__c</field>
            <operation>equals</operation>
            <value>support+bc@pixelunion.net</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Normal</value>
        </criteriaItems>
        <description>This rule handles cases that are being handled by the Pixel Union Support Team.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pixel Union Escalated Support</fullName>
        <actions>
            <name>Update_Case_Flag_for_PXU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Client_Notification_Email__c</field>
            <operation>equals</operation>
            <value>support+bc@pixelunion.net</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>escalation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <description>This rule handles cases that are being escalated to the Client Success team from the Pixel Union Support Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales %3A Notification to Rep of New Sales Case</fullName>
        <actions>
            <name>New_Sales_Case_Notification_to_Sales_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web,sales@bigcommerce.com,partners@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Partner</value>
        </criteriaItems>
        <description>Intended to send an email to the owner of the case&apos;s account or lead when a new sales case comes in.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Default Email</fullName>
        <actions>
            <name>Sent_Default_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>reset_Send_Email_Initial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Send_Initial_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send email with subject and description using the Send Email checkbox on the case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Professional Services Auto Closed Email</fullName>
        <actions>
            <name>Send_PS_Email_that_we_ve_autoclosed_the_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Outcome__c</field>
            <operation>equals</operation>
            <value>Autoclosed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Send the &quot;We Know You&apos;r Busy&quot; email when autoclosing a case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Professional Services Survey</fullName>
        <actions>
            <name>Store_Launched_Case_Survey</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Survey_Sent_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Outcome__c</field>
            <operation>equals</operation>
            <value>Paid Store Setup,Orion Store Setup,Courtesy Store Setup,Upsell Store Setup,Partner Store Setup,Platinum Plus Store Setup,Consultation Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Send the Store Launched CSAT when the case outcome is set to a launchd status and the Survey Sent box = False</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send SOW Email to Prof Services Cases</fullName>
        <actions>
            <name>Email_SOW</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_SOW_Email</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Product_Sold__c</field>
            <operation>equals</operation>
            <value>Platinum Next Store Setup,Platinum Next Store Setup + Migration,Platinum Plus Store Setup,Platinum Plus Store Setup + Migration,Store Setup,Migration+Store Set Up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Send SOW Email to new Prof Services Cases for specific &quot;product sold&quot; values</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Employee Accounts Subject Name</fullName>
        <actions>
            <name>Set_Employee_Account_Subject_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Employee Account</value>
        </criteriaItems>
        <description>Sets the Employee Account case subject if it is not correct</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WorkIt%21 Allow update</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Case_Allow_Update_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.WorkIt2__Allow_Update__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WorkIt2__WorkIt%21 Case Close</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Closed_with_Package_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WorkIt2__WorkIt_Set_Don_t_Time_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Makes WorkIt! stop timing a case when it&apos;s closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WorkIt2__WorkIt%21 Case Open</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Don_t_Time_to_Off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Makes WorkIt! start timing a case when it&apos;s opened.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>rvee__Notify RV Member</fullName>
        <actions>
            <name>rvee__NotifyRVMemberReset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(rvpe__NotifyRVMember__c == true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Cancellation_Survey_Sent_Testing</fullName>
        <assignedTo>maria.huemmer@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Cancellation Survey Sent Testing</subject>
    </tasks>
    <tasks>
        <fullName>Orion_Launch_Email_Sent</fullName>
        <assignedTo>miles.leymeister@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The Orion Launch email has been sent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Orion Launch Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>Post_Migration_Follow_Up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Follow up with SS to confirm Client Store Launch once data migration process is complete.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Verification_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Post-Migration Follow-Up</subject>
    </tasks>
    <tasks>
        <fullName>Send_SOW_Email</fullName>
        <assignedToType>owner</assignedToType>
        <description>Sent the Store Launch SOW email</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Send SOW Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_Orion_Day_4_Migration_Email</fullName>
        <assignedToType>owner</assignedToType>
        <description>Sent Orion Day 4 Migration Email</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent Orion Day 4 Migration Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_Orion_Day_8_Migration_Email</fullName>
        <assignedToType>owner</assignedToType>
        <description>Sent Orion Day 8 Migration Email</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent Orion Day 8 Migration Email</subject>
    </tasks>
    <tasks>
        <fullName>WFR_Emailed_Auto_Close_Warning</fullName>
        <assignedToType>owner</assignedToType>
        <description>Emailed client auto close warning. Email Template: Case 96 Hour Closure Warning Contact</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>WFR: Emailed Auto Close Warning</subject>
    </tasks>
    <tasks>
        <fullName>WFR_Emailed_Survey</fullName>
        <assignedToType>owner</assignedToType>
        <description>Sent Survey Email</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>WFR: Send Client Success CSAT Survey</subject>
    </tasks>
</Workflow>
