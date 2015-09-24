public class InvoiceLineItemCompCntrl {
    public id oliId {set;get;}
    Public List<Invoice_LineItem__c> invoiceLst; 
  public InvoiceLineItemCompCntrl()
  {
      invoiceLst = new List<Invoice_LineItem__c>();
      
  }
  
   public List<Invoice_LineItem__c>  getInvoiceLst()
  {
      opportunityLineItem oli = [select id,name,opportunity.name,OpportunityId,Product2.Name,LastModifiedBy.Name,Project__c from opportunityLineItem where id =:oliId];
     
      invoiceLst = [select id,name,TotalMonthlyCharge__c,Invoice_LineItemType__c,Invoice_PeriodEnd__c,Invoice_PeriodStart__c,Invoice_ScheduleDate__c,isDeleted__c,isLocked__c,OpportunityRef__c,ProjectRef__c,Wholesale_Fee__c,Media_Spend__c from Invoice_LineItem__c where OpportunityRef__c =:oli.OpportunityId  and ProjectRef__c =:oli.Project__c];
      
      return invoiceLst;
  }  
    
    
}