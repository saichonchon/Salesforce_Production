<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Design_Partner_Lead_Referral_Notification</fullName>
        <description>Design Partner Lead Referral Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Referral_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Design_Partner_Lead_Notification</template>
    </alerts>
    <alerts>
        <fullName>Direct_Intl_Email_Sent</fullName>
        <description>Direct : Intl Email Sent</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Direct_Sales_Templates/Direct_International_Trial</template>
    </alerts>
    <alerts>
        <fullName>Email_Client_if_Bad_Phone_True</fullName>
        <description>Email Client if Bad Phone = True</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Direct_Sales_Templates/Direct_No_Phone_Number</template>
    </alerts>
    <alerts>
        <fullName>New_Lead_Created</fullName>
        <description>Lead: New Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>New_Trial_Old_Lead_Email_Owner</fullName>
        <description>New Trial Old Lead : Email Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Leads_New_Trial_Added_to_Old_Lead</template>
    </alerts>
    <alerts>
        <fullName>Notify_Rep_of_Lead_who_downloaded_Pinterest_eBook</fullName>
        <description>Notify Rep of Lead who downloaded Pinterest eBook</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Direct_Rep_Notification_for_Pinterest_eBook</template>
    </alerts>
    <alerts>
        <fullName>Notify_Rep_of_Lead_who_viewed_the_Product_Tour</fullName>
        <description>Notify Rep of Lead who viewed the Product Tour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Direct_Rep_Notification_for_Product_TOur</template>
    </alerts>
    <alerts>
        <fullName>Owner_Lead_Referral_Notification</fullName>
        <description>Owner Lead Referral Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Owner_Referral_Lead_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assignment_Method_Channel_Partner</fullName>
        <field>Lead_Assignment_Method__c</field>
        <literalValue>Channel Partner</literalValue>
        <name>Assignment Method : Channel Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assignment_Method_Chat</fullName>
        <field>Lead_Assignment_Method__c</field>
        <literalValue>Chat</literalValue>
        <name>Assignment Method : Chat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Date_of_Pinterest_eBook</fullName>
        <field>Pinterest_eBook_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Capture Date of Pinterest eBook</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Date_of_Recorded_Product_Tour</fullName>
        <field>Recorded_Product_Tour_Date__c</field>
        <formula>TODAY()</formula>
        <name>Capture Date of Recorded Product Tour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_owner_to_The_Bigcommerce_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>team@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change owner to The Bigcommerce Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Closed_Lost_Reason</fullName>
        <description>Clear the Closed Lost Reason</description>
        <field>Closed_Lost_Reason__c</field>
        <name>Clear Closed Lost Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Closed_Lost_Reason_Detail</fullName>
        <description>Clear Closed Lost Reason</description>
        <field>Functionality_Detail__c</field>
        <name>Clear Closed Lost Reason Detail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Lost_Reason_Testing</fullName>
        <field>Closed_Lost_Reason__c</field>
        <literalValue>Test Account</literalValue>
        <name>Closed Lost Reason : Test Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Lost_Reason_Trial_Expired</fullName>
        <field>Closed_Lost_Reason__c</field>
        <literalValue>Trial Expired</literalValue>
        <name>Closed Lost Reason : Trial Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Lost_Reason_to_Bad_Number_Email</fullName>
        <field>Closed_Lost_Reason__c</field>
        <literalValue>No Valid Phone/Email</literalValue>
        <name>Closed Lost Reason to Bad Number/Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Lost_Reason_to_Duplicate</fullName>
        <field>Closed_Lost_Reason__c</field>
        <literalValue>Duplicate Record</literalValue>
        <name>Closed Lost Reason to Duplicate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Lost_Stage</fullName>
        <field>Stage__c</field>
        <literalValue>Closed Lost</literalValue>
        <name>Closed Lost Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Engaged_True</fullName>
        <field>Engaged__c</field>
        <literalValue>1</literalValue>
        <name>Engaged = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hubspot_prem_lead_to_Acq_Miderp</fullName>
        <description>When a person completes and submits the Enterprise Form Submission, we want HubSpot to create a new Lead in SFDC and populate the lead with some Premium specific information. Additionally, we want the lead routed to Lead Owner = Acquisition Miderprise.</description>
        <field>OwnerId</field>
        <lookupValue>Acquisition_Miderprise</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Hubspot prem lead to Acq Miderp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Closed_Lost_Date_Populated</fullName>
        <field>Closed_Lost_Date__c</field>
        <formula>TODAY()</formula>
        <name>Lead Closed Lost Date Populated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_GSB</fullName>
        <field>OwnerId</field>
        <lookupValue>Marketing_GSB</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Owner = GSB Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_to_BCT</fullName>
        <field>OwnerId</field>
        <lookupValue>team@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Lead Owner to BCT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_to_Bryan_Foster</fullName>
        <field>OwnerId</field>
        <lookupValue>bryan.foster@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Lead Owner to Bryan Foster</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_RT_to_Client_Prospect</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_Prospect</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead RT to Client Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Record_Type_to_Sales</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Client_Prospect</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>zLead Record Type to Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source_Inbound</fullName>
        <description>Update Lead Source to Inbound</description>
        <field>LeadSource</field>
        <literalValue>Inbound</literalValue>
        <name>Lead Source = Inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source_to_Chat</fullName>
        <field>LeadSource</field>
        <literalValue>Chat</literalValue>
        <name>Lead Source to Chat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Unqualified</fullName>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>Lead Status = Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Type_to_Prospect</fullName>
        <field>Type__c</field>
        <literalValue>Prospect</literalValue>
        <name>Lead Type to Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketo_Sync_Update</fullName>
        <description>Mark record to be synced with Marketo</description>
        <field>Sync_with_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Marketo Sync Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Most_Recenet_Trial_URL_Population</fullName>
        <field>Most_Recent_Trial_URL__c</field>
        <formula>Most_Recent_Trial__r.StoreURL__c</formula>
        <name>Most Recenet Trial URL Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>No_Assign_True</fullName>
        <field>No_Assign__c</field>
        <literalValue>1</literalValue>
        <name>No Assign = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opt_out_of_Email</fullName>
        <description>Update Email Opt Out field to true.</description>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Opt out of Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_API</fullName>
        <field>OwnerId</field>
        <lookupValue>team@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner = API User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Acq_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Acquisition_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Acq Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Acquisition_Queue</fullName>
        <description>changed to queue</description>
        <field>OwnerId</field>
        <lookupValue>Acquisition_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Acquisition Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Dane_Koch</fullName>
        <description>This was assigning owner to Dane, he is no longer here so I have updated to TBT - 6-30-14- MH</description>
        <field>OwnerId</field>
        <lookupValue>team@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner = The Bigcommerce Team</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_Chat_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Chat_Queue_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to Chat Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Change_Date_Now</fullName>
        <field>Ownership_Change_Request_Date__c</field>
        <formula>NOW()</formula>
        <name>Ownership Change Date = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ownership_Change_Requestor_User</fullName>
        <field>Ownership_Change_Requestor__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Ownership Change Requestor = User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provisioning_Error_True</fullName>
        <field>Provisioning_Error__c</field>
        <literalValue>1</literalValue>
        <name>Provisioning Error = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Referral_Date_Capture</fullName>
        <field>Referral_Date__c</field>
        <formula>TODAY()</formula>
        <name>Referral Date Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Referral_Email_Update</fullName>
        <field>Referral_Email__c</field>
        <formula>Design_Account__r.Design_Referral_Email__c</formula>
        <name>Referral Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Referral_Form_URL_Update</fullName>
        <field>Referral_Form_URL__c</field>
        <formula>Design_Account__r.Referral_Form_URL__c</formula>
        <name>Referral Form URL Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Round_Robin_Assignment_Method</fullName>
        <field>Lead_Assignment_Method__c</field>
        <literalValue>Round Robin</literalValue>
        <name>Round Robin Assignment Method</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Do_Not_Call_to_True</fullName>
        <field>DoNotCall</field>
        <literalValue>1</literalValue>
        <name>Set Do Not Call to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_to_Existing_New_Trial</fullName>
        <field>Stage__c</field>
        <literalValue>Existing: New Trial</literalValue>
        <name>Stage to Existing: New Trial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_to_New</fullName>
        <field>Stage__c</field>
        <literalValue>New</literalValue>
        <name>Stage to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Testing_True</fullName>
        <field>Testing_Lead__c</field>
        <literalValue>1</literalValue>
        <name>Testing = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Dev_Testing</fullName>
        <field>Type__c</field>
        <literalValue>Designer/Dev Testing</literalValue>
        <name>Type = Dev Testing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Trial</fullName>
        <field>Type__c</field>
        <literalValue>Trial</literalValue>
        <name>Type = Trial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>US_Time_Zone_Alaskan</fullName>
        <field>US_Time_Zone__c</field>
        <literalValue>Alaskan</literalValue>
        <name>US Time Zone : Alaskan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>US_Time_Zone_Central</fullName>
        <field>US_Time_Zone__c</field>
        <literalValue>Central</literalValue>
        <name>US Time Zone : Central</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>US_Time_Zone_Eastern</fullName>
        <field>US_Time_Zone__c</field>
        <literalValue>Eastern</literalValue>
        <name>US Time Zone : Eastern</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>US_Time_Zone_Hawaiian</fullName>
        <field>US_Time_Zone__c</field>
        <literalValue>Hawaiian</literalValue>
        <name>US Time Zone : Hawaiian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>US_Time_Zone_Mountain</fullName>
        <field>US_Time_Zone__c</field>
        <literalValue>Mountain</literalValue>
        <name>US Time Zone : Mountain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>US_Time_Zone_Pacific</fullName>
        <field>US_Time_Zone__c</field>
        <literalValue>Pacific</literalValue>
        <name>US Time Zone : Pacific</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Datanyze_City_toAddress_City</fullName>
        <field>City</field>
        <formula>Left(Datanyze_City__c,40)</formula>
        <name>Update Datanyze City to Address City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Datanyze_Country_to_Address_Coun</fullName>
        <field>Country</field>
        <formula>Datanyze_Country__c</formula>
        <name>Update Datanyze Country to Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Datanyze_Emp_No_to_No_of_Emp</fullName>
        <field>NumberOfEmployees</field>
        <formula>value(Datanyze_Employee_No__c)</formula>
        <name>Update Datanyze Emp No. to  No. of Emp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Datanyze_State_to_Address_State</fullName>
        <field>State</field>
        <formula>Datanyze_State__c</formula>
        <name>Update Datanyze State to Address State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Datanyze_Street_to_Address_Street</fullName>
        <field>Street</field>
        <formula>Datanyze_Address__c</formula>
        <name>Update Datanyze Street to Address Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Datanyze_Zip_to_Address_Zip</fullName>
        <field>PostalCode</field>
        <formula>Datanyze_Zip__c</formula>
        <name>Update Datanyze Zip to Address Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_Phone</fullName>
        <field>Owner_Phone__c</field>
        <formula>Owner:User.Phone</formula>
        <name>Update Owner Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <field>rvpe__PartnerLeadAcceptance__c</field>
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
        <fullName>set_the_BA_Testing_Lead_field_to_true</fullName>
        <description>set the BA Testing Lead field to true</description>
        <field>Testing_Lead__c</field>
        <literalValue>1</literalValue>
        <name>set the BA Testing Lead field to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>usertesting_URL_to_API</fullName>
        <field>OwnerId</field>
        <lookupValue>api@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>usertesting URL to API</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Deal_Registration_Denied_Outbound</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://partners.bigcommerce.com/services/SFDC-DealRegistrationApproved.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>treehouse@bigcommerce.com</integrationUser>
        <name>Deal Registration Denied Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Notify_Partner_Outbound</fullName>
        <apiVersion>34.0</apiVersion>
        <endpointUrl>https://partners.bigcommerce.com/services/SFDC-LeadNotifyRVMember.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>treehouse@bigcommerce.com</integrationUser>
        <name>Notify Partner Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualified_Opp_KPI</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/qualopp</endpointUrl>
        <fields>Id</fields>
        <fields>OwnerId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>james.juarez@bigcommerce.com</integrationUser>
        <name>Qualified Opp KPI</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Assignment Method %3A Channel Partner</fullName>
        <actions>
            <name>Assignment_Method_Channel_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If MBA Partner ID is populated, change assignment method to Partner</description>
        <formula>DATEVALUE(CreatedDate) = TODAY() &amp;&amp; ISBLANK(MBA_Partner_ID__c ) = FALSE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Company %3D Trial New Entry</fullName>
        <actions>
            <name>Owner_API</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>equals</operation>
            <value>Trial New Entry</value>
        </criteriaItems>
        <description>Transfers leads with &quot;Trial New Entry&quot; as the company name to API User since that indicates that the MBA Staging Account &amp; Contact records did not sync to SF properly.  Lead needs contact data added and can then be assigned to a rep</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Design Account Field Updates and Owner Email</fullName>
        <actions>
            <name>Owner_Lead_Referral_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Referral_Date_Capture</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Referral_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Referral_Form_URL_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates if Design Account is populated, and Budget is greater than 1 or notes are filled out</description>
        <formula>ISBLANK( Design_Account__c) = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Direct%3A Email Client if Non English Speaking %3D True</fullName>
        <actions>
            <name>Direct_Intl_Email_Sent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Non_English_Speaking_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Non_English_Speaking__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_Team__c</field>
            <operation>contains</operation>
            <value>Direct</value>
        </criteriaItems>
        <description>If a direct rep checks the Non English Speaking field, email is sent to client and task logged for sent email. ISSUE = task creation cannot default activity Type to &quot;Email&quot;, so they are logged as calls</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Contains Kaiser%2EKhan%2Cmeggnotec</fullName>
        <actions>
            <name>Owner_API</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Testing_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Type_Dev_Testing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 4) OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>jordan.chen,chris.boulton,ron.howard,verification.testing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Full_Name__c</field>
            <operation>equals</operation>
            <value>Hoth Chut Deng</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>Kaiser.Khan,meggnotec</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>@bigcommerce.com</value>
        </criteriaItems>
        <description>If a lead comes in from a known tester (internal or client), the owner is moved to API, Test = True and type goes to Testing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email New Lead</fullName>
        <actions>
            <name>New_Lead_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Emails Partner &amp; Acq reps if a new lead is assigned to them.  Direct didn&apos;t want the alert as it junks up their in-box</description>
        <formula>RecordTypeId = &quot;012a0000001NQQK&quot; &amp;&amp;   (CONTAINS(Owner:User.UserRole.Name,&quot;Inbound&quot;) = FALSE  ||
CONTAINS(Owner:User.UserRole.Name,&quot;Outbound&quot;) = FALSE)
&amp;&amp; OwnerId &lt;&gt; &quot;00530000007EJEO&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Type %3A Provisioning Error</fullName>
        <actions>
            <name>Provisioning_Error_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Type__c</field>
            <operation>equals</operation>
            <value>Provision Failure</value>
        </criteriaItems>
        <description>Moves type to Provisioning Failure if the Provisioning Error box is checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Type %3A Testing</fullName>
        <actions>
            <name>Closed_Lost_Reason_Testing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Closed_Lost_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>No_Assign_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Testing_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Type__c</field>
            <operation>contains</operation>
            <value>Testing</value>
        </criteriaItems>
        <description>If the lead Type field is Testing, update Stage to Closed Lost &amp; reason to Test</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Type of Duplicate</fullName>
        <actions>
            <name>Closed_Lost_Reason_to_Duplicate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Status_Unqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Type__c</field>
            <operation>equals</operation>
            <value>Duplicate</value>
        </criteriaItems>
        <description>If the lead Type field is Duplicate, update Status to Unqualified &amp; reason to Duplicate Record</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Unqualified Date</fullName>
        <actions>
            <name>Lead_Closed_Lost_Date_Populated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified</value>
        </criteriaItems>
        <description>Populates when lead status moves to Unqualified</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move Datanyze Standard Lead Data to Lead Standard Fields</fullName>
        <actions>
            <name>Update_Datanyze_City_toAddress_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Datanyze_Country_to_Address_Coun</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Datanyze_State_to_Address_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Datanyze_Street_to_Address_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Datanyze_Zip_to_Address_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a lead is created with lead source &quot;Datanyze&quot;, it will copy the Datanyze fields from the Datanyze section to the native lead field:</description>
        <formula>ISPICKVAL(Lead_Source_Detail__c, &apos;Datanyze&apos;) &amp;&amp;
