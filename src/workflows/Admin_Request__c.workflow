<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Admin_Request_Update</fullName>
        <description>Admin Request: Update Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Admin_Request_Updated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Completed_Date_Today</fullName>
        <field>Completion_Date__c</field>
        <formula>Today ()</formula>
        <name>Completed Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Completion_Date</fullName>
        <field>Completion_Date__c</field>
        <formula>Today()</formula>
        <name>Populate Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>zBiz Apps Request%3A Updated Email Notification</fullName>
        <actions>
            <name>Admin_Request_Update</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>sends Requestor/Owner an email when an admin request&apos;s SOps Note field is updated</description>
        <formula>ISCHANGED( Sales_Ops_Notes__c ) &amp;&amp;  RecordTypeId =&quot;012a0000001NQpT&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zPopulate Completion Date</fullName>
        <actions>
            <name>Populate_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Admin_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Admin_Request__c.Completion_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If admin request is moved to Completed and no date is entered, marks date as today</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
