<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Quote_Fax_Value</fullName>
        <description>Set the Quote Fax value to the Account fax value</description>
        <field>Fax</field>
        <formula>Opportunity.Account.Fax</formula>
        <name>Set Quote Fax Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Quote Details</fullName>
        <actions>
            <name>Set_Quote_Fax_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Opportunity_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set Quote details o ncreate</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
