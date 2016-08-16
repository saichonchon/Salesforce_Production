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
        <fullName>Closed_Lost_Reason_to_Duplicate</fullName>
        <field>Closed_Lost_Reason__c</field>
        <literalValue>Duplicate Record</literalValue>
        <name>Closed Lost Reason to Duplicate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Lead_Status_Unqualified</fullName>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>Lead Status = Unqualified</name>
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
        <fullName>No_Assign_True</fullName>
        <field>No_Assign__c</field>
        <literalValue>1</literalValue>
        <name>No Assign = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Rating_Hot</fullName>
        <field>Rating</field>
        <literalValue>Hot</literalValue>
        <name>Rating = Hot</name>
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
        <fullName>Demo Request Task - Lead</fullName>
        <actions>
            <name>Rating_Hot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Demo_Requested</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>When a Lead is added as a campaign member for a demo request, this date is set. Create a task for the Lead owner. 
For BAP-3811</description>
        <formula>AND(  
NOT(ISBLANK(Demo_Requested_Date__c)), 
OwnerId &lt;&gt; &apos;005a000000AsxTo&apos;, /* The BigCommerce Team */   
OR( 
Owner:User.Profile.Id = &apos;00e13000000jUNJ&apos;, /* Lead Development Rep */     
Owner:User.Profile.Id = &apos;00e130000024OSc&apos;, /* Sales Rep */     
Owner:User.Profile.Id = &apos;00e13000000jUyt&apos;, /* Sales Rep - Dial on Opps */     
Owner:User.Profile.Id = &apos;00e130000024OSX&apos; /* Sales Leader */  
)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Design Account Field Updates and Owner Email</fullName>
        <actions>
            <name>Owner_Lead_Referral_Notification</name>
            <type>Alert</type>
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
        <active>false</active>
        <description>When a lead is created with lead source &quot;Datanyze&quot;, it will copy the Datanyze fields from the Datanyze section to the native lead field:</description>
        <formula>ISPICKVAL(Lead_Source_Detail__c, &apos;Datanyze&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
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
            <value>SEM,Social Ads,Display,Print Ads,Email Advertising,Organic Search,Organic Social,Other,Deal Registration,Affiliate,Events,Inbound,Webinar List</value>
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
        <fullName>Update Owner When Unqualified</fullName>
        <actions>
            <name>Owner_Acquisition_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_ID__c</field>
            <operation>notEqual</operation>
            <value>00Ga00000044WHq</value>
        </criteriaItems>
        <description>Update the Lead Owner to Acquisition Queue when the Status is set to Unqualified.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