NOT(ISCHANGED( OwnerId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>No Assign %3D True</fullName>
        <actions>
            <name>No_Assign_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Trial_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.No_Assign__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
            <value>API User</value>
        </criteriaItems>
        <description>Makes No Assign = True so that the lead is not reassigned via round robin when a rep creates the lead or a new trial is added to an existing lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Owner Phone on Lead</fullName>
        <actions>
            <name>Update_Owner_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures the owner phone number if the owner ever changes so that Hubspot can use it in email template signatures.  Workflow is required because HS can&apos;t read formula fields.</description>
        <formula>ISCHANGED(OwnerId) || (OwnerId &lt;&gt; &quot;00530000004W020&quot; &amp;&amp; ISBLANK( Owner_Phone__c ) = TRUE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sync with Marketo</fullName>
        <actions>
            <name>Marketo_Sync_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 OR 7) AND 2 AND 3 AND 4 AND 5 AND 6 AND 8 AND 9 AND 10 AND 11) OR 12</booleanFilter>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web Trial,Web Form,Webinar,Hubspot,WebToLead,Netline,ACQ Hubspot Content,ACQ Hubspot Demo Request,PRE Hubspot Content,PRE Hubspot Demo Request,Internet Retailer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notContain</operation>
            <value>crapdata,@test,david.lewis+</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Bad_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>SEM,Social Ads,Display,Print Ads,Email Advertising,Organic Search,Organic Social,Other,Deal Registration,Affiliate,SBD,ACQ List Upload,Events,Inbound,Webinar List</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Is_Duplicate__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.FirstName</field>
            <operation>notEqual</operation>
            <value>test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LastName</field>
            <operation>notEqual</operation>
            <value>test</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Duplicate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Closed_Lost_Reason__c</field>
            <operation>contains</operation>
            <value>Timing</value>
        </criteriaItems>
        <description>Based on given criteria, Marketo will pick up record to be synced with Marketo. The Marketo team has stored filter to only sync records that have the Sync with Marketo checkbox checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>US Time Zone %3A Alaskan</fullName>
        <actions>
            <name>US_Time_Zone_Alaskan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>contains</operation>
            <value>AK,Alaska</value>
        </criteriaItems>
        <description>Based on the Lead&apos;s state value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Time Zone %3A Central</fullName>
        <actions>
            <name>US_Time_Zone_Central</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>equals</operation>
            <value>ND,SD,NE,KS,OK,TX,MN,IA,MO,AR,LA,WI,IL,TN,MS,AL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>contains</operation>
            <value>Arkansas,Illinois,Iowa,Louisiana,Minnesota,Mississippi,Missouri,Oklahoma,Wisconsin,Alabama,Kansas,Nebraska,North Dakota,South Dakota,Tennessee,Texas</value>
        </criteriaItems>
        <description>Based on the Lead&apos;s state value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Time Zone %3A Eastern</fullName>
        <actions>
            <name>US_Time_Zone_Eastern</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>equals</operation>
            <value>MI,IN,KY,TN,GA,FL,OH,WV,VA,NC,SC,PA,NY,VT,NH,ME,MA,RI,CT,NJ,DE,MD,DC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>contains</operation>
            <value>Connecticut,Delaware,Georgia,Maine,Maryland,Massachusetts,New Hampshire,New Jersey,New York,North Carolina,Ohio,Pennsylvania,Rhode Island,South Carolina,Vermont,Virginia,Washington,West Virginia,Florida,Indiana,Kentucky,Michigan,District of Columbia</value>
        </criteriaItems>
        <description>Based on the Lead&apos;s state value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Time Zone %3A Hawaiian</fullName>
        <actions>
            <name>US_Time_Zone_Hawaiian</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>contains</operation>
            <value>HI,Hawaii</value>
        </criteriaItems>
        <description>Based on the Lead&apos;s state value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Time Zone %3A Mountain</fullName>
        <actions>
            <name>US_Time_Zone_Mountain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>equals</operation>
            <value>MT,ID,WY,UT,CO,AZ,NM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>contains</operation>
            <value>Arizona,Colorado,Montana,New Mexico,Utah,Wyoming,Idaho</value>
        </criteriaItems>
        <description>Based on the Lead&apos;s state value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Time Zone %3A Pacific</fullName>
        <actions>
            <name>US_Time_Zone_Pacific</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>equals</operation>
            <value>WA,OR,NV,CA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.State</field>
            <operation>contains</operation>
            <value>California,Washington,Nevada,Oregon</value>
        </criteriaItems>
        <description>Based on the Lead&apos;s state value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status to Unqualified</fullName>
        <actions>
            <name>Lead_Status_Unqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update status to unqualified automatically if a rep enters an unqualified reason.</description>
        <formula>ISCHANGED(Closed_Lost_Reason__c) &amp;&amp; NOT(ISPICKVAL(Closed_Lost_Reason__c, &apos;&apos;)) &amp;&amp; NOT(ISPICKVAL(Status, &apos;Unqualified&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
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
        <fullName>rvee__Deal Registration Denied</fullName>
        <actions>
            <name>Deal_Registration_Denied_Outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>(rvpe__IsDealRegistration__c == true) &amp;&amp; (rvpe__DealRegistrationDenied__c == true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
    <rules>
        <fullName>zAcq ownership from Meg</fullName>
        <actions>
            <name>Ownership_Change_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Ownership_Change_Requestor_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Request_Ownership__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Meg A. Murphy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Experience__c</field>
            <operation>equals</operation>
            <value>Switching from a Competitor</value>
        </criteriaItems>
        <description>Changes ownership from Meg to the requestor when the lead has the experience of Switching from a Competitor</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zAssign Hubspot leads to The Bigcommerce Team when trial comes in</fullName>
        <actions>
            <name>Change_owner_to_The_Bigcommerce_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Hubspot</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Hubspot</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Active_Trials__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.MBA_Partner_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>We are currently creating leads (owned by Hubspot) for all content downloads. When a trial is associated with this lead, we want to change ownership to the Bigcommerce Team to allow our sales team to call out on the lead.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zChat Lead Owner to Queue</fullName>
        <actions>
            <name>Owner_to_Chat_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>equals</operation>
            <value>t.b.d.</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Hubspot</value>
        </criteriaItems>
        <description>change owner to Chat Queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>zGenerate task if Pinterest eBook is True</fullName>
        <actions>
            <name>Notify_Rep_of_Lead_who_downloaded_Pinterest_eBook</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Capture_Date_of_Pinterest_eBook</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Downloaded_Pinterest_eBook</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Pinterest_eBook__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_Team__c</field>
            <operation>contains</operation>
            <value>Direct</value>
        </criteriaItems>
        <description>With create a task for the lead owner when &quot;Pinterest eBook&quot; is checked off.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zGenerate task if Product Tour is Watched</fullName>
        <actions>
            <name>Notify_Rep_of_Lead_who_viewed_the_Product_Tour</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Capture_Date_of_Recorded_Product_Tour</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Watched_Recorded_Product_Tour</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Openend_Product_Tour_Recording__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_Team__c</field>
            <operation>contains</operation>
            <value>Direct</value>
        </criteriaItems>
        <description>With create a task for the lead owner when &quot;Opened Product Tour Recording&quot; is checked off.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zHubspot Store URL %3A Lead</fullName>
        <actions>
            <name>Most_Recenet_Trial_URL_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>so HS can use in emails</description>
        <formula>ISCHANGED( Most_Recent_Trial__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zLead Transfer to Bryan Foster%3A Hubspot</fullName>
        <actions>
            <name>Lead_Owner_to_Bryan_Foster</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>reassigns incoming leads from Hubspot to BFoss from Mitch</description>
        <formula>Campaign.Name = &quot;Hubspot Campaign&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>zLead%3ASet the BA Testing Lead field to true%2E</fullName>
        <actions>
            <name>set_the_BA_Testing_Lead_field_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>and(  ISPICKVAL( Closed_Lost_Reason__c ,&apos;4 Test Account&apos;), ISCHANGED(Closed_Lost_Reason__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zNew Trail Added to Lead</fullName>
        <actions>
            <name>New_Trial_Old_Lead_Email_Owner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends lead owner an email if a new trial is added to an old lead</description>
        <formula>PRIORVALUE( Active_Trials__c ) &lt; Active_Trials__c &amp;&amp;   $User.Id  &lt;&gt; &quot;005a0000007EvtM&quot; &amp;&amp;  OwnerId &lt;&gt; &quot;00530000004W020&quot; &amp;&amp; OwnerId &lt;&gt; &quot;00530000007EJEO&quot;  &amp;&amp;  
OwnerId &lt;&gt;  $Label.Lead_Default_Owner  &amp;&amp;
DATEVALUE( CreatedDate ) &lt;&gt; TODAY() &amp;&amp;  Trial_Start_Date__c = TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zPopulate Initial Hubspot Score</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Hubspot_Score__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Initial_Hubspot_Score__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Captures the Hubspot score value the very first time one comes through to the lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zRecord Type from Sales to Client Prospect</fullName>
        <actions>
            <name>Lead_RT_to_Client_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Type_Trial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.MBAAccountID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Prospect</value>
        </criteriaItems>
        <description>Updates the lead record type when a trial is added to a lead that previously did not have any MBA trial and data</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zStage to Closed Lost if Reason field Populated</fullName>
        <actions>
            <name>Closed_Lost_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Closed_Lost_Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If a rep fills in the Closed Lost Reason, stage will move to Closed Lost for them.  Created because Acq wanted field dependency but Direct didn&apos;t.  This lets Acq reps only focus on lost reason</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zStore Name Contains %22usertesting%22</fullName>
        <actions>
            <name>usertesting_URL_to_API</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Trial_Store_URL__c</field>
            <operation>contains</operation>
            <value>usertesting</value>
        </criteriaItems>
        <description>transfer to API User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zTransfer Lead to GSB Queue</fullName>
        <actions>
            <name>Lead_Owner_GSB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Marketing_Promotion__c</field>
            <operation>contains</operation>
            <value>GSB2013</value>
        </criteriaItems>
        <description>Transfers lead ownership to the GSB queue for marketing to monitor for the store giveaway promotion.  Can be deleted if Megan O&apos;Brien is finished with her reporting</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Bad_Phone_Number_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Bad Phone Number Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>Lead_Downloaded_Pinterest_eBook</fullName>
        <assignedToType>owner</assignedToType>
        <description>This lead has downloaded the Pinterest eBook and needs to be followed up on.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Lead Downloaded Pinterest eBook</subject>
    </tasks>
    <tasks>
        <fullName>Lead_Watched_Recorded_Product_Tour</fullName>
        <assignedToType>owner</assignedToType>
        <description>This lead has watched the product tour recording and needs to be followed up on.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Lead Watched Recorded Product Tour</subject>
    </tasks>
    <tasks>
        <fullName>Non_English_Speaking_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Non English Speaking Email Sent</subject>
    </tasks>
</Workflow>
