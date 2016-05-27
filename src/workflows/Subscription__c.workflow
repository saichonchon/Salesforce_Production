<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Cancellation_Notice_to_Owner</fullName>
        <description>Cancellation Notice to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Store_Cancellation_Email_Alert_to_Owner</template>
    </alerts>
    <alerts>
        <fullName>New_Subscription_Owner_Doesn_t_Match</fullName>
        <description>New Subscription : Owner Doesn&apos;t Match</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Email_Template/Sub_New_Added_NOT_OWNER</template>
    </alerts>
    <alerts>
        <fullName>SUB_Cancelled_sub_with_GMV_1k</fullName>
        <description>SUB: Cancelled sub with GMV &gt; 1k</description>
        <protected>false</protected>
        <recipients>
            <recipient>adam.ferenzi@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_System_Folder_DO_NOT_TOUCH/Cancelled_Subscription_with_GMV_1k</template>
    </alerts>
    <alerts>
        <fullName>Send_email_stating_new_Enterprise_Account_is_paid</fullName>
        <ccEmails>accountmanagement@bigcommerce.com</ccEmails>
        <description>Send email stating new Enterprise Account is paid</description>
        <protected>false</protected>
        <recipients>
            <recipient>maria.huemmer@bigcommerce.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>no-reply@bigcommerce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Subscription_Templates/Sub_New_Enterprise_Store1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Direct_Purchase_True</fullName>
        <field>Direct_Purchase__c</field>
        <literalValue>1</literalValue>
        <name>Direct Purchase = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Migration_True</fullName>
        <field>Migration__c</field>
        <literalValue>1</literalValue>
        <name>Migration = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Original_Plan_Name_Capture</fullName>
        <field>Original_Plan_Purchased__c</field>
        <formula>Product__c</formula>
        <name>Original Plan Name Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Original_Plan_Value_Capture</fullName>
        <field>Original_Plan_Value__c</field>
        <formula>MonthlyRecurringRevenue__c</formula>
        <name>Original Plan Value Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>alecia.wall@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_Susan</fullName>
        <field>OwnerId</field>
        <lookupValue>barbara.baeyens@bigcommerce.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner to Susan</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Plan_Change_Date_Today</fullName>
        <field>Plan_Change_Date__c</field>
        <formula>TODAY ()</formula>
        <name>Plan Change Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_1st_Plan_Change_Name</fullName>
        <field>X1st_Upgrade_Product_Name__c</field>
        <formula>Product__c</formula>
        <name>Populate 1st Upgrade Product Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_1st_Plan_Change_Value</fullName>
        <field>X1st_Upgrade_Product_Name__c</field>
        <formula>Product__c</formula>
        <name>Populate 1st Plan Change Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_2nd_Plan_Value</fullName>
        <field>X1st_Upgrade_Product_Value__c</field>
        <formula>MonthlyRecurringRevenue__c</formula>
        <name>Populate 1st Upgrade Product Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Hubspot_Conversion_Score</fullName>
        <field>Hubspot_Score_at_Conversion__c</field>
        <formula>Hubspot_Score__c</formula>
        <name>Populate Hubspot Conversion Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Hubspot_Score_at_Trial_Expirati</fullName>
        <field>Hubspot_Score_at_Trial_Expiration__c</field>
        <formula>Lead_Hubspot_Score__c</formula>
        <name>Populate Hubspot Score at Trial Expirati</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Initial_Totango_Score</fullName>
        <field>Initial_Totango_Score__c</field>
        <formula>Totango_Score__c</formula>
        <name>Populate Initial Totango Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Text_This_Months_Rev</fullName>
        <field>TEXT_This_Months_Rev__c</field>
        <formula>This_Month_s_Revenue__c</formula>
        <name>Populate Text This Months Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Totango_Score_at_Expiration</fullName>
        <field>Totango_Score_at_Expiration__c</field>
        <formula>Totango_Score__c</formula>
        <name>Populate Totango Score at Expiration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Purchase_Rep_Owner</fullName>
        <field>Purchase_Rep__c</field>
        <formula>Owner:User.Full_Name__c</formula>
        <name>Purchase Rep = Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Purchase_Team_Capture</fullName>
        <field>Purchase_Team__c</field>
        <formula>Owner:User.Department</formula>
        <name>Purchase Team Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sandbox_True</fullName>
        <field>Sandbox__c</field>
        <literalValue>1</literalValue>
        <name>Sandbox = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Start_Date_Purchase_Date</fullName>
        <field>StartDate__c</field>
        <formula>PurchaseDate__c</formula>
        <name>Start Date = Purchase Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Active</fullName>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Cancelled</fullName>
        <field>Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Email_Update_Contact</fullName>
        <field>Email__c</field>
        <formula>Contact__r.Email</formula>
        <name>Sub Email Update : Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Email_Update_Lead</fullName>
        <field>Email__c</field>
        <formula>Lead__r.Email</formula>
        <name>Sub Email Update : Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Phone_Update_Contact</fullName>
        <field>Phone__c</field>
        <formula>Contact__r.Phone</formula>
        <name>Sub Phone Update : Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Phone_Update_Lead</fullName>
        <field>Phone__c</field>
        <formula>Lead__r.Phone</formula>
        <name>Sub Phone Update : Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subscription_Copy_Store_URL_TEXT</fullName>
        <field>Store_URL_TEXT__c</field>
        <formula>StoreURL__c</formula>
        <name>Subscription Copy Store URL TEXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Testing_True</fullName>
        <field>Test_Store__c</field>
        <literalValue>1</literalValue>
        <name>Testing = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Most_Recent_Plan</fullName>
        <field>Previous_Product_Name__c</field>
        <formula>PRIORVALUE( Product__c )</formula>
        <name>Previous Upgrade Plan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Most_Recent_Plan_CHange_Date</fullName>
        <field>Previous_Upgrade_Date__c</field>
        <formula>TODAY()</formula>
        <name>Previous Upgrade Plan Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Most_Recent_Plan_Value</fullName>
        <field>Previous_Product_Value__c</field>
        <formula>PRIORVALUE( MonthlyRecurringRevenue__c )</formula>
        <name>Previous Upgrade Plan Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Referral_ID</fullName>
        <description>Update Referral Id to Globalpayments</description>
        <field>Referral_ID__c</field>
        <formula>&quot;Globalpayments&quot;</formula>
        <name>Update Referral ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Totango_Score_at_Conversion</fullName>
        <field>Totango_Score_at_Conversion__c</field>
        <formula>Totango_Score__c</formula>
        <name>Update Totango Score at Conversion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Was_Trial_True</fullName>
        <field>Was_Trial__c</field>
        <literalValue>1</literalValue>
        <name>Was Trial = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X1st_Plan_Change_Date</fullName>
        <field>X1st_Upgrade_Date__c</field>
        <formula>Today()</formula>
        <name>Populate 1st Upgrade Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1st Upgrade Fields</fullName>
        <actions>
            <name>Populate_1st_Plan_Change_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_2nd_Plan_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>X1st_Plan_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures product data the first time a sub&apos;s product value changes from one paid plan to another.  Used in upgrade dashboards</description>
        <formula>ISBLANK(X1st_Upgrade_Date__c) = TRUE
