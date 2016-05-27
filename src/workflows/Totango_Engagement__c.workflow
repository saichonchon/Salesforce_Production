<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Initial_Totango_Score_Update</fullName>
        <field>Initial_Totango_Score__c</field>
        <formula>TotangoEngagement__c</formula>
        <name>Initial Totango Score Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Totango_Insights</fullName>
        <description>Updates the Totango_Insights__c field on the subscription with the value in the same field name from the Totango record each time it is changed</description>
        <field>Totango_Insights__c</field>
        <formula>TotangoInsights__c</formula>
        <name>Totango Insights</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Subscription__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Totango Insights</fullName>
        <actions>
            <name>Totango_Insights</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Totango Insight field in the Subscription Record</description>
        <formula>ISCHANGED( TotangoInsights__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
