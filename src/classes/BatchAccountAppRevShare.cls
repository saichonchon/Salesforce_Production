global class BatchAccountAppRevShare implements Schedulable {
   global void execute(SchedulableContext ctx) {

    AppRevShareAcctUpdate a = new AppRevShareAcctUpdate();
    database.executebatch(a);

   }   
}