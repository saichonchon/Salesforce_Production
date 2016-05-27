<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_opportunity_owner_for_expiring_Enterprise_30day_trials</fullName>
        <description>Notify opportunity owner for expiring Enterprise 30day trials</description>
        <protected>false</protected>
        <recipients>
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Expiring_Enterprise_30day_trials</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_Opportunity_Promo_Date</fullName>
        <field>Promo_Given_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Populate Opportunity Promo Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Promo_Given_Date_to_Product_Created</fullName>
        <description>Set Promo Given Date to Promo Product Created Date</description>
        <field>Promo_Given_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Set Promo Given Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_Migration</fullName>
        <field>Is_Migration__c</field>
        <literalValue>1</literalValue>
        <name>Update Is Migration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Line_Description</fullName>
        <field>Description</field>
        <formula>Product2.Name</formula>
        <name>Update Line Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Migration Product check</fullName>
        <actions>
            <name>Update_Is_Migration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Family</field>
            <operation>contains</operation>
            <value>Migration</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Opportunity Promo Date</fullName>
        <actions>
            <name>Set_Promo_Given_Date_to_Product_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Family__c</field>
            <operation>equals</operation>
            <value>Promo</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Name</field>
            <operation>startsWith</operation>
            <value>Promo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Promo_Given_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Populate the promo date which indicates when a promotion was first applied to hthe store.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
