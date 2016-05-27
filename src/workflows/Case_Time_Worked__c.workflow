<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BC_Consulting_Case_Not_Returned_to_Queue</fullName>
        <description>BC Consulting Case Not Returned to Queue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>premiumservices@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Working_More_Than_1_Hour</template>
    </alerts>
    <alerts>
        <fullName>Client_Success_Case_Not_Returned_to_Queue</fullName>
        <description>Internal CS Manager Notification - Case Not Returned to Queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>adam.ferenzi@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>friedrich.stegmann@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.blahnik@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Templates/Case_Working_More_Than_1_Hour</template>
    </alerts>
    <fieldUpdates>
        <fullName>Stop_Time_Now</fullName>
        <field>Stop_Time__c</field>
        <formula>Now()</formula>
        <name>Stop Time = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CS Internal CS Manager Notification - CTW %3A Case Working %3E1hr</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case_Time_Worked__c.Stop_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Time_Worked__c.Start_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>support</value>
        </criteriaItems>
        <description>Sends an email to CS management if a case working time has been left open for an hour.  manager manually sets the stop time after that</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Client_Success_Case_Not_Returned_to_Queue</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case_Time_Worked__c.Start_Time__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Premium Account Services - Case Working %3E 1 hr</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case_Time_Worked__c.Stop_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Time_Worked__c.Start_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Premium Account Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>Premium Account Services Queue</value>
        </criteriaItems>
        <description>Sends an email to Case Owner if a case working time has been left open for an hour.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BC_Consulting_Case_Not_Returned_to_Queue</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case_Time_Worked__c.Start_Time__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
