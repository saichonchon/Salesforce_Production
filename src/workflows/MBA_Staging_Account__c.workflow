<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Company_Name_Account_ID</fullName>
        <field>CompanyName__c</field>
        <formula>MBAAccountID__c</formula>
        <name>Company Name = Account ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Company Name Population</fullName>
        <actions>
            <name>Company_Name_Account_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MBA_Staging_Account__c.CompanyName__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If MBA Staging Account record comes in with no account name, WF populates it with the MBA ID</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
