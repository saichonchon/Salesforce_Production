<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Webinar_Survey_Request</fullName>
        <description>Webinar Survey Request</description>
        <protected>false</protected>
        <recipients>
            <field>Registrant_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>hwong@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Survey_Templates/Webinar_Survey_General</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Status_to_Did_Not_Attend</fullName>
        <field>Status__c</field>
        <formula>&quot;Did Not Attend&quot;</formula>
        <name>Change Status to Did Not Attend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Sent_True</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Survey Sent = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Status to Did Not Attend</fullName>
        <actions>
            <name>Change_Status_to_Did_Not_Attend</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Webinar__c.Status__c</field>
            <operation>equals</operation>
            <value>Registered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Webinar__c.Date1__c</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Webinar__c.Date1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the webinar status if the webinar date is past and status is &quot;Registered&quot; since Bedrock only pushes an update for those who DO attend</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Webinar Survey Email</fullName>
        <actions>
            <name>Webinar_Survey_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Survey_Sent_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Webinar__c.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Webinar__c.Status__c</field>
            <operation>equals</operation>
            <value>Attended</value>
        </criteriaItems>
        <description>Send an email to the registrant once they have attended a webinar and check the Survey Sent field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
