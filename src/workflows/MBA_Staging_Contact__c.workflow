<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Remove_Primary</fullName>
        <field>Primary_MBA_Contact__c</field>
        <literalValue>0</literalValue>
        <name>Remove Primary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BMP Primary Contact</fullName>
        <actions>
            <name>Remove_Primary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MBA_Staging_Contact__c.Source__c</field>
            <operation>equals</operation>
            <value>BMP</value>
        </criteriaItems>
        <criteriaItems>
            <field>MBA_Staging_Contact__c.Type__c</field>
            <operation>notEqual</operation>
            <value>Primary Contact</value>
        </criteriaItems>
        <description>For BMP only the contact with Type of Primary needs to be set.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
