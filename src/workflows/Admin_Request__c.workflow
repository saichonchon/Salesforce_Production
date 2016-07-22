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
</Workflow>
