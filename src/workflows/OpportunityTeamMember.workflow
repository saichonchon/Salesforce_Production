<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_SE_when_Opportunity_is_assigned</fullName>
        <description>Email SE when Opportunity is assigned</description>
        <protected>false</protected>
        <recipients>
            <recipient>Pre-Sales Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Opp_Sales_Engineer_Assigned</template>
    </alerts>
    <rules>
        <fullName>Send Email to Assigned SE</fullName>
        <actions>
            <name>Email_SE_when_Opportunity_is_assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>Pre-Sales Consultant</value>
        </criteriaItems>
        <description>Send Notification email to SE when they are assigned an Opportunity to work on per BAP-2986.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
