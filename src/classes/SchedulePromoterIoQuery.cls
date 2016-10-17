public class SchedulePromoterIoQuery implements Schedulable {
    public void execute(SchedulableContext SC) {
      BatchCreatePromoterIoFeedback BC = new BatchCreatePromoterIoFeedback();
      database.executeBatch(BC, 10);
   }
}