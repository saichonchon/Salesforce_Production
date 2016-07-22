<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Partner_Application_Submitted_CONTACT</fullName>
        <description>Partner Application Submitted CONTACT</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>appstore@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>App_Partner_Templates/Techology_Partner_Application_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Marketo_Sync_Update_Contact</fullName>
        <description>Mark record to be synced with Marketo.</description>
        <field>Sync_with_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Marketo Sync Update_Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Conversion_at_Hubspot</fullName>
        <field>Hubspot_Score_at_Conversion__c</field>
        <formula>Hubspot_Score__c</formula>
        <name>Populate Conversion at Hubspot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Owner_Phone</fullName>
        <field>Owner_Phone__c</field>
        <formula>Owner.Phone</formula>
        <name>Populate Owner Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Recorded_Product_Tour_Date</fullName>
        <field>Recorded_Product_Tour_Date__c</field>
        <formula>TODAY()</formula>
        <name>Populate Recorded Product Tour Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_2</fullName>
        <description>Copy Other Email Value to Email 2</description>
        <field>DaScoopComposer__Email_2__c</field>
        <formula>Other_Email__c</formula>
        <name>Update Email 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <flowActions>
        <fullName>Set_App_Developer_Contact</fullName>
        <flow>Populate_App_Developer_Contact_on_Account</flow>
        <flowInputs>
            <name>AccountID</name>
            <value>{!AccountId}</value>
        </flowInputs>
        <flowInputs>
            <name>ContactID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>Set App Developer Contact</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <rules>
        <fullName>Demo Request Task - Contact</fullName>
        <actions>
            <name>Demo_Requested</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>When a contact is added as a campaign member for a demo request, this date is set.  Create a task for the contact owner.
For BAP-3811</description>
        <formula>AND(  
NOT(ISBLANK(Demo_Requested_Date__c)),  
OR(
Owner.Profile.Id = &apos;00e13000000jUNJ&apos;, /* Lead Development Rep */     
Owner.Profile.Id = &apos;00e130000024OSc&apos;, /* Sales Rep */     
Owner.Profile.Id = &apos;00e13000000jUyt&apos;, /* Sales Rep - Dial on Opps */     
Owner.Profile.Id = &apos;00e130000024OSX&apos;) /* Sales Leader */ ,
Owner.Id != &apos;005a000000AsxToAAJ&apos; /* The BigCommerce Team */
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Owner Phone on Contact</fullName>
        <actions>
            <name>Populate_Owner_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures the owner phone number if the owner ever changes so that Hubspot can use it in email template signatures. Workflow is required because HS can&apos;t read formula fields.</description>
        <formula>ISCHANGED(OwnerId) ||  (OwnerId &lt;&gt; &quot;00530000004W020&quot; &amp;&amp; ISBLANK( Owner_Phone__c ) = TRUE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send App Partner Application Received Email</fullName>
        <actions>
            <name>Partner_Application_Submitted_CONTACT</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_App_Partner_App_Received_Email</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send the App Partner a notification that their application to become a partner has been received.</description>
        <formula>Account.RecordType.Id = &apos;012a0000001NOe1&apos;
&amp;&amp; ISPICKVAL (Account.Type, &apos;Technology Partner&apos;)
&amp;&amp;  ISPICKVAL (Account.Status__c , &apos;Pending&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set App Developer Contact</fullName>
        <actions>
            <name>Set_App_Developer_Contact</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <description>Sets the App Developer contact if a contact comes in and the contact doesn&apos;t exist.</description>
        <formula>ISBLANK( Account.AppDeveloperContact__c ) &amp;&amp; Account.RecordType.Id = &apos;012a0000001NOe1&apos; &amp;&amp;  ISPICKVAL(Account.Type, &apos;Technology Partner&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sync with Marketo _ Contact</fullName>
        <actions>
            <name>Marketo_Sync_Update_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Based on given criteria, Marketo will pick up record to be synced with Marketo. The Marketo team has stored filter to only sync records that have the Sync with Marketo checkbox checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Email 2</fullName>
        <actions>
            <name>Update_Email_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Email 2 field (Groove field) with the other email</description>
        <formula>ISCHANGED( Other_Email__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>App_Approved_Contact_Email_Sent</fullName>
        <assignedTo>miles.leymeister@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>App Approved Contact Email Sent</subject>
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
        <fullName>Send_App_Partner_App_Decline_Email_CONTACT</fullName>
        <assignedTo>miles.leymeister@bigcommerce.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Send App Partner App Decline Email CONTACT</subject>
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
