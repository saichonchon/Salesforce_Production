<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Demo_Request_Assigment_Notification</fullName>
        <description>Demo Request Assignment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Internal_Workflow_Communications_Sales/New_Demo_Request_Received</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Type_to_Reminder</fullName>
        <field>Type</field>
        <literalValue>Reminder</literalValue>
        <name>Change Type to Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_of_Month_Date_Population_Task</fullName>
        <field>First_of_Month__c</field>
        <formula>First_of_Month_Formula__c</formula>
        <name>First of Month Date Population : Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_of_Month_Date_Population_Task</fullName>
        <field>Last_of_Month__c</field>
        <formula>Last_of_Month_Formula__c</formula>
        <name>Last of Month Date Population : Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Meeting_Checkbox_to_True</fullName>
        <field>Meeting_Count__c</field>
        <literalValue>1</literalValue>
        <name>Meeting Checkbox to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Call_Result_Value</fullName>
        <description>Populate Call Result Value with value of the &quot;Call Results (Manual)&quot; field</description>
        <field>CallDisposition</field>
        <formula>TEXT(Call_Result_Manual__c)</formula>
        <name>Populate Call Result Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Call_Result_to_Correct_Contact</fullName>
        <description>Set Call Result MANUAL to Correct Contact</description>
        <field>Call_Result_Manual__c</field>
        <literalValue>Correct Contact</literalValue>
        <name>Set Call Result to Correct Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Short_Comment_Update</fullName>
        <field>Comments_short__c</field>
        <formula>Description</formula>
        <name>Short Comment Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Call_Outcome_to_EMail</fullName>
        <field>Call_Outcome__c</field>
        <literalValue>Email</literalValue>
        <name>Task Call Outcome to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Email</fullName>
        <field>Type</field>
        <literalValue>Email</literalValue>
        <name>Type = Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type_Text_Capture</fullName>
        <field>Task_Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Type Text Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>First of Month Date Population %3A Task</fullName>
        <actions>
            <name>First_of_Month_Date_Population_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Pushes the formula value to this date field to be used in other formulas</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last of Month Date Population %3A Task</fullName>
        <actions>
            <name>Last_of_Month_Date_Population_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Pushes the formula value to this date field to be used in other formulas</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Meeting Checkbox Update %3A Tasks</fullName>
        <actions>
            <name>Meeting_Checkbox_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Meeting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>Meeting,Correct Contact</value>
        </criteriaItems>
        <description>Can probably be deleted and replaced by a formula checkbox field now that those exist; Used to be used in reporting to designate meetings from regular calls</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Manual Call result to auto Call Result</fullName>
        <actions>
            <name>Populate_Call_Result_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Default</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.isdc_dialer_call_type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Call_Result_Manual__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Populate the Call Result (Manual) entry to the Call Result field when reps log a call manually</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Call Result on Manual Calls</fullName>
        <actions>
            <name>Set_Call_Result_to_Correct_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>BAP 896 - Set Call Result on manual rep calls so that they get credit for commission and ROE</description>
        <formula>ISBLANK(CallDisposition) &amp;&amp;  ISBLANK(TEXT(Call_Result_Manual__c)) &amp;&amp; ISBLANK( CallObject) &amp;&amp;  ISPICKVAL(Type, &quot;Call&quot;) &amp;&amp;  (CONTAINS(CreatedBy.Profile.Name, &apos;Sales Rep&apos;) || CONTAINS(CreatedBy.Profile.Name, &apos;Lead Development Rep&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Short Comment Update</fullName>
        <actions>
            <name>Short_Comment_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Task.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Description</field>
            <operation>notContain</operation>
            <value>Data provided by Yesware</value>
        </criteriaItems>
        <description>Needed to include comments in page layout related lists - full comments field isn&apos;t a column option, so this WFR copies them into a shorter text field to be used</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Email Type %3D Email Outcome</fullName>
        <actions>
            <name>Task_Call_Outcome_to_EMail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Task.Call_Outcome__c</field>
            <operation>notEqual</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Task_Type__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <description>Updates the call outcome field to Email for email tasks if edited by a PS member</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Type Field Capture</fullName>
        <actions>
            <name>Type_Text_Capture</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used in reports where the standard &quot;Type&quot; field is unavailable due to SF restriction</description>
        <formula>ISCHANGED( Type ) = TRUE || ISCHANGED( Subject ) = TRUE ||  CONTAINS(Subject,&quot;email&quot;) = TRUE || 
ISPICKVAL( Type, &quot;Call&quot;) || 
ISPICKVAL( Type, &quot;Meeting&quot;) || 
ISPICKVAL( Type, &quot;Chat&quot;) || 
ISPICKVAL( Type, &quot;Email&quot;) || 
ISPICKVAL( Type, &quot;Reminder&quot;) || 
ISPICKVAL( Type, &quot;Other&quot;) || 
ISPICKVAL( Type, &quot;Success Squad Sync&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
