<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Case_Status_Pending_Acceptance</fullName>
        <field>Status</field>
        <literalValue>Pending Acceptance</literalValue>
        <name>Case: Case Status = Pending Acceptance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Email_Log_First_OCR_Response</fullName>
        <field>Email_Log__c</field>
        <formula>&quot;First OCR Response&quot;</formula>
        <name>Case: Email Log =+First OCR Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Email_Log_Second_OCR_Response</fullName>
        <field>Email_Log__c</field>
        <formula>Parent.Email_Log__c +&quot;; &quot;+&quot;Second OCR Response&quot;</formula>
        <name>Case: Email Log =+ Second OCR Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Issue_Resolved_blank</fullName>
        <field>Issue_Resolved__c</field>
        <name>Case: Issue Resolved? = blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_OCR_Resolution_update</fullName>
        <field>OCR_Resolution__c</field>
        <formula>MID( 
HtmlBody, 
FIND(&quot;&gt;Proposed Solution:&quot;, HtmlBody)+19,
FIND(&quot;Does this resolve your case?&quot;,HtmlBody)-(FIND(&quot;&gt;Proposed Solution:&quot;, HtmlBody)+19)
)</formula>
        <name>Case: OCR Resolution update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_Support_Queue2</fullName>
        <field>OwnerId</field>
        <lookupValue>Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner =  Support Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Open_Unsolved_Email_MSG</fullName>
        <field>Status</field>
        <literalValue>Open Unsolved</literalValue>
        <name>Case Status = Open Unsolved (Email MSG)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Open_Unsolved_Email_Messa</fullName>
        <description>Set Case Status to Open Unsolved when an email comes in</description>
        <field>Status</field>
        <literalValue>Open Unsolved</literalValue>
        <name>Case Status = Open Unsolved (Email Messa</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Reopened</fullName>
        <field>Status</field>
        <literalValue>Reopened</literalValue>
        <name>Case Status = Reopened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Department_API</fullName>
        <field>Department__c</field>
        <literalValue>API</literalValue>
        <name>Department = API</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Department_Legal_Abuse</fullName>
        <field>Department__c</field>
        <literalValue>Legal/Abuse</literalValue>
        <name>Department = Legal/Abuse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Do_Not_Send_Survey_EM</fullName>
        <field>Do_Not_Send_Survey__c</field>
        <literalValue>1</literalValue>
        <name>Do Not Send Survey-EM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Recd_Closed_Case_True</fullName>
        <field>Email_Recd_Closed_Case__c</field>
        <literalValue>1</literalValue>
        <name>Email Recd Closed Case = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Support_API_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Support_API</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner = Support - API Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_When_case_Status_Waiting_on_C</fullName>
        <description>When case Status = Waiting on Client, and a new email is received, set Status to Open Uns</description>
        <field>Status</field>
        <literalValue>Open Unsolved</literalValue>
        <name>Partner: When case Status = Waiting on C</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Client_Responded</fullName>
        <field>Status</field>
        <literalValue>Client Responded</literalValue>
        <name>Status = Client Responded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Response_Received</fullName>
        <description>Update status to response received</description>
        <field>Status</field>
        <literalValue>Response Received</literalValue>
        <name>Status = Response Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unread_Email_to_False</fullName>
        <description>Sets Unread Email field to false.</description>
        <field>Unread_Email__c</field>
        <literalValue>0</literalValue>
        <name>Unread Email to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unread_Email_to_True</fullName>
        <field>Unread_Email__c</field>
        <literalValue>1</literalValue>
        <name>Unread Email to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Response</fullName>
        <field>First_Response_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update First Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Resolution_Count</fullName>
        <description>BAP-3743. Update Resolution Count each time an OCR is sent</description>
        <field>Resolution_Count__c</field>
        <formula>IF(ISBLANK(Parent.Resolution_Count__c),1,Parent.Resolution_Count__c+1)</formula>
        <name>Update Resolution Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Open_Unsolved</fullName>
        <field>Status</field>
        <literalValue>Open Unsolved</literalValue>
        <name>Update Status to Open Unsolved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>App Store Emails%3A Open Unsolved</fullName>
        <actions>
            <name>Update_Status_to_Open_Unsolved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,Waiting on Client,Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Default Email to Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>App Store Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <description>Change Case status to Open Unsolved when an email is received</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Billing %3A Client Reply Received</fullName>
        <actions>
            <name>Status_Client_Responded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Billing,Cancellations</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <description>When case is specific status (waiting on client, on hold, pending acceptance) and new email is received, set status to Client Responded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A Open Unsolved</fullName>
        <actions>
            <name>Case_Status_Open_Unsolved_Email_MSG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting on Client,On Hold,Working,Pending Acceptance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>support@bigcommerce.com (closed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <description>Change status to Open Unsolved when an email is received</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS All%3A Reopen Case</fullName>
        <actions>
            <name>Case_Status_Reopened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND (6 or 7)</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>support@bigcommerce.com (closed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ClosedDate</field>
            <operation>lessOrEqual</operation>
            <value>LAST 7 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>notContain</operation>
            <value>nondeliverable,mailer-daemon@salesforce.com,mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Subject</field>
            <operation>notContain</operation>
            <value>loop protection</value>
        </criteriaItems>
        <description>If a case is closed and the client sends an email within 7 days of close date change the status to Reopened.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Owner Update to Support after First OCR</fullName>
        <actions>
            <name>Case_Owner_Support_Queue2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.HtmlBody</field>
            <operation>contains</operation>
            <value>OCR Closure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Issue_Resolved__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Auto-Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalated__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Tier_2_Request_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update after First OCR</fullName>
        <actions>
            <name>Case_Case_Status_Pending_Acceptance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Email_Log_First_OCR_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Issue_Resolved_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_OCR_Resolution_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Resolution_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.HtmlBody</field>
            <operation>contains</operation>
            <value>OCR Closure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Auto-Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Mig Specialist All%3A Open Unsolved</fullName>
        <actions>
            <name>Case_Status_Open_Unsolved_Email_Messa</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Withdrawn,Cancelled,Pending Acceptance,Waiting on Client,Closed,Scoping</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Migration Specialist</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>support@bigcommerce.com (closed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>mailer-daemon</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>email loop protection</value>
        </criteriaItems>
        <description>Change Case status to Open Unsolved when an email is received</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Partner Support%3A Response Received</fullName>
        <actions>
            <name>Status_Response_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>notContain</operation>
            <value>@bigcommerce.com,nondeliverable,mailer-daemon@salesforce.com,mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <description>Updates status to &quot;Response Received&quot; when status isn&apos;t closed and a new email comes in from customer.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Reopened Case</fullName>
        <actions>
            <name>Case_Status_Reopened</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unread_Email_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>notContain</operation>
            <value>@bigcommerce.com,nondeliverable,mailer-daemon@salesforce.com,mailer-daemon,postmaster</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New,Read</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Support,Premium Account Services</value>
        </criteriaItems>
        <description>Reopens Premium Account Services/Partner Support Case when an email has been sent regarding a case that is already closed. Related to BAP-2964/BAP-3175.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set First Response</fullName>
        <actions>
            <name>Update_First_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (ISNULL(Parent.First_Response_Date_Time__c) ,
  ISPICKVAL(Parent.Origin, &apos;Web&apos;), 
 Incoming  = false,
 CONTAINS( FromAddress , &apos;support@bigcommerce.com&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unread Email to False</fullName>
        <actions>
            <name>Unread_Email_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR (4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>contains</operation>
            <value>@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Call Scheduled,In Progress,Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Premium Account Services</value>
        </criteriaItems>
        <description>Unchecks unread email field when there is a new email sent from Bigcommerce. Requested by BC Consulting team for BAP-2953.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unread Email to True</fullName>
        <actions>
            <name>Unread_Email_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>notContain</operation>
            <value>@bigcommerce.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New,Read</value>
        </criteriaItems>
        <description>Checks unread email field when there is a new email that has not yet been read.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>When case Status %3D Waiting on Client%2C and a new email is received%2C set Status to Open Uns</fullName>
        <actions>
            <name>Partner_When_case_Status_Waiting_on_C</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,Waiting on Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Partner,Partner Email Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.TextBody</field>
            <operation>contains</operation>
            <value>ref</value>
        </criteriaItems>
        <description>When case Status = Waiting on Client, and a new email is received, set Status to Open Uns</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