&amp;&amp; ISBLANK(Original_Plan_Purchased__c) = FALSE
&amp;&amp; ISCHANGED( Product__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cancelled Subscription with GMV %3E 1k</fullName>
        <actions>
            <name>SUB_Cancelled_sub_with_GMV_1k</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.GMV__c</field>
            <operation>greaterOrEqual</operation>
            <value>1000</value>
        </criteriaItems>
        <description>Workflow rule to handle actions when a subscription moves to a status of cancelled and has GMV greater than $1000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture Totango Score at Conversion</fullName>
        <actions>
            <name>Update_Totango_Score_at_Conversion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Product__c</field>
            <operation>contains</operation>
            <value>Plan</value>
        </criteriaItems>
        <description>Captured the Totango score of a sub if the product contains &quot;Plan&quot; and did not previously</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Direct Purchase Checkbox</fullName>
        <actions>
            <name>Direct_Purchase_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.IsTrial__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.BillingAmount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.ProductType__c</field>
            <operation>notEqual</operation>
            <value>Domain Name,SSL Certificate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>MBA Subscription</value>
        </criteriaItems>
        <description>Marks a sub as a direct purchase if it&apos;s created with a plan name and IsTrial = False</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Direct Purchase Start Date</fullName>
        <actions>
            <name>Start_Date_Purchase_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Direct_Purchase__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.StartDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.PurchaseDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates start date for direct purchases if it&apos;s not pushed from MBA.  ISSUE: This should probably live on the MBA Staging Sub if MBA is ever able to push the Direct Purchase value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email%2FPhone Field Updates %3A Contact</fullName>
        <actions>
            <name>Sub_Email_Update_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sub_Phone_Update_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates sub phone &amp; email field if the Contact value is changed.  Originally used for list views but is also the last resort for a case email notifications if the case doesn&apos;t have a web address, lead or contact associated</description>
        <formula>Contact__c &lt;&gt; NULL || ISCHANGED(Contact__c) = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email%2FPhone Field Updates %3A Lead</fullName>
        <actions>
            <name>Sub_Email_Update_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sub_Phone_Update_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates sub phone &amp; email field if the Lead value is changed.  Originally used for list views but is also the last resort for a case email notifications if the case doesn&apos;t have a web address, lead or contact associated</description>
        <formula>Lead__c &lt;&gt; NULL</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Heartland to Susan</fullName>
        <actions>
            <name>Owner_to_Susan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Agency__c</field>
            <operation>contains</operation>
            <value>Heartland</value>
        </criteriaItems>
        <description>Transfers sub owner to Susan if the agency is Heartand</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Migration Updates on Subs</fullName>
        <actions>
            <name>Migration_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Product__c</field>
            <operation>contains</operation>
            <value>migration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Migration__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Checks the Migration box if the product name ever contains &quot;Migration&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move This Months Rev to Text Field</fullName>
        <actions>
            <name>Populate_Text_This_Months_Rev</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.This_Month_s_Revenue__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Captures the value of the rev formula field into a text field so it can be used in other formulas.  Including the formula in other formulas was exceeding limits. ISSUE: Rounds the original value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Enterprise Store Notification</fullName>
        <actions>
            <name>Send_email_stating_new_Enterprise_Account_is_paid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification of a new Enterprise Store Sold</description>
        <formula>AND(
  OR(
    ProductID__c= &quot;126&quot;,  /*these are the enterprise IDs*/
    ProductID__c = &quot;127&quot;
    ),
  NOT( ISBLANK(PurchaseDate__c)),
  MonthlyRecurringRevenue__c  &gt; 0
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Trial %3A Sub Owner NOT Parent Owner</fullName>
        <actions>
            <name>New_Subscription_Owner_Doesn_t_Match</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Purchase_Team__c</field>
            <operation>contains</operation>
            <value>partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Parent_Owner_Team__c</field>
            <operation>notContain</operation>
            <value>partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.StartDate__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.StartDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Emails sub owner if owned by a Channel rep but the parent lead or account is owned by a Direct or Acq rep.  Reps are supposed to figure out ownership from there and align parent &amp; sub owners</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Original Plan Captures</fullName>
        <actions>
            <name>Original_Plan_Name_Capture</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Original_Plan_Value_Capture</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures the original paid plan of a store so that they can be used in comparison to future updates (captured in other update fields)</description>
        <formula>(ISCHANGED( Product__c ) &amp;&amp; 
ISBLANK( Original_Plan_Purchased__c ) = TRUE &amp;&amp; 
((CONTAINS(Product__c, &quot;Trial&quot;) = FALSE &amp;&amp; 
CONTAINS(Product__c, &quot;Migration&quot;) = FALSE &amp;&amp; 
CONTAINS(Product__c, &quot;Sandbox&quot;) = FALSE &amp;&amp; 
CONTAINS(Product__c, &quot;Free&quot;) = FALSE) 
|| Direct_Purchase__c = TRUE) 
) 
|| 
( DATEVALUE( CreatedDate ) = TODAY() &amp;&amp; 
ISBLANK( Original_Plan_Purchased__c ) = TRUE &amp;&amp; 
((CONTAINS(Product__c, &quot;Trial&quot;) = FALSE &amp;&amp; 
CONTAINS(Product__c, &quot;Migration&quot;) = FALSE &amp;&amp; 
CONTAINS(Product__c, &quot;Sandbox&quot;) = FALSE &amp;&amp; 
CONTAINS(Product__c, &quot;Free&quot;) = FALSE) 
|| Direct_Purchase__c = TRUE) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Owner Notification%3A Cancellation</fullName>
        <actions>
            <name>Cancellation_Notice_to_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Terminated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.MonthlyRecurringRevenue__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Purchase_Team__c</field>
            <operation>contains</operation>
            <value>Direct,Acquisition</value>
        </criteriaItems>
        <description>Emails Direct or Acq rep if a sub they own cancels or is terminated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Plan Change Date Capture</fullName>
        <actions>
            <name>Plan_Change_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Timestamps any time the product changes (after initial purchase) so that we can use this date to calculate this month&apos;s revenue</description>
        <formula>PRIORVALUE( Product__c ) &lt;&gt; NULL &amp;&amp; ISCHANGED( Product__c ) &amp;&amp; PRIORVALUE(Product__c) &lt;&gt; &quot;Big Commerce - Free Plan - ISC Migration - Server 1&quot; &amp;&amp; CONTAINS(Product__c,&quot;Plan&quot;) = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Hubspot Conversion Score</fullName>
        <actions>
            <name>Populate_Hubspot_Conversion_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.PurchaseDate__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Purchase_Team__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Captures the Hubspot score value at the time the sub product moves to a paid plan</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Hubspot Score at Trial Expiration</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.StartDate__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Product__c</field>
            <operation>equals</operation>
            <value>15 Day Free Trial</value>
        </criteriaItems>
        <description>Captures the Hubspot score value at the time the sub starts as a trial.  ISSUE: rule name does not fit filter criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Populate_Hubspot_Score_at_Trial_Expirati</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>16</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Initial Totango Score</fullName>
        <actions>
            <name>Populate_Initial_Totango_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Totango_Score__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Initial_Totango_Score__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Captures the Totango score value the very first time one comes through to the sub</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Totango Score at Expiration</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.StartDate__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Product__c</field>
            <operation>equals</operation>
            <value>15 Day Free Trial</value>
        </criteriaItems>
        <description>Time based WF triggered at trial start date which captures the Totango score after 16 days for 15 day trials</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Populate_Totango_Score_at_Expiration</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>16</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Previous Upgrade Fields</fullName>
        <actions>
            <name>Update_Most_Recent_Plan</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Most_Recent_Plan_CHange_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Most_Recent_Plan_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures the prior values of the store product and value when it changes for the 2nd + times.  Used in this month revenue calculation</description>
        <formula>NOT( ISBLANK(  X1st_Upgrade_Date__c )) &amp;&amp;  ISCHANGED(  Product__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Purchase Team %26 Rep</fullName>
        <actions>
            <name>Purchase_Rep_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Purchase_Team_Capture</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures the sub owner&apos;s name and team (Department field on user record) at first purchase.  Should not be changed unless someone else is to be paid on it as this is used to track the FIRST rep paid regardless of future ownership changes</description>
        <formula>(ISCHANGED( OwnerId ) = TRUE &amp;&amp; (MONTH(DATEVALUE( CreatedDate )) = MONTH(TODAY())))
||(MONTH(DATEVALUE( CreatedDate )) = MONTH(TODAY()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sandbox</fullName>
        <actions>
            <name>Sandbox_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Product__c</field>
            <operation>contains</operation>
            <value>sandbox</value>
        </criteriaItems>
        <description>Checks the Sandbox field if the product name ever contains &quot;Sandbox&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Subscription Copy Store URL TEXT</fullName>
        <actions>
            <name>Subscription_Copy_Store_URL_TEXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies store URL to text field to enable searching on create/edit</description>
        <formula>Store_URL_TEXT__c &lt;&gt; StoreURL__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Testing %3D True</fullName>
        <actions>
            <name>Testing_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.Email__c</field>
            <operation>contains</operation>
            <value>Kaiser.Khan,meggnotec,chris@bigcommerce.com,jordan.chen,hothchutden</value>
        </criteriaItems>
        <description>Checks the Testing box if the email address contains known testing offenders</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Was Trial</fullName>
        <actions>
            <name>Was_Trial_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subscription__c.IsTrial__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subscription__c.Was_Trial__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Updates to True if the sub ever has IsTrial = True to distinguish between upgrades and direct purchases after conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zAcquisition Queue%3A Product Change</fullName>
        <active>true</active>
        <description>Notifies Jason Svatek if the product name is changed. Indicates an upgrade or downgrade.
Maria: Shouldn&apos;t this never apply since paid stores can&apos;t be attached to leads, and queues can only own leads?</description>
        <formula>AND(
ISCHANGED( Product__c ),
Owner:Queue.Id  =  &quot;00Ga00000044WHq&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zEnterprise Downgrade</fullName>
        <active>true</active>
        <description>Workflow to handle actions when a subscription downgrades from an enterprise product. CREATED IDENTICAL WFR ON OPPORTUNITY PER BAP 1701</description>
        <formula>AND(   OR(     PRIORVALUE(ProductID__c) = &quot;59&quot;,     PRIORVALUE(ProductID__c) = &quot;104&quot;,     PRIORVALUE(ProductID__c) = &quot;68&quot;,     PRIORVALUE(ProductID__c) = &quot;58&quot;   ),   /*OR(*/     ProductID__c &lt;&gt; &quot;59&quot;,     ProductID__c &lt;&gt; &quot;104&quot;,     ProductID__c &lt;&gt; &quot;68&quot;,     ProductID__c &lt;&gt; &quot;58&quot;   /*)*/ )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
