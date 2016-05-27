<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Internal_Article_Approval</fullName>
        <description>Internal Article Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Internal_Article_Approved_HTML</template>
    </alerts>
    <alerts>
        <fullName>Internal_Article_Rejection</fullName>
        <description>Internal Article Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Internal_Article_Rejected_HTML</template>
    </alerts>
    <alerts>
        <fullName>New_Internal_Article_Submission</fullName>
        <description>New Internal Article Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>KB_Article_Reviewers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Templates/Internal_Article_Approval_Submission_HTML</template>
    </alerts>
</Workflow>
