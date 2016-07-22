<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_to_new_account_owner</fullName>
        <description>Email notification to new account owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_ownership_updateion</template>
    </alerts>
    <alerts>
        <fullName>Email_the_Account_Owner</fullName>
        <description>Email the Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Email_Template/Account_New_Trial</template>
    </alerts>
    <alerts>
        <fullName>New_Subscription_Added_to_Account</fullName>
        <description>New Subscription Added to Account</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Account_New_Subscription_Added</template>
    </alerts>
    <alerts>
        <fullName>Partner_Approved</fullName>
        <description>Partner Approved</description>
        <protected>false</protected>
        <recipients>
            <field>AppDeveloperContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/Partner_Approved</template>
    </alerts>
    <alerts>
        <fullName>Partner_Rejected</fullName>
        <description>Partner Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>AppDeveloperContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/Partner_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_App_Partner_Rev_Share_Reminder_Email</fullName>
        <description>Send App Partner Rev Share Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>AppDeveloperContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/Rev_Share_Reminder_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Owner_to_Simon</fullName>
        <field>OwnerId</field>
        <lookupValue>evan.smith@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account Owner to Simon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_to_Client</fullName>
        <field>Type</field>
        <literalValue>Client</literalValue>
        <name>Account Type to Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_to_Former_Client</fullName>
        <field>Type</field>
        <literalValue>Former Client</literalValue>
        <name>Account Type to Former Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_to_Prospect</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Account Type to Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Start_Date_Population</fullName>
        <field>Client_Start_Date__c</field>
        <formula>TODAY ()</formula>
        <name>Client Start Date Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hubspot_Client_Age</fullName>
        <field>Hubspot_Client_Age__c</field>
        <formula>Client_Age__c</formula>
        <name>Hubspot Client Age</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MaxSub_Store_URL_Update</fullName>
        <field>MaxSub_Store_URL__c</field>
        <formula>MaxSub_Subscription__r.StoreURL__c</formula>
        <name>MaxSub Store URL Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_MKT_Account_Owner_Team</fullName>
        <description>Populate MKT Account Owner Team</description>
        <field>MKT_Account_Owner_Team__c</field>
        <formula>Owner_Team__c</formula>
        <name>Populate MKT Account Owner Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_Survey_Contact_Email</fullName>
        <field>OLD_Survey_Contact_Email__c</field>
        <formula>OLD_Survey_Contact__r.Email</formula>
        <name>SS Survey Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_Survey_Rep_Link</fullName>
        <field>OLD_Survey_Link_Success_Squad__c</field>
        <formula>SSC__r.Survey_Link__c</formula>
        <name>SS Survey Rep Link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_Survey_Rep_Link_Acq</fullName>
        <field>OLD_Survey_Link_Success_Squad_Acq__c</field>
        <formula>SSC__r.Survey_Link_Acquisition__c</formula>
        <name>SS Survey Rep Link Acq</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Active_Trial_field</fullName>
        <description>Set the Account Active Trial field to equal the Active Trial (opp) field. Used because Hubspot can&apos;t read the account rollup summary and our Bedrock integration can&apos;t integrate to the account nor use the formula field we have on the opportunity</description>
        <field>Active_Trials__c</field>
        <formula>Active_Trials_Opp__c</formula>
        <name>Set Account Active Trial field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Status_to_Active</fullName>
        <description>Set Account Status from Onboarding to Active</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Set Account Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_BMP_Client</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BMP_Client</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set BMP Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PAR_TTFR</fullName>
        <description>Set the Partner</description>
        <field>PAR_TTFR__c</field>
        <formula>today() - Partner_Approved_Date__c</formula>
        <name>Set PAR: Time to First Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Partner_First_Revenue_Date</fullName>
        <field>PAR_First_Rev_Date__c</field>
        <formula>Today()</formula>
        <name>Set Partner First Revenue Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Total_Revenue_for_Partner_Onboarding</fullName>
        <description>Capture the Total Partner revenue at the end of the partner&apos;s onboarding lifecycle (90 days from first revenue)</description>
        <field>Onboarding_MRR__c</field>
        <formula>PAR_Total_Active_MRR__c</formula>
        <name>Set Total Revenue for Partner Onboarding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Date_Today</fullName>
        <field>OLD_Survey_Date__c</field>
        <formula>Today()</formula>
        <name>Survey Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Partner_Status_from_Onboarding</fullName>
        <description>Update Partner Status from &quot;Onboarding&quot; to &quot;Account&quot;</description>
        <field>Status__c</field>
        <literalValue>Account</literalValue>
        <name>Update Partner Status from Onboarding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Valid_Activity_By_Update</fullName>
        <field>Valid_Activity_By__c</field>
        <formula>OwnerId</formula>
        <name>Valid Activity By Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Valid_Activity_Date_Update</fullName>
        <field>Valid_Activity_Date__c</field>
        <formula>Today()</formula>
        <name>Valid Activity Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>iDev_Partner_Link_Population</fullName>
        <field>iDev_Partner_Link__c</field>
        <formula>&quot;www.bigcommerce.com/p/&quot;+TEXT(  iDev_Partner_ID__c  )+&quot;.html&quot;</formula>
        <name>iDev Partner Link Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>SQL_Created</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>https://powerstandings.insidesales.com/kpi/qualopp</endpointUrl>
        <fields>Id</fields>
        <fields>Qualifier__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>james.juarez@bigcommerce.com</integrationUser>
        <name>SQL Created</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Change to BMP Client</fullName>
        <actions>
            <name>Set_BMP_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Source__c</field>
            <operation>equals</operation>
            <value>BMP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>BMP Client</value>
        </criteriaItems>
        <description>Change to BMP Client recordtype</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Client Start Date Population</fullName>
        <actions>
            <name>Client_Start_Date_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Client_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Active_Stores_Opp__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Populates the account Client Start Date field if it was blank and a new store sub is added</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Hubspot Store URL</fullName>
        <actions>
            <name>MaxSub_Store_URL_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates a non-formula field for the MaxSub URl when MaxSub ischanged so Hubspot can use it in email templates</description>
        <formula>ISCHANGED( MaxSub_Subscription__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Trial Added to Account</fullName>
        <actions>
            <name>Email_the_Account_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Emails the Account owner if a new trial store is added</description>
        <formula>PRIORVALUE(  Active_Trials__c )  &lt; Active_Trials__c  &amp;&amp;
CONTAINS(Owner.Profile.Name, &quot;Sales Rep&quot;) &amp;&amp;
NOT(CONTAINS( Owner.Full_Name__c, &quot;Team&quot;)) &amp;&amp;
DATEVALUE(CreatedDate) &lt;&gt; TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Sales when Account Owner Changes</fullName>
        <actions>
            <name>Email_notification_to_new_account_owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Each time an account owner changes to a new Outbound or LDR, notify the new owner by email</description>
        <formula>ISCHANGED( OwnerId )&amp;&amp; (Owner.UserRole.Id==&apos;00E13000001OSnm&apos; ||Owner.UserRole.Id==&apos;00E13000001OSnc&apos; || Owner.UserRole.Id==&apos;00E13000001DGi1&apos;) &amp;&amp;
 Owner.ProfileId ==&apos;00e130000024OSc&apos;

 /*(Outbound Direct Sales, LDR)*/ &amp;&amp; ( $User.Id != Owner.Id )
&amp;&amp;  $User.Id != $Label.The_Bigcommerce_Team</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate MKT Account Owner Team</fullName>
        <actions>
            <name>Populate_MKT_Account_Owner_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate MKT Account Owner Team so Hubspot has the data</description>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Power Standing%3A SQL Created</fullName>
        <actions>
            <name>SQL_Created</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Qualifier__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Capture when the account qualifier field goes from null to a value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send App Partner Approved Email</fullName>
        <actions>
            <name>Partner_Approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Account_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sent_App_Partner_App_Approved_Email</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send App Partner Account Approved Email</description>
        <formula>RecordType.Id = &apos;012a0000001NOe1&apos; &amp;&amp;
ISPICKVAL(Type, &apos;Technology Partner&apos;) &amp;&amp;
ISPICKVAL( Status__c, &apos;Onboarding&apos;) &amp;&amp;
ISCHANGED(Status__c) &amp;&amp;
NOT( ISNULL( AppDeveloperContact__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send App Partner Decline Email</fullName>
        <actions>
            <name>Partner_Rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_App_Partner_App_Declined_Email</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send App Partner Account Declined Email</description>
        <formula>RecordType.Id = &apos;012a0000001NOe1&apos; &amp;&amp;
ISPICKVAL(Type, &apos;Technology Partner&apos;) &amp;&amp;
ISPICKVAL( Status__c, &apos;Declined&apos;) &amp;&amp;
ISCHANGED(Status__c) &amp;&amp;
NOT( ISNULL( AppDeveloperContact__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send App Rev Share Email</fullName>
        <actions>
            <name>Send_App_Partner_Rev_Share_Reminder_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends App Partners their Rev Share reminder email</description>
        <formula>ISCHANGED(App_Send_Rev_Share_Email__c) &amp;&amp; App_Send_Rev_Share_Email__c &lt;&gt;  PRIORVALUE(App_Send_Rev_Share_Email__c) &amp;&amp; NOT(ISBLANK(App_Send_Rev_Share_Email__c)) &amp;&amp; App_Send_Rev_Share_Email__c = Today()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Partner Account Onboarding Details</fullName>
        <actions>
            <name>Set_PAR_TTFR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Partner_First_Revenue_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Partner Account First Rev Details and time based workflow to set the revenue at 90 days.</description>
        <formula>PAR_Total_Active_MRR__c &gt; 0 &amp;&amp; 
(ISBLANK( PAR_First_Rev_Date__c ) || ISBLANK( Onboarding_MRR__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Total_Revenue_for_Partner_Onboarding</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Partner_Status_from_Onboarding</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Type %3D Client</fullName>
        <actions>
            <name>Account_Type_to_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Active_Stores_Opp__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Record Type,BMP Client</value>
        </criteriaItems>
        <description>Moves account Type to Client if the Active Store count is one or greater</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Type %3D Former Client</fullName>
        <actions>
            <name>Account_Type_to_Former_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Active_Stores_Opp__c</field>
            <operation>equals</operation>
            <value>,0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Record Type,BMP Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Active_Trials_Opp__c</field>
            <operation>lessThan</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Client</value>
        </criteriaItems>
        <description>If an account with previously active stores moves to zero active, account Type goes to Former Client</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Type %3D Prospect</fullName>
        <actions>
            <name>Account_Type_to_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>,Former Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Record Type,BMP Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Active_Trials_Opp__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>If an account with previously Former Client type gets Trials</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Active Trial</fullName>
        <actions>
            <name>Set_Account_Active_Trial_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set the Account Active Trial field to equal the Active Trial (opp) field. Used because Hubspot can&apos;t read the account rollup summary and our Bedrock integration can&apos;t integrate to the account nor use the formula field we have on the opportunity.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Valid Activity on  Account Owner Changes</fullName>
        <actions>
            <name>Valid_Activity_By_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Valid_Activity_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Valid Activity on  Account Owner Changes (to be used in 90 day rule)</description>
        <formula>OR (ISNEW() , ISCHANGED( OwnerId )) 
&amp;&amp; OwnerId != $Label.The_Bigcommerce_Team</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>iDev Partner Link Population</fullName>
        <actions>
            <name>iDev_Partner_Link_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.iDev_Partner_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>formulates the iDev link based on iDev ID</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Sent_App_Partner_App_Approved_Email</fullName>
        <assignedTo>miles.leymeister@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent App Partner App Approved Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_App_Partner_App_Declined_Email</fullName>
        <assignedTo>miles.leymeister@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent App Partner App Declined Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_App_Partner_App_Received_Email</fullName>
        <assignedTo>miles.leymeister@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent App Partner App Received Email</subject>
    </tasks>
</Workflow>
