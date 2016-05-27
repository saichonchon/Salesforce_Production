<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Portal_Notice_Email_to_Users</fullName>
        <ccEmails>team-bigcommerce-support@bigcommerce.com</ccEmails>
        <ccEmails>inbound@bigcommerce.com</ccEmails>
        <ccEmails>accountmanagement@bigcommerce.com</ccEmails>
        <ccEmails>bizapps@bigcommerce.com</ccEmails>
        <description>Portal Notice Email to Users</description>
        <protected>false</protected>
        <recipients>
            <recipient>steven.bennett@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Biz_Apps_Templates/Portal_Notice</template>
    </alerts>
    <rules>
        <fullName>Send Portal Notice Email</fullName>
        <actions>
            <name>Portal_Notice_Email_to_Users</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Send_Email__c) &amp;&amp; Active__c = true &amp;&amp; Send_Email__c = true &amp;&amp; PRIORVALUE(Send_Email__c) = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
