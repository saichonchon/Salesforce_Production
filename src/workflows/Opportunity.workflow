<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email</fullName>
        <description>Email Pre-Sales Consultant when purchase has been made.</description>
        <protected>false</protected>
        <recipients>
            <recipient>Pre-Sales Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Opp_New_Purchase_Made</template>
    </alerts>
    <alerts>
        <fullName>Email_Account_Owner</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>Email Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/New_Trial_Opp_not_owned_by_Account_Owner</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_lead_converted</fullName>
        <description>Email Alert - lead converted</description>
        <protected>false</protected>
        <recipients>
            <recipient>maggie.frederick@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maria.huemmer@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/TesT123</template>
    </alerts>
    <alerts>
        <fullName>Email_Migraiton_Team_of_new_prescoping_opportunity</fullName>
        <description>Email Migration Team of new prescoping opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>john.mcleod@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kris.westlund@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Migration_prescoping_details</template>
    </alerts>
    <alerts>
        <fullName>Email_Opp_Owner_of_Closed_Won_OpportunityWFR</fullName>
        <description>Email Opp Owner of Closed Won Opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Upgrade_Opportunity_Close_Won_2</template>
    </alerts>
    <alerts>
        <fullName>Email_Sales_Rep_that_Prescoping_is_complete</fullName>
        <description>Email Sales Rep that Prescoping is complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>Pre-Sales Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Migration_prescoping_details</template>
    </alerts>
    <alerts>
        <fullName>Email_opp_owner</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>Email opp owner of plan change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Opp_Product_Change_Notice</template>
    </alerts>
    <alerts>
        <fullName>Enterprise_Partner_Request_Approved</fullName>
        <description>Enterprise Partner Request Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Enterprise_Partner_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Enterprise_Partner_Request_Rejected</fullName>
        <description>Enterprise Partner Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Enterprise_Partner_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Enterprise_Sales_Closed_Opp_Notification</fullName>
        <description>Enterprise Sales: Closed Opp Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>alecia.wall@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>russell.griffin@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sachin.wadhawan@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Workflow_Communications_Sales/Closed_Enterprise_Deal</template>
    </alerts>
    <alerts>
        <fullName>Executive_Sponsorship</fullName>
        <description>Executive Sponsorship</description>
        <protected>false</protected>
        <recipients>
            <recipient>russell.griffin@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Executive_Sponsorship__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Executive_Sponsorship_Notification</template>
    </alerts>
    <alerts>
        <fullName>MKT_Featured_client_churned</fullName>
        <ccEmails>marketingteam@bigcommerce.com, comms@bigcommerce.com</ccEmails>
        <description>MKT Featured client churned notification</description>
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
        <fullName>Notification_of_new_oppty_for_Professional_Services</fullName>
        <ccEmails>team-billing@bigcommerce.com</ccEmails>
        <description>PS Opp Notification to Bill Client for Migration in MBA</description>
        <protected>false</protected>
        <recipients>
            <recipient>Migration_Specialists</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>adam.ferenzi@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>timothy.shuman@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Oppty_New_Professional_Services_Added</template>
    </alerts>
    <alerts>
        <fullName>Notify_Opp_Owner_of_Store_Plan_Change</fullName>
        <description>KEEP Notify Opp Owner of Store Plan Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Product_Change_Alert_Opp</template>
    </alerts>
    <alerts>
        <fullName>Notify_Opp_Owner_of_store_cancellation</fullName>
        <description>Notify Opp Owner of store cancellation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Opp_Cancellation_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>Product_Change_Notice_to_Owner_Opp</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>Product Change Notice to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Product_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>SBD_Intuit_Plus_Plan_Email</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>SBD Intuit Plus Plan Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SBD_Paypal_Braintree/Intuit_Promo_Email_Plus</template>
    </alerts>
    <alerts>
        <fullName>SBD_Intuit_Standard_Plan_Email</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>SBD Intuit Standard Plan Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SBD_Paypal_Braintree/Intuit_Promo_Standard</template>
    </alerts>
    <alerts>
        <fullName>Send_Approved_Email</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>Send Client Reference Program Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Client_Reference_Nomination_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_Cancellation_notice_to_Opp_Owner</fullName>
        <description>Send Cancellation notice for Showcase stores</description>
        <protected>false</protected>
        <recipients>
            <recipient>john.yarbrough@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Opp_Cancellation_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>Send_Client_Reference_Program_Decline_Email</fullName>
        <ccEmails>maria.huemmer@bigcommerce.com</ccEmails>
        <description>Send Client Reference Program Declined Email</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Client_Reference_Nomination_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_Grow_Bundle_Email_to_Client</fullName>
        <description>Send Plus Plan Grow Bundle Email to Client -  SBD Paypal Braintree</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>coaches@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SBD_Paypal_Braintree/Grow_Bundle_Store_Setup</template>
    </alerts>
    <alerts>
        <fullName>Send_Migration_prescoping_details_to_Enterprise_Partner_team</fullName>
        <description>Send Migration prescoping details to Enterprise Partner team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>russell.griffin@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Migration_prescoping_details</template>
    </alerts>
    <alerts>
        <fullName>Send_Standard_Plan_Launch_Email_to_Client_SBD_Paypal_Braintree</fullName>
        <description>Send Standard Plan Launch Email to Client  - SBD Paypal Braintree</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>coaches@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SBD_Paypal_Braintree/Launch_Bundle_Standard_Plan</template>
    </alerts>
    <alerts>
        <fullName>When_an_app_is_approved_and_launched</fullName>
        <description>When an app is approved and launched</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/App_Approved</template>
    </alerts>
    <alerts>
        <fullName>When_an_app_is_rejected_and_requires_work</fullName>
        <description>When an app is rejected and requires work</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/App_Rejected</template>
    </alerts>
    <alerts>
        <fullName>When_an_app_is_submitted_for_review_in_the_App_Registry</fullName>
        <description>When an app is submitted for review in the App Registry</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/App_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>BA_Test_Opportunity_False</fullName>
        <field>BA_Testing_Opportunity__c</field>
        <literalValue>0</literalValue>
        <name>BA Test Opportunity = False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bigcommerce_Approved</fullName>
        <field>Enterprise_Partner_Request_Status__c</field>
        <literalValue>Bigcommerce Approved</literalValue>
        <name>Set Status to Bigcommerce Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bigcommerce_Rejected</fullName>
        <field>Enterprise_Partner_Request_Status__c</field>
        <literalValue>Bigcommerce Rejected</literalValue>
        <name>Set Status to Bigcommerce Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bigcommerce_Review</fullName>
        <field>Enterprise_Partner_Request_Status__c</field>
        <literalValue>Bigcommerce Review</literalValue>
        <name>Bigcommerce Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Opportunity_Stage_to_SQL</fullName>
        <description>Change Opportunity Stage to Sales Qualified Lead</description>
        <field>StageName</field>
        <literalValue>Sales Qualified Lead</literalValue>
        <name>Change Opportunity Stage to SQL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Store_URL_TEXT</fullName>
        <description>Update Store URL text value</description>
        <field>Store_URL_TEXT__c</field>
        <formula>StoreURL__c</formula>
        <name>Copy Store URL TEXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FieldUpdate_CloseDate</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>FieldUpdate:CloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Closed_Lost_Reason</fullName>
        <description>Field Update:Closed Lost Reason to auto closed lost</description>
        <field>Closed_Lost_Reason__c</field>
        <literalValue>Auto Closed Lost</literalValue>
        <name>Set CL reason to Auto Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Stage_Change_Update</fullName>
        <field>Stage_Change_Date__c</field>
        <formula>Today()</formula>
        <name>Last Stage Change Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Most_Recent_Store_URL</fullName>
        <description>Updates a non-formula field for the most recent store URL when the most recent purchase  is changed so Marketo can use it in email templates</description>
        <field>Most_Recent_Store_URL__c</field>
        <formula>TemporaryStoreURL__c</formula>
        <name>Most Recent Store URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Referral_Update</fullName>
        <description>Field Update per BAP-2988</description>
        <field>Referral_ID__c</field>
        <formula>Contact__r.MBA_Referral_ID__c</formula>
        <name>Opp Referral Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_The_BigCommerce_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>team@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner: The BigCommerce Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_App_Approval_Date</fullName>
        <field>App_Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set App Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Client_Reference_Status_to_Approved</fullName>
        <description>Set Client Reference Status to Approved</description>
        <field>Client_Reference_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Client Reference Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Client_Reference_Status_to_Denied</fullName>
        <description>Set Client Reference Status to Denied</description>
        <field>Client_Reference_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Client Reference Status to Denied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_Stage_to_Closed_Won</fullName>
        <description>Set Opportunity Stage to Closed Won</description>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>Set Opportunity Stage to Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Revshare_signed_date</fullName>
        <description>Set Revshare signed date</description>
        <field>Revshare_Signed_Date__c</field>
        <formula>today()</formula>
        <name>Set Revshare signed date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>jennifer.schultz@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>jennifer.schultz@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Opportunity Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Closed_Lost</fullName>
        <field>StageName</field>
        <literalValue>Closed Lost</literalValue>
        <name>Update Stage to Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Migration_Prescoping</fullName>
        <description>Update Stage to Migration Prescoping</description>
        <field>StageName</field>
        <literalValue>Migration Pre Scoping</literalValue>
        <name>Update Stage to Migration Prescoping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>rvee__AssignedToPartnerModified</fullName>
        <field>rvpe__PartnerLastModifiedDate__c</field>
        <name>Assigned to Partner Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>rvee__AssignedToPartnerPending</fullName>
        <field>rvpe__PartnerOpportunityAcceptance__c</field>
        <literalValue>Pending</literalValue>
        <name>Assigned to Partner Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>rvee__AssignedToPartnerTimestamp</fullName>
        <field>rvpe__DateAssignedToPartner__c</field>
        <formula>NOW()</formula>
        <name>Assigned to Partner Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
    <fieldUpdates>
        <fullName>set_the_BA_Testing_Opportunity_field_to</fullName>
        <description>set the BA Testing Opportunity field to</description>
        <field>BA_Testing_Opportunity__c</field>
        <literalValue>1</literalValue>
        <name>set the BA Testing Opportunity field to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <flowActions>
        <fullName>Add_Opp_Contacts_to_Totango_Campaign</fullName>
        <description>Looks for changes in the opportunity insight field and adds contacts to appropriate Totango campaigns.</description>
        <flow>Opportunity_Contact_Campaign_Assignment</flow>
        <flowInputs>
            <name>OpportunityContactId</name>
            <value>{!Contact__c}</value>
        </flowInputs>
        <flowInputs>
            <name>tatangoInsight</name>
            <value>{!totango__TotangoInsights__c}</value>
        </flowInputs>
        <label>zAdd Opp Contacts to Totango Campaign</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <flowActions>
        <fullName>Invoke_Flow_to_Add_Opps_to_Lifecycle_Campaigns</fullName>
        <description>Adds opportunities to a campaigns for lifecycle marketing such as active trials, active stores.</description>
        <flow>Flow_for_Trial_Record_Type_Opportunity</flow>
        <flowInputs>
            <name>OpportunityContactID</name>
            <value>{!Contact__c}</value>
        </flowInputs>
        <flowInputs>
            <name>OpportunityStatus</name>
            <value>{!Status__c}</value>
        </flowInputs>
        <flowInputs>
            <name>recordTypeID</name>
            <value>{!RecordTypeId}</value>
        </flowInputs>
        <label>zInvoke Flow to Add Opps to Lifecycle Campaigns</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <outboundMessages>
        <fullName>Deal_Registration_Approved_Outbound</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://partners.bigcommerce.com/services/SFDC-DealRegistrationApproved.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>maria.huemmer@bigcommerce.com</integrationUser>
        <name>Deal Registration Approved Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>MRR</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/mon_rec_rev</endpointUrl>
        <fields>Amount</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>james.juarez@bigcommerce.com</integrationUser>
        <name>MRR</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Notify_Partner_Outbound</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://partners.bigcommerce.com/services/SFDC-OpportunityNotifyRVMember.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>treehouse@bigcommerce.com</integrationUser>
        <name>Notify Partner Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Opp_Won</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/oppwon</endpointUrl>
        <fields>Id</fields>
        <fields>StageName</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>james.juarez@bigcommerce.com</integrationUser>
        <name>Opp Won</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Total_MRR</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/bookings</endpointUrl>
        <fields>Amount</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>james.juarez@bigcommerce.com</integrationUser>
        <name>Total MRR</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Change the opportunity owner if landing page contains WSI</fullName>
        <actions>
            <name>Update_Account_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Opportunity_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LandingPage__c</field>
            <operation>contains</operation>
            <value>/wsi</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>notEqual</operation>
            <value>Jennifer Schultz</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>Jennifer Schultz</value>
        </criteriaItems>
        <description>If the opportunity landing page field contains WSI, this WFR will change the opportunity owner and account owner to Jennifer Schultz.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ClosedWon Opportunity Close Date</fullName>
        <actions>
            <name>FieldUpdate_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordTypeId=&apos;012a0000001Nayp&apos;, ISCHANGED(StageName), ISPICKVAL(StageName,&apos;Closed Won&apos;),    CloseDate  &lt;&gt;  TODAY()  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Store URL TEXT</fullName>
        <actions>
            <name>Copy_Store_URL_TEXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies store URL to text field to enable searching on create/edit</description>
        <formula>Store_URL_TEXT__c &lt;&gt; StoreURL__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Demo Request Task - Opportunity</fullName>
        <actions>
            <name>Demo_Requested</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>When a contact is added as a campaign member for a demo request, this date is set. Create a task for the contact owner. 
