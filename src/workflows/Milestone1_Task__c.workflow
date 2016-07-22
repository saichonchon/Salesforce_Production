<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_stage</fullName>
        <field>Task_Stage__c</field>
        <literalValue>Completed</literalValue>
        <name>Update stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Task_Complete_Email</fullName>
        <apiVersion>29.0</apiVersion>
        <description>A project task has been completed</description>
        <endpointUrl>https://na13.salesforce.com/00Oa00000086BCE</endpointUrl>
        <fields>Assigned_To__c</fields>
        <fields>CreatedDate</fields>
        <fields>Days_Late__c</fields>
        <fields>Description__c</fields>
        <fields>Due_Date__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>ProjectStatus__c</fields>
        <fields>Project_Milestone__c</fields>
        <fields>Project__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>maria.huemmer@bigcommerce.com</integrationUser>
        <name>Task Complete Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Complete stage when task complete</fullName>
        <actions>
            <name>Update_stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Task__c.Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set task stage to Complete when complete check box is selected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PM Milestone task notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Task__c.Complete__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends a notification when a new task is assigned via PM Milestones.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
