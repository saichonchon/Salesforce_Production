trigger LeadShareTrigger on Lead (after insert, before update) {
	//------------------------------------------------------------------------------------
	//// Commented out on 5/22/2013 
	////	- No reason to set sharing on Leads
	//------------------------------------------------------------------------------------
	/*    
	    public string GROUPNAME = 'Partner Users';
	    public integer i = 0;
	    public list<Lead> leadlist = new list<lead>();
	    public list<Lead> toUpdateLeadList = new list<lead>();
	    public list<Id> toUpdateLeadIdList = new list<Id>();
	    public list<Id> toUpdateAccountIdList = new list<Id>();
	    public list<LeadShare> leadsharelist = new list<LeadShare>();
	    List<Lead> listLead = new List<Lead>();
	    
	    //public Group grpId = [Select Id,Name from GROUP where Name=:GROUPNAME];
	    //system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<GroupId>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+grpId.Id);
	    try {
		    List<Id> UserIdList = new List<Id>();
		    List<Id> OwnerIdList = new List<Id>();
		    
		    for(lead l : trigger.new) {
		        OwnerIdList.add(l.ownerId);
		    }
		    
		   if(trigger.isUpdate) {
		       
		       for(Lead l : Trigger.new) {
		            if(Trigger.old[i].Partner_Account__c != Trigger.new[i].Partner_Account__c) {
		            system.debug(Trigger.old[i].Partner_Account__c + '-------' + Trigger.new[i].Partner_Account__c);
		                toUpdateLeadIdList.add(l.id);
		                toUpdateAccountIdList.add(l.Partner_Account__c);
		            }
		            i++;
		       }
		       list<LeadShare> leadShareDeleteList = [select Id, leadId,UserOrGroupId from leadShare where LeadId in :toUpdateLeadIdList and UserOrGroupId not in :OwnerIdList];
		       if(leadShareDeleteList.size() > 0) {
		           delete leadShareDeleteList;
		       }     
		       listLead = [select id,Partner_Account__c from lead where id in :toUpdateLeadIdList];
		   }
		   else{
		       listLead = [select id,Partner_Account__c from lead where id in :Trigger.new];
		       for(Lead l : Trigger.new) {   
		                toUpdateLeadIdList.add(l.id);
		                toUpdateAccountIdList.add(l.Partner_Account__c);
		       }
		   }
		   List<Contact> contacts = [select id from contact where accountId in :toUpdateAccountIdList];
		   List<Id> contactIds = new List<Id>();
		   for(Contact con : contacts) {
		       contactIds.add(con.id);
		   }
		   List<user> PartnerList = [select id,accountId from user where contactId in :contactIds];
		   list<leadShare> llshr = [select id from leadShare where leadId in :trigger.newMap.keyset()];
		    // for (select Id, leadId from leadShare where LeadId in Trigger.newMap.getKeySet()];
		    // { Map(leadid, Id)
	    
            for(Lead newlead : Trigger.new) {
                //newlead = [Select id, Share__c from lead];
                // IF (Map.get(newLead.id) && newLead.Share__c == null { delete sharing rule} else if () { insert  }
                for(User u : PartnerList) {
                //system.debug(u.accountId + '<<<<<<<<<' + newlead.Partner_Account__c);
                if(u.accountId == newlead.Partner_Account__c) {
                    if(newlead.Partner_Account__c != null) {
                        LeadShare ldshare = new LeadShare();
                        ldshare.LeadAccessLevel = 'Edit';
                        ldshare.UserOrGroupId = u.Id;
                        //system.debug('Sharing rule created on lead with the user id as ['+u.id+']');
                        ldshare.LeadId = newlead.id;
                        leadsharelist.add(ldshare);
                        
                    }
                }
            }
            if(!leadsharelist.isEmpty()) {
                insert leadsharelist;
            }
        }
    }
    catch (Exception e) {}
    */
}