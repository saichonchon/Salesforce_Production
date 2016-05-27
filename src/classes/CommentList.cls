public with sharing class CommentList{ 
    public boolean publicFilter {get; set;}
    public boolean privateFilter {get; set;}
    public boolean statusFilter {get; set;}
    private list<CaseCommentExt> myCommentItems;
    public Boolean showFullList {get; set;}
    public Boolean deletable {get; set;}
    public Boolean updateable {get; set;} 
    private String privateColor ='#990000';
    private String publicColor = '#0C5D2C';
    private String statusColor = '#0099CC';
    
   
    public CommentList(ApexPages.StandardController controller) {
        publicFilter = true;
        privateFilter = true;
        statusFilter = true;
        //myCommentItems = this.getCommentItems();
        if (ApexPages.currentPage().getParameters().get('showFullList') == 'true')
            showFullList = true;
        else
            showFullList = false;
            
        deletable = Schema.SObjectType.CaseComment.isDeletable();
        updateable = Schema.SObjectType.CaseComment.isUpdateable();
    }
    
    public String getTableHeight(){
        if (showFullList)
            return '';
        else
            return 'max-height: 1000px;';
    
    }

    public pageReference refreshPage(){
        return null;
    }
    
    public boolean getButtonSettings(){
        Comment_Buttons__c mc = Comment_Buttons__c.getInstance();
        system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'+mc.display__c);
        return mc.display__c;
    }
    
    public string getCaseId(){
        return System.currentPageReference().getParameters().get('id') ;
    }
    
    public list<CaseCommentExt> getFilteredCommentItems(){ 
        List<CaseCommentExt> cmtexts = new list<CaseCommentExt>();
        for (CaseCommentExt cmtext :  getCommentItems()){ //myCommentItems){
            if (cmtext.cmt != null){
                if (cmtext.cmt.IsPublished && publicFilter)
                    cmtexts.add(cmtext);
                else if (!cmtext.cmt.IsPublished && privateFilter)
                    cmtexts.add(cmtext);
            } else if (statusFilter)
                cmtexts.add(cmtext);
        }
        
        return cmtexts;
    }
    

    public list<CaseCommentExt> getCommentItems(){ 
        //builds list of extended comments for display
        
        List<CaseCommentExt> cmtexts = new list<CaseCommentExt>();
    
        List<CaseComment> cmts = [Select IsPublished,CreatedDate,CreatedById,CommentBody, id
            From CaseComment 
            Where ParentId = :System.currentPageReference().getParameters().get('id') 
            order by createddate DESC];
        
        Integer CmtTotal = cmts.size();
        Integer CmtCount = 0;
        
        for(CaseComment cmt : cmts){
            CaseCommentExt ccx = new CaseCommentExt ();
            ccx.cmt = cmt;
            if (cmt.IsPublished)
                ccx.color = publicColor;
            else
                ccx.color = privateColor;
            cmtexts.add(ccx);
         
        }
        
        if (cmtexts.size() > 0) {
            // gather attachments
            List<String> commentIds = new List<Id>();
            for(CaseComment cmt : cmts){
                commentIds.add(cmt.id);
            }
            Map<String, List<Attachment>> attchMap = new Map<String, List<Attachment>>();
            
            CaseCommentExt nearestComment;
            
            List<Attachment> attchList = [SELECT Id,Name,ParentId, CreatedDate FROM Attachment WHERE ParentId =: this.getCaseId() order by createddate DESC];
            
            Integer point = 0;
            Boolean x = false;
            for (Attachment attch : attchList){
                x = false;
                DateTime attchDate = attch.CreatedDate;
                while (point < cmtexts.size() && !x){
                    DateTime cmmntDate = cmtexts[point].createdDate();
                    if (withinRange(cmmntDate,attchDate)){
                        cmtexts[point].attch.add(attch);
                        x = true;
                    } else if (cmmntDate>attchDate){
                        point++;
                    }else{
                        x = true;
                    }
                }
            }
            /* for (Attachment attch : attchList){
               nearestComment = cmtexts.get(0);
               for (integer x = 1; x < cmtexts.size(); x++)
                   if (diffInTime(cmtexts[x].createdDate(),attch.CreatedDate) < diffInTime(nearestComment.createdDate(),attch.CreatedDate))
                       nearestComment = cmtexts[x];
               if (diffInTime(nearestComment.createdDate(),attch.CreatedDate) < 10000)
                   nearestComment.attch.add(attch);
            } */
            
            // gather email
            List<EmailMessage> emailList = [SELECT Id, HtmlBody, CreatedDate, Incoming FROM EmailMessage WHERE ParentId =: this.getCaseId() order by createddate DESC];
            System.debug(emailList);
            for (EmailMessage email : emailList){
                x = false;
                DateTime emailDate = email.CreatedDate;
                while (point < cmtexts.size() && !x){
                    DateTime cmmntDate = cmtexts[point].createdDate();
                    System.debug(point + ' ' + cmmntDate + ' ' + emailDate);
                    
                    if (withinRange(cmmntDate,emailDate)){
                        cmtexts[point].em = email;
                        System.debug('within range');
                        x = true;
                    } else if (cmmntDate>emailDate){
                        System.debug('point');
                        point++;
                    }else{
                        x = true;
                    }
                }
            }
            
           /* for (EmailMessage email : emailList){
               nearestComment = cmtexts.get(0);
               for (integer x = 1; x < cmtexts.size(); x++)
                   if (diffInTime(cmtexts[x].createdDate(),email.CreatedDate) < diffInTime(nearestComment.createdDate(),email.CreatedDate))
                       nearestComment = cmtexts[x];
               nearestComment.em = email;
            } */
        
        }
        
        // merge case history into timeline
        List<CaseHistory> cHistory = [SELECT NewValue,OldValue,Field,CreatedDate,CreatedById FROM CaseHistory WHERE CaseId =: this.getCaseId() AND (Field = 'Owner' OR Field = 'Status' OR Field = 'Priority') ORDER BY CreatedDate DESC NULLS FIRST];
        
        List<CaseCommentExt> cmtexts2 = new list<CaseCommentExt>();
        Integer pos = 0;
        for (CaseHistory cHis : cHistory){
            if (cHis.NewValue == null) continue;
            if (String.valueOf(cHis.NewValue).startsWith('005')) continue;
            if (String.valueOf(cHis.NewValue).startsWith('00G')) continue;
            CaseCommentExt ccx = new CaseCommentExt ();
            ccx.hstry = cHis;
            ccx.color = statusColor;
            
            while (pos < cmtexts.size() && cHis.CreatedDate < cmtexts[pos].cmt.CreatedDate){
                cmtexts2.add(cmtexts[pos++]);
            }
            cmtexts2.add(ccx);
        }
        
        while (pos < cmtexts.size()){
            cmtexts2.add(cmtexts[pos++]);
        }
        cmtexts = cmtexts2;
        
        Integer count = cmtexts.size();
        
        for (CaseCommentExt ccx : cmtexts)
            ccx.ord = count--;
        return cmtexts; 
    } 
    
    private Boolean withinRange(DateTime date1, DateTime date2){
        long diff = date1.getTime() - date2.getTime();
        
        if (diff < 0)
            diff *= -1;
        System.debug(diff);
        if (diff < (30 * 1000))
            return true;
        return false;
    }
    
    public String getNewPrivateComment(){
        PageReference nc = new PageReference('/' + CaseComment.sObjectType.getDescribe().getKeyPrefix() + '/e');
        nc.getParameters().put('parent_id', System.currentPageReference().getParameters().get('id'));
        nc.getParameters().put('retURL',System.currentPageReference().getParameters().get('id')); 
        nc.getParameters().put('inline','0');
        nc.setRedirect(true);

        return nc.getUrl();
    }
    public PageReference getPrivateComment2(){
        PageReference nc = new PageReference('/' + CaseComment.sObjectType.getDescribe().getKeyPrefix() + '/e');
        nc.getParameters().put('parent_id', System.currentPageReference().getParameters().get('id'));
        nc.getParameters().put('retURL',System.currentPageReference().getParameters().get('id')); 
        nc.getParameters().put('inline','0');
        nc.setRedirect(true);
        
        return nc;
    }
    
    
    public PageReference startWorking(){
        return new pagereference('/apex/CaseStartWorking?id=' + System.currentPageReference().getParameters().get('id'));
    }
    
    public string getStartWorkingURL(){
        return new pagereference('/apex/CaseStartWorking?id=' + System.currentPageReference().getParameters().get('id')).getUrl();
    }
    
   public PageReference getNewPublicCommentURL2(){
        //returns the full URL to E2CP new comment page, used by a page button oncomplete javascript event
        PageReference nc = new PageReference('/apex/E2CP__New_Comment');   
        //PageReference nc = Page.E2CP__New_Comment; 
        nc.getParameters().put('id', System.currentPageReference().getParameters().get('id'));
        nc.setRedirect(true);

        return nc;
    }


    public string getNewPublicCommentURL(){
        //returns the full URL to E2CP new comment page, used by a page button oncomplete javascript event
        PageReference nc = new PageReference('/apex/E2CP__New_Comment');   
        //PageReference nc = Page.E2CP__New_Comment; 
        nc.getParameters().put('id', System.currentPageReference().getParameters().get('id'));
        nc.setRedirect(true);

        return nc.getUrl();
    }
    
    public string getListURL(){
        //returns the full URL to the current comment list page
        PageReference nc = Page.Comment_List;   
        nc.getParameters().put('id', System.currentPageReference().getParameters().get('id'));
        nc.getParameters().put('showFullList', 'true');
        return nc.getUrl();
    }
            
    public class CaseCommentExt{
    //extension class for comments to add the ordinal and handle public/private toggling
    
        public CaseComment cmt {get;set;}
        public Integer ord {get;set;}
        public List<Attachment> attch {get; set;}
        public EmailMessage em {get; set;}
        public CaseHistory hstry {get; set;}
        public String color {get; set;}
        
        public CaseCommentExt(){
            cmt = null;
            ord = null;
            attch = new List<Attachment>();
            em = null;
            hstry = null;
        }
        
        public void togglePublic(){
            cmt.IsPublished = !cmt.IsPublished;
            update cmt;
        }
        
        //delete method here
        public void deleteComment() {
            delete cmt;
            //cmt = null;
        }
  
        public Datetime createdDate(){
            return cmt.CreatedDate;
        }
    
    }
    
    /*private long diffInTime(DateTime date1, DateTime date2){
        long diff = date1.getTime() - date2.getTime();
        
        if (diff < 0)
            diff *= -1;
        return diff;
    
    }*/
    
    static testMethod void testCommentlist(){
        
        //make test data
        Contact foo = new Contact(FirstName = 'Foo', LastName='Bar');
        
        insert foo;
        
        Case c = new Case(Subject = 'Test case', ContactId=foo.id);
        Insert c;
        
        CaseComment cmt1 = new CaseComment(
            ParentId = c.id,
            IsPublished = false,
            CommentBody = 'A private comment from a user.'
        );
        CaseComment cmt2 = new CaseComment(
            ParentId = c.id,
            IsPublished = true,
            CommentBody = 'Recipients: Foo Bar A public comment from a client.'
        );
        Insert cmt1;
        Insert cmt2;
        
        cmt2.IsPublished = true; 
        update cmt2;
        
        Attachment attch = new Attachment();
        attch.body = Blob.valueOf('Unit Test Attachment Body');
        attch.Name = 'test.txt';
        attch.ParentId = c.id;
        
        insert attch;
        
       
                
        //load page
        System.currentPageReference().getParameters().put('id', c.id);
        CommentList cl = new commentlist(new ApexPages.StandardController(c));
        List<CaseCommentExt> cmtItems = cl.getFilteredCommentItems();
        System.assert(cl.getCaseId() == c.id);
        
        System.assertEquals(true, cl.publicFilter);
        System.assertEquals(true, cl.privateFilter);
        System.assertEquals(true, cl.statusFilter);
        System.assertEquals(2, cmtItems.size());
        System.assertEquals('max-height: 1000px;', cl.getTableHeight());
        
        
        cl.publicFilter = false;
        cmtItems = cl.getFilteredCommentItems();
        System.assertEquals(1, cmtItems.size());
        System.assert(cmtItems[0].cmt.CommentBody == cmt1.CommentBody);
        System.assert(cmtItems[0].cmt.IsPublished == cmt1.IsPublished);
        
        cl.publicFilter = true;
        cl.privateFilter = false;
        cl.refreshPage();
        cmtItems = cl.getFilteredCommentItems();
        System.assertEquals(1, cmtItems.size());
        System.assert(cmtItems[0].cmt.CommentBody == cmt2.CommentBody);
        System.assert(cmtItems[0].cmt.IsPublished == cmt2.IsPublished);
        
        
     
        //check new page buttons
        System.assert(cl.getNewPrivateComment() != null);
        System.assert(cl.getNewPublicCommentURL() != null);
        System.assert(cl.getListURL() != null);
        
        //check public/private toggle
        cmtItems[0].togglePublic();
        CaseComment cmt1a = [Select IsPublished from CaseComment where id = :cmt1.id][0];
        System.assert(cmt1a.IsPublished = true);
        
        cl.getPrivateComment2();
        cl.getNewPublicCommentURL2();
        
    }
    
}