/**
 * Trigger for Invoice Transactions
 * @author Steve O'Neal
 * @date   2016-07-06
 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
 */
trigger InvoiceTransactionTrigger on Invoice_Transaction__c (before insert, before update)
{

	// Add in an effective until date that is equal to the payment date + 1 month less than the payment term
	// The purpose of the field is to capture annual payment overlap
	if (Trigger.isBefore) {
    	if (trigger.isInsert || trigger.isUpdate)
    	{
    		for (Invoice_Transaction__c invTrans : trigger.new)
    		{
    			if (invTrans.Payment_Term__c == null || invTrans.Payment_Term__c < 1)
    			{
    				invTrans.Payment_Term__c = 1;
    			}

    			if (invTrans.Date_Paid__c != null)
    			{
    				try
    				{
		    			invTrans.Date_Payment_Effective_Until__c = invTrans.Date_Paid__c.addMonths(Integer.valueOf(invTrans.Payment_Term__c) - 1);
		    		}
		    		catch (Exception e)
		    		{
		    			invTrans.Date_Payment_Effective_Until__c = invTrans.Date_Paid__c;
		    		}
	    		}
    		}
    	}
	}
}