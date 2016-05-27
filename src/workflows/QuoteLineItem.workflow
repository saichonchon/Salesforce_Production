<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_One_Time_Charge</fullName>
        <description>Set One Time Charge</description>
        <field>One_Time_Charge__c</field>
        <formula>IF(NOT(CONTAINS( Product2.Name, &apos;Plan&apos;)), UnitPrice  ,null)</formula>
        <name>Set One Time Charge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Recurring_Charge_Value</fullName>
        <description>Set Recurring Charge Value</description>
        <field>Recurring_charge__c</field>
        <formula>IF(CONTAINS( Product2.Name,&apos;Plan&apos;), UnitPrice, null)</formula>
        <name>Set Recurring Charge Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Quote Recurring and One Time Values</fullName>
        <actions>
            <name>Set_One_Time_Charge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Recurring_Charge_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Product_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set Quote Recurring and One Time Values</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
