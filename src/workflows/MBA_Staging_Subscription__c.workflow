<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>No_Start_or_Purchase_Date</fullName>
        <description>No Start or Purchase Date</description>
        <protected>false</protected>
        <recipients>
            <recipient>maggie.frederick@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maria.huemmer@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Sales_Ops_Notification_Start_Purchase_Dates</template>
    </alerts>
    <fieldUpdates>
        <fullName>Purchase_Date_Today</fullName>
        <field>PurchaseDate__c</field>
        <formula>TODAY()</formula>
        <name>Purchase Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EdaptIT_Partner_ID</fullName>
        <field>MBAPartnerID__c</field>
        <formula>Text(12252)</formula>
        <name>Set EdaptIT Partner ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Domain</fullName>
        <field>SubscriptionType__c</field>
        <literalValue>Domain Name</literalValue>
        <name>Type = Domain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Product Type to Domain</fullName>
        <actions>
            <name>Type_Domain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MBA_Staging_Subscription__c.Product__c</field>
            <operation>contains</operation>
            <value>domain</value>
        </criteriaItems>
        <criteriaItems>
            <field>MBA_Staging_Subscription__c.SubscriptionType__c</field>
            <operation>contains</operation>
            <value>Store,SSL</value>
        </criteriaItems>
        <description>Changes the staging sub field Subscription Type to Domain if the product name contains &quot;Domain&quot; since they come in from MBA as &quot;Store&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set EdaptIT Partner Account</fullName>
        <actions>
            <name>Set_EdaptIT_Partner_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MBA_Staging_Subscription__c.Referral_ID__c</field>
            <operation>equals</operation>
            <value>edaptit</value>
        </criteriaItems>
        <description>If a store has a Referral ID of edaptit, set the partner ID to 12252</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
