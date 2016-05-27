global class BatchUpdateLeadOwners implements Schedulable {
   global void execute(SchedulableContext sc) {
      UpdateLeadOwners b = new UpdateLeadOwners(); 
      database.executebatch(b);
   }
}