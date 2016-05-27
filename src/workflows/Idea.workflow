<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Idea_Status_Change_Notification</fullName>
        <description>Idea Status Change Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Communities/Idea_Status_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_Idea_Comment_Notification</fullName>
        <description>New Idea Comment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Communities/Idea_Comment_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Idea_Status_to_New</fullName>
        <description>Set Idea Status to New</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Set Idea Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Idea Comment Notification</fullName>
        <actions>
            <name>New_Idea_Comment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies Idea Owner of new comment on the idea</description>
        <formula>ischanged(LastCommentDate) &amp;&amp; not(isnull(LastCommentDate))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Idea Status Notification</fullName>
        <actions>
            <name>Idea_Status_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies Idea Owner when Idea Status changes</description>
        <formula>ischanged( Status ) &amp;&amp; NOT(ISNULL(PRIORVALUE(Status) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Idea Status on Create</fullName>
        <actions>
            <name>Set_Idea_Status_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the Idea Status to &quot;New&quot; on Create</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
