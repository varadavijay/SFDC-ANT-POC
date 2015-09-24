public class OpportunityLineItemUSCPCancelController {
    
    public OpportunityLineItem oli{set;get;}
    public OpportunityLineItemUSCPCancelController(ApexPages.StandardController stdController) {
        
        oli = (OpportunityLineItem) stdController.getRecord();
        oli = [SELECT Id, Invoice_ServiceEndDate__c, Invoice_ServiceStartDate__c, 
                                           CancelType__c, Waiting_Status__c,
                                           Cancellation_Category__c, Cancellation_Reason__c,
                                           Invoice_CancelDate__c,Waiting_Status_Descr__c,Cancellation_Detail__c
                               FROM OpportunityLineItem
                                WHERE Id =: oli.Id];
   
    }
    
    public PageReference save()
    {
        PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+oli.id);
      try
        {
            String errMsg = 'Please select Cancellation Detail';
            if(oli.Cancellation_Reason__c != null && oli.Cancellation_Detail__c == null)
            {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errMsg));
              ref = null;  
            }
            else
            {
             update oli;   
            }  
        }
        catch(DmlException ex){
           System.debug('Update OLI exception details from OpportunityLineItemUSCPCancelController Controller >> ' + ex);
           if(ex.getDmlStatusCode(0) !=null && ex.getDmlFields(0) == null){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
           }
           ref = null;
        }
        
      return ref;  
    }
    Public PageREference cancel()
    {
        PageReference ref = new PageReference('/apex/OpportunityLineItemUSCP?id='+oli.id);  
      return ref;
    }
    
}