For BAP-3811</description>
        <formula>AND(  
NOT(ISBLANK(Demo_Requested_Date__c)),  
OR(
Owner.Profile.Id = &apos;00e13000000jUNJ&apos;, /* Lead Development Rep */  
Owner.Profile.Id = &apos;00e130000024OSc&apos;, /* Sales Rep */  
Owner.Profile.Id = &apos;00e13000000jUyt&apos;, /* Sales Rep - Dial on Opps */  
Owner.Profile.Id = &apos;00e130000024OSX&apos;  /* Sales Leader */ 
),
Owner.Id != &apos;005a000000AsxTo&apos; /* The BigCommerce Team */
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise%3A Opportunity Closed Notification</fullName>
        <actions>
            <name>Enterprise_Sales_Closed_Opp_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Notification that updates Enterprise Sales Management when an Opportunity has closed, whether one or lost.</description>
        <formula>OR(  
Owner.UserRoleId = &apos;00E13000001DGhr&apos;, /* Enterprise Leader */ 
Owner.UserRoleId = &apos;00E13000001DGi1&apos;  /* Enterprise Sales */ 
) &amp;&amp;  
IsClosed = True &amp;&amp; 
OR(  
IsWon = False &amp;&amp;  Projected__c = True,
IsWon = True &amp;&amp; Amount &gt; 500
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>KEEP Product Change Notification</fullName>
        <actions>
            <name>Notify_Opp_Owner_of_Store_Plan_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies Opp owner that the store plan has changed</description>
        <formula>((ISCHANGED(New_Product_Plan__c) &amp;&amp;
NOT(ISPICKVAL(Source__c, &quot;BMP&quot;))) ||
(ISPICKVAL(Source__c, &quot;BMP&quot;) &amp;&amp;
ISCHANGED(MonthlyRecurringRevenue__c) &amp;&amp;
MonthlyRecurringRevenue__c &gt; 0)) &amp;&amp;

(
   Owner.ProfileId &lt;&gt; $Label.Admin_Profiles &amp;&amp; 
   OwnerId &lt;&gt; &apos;0051300000BTCyk&apos; /* Marketing Team */ &amp;&amp; 
   OwnerId &lt;&gt; &apos;005a000000AsxTo&apos; /*The Bigcommerce Team */ )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Migration Prescoping Status Changed to New</fullName>
        <actions>
            <name>Email_Migraiton_Team_of_new_prescoping_opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Migration_Prescoping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Actions when the migration status on an opportunity is changed to new</description>
        <formula>ISCHANGED(Migration_Scoping_Status__c) &amp;&amp;  ISPICKVAL(Migration_Scoping_Status__c, &quot;New&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Migration Status Changed to Complete Status</fullName>
        <actions>
            <name>Email_Sales_Rep_that_Prescoping_is_complete</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_Opportunity_Stage_to_SQL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Actions when the migration status on an opportunity is changed to a status that completes the prescoping process</description>
        <formula>ISCHANGED(Migration_Scoping_Status__c) &amp;&amp;    (       ISPICKVAL(Migration_Scoping_Status__c,&quot;Complete&quot;) ||      ISPICKVAL(Migration_Scoping_Status__c,&quot;Blocked&quot;) ||      ISPICKVAL(Migration_Scoping_Status__c,&quot;Cancelled&quot;) ||      ISPICKVAL(Migration_Scoping_Status__c,&quot;Withdrawn&quot;)    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Migration Status Changed to Recommended to Partner</fullName>
        <actions>
            <name>Send_Migration_prescoping_details_to_Enterprise_Partner_team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Actions when the migration status on an opportunity is changed to recommended to partner</description>
        <formula>ISCHANGED(Migration_Scoping_Status__c) &amp;&amp;  ISPICKVAL(Migration_Scoping_Status__c, &quot;Recommended to a Partner&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Opp Team of Purchased Opp</fullName>
        <actions>
            <name>Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Store Purchase</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Purchased,Suspended</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PurchaseDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Email the Opportunity Team when a purchase has been made.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Trial Automatically close%2Flost opportunities owned by the Bigcommerce</fullName>
        <active>true</active>
        <description>Automatically close/lost trial opportunities owned by the Bigcommerce team or Marketing test user</description>
        <formula>((OwnerId  =&apos;005a000000AsxTo&apos;) || (OwnerId  =&apos;0051300000BTCyk&apos;)) &amp;&amp; ( ISPICKVAL(Status__c,&apos;Cancelled&apos;) ) &amp;&amp; RecordTypeId =&apos;01213000000AUty&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Field_Update_Closed_Lost_Reason</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Stage_to_Closed_Lost</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>33</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opp%3A Cancellation Notification</fullName>
        <actions>
            <name>Send_Cancellation_notice_to_Opp_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Store Purchase</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Suspended,Cancelled,Terminated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Client_Reference_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Notify the opportunity owner if the store goes to cancelled, suspended, or terminated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp%3A Owner Team Discrepancy</fullName>
        <actions>
            <name>Email_Account_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the opportunity owner if the store plan changes</description>
        <formula>(CONTAINS(RecordType.DeveloperName, &quot;Trial&quot;) ||
CONTAINS(RecordType.DeveloperName, &quot;Purchase&quot;)) &amp;&amp;
CONTAINS(Account.Owner_Team__c, &quot;partner&quot;) &amp;&amp;
Owner_Team__c !=  Account.Owner_Team__c &amp;&amp;
CONTAINS(Owner.Profile.Name, &quot;Sales Rep&quot;) &amp;&amp; 
DATEVALUE(CreatedDate) = TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp%3A Product Change Notice</fullName>
        <actions>
            <name>Email_opp_owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the opportunity owner if the store plan changes</description>
        <formula>CONTAINS(RecordType.DeveloperName, &quot;Store Purchase&quot;) &amp;&amp;
ISCHANGED(Product__c)&amp;&amp;
CONTAINS(Owner.Profile.Name, &quot;Sales Rep&quot;) &amp;&amp; 
NOT(CONTAINS( Owner.Full_Name__c, &quot;Team&quot;)) &amp;&amp; 
DATEVALUE(CreatedDate) &lt;&gt; TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A BA Test Opportunity %3D True</fullName>
        <actions>
            <name>BA_Test_Opportunity_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.BA_Testing_Opportunity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MonthlyRecurringRevenue__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>BAP-3748: Sets the BA Test Opportunity field to false (usually set to true due to being previously Closed Lost as &quot;Test Account&quot;) and it has a positive MRR associated with it.
**NOTE**  Field may no longer be valid in revenue report filtering.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3ASet the BA Testing Opportunity field to true</fullName>
        <actions>
            <name>set_the_BA_Testing_Opportunity_field_to</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the BA Testing Opportunity field to true</description>
        <formula>AND( RecordTypeId =&apos;01213000000AUty&apos; ,ISPICKVAL(Closed_Lost_Reason__c,&apos;Test Account&apos;),  ISCHANGED(Closed_Lost_Reason__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PS%3A Auto closed won %240 opps</fullName>
        <actions>
            <name>Set_Opportunity_Stage_to_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.HasOpportunityLineItem</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sale</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Automatically move PS Opps with a $0 amount to closed won so the migration case is created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Power Standing%3A SMB %2B TBT MRR</fullName>
        <actions>
            <name>Total_MRR</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Purchased,Closed Won</value>
        </criteriaItems>
        <description>All closed MRR owned by the Bigcommerce team or the SMB Team, including upgrades</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Power Standing%3A SMB MRR</fullName>
        <actions>
            <name>MRR</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Purchased</value>
        </criteriaItems>
        <description>MRR won by the SMB team, including upgrades</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Power Standing%3A SMB Net New Stores</fullName>
        <actions>
            <name>Opp_Won</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Purchased</value>
        </criteriaItems>
        <description>Count of net new Store opportunities won by the SMB team MRR won by the SMB team (no upgrades)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Professional Services Sale Notification</fullName>
        <actions>
            <name>Notification_of_new_oppty_for_Professional_Services</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.HasOpportunityLineItem</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Sale</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Notification to Billing when a professional services has the stage of Sale.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SBD Intuit Plus Plan</fullName>
        <actions>
            <name>SBD_Intuit_Plus_Plan_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send the SBD Intuit Plus Plan email to Plus Plan stores</description>
        <formula>(Referral_ID__c = &quot;welcome-quickbooks&quot; ||Referral_ID__c = &quot;quickbooks&quot;) &amp;&amp;
ISCHANGED( New_Product_Plan__c )  &amp;&amp;
New_Product_Plan__c = &quot;Plus Plan&quot; &amp;&amp;
 PurchaseDate__c  = today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SBD Intuit Standard Plan</fullName>
        <actions>
            <name>SBD_Intuit_Standard_Plan_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send the SBD Intuit Standard Plan email to Standard Plan stores</description>
        <formula>(Referral_ID__c = &quot;welcome-quickbooks&quot; ||Referral_ID__c = &quot;quickbooks&quot;) &amp;&amp;
ISCHANGED( New_Product_Plan__c )  &amp;&amp;
New_Product_Plan__c = &quot;Standard Plan&quot; &amp;&amp;
 PurchaseDate__c  = today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SBD Paypal Braintree Plus Plan Grow Bundle Store Setup Email</fullName>
        <actions>
            <name>Send_Grow_Bundle_Email_to_Client</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send the SBD Grow Bundle to Plus Plan stores</description>
        <formula>Referral_ID__c = &quot;welcome-paypal&quot; &amp;&amp;
ISCHANGED( New_Product_Plan__c )  &amp;&amp;
New_Product_Plan__c = &quot;Plus Plan&quot; &amp;&amp;
 PurchaseDate__c  = today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SBD Paypal Braintree Standard Launch Bundle Store Setup Email</fullName>
        <actions>
            <name>Send_Standard_Plan_Launch_Email_to_Client_SBD_Paypal_Braintree</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send the SBD Paypal Braintree Launch Bundle Email to Standard Plans</description>
        <formula>Referral_ID__c = &quot;welcome-paypal&quot; &amp;&amp;
ISCHANGED( New_Product_Plan__c )  &amp;&amp;
New_Product_Plan__c = &quot;Standard Plan&quot; &amp;&amp;
 PurchaseDate__c  = today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Executive Sponsorship Email</fullName>
        <actions>
            <name>Executive_Sponsorship</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to Executive Sponsor when executive sponsorship information is populated.</description>
        <formula>ISCHANGED ( Executive_Sponsorship__c ) &amp;&amp; Executive_Sponsorship__c &lt;&gt; &apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set App Approved Date</fullName>
        <actions>
            <name>Set_App_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the App Approved date when stage is set to approved</description>
        <formula>RecordTypeId = &quot;01213000000AVUj&quot; &amp;&amp;
ispickval(StageName, &quot;Approved&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set App Revshare Signed Date</fullName>
        <actions>
            <name>Set_Revshare_signed_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the App Revshare Signed date when stage is set to approved</description>
        <formula>RecordTypeId = &quot;01213000000AVUj&quot; &amp;&amp;
ispickval( App_Revshare__c , &quot;Signed&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Stage Change Date</fullName>
        <actions>
            <name>Last_Stage_Change_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Last Date  when stage changed</description>
        <formula>OR (ISCHANGED(StageName),ISNEW())
&amp;&amp; RecordType.Name = &apos;Trial&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update MBA Referral ID</fullName>
        <actions>
            <name>Opp_Referral_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Referral_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Updates MBA Referral ID of an Opportunity when an existing Contact is referred to a demo request by a partner.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Most Recent Store URL</fullName>
        <actions>
            <name>Most_Recent_Store_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.TemporaryStoreURL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Store Purchase</value>
        </criteriaItems>
        <description>Update store URL to most recent store purchased.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opp Owner when Closed Lost</fullName>
        <actions>
            <name>Owner_The_BigCommerce_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update the Opportunity owner to the bigcommerce team when the opportunity is closed lost</description>
        <formula>AND(
OR(
ISPICKVAL(StageName, &apos;Closed Lost&apos;),
ISPICKVAL(StageName, &apos;Trial Expired&apos;)
),
OwnerId  &lt;&gt; &apos;005a000000AsxTo&apos; /* The BigCommerce Team */
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Upgrade notification</fullName>
        <actions>
            <name>Email_Opp_Owner_of_Closed_Won_OpportunityWFR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Upgrade Store</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>Notify opportunity owner if an upgrade closes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>rvee__Assigned to Partner</fullName>
        <actions>
            <name>rvee__AssignedToPartnerModified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>rvee__AssignedToPartnerPending</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>rvee__AssignedToPartnerTimestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(rvpe__IsDealRegistration__c == false) &amp;&amp; (ISNEW() || ISCHANGED(rvpe__RVMember__c)) &amp;&amp; (rvpe__RVMember__c != null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>rvee__Deal Registration Approved</fullName>
        <actions>
            <name>Deal_Registration_Approved_Outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>(rvpe__IsDealRegistration__c == true)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>rvee__Notify RV Member</fullName>
        <actions>
            <name>rvee__NotifyRVMemberReset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Notify_Partner_Outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>(rvpe__NotifyRVMember__c == true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Demo_Requested</fullName>
        <assignedToType>owner</assignedToType>
        <description>A potential customer has requested a demo. Please reach out ASAP and close the task once it has been completed.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>**Demo Requested**</subject>
    </tasks>
</Workflow>